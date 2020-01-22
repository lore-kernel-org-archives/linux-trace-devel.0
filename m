Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABF6C33CAF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDFEC2467E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAVRYM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:24:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgAVRYM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:24:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8817024673
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 17:24:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1iuJje-000hxa-EH
        for linux-trace-devel@vger.kernel.org; Wed, 22 Jan 2020 12:24:10 -0500
Message-Id: <20200122172410.322761876@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 22 Jan 2020 12:22:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/5] trace-cmd: Place "trace.dat" into the macro DEFAULT_INPUT_FILE
References: <20200122172247.539894616@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The trace-cmd commands default the input/output file as "trace.dat". Instead
of using the open coded string, make a macro to use instead.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h | 1 +
 tracecmd/trace-dump.c          | 3 +--
 tracecmd/trace-hist.c          | 2 +-
 tracecmd/trace-mem.c           | 2 +-
 tracecmd/trace-read.c          | 2 +-
 tracecmd/trace-record.c        | 2 +-
 tracecmd/trace-restore.c       | 2 +-
 tracecmd/trace-split.c         | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 0658115c2a6a..44f1e62a779a 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -14,6 +14,7 @@
 
 #define TRACE_AGENT_DEFAULT_PORT	823
 
+#define DEFAUT_INPUT_FILE	"trace.dat"
 #define GUEST_PIPE_NAME		"trace-pipe-cpu"
 #define GUEST_DIR_FMT		"/var/lib/trace-cmd/virt/%s"
 #define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index ed6705886e39..415e913872f1 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -13,7 +13,6 @@
 
 #include "trace-local.h"
 
-#define DEF_INPUT_FILE	"trace.dat"
 #define TRACING_STR	"tracing"
 #define HEAD_PAGE_STR	"header_page"
 #define HEAD_PAGE_EVENT	"header_event"
@@ -602,7 +601,7 @@ void trace_dump(int argc, char **argv)
 	}
 
 	if (!input_file)
-		input_file = DEF_INPUT_FILE;
+		input_file = DEFAUT_INPUT_FILE;
 
 	if (!verbosity && !validate)
 		verbosity = SUMMARY;
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 384a7ff09306..c45182679b8f 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -1037,7 +1037,7 @@ void trace_hist(int argc, char **argv)
 	}
 
 	if (!input_file)
-		input_file = "trace.dat";
+		input_file = DEFAUT_INPUT_FILE;
 
 	handle = tracecmd_alloc(input_file);
 	if (!handle)
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 078a61bc702a..37046fd8310b 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -548,7 +548,7 @@ void trace_mem(int argc, char **argv)
 	}
 
 	if (!input_file)
-		input_file = "trace.dat";
+		input_file = DEFAUT_INPUT_FILE;
 
 	handle = tracecmd_alloc(input_file);
 	if (!handle)
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c0d640d3515b..8c2b2ae39f5e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -74,7 +74,7 @@ struct pid_list *comm_list;
 
 static unsigned int page_size;
 static int input_fd;
-static const char *default_input_file = "trace.dat";
+static const char *default_input_file = DEFAUT_INPUT_FILE;
 static const char *input_file;
 static int multi_inputs;
 static int max_file_size;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 80b223414246..b0860bbf5a0a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -68,7 +68,7 @@ static int rt_prio;
 
 static int keep;
 
-static const char *output_file = "trace.dat";
+static const char *output_file = DEFAUT_INPUT_FILE;
 
 static int latency;
 static int sleep_time = 1000;
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index b649cf4d2962..e3b86dd2085c 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -25,7 +25,7 @@
 void trace_restore (int argc, char **argv)
 {
 	struct tracecmd_output *handle;
-	const char *output_file = "trace.dat";
+	const char *output_file = DEFAUT_INPUT_FILE;
 	const char *output = NULL;
 	const char *input = NULL;
 	const char *tracing_dir = NULL;
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 6c8a774e13d0..b4d0df32217c 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -23,7 +23,7 @@
 #include "trace-local.h"
 
 static unsigned int page_size;
-static const char *default_input_file = "trace.dat";
+static const char *default_input_file = DEFAUT_INPUT_FILE;
 static const char *input_file;
 
 enum split_types {
-- 
2.24.1


