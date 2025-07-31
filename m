Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EB725EF89
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753993340; cv=none; b=E4ISV4rFIIlMY9lGyTo2sVWxMNRcdMz9NXGfUns0TY6m6R1Kt2gNun2qH6uWtceQT7Jx4ABZ8y41jwICy1FXXX8UnwfAHcPaSw2FymOxeG+s7RYfs7g1AEZP5s2Guji4sHijgqQohKKFlnJdpRZUWcvW08XbzehdWEF6cHcXkGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753993340; c=relaxed/simple;
	bh=y6KJ8eyHgEbM4226SMDEO3NmDdiZWHqa2riQpy3f88o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFFOoza+7133FNB+Ce2SUSdjlwgNcb8eLartEFwl7+LytuWkeqW/mLdVOIZp1hrBhHRuJxVUfi3n8owxqvL2DnrIewXfnv4IWx4/FMgRF7OXtASiQWW1K9s2WkxPjsqbrWPnNR3bTTSPilgP/ObTaWtPllnx5WxV7jJXscSxl9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F8DC4CEF8;
	Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1uhZnT-00000006wRF-3CJG;
	Thu, 31 Jul 2025 16:22:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/5] libtracecmd: Add write_compress_section_header() for writing compress sections
Date: Thu, 31 Jul 2025 16:20:36 -0400
Message-ID: <20250731202238.1654368-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250731202238.1654368-1-rostedt@goodmis.org>
References: <20250731202238.1654368-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

All the functions that write compressed sections has a "compress" parameter
this is set when the handle->compress is set. But this is redundant and
can be removed.

There's one function that still calls tcmd_out_write_section_header()
without the compress flag set and that's write_options_start() as the
options section is never compressed.

Since all the other functions compress their sections, add a wrapper
function write_compress_section_header() that calls
tcmd_out_write_section_header() with its compress flag set, and have those
functions use the wrapper.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 93 +++++++++++++-----------------------
 1 file changed, 34 insertions(+), 59 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4144e1b50d85..e775cdc03bfc 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -549,6 +549,14 @@ tcmd_out_write_section_header(struct tracecmd_output *handle, unsigned short hea
 	return offset;
 }
 
+static unsigned long long
+write_compress_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			      char *description, bool option)
+{
+	return tcmd_out_write_section_header(handle, header_id, description,
+					     TRACECMD_SEC_FL_COMPRESS, option);
+}
+
 __hidden int tcmd_out_update_section_header(struct tracecmd_output *handle, tsize_t offset)
 {
 	tsize_t current;
@@ -579,7 +587,6 @@ __hidden int tcmd_out_update_section_header(struct tracecmd_output *handle, tsiz
 
 static int save_string_section(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = TRACECMD_SEC_FL_COMPRESS;
 	tsize_t offset;
 
 	if (!handle->strings || !handle->strings_p)
@@ -591,7 +598,7 @@ static int save_string_section(struct tracecmd_output *handle)
 		return -1;
 	}
 
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_STRINGS, "strings", flags, false);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_STRINGS, "strings", false);
 	if (offset == (off_t)-1)
 		return -1;
 
@@ -618,9 +625,8 @@ error:
 	return -1;
 }
 
-static int read_header_files(struct tracecmd_output *handle, bool compress)
+static int read_header_files(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = 0;
 	tsize_t size, check_size, endian8;
 	struct stat st;
 	tsize_t offset;
@@ -638,10 +644,8 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	if (!path)
 		return -1;
 
-	if (compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
-					       "headers", flags, true);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
+					       "headers", true);
 	if (offset == (off_t)-1) {
 		put_tracing_file(path);
 		return -1;
@@ -959,9 +963,8 @@ create_event_list_item(struct tracecmd_output *handle,
 	 tracecmd_warning("Insufficient memory");
 }
 
-static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
+static int read_ftrace_files(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems = NULL;
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
 	tsize_t offset;
@@ -973,10 +976,8 @@ static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 		return -1;
 	}
 
-	if (compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
-					       "ftrace events", flags, true);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
+					       "ftrace events", true);
 	if (offset == (off_t)-1)
 		return -1;
 
