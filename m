Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEED9C6379F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjAFSjl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbjAFSjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9517D9E3
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F101FB81E57
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33800C4339C;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003LM-0X;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 10/10] trace-cmd record: Keep stopping the recording when finished
Date:   Fri,  6 Jan 2023 13:39:30 -0500
Message-Id: <20230106183930.12565-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracecmd_stop_recording() is suppose to force the recorders to finish,
but because it is called from a signal handler, that may not necessarily be
the case (due to race conditions and such). Set an alarm to try again in a
second, then after two seconds, and then three, and so on.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b3614b0706de..7f0cebe8cd7a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3164,11 +3164,21 @@ static void expand_event_list(void)
 
 static void finish(void)
 {
+	static int secs = 1;
+
 	sleep_time = 0;
 
 	/* all done */
-	if (recorder)
+	if (recorder) {
 		tracecmd_stop_recording(recorder);
+		/*
+		 * We could just call the alarm if the above returned non zero,
+		 * as zero is suppose to guarantee that the reader woke up.
+		 * But as this is called from a signal handler, that may not
+		 * necessarily be the case.
+		 */
+		alarm(secs++);
+	}
 	finished = 1;
 }
 
@@ -3181,6 +3191,7 @@ static void flush(void)
 static void do_sig(int sig)
 {
 	switch (sig) {
+	case SIGALRM:
 	case SIGUSR1:
 	case SIGINT:
 		return finish();
@@ -3432,6 +3443,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		signal(SIGINT, SIG_IGN);
 		signal(SIGUSR1, do_sig);
 		signal(SIGUSR2, do_sig);
+		signal(SIGALRM, do_sig);
 
 		if (rt_prio)
 			set_prio(rt_prio);
-- 
2.35.1

