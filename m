Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C824C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352460AbiASI1b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352458AbiASI1a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:30 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B424C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:29 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id 30so7635783edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rhbc61nx2547b5/LCa11SZYtwlB5pblDv8z6EA9D7So=;
        b=NCD4+OQoyh97YZdEOaxBSMFc62HlrEsce9gU08f8ymFpJk6KwmiPMPfg/2IrjLoF6N
         n3jA/CVjThOd0rNeIJsl0YsQLNGtRGhib3Sa5NoGLHKBoK1fK2RHql/b+CrKZHrdDsEx
         Mj+rTzJMO/ZmNgLsXx0sXGzWP9c8tT0QJkwpWuoVH0qoMhUqXr386Fr+VR7JNVvCmRIj
         Ja7tpfmQAy+48BeRiEnnUAe98AI8F2/tgPjr2lgKTs17DZMZXjzOy4ufk8RAKO5hMpJ6
         oRqHro5bs3pEGSWJiNnReRvAd4Vh4Duwz2HUl9ggX/1muZ+jsPcEiMxIka0EFMAY394s
         gq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rhbc61nx2547b5/LCa11SZYtwlB5pblDv8z6EA9D7So=;
        b=SG2+/HGvkIPjRIUCfmI658buikgYRWnihMfG2x1fFp+e3LyEZ9bz4428tNxhFFOdWt
         wA/UCbcpzw4tnSWe1X441VH/HUTmEZkJOFFBxvTDNe2dy3ait8tvsabigvhu+hqTbmbD
         xoAh22t0RaOhxfueYRplUdeK+y+BeEL7Xca4cAZNRk54/w5OdAVXESWEJOZoImkemHlx
         iVlsnhaSj+PrVO0ivlc8toYw69RWZ+YwT5/RAb21Lkzv7/CE6+5S4mlEpa5sY2Z+TECm
         uTDKFFTZDHmbfIBqs4o/MQCwZo7XEge/eoyMwEGIQhtW+PUmXdtA0TdrW00MvUKvrjst
         Lc3g==
X-Gm-Message-State: AOAM531Kr7pvOgYtMbmlnMRrM/McmbIt+5mLZw0sDJWVLAjs81xipTmn
        1Hn77h9qyOVFd2l1Z2NlX3EH3iJ7NHg=
X-Google-Smtp-Source: ABdhPJz16bbpHnlnnXyDt57Y5d064F75iOLt79Xt+h+6O4arErn3KvIS4CVMLJt2m0tRgG/fJi1Xjg==
X-Received: by 2002:a17:906:954f:: with SMTP id g15mr18051973ejy.755.1642580848007;
        Wed, 19 Jan 2022 00:27:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 11/20] trace-cmd library: Read compression header
Date:   Wed, 19 Jan 2022 10:27:06 +0200
Message-Id: <20220119082715.245846-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index d5295c98..ac3234f4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -193,6 +193,7 @@ __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
 #define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
+#define HAS_COMPRESSION(H) ((H)->flags & TRACECMD_FL_COMPRESSION)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -3849,7 +3850,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3887,9 +3890,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3919,6 +3925,26 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3932,6 +3958,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -4131,7 +4160,8 @@ void tracecmd_close(struct tracecmd_input *handle)
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
2.34.1

