Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB86235504F
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Feb 2026 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071958; cv=none; b=qYpbkVZxHekuX/tpPZbllKz5YWer5is2xfVTAjZ3EgPX/tlxcn5sk0MyEAnpxkJhAvMb4l90JPgvdKRoiuAI3njXMrJi6AH3+9Nab65qmK+1uvmgBnHPMrUfeDQTwFeeMOzUFHjP2WT720NEziVJ2gzVSnCQ2af50s6ubdIPDJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071958; c=relaxed/simple;
	bh=jMQ91a12vwuGhHsDe4bvzFSUezHOU1un7/RUB/mgt0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWHfOPNLKLoQQAGgfAV/9j5BSxMgWxBzIPh9jg0LVu6+AUwKDZG1W3sXvG0KqtghlYd1nayCzJF1xkFa01kFP6uPaGPMYwetWWeG1Ro4BuKv46pOuIjrVGQI8x5jfUCGarnDpy7pohEHeROwMyKNhkLj/cNwfv//JQX1lKMat9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D0FC2BC87;
	Mon,  2 Feb 2026 22:39:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vn2a8-00000008We1-3Ipt;
	Mon, 02 Feb 2026 17:39:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 2/6] libtracecmd: Remove "compress" parameter from tcmd_out_compress*() functions
Date: Mon,  2 Feb 2026 17:36:57 -0500
Message-ID: <20260202223941.2031858-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202223941.2031858-1-rostedt@goodmis.org>
References: <20260202223941.2031858-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

All the tcmd_out_compression*() functions test if the handle passed in has
its "compress" field set as well as the "compress" parameter is set. If
either of them are not set, then those functions return without doing
anything.

But the passed in "compress" value is derived from the handle->compress
field, which makes it redundant.

Remove it as it's not need.

