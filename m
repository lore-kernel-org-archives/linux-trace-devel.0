Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E1FC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D44AB61052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhG2FKN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbhG2FKM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C11C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n2so6355912eda.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLSHwkXPM5e7LU+G0SGg5XyFgz4EHgw5nwwxF8BCeVA=;
        b=Gmf+VCsNQkqxEOKR1micTEcU70CYhmzZKkNeIySu5D8kM6Ef4BZJEEd3cIXgUznGDO
         EpjNUip6htSHS/mLf7X4U1ggZj7vxm7OZx0+b5NY4mmRDXXePrAdt00FCc1yPGSPDRGj
         WBJbiwWRlcKLaNLrRaeBw7u8HUD5TmhSqbeZEF/CKveYpNmY76r0LJiXCBttmOkWmBom
         /v3Aym9LGo7OPDhh1HPnEMsS2EyWN/6X4P8zm+P+/Oz/olszfNXLtfuuIiNntKho0sm0
         5XMF8XRHEB9Mnf8wMQkwV7TdT/0rLA533JTXCZdzxe2ZyQgY+dmRITzVvnAnUhi8EsQc
         GBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLSHwkXPM5e7LU+G0SGg5XyFgz4EHgw5nwwxF8BCeVA=;
        b=JDyebtesSF0dAxEwP72LJZFs0oYi0TpKtSp95WP+ueN7FbaN5MKQIeSNiHfmA6su8y
         b3m70JjxiVqljdGuBtyrVqlwPeZFfjsmtvNFN65+04eLIuuGv9tqcIGcTd32vFYAhhJv
         2KbeBof721b8Glk6fFyPqrqB3NhvLYtSfhExcyWVvoLHLeo3kvOkjEIBSLdC/cvG2lcF
         hKG8jtL0yubYLZJkkZZoGWMzwsSsC81nEVeaqjJ9IcmMDUfama4GOpAcg1ml1mfJ16Mw
         DFmRkYlnwPrK1SuXsenSFFSi/WHLeTJDg7wiitcDpkXbHZPd7XoV/2QVJNAlVE5L3IdE
         NEkg==
X-Gm-Message-State: AOAM5305sXlqwdopFi/X8YProq5w6Lb9PPMgGZkKdd/ABt1FZdN6aaSV
        MyNSCEYPH1ZhkPw68SqSbRCHqgaiGtQSQg==
X-Google-Smtp-Source: ABdhPJyHww56p2MVM7tdfkYqVk5cJ5Udqy7/+uIwQrpQku7G3L/cy5HsxXfdqGXoh/RHg1dZTC7LtA==
X-Received: by 2002:a05:6402:4246:: with SMTP id g6mr3963969edb.134.1627535408590;
        Wed, 28 Jul 2021 22:10:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/87] trace-cmd library: Add cache functionality to network message handler
Date:   Thu, 29 Jul 2021 08:08:39 +0300
Message-Id: <20210729050959.12263-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
The local cahce is flushed on the socket when the
 tracecmd_msg_finish_sending_data()
