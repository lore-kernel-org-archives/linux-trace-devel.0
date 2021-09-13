Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6670CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3747360F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbhIMMbJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbhIMMbI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:08 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1020AC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:53 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso6832775wmb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=czs8Tjr76YnWmBz1OT34H4FnprR/TGOXcUlj3hBJRkM=;
        b=gg21zPomw25NfdvWxhvHAZyfWeIhRPxEl078g7SKRBbr42OO6MUCXILo8XRBYyiecE
         JhZ/xwem4W1G0fTWMILBbYXckWV7tAsUM8F6+B1hYzxX+zCp/OuErWIs3D5vOBQuvwu/
         dJjmljnCA4msQMiUYz9ciYI8ZV2zVIzcFGvd/zUHphFi/D/7sdxEbggYOMYHJInfo/VU
         1nd0Z57oPCK7au/2YYap46qMJ6Cdlqc8AY/Lq95gl6dWgCQgGlJ/fuKkPlYq+Q9WW1C3
         xQPvGUlZJM127ShEXmUhZ7/w9I4Jfm5HdpViDY0a4WKNXNrfPHFvkF07WkXo3l9vGWva
         wGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=czs8Tjr76YnWmBz1OT34H4FnprR/TGOXcUlj3hBJRkM=;
        b=hTUWQgkoeIy3Wi5qIV6jl4oRCvlixTi33XeoCa2sln1/cDlElzuVagxwrN/9lzyU1h
         h5A9otYBipb2xmoT1vuq7eVdZ3Nv4kGKAiWm3EEfw3eB1jAKkP7NBtTNmfFIS+xWo3ZP
         MiHAGpeu2WNLfvpDMphH3iCK/u3j4RKPglucG/QIwCU2S8744bQRxNY/jlwEfwtvMltf
         FLNOfww1ZgUn3n6NS4cBQ7S4T4BJny+aQd4yymoAG7EIvQnURDabRYGuZ0ZfHlvLf6vl
         dMrwG9efejUsz4tqrySuN3a7MPeATu8li/JoqgHzfMHmL/qMMTKtVCZBkKluQL+oq7bc
         UOdQ==
X-Gm-Message-State: AOAM530aondRtwDLHLgoVkp4XSpSySsRujv/oOUeXMczboVS3KjKASEy
        5avhFAMb8j3S+8Jz5b0lKgXE3sROodg=
X-Google-Smtp-Source: ABdhPJwcXEDgc69mGc/2wiYHFjjolga6WpcYorIdGk5oEMhufzvQcpIT4qIfOlp1PaTUtXd7gPln/Q==
X-Received: by 2002:a7b:c408:: with SMTP id k8mr10623912wmi.184.1631536191584;
        Mon, 13 Sep 2021 05:29:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/25] trace-cmd library: Add cache functionality to network message handler
Date:   Mon, 13 Sep 2021 15:29:24 +0300
Message-Id: <20210913122947.3673239-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Network message handler is used to send trace metadata through a network
socket, instead writing it into a trace file. There are use cases,
that could require to do a lseek() on the metadata. It is hard to
implement lseek on a network socket, that's why for such use cases a
cache to a local file is introduced. Once the metadata is constructed,
the local cache is send to the socket. A new library API is used to
enable the local cache:
 tracecmd_msg_handle_cache()
The local cache is flushed on the socket when the
 tracecmd_msg_finish_sending_data()
is called.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   5 +
 lib/trace-cmd/include/trace-cmd-local.h       |   1 +
 lib/trace-cmd/trace-msg.c                     | 127 +++++++++++++-----
 lib/trace-cmd/trace-output.c                  |  45 ++++---
 4 files changed, 127 insertions(+), 51 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index e21bc3bf..460f8a5d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -344,12 +344,16 @@ enum tracecmd_msg_flags {
 };
 
 /* for both client and server */