This also removes the tcmd_out_check_compression() which was used to see if
the handle had its compress field set in order to set the compress variable!

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/trace-cmd-local.h |  7 ++-
 lib/trace-cmd/trace-input.c             | 42 ++++++++---------
 lib/trace-cmd/trace-output.c            | 61 ++++++++++++-------------
 3 files changed, 49 insertions(+), 61 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index a2baab66c19f..c75055ecf9b8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -65,10 +65,9 @@ bool tcmd_check_file_state(unsigned long file_version, int current_state, int ne
 bool tcmd_check_out_state(struct tracecmd_output *handle, int new_state);
 
 int tcmd_out_uncompress_block(struct tracecmd_output *handle);
-int tcmd_out_compression_start(struct tracecmd_output *handle, bool compress);
-int tcmd_out_compression_end(struct tracecmd_output *handle, bool compress);
-void tcmd_out_compression_reset(struct tracecmd_output *handle, bool compress);
-bool tcmd_out_check_compression(struct tracecmd_output *handle);
+int tcmd_out_compression_start(struct tracecmd_output *handle);
+int tcmd_out_compression_end(struct tracecmd_output *handle);
+void tcmd_out_compression_reset(struct tracecmd_output *handle);
 
 void tcmd_out_set_file_state(struct tracecmd_output *handle, int new_state);
 int tcmd_out_save_options_offset(struct tracecmd_output *handle,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b3a044922c58..fba9c5b6a7fc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5330,7 +5330,6 @@ static bool check_in_state(struct tracecmd_input *handle, int new_state)
 static int copy_header_files(struct tracecmd_input *in_handle,
 			     struct tracecmd_output *out_handle)
 {
-	bool compress = tcmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
@@ -5345,7 +5344,7 @@ static int copy_header_files(struct tracecmd_input *in_handle,
 
 	offset = tcmd_out_write_section_header(out_handle, TRACECMD_OPTION_HEADER_INFO,
 					       "headers", TRACECMD_SEC_FL_COMPRESS, true);
-	tcmd_out_compression_start(out_handle, compress);
+	tcmd_out_compression_start(out_handle);
 
 	/* "header_page"  */
 	if (read_copy_data(in_handle, 12, out_handle) < 0)
@@ -5368,7 +5367,7 @@ static int copy_header_files(struct tracecmd_input *in_handle,
 		goto error;
 
 	in_handle->file_state = TRACECMD_FILE_HEADERS;
-	if (tcmd_out_compression_end(out_handle, compress))
+	if (tcmd_out_compression_end(out_handle))
 		goto error;
 
 	tcmd_out_set_file_state(out_handle, in_handle->file_state);
@@ -5379,14 +5378,13 @@ static int copy_header_files(struct tracecmd_input *in_handle,
 
 	return 0;
 error:
-	tcmd_out_compression_reset(out_handle, compress);
+	tcmd_out_compression_reset(out_handle);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = tcmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
@@ -5403,7 +5401,7 @@ static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_o
 	offset = tcmd_out_write_section_header(out_handle, TRACECMD_OPTION_FTRACE_EVENTS,
 					       "ftrace events", TRACECMD_SEC_FL_COMPRESS, true);
 
-	tcmd_out_compression_start(out_handle, compress);
+	tcmd_out_compression_start(out_handle);
 
 	if (read_copy_size4(in_handle, out_handle, &count) < 0)
 		goto error;
@@ -5418,7 +5416,7 @@ static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_o
 	}
 
 	in_handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
-	if (tcmd_out_compression_end(out_handle, compress))
+	if (tcmd_out_compression_end(out_handle))
 		goto error;
 
 	tcmd_out_set_file_state(out_handle, in_handle->file_state);
@@ -5430,14 +5428,13 @@ static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_o
 
 	return 0;
 error:
-	tcmd_out_compression_reset(out_handle, compress);
+	tcmd_out_compression_reset(out_handle);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = tcmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
@@ -5456,7 +5453,7 @@ static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_ou
 	offset = tcmd_out_write_section_header(out_handle, TRACECMD_OPTION_EVENT_FORMATS,
 					       "events format", TRACECMD_SEC_FL_COMPRESS, true);
 
-	tcmd_out_compression_start(out_handle, compress);
+	tcmd_out_compression_start(out_handle);
 
 	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
 		goto error;
@@ -5484,7 +5481,7 @@ static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_ou
 	}
 
 	in_handle->file_state = TRACECMD_FILE_ALL_EVENTS;
-	if (tcmd_out_compression_end(out_handle, compress))
+	if (tcmd_out_compression_end(out_handle))
 		goto error;
 
 	tcmd_out_set_file_state(out_handle, in_handle->file_state);
@@ -5496,14 +5493,13 @@ static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_ou
 
 	return 0;
 error:
-	tcmd_out_compression_reset(out_handle, compress);
+	tcmd_out_compression_reset(out_handle);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = tcmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned int size;
@@ -5518,7 +5514,7 @@ static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_
 	offset = tcmd_out_write_section_header(out_handle, TRACECMD_OPTION_KALLSYMS,
 					  "kallsyms", TRACECMD_SEC_FL_COMPRESS, true);
 
-	tcmd_out_compression_start(out_handle, compress);
+	tcmd_out_compression_start(out_handle);
 	if (read_copy_size4(in_handle, out_handle, &size) < 0)
 		goto error;
 
@@ -5529,7 +5525,7 @@ static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_
 		goto error;
 out:
 	in_handle->file_state = TRACECMD_FILE_KALLSYMS;
-	if (tcmd_out_compression_end(out_handle, compress))
+	if (tcmd_out_compression_end(out_handle))
 		goto error;
 
 	tcmd_out_set_file_state(out_handle, in_handle->file_state);
@@ -5541,14 +5537,13 @@ out:
 
 	return 0;
 error:
-	tcmd_out_compression_reset(out_handle, compress);
+	tcmd_out_compression_reset(out_handle);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = tcmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned int size;
@@ -5564,7 +5559,7 @@ static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_
 	offset = tcmd_out_write_section_header(out_handle, TRACECMD_OPTION_PRINTK,
 					  "printk", TRACECMD_SEC_FL_COMPRESS, true);
 
-	tcmd_out_compression_start(out_handle, compress);
+	tcmd_out_compression_start(out_handle);
 
 	if (read_copy_size4(in_handle, out_handle, &size) < 0)
 		goto error;
@@ -5577,7 +5572,7 @@ static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_
 
 out:
 	in_handle->file_state = TRACECMD_FILE_PRINTK;
-	if (tcmd_out_compression_end(out_handle, compress))
+	if (tcmd_out_compression_end(out_handle))
 		goto error;
 
 	tcmd_out_set_file_state(out_handle, in_handle->file_state);
@@ -5589,14 +5584,13 @@ out:
 
 	return 0;
 error:
-	tcmd_out_compression_reset(out_handle, compress);
+	tcmd_out_compression_reset(out_handle);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = tcmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
@@ -5611,7 +5605,7 @@ static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_
 	offset = tcmd_out_write_section_header(out_handle, TRACECMD_OPTION_CMDLINES,
 					       "command lines", TRACECMD_SEC_FL_COMPRESS, true);
 
-	tcmd_out_compression_start(out_handle, compress);
+	tcmd_out_compression_start(out_handle);
 
 	if (read_copy_size8(in_handle, out_handle, &size) < 0)
 		goto error;
@@ -5624,7 +5618,7 @@ static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_
 
 out:
 	in_handle->file_state = TRACECMD_FILE_CMD_LINES;
-	if (tcmd_out_compression_end(out_handle, compress))
+	if (tcmd_out_compression_end(out_handle))
 		goto error;
 
 	tcmd_out_set_file_state(out_handle, in_handle->file_state);
@@ -5636,7 +5630,7 @@ out:
 
 	return 0;
 error:
-	tcmd_out_compression_reset(out_handle, compress);
+	tcmd_out_compression_reset(out_handle);
 	section_close(in_handle, sec);
 	return -1;
 }
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6becaa1f8619..b477788b2365 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -155,9 +155,9 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
-__hidden void tcmd_out_compression_reset(struct tracecmd_output *handle, bool compress)
+__hidden void tcmd_out_compression_reset(struct tracecmd_output *handle)
 {
-	if (!compress || !handle->compress)
+	if (!handle->compress)
 		return;
 
 	tracecmd_compress_reset(handle->compress);
@@ -178,9 +178,9 @@ __hidden int tcmd_out_uncompress_block(struct tracecmd_output *handle)
 	return ret;
 }
 
-__hidden int tcmd_out_compression_start(struct tracecmd_output *handle, bool compress)
+__hidden int tcmd_out_compression_start(struct tracecmd_output *handle)
 {
-	if (!compress || !handle->compress)
+	if (!handle->compress)
 		return 0;
 
 	tracecmd_compress_reset(handle->compress);
@@ -189,9 +189,9 @@ __hidden int tcmd_out_compression_start(struct tracecmd_output *handle, bool com
 	return 0;
 }
 
-__hidden int tcmd_out_compression_end(struct tracecmd_output *handle, bool compress)
+__hidden int tcmd_out_compression_end(struct tracecmd_output *handle)
 {
-	if (!compress || !handle->compress)
+	if (!handle->compress)
 		return 0;
 
 	handle->do_compress = false;
@@ -628,12 +628,12 @@ static int save_string_section(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	tcmd_out_compression_start(handle, true);
+	tcmd_out_compression_start(handle);
 
 	if (tcmd_do_write_check(handle, handle->strings, handle->strings_p))
 		goto error;
 
-	if (tcmd_out_compression_end(handle, true))
+	if (tcmd_out_compression_end(handle))
 		goto error;
 
 	if (tcmd_out_update_section_header(handle, offset))
@@ -647,7 +647,7 @@ static int save_string_section(struct tracecmd_output *handle)
 	return 0;
 
 error:
-	tcmd_out_compression_reset(handle, true);
+	tcmd_out_compression_reset(handle);
 	return -1;
 }
 
@@ -680,7 +680,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 		return -1;
 	}
 
-	tcmd_out_compression_start(handle, compress);
+	tcmd_out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* old style did not show this info, just add zero */
@@ -694,7 +694,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 			goto out_close;
 		if (tcmd_do_write_check(handle, &size, 8))
 			goto out_close;
-		if (tcmd_out_compression_end(handle, compress))
+		if (tcmd_out_compression_end(handle))
 			goto out_close;
 		if (tcmd_out_update_section_header(handle, offset))
 			goto out_close;
@@ -748,7 +748,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 		goto out_free;
 	}
 	put_tracing_file(path);
-	if (tcmd_out_compression_end(handle, compress))
+	if (tcmd_out_compression_end(handle))
 		goto out_close;
 
 	if (tcmd_out_update_section_header(handle, offset))
@@ -760,7 +760,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
  out_free:
 	put_tracing_file(path);
  out_close:
-	tcmd_out_compression_reset(handle, compress);
+	tcmd_out_compression_reset(handle);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -1014,13 +1014,13 @@ static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 		return -1;
 
 	create_event_list_item(handle, &systems, &list);
-	tcmd_out_compression_start(handle, compress);
+	tcmd_out_compression_start(handle);
 
 	ret = copy_event_system(handle, systems);
 	if (!ret)
-		ret = tcmd_out_compression_end(handle, compress);
+		ret = tcmd_out_compression_end(handle);
 	else
-		tcmd_out_compression_reset(handle, compress);
+		tcmd_out_compression_reset(handle);
 
 	free_list_events(systems);
 	if (ret)
@@ -1087,7 +1087,7 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-	tcmd_out_compression_start(handle, compress);
+	tcmd_out_compression_start(handle);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (tcmd_do_write_check(handle, &endian4, 4))
@@ -1105,7 +1105,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	if (ret)
 		goto out_free;
 
-	ret = tcmd_out_compression_end(handle, compress);
+	ret = tcmd_out_compression_end(handle);
 	if (ret)
 		goto out_free;
 	ret = tcmd_out_update_section_header(handle, offset);
@@ -1114,7 +1114,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
 	else
-		tcmd_out_compression_reset(handle, compress);
+		tcmd_out_compression_reset(handle);
 
 	free_list_events(systems);
 
@@ -1187,7 +1187,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	if (offset == (off_t)-1)
 		return -1;
 
-	tcmd_out_compression_start(handle, compress);
+	tcmd_out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -1215,7 +1215,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	}
 	set_proc_kptr_restrict(1);
 
-	ret = tcmd_out_compression_end(handle, compress);
+	ret = tcmd_out_compression_end(handle);
 	if (ret)
 		goto out;
 
@@ -1224,7 +1224,7 @@ out:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_KALLSYMS;
 	else
-		tcmd_out_compression_reset(handle, compress);
+		tcmd_out_compression_reset(handle);
 	return ret;
 }
 
@@ -1255,7 +1255,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 		return -1;
 	}
 
