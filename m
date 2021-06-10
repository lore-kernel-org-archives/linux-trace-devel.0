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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37607C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2177E61406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhFJLgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhFJLgw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:52 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCEBC061760
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:44 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l2so1908611wrw.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=il8iUhJksidiq3MngizPXyhw7RHXGLQZpoprRtC3+P0=;
        b=osvaI1f+k6ZNt0oIgjOnkXOX6b0UsQqwCArtOdq3nTgX+/cmkvWicBT9vH4Q8BEDZF
         wsDwOVQ8xpVTwBFq4nqnBhNn9T9crMk0sDJioH8RFgWQ7l6YgaD67G1yPcgiwBRQNJyD
         I6JP0sdcqnHod0J3NsDJ+IJo9wF3z9Rn8X4UQPA8XVOsyDqZnc/AB9WPEhE0K92f+1F4
         tC8VyDsCNXflVNV0Z28G/p+8iO3q8Hz/JoFfGscooJzzOkrvihi4cjIsI0FXRHOOVxzQ
         huPsA0LBcpwVw7wYgHRpo/SaXXze9uF+wPVzXL9/SzeYg6c6WLU33sVSfflor7bnvBWm
         lUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=il8iUhJksidiq3MngizPXyhw7RHXGLQZpoprRtC3+P0=;
        b=fNSiPzZqB+aFwky8rvAvO0DTk0FhoD/GWRNW06UMmPUsPkEuo/hDrDzCE/wzdaIYXK
         A0iNQ3T4TW3+1z9ZXcH92uA5sgrbg7HotcrNAcH27KVYlxU9UPSmSMuLWRYfFJ5Zmjzr
         YDZ9By19l+1M0S9WES21Pq6tbMNv1yOvb1CgLiRLo34hlXMrKx1miHWBL7Far8heibWB
         32X8Bg0g6VHjGZ5VFpHNPd4w/FvMZ9QZc4xcYtr8GL4cQ8gpfDxIgZC+uqmmjN93xsq7
         Gz+8ZpYQSa+yTPn4jUojtj61ZPRbl9xVpltGdMCtuvrWMvbEDDjNn+EpYbDv7Kx5xIdz
         A8Eg==
X-Gm-Message-State: AOAM533IL2GzufJVi5eJvB2bqEYw26ikIgPbKHgGdJrRtC1vqWcceic+
        UlHD9hMEsT3j1uAleZUDUDM=
X-Google-Smtp-Source: ABdhPJzs8AWXxbHqCiQGl+aIpK+rnxjbz1FgVY2MpWZjENBCIebmWCgJgyj3WHgOqoo5CExb0ZXuYQ==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr4786638wrs.397.1623324881014;
        Thu, 10 Jun 2021 04:34:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 13/40] trace-cmd library: Inherit compression algorithm from input file
Date:   Thu, 10 Jun 2021 14:33:59 +0300
Message-Id: <20210610113426.257931-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace file output handler is allocated, based on given trace
file input handler - use the same compression algorithm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 0d89fe13..172462e7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -980,17 +980,27 @@ out_free:
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (ihandle) {
 		handle->file_version = tracecmd_get_in_file_version(ihandle);
-	} else {
-		handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
-							   handle->pevent, handle->msg_handle);
-		if (handle->compress)
-			handle->file_version = 7;
-		else
-			handle->file_version = 6;
+		if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+			handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+								   handle->pevent, handle->msg_handle);
+			if (!handle->compress)
+				return -1;
+		}
+		return 0;
 	}
 
+	handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
+						   handle->pevent, handle->msg_handle);
+	if (handle->compress)
+		handle->file_version = 7;
+	else
+		handle->file_version = 6;
+
 	return 0;
 }
 
@@ -1645,6 +1655,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -1682,6 +1694,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	list_head_init(&handle->options);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							   handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			goto out_free;
+	}
 	tracecmd_close(ihandle);
 
 	return handle;
-- 
2.31.1

