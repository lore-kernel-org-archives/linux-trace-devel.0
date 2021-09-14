Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106EBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0F7260724
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhINNSR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB872C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso2552701wme.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mlxclYoJfY56ZTfpJxTpE6EKYQGSGZp1shRRwl5bhFw=;
        b=po4gU9MFQ/uit/e+CC9Rtp9nUeQYT98+cIz8myQFzYv5VtAM1AbbswGmdth3ut+yoH
         vWyQviGZXM9XgyUrtMmPGSd9YWOZgVH3AhrMfwMAmosI/K1q9pXuEhTQcm1TX94usArH
         rzd7DEKa+jTeL2f75NJv69v7Ygan+WQU7l/7RfD8AklfvtDoS/6kFwACXHhu2oCHjyk8
         o69u4ZqwdX/lWHiEVqRZa7fqadBpAx0T4shVkf+LD0/IZPQnsTplAYH4LjRJg+mTUjw6
         jsIv9RTeGXs6Nkk2aiCGnWIHyjdNKDzRbjZPidkSz/wiv5QnI6cU5g5oC+O3vTTj2ClS
         CWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mlxclYoJfY56ZTfpJxTpE6EKYQGSGZp1shRRwl5bhFw=;
        b=j0vH5JohKGQEBw8oLsyQNzmFa474PUFufcqGVp5tB1KVKBmpxP2nj9jMmrLokdrRKD
         /JGTx/D3vCUG19d5THtvYPqo9c0XIS4jQ8VoVzPEXOyvnSi6yyYipOdjH7tzG/jiCGMD
         TtsEOKtpVbSYplxDbxQ5Xsb0+KA/aueJjqdur7G8VZfR3mcDcaEc+jswU/eNmL7HzKLQ
         w4I3XK3Vgj5JTOJoTvU5kzFzO5gArYYIqddcZ80ShUN7VsCucWVKvQ4iOMp4YRSB6Wk7
         o6XoFZ6Iq3ZcyZLgTi9+sOx0QUhz747hNju1YkxPtm/FM/IcMbJ734K+NpoFT2zfTBt5
         Av2A==
X-Gm-Message-State: AOAM5305qpIRupLJvGM/sSX2rE4jGpSHuukVyLeVvqtMMZevqCc9JDqR
        OC7nAMJPb3+4SQ57ceYG9OdZ4VT94Pk=
X-Google-Smtp-Source: ABdhPJyilL0oq/xCG68nL8v6U0Lh4OXhYKU4fM06aOELYScaSS3NJ28zN0QM/F/geGdmYrBXf5JdQg==
X-Received: by 2002:a1c:7e8a:: with SMTP id z132mr2119612wmc.75.1631625418335;
        Tue, 14 Sep 2021 06:16:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 11/20] trace-cmd library: Read compression header
Date:   Tue, 14 Sep 2021 16:16:36 +0300
Message-Id: <20210914131645.3966308-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 41b60649..d4728c86 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -189,6 +189,7 @@ __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
 #define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
 #define HAS_SECTIONS(H) ((H)->flags & TRACECMD_FL_SECTIONED)
+#define HAS_COMPRESSION(H) ((H)->flags & TRACECMD_FL_COMPRESSION)
 
 static int read_options_type(struct tracecmd_input *handle);
 
@@ -3797,7 +3798,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3835,9 +3838,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3867,6 +3873,26 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
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
@@ -3879,6 +3905,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -4077,7 +4106,8 @@ void tracecmd_close(struct tracecmd_input *handle)
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

