Return-Path: <SRS0=4xj7=42=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AA2C18E5B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2F724655
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgCITF3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 15:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbgCITF2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 15:05:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E397E24654
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Mar 2020 19:05:27 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jBNiQ-0033Bc-Rg
        for linux-trace-devel@vger.kernel.org; Mon, 09 Mar 2020 15:05:26 -0400
Message-Id: <20200309190526.741063088@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 09 Mar 2020 15:04:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Its DEFAULT_INPUT_FILE not DEFAUT_INPUT_FILE
References: <20200309190449.207021960@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Fix the typo in the DEFAULT_INPUT_FILE macro name.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h | 2 +-
 tracecmd/trace-dump.c          | 2 +-
 tracecmd/trace-hist.c          | 2 +-
 tracecmd/trace-mem.c           | 2 +-
 tracecmd/trace-read.c          | 2 +-
 tracecmd/trace-record.c        | 2 +-
 tracecmd/trace-restore.c       | 2 +-
 tracecmd/trace-split.c         | 2 +-
 tracecmd/trace-tsync.c         | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 49c52b1762b6..5ef569f03553 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -14,7 +14,7 @@
 
 #define TRACE_AGENT_DEFAULT_PORT	823
 
-#define DEFAUT_INPUT_FILE	"trace.dat"
+#define DEFAULT_INPUT_FILE	"trace.dat"
 #define GUEST_PIPE_NAME		"trace-pipe-cpu"
 #define GUEST_DIR_FMT		"/var/lib/trace-cmd/virt/%s"
 #define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index ffb1c6b17fff..5642f12a55ed 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -723,7 +723,7 @@ void trace_dump(int argc, char **argv)
 	}
 
 	if (!input_file)
-		input_file = DEFAUT_INPUT_FILE;
+		input_file = DEFAULT_INPUT_FILE;
 
 	if (!verbosity && !validate)
 		verbosity = SUMMARY;
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index fdfd4a1976d0..c458c25e2aa5 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -1037,7 +1037,7 @@ void trace_hist(int argc, char **argv)
 	}
 
 	if (!input_file)
-		input_file = DEFAUT_INPUT_FILE;
+		input_file = DEFAULT_INPUT_FILE;
 
 	handle = tracecmd_alloc(input_file);
 	if (!handle)
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 5caeeb6cf86d..465b1823345d 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -548,7 +548,7 @@ void trace_mem(int argc, char **argv)
 	}
 
 	if (!input_file)
-		input_file = DEFAUT_INPUT_FILE;
+		input_file = DEFAULT_INPUT_FILE;
 
 	handle = tracecmd_alloc(input_file);
 	if (!handle)
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c184c6273316..c1f840d560f2 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -74,7 +74,7 @@ struct pid_list *comm_list;
 
 static unsigned int page_size;
 static int input_fd;
-static const char *default_input_file = DEFAUT_INPUT_FILE;
+static const char *default_input_file = DEFAULT_INPUT_FILE;
 static const char *input_file;
 static int multi_inputs;
 static int max_file_size;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c8c853f80d11..280dc9ddf23a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -69,7 +69,7 @@ static int rt_prio;
 
 static int keep;
 
-static const char *output_file = DEFAUT_INPUT_FILE;
+static const char *output_file = DEFAULT_INPUT_FILE;
 
 static int latency;
 static int sleep_time = 1000;
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index e3b86dd2085c..d6134acf2588 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -25,7 +25,7 @@
 void trace_restore (int argc, char **argv)
 {
 	struct tracecmd_output *handle;
-	const char *output_file = DEFAUT_INPUT_FILE;
+	const char *output_file = DEFAULT_INPUT_FILE;
 	const char *output = NULL;
 	const char *input = NULL;
 	const char *tracing_dir = NULL;
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index b4d0df32217c..bb2c3d5346b3 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -23,7 +23,7 @@
 #include "trace-local.h"
 
 static unsigned int page_size;
-static const char *default_input_file = DEFAUT_INPUT_FILE;
+static const char *default_input_file = DEFAULT_INPUT_FILE;
 static const char *input_file;
 
 enum split_types {
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index bf65e441a93e..eab2fda5b120 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -139,7 +139,7 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 	if (ret < 0 || !count || !ts || !offsets)
 		return;
 
-	file = trace_get_guest_file(DEFAUT_INPUT_FILE,
+	file = trace_get_guest_file(DEFAULT_INPUT_FILE,
 				tracefs_instance_get_name(instance->tracefs));
 	fd = open(file, O_RDWR);
 	if (fd < 0)
-- 
2.25.0


