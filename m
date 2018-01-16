Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38047 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeAPHr4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 02:47:56 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v3 3/3] trace-cmd: Making stat to report when the stack tracer is ON
Date: Tue, 16 Jan 2018 09:47:44 +0200
Message-Id: <20180116074744.5522-4-vladislav.valtchev@gmail.com>
In-Reply-To: <20180116074744.5522-1-vladislav.valtchev@gmail.com>
References: <20180116074744.5522-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

trace-cmd stat is a handy way for users to see what tracing is currently going
on, but currently it does not say anything about the stack tracing. This patch
makes the command to show a message when the stack tracer is ON.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 trace-cmd.h   | 2 ++
 trace-stack.c | 6 ++++++
 trace-stat.c  | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/trace-cmd.h b/trace-cmd.h
index 6fd34d7..9704b2e 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -358,6 +358,8 @@ void tracecmd_free_hooks(struct hook_list *hooks);
 /* --- Hack! --- */
 int tracecmd_blk_hack(struct tracecmd_input *handle);
 
+/* --- Stack tracer functions --- */
+int tracecmd_stack_tracer_status(int *status);
 
 /* --- Debugging --- */
 struct kbuffer *tracecmd_record_kbuf(struct tracecmd_input *handle,
diff --git a/trace-stack.c b/trace-stack.c
index d55d994..0028ecc 100644
--- a/trace-stack.c
+++ b/trace-stack.c
@@ -107,6 +107,12 @@ static int read_proc(int *status)
 	return 1; /* full success */
 }
 
+/* Public wrapper of read_proc() */
+int tracecmd_stack_tracer_status(int *status)
+{
+	return read_proc(status);
+}
+
 /* NOTE: this implementation only accepts new_status in the range [0..9]. */
 static void change_stack_tracer_status(int new_status)
 {
diff --git a/trace-stat.c b/trace-stat.c
index fd16354..23d7dd4 100644
--- a/trace-stat.c
+++ b/trace-stat.c
@@ -893,6 +893,7 @@ void trace_stat (int argc, char **argv)
 {
 	struct buffer_instance *instance = &top_instance;
 	int topt = 0;
+	int status;
 	int c;
 
 	for (;;) {
@@ -928,5 +929,12 @@ void trace_stat (int argc, char **argv)
 		stat_instance(instance);
 	}
 
+	if (tracecmd_stack_tracer_status(&status) >= 0) {
+		if (status > 0)
+			printf("Stack tracing is enabled\n\n");
+	} else {
+		printf("Error reading stack tracer status\n\n");
+	}
+
 	exit(0);
 }
-- 
2.14.1
