Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B74C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiENCzh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiENCzW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C0734A96E
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7665FB8324B
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08FBC341CE;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XNT-Pj;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 24/26] trace-cmd agent-proxy: Send options at the end of the trace
Date:   Fri, 13 May 2022 22:47:54 -0400
Message-Id: <20220514024756.1319681-25-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The host controls the time shift for the guest, and when the host is
running as an agent proxy, it must be able to send that data to the
guest to be saved it the guests file. But the guest running the recorder
does not create its file until the end of the trace.

Send options for the time shift at the end of the trace (will later add
the time synchronization too). The guest recorder will then add this to
its trace.dat file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |   6 +
 lib/trace-cmd/include/trace-cmd-local.h       |   2 +
 lib/trace-cmd/trace-msg.c                     | 148 ++++++++++++---
 lib/trace-cmd/trace-output.c                  | 177 ++++++++++++++----
 tracecmd/trace-record.c                       |  41 +++-
 5 files changed, 317 insertions(+), 57 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 053866d547af..5606e132cba1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -421,6 +421,8 @@ int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_cont(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_wait(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
@@ -430,6 +432,10 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_read_options(struct tracecmd_msg_handle *msg_handle,
+			      struct tracecmd_output *handle);
+int tracecmd_msg_send_options(struct tracecmd_msg_handle *msg_handle,
+			      struct tracecmd_output *handle);
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int argc, char **argv, bool use_fifos,
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 6ac341374941..cfa3e97ae445 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -94,5 +94,7 @@ int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off64_t offset, int whence);
 unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 unsigned int get_meta_strings_size(struct tracecmd_input *handle);
+int trace_append_options(struct tracecmd_output *handle, void *buf, size_t len);
+void *trace_get_options(struct tracecmd_output *handle, size_t *len);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index a0c7f1818b0f..9c26401abe66 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -108,7 +108,8 @@ struct tracecmd_msg_header {
 	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),\
 	C(CLOSE_RESP,	8,	0),					\
 	C(TIME_SYNC,	9,	sizeof(struct tracecmd_msg_tsync)),	\
-	C(TRACE_PROXY,	10,	sizeof(struct tracecmd_msg_trace_proxy)),
+	C(TRACE_PROXY,	10,	sizeof(struct tracecmd_msg_trace_proxy)), \
+	C(CONT,		11,	0),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -783,6 +784,14 @@ int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle)
 	return tracecmd_msg_send(msg_handle, &msg);
 }
 
+int tracecmd_msg_cont(struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_msg msg;
+
+	tracecmd_msg_init(MSG_CONT, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
+}
+
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			   const char *buf, int size)
 {
@@ -823,6 +832,42 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 	return ret;
 }
 
