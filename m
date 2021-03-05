Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49759C433E6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EE36509E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhCEW7v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhCEW7t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4568E6509E;
        Fri,  5 Mar 2021 22:59:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJQC-0020BR-8a; Fri, 05 Mar 2021 17:59:48 -0500
Message-ID: <20210305225948.143320048@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:52:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 6/9 v2] trace-cmd: Have tracecmd_read_headers() specify the state to read up
 to
References: <20210305225223.794554327@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As trace-cmd restore needs to read only a portion of the headers, it needs a
way to not read all of them. Export the tracecmd_file_state enums and pass
that as another parameter to tracecmd_read_headers(), in which it will stop
at the state requested.

If zero is passed in as the state, tracecmd_read_headers() will act in its
old behavior and read everything it can.

Now trace-cmd restore can call tracecmd_read_headers() and have it stop
after it reads the cmdlines.

Link: https://lore.kernel.org/linux-trace-devel/CAPpZLN5fdY+rb6s=X6bNykiqrjuTprvZxay9iDSEQxJXHURh3A@mail.gmail.com/

Suggested-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  7 +-
 lib/trace-cmd/trace-input.c                   | 71 +++++++++++++++++--
 lib/trace-cmd/trace-output.c                  |  2 +-
 tracecmd/trace-hist.c                         |  2 +-
 tracecmd/trace-mem.c                          |  2 +-
 tracecmd/trace-read.c                         |  2 +-
 tracecmd/trace-restore.c                      |  2 +-
 tracecmd/trace-stream.c                       |  2 +-
 8 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index fc968cc9efe1..ad863df8954f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -95,8 +95,8 @@ static inline int tracecmd_host_bigendian(void)
 
 /* --- Opening and Reading the trace.dat file --- */
 
