Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51092C61DB3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbjAFSjf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjAFSje (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282CD7DE0B
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95C0D61F1C
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B052C433F0;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrco-0003Km-3A;
        Fri, 06 Jan 2023 13:39:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 01/10] trace-cmd library: Set recorder to nonblock when finished
Date:   Fri,  6 Jan 2023 13:39:21 -0500
Message-Id: <20230106183930.12565-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the recorder is signaled to stop, make sure it only reads in
non-blocking mode.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-recorder.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index f387091f5177..bb02f7b8ee11 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -317,11 +317,12 @@ static inline void update_fd(struct tracecmd_recorder *recorder, int size)
  */
 static long read_data(struct tracecmd_recorder *recorder)
 {
+	bool nonblock = recorder->stop;
 	char buf[recorder->subbuf_size];
 	long left;
 	long r, w;
 
-	r = tracefs_cpu_read(recorder->tcpu, buf, false);
+	r = tracefs_cpu_read(recorder->tcpu, buf, nonblock);
 
 	left = r;
 	do {
@@ -344,11 +345,13 @@ static long read_data(struct tracecmd_recorder *recorder)
  */
 static long direct_splice_data(struct tracecmd_recorder *recorder)
 {
-	return tracefs_cpu_pipe(recorder->tcpu, recorder->fd, false);
+	bool nonblock = recorder->stop;
+	return tracefs_cpu_pipe(recorder->tcpu, recorder->fd, nonblock);
 }
 
 static long move_data(struct tracecmd_recorder *recorder)
 {
+	bool nonblock = recorder->stop;
 	long ret;
 
 	if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
@@ -357,7 +360,7 @@ static long move_data(struct tracecmd_recorder *recorder)
 	if (recorder->flags & TRACECMD_RECORD_NOBRASS)
 		return direct_splice_data(recorder);
 
-	ret = tracefs_cpu_write(recorder->tcpu, recorder->fd, false);
+	ret = tracefs_cpu_write(recorder->tcpu, recorder->fd, nonblock);
 	if (ret > 0)
 		update_fd(recorder, ret);
 	return ret;
-- 
2.35.1