+/**
+ * tracecmd_msg_send_options - Send options over the network
+ * @msg_handle: message handle, holding the communication context
+ * @handle: The output file that has the options to send
+ *
+ * Send options over the network. This is used when the output handle
+ * has more options to send over the network after the trace. Some
+ * options are sent before, and some sent afterward. Since the receiving
+ * side needs to know the location to update the indexes, it will
+ * handle the section header. This just sends out the raw content to
+ * the receiver (requires that both sides have the same endianess, as
+ * no conversion is made of the content of the options).
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracecmd_msg_send_options(struct tracecmd_msg_handle *msg_handle,
+			      struct tracecmd_output *handle)
+{
+	struct tracecmd_msg msg;
+	size_t len;
+	void *buf;
+	int ret;
+
+	buf = trace_get_options(handle, &len);
+	if (!buf)
+		return -1;
+
+	ret = tracecmd_msg_data_send(msg_handle, buf, len);
+	free(buf);
+	if (ret < 0)
+		return ret;
+
+	tracecmd_msg_init(MSG_FIN_DATA, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
+}
+
 /**
  * tracecmd_msg_flush_data - Send the current cache data over the network
  * @msg_handle: message handle, holding the communication context
@@ -856,32 +901,89 @@ int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 	return 0;
 }
 
+static int read_msg_data(struct tracecmd_msg_handle *msg_handle,
+			 struct tracecmd_msg *msg)
+{
+	int cmd;
+	int ret;
+
+	ret = tracecmd_msg_recv_wait(msg_handle->fd, msg);
+	if (ret < 0) {
+		tracecmd_warning("reading client %d (%s)", ret, strerror(ret));
+		return ret;
+	}
+
+	cmd = ntohl(msg->hdr.cmd);
+	if (cmd == MSG_FIN_DATA) {
+		/* Finish receiving data */
+		return 0;
+	} else if (cmd != MSG_SEND_DATA) {
+		ret = handle_unexpected_msg(msg_handle, msg);
+		if (ret < 0)
+			return -1;
+		return 0;
+	}
+
+	return msg_buf_len(msg);
+}
+
+/**
+ * tracecmd_msg_read_options - Receive options from over the network
+ * @msg_handle: message handle, holding the communication context
+ * @handle: The output file to write the options to.
+ *
+ * Receive the options sent by tracecmd_msg_send_options().
+ * See that function's documentation for mor details.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracecmd_msg_read_options(struct tracecmd_msg_handle *msg_handle,
+			      struct tracecmd_output *handle)
+{
+	struct tracecmd_msg msg;
+	size_t len = 0;
+	void *buf = NULL;
+	void *tmp;
+	int ret;
+	int n;
+
+	memset(&msg, 0, sizeof(msg));
+	while (!tracecmd_msg_done(msg_handle)) {
+		n = read_msg_data(msg_handle, &msg);
+		if (n <= 0)
+			break;
+
+		tmp = realloc(buf, n + len);
+		if (!tmp)
+			goto error;
+		buf = tmp;
+		memcpy(buf + len, msg.buf, n);
+		len += n;
+		msg_free(&msg);
+	}
+	msg_free(&msg);
+
+	ret = trace_append_options(handle, buf, len);
+	free(buf);
+
+	return ret;
+ error:
+	msg_free(&msg);
+	free(buf);
+	return -1;
+}
+
 int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 {
 	struct tracecmd_msg msg;
-	int t, n, cmd;
+	int t, n;
 	ssize_t s;
 	int ret;
 
 	while (!tracecmd_msg_done(msg_handle)) {
-		ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
-		if (ret < 0) {
-			tracecmd_warning("reading client %d (%s)", ret, strerror(ret));
-			return ret;
-		}
-
-		cmd = ntohl(msg.hdr.cmd);
-		if (cmd == MSG_FIN_DATA) {
-			/* Finish receiving data */
+		n = read_msg_data(msg_handle, &msg);
+		if (n <= 0)
 			break;
-		} else if (cmd != MSG_SEND_DATA) {
-			ret = handle_unexpected_msg(msg_handle, &msg);
-			if (ret < 0)
-				goto error;
-			goto next;
-		}
-
-		n = msg_buf_len(&msg);
 		t = n;
 		s = 0;
 		while (t > 0) {
@@ -896,10 +998,9 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 			t -= s;
 			s = n - t;
 		}
-
-next:
 		msg_free(&msg);
 	}
+	msg_free(&msg);
 
 	return 0;
 
@@ -947,6 +1048,11 @@ error:
 	return ret;
 }
 
