Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005E2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhLJLDT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:18 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F2FC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:43 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id x15so29282835edv.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8zafahj+BIQ+EoEjSAS5NYP2Tv9+YwHaM4X6PQNieU8=;
        b=D4Xj6Kg+OtEh7RG9PUtCtOj9bOLifVZeUgFD2KTyKDsPpN3msLd243S31ME8q59olF
         smpRt3fFDenY204IkdXid1ZjRrcnU5zo4oQSfl6g36lK+j0o3igxZv9gjtgOD1S0U81i
         C1+8ENE4nvrIjugZ1CMmCGbQDzdmCS9e/X5oXyOWx1BWv6hXV4yO8qBg2AfZykj4qo8H
         7syOpi7vQFSVrfNz0meDLU9rD1XAYo1m16kWR6X2wMXE5REQ/AOzZ8EZD3AnwWxAEaMH
         Y6y46AdZJ0SfSFFPwnVEJh67qFRU/AgGVXgZQMry2JZKm8BGroGqDBy5ZdHg0a99+vuH
         cSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8zafahj+BIQ+EoEjSAS5NYP2Tv9+YwHaM4X6PQNieU8=;
        b=asKXxLcSJkG/EQe1dKQDqb0VRuFTA27z79nSJZIMAfplXdRFuoY38eFaUf6KBE1Wh4
         GAIovzbP710/7kU3+x9JN55qPBSZsaLHo34PU61X0kZboR2B30yJUvzQ51WIlmBUcGtl
         oj0aw84RfGJF8zRuNnxLXn8dz8eAW7mRI73it9D8MmSkyOVRo4tR4qiO7MagDLxd8PGq
         Y/pZJem91VVPxm94k4yJb33j7FYeu0vPoe5mlLyKiiae/igfwM7/u6zsTR+pYdfKAX7a
         qG+29HbVPzOKF3jsmk9UB+LLt7ip0xEuZ0vwejFhgNyyB3JG+aesRRO2nZDgD6AZSVQ2
         MK2g==
X-Gm-Message-State: AOAM533WmlvrT60hpgQ2cploAa79uI5GOdJtmaQomyUUCCNObEESACfD
        pklApACGE6VMnLIcVSaoWopPLOi27NY=
X-Google-Smtp-Source: ABdhPJyHWeakeGEP/zgYdwNS/k7eAC6FwGCfE0zs/QLe+yx7/gxPMcRb/yK2p29au5Fbk8EnmqNAfg==
X-Received: by 2002:a05:6402:2792:: with SMTP id b18mr37329675ede.329.1639133982500;
        Fri, 10 Dec 2021 02:59:42 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:42 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 03/20] trace-cmd library: Internal helpers for uncompressing data
Date:   Fri, 10 Dec 2021 12:59:21 +0200
Message-Id: <20211210105938.98250-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index bc4e2885..eb1359b8 100644
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
2.33.1

