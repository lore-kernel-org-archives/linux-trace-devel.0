Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1095C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB5D61390
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhKKPOu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhKKPOt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:49 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488AAC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:00 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v11so25477412edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d3t3kEYhcHJipDCE3CbYWFZXnPRzJHyBhw0h3SpbeO0=;
        b=qAhuXIYJfiwklHaH6shDXYrAWFowPAxv2uM9YXHoFL8YvPlGjoe4Czd7o2AlsEJ4R2
         +cFBk031cidHf9ZZM8q0Rno3l0mJSWiQzhMPYvBvMKp5lMIl7vrCT2rCL4/NqAnii1AQ
         vXW9praqnRwz32dIMvkEW+e8qnwOLomkjIIZnW7HE9jGxyyi2XdzjWgU1HxdGXablP/0
         4ISDFVU7e2vfG6xs5lGlTfCg1axrpgqzHpC0iuSRo0EDeAIPs4CNGyL1pah5ocPWdFRR
         pcsYwmwUAI7ZjZkgM1TN+JG1ipOfULXpIKufDZpiHGYuQUixU5+zyhYl1/gpVEySZ7tN
         W4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d3t3kEYhcHJipDCE3CbYWFZXnPRzJHyBhw0h3SpbeO0=;
        b=RL7PBQBBPuxM89DTkXsCR/PbU4Z38MMHkbZX60pKUKrBandDiUSHZsPF1S0blkZnmP
         t4OPD6ItifGr7BqS2+wRHKJ0kpmYox8GXYac/UFJq/EZ3gUCi6CZhu3ccmp4Wzsvr2qp
         G1RSjOFr1qvGAnqH7oncYt6NCLV8Aa9fLGru0QeaSwFpP6q4icV2klp40iN6aj36hcrA
         IFrwwyvIWBuTnKeYruM7xkSmUKZqLkEJF1AuQOS4YbVWEDVimLvER+X0jkPuVUFSgzjf
         IH4YcFcNeahrTqz4tGisZm8o+RLD8huCXeRKx+aWRl1tYgFQange5j9iUDar6NA/zGTH
         Fhfw==
X-Gm-Message-State: AOAM532FZaiNvSGmOfRvdGineZb8Tl2iE7a6mHcbOwyBCepxPypE2OW6
        nqKGCZuyYcOPBgcoYYBCXKtWU6l/aDUKNw==
X-Google-Smtp-Source: ABdhPJwsGLCNvX4wTIuivBsqoGAHd8Wwt2Tmk6Eo4TYDsPQUt6iZHDYeMePfSgYBftTmOhO13I05Pw==
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr10415487ejc.239.1636643518884;
        Thu, 11 Nov 2021 07:11:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 03/20] trace-cmd library: Internal helpers for uncompressing data
Date:   Thu, 11 Nov 2021 17:11:36 +0200
Message-Id: <20211111151153.86855-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index 393d05e8..fd61150d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -47,6 +47,9 @@ void out_compression_reset(struct tracecmd_output *handle, bool compress);
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
index f9978dde..f0b7b3eb 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -157,6 +157,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -263,13 +266,13 @@ static const char *show_records(struct page **pages, int nr_pages)
 
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
@@ -281,6 +284,22 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
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
@@ -305,9 +324,7 @@ static char *read_string(struct tracecmd_input *handle)
 
 	for (;;) {
 		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -333,7 +350,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -397,6 +414,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
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
2.33.1

