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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32D4C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 04:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA2264DF3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 04:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhBQE0x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Feb 2021 23:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhBQEY2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Feb 2021 23:24:28 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FD4C0613D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Feb 2021 20:23:46 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ly28so117937ejb.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Feb 2021 20:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43uPqi0qhMof7A+OmJzUTHbF/DZogLQi+QqDy/jHdXU=;
        b=nUD8yvaTpVOyBfdC4a8vvad6BAnn8Li0AeqychuTsxDNYw/p9h/ajw6cI96Pc+hNDE
         7wSRfFPcSuO+eujLW6A9bvqtVmFCuZPnBe2pumlFjN/FHcFg/yR+xgLi0Fo9AqwgVLpO
         BfS+JHpc5BZZ9o9AAPjNoNbx19mWBmexX8eTteRaE9dqk+tF+gynP2pppjSoM3XGqBKj
         iwgX7BkZsViZgmQ1nsOVUacF54t+sZGR9fY+R42MdW1o/XvZO5BLRQGf7jikyGvht5oW
         Ghqr4E8oY3mWByB/3uecTiper/eQ0g3MPIC4kzzyf8xFb3sf+/pqRUzXG/ay5FBI4kzH
         kdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43uPqi0qhMof7A+OmJzUTHbF/DZogLQi+QqDy/jHdXU=;
        b=K+TlcozDXEqNAypSQrQGCg0JF6UMKLSCFoydthMJElWRcHj+OLvsxy6OdrGAfmfQ+1
         I3CM32PTt5q6oQbgpYKkcA/vNYwspLTiFyNEyZpBcmTdSovqOLc6z2ZdcshMkT9GtU96
         OIJCoOqfV9wWVtf5M0UIj9/tCtUZnerhfuZLfpwnDB/TfFZGRNN4BCt1xVi1cOzRr0qd
         yFWfT9Dv7VXnWrC3DmG9fbzeITSdXjHCfdkuohB9MxRkMwf/Q7YW4IhpOppF1qiRh3KI
         VaMOKVdqKBnJ6wm09CTYGWI2TEHeh85EThh0xUvTvzlUvfnX4oQ0yAO76mdi8xPzVFXE
         nywA==
X-Gm-Message-State: AOAM530NViqNJrmvnnz8NP5BEKzeuWjzThuf3plI238+YDZ8PsanMjcI
        /9uzO0gp5Xhh8YckpcQiDpk=
X-Google-Smtp-Source: ABdhPJzI0svG0Sf/9BYauFMkUZ7ucCGhqSGcQz3fme95wWvhzkmL3ImO+C4EmMegPEMtxiyNAKn4Yw==
X-Received: by 2002:a17:906:5195:: with SMTP id y21mr266286ejk.345.1613535825576;
        Tue, 16 Feb 2021 20:23:45 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cb21sm389698edb.57.2021.02.16.20.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 20:23:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Fix broken listener and add error checks
Date:   Wed, 17 Feb 2021 06:23:41 +0200
Message-Id: <20210217042341.1675546-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-listen.c | 22 ++++++++++++++--------
 tracecmd/trace-record.c | 31 ++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 7798fe4f..ecad7656 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -597,8 +597,12 @@ static int put_together_file(int cpus, int ofd, const char *node,
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
 
@@ -634,11 +638,12 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	stop_msg_handle = msg_handle;
 
 	/* Now we are ready to start reading data from the client */
-	if (msg_handle->version == V3_PROTOCOL)
-		tracecmd_msg_collect_data(msg_handle, ofd);
-	else
+	if (msg_handle->version == V3_PROTOCOL) {
+		ret = tracecmd_msg_collect_data(msg_handle, ofd);
+	} else {
 		collect_metadata_from_client(msg_handle, ofd);
-
+		ret = 0;
+	}
 	stop_msg_handle = NULL;
 
 	/* wait a little to let our readers finish reading */
@@ -652,8 +657,9 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
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

