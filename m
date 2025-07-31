Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA86D25F79A
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753993340; cv=none; b=tZ3IhRsKRMeQ9MUEZhdPx0RfyGxyKnNd50oyLwMu1YCP/LycgKYHs7KAIjqFvIq7fdjBsBtEvf2g5AUc7szbEdQVe5T4Pd5DzLFKZJhTCSUOUhV85Ed+VNpRPtcSC6wc0uOuUW3ZuYQJ/MQfT6C3HfbGSzmTVpLSKmpNHnOPD5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753993340; c=relaxed/simple;
	bh=flt4lB1MpB5JSOSwjVEzmQXE/iXE0pbcUBdZv87lptI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUKr09T95LRXEJL48eOnD5UwmYuSMhocZYK6cXG4MDczAbGQm6bA0DlutNML55e558I/qIicSR3sCGjbsxeXyyBUI48tbB7E27QcFUvNhgyYR/XU21PgrBO01Rr9L6pQfjrRIz16V6on7xqeG+iDB66auYANuJvdrKTJSyLNvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574EBC4CEFA;
	Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1uhZnT-00000006wRL-3KhI;
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
Subject: [PATCH 4/5] trace-cmd record / report: Record BTF file if function arguments are recorded
Date: Thu, 31 Jul 2025 16:20:37 -0400
Message-ID: <20250731202238.1654368-5-rostedt@goodmis.org>
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

If function tracer is recorded with func-args option set, or the
function_graph tracer is recorded with the funcgraph-args option set, then
record the BTF file in a new BTF_FILE section in the trace.dat file.

This is compressed on disk, and when the trace.dat file is read, it is
loaded into memory and sent to the libtraceevent tep_load_btf() function.

This will be used to show arguments of the function tracer:

             cat-33501 [005] ..... 136155.767937: function:             mutex_unlock(lock=0xffffffff831dbbe0)
             cat-33501 [005] ..... 136155.767939: function:             __mutex_unlock_slowpath(lock=0xffffffff831dbbe0, ip=0xffffffff814a7154)
             cat-33501 [005] ..... 136155.767940: function:             __f_unlock_pos(f=0xffff8881538de000)
             cat-33501 [005] ..... 136155.767940: function:             mutex_unlock(lock=0xffff8881538de090)
             cat-33501 [005] ..... 136155.767940: function:             __mutex_unlock_slowpath(lock=0xffff8881538de090, ip=0xffffffff816e8ed1)
             cat-33501 [005] ..... 136155.767941: function:             mem_cgroup_handle_over_high(gfp_mask=0xcc0)
             cat-33501 [005] ..... 136155.767941: function:             blkcg_maybe_throttle_current()
             cat-33501 [005] ..... 136155.767942: function:             __rseq_handle_notify_resume(ksig=0x0, regs=0xffffc9000e3eff58)
             cat-33501 [005] d.... 136155.767943: function:             fpregs_assert_state_consistent()
             cat-33501 [005] d.... 136155.767943: function:             switch_fpu_return()
             cat-33501 [005] ..... 136155.767950: function:             __x64_sys_execve(regs=0xffffc9000e3eff58)
             cat-33501 [005] ..... 136155.767951: function:                getname_flags(filename=0x7ffe7d33f3d0, flags=0)
             cat-33501 [005] ..... 136155.767951: function:                getname_flags.part.0(7ffe7d33f3d0, 0, 0, 0, 0, 0)
             cat-33501 [005] ..... 136155.767951: function:                   kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  3 +
 lib/trace-cmd/trace-compress.c                | 26 ++++++++
 lib/trace-cmd/trace-input.c                   | 15 +++++
 lib/trace-cmd/trace-output.c                  | 64 +++++++++++++++++++
 tracecmd/trace-record.c                       | 42 +++++++++++-
 5 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 809e244b2d1c..4743bbc62048 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -159,6 +159,7 @@ enum {
 	TRACECMD_OPTION_PRINTK,
 	TRACECMD_OPTION_CMDLINES,
 	TRACECMD_OPTION_BUFFER_TEXT,
+	TRACECMD_OPTION_BTF_FILE,
 	TRACECMD_OPTION_MAX,
 };
 
@@ -340,6 +341,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 size_t tracecmd_get_out_file_offset(struct tracecmd_output *handle);
+int tracecmd_append_btf_file(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
@@ -568,6 +570,7 @@ int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
 			      struct tracecmd_compress_chunk *chunk, char *data);
 int tracecmd_load_chunks_info(struct tracecmd_compression *handle,
 			      struct tracecmd_compress_chunk **chunks_info);
+void *tracecmd_uncompress_buffer(struct tracecmd_compression *handle, size_t *size);
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 2a7a3e24a7ad..19457a1e0f41 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -363,6 +363,32 @@ out:
 	free(buf);
 	return ret;
 }