-enum  {
-	TRACECMD_FILE_INIT,
+enum tracecmd_file_states {
+	TRACECMD_FILE_INIT = 1,
 	TRACECMD_FILE_HEADERS,
 	TRACECMD_FILE_FTRACE_EVENTS,
 	TRACECMD_FILE_ALL_EVENTS,
@@ -153,7 +153,8 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 struct tracecmd_input *tracecmd_alloc(const char *file, int flags);
 struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags);
 void tracecmd_ref(struct tracecmd_input *handle);
-int tracecmd_read_headers(struct tracecmd_input *handle);
+int tracecmd_read_headers(struct tracecmd_input *handle,
+			  enum tracecmd_file_states state);
 int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
 int tracecmd_long_size(struct tracecmd_input *handle);
 int tracecmd_page_size(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b7166a9b1f40..1dcefc61bcbb 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -349,6 +349,9 @@ static int read_header_files(struct tracecmd_input *handle)
 	char *header;
 	char buf[BUFSIZ];
 
+	if (handle->file_state >= TRACECMD_FILE_HEADERS)
+		return 0;
+
 	if (do_read_check(handle, buf, 12))
 		return -1;
 
@@ -552,6 +555,9 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
+	if (handle->file_state >= TRACECMD_FILE_FTRACE_EVENTS)
+		return 0;
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -620,6 +626,9 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
+	if (handle->file_state >= TRACECMD_FILE_ALL_EVENTS)
+		return 0;
+
 	if (regex) {
 		sreg = &spreg;
 		ereg = &epreg;
@@ -702,6 +711,9 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
+	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
+		return 0;
+
 	if (read4(handle, &size) < 0)
 		return -1;
 	if (!size)
@@ -730,6 +742,9 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
+	if (handle->file_state >= TRACECMD_FILE_PRINTK)
+		return 0;
+
 	if (read4(handle, &size) < 0)
 		return -1;
 	if (!size)
@@ -773,11 +788,15 @@ static int read_cpus(struct tracecmd_input *handle)
 {
 	unsigned int cpus;
 
+	if (handle->file_state >= TRACECMD_FILE_CPU_COUNT)
+		return 0;
+
 	if (read4(handle, &cpus) < 0)
 		return -1;
 
 	handle->cpus = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
+	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
 	return 0;
 }
@@ -785,15 +804,26 @@ static int read_cpus(struct tracecmd_input *handle)
 /**
  * tracecmd_read_headers - read the header information from trace.dat
  * @handle: input handle for the trace.dat file
+ * @state: The state to read up to or zero to read up to options.
  *
  * This reads the trace.dat file for various information. Like the
  * format of the ring buffer, event formats, ftrace formats, kallsyms
- * and printk.
+ * and printk. This may be called multiple times with different @state
+ * values, to read partial data at a time. It will always continue
+ * where it left off.
  */
-int tracecmd_read_headers(struct tracecmd_input *handle)
+int tracecmd_read_headers(struct tracecmd_input *handle,
+			  enum tracecmd_file_states state)
 {
 	int ret;
 
+	/* Set to read all if state is zero */
+	if (!state)
+		state = TRACECMD_FILE_OPTIONS;
+
+	if (state <= handle->file_state)
+		return 0;
+
 	handle->parsing_failures = 0;
 
 	ret = read_header_files(handle);
@@ -802,28 +832,48 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 
 	tep_set_long_size(handle->pevent, handle->long_size);
 
+	if (state <= handle->file_state)
+		return 0;
+
 	ret = read_ftrace_files(handle, NULL);
 	if (ret < 0)
 		return -1;
 
+	if (state <= handle->file_state)
+		return 0;
+
 	ret = read_event_files(handle, NULL);
 	if (ret < 0)
 		return -1;
 
+	if (state <= handle->file_state)
+		return 0;
+
 	ret = read_proc_kallsyms(handle);
 	if (ret < 0)
 		return -1;
 
+	if (state <= handle->file_state)
+		return 0;
+
 	ret = read_ftrace_printk(handle);
 	if (ret < 0)
 		return -1;
 
+	if (state <= handle->file_state)
+		return 0;
+
 	if (read_and_parse_cmdlines(handle) < 0)
 		return -1;
 
+	if (state <= handle->file_state)
+		return 0;
+
 	if (read_cpus(handle) < 0)
 		return -1;
-	handle->file_state = TRACECMD_FILE_CPU_COUNT;
+
+	if (state <= handle->file_state)
+		return 0;
 
 	if (read_options_type(handle) < 0)
 		return -1;
@@ -2668,6 +2718,9 @@ static int read_options_type(struct tracecmd_input *handle)
 {
 	char buf[10];
 
+	if (handle->file_state >= TRACECMD_FILE_CPU_LATENCY)
+		return 0;
+
 	if (do_read_check(handle, buf, 10))
 		return -1;
 
@@ -2830,6 +2883,9 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	unsigned long long size;
 	char *cmdlines;
 
+	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
+		return 0;
+
 	if (read_data_and_size(handle, &cmdlines, &size) < 0)
 		return -1;
 	cmdlines[size] = 0;
@@ -3225,7 +3281,7 @@ struct tracecmd_input *tracecmd_open_fd(int fd, int flags)
 	if (!handle)
 		return NULL;
 
-	if (tracecmd_read_headers(handle) < 0)
+	if (tracecmd_read_headers(handle, 0) < 0)
 		goto fail;
 
 	if ((ret = tracecmd_init_data(handle)) < 0)
@@ -3273,7 +3329,7 @@ struct tracecmd_input *tracecmd_open_head(const char *file, int flags)
 	if (!handle)
 		return NULL;
 
-	if (tracecmd_read_headers(handle) < 0)
+	if (tracecmd_read_headers(handle, 0) < 0)
 		goto fail;
 
 	return handle;
@@ -3799,6 +3855,11 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 		goto error;
 	}
 
+	/*
+	 * read_options_type() is called right after the CPU count so update
+	 * file state accordingly.
+	 */
+	new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
 	ret = read_options_type(new_handle);
 	if (!ret)
 		ret = read_cpu_data(new_handle);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3e59bf7fdf5d..a26fd8537a1d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1540,7 +1540,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	ihandle = tracecmd_alloc_fd(fd2, TRACECMD_FL_LOAD_NO_PLUGINS);
 	if (!ihandle)
 		return NULL;
-	tracecmd_read_headers(ihandle);
+	tracecmd_read_headers(ihandle, 0);
 
 	/* move the file descriptor to the end */
 	if (lseek(fd, 0, SEEK_END) == (off_t)-1)
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 3b59ac6f27ab..efb790acb807 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -1043,7 +1043,7 @@ void trace_hist(int argc, char **argv)
 	if (!handle)
 		die("can't open %s\n", input_file);
 
-	ret = tracecmd_read_headers(handle);
+	ret = tracecmd_read_headers(handle, 0);
 	if (ret)
 		return;
 
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 3453c3a75fcc..25eb08612b06 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -554,7 +554,7 @@ void trace_mem(int argc, char **argv)
 	if (!handle)
 		die("can't open %s\n", input_file);
 
-	ret = tracecmd_read_headers(handle);
+	ret = tracecmd_read_headers(handle, 0);
 	if (ret)
 		return;
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 56fc0626d486..22e8635ce60a 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1826,7 +1826,7 @@ void trace_report (int argc, char **argv)
 			return;
 		}
 
-		ret = tracecmd_read_headers(handle);
+		ret = tracecmd_read_headers(handle, 0);
 		if (check_event_parsing) {
 			if (ret || tracecmd_get_parsing_failures(handle))
 				exit(EINVAL);
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 13f803053582..280a37f0a8ca 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -122,7 +122,7 @@ void trace_restore (int argc, char **argv)
 		if (!ihandle)
 			die("error reading file %s", input);
 		/* make sure headers are ok */
-		if (tracecmd_read_headers(ihandle) < 0)
+		if (tracecmd_read_headers(ihandle, TRACECMD_FILE_CMD_LINES) < 0)
 			die("error reading file %s headers", input);
 
 		handle = tracecmd_copy(ihandle, output);
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index e230cf89cfd1..f503bf770366 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -59,7 +59,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		goto fail;
 	}
 
-	if (tracecmd_read_headers(trace_input) < 0)
+	if (tracecmd_read_headers(trace_input, 0) < 0)
 		goto fail_free_input;
 
 	if (handle_init)
-- 
2.30.0