is called.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   5 +
 lib/trace-cmd/include/trace-cmd-local.h       |   1 +
 lib/trace-cmd/trace-msg.c                     | 131 +++++++++++++-----
 3 files changed, 103 insertions(+), 34 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6440084d..68715580 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -339,12 +339,16 @@ enum tracecmd_msg_flags {
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
+	char			cfile[26]; /* strlen(MSG_CACHE_FILE) */
 };
 
 struct tracecmd_tsync_protos {
@@ -353,6 +357,7 @@ struct tracecmd_tsync_protos {
 
 struct tracecmd_msg_handle *
 tracecmd_msg_handle_alloc(int fd, unsigned long flags);
+int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle);
 
 /* Closes the socket and frees the handle */
 void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 821b5cdb..7691cc05 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -31,5 +31,6 @@ void tracecmd_info(const char *fmt, ...);
 #endif
 #endif
 
+off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 6667028e..e856fb33 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -154,33 +154,54 @@ static inline int msg_buf_len(struct tracecmd_msg *msg)
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
+	/* lseek works only if the handle is in cache mode,
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
@@ -274,11 +295,11 @@ static void msg_free(struct tracecmd_msg *msg)
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
 
@@ -287,11 +308,11 @@ static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
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
 
@@ -454,7 +475,7 @@ static int tracecmd_msg_send_notsupp(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_NOT_SUPP, &msg);
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 static int handle_unexpected_msg(struct tracecmd_msg_handle *msg_handle,
@@ -472,7 +493,6 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 				unsigned int **client_ports)
 {
 	struct tracecmd_msg msg;
-	int fd = msg_handle->fd;
 	unsigned int *ports;
 	int i, cpus, ret;
 	char *p, *buf_end;
@@ -485,13 +505,13 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
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
 
@@ -564,12 +584,57 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 
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
+	}
+	msg_handle->cache = true;
+	return 0;
+}
+
+static int flush_cache(struct tracecmd_msg_handle *msg_handle)
+{
+	char buf[MSG_MAX_DATA_LEN];
+	int ret;
+	int fd;
+
+	if (!msg_handle->cache || msg_handle->cfd < 0)
+		return 0;
+	close(msg_handle->cfd);
+	msg_handle->cfd = -1;
+	fd = open(msg_handle->cfile, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	do {
+		ret = read(fd, buf, MSG_MAX_DATA_LEN);
+		if (ret <= 0)
+			break;
+		ret = tracecmd_msg_data_send(msg_handle, buf, ret);
+		if (ret < 0)
+			break;
+	} while (ret >= 0);
+
+	close(fd);
+	unlink(msg_handle->cfile);
+	return ret;
+}
+
 void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle)
 {
 	close(msg_handle->fd);
+	if (msg_handle->cfd >= 0) {
+		close(msg_handle->cfd);
+		unlink(msg_handle->cfile);
+	}
 	free(msg_handle);
 }
 
@@ -666,7 +731,7 @@ int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		return ret;
 
-	ret = tracecmd_msg_send(msg_handle->fd, &msg);
+	ret = tracecmd_msg_send(msg_handle, &msg);
 	if (ret < 0)
 		return ret;
 
@@ -678,7 +743,7 @@ int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_CLOSE, &msg);
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle)
@@ -686,14 +751,13 @@ int tracecmd_msg_send_close_resp_msg(struct tracecmd_msg_handle *msg_handle)
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
@@ -721,7 +785,7 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			memcpy(msg.buf, buf + count, n);
 			n = 0;
 		}
-		ret = msg_write(fd, &msg);
+		ret = msg_write(msg_handle, &msg);
 		if (ret < 0)
 			break;
 	}
@@ -735,8 +799,10 @@ int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 	struct tracecmd_msg msg;
 	int ret;
 
+	flush_cache(msg_handle);
+	msg_handle->cache = false;
 	tracecmd_msg_init(MSG_FIN_DATA, &msg);
-	ret = tracecmd_msg_send(msg_handle->fd, &msg);
+	ret = tracecmd_msg_send(msg_handle, &msg);
 	if (ret < 0)
 		return ret;
 	return 0;
@@ -752,10 +818,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
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
 
@@ -959,7 +1022,7 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		return ret;
 
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 static int get_trace_req_protos(char *buf, int length,
@@ -1151,7 +1214,7 @@ int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
 	msg.hdr.size = htonl(ntohl(msg.hdr.size) + payload_size);
 
 	msg.buf = payload;
-	return msg_send_nofree(msg_handle->fd, &msg);
+	return msg_send_nofree(msg_handle, &msg);
 }
 
 /**
@@ -1283,7 +1346,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		return ret;
 
-	return tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle, &msg);
 }
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
-- 
2.31.1