@@ -1014,9 +1015,8 @@ create_event_list(struct tracecmd_output *handle,
 }
 
 static int read_event_files(struct tracecmd_output *handle,
-			    struct tracecmd_event_list *event_list, bool compress)
+			    struct tracecmd_event_list *event_list)
 {
-	enum tracecmd_section_flags flags = 0;
 	struct list_event_system *systems;
 	struct list_event_system *slist;
 	struct tracecmd_event_list *list;
@@ -1032,10 +1032,8 @@ static int read_event_files(struct tracecmd_output *handle,
 		return -1;
 	}
 
-	if (compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
-					       "events format", flags, true);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
+					       "events format", true);
 	if (offset == (off_t)-1)
 		return -1;
 	/*
@@ -1128,9 +1126,8 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
+static int read_proc_kallsyms(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
 	tsize_t offset;
@@ -1146,10 +1143,8 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	if (handle->kallsyms)
 		path = handle->kallsyms;
 
-	if (compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_KALLSYMS,
-					       "kallsyms", flags, true);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_KALLSYMS,
+					       "kallsyms", true);
 	if (offset == (off_t)-1)
 		return -1;
 
@@ -1192,9 +1187,8 @@ out:
 	return ret;
 }
 
-static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
+static int read_ftrace_printk(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	tsize_t offset;
 	struct stat st;
@@ -1211,9 +1205,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 	if (!path)
 		return -1;
 
-	if (compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", true);
 	if (offset == (off_t)-1) {
 		put_tracing_file(path);
 		return -1;
@@ -1679,25 +1671,21 @@ static int output_write_init(struct tracecmd_output *handle)
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list)
 {
-	bool compress = false;
-
 	if (!handle || handle->file_state < TRACECMD_FILE_ALLOCATED)
 		return -1;
 
 	/* Write init data, if not written yet */
 	if (handle->file_state < TRACECMD_FILE_INIT && output_write_init(handle))
 		return -1;
-	if (handle->compress)
-		compress = true;
-	if (read_header_files(handle, compress))
+	if (read_header_files(handle))
 		return -1;
-	if (read_ftrace_files(handle, compress))
+	if (read_ftrace_files(handle))
 		return -1;
-	if (read_event_files(handle, list, compress))
+	if (read_event_files(handle, list))
 		return -1;
-	if (read_proc_kallsyms(handle, compress))
+	if (read_proc_kallsyms(handle))
 		return -1;
-	if (read_ftrace_printk(handle, compress))
+	if (read_ftrace_printk(handle))
 		return -1;
 	return 0;
 }
@@ -2268,8 +2256,6 @@ static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char
 
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
-	enum tracecmd_section_flags flags = 0;
-	bool compress = false;
 	tsize_t offset;
 	int ret;
 
@@ -2279,13 +2265,8 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 		return -1;
 	}
 
-	if (handle->compress)
-		compress = true;
-
-	if (compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_CMDLINES,
-					       "command lines", flags, true);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_CMDLINES,
+					       "command lines", true);
 	if (offset == (off_t)-1)
 		return -1;
 
@@ -2420,7 +2401,6 @@ tcmd_out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
 						     int file_version, const char *compression)
 {
-	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
 	tsize_t offset;
 	char *path;
@@ -2472,11 +2452,9 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	    !tcmd_out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT,
 				   offset, 0, NULL, getpagesize()))
 		goto out_free;
-	if (handle->compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
 
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
-					       "buffer latency", flags, false);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
+					       "buffer latency", false);
 
 	copy_file_compress(handle, path, NULL);
 	if (tcmd_out_update_section_header(handle, offset))
@@ -2595,7 +2573,6 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 				     const char *buff_name)
 {
 	struct data_file_write *data_files = NULL;
-	enum tracecmd_section_flags flags = 0;
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
@@ -2625,11 +2602,9 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && tcmd_do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
-	if (handle->compress)
-		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
-	offset = tcmd_out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_BUFFER, str, false);
 	free(str);
 	if (offset == (off_t)-1)
 		goto out_free;
@@ -2713,7 +2688,7 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 		if (!tracecmd_get_quiet(handle)) {
 			fprintf(stderr, "    %llu bytes in size",
 				(unsigned long long)data_files[i].write_size);
-			if (flags & TRACECMD_SEC_FL_COMPRESS)
+			if (handle->compress)
 				fprintf(stderr, " (%llu uncompressed)",
 					(unsigned long long)data_files[i].file_size);
 			fprintf(stderr, "\n");
-- 
2.47.2