-	tcmd_out_compression_start(handle, compress);
+	tcmd_out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -1278,7 +1278,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 
  out:
 	put_tracing_file(path);
-	if (tcmd_out_compression_end(handle, compress))
+	if (tcmd_out_compression_end(handle))
 		return -1;
 
 	if (tcmd_out_update_section_header(handle, offset))
@@ -1287,7 +1287,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 	return 0;
  fail:
 	put_tracing_file(path);
-	tcmd_out_compression_reset(handle, compress);
+	tcmd_out_compression_reset(handle);
 	return -1;
 }
 
@@ -2325,15 +2325,15 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	tcmd_out_compression_start(handle, compress);
+	tcmd_out_compression_start(handle);
 
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
 	if (ret < 0) {
-		tcmd_out_compression_reset(handle, compress);
+		tcmd_out_compression_reset(handle);
 		return ret;
 	}
 
-	if (tcmd_out_compression_end(handle, compress))
+	if (tcmd_out_compression_end(handle))
 		return -1;
 
 	if (tcmd_out_update_section_header(handle, offset))
@@ -3016,11 +3016,6 @@ __hidden bool tcmd_check_out_state(struct tracecmd_output *handle, int new_state
 	return tcmd_check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
-__hidden bool tcmd_out_check_compression(struct tracecmd_output *handle)
-{
-	return (handle->compress != NULL);
-}
-
 __hidden int tcmd_out_save_options_offset(struct tracecmd_output *handle, unsigned long long start)
 {
 	unsigned long long new, en8;
-- 
2.51.0

