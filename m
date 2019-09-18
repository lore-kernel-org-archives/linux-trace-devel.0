Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2786FC4CED0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080C421881
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4547121881
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 02:05:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iAPLW-0000qX-Et
        for linux-trace-devel@vger.kernel.org; Tue, 17 Sep 2019 22:05:30 -0400
Message-Id: <20190918020530.344889398@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 17 Sep 2019 22:03:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] trace-cmd: Move extract trace_clock into trace-input.c
References: <20190918020334.344561631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Move the extracting of the trace_clock logic into trace-input.c from
trace-util.c, and store it locally in the tracecmd_input handler. This will
allow us to remove the trace_clock logic from event_parse.c as it doesn't
belong there.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h |  3 ++-
 lib/trace-cmd/trace-input.c   | 33 +++++++++++++++++++++++++++++++--
 lib/trace-cmd/trace-util.c    | 27 ---------------------------
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 092bd896fb09..eb36a1f20c30 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -18,7 +18,6 @@
 #define TRACECMD_PTR2ERR(ptr)	((unisgned long)(ptr) & ~TRACECMD_ERR_MSK)
 
 void tracecmd_parse_cmdlines(struct tep_handle *pevent, char *file, int size);
-void tracecmd_parse_trace_clock(struct tep_handle *pevent, char *file, int size);
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
 void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
 
@@ -124,6 +123,8 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
 
+void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
+
 int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus);
 
 int tracecmd_buffer_instances(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8cceb31cefef..5533d42fd7c2 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -95,6 +95,7 @@ struct tracecmd_input {
 	char *			cpustats;
 	char *			uname;
 	char *			version;
+	char *			trace_clock;
 	struct input_buffer_instance	*buffers;
 	int			parsing_failures;
 
@@ -2571,6 +2572,33 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	return 0;
 }
 
+static void extract_trace_clock(struct tracecmd_input *handle, char *line)
+{
+	char *data;
+	char *clock;
+	char *next = NULL;
+
+	data = strtok_r(line, "[]", &next);
+	sscanf(data, "%ms", &clock);
+	/* TODO: report if it fails to allocate */
+	handle->trace_clock = clock;
+}
+
+void tracecmd_parse_trace_clock(struct tracecmd_input *handle,
+				char *file, int size __maybe_unused)
+{
+	char *line;
+	char *next = NULL;
+
+	line = strtok_r(file, " ", &next);
+	while (line) {
+		/* current trace_clock is shown as "[local]". */
+		if (*line == '[')
+			return extract_trace_clock(handle, line);
+		line = strtok_r(NULL, " ", &next);
+	}
+}
+
 static int read_and_parse_trace_clock(struct tracecmd_input *handle,
 							struct tep_handle *pevent)
 {
@@ -2580,7 +2608,7 @@ static int read_and_parse_trace_clock(struct tracecmd_input *handle,
 	if (read_data_and_size(handle, &trace_clock, &size) < 0)
 		return -1;
 	trace_clock[size] = 0;
-	tracecmd_parse_trace_clock(pevent, trace_clock, size);
+	tracecmd_parse_trace_clock(handle, trace_clock, size);
 	free(trace_clock);
 	return 0;
 }
@@ -2618,7 +2646,7 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 		if (read_and_parse_trace_clock(handle, pevent) < 0) {
 			char clock[] = "[local]";
 			warning("File has trace_clock bug, using local clock");
-			tracecmd_parse_trace_clock(pevent, clock, 8);
+			tracecmd_parse_trace_clock(handle, clock, 8);
 		}
 	}
 
@@ -3011,6 +3039,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->cpustats);
 	free(handle->cpu_data);
 	free(handle->uname);
+	free(handle->trace_clock);
 	close(handle->fd);
 
 	tracecmd_free_hooks(handle->hooks);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b08e377c61ba..38584c200fa1 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -70,33 +70,6 @@ void tracecmd_parse_cmdlines(struct tep_handle *pevent,
 	}
 }
 
-static void extract_trace_clock(struct tep_handle *pevent, char *line)
-{
-	char *data;
-	char *clock;
-	char *next = NULL;
-
-	data = strtok_r(line, "[]", &next);
-	sscanf(data, "%ms", &clock);
-	tep_register_trace_clock(pevent, clock);
-	free(clock);
-}
-
-void tracecmd_parse_trace_clock(struct tep_handle *pevent,
-				char *file, int size __maybe_unused)
-{
-	char *line;
-	char *next = NULL;
-
-	line = strtok_r(file, " ", &next);
-	while (line) {
-		/* current trace_clock is shown as "[local]". */
-		if (*line == '[')
-			return extract_trace_clock(pevent, line);
-		line = strtok_r(NULL, " ", &next);
-	}
-}
-
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
-- 
2.20.1


