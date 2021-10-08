Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FDFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60DC861073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhJHEV7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEV6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:21:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEB5C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:04 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d3so3877259edp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bKL2/Cposxb3dIsadfn4WF9XX3PKFPJDvZ8ubuQyOMo=;
        b=ebYtXNtAAnReaEPO/ffNokVoWBE82q6JkkLIywYfSh2OZ2YRzqfXivGp3zgCBOWtUH
         0S0cg0QOnlKLrJS97qSqB5ERLq98YJQ0tCkt7tVgXdy2DvVQ+3Em8eamI7stTrDFzcRs
         2+tTtF/QS35AIP5skP1heNOKpg+zwj/Yz+7NzC4XOItIvOma16B2jOWCBskoKSkUSq/+
         yeD321dXc9eYpfUpZLDAOzwBIS1OSEgrvFiyEstA1xBIZB9AUuOaW9AyUGJJ180orijp
         aHJeFTdOyFFEXwX4Ykom0o1MSjUxrcfbR/iuUCQeS3OXZNkOQJnxS+Ag5iUTEGnbdnhe
         85jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKL2/Cposxb3dIsadfn4WF9XX3PKFPJDvZ8ubuQyOMo=;
        b=fv3rNhIYD6ciXFciJD3ES1Y8rTsQoBhGy7wGIM0T0/ahQdkkSMRZrv/cdDna6vtdPt
         QBZPS/8XBI0IFeMP8IC1mq/1r+hWbHrcMxv3vcZBY/FU3BQluEcn3cT+HfnD10lUbVGF
         F8tM8QSaCTgK+hQKAFlB6LG1oYXN78Mx6MG+3r/XIrRkqiRYwkUupj7fyz2rFCBjf7gk
         zXwJ79XdtkceieZtKkEBWN6grbvzho9Xl+mPBdl+iug/Uod4xJ6y7N4VBFNKVfyGjAmU
         kZHgfVyoqQrDHyvoEBUVoDKqbW/HwO3/ppd/P8qhwmej+6l3eJOU7YYYU5Spdi0nv2Ms
         Wl4w==
X-Gm-Message-State: AOAM530UfFz+fmTBd/s+g45P22yeKoScTsVCd4TgvqMqNxVsgMvcbmCR
        EAJ2YJp0gcqOFSem2z4Rb/G+oW/O/MsGQw==
X-Google-Smtp-Source: ABdhPJymATvsK0dCdz8uK1aI1/I4Y5EUeT1kCAAv0U4ms4YGZsYsXxqp1J8xMqHnr3j5B49yCW73+A==
X-Received: by 2002:a17:906:7632:: with SMTP id c18mr1308350ejn.317.1633666802472;
        Thu, 07 Oct 2021 21:20:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 02/25] trace-cmd library: Add cache functionality to network message handler
Date:   Fri,  8 Oct 2021 07:19:35 +0300
Message-Id: <20211008041958.976309-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index a025c0fa..d65ff599 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -45,5 +45,6 @@ struct cpu_data_source {
 
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
index 6c2f5c18..10e5875f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -94,6 +94,14 @@ do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
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
@@ -953,6 +961,9 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg
 		return -1;
 
 	handler->msg_handle = msg_handle;
+	/* Force messages to be cached in a temp file before sending through the socket */
+	if (handler->msg_handle && HAS_SECTIONS(handler))
+		tracecmd_msg_handle_cache(handler->msg_handle);
 
 	return 0;
 }
@@ -1268,7 +1279,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
@@ -1301,9 +1312,9 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	if (handle->file_state != TRACECMD_FILE_OPTIONS)
 		return -1;
 
-	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
+	if (do_lseek(handle, 0, SEEK_END) == (off_t)-1)
 		return -1;
-	offset = lseek64(handle->fd, -2, SEEK_CUR);
+	offset = do_lseek(handle, -2, SEEK_CUR);
 	if (offset == (off_t)-1)
 		return -1;
 
@@ -1321,7 +1332,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
-		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
 		if (do_write_check(handle, options->data,
 				   options->size))
@@ -1518,10 +1529,10 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
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
@@ -1530,7 +1541,7 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
 		return -1;
 
 	/* Go back to end of file */
-	if (lseek64(handle->fd, current, SEEK_SET) == (off64_t)-1) {
+	if (do_lseek(handle, current, SEEK_SET) == (off64_t)-1) {
 		tracecmd_warning("could not seek to %lld\n", offset);
 		return -1;
 	}
@@ -1579,7 +1590,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 	}
 
-	data_offs = lseek64(handle->fd, 0, SEEK_CUR);
+	data_offs = do_lseek(handle, 0, SEEK_CUR);
 	if (do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
@@ -1594,10 +1605,10 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		 * updated them with the correct data later.
 		 */
 		endian8 = 0;
-		data_files[i].file_data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+		data_files[i].file_data_offset = do_lseek(handle, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
-		data_files[i].file_write_size = lseek64(handle->fd, 0, SEEK_CUR);
+		data_files[i].file_write_size = do_lseek(handle, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 	}
@@ -1608,12 +1619,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-		data_files[i].data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
 		/* Page align offset */
 		data_files[i].data_offset += handle->page_size - 1;
 		data_files[i].data_offset &= !(handle->page_size - 1);
 
-		ret = lseek64(handle->fd, data_files[i].data_offset, SEEK_SET);
+		ret = do_lseek(handle, data_files[i].data_offset, SEEK_SET);
 		if (ret == (off64_t)-1)
 			goto out_free;
 
@@ -1637,21 +1648,21 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		}
 
 		/* Write the real CPU data offset in the file */
-		if (lseek64(handle->fd, data_files[i].file_data_offset, SEEK_SET) == (off64_t)-1)
+		if (do_lseek(handle, data_files[i].file_data_offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		endian8 = convert_endian_8(handle, data_files[i].data_offset);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 
 		/* Write the real CPU data size in the file */
-		if (lseek64(handle->fd, data_files[i].file_write_size, SEEK_SET) == (off64_t)-1)
+		if (do_lseek(handle, data_files[i].file_write_size, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		endian8 = convert_endian_8(handle, data_files[i].write_size);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 
 		offset = data_files[i].data_offset + data_files[i].write_size;
-		if (lseek64(handle->fd, offset, SEEK_SET) == (off64_t)-1)
+		if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 
 		if (!tracecmd_get_quiet(handle))
@@ -1660,7 +1671,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	free(data_files);
-	if (lseek64(handle->fd, 0, SEEK_END) == (off64_t)-1)
+	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
 
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
@@ -1668,7 +1679,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	return 0;
 
  out_free:
-	lseek64(handle->fd, 0, SEEK_END);
+	do_lseek(handle, 0, SEEK_END);
 	free(data_files);
 	return -1;
 }
-- 
2.31.1