+#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
 struct tracecmd_msg_handle {
 	int			fd;
 	short			cpu_count;
 	short			version;	/* Current protocol version */
 	unsigned long		flags;
 	bool			done;
+	bool			cache;
+	int			cfd;
+	char			cfile[sizeof(MSG_CACHE_FILE)];
 };
 
 struct tracecmd_tsync_protos {
@@ -358,6 +362,7 @@ struct tracecmd_tsync_protos {
 
 struct tracecmd_msg_handle *
 tracecmd_msg_handle_alloc(int fd, unsigned long flags);
+int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle);
 
 /* Closes the socket and frees the handle */
 void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index e11dce58..362b9fc0 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -43,5 +43,6 @@ struct cpu_data_source {
 
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
+off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 6667028e..4910ed5c 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -154,33 +154,55 @@ static inline int msg_buf_len(struct tracecmd_msg *msg)
 	return ntohl(msg->hdr.size) - MSG_HDR_LEN - ntohl(msg->hdr.cmd_size);
 }
 
-static int msg_write(int fd, struct tracecmd_msg *msg)
+static int __msg_write(int fd, struct tracecmd_msg *msg, bool network)
 {
-	int cmd = ntohl(msg->hdr.cmd);
 	int msg_size, data_size;
 	int ret;
-
-	if (cmd < 0 || cmd >= MSG_NR_COMMANDS)
-		return -EINVAL;
-
-	dprint("msg send: %d (%s) [%d]\n",
-	       cmd, cmd_to_name(cmd), ntohl(msg->hdr.size));
-
+	int cmd;
+
+	if (network) {
+		cmd = ntohl(msg->hdr.cmd);
+		if (cmd < 0 || cmd >= MSG_NR_COMMANDS)
+			return -EINVAL;
+		dprint("msg send: %d (%s) [%d]\n",
+		       cmd, cmd_to_name(cmd), ntohl(msg->hdr.size));
+	}
 	msg_size = MSG_HDR_LEN + ntohl(msg->hdr.cmd_size);
 	data_size = ntohl(msg->hdr.size) - msg_size;
 	if (data_size < 0)
 		return -EINVAL;
 
-	ret = __do_write_check(fd, msg, msg_size);
-	if (ret < 0)
-		return ret;
-
+	if (network) {
+		ret = __do_write_check(fd, msg, msg_size);
+		if (ret < 0)
+			return ret;
+	}
 	if (!data_size)
 		return 0;
 
 	return __do_write_check(fd, msg->buf, data_size);
 }
 
+__hidden off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off64_t offset, int whence)
+{
+	/*
+	 * lseek works only if the handle is in cache mode,
+	 * cannot seek on a network socket
+	 */
+	if (!msg_handle->cache || msg_handle->cfd < 0)
+		return (off64_t)-1;
+	return lseek64(msg_handle->cfd, offset, whence);
+}
+
+static int msg_write(struct tracecmd_msg_handle *msg_handle, struct tracecmd_msg *msg)
+{
+	if (msg_handle->cache && msg_handle->cfd >= 0)
+		return __msg_write(msg_handle->cfd, msg, false);
+
+
+	return __msg_write(msg_handle->fd, msg, true);
+}
+
 enum msg_trace_flags {
 	MSG_TRACE_USE_FIFOS = 1 << 0,
 };
@@ -274,11 +296,11 @@ static void msg_free(struct tracecmd_msg *msg)
 	memset(msg, 0, sizeof(*msg));
 }
 
-static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
+static int tracecmd_msg_send(struct tracecmd_msg_handle *msg_handle, struct tracecmd_msg *msg)
 {
 	int ret = 0;
 
-	ret = msg_write(fd, msg);
+	ret = msg_write(msg_handle, msg);
 	if (ret < 0)
 		ret = -ECOMM;
 
@@ -287,11 +309,11 @@ static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
 	return ret;
 }
 
