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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C754C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75E7860F36
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhINNSJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhINNSI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:08 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8256CC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id s24so9227817wmh.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/OE6tdFd+yfVYNsUI1RW9md2K5qwYRUbMEMY+ELH0Ts=;
        b=kVQdZILE85pf4AsxLBqpQhNznUgPvIb3vUNnkqfdrekdU2eiNGBKoOUDS5ms5b51nJ
         Ci6l4UcyKeoXJXvII6FCcFNwkcvkVzo2pdl1UxMhohpfUaDQr1CjNLeJVmxF2K14EgKC
         Hsb1L0sfU9h3AqpA1DdOWUMAy++ZQGI0pZF56XpKgu8GrgnmD13PWi5wAtsFQEa1/DP0
         HHVTrqmszU+tcSoq9aU8/iZVbSQ1JQXz48cAebc/s+jQSD0MLMo0ChzQLFWwhyeFz6gs
         me1uL5cGCo9KMJrRa+DvqWM8PgfiPS8S7TogTAefFWb1a+vQowimUDfNJy/YGHPJqfOV
         DltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/OE6tdFd+yfVYNsUI1RW9md2K5qwYRUbMEMY+ELH0Ts=;
        b=V9Li9V07dEJnPCZFC43b1MZvOZClg4WqvdwcHsvDFBgv2K+YWNih7LhQcpCs2O7J9R
         GI1WP1UkmasfbsbdfQlmNE7AXX2y7Rk1deC1y7PrWQd/QeoqL52Lpo/FUoqJUhHaV5U8
         6DqtLdnxjYW5GnrgIvcrugw3TbxiQf14821CUnAJT/vz8aHjrsvbe/igTRDmrqVSTWKA
         CNrqtKXe6slLR+LO5UNE+VgUpxqrZny59BxxzFJzcE6cpckkSOTg7fT5FJMP/yO8QnXP
         Y3jUIemzUCCd/DJeN0ugm7Uf8sFm1Bjx1g02GLTMqtYranr2AcKJjNbJx0MZCtdz03wK
         pbwQ==
X-Gm-Message-State: AOAM533nZygUX5MK0865NPVh+Y+R3cWql1sz/LYO0PwKuJf3zR2+C1GM
        zuXL0AsKZSUmqMeQT7AWuICnDwbC6GI=
X-Google-Smtp-Source: ABdhPJxmzKYU8tqcjhB/aqRJjjOlKjy4+y5pyze8n4OMD5TrbxQRP+zrXk9KOaGdS/3bqxVixBDO1A==
X-Received: by 2002:a1c:7dc8:: with SMTP id y191mr2151285wmc.6.1631625410162;
        Tue, 14 Sep 2021 06:16:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/20] trace-cmd library: Internal helpers for uncompressing data
Date:   Tue, 14 Sep 2021 16:16:28 +0300
Message-Id: <20210914131645.3966308-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 304bec49..14223a08 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -45,6 +45,9 @@ void out_compression_reset(struct tracecmd_output *handle, bool compress);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
+void in_uncompress_reset(struct tracecmd_input *handle);
+int in_uncompress_block(struct tracecmd_input *handle);
+
 unsigned long long
 out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
 			 char *description, enum tracecmd_section_flags flags, bool option);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 222b9c89..3eef539f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -155,6 +155,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	unsigned int		cpustats_size;
@@ -262,13 +265,13 @@ static const char *show_records(struct page **pages, int nr_pages)
 
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
@@ -280,6 +283,22 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
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
@@ -304,9 +323,7 @@ static char *read_string(struct tracecmd_input *handle)
 
 	for (;;) {
 		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -332,7 +349,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -396,6 +413,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
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
2.31.1