+int tracecmd_msg_wait(struct tracecmd_msg_handle *msg_handle)
+{
+	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CONT);
+}
+
 int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
 {
 	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1fc41424eca7..bdec75d67bc4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1902,30 +1902,11 @@ int tracecmd_prepare_options(struct tracecmd_output *handle, off64_t offset, int
 	return curr == -1 ? -1 : 0;
 }
 
-static int write_options(struct tracecmd_output *handle)
+static tsize_t write_options_start(struct tracecmd_output *handle)
 {
-	struct tracecmd_option *options;
-	unsigned long long endian8;
-	unsigned short endian2;
-	unsigned int endian4;
-	bool new = false;
 	tsize_t offset;
 	int ret;
 
-	/* Check if there are unsaved options */
-	list_for_each_entry(options, &handle->options, list) {
-		if (!options->offset) {
-			new = true;
-			break;
-		}
-	}
-	/*
-	 * Even if there are no new options, if options_next is set, it requires
-	 * adding a new empty options section as the previous one already
-	 * points to it.
-	 */
-	if (!new && !handle->options_next)
-		return 0;
 	offset = do_lseek(handle, 0, SEEK_CUR);
 
 	if (handle->options_next) {
@@ -1950,7 +1931,55 @@ static int write_options(struct tracecmd_output *handle)
 			return -1;
 	}
 
-	offset = out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
+	return out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
+}
+
+static tsize_t write_options_end(struct tracecmd_output *handle, tsize_t offset)
+{
+	unsigned long long endian8;
+	unsigned short endian2;
+	unsigned int endian4;
+
+	endian2 = convert_endian_2(handle, TRACECMD_OPTION_DONE);
+	if (do_write_check(handle, &endian2, 2))
+		return -1;
+	endian4 = convert_endian_4(handle, 8);
+	if (do_write_check(handle, &endian4, 4))
+		return -1;
+	endian8 = 0;
+	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
+	if (do_write_check(handle, &endian8, 8))
+		return -1;
+	if (out_update_section_header(handle, offset))
+		return -1;
+
+	return 0;
+}
+
+static int write_options(struct tracecmd_output *handle)
+{
+	struct tracecmd_option *options;
+	unsigned short endian2;
+	unsigned int endian4;
+	bool new = false;
+	tsize_t offset;
+
+	/* Check if there are unsaved options */
+	list_for_each_entry(options, &handle->options, list) {
+		if (!options->offset) {
+			new = true;
+			break;
+		}
+	}
+	/*
+	 * Even if there are no new options, if options_next is set, it requires
+	 * adding a new empty options section as the previous one already
+	 * points to it.
+	 */
+	if (!new && !handle->options_next)
+		return 0;
+
+	offset = write_options_start(handle);
 	if (offset == (off_t)-1)
 		return -1;
 
@@ -1970,20 +1999,104 @@ static int write_options(struct tracecmd_output *handle)
 			return -1;
 	}
 
-	endian2 = convert_endian_2(handle, TRACECMD_OPTION_DONE);
-	if (do_write_check(handle, &endian2, 2))
-		return -1;
-	endian4 = convert_endian_4(handle, 8);
-	if (do_write_check(handle, &endian4, 4))
-		return -1;
-	endian8 = 0;
-	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
-	if (do_write_check(handle, &endian8, 8))
+	return write_options_end(handle, offset);
+}
+
+/**
+ * trace_get_options - Get the current options from the output file handle
+ * @handle: The output file descriptor that has options.
+ * @len: Returns the length of the buffer allocated and returned.
+ *
+ * Reads the options that have not been written to the file yet,
+ * puts them into an allocated buffer and sets @len to the size
+ * added. Used by trace-msg.c to send options over the network.
+ *
+ * Note, the options cannot be referenced again once this is called.
+ *  New options can be added and referenced.
+ *
+ * Returns an allocated buffer (must be freed with free()) that contains
+ *   the options to send, with @len set to the size of the content.
+ *   NULL on error (and @len is undefined).
+ */
+__hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
+{
+	struct tracecmd_msg_handle msg_handle;
+	struct tracecmd_output out_handle;
+	struct tracecmd_option *options;
+	unsigned short endian2;
+	unsigned int endian4;
+	tsize_t offset;
+	void *buf = NULL;
+
+	/* Use the msg_cache as our output */
+	memset(&msg_handle, 0, sizeof(msg_handle));
+	msg_handle.cfd = -1;
+	if (tracecmd_msg_handle_cache(&msg_handle) < 0)
+		return NULL;
+
+	out_handle = *handle;
+	out_handle.fd = msg_handle.cfd;
+	out_handle.msg_handle = &msg_handle;
+
+	list_for_each_entry(options, &handle->options, list) {
+		/* Option is already saved, skip it */
+		if (options->offset)
+			continue;
+		endian2 = convert_endian_2(handle, options->id);
+		if (do_write_check(&out_handle, &endian2, 2))
+			goto out;
+		endian4 = convert_endian_4(handle, options->size);
+		if (do_write_check(&out_handle, &endian4, 4))
+			goto out;
+		/* The option can not be referenced again */
+		options->offset = -1;
+		if (do_write_check(&out_handle, options->data, options->size))
+			goto out;
+	}
+
+	offset = do_lseek(&out_handle, 0, SEEK_CUR);
+	buf = malloc(offset);
+	if (!buf)
+		goto out;
+
+	if (do_lseek(&out_handle, 0, SEEK_SET) == (off64_t)-1)
+		goto out;
+	*len = read(msg_handle.cfd, buf, offset);
+	if (*len != offset) {
+		free(buf);
+		buf = NULL;
+	}
+
+ out:
+	close(msg_handle.cfd);
+	return buf;
+}
+
+/**
+ * trace_append_options - Append options to the file
+ * @handle: The output file descriptor that has options.
+ * @buf: The options to append.
+ * @len: The length of @buf.
+ *
+ * Will add an options section header for the content of @buf to
+ * be written as options into the @handle.
+ * Used by trace-msg.c to retrieve options over the network.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+__hidden int trace_append_options(struct tracecmd_output *handle, void *buf,
+				  size_t len)
+{
+	tsize_t offset;
+
+	offset = write_options_start(handle);
+	if (offset == (off_t)-1)
 		return -1;
-	if (out_update_section_header(handle, offset))
+
+	if (do_write_check(handle, buf, len))
 		return -1;
 
-	return 0;
+	return write_options_end(handle, offset);
 }
 
 int tracecmd_write_meta_strings(struct tracecmd_output *handle)
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a6829565a679..e0d2f2b0f554 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -739,8 +739,10 @@ static void tell_guests_to_stop(struct common_record_context *ctx)
 	/* Wait for guests to acknowledge */
 	for_all_instances(instance) {
 		if (is_guest(instance)) {
-			tracecmd_msg_wait_close_resp(instance->msg_handle);
-			tracecmd_msg_handle_close(instance->msg_handle);
+			if (!is_proxy(instance)) {
+				tracecmd_msg_wait_close_resp(instance->msg_handle);
+				tracecmd_msg_handle_close(instance->msg_handle);
+			}
 		}
 	}
 }
