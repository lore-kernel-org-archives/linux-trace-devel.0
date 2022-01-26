Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F87EC28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbiAZJtR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiAZJtQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:16 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844DDC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:15 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id p12so68193181edq.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yC2xR/bZdtpDipk9C+O0C1NyjXrFWeuokF9YEWnsrvw=;
        b=Ezch7itmMeagQpmDUe7K8J5yYy5nt/RRhyGf0v6RkXj1p5pREc4eY4haAKMNyV9HjU
         NhuhPbNSp9OpquCk0Ra9AtV++WAQgZqBsXR+CVd1rix63sOHPGu4jdlfJ6UXFUiIDpSm
         SzRgKtZXv1p1ui2gFry98hHAWMPwZXwKKcFB595rdkcp49H5f4LxLGwLb4eG1YLt4o8E
         5bVInQAHYToBLim4OQ2bp/h6lXO+cvWUK747NhcpiTWl5beB54+bTy7eTE01HiWpraO6
         Z1Jz7jH1JN3VPvyRPk5jZtdcUD8UUrjZp1EZHwx269Y4RKFtsDyj7LlrQjoahCCI8k2u
         13/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yC2xR/bZdtpDipk9C+O0C1NyjXrFWeuokF9YEWnsrvw=;
        b=4ollDHsqEn8aiyzxFnZxaEwp08/2AAg0eZwwxSnEC6HUzgrdYBi/k8ZvJd0IbwmiDW
         WRxegVFdXBuzRBmgBA9+a9pBTGwGPRdP+5o5hQZ/TZKD20FRGHco+uK5DD0wHOdeQD8F
         93YMhw0S4ArbS19ag2kuBRyLbukWWvFn7Ing/tdIdazsbCJR8rkvE8oWlUcq0UUt+S4H
         7H1+q9EgF8f6tL4EZK3/tud+Yu6jpo/aiT9r9r+OknpMtNbhj9OgdlHU2UtLenMTlIGy
         MkIfOGvH9OmSYldFrbYBrIHtGkYCXICbQs5Our4l7++dlI3heX4iUq2MWJRabyU9skyf
         aYrw==
X-Gm-Message-State: AOAM532pyaQSnGw3ZLgwX4YJC+PtvHAmU5keik7KhfXksChZxEV6AzbT
        LYUziBXuxSzT/3xALrCuZh0haCzZXo8=
X-Google-Smtp-Source: ABdhPJwTN3Lmqbp1WHLqTql1yY8wx3oVdw/FKKaAvqShdWNcEz4Qb5mqhfXAs/3EyH5ywRjKPcECoQ==
X-Received: by 2002:a05:6402:7cf:: with SMTP id u15mr24635157edy.325.1643190554119;
        Wed, 26 Jan 2022 01:49:14 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 03/20] trace-cmd library: Internal helpers for uncompressing data
Date:   Wed, 26 Jan 2022 11:48:49 +0200
Message-Id: <20220126094906.570451-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
index ecb56826..4b911818 100644
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
+		return tracecmd_compress_buffer_read(handle->compress, data, size);
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

