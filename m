Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DE5C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC7661073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhJHEY3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbhJHEY1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:27 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688F4C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:29 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i20so15207327edj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T0K7GwnJLmI+4qfTUOWRjmpoq7S0xJk9BVAQkvoraVQ=;
        b=FbNwmnxeuWMeju2GlNIAARSnn8UutJfWuK8hvQzYKpxWN2paxS56mTgKT3QVcWrbrD
         sjhDGs4uIlj9Im4t/HrpHfYBTRqz12+ZZg2vQkfO8r8YJ02Ot/EQtIJsES0fa1f1JNCU
         pc0M1BjjikhMhHhtFlAh+AlpHKwE6BaIhnDY6n4b1VGVRa5VK2/maSjWKCQ/FWvOyrVv
         0Nrj3sE/66mI+GO2dsu7THqJvTA2Gdz+uoWGAxL0Br57wNykYDT/iYPrG5476J2k9dD/
         PLu7tDwjPK3ziCRIYcb85OcqSJ3b9nQDz5TfAdPDzQkjXOYL2gDFL9vYeCbyMQeweb6B
         8rwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0K7GwnJLmI+4qfTUOWRjmpoq7S0xJk9BVAQkvoraVQ=;
        b=3A+P9+LVgf1TgfT0l4b96LW6IB7eH0pH3zdaPeVvf4IwHeN7tcsZv7GypmeNpkIRMu
         iz7/iPtOI+XxRFdnHrSZ6NcQ+QH0w6tdLs4vqiVuZEaDJPCRVJphJpSgtTomO3I1yra+
         FDwAKk6K25dWi7vd46loW2id53LLiXl8+3ho36HJU9hmeQvPqaFhzQZM8VkSBcFHlFMB
         HAP3zeIJwx2BhGAGXOlwn/MbGmg/CRaG8AJ1L37mi+B8jXeQB/cmCDMGCvE1750AL7JQ
         5nnZUWmATzJI+2QZsUsiqLm6bLY4H5Tu9g3Dp8tkp608ZygdYnAGHm164Fv1xZ90lY3D
         BFlQ==
X-Gm-Message-State: AOAM533nAWOfts9yDl7Ax+4gtYSwaxhPETUPURlU+KW07lvAbpcsuXe9
        zGTtTBFFDw0v4KNmwAYvyggL3D3lA0MAtQ==
X-Google-Smtp-Source: ABdhPJzi49lJrauvf+dXldym/8cVIX+0KVXXYCHzF7h4GvnOWSLXGksiPxNopO7SYt6+C9zIvBF0Vw==
X-Received: by 2002:a17:906:1757:: with SMTP id d23mr1394111eje.102.1633666948070;
        Thu, 07 Oct 2021 21:22:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 11/20] trace-cmd library: Read compression header
Date:   Fri,  8 Oct 2021 07:22:05 +0300
Message-Id: <20211008042214.977193-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index 2bac5d2c..5bab81c7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -189,6 +189,7 @@ __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
 #define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
+#define HAS_COMPRESSION(H) ((H)->flags & TRACECMD_FL_COMPRESSION)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -3785,7 +3786,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3823,9 +3826,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3855,6 +3861,26 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3867,6 +3893,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -4065,7 +4094,8 @@ void tracecmd_close(struct tracecmd_input *handle)
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
2.31.1

