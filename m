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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E087C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 05:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34AA064DA1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 05:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbhBSFcq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 00:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBSFco (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 00:32:44 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3028CC061786
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 21:32:04 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c6so7704018ede.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 21:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7TNZiMUy09SiQrrBsuuff3qdeaYSeaKi1k8Nrc5C6es=;
        b=ZUlBmhGiHqW1aRKAxISJNvVqY0HuEkAT+osKtPk8OVesCY2k3yaQxbbAKVoJ9FzSAE
         6MjP/UYRm6LwsCL6HI/OWCmoXydk3lG9WnI1lyCh9NMdvOUU+tzcV3JEawEE1qfLKy2M
         IYImQfCBPxzdumnkjd1Svb4o1IdT+rcQL3dHE4vYrVbtbG/AOucSwgSDiGED7vNJro4Q
         n02BLWsslKCm+B1E2DYHm7jWOcQJMZorkuDHmLV4l5b8Sk5inm7bca73P60zLBWOKlpf
         MPb8tz2P6RjnpjkxgBpCqC0LtE4vyec+614T2jaDLEVyybC6PjfMyLzzc8p/KTm4kSmR
         LNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TNZiMUy09SiQrrBsuuff3qdeaYSeaKi1k8Nrc5C6es=;
        b=nChGKABr+kKz6t4ywnb6ASPZqcuUsxb9YL5x65drfdwPca0RrguiQkZAQngH5C6eRr
         ntCWCk4VFTMizScBTbSMtkHWJyRsmQo1bKQE8cT6SKyodE1lUIkIC6v1ft4NIqDhgVRg
         bs5MBLNND6zNFbP/UM9IPo3r9DDTeq1VL+aa7SbHMqlA55c2MLESvnvHn7AoZIrtxDX0
         ZsRGx8kK6NSC1apMhTgoePpOrtBiDfsdfXUEa2Bp6trvaeInpnPc1eudetDfwRWgdv9q
         yVxdCTqmXLiA2Oi1qYpbYi1Q/5tSu9oMXZ3dwnxbnJBk2HgPBjRJf6F/IXQA67IL1nLZ
         Yp+w==
X-Gm-Message-State: AOAM533crSNyFf/MVAPUSXIW8W9mTTjkWsoO6joIh4YS8vqK3TQNWmP5
        0tPYOaKN2gnApfUoZJIWwMdwMd+6VFTUhA==
X-Google-Smtp-Source: ABdhPJwm4bQRAPPDNNm8jTRsbMti22ZuIu3sVp9JgRQxgj+8vCh1Jkfrvn4qkVVKYIHx7GaiixzZjw==
X-Received: by 2002:aa7:dc4e:: with SMTP id g14mr7518351edu.7.1613712721832;
        Thu, 18 Feb 2021 21:32:01 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id bm2sm3752883ejb.87.2021.02.18.21.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 21:32:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] trace-cmd: Fix broken listener and add error checks
Date:   Fri, 19 Feb 2021 07:31:56 +0200
Message-Id: <20210219053156.2235035-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
References: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd listener was broken by recent changes in writing saved
command lines in the trace file. There was no error checking in that
flow, so the trace-cmd listener indicates successful trace session,
even though the output trace file was broken.
Fixed the listener logic and added more error checks.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-listen.c | 30 ++++++++++++++++++++----------
 tracecmd/trace-record.c | 31 ++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 7798fe4f..0ae1c948 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -531,20 +531,22 @@ static int *create_all_readers(const char *node, const char *port,
 	return NULL;
 }
 
-static void
+static int
 collect_metadata_from_client(struct tracecmd_msg_handle *msg_handle,
 			     int ofd)
 {
 	char buf[BUFSIZ];
 	int n, s, t;
 	int ifd = msg_handle->fd;
+	int ret = 0;
 
 	do {
 		n = read(ifd, buf, BUFSIZ);
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
-			pdie("reading client");
+			ret = -errno;
+			break;
 		}
 		t = n;
 		s = 0;
@@ -553,12 +555,16 @@ collect_metadata_from_client(struct tracecmd_msg_handle *msg_handle,
 			if (s < 0) {
 				if (errno == EINTR)
 					break;
-				pdie("writing to file");
+				ret = -errno;
+				goto out;
 			}
 			t -= s;
 			s = n - t;
 		} while (t);
 	} while (n > 0 && !tracecmd_msg_done(msg_handle));
+
+out:
+	return ret;
 }
 
 static void stop_all_readers(int cpus, int *pid_array)
@@ -597,8 +603,12 @@ static int put_together_file(int cpus, int ofd, const char *node,
 	}
 
 	if (write_options) {
-		tracecmd_write_cpus(handle, cpus);
-		tracecmd_write_options(handle);
+		ret = tracecmd_write_cpus(handle, cpus);
+		if (ret)
+			goto out;
+		ret = tracecmd_write_options(handle);
+		if (ret)
+			goto out;
 	}
 	ret = tracecmd_write_cpu_data(handle, cpus, temp_files);
 
@@ -635,10 +645,9 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 
 	/* Now we are ready to start reading data from the client */
 	if (msg_handle->version == V3_PROTOCOL)
-		tracecmd_msg_collect_data(msg_handle, ofd);
+		ret = tracecmd_msg_collect_data(msg_handle, ofd);
 	else
-		collect_metadata_from_client(msg_handle, ofd);
-
+		ret = collect_metadata_from_client(msg_handle, ofd);
 	stop_msg_handle = NULL;
 
 	/* wait a little to let our readers finish reading */
@@ -652,8 +661,9 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	/* wait a little to have the readers clean up */
 	sleep(1);
 
-	ret = put_together_file(cpus, ofd, node, port,
-				msg_handle->version < V3_PROTOCOL);
+	if (!ret)
+		ret = put_together_file(cpus, ofd, node, port,
+					msg_handle->version < V3_PROTOCOL);
 
 	destroy_all_readers(cpus, pid_array, node, port);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9396042d..f6131692 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3590,22 +3590,36 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 static struct tracecmd_msg_handle *
 setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
 {
-	struct tracecmd_msg_handle *msg_handle;
-	struct tracecmd_output *network_handle;
+	struct tracecmd_msg_handle *msg_handle = NULL;
+	struct tracecmd_output *network_handle = NULL;
+	int ret;
 
 	msg_handle = setup_network(instance);
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		if (!network_handle)
+			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
 		add_options(network_handle, ctx);
-		tracecmd_write_cpus(network_handle, instance->cpu_count);
-		tracecmd_write_options(network_handle);
-		tracecmd_msg_finish_sending_data(msg_handle);
+		ret = tracecmd_write_cmdlines(network_handle);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_cpus(network_handle, instance->cpu_count);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_options(network_handle);
+		if (ret)
+			goto error;
+		ret = tracecmd_msg_finish_sending_data(msg_handle);
+		if (ret)
+			goto error;
 	} else {
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
 							      listed_events);
+		if (!network_handle)
+			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
 	}
 
@@ -3613,6 +3627,13 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* OK, we are all set, let'r rip! */
 	return msg_handle;
+
+error:
+	if (msg_handle)
+		tracecmd_msg_handle_close(msg_handle);
+	if (network_handle)
+		tracecmd_output_close(network_handle);
+	return NULL;
 }
 
 static void finish_network(struct tracecmd_msg_handle *msg_handle)
-- 
2.29.2