@@ -4366,15 +4368,18 @@ static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
+	bool have_proxy = false;
 	bool local = false;
 	int max_cpu_count = local_cpu_count;
 	char **temp_files;
 	int i;
 
 	for_all_instances(instance) {
-		if (is_guest(instance))
+		if (is_guest(instance)) {
 			write_guest_file(instance);
-		else if (host && instance->msg_handle)
+			if (is_proxy(instance))
+				have_proxy = true;
+		} else if (host && instance->msg_handle)
 			finish_network(instance->msg_handle);
 		else
 			local = true;
@@ -4423,6 +4428,22 @@ static void record_data(struct common_record_context *ctx)
 
 		add_options(handle, ctx);
 
+		/*
+		 * If we connected to a proxy, then it will now send us
+		 * the tsync data for our file.
+		 */
+		if (have_proxy) {
+			for_all_instances(instance) {
+				if (!is_proxy(instance))
+					continue;
+				/* Tell proxy we are ready for the rest */
+				tracecmd_msg_cont(instance->msg_handle);
+				tracecmd_msg_read_options(instance->msg_handle, handle);
+				tracecmd_msg_wait_close_resp(instance->msg_handle);
+				tracecmd_msg_handle_close(instance->msg_handle);
+			}
+		}
+
 		/* Only record the top instance under TRACECMD_OPTION_CPUSTAT*/
 		if (!no_top_instance() && !top_instance.msg_handle) {
 			struct trace_seq *s = top_instance.s_save;
@@ -6680,6 +6701,14 @@ static void finalize_record_trace(struct common_record_context *ctx)
 		if (instance->flags & BUFFER_FL_KEEP)
 			write_tracing_on(instance,
 					 instance->tracing_on_init_val);
+		if (is_proxy_server(instance) && instance->network_handle) {
+			/* Now wait for the recorder to be ready for us to send more */
+			tracecmd_msg_wait(ctx->instance->msg_handle);
+			if (ctx->tsc2nsec.mult)
+				add_tsc2nsec(ctx->instance->network_handle, &ctx->tsc2nsec);
+			tracecmd_msg_send_options(ctx->instance->msg_handle,
+						  ctx->instance->network_handle);
+		}
 		if (is_agent(instance)) {
 			tracecmd_msg_send_close_resp_msg(instance->msg_handle);
 			tracecmd_output_close(instance->network_handle);
@@ -6916,6 +6945,10 @@ static void record_trace(int argc, char **argv,
 		wait_threads();
 
 	if (is_proxy_server(ctx->instance) && ctx->instance->network_handle) {
+		tracecmd_tsync_with_guest_stop(ctx->instance->tsync);
+		trace_add_guest_info(ctx->instance->network_handle, ctx->instance);
+		if (ctx->tsc2nsec.mult)
+			add_tsc2nsec(ctx->instance->network_handle, &ctx->tsc2nsec);
 		tracecmd_write_options(ctx->instance->network_handle);
 		tracecmd_write_meta_strings(ctx->instance->network_handle);
 		tracecmd_msg_finish_sending_data(ctx->instance->msg_handle);
-- 
2.35.1