-static int msg_send_nofree(int fd, struct tracecmd_msg *msg)
+static int msg_send_nofree(struct tracecmd_msg_handle *msg_handle, struct tracecmd_msg *msg)
 {
 	int ret = 0;
 
-	ret = msg_write(fd, msg);
+	ret = msg_write(msg_handle, msg);
 	if (ret < 0)
 		ret = -ECOMM;
 
@@ -454,7 +476,7 @@ static int tracecmd_msg_send_notsupp(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_NOT_SUPP, &msg);
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 static int handle_unexpected_msg(struct tracecmd_msg_handle *msg_handle,
@@ -472,7 +494,6 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 				unsigned int **client_ports)
 {
 	struct tracecmd_msg msg;
-	int fd = msg_handle->fd;
 	unsigned int *ports;
 	int i, cpus, ret;
 	char *p, *buf_end;
@@ -485,13 +506,13 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		goto out;
 
-	ret = tracecmd_msg_send(fd, &msg);
+	ret = tracecmd_msg_send(msg_handle, &msg);
 	if (ret < 0)
 		goto out;
 
 	msg_free(&msg);
 
-	ret = tracecmd_msg_wait_for_msg(fd, &msg);
+	ret = tracecmd_msg_wait_for_msg(msg_handle->fd, &msg);
 	if (ret < 0)
 		goto out;
 
@@ -564,12 +585,53 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 
 	handle->fd = fd;
 	handle->flags = flags;
+	handle->cfd = -1;
+	handle->cache = false;
 	return handle;
 }
 
+int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
+{
+	if (msg_handle->cfd < 0) {
+		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
+		msg_handle->cfd = mkstemp(msg_handle->cfile);
+		if (msg_handle->cfd < 0)
+			return -1;
+		unlink(msg_handle->cfile);
+	}
+	msg_handle->cache = true;
+	return 0;
+}
+
+static int flush_cache(struct tracecmd_msg_handle *msg_handle)
+{
+	char buf[MSG_MAX_DATA_LEN];
+	int ret;
+
+	if (!msg_handle->cache || msg_handle->cfd < 0)
+		return 0;
+	msg_handle->cache = false;
+	if (lseek64(msg_handle->cfd, 0, SEEK_SET) == (off64_t)-1)
+		return -1;
+	do {
+		ret = read(msg_handle->cfd, buf, MSG_MAX_DATA_LEN);
+		if (ret <= 0)
+			break;
+		ret = tracecmd_msg_data_send(msg_handle, buf, ret);
+		if (ret < 0)
+			break;
+	} while (ret >= 0);
+
+	close(msg_handle->cfd);
+	msg_handle->cfd = -1;
+	return ret;
+}
+
 void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle)
 {
 	close(msg_handle->fd);
+	if (msg_handle->cfd >= 0)
+		close(msg_handle->cfd);
 	free(msg_handle);
 }
 
@@ -666,7 +728,7 @@ int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		return ret;
 
-	ret = tracecmd_msg_send(msg_handle->fd, &msg);
+	ret = tracecmd_msg_send(msg_handle, &msg);
 	if (ret < 0)
 		return ret;
 
@@ -678,7 +740,7 @@ int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_CLOSE, &msg);
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle)
@@ -686,14 +748,13 @@ int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_CLOSE_RESP, &msg);
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			   const char *buf, int size)
 {
 	struct tracecmd_msg msg;
-	int fd = msg_handle->fd;
 	int n;
 	int ret;
 	int count = 0;
@@ -721,7 +782,7 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			memcpy(msg.buf, buf + count, n);
 			n = 0;
 		}
-		ret = msg_write(fd, &msg);
+		ret = msg_write(msg_handle, &msg);
 		if (ret < 0)
 			break;
 	}
@@ -735,8 +796,9 @@ int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 	int ret;
 
+	flush_cache(msg_handle);
 	tracecmd_msg_init(MSG_FIN_DATA, &msg);
-	ret = tracecmd_msg_send(msg_handle->fd, &msg);
+	ret = tracecmd_msg_send(msg_handle, &msg);
 	if (ret < 0)
 		return ret;
 	return 0;
@@ -752,10 +814,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 	while (!tracecmd_msg_done(msg_handle)) {
 		ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 		if (ret < 0) {
-			if (ret == -ETIMEDOUT)
-				tracecmd_warning("Connection timed out\n");
-			else
-				tracecmd_warning("reading client");
+			tracecmd_warning("reading client %d (%s)", ret, strerror(ret));
 			return ret;
 		}
 
@@ -959,7 +1018,7 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		return ret;
 
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 static int get_trace_req_protos(char *buf, int length,
@@ -1151,7 +1210,7 @@ int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
 	msg.hdr.size = htonl(ntohl(msg.hdr.size) + payload_size);
 
 	msg.buf = payload;
-	return msg_send_nofree(msg_handle->fd, &msg);
+	return msg_send_nofree(msg_handle, &msg);
 }
 
 /**
@@ -1283,7 +1342,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		return ret;
 
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f9c0515d..118aa581 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -95,6 +95,14 @@ do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 	return __do_write_check(handle->fd, data, size);
 }
 
+static inline off64_t do_lseek(struct tracecmd_output *handle, off_t offset, int whence)
+{
+	if (handle->msg_handle)
+		return msg_lseek(handle->msg_handle, offset, whence);
+	else
+		return lseek64(handle->fd, offset, whence);
+}
+
 static short convert_endian_2(struct tracecmd_output *handle, short val)
 {
 	if (!handle->pevent)
@@ -957,6 +965,9 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg
 		return -1;
 
 	handler->msg_handle = msg_handle;
+	/* Force messages to be cached in a temp file before sending through the socket */
+	if (handler->msg_handle && HAS_SECTIONS(handler))
+		tracecmd_msg_handle_cache(handler->msg_handle);
 
 	return 0;
 }
