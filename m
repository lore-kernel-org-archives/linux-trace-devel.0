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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4406BC433E9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0644464EFA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZEG7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBZEG6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 23:06:58 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B1EC061786
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:06:18 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id u187so4417874wmg.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7TNZiMUy09SiQrrBsuuff3qdeaYSeaKi1k8Nrc5C6es=;
        b=Q7YDslPQ2Ogdm2Xb8ID7zo7ShxkGJQviJokRUdY8X4b9QYchTHKsUuvzO58rV2nudS
         Evw5Yfw+3DsiB7GXfKJFFgmuxLFp+8ADRsFKK4CLcb6aoGBynN9GuEfD/lEXq85oi9G9
         fbvExwvxgjlRwJFm/G+ao7wxlojVptD+9pHpaHRx1OBKSwLPCS/lqypx4xupdY3AcHQT
         E607ir5cAKjfaPGPMcAdUO6dS+IMyZYI3WRflmr//3O5K91cYUetYvVPx80b1mrTmDH+
         DIcIQtVoCsKjqIr8/gKfo2QVUDRlukOw1n1HsVPkBPhF3ZktYPUX73h4QhLyx8x219Am
         0ywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TNZiMUy09SiQrrBsuuff3qdeaYSeaKi1k8Nrc5C6es=;
        b=cInuZknyMKMXFtgbA6NMF4yoKBSOWMTmMVHC6bYFUbFnJjnWzqS4ZQSGIpp+vq0Ghm
         mD61DdEhYVT3x6+1dUrcim/tgOXFl1IHkAJLunSjhvZErT7Sx+Ud/sZX6DZKfVMMeec7
         jyu6Anfkol9EdaldhZ38X7k2uMFQbAaoTKJ1MVONVBlRvOX/5oajd4S50k8zOVus2n/0
         ty7oNZv8apTCYcOdQoF09biQLRR5rMdFSFyOac9IVZZ3RXzMmomRQkAbNga9xyTCdpi2
         ylAxg10f9erhJw1CkYUOzsAf+G1BIFneLqYU8fJwFweDAI8ORvFp1gudX+rUd7/JQwAh
         JVIA==
X-Gm-Message-State: AOAM531PWgKKVMxD5pQ0GsuZkfM7n/ybg3twqHINa9vN93LGAufvdirL
        Z2rIO1Jm/IChrITyd0om39k=
X-Google-Smtp-Source: ABdhPJzfVbJcHxdJEagWfgVJOBHK8K06+ivI7P0QsL+4SVsIb4QeyEawcHDR7non0U8Y9amJFazOZA==
X-Received: by 2002:a7b:cb98:: with SMTP id m24mr709599wmi.15.1614312377183;
        Thu, 25 Feb 2021 20:06:17 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n1sm12357070wrx.45.2021.02.25.20.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 20:06:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/3] trace-cmd: Fix broken listener and add error checks
Date:   Fri, 26 Feb 2021 06:06:11 +0200
Message-Id: <20210226040611.186037-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210226040611.186037-1-tz.stoyanov@gmail.com>
References: <20210226040611.186037-1-tz.stoyanov@gmail.com>
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

