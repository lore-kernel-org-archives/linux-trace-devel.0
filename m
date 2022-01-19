Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72CAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352438AbiASI1W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI1V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98564C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id p12so7521305edq.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zomYlE8NAQmflyOPsjJiUCp0aPpWWVdf21/5YjVh3D0=;
        b=b8UZUPEfnPmpuQA5+PtAEQsFeV2rFuH9M568S+ThA2yucmw48+bVOaPr8B5JuhPJRK
         ohz6RanmB+H6Eay7EVvY3CbqPC22FuPT7IKA3aExqh8QbuSnSv3hCW52G9H341DhJKxc
         YuyRTDX8WAyDMUv7vqOw7v4R354AkA/dgL5qON7A8fON/ph4LEV21LL6rnCdrahkn186
         SH+zEkkynIYJbAGsXlrXCpPhuhspkR0RrJSGbEGaJcmzH2KF0YRN/fdGbl6ikVI9A934
         gh0UCgSTT07reD5se4OC5Gm7ECFCh84eVfwOi8mo5xX43IwShCM7MINmRKjas5at3zJ7
         ZZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zomYlE8NAQmflyOPsjJiUCp0aPpWWVdf21/5YjVh3D0=;
        b=kf1CupYUPcFjwkSNBdDE3XvgcILL1g0HycX5Vj3X0FoLzbhlhdaGQEw41Ri1p7jYVZ
         dSaHsdOAwcWh/+dkYL4Iy72G4+d+W5f8kfEGx9DS6XjXDVHRLLD2dF5L0Xpku4QMq1qC
         u617xDGpvCDCtcnp1q8TZdIPvFX5cdytFB3w3uiPHy2XF2ZwgFejS4BH2KWDpS1eKWfe
         CFiJolXdxk+zH37oJaMLY0i5Pr9886t+qiEbyB8J8GmQIXLIZdP8G8kR5N4HSuci3eWT
         /gviO0S2j96UaarhgU8p8Okceh1kSQXKMskTrtQP0ZGA1bZN6Fmws8ZwE2w3eqGUWw5I
         /rdQ==
X-Gm-Message-State: AOAM530iS5wsG3Zo+8aBPpFG7kv53UQkMS2gIU2KqRkvdETN8wTLFceo
        17CA7G5yRvbsm+XSPDH75/bMvUd2Mwk=
X-Google-Smtp-Source: ABdhPJxCm8X98YYMu7yMu/X4Y1hPlGteBDVIXrHq0lSk/f8ak6h+HRZRfssfiS+QtT860G+9gUjXKg==
X-Received: by 2002:a05:6402:4382:: with SMTP id o2mr29379997edc.38.1642580840276;
        Wed, 19 Jan 2022 00:27:20 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 03/20] trace-cmd library: Internal helpers for uncompressing data
Date:   Wed, 19 Jan 2022 10:26:58 +0200
Message-Id: <20220119082715.245846-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the input trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  3 ++
 lib/trace-cmd/trace-input.c             | 49 ++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index b848514e..ca682ed9 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -49,6 +49,9 @@ void out_compression_reset(struct tracecmd_output *handle, bool compress);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
+void in_uncompress_reset(struct tracecmd_input *handle);
+int in_uncompress_block(struct tracecmd_input *handle);
+
 unsigned long long
 out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
 			 char *description, int flags, bool option);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ecb56826..49ada92f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -160,6 +160,9 @@ struct tracecmd_input {
 	unsigned int		strings_size;	/* size of the metadata strings */
 	char			*strings;	/* metadata strings */
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -266,13 +269,13 @@ static const char *show_records(struct page **pages, int nr_pages)
 
 static int init_cpu(struct tracecmd_input *handle, int cpu);
 
-static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
+static ssize_t do_read_fd(int fd, void *data, size_t size)
 {
 	ssize_t tot = 0;
 	ssize_t r;
 
 	do {
-		r = read(handle->fd, data + tot, size - tot);
+		r = read(fd, data + tot, size - tot);
 		tot += r;
 
 		if (!r)
@@ -284,6 +287,22 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
 	return tot;
 }
 
+static inline int do_lseek(struct tracecmd_input *handle, int offset, int whence)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
+	else
+		return lseek(handle->fd, offset, whence);
+}
+
+static inline ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_read(handle->compress, data, size);
+	else
+		return do_read_fd(handle->fd, data, size);
+}
+
 static ssize_t
 do_read_check(struct tracecmd_input *handle, void *data, size_t size)
 {
@@ -308,9 +327,7 @@ static char *read_string(struct tracecmd_input *handle)
 
 	for (;;) {
 		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -336,7 +353,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -400,6 +417,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	return 0;
 }
 
+__hidden void in_uncompress_reset(struct tracecmd_input *handle)
+{
+	if (handle->compress) {
+		handle->read_compress = false;
+		tracecmd_compress_reset(handle->compress);
+	}
+}
+
+__hidden int in_uncompress_block(struct tracecmd_input *handle)
+{
+	int ret = 0;
+
+	if (handle->compress) {
+		ret = tracecmd_uncompress_block(handle->compress);
+		if (!ret)
+			handle->read_compress = true;
+	}
+	return ret;
+}
+
 static struct file_section *section_get(struct tracecmd_input *handle, int id)
 {
 	struct file_section *sec;
-- 
2.34.1

