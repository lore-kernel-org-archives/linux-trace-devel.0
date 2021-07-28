Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD603C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C62D361019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhG1NdL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbhG1NdH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E60BC0613D3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:04 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gn26so4672135ejc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ALc/dXThP16z0nS5ZE1g6ixFgchPDYkHssFxAdlcy4c=;
        b=EppsNknIrQiAYa2/4dfXiqKGQ//Mr9u6NZGKnlBGsPreyS/5PR7ATX/+M6aOW79WJ3
         SdbjW5hAM881ow6mSm3cHCtsN+LSqGjdF3YWUGTxqTuyjz1M9WmN7Lu6/YdHUOWiPtYG
         qid5PrE55FZyMJr0BnIQoLja23va9YcIXUfEyWENSwYAzXRLcgqQUqtq0qacyRDrzQ5B
         5UO08y2RY+D9lbRVok9F2KeBJamPkZx5mv9/WS+kHCvjfV1qmk0oMaPoJNM6hOLzjsYN
         KRV0MsuYIOltaDZlJ73T7qhQB3/LfUZqHCS/8XTHMqQaJSFesVEwc3fGheGvG5w0nxn8
         jZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ALc/dXThP16z0nS5ZE1g6ixFgchPDYkHssFxAdlcy4c=;
        b=qQvTcGSPRXFXdI9a/CatoqbwIXT5iot2+mSEMHAbt9KmRECokHFpdgSLVRUQnerjZH
         jOHcLPKxhwX70xeN5UB2lPbNEE8bSShQ4QJsdSJmSk9x4/aqud2G2aK33SjZpBNaMrAD
         NxHd6Gka3sBuLB6MsdFtHDnQ73AGTQBHtuga1yB40sZX8B/ExEhcseqWN/AvCMRrFdq5
         VnwwTUm2+xcTfWy87IDyfoY5LeStDNG0wbx7qB38RPtFRp9Sicfgo+PKpN0aoXVKUCmu
         rtsXenhxe5H88a134CVlLN8lpIc7SLKMZJ3pveYN1vJW7a/xw7pAeG3xI8Vfu4zP/RK3
         5y3Q==
X-Gm-Message-State: AOAM5334dtKj09DEN8+9p7ZR7lIeX0NT+zToM7PO4fA4a8QQCFstP3Wb
        JmMVVrvoLSVDfk/sMIS3gNayFwcnjOIVAg==
X-Google-Smtp-Source: ABdhPJxm/v53XvepqwNBJKg36uEVx2Q4OqDx1r14Vkoc6kZ9m0Wz8bmNHjFbTwK0EfM/dS7uc54A8w==
X-Received: by 2002:a17:906:368e:: with SMTP id a14mr27889984ejc.60.1627479183193;
        Wed, 28 Jul 2021 06:33:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/87] trace-cmd library: Internal helpers for uncompressing data
Date:   Wed, 28 Jul 2021 16:31:34 +0300
Message-Id: <20210728133250.234140-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the input trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  4 ++
 lib/trace-cmd/trace-input.c             | 54 +++++++++++++++++++++----
 2 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index fa361766..670af8e4 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -38,6 +38,10 @@ int out_uncompress_block(struct tracecmd_output *handle);
 int out_compression_start(struct tracecmd_output *handle);
 int out_compression_end(struct tracecmd_output *handle);
 void out_compression_reset(struct tracecmd_output *handle);
+
+void in_uncompress_reset(struct tracecmd_input *handle);
+int in_uncompress_block(struct tracecmd_input *handle);
+
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 38dd0deb..da6825b8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -136,6 +136,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -238,13 +241,13 @@ static const char *show_records(struct page **pages, int nr_pages)
 
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
@@ -256,12 +259,28 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
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
+static inline ssize_t do_read_compressed(struct tracecmd_input *handle, void *data, size_t size)
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
 	ssize_t ret;
 
-	ret = do_read(handle, data, size);
+	ret = do_read_compressed(handle, data, size);
 	if (ret < 0)
 		return ret;
 	if (ret != size)
@@ -279,10 +298,8 @@ static char *read_string(struct tracecmd_input *handle)
 	ssize_t r;
 
 	for (;;) {
-		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		r = do_read_compressed(handle, buf, BUFSIZ);
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -308,7 +325,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -372,6 +389,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
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
 static int read_header_files(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -479,6 +516,7 @@ static int read_ftrace_file(struct tracecmd_input *handle,
 	buf = malloc(size);
 	if (!buf)
 		return -1;
+
 	if (do_read_check(handle, buf, size)) {
 		free(buf);
 		return -1;
-- 
2.31.1

