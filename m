Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4C0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbhLJLD1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240113AbhLJLD0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:26 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA29EC0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:51 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w1so28500707edc.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rGybjosqsQwLOzfXnuAsdnckYzIGrHvfQXkGG/d0SNw=;
        b=cmdBf8O9uCMAXiuy6zPyantu0rOXQwbbSzA96rQLtwd8WeJnAODC+7culUssoumv//
         uHE0Z7zZp5b1fdiEIbv1a3jKRmbxJItqdCMzqSX1LIJlVshajsfkLXZmWrqrhZJ9pNWM
         IeodZ89VN6QrAcewbo+tIeSWeg0uOcHjEfAGaFZ9wNaRh/SYm8xemxLdLvBGY9DtHdqe
         9ur5XjFXaYRwsRAizD44A+6HcXPkHRm8/aXksqUY+NnawbVLRwsbnD7MPXaYtahs+1yv
         TJV1CzcI6kYaBY8zEGr9+u/y4r/WeykAzUl+6xJQ3ujq+7VR7BvMe3d0B6m+iVrohc8b
         z0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rGybjosqsQwLOzfXnuAsdnckYzIGrHvfQXkGG/d0SNw=;
        b=BlLTyyRoMkTUEUIT5fyBS/wn5R3fPD/7NW7AdQrrfHh5scVzTQAUWAGr+n1dV1npTw
         8Bpo87mBB8GBJiIlyACasChk0yvddMMwYiiMxKkW/VVKc2HHHszIbADCnP5Gko8gVVg3
         Zl66cr7u6fEZRdAjW5axtUls67tLcOgGYKxNw4MY67B5ClWp4YYPo23CaczOyYhAMWWk
         4QC4yD65EwWGrY5EwOf7nYRf0ZHFEfiumhJL2f80XXbf4FcyPBwkZxsNopsShnlocivD
         kf2jpqbuXmmodbqZUcEmeTvIK4H1EZSnaBciRPH/uqPQE7LjLqA5HIBEryoZeUlI1ugG
         OK8A==
X-Gm-Message-State: AOAM531qR5RWTq3nqZmedB6CNlnVqlmTMXRm2ihofIYXWJrVRcBS5zF/
        Vw8BU7N85CkhGLLrpWsBhdzXBxUt1SA=
X-Google-Smtp-Source: ABdhPJw8ac+0k6EY1xum239HnAiblBfpyCeB8ddxcO3KV/VYpnxf3NEvpvYmvPhcd3klyyOw1J+xvQ==
X-Received: by 2002:a17:906:f0d4:: with SMTP id dk20mr22947690ejb.257.1639133989495;
        Fri, 10 Dec 2021 02:59:49 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:49 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 11/20] trace-cmd library: Read compression header
Date:   Fri, 10 Dec 2021 12:59:29 +0200
Message-Id: <20211210105938.98250-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 introduced new mandatory compression header,
storing information about the compression algorithm used to compress the
trace file. Added code to read that header and to initialize compression
context according to it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f35b61ce..78271fdf 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -193,6 +193,7 @@ __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
 #define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
+#define HAS_COMPRESSION(H) ((H)->flags & TRACECMD_FL_COMPRESSION)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -3838,7 +3839,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3876,9 +3879,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	}
 	handle->file_version = ver;
 	free(version);
+	version = NULL;
 
 	if (handle->file_version >= FILE_VERSION_SECTIONS)
 		handle->flags |= TRACECMD_FL_SECTIONED;
+	if (handle->file_version >= FILE_VERSION_COMPRESSION)
+		handle->flags |= TRACECMD_FL_COMPRESSION;
 
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
@@ -3908,6 +3914,26 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
 	lseek64(handle->fd, offset, SEEK_SET);
 
+	if (HAS_COMPRESSION(handle)) {
+		zname = read_string(handle);
+		if (!zname)
+			goto failed_read;
+		zver = read_string(handle);
+		if (!zver)
+			goto failed_read;
+		if (strcmp(zname, "none")) {
+			handle->compress = tracecmd_compress_alloc(zname, zver,
+								   handle->fd,
+								   handle->pevent, NULL);
+			if (!handle->compress) {
+				tracecmd_warning("Unsupported file compression %s %s", zname, zver);
+				goto failed_read;
+			}
+		}
+		free(zname);
+		free(zver);
+	}
+
 	if (HAS_SECTIONS(handle)) {
 		if (read8(handle, &(handle->options_start))) {
 			tracecmd_warning("Filed to read the offset of the first option section");
@@ -3921,6 +3947,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -4120,7 +4149,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
-		/* Only main handle frees plugins and pevent */
+		/* Only main handle frees plugins, pevent and compression context */
+		tracecmd_compress_destroy(handle->compress);
 		tep_unload_plugins(handle->plugin_list, handle->pevent);
 		tep_free(handle->pevent);
 	}
-- 
2.33.1