@@ -1276,7 +1287,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
@@ -1309,9 +1320,9 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	if (handle->file_state != TRACECMD_FILE_OPTIONS)
 		return -1;
 
-	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
+	if (do_lseek(handle, 0, SEEK_END) == (off_t)-1)
 		return -1;
-	offset = lseek64(handle->fd, -2, SEEK_CUR);
+	offset = do_lseek(handle, -2, SEEK_CUR);
 	if (offset == (off_t)-1)
 		return -1;
 
@@ -1329,7 +1340,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
@@ -1522,10 +1533,10 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
 		tracecmd_warning("Cannot find description for buffer %s\n", name);
 		return -1;
 	}
-	current = lseek64(handle->fd, 0, SEEK_CUR);
+	current = do_lseek(handle, 0, SEEK_CUR);
 
 	/* Go to the option data, where will write the offest */
-	if (lseek64(handle->fd, b_offset, SEEK_SET) == (off64_t)-1) {
+	if (do_lseek(handle, b_offset, SEEK_SET) == (off64_t)-1) {
 		tracecmd_warning("could not seek to %lld\n", b_offset);
 		return -1;
 	}
@@ -1534,7 +1545,7 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
 		return -1;
 
 	/* Go back to end of file */
-	if (lseek64(handle->fd, current, SEEK_SET) == (off64_t)-1) {
+	if (do_lseek(handle, current, SEEK_SET) == (off64_t)-1) {
 		tracecmd_warning("could not seek to %lld\n", offset);
 		return -1;
 	}
@@ -1583,7 +1594,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 	}
 
-	data_offs = lseek64(handle->fd, 0, SEEK_CUR);
+	data_offs = do_lseek(handle, 0, SEEK_CUR);
 	if (do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
@@ -1595,10 +1606,10 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		data_files[i].file_size = data[i].size;
 		/* Write 0 for trace data offset and size and store offsets of these fields */
 		endian8 = 0;
-		data_files[i].doffset = lseek64(handle->fd, 0, SEEK_CUR);
+		data_files[i].doffset = do_lseek(handle, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
-		data_files[i].soffset = lseek64(handle->fd, 0, SEEK_CUR);
+		data_files[i].soffset = do_lseek(handle, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 	}
@@ -1608,10 +1619,10 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (clock && save_clock(handle, clock))
 		goto out_free;
 	for (i = 0; i < cpus; i++) {
-		data_files[i].data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
 		/* Page align offset */
 		data_files[i].data_offset = (data_files[i].data_offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
-		data_files[i].data_offset = lseek64(handle->fd, data_files[i].data_offset, SEEK_SET);
+		data_files[i].data_offset = do_lseek(handle, data_files[i].data_offset, SEEK_SET);
 		if (data_files[i].data_offset == (off64_t)-1)
 			goto out_free;
 		if (!tracecmd_get_quiet(handle))
@@ -1633,26 +1644,26 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		}
 
 		/* Write the real CPU data offset in the file */
-		if (lseek64(handle->fd, data_files[i].doffset, SEEK_SET) == (off64_t)-1)
+		if (do_lseek(handle, data_files[i].doffset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		endian8 = convert_endian_8(handle, data_files[i].data_offset);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 		/* Write the real CPU data size in the file */
-		if (lseek64(handle->fd, data_files[i].soffset, SEEK_SET) == (off64_t)-1)
+		if (do_lseek(handle, data_files[i].soffset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		endian8 = convert_endian_8(handle, data_files[i].write_size);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 		offset = data_files[i].data_offset + data_files[i].write_size;
-		if (lseek64(handle->fd, offset, SEEK_SET) == (off64_t)-1)
+		if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
 				(unsigned long long)data_files[i].write_size);
 	}
 
-	if (lseek64(handle->fd, 0, SEEK_END) == (off64_t)-1)
+	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		goto out_free;
 
 	free(data_files);
@@ -1661,7 +1672,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	return 0;
 
  out_free:
-	lseek64(handle->fd, 0, SEEK_END);
+	do_lseek(handle, 0, SEEK_END);
 	free(data_files);
 	return -1;
 }
-- 
2.31.1

