Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A762C54EBD
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 18:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbjAFSjl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 13:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235587AbjAFSjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 13:39:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495DD7D9FE
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 10:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6FFAB81E56
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C52C4339E;
        Fri,  6 Jan 2023 18:39:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDrcp-0003LE-0P;
        Fri, 06 Jan 2023 13:39:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 08/10] trace-cmd library: Return the result of tracefs_cpu_stop()
Date:   Fri,  6 Jan 2023 13:39:28 -0500
Message-Id: <20230106183930.12565-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230106183930.12565-1-rostedt@goodmis.org>
References: <20230106183930.12565-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Ideally, tracefs_cpu_stop() is suppose to return zero if it guaranteed to
stop the recorders (but this may not be true if called from a signal
handler). Return the result of tracefs_cpu_stop() in
tracecmd_stop_recording().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 +-
 lib/trace-cmd/trace-recorder.c                    | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index e8b0989ac67e..05c084ceea41 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -377,7 +377,7 @@ struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance, int maxkb);
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
-void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
+int tracecmd_stop_recording(struct tracecmd_recorder *recorder);
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder, bool finish);
 
 enum tracecmd_msg_flags {
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index db159e5e5d14..23499f308156 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -102,9 +102,9 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 	free(recorder);
 }
 
-static void set_nonblock(struct tracecmd_recorder *recorder)
+static int set_nonblock(struct tracecmd_recorder *recorder)
 {
-	tracefs_cpu_stop(recorder->tcpu);
+	return tracefs_cpu_stop(recorder->tcpu);
 }
 
 static struct tracecmd_recorder *
@@ -437,12 +437,12 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 	return 0;
 }
 
-void tracecmd_stop_recording(struct tracecmd_recorder *recorder)
+int tracecmd_stop_recording(struct tracecmd_recorder *recorder)
 {
 	if (!recorder)
-		return;
-
-	set_nonblock(recorder);
+		return -1;
 
 	recorder->stop = 1;
+
+	return set_nonblock(recorder);
 }
-- 
2.35.1