+/**
+ * tracecmd_uncompress_buffer - Returned the current uncompressed buffer
+ * @handle: compression handle
+ * @size: A pointer to place the size of the uncompressed buffer in
+ *
+ * Returns the current uncompressed buffer and resets the compression
+ * @handle.
+ *
+ * Returns the buffer (must be freed with free()) or NULL.
+ *  @size (if not NULL) will contain the size of the uncompressed buffer.
+ */
+void *tracecmd_uncompress_buffer(struct tracecmd_compression *handle, size_t *size)
+{
+	void *buffer;
+
+	if (!handle)
+		return NULL;
+
+	if (size)
+		*size = handle->capacity;
+
+	buffer = handle->buffer;
+	handle->buffer = NULL;
+	tracecmd_compress_reset(handle);
+	return buffer;
+}
 
 /**
  * tracecmd_compress_buffer_write - write() to compression buffer
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6080a6f0cdfd..84afc346a86a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1026,6 +1026,17 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	return 0;
 }
 
+static int read_btf(struct tracecmd_input *handle)
+{
+	void *raw_data;
+	size_t size;
+
+	raw_data = tracecmd_uncompress_buffer(handle->compress, &size);
+
+	tep_load_btf(handle->pevent, raw_data, size);
+	return 0;
+}
+
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
 
 /**
@@ -1203,6 +1214,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 	case TRACECMD_OPTION_CMDLINES:
 		ret = read_and_parse_cmdlines(handle);
 		break;
+	case TRACECMD_OPTION_BTF_FILE:
+		ret = read_btf(handle);
+		break;
 	default:
 		ret = 0;
 		break;
@@ -4174,6 +4188,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_KALLSYMS:
 		case TRACECMD_OPTION_PRINTK:
 		case TRACECMD_OPTION_CMDLINES:
+		case TRACECMD_OPTION_BTF_FILE:
 			if (size < 8)
 				break;
 			section_add_or_update(handle, option, -1,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e775cdc03bfc..ac8f178b1a91 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2288,6 +2288,70 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	return 0;
 }
 
+#define BTF_FILE "/sys/kernel/btf/vmlinux"
+
+int tracecmd_append_btf_file(struct tracecmd_output *handle)
+{
+	tsize_t offset, size, check_size;
+	struct tracecmd_option *option;
+	struct iovec *vect;
+	struct stat st;
+	int ret;
+
+	if (!HAS_SECTIONS(handle))
+		return -1;
+
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_BTF_FILE, NULL, true);
+	if (offset == (off_t)-1)
+		return -1;
+
+	tcmd_out_compression_start(handle);
+
+	ret = stat(BTF_FILE, &st);
+	if (ret < 0)
+		return -1;
+
+	check_size = copy_file(handle, BTF_FILE);
+	if (st.st_size != check_size) {
+		errno = EINVAL;
+		tracecmd_warning("error in size of file '%s'", BTF_FILE);
+		return -1;
+	}
+
+	if (tcmd_out_compression_end(handle))
+		return -1;
+
+	if (tcmd_out_update_section_header(handle, offset))
+		return -1;
+
+	return 0;
+
+	/*
+	 * BTF file
+	 *  - data offset in the file
+	 *  - data size
+	 */
+
+	vect = calloc(2, sizeof(struct iovec));
+	if (!vect)
+		return -1;
+	vect[0].iov_base = &offset;
+	vect[0].iov_len = 8;
+	vect[1].iov_base = &size;
+	vect[1].iov_len = 8;
+
+	option = tracecmd_add_option_v(handle, TRACECMD_OPTION_BTF_FILE, vect, 2);
+	free(vect);
+
+	if (!option)
+		return -1;
+
+	if (do_lseek(handle, 0, SEEK_END) == (off_t)-1)
+		return -1;
+
+	return 0;
+}
+
 static char *get_clock(struct tracecmd_output *handle)
 {
 	struct tracefs_instance *inst;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 47486e9863df..f36ee6cd6cc6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4632,12 +4632,46 @@ error:
 	return NULL;
 }
 
+static void check_need_btf(bool *need_btf, struct tracefs_instance *instance)
+{
+	bool func_graph_trace;
+	bool func_trace;
+	char *current;
+
+	/* Nothing to do if it's already set */
+	if (*need_btf)
+		return;
+
+	current = tracefs_instance_file_read(instance, "current_tracer", NULL);
+	if (!current)
+		return;
+
+	func_trace = strcmp(current, "function\n") == 0;
+	func_graph_trace = strcmp(current, "function_graph\n") == 0;
+
+	free(current);
+	if (!func_trace && !func_graph_trace)
+		return;
+
+	if (func_trace)
+		current = tracefs_instance_file_read(instance, "options/func-args", NULL);
+	else
+		current = tracefs_instance_file_read(instance, "options/funcgraph-args", NULL);
+	if (!current)
+		return;
+
+	*need_btf = strncmp(current, "1", 1) == 0;
+
+	free(current);
+}
+
 static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
 	bool have_proxy = false;
 	bool local = false;
+	bool need_btf = false;
 	int max_cpu_count = local_cpu_count;
 	char **temp_files;
 	int i;
@@ -4733,11 +4767,17 @@ static void record_data(struct common_record_context *ctx)
 							tracefs_instance_get_name(instance->tracefs),
 							cpus);
 				add_buffer_stat(handle, instance);
+				check_need_btf(&need_btf, instance->tracefs);
 			}
 		}
 
-		if (!no_top_instance() && !top_instance.msg_handle)
+		if (!no_top_instance() && !top_instance.msg_handle) {
 			print_stat(&top_instance);
+			check_need_btf(&need_btf, top_instance.tracefs);
+		}
+
+		if (need_btf)
+			tracecmd_append_btf_file(handle);
 
 		for_all_instances(instance) {
 			add_pid_maps(handle, instance);
-- 
2.47.2

