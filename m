Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B2CC3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D6A9208C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390851AbfITPKI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389665AbfITPKH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:10:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 808D32086A;
        Fri, 20 Sep 2019 15:10:06 +0000 (UTC)
Date:   Fri, 20 Sep 2019 11:10:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/5 v2] trace-cmd: Move extract trace_clock into
 trace-input.c
Message-ID: <20190920111005.45ba39a6@gandalf.local.home>
In-Reply-To: <CACqStofGsn5mTaT=+K1VSxPeHcfow5NHk3Jo54QBiwYA=79uAQ@mail.gmail.com>
References: <20190918020334.344561631@goodmis.org>
        <20190918020530.344889398@goodmis.org>
        <CACqStofGsn5mTaT=+K1VSxPeHcfow5NHk3Jo54QBiwYA=79uAQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
Changes since v1:

 - Initialized clock to NULL in case scanf failed (Tzvetomir Stoyanov)

 include/trace-cmd/trace-cmd.h |  3 ++-
 lib/trace-cmd/trace-input.c   | 33 +++++++++++++++++++++++++++++++--
 lib/trace-cmd/trace-util.c    | 27 ---------------------------
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7a9fbc5f..2d4c6e8f 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -18,7 +18,6 @@
 #define TRACECMD_PTR2ERR(ptr)	((unisgned long)(ptr) & ~TRACECMD_ERR_MSK)
 
 void tracecmd_parse_cmdlines(struct tep_handle *pevent, char *file, int size);
-void tracecmd_parse_trace_clock(struct tep_handle *pevent, char *file, int size);
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
 void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
 
@@ -127,6 +126,8 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
 
+void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
+
 int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus);
 
 int tracecmd_buffer_instances(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8cceb31c..f469118a 100644
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
+	char *clock = NULL;
+	char *next = NULL;
+	char *data;
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
index c153e4b7..8aa3b6cd 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -73,33 +73,6 @@ void tracecmd_parse_cmdlines(struct tep_handle *pevent,
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

