Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A69C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239393AbiAZJt1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbiAZJt0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:26 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AF4C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:25 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id s5so37618464ejx.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqEq/jGiLAhv0Sl33b28YglfPxn4NaW/MPkobfx0ZSs=;
        b=Al23ck/sDQ4sHwFtL8WtKY4MyFoqe5cSGWI2Q1ONoLBeEHQxq0QgYzrYQ+a9T8js2G
         iJ0VP/53ti4aZLsHrfPXcjYC1/PK2ff5q7sQCfWn0eUvxP6qJrdw+dJtO7TGMcwgTuNI
         byjn8IwpabpvFJwOdL5r8oTO/H8tCG6aI4oUeIF1tw7hIauRzddXn3m8L1Xt/IyGt/uC
         w9GwMyzHTHsNVYkoTjumXiDjaUDmtI9rXsKxRLmQmTD0rIXWSrGRKXWni8znTTO1N2K/
         5nPrVZQTXiZjjgkecODHhZZ+fm5hD2Wq+URyP9lkmMT2I4LX9T3sklyUao/yhA//3UXh
         T5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqEq/jGiLAhv0Sl33b28YglfPxn4NaW/MPkobfx0ZSs=;
        b=dDKzIjXj3Gm3UMDnZdlV0aGbHr9HrKS7QnFpmbz38jspcYpKyR9Aj658Tvs2KwuPIN
         xkMyLNrLt1bSwoQuhjdRiRhX0KOoJogZ1YsC5Ma3R+vS5NZ4csYWwYLhO7q4O4XZVT7X
         zkZQInVX6EQRx4JfH+A3ivLYgYLLLGHCi8pO6lwF7vV2s3O2Rmdzbjr5rSCPv/DOyBif
         EHnqJtM5hWm35WEhwNyFFWy92DZHa8ihP1qGrqtRFlrE6wzfqPQbK/Wfm4nF3i7FjElc
         wuI/b2+o4PZzkF+wAsmX5s5dBc3HDNI1VDURkjSAnSCW2Ummjau0//eGXmOXiEL+r+cd
         bFjQ==
X-Gm-Message-State: AOAM533sR0iQL+dkNRdORVzfadmlkZGM71JZTbX72oZIdj7vy1uE6Sw5
        Q9GflU3m26w3POb62+HlMWkMKgI61xI=
X-Google-Smtp-Source: ABdhPJxctdJVZoyreaToCKvvzrreptLvWz2u6ZykJvRHUGoA5hty6LdbTO/Q6vy55TglmpVAHI6VbQ==
X-Received: by 2002:a17:907:6e94:: with SMTP id sh20mr15511641ejc.378.1643190564527;
        Wed, 26 Jan 2022 01:49:24 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 11/20] trace-cmd library: Read compression header
Date:   Wed, 26 Jan 2022 11:48:57 +0200
Message-Id: <20220126094906.570451-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2da24a7c..20cd6c32 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -193,6 +193,7 @@ __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
 #define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
+#define HAS_COMPRESSION(H) ((H)->flags & TRACECMD_FL_COMPRESSION)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -3850,7 +3851,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3888,9 +3891,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3920,6 +3926,29 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
 	lseek64(handle->fd, offset, SEEK_SET);
 
+	if (HAS_COMPRESSION(handle)) {
+		zname = read_string(handle);
+		if (!zname)
+			goto failed_read;
+
+		zver = read_string(handle);
+		if (!zver)
+			goto failed_read;
+
+		if (strcmp(zname, "none")) {
+			handle->compress = tracecmd_compress_alloc(zname, zver,
+								   handle->fd,
+								   handle->pevent, NULL);
+			if (!handle->compress) {
+				tracecmd_warning("Unsupported file compression %s %s", zname, zver);
+				goto failed_read;
+			}
+		}
+
+		free(zname);
+		free(zver);
+	}
+
 	if (HAS_SECTIONS(handle)) {
 		if (read8(handle, &(handle->options_start))) {
 			tracecmd_warning("Filed to read the offset of the first option section");
@@ -3933,6 +3962,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -4132,7 +4164,8 @@ void tracecmd_close(struct tracecmd_input *handle)
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

