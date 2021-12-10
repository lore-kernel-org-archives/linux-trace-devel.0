Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8F3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhLJLDS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:17 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9888C0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:42 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v1so29002881edx.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nf8qIehI0YZ6GHzWhu+FaDOt0HIZ/zp1dMbXGKZ9l1U=;
        b=ppWpOveK8xZBtorGax1YeNIYbP7Mq5oFO/6hzi4NWX3FvV+8EwpGi4kNequG2cshxi
         WJwgvyOB2pBVwP0G6DfATCRxPO5PNvLTCu4DKd7cQUnCz7SdTaTwTP/LtO7+rboLSbBb
         jyEcvCQ6fph05LdXLRLXxHC5JxcgXg0V6UOibNXuXH1JmyGSgN0l/vzyvSL7ZBGqiJWL
         xyJZz7Xu0acKboTbteGDbx2c9bCT9l/D5FcWFHfoI8lO4N+/BAHjeSBeglv/a+1u8cnw
         nYdomP3DR9d00nk1/IVNFVgvZW2MUR1aMQ514dqRdNCHvKG/3zJn8MD9RHP071S3Gm3B
         Ns0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nf8qIehI0YZ6GHzWhu+FaDOt0HIZ/zp1dMbXGKZ9l1U=;
        b=uiYNzpuXX04XQIcnITr0ESqnzppUMoc49XhjvUNnit4BOOIpdDkyWNwWevqD0LhIsT
         C70CkYlr2o95+ji+MB6pv19XYWzBk5D1wAxEIesCX5CTRWw5uu4acRuvpFO8Y8sxzumG
         ODqJ9xi/ZEXggPGOBEUzoSlUWiePTEZQwv7yXW5FjNfSwL1026dm2vI98j/AdgW6VHYM
         g5Z4sJE0Ia1AwJrs8TcgvQ/4mXBxAj6RZsCP/4nvf+Jzd0cUEMFS0X4pTZ/2v0doOSSm
         ILkYsGftuY1zpibU+14epO1B+Dka0ltC+jN9h3mIGu4H2kT4PP6dqBBBSAXhOk6zgrP4
         oYbg==
X-Gm-Message-State: AOAM530zY/hv03wwGfHoeBeM/L/pu84zCJgGTm+J6CiaHeBx61/ooZlI
        BIPxTgXTSJIMwxzl3cdTnj1ErBlelqs=
X-Google-Smtp-Source: ABdhPJw+UGJZfq98FJdx5Xeg48e0HlOlw9leuYCnsqzgpYGtUpVJ+Nn+WPrpfcI/ouuD1rZGOla/5w==
X-Received: by 2002:a05:6402:280b:: with SMTP id h11mr38184182ede.341.1639133981522;
        Fri, 10 Dec 2021 02:59:41 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:41 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 02/20] trace-cmd library: Internal helpers for compressing data
Date:   Fri, 10 Dec 2021 12:59:20 +0200
Message-Id: <20211210105938.98250-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the output trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  7 ++++
 lib/trace-cmd/trace-output.c            | 56 +++++++++++++++++++++++--
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index d4047429..b848514e 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -42,6 +42,13 @@ void tracecmd_compress_free(void);
 bool check_file_state(unsigned long file_version, int current_state, int new_state);
 bool check_out_state(struct tracecmd_output *handle, int new_state);
 
+int out_uncompress_block(struct tracecmd_output *handle);
+int out_compression_start(struct tracecmd_output *handle, bool compress);
+int out_compression_end(struct tracecmd_output *handle, bool compress);
+void out_compression_reset(struct tracecmd_output *handle, bool compress);
+unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+					int fd, unsigned long long max,
+					unsigned long long *write_size);
 unsigned long long
 out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
 			 char *description, int flags, bool option);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 38a0699b..6dda61f1 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -66,6 +66,8 @@ struct tracecmd_output {
 	unsigned long		strings_offs;
 	tsize_t			options_start;
 	bool			big_endian;
+	bool			do_compress;
+	struct tracecmd_compression *compress;
 
 	struct list_head	options;
 	struct list_head	buffers;
@@ -95,18 +97,27 @@ static int save_string_section(struct tracecmd_output *handle);
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
+	if (handle->do_compress)
+		return tracecmd_compress_write(handle->compress, data, size);
 	if (handle->msg_handle)
 		return tracecmd_msg_data_send(handle->msg_handle, data, size);
-
 	return __do_write_check(handle->fd, data, size);
 }
 
 static inline off64_t do_lseek(struct tracecmd_output *handle, off_t offset, int whence)
 {
+	if (handle->do_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
 	if (handle->msg_handle)
 		return msg_lseek(handle->msg_handle, offset, whence);
-	else
-		return lseek64(handle->fd, offset, whence);
+	return lseek64(handle->fd, offset, whence);
+}
+
+static inline int do_preed(struct tracecmd_output *handle, void *dst, int len, off_t offset)
+{
+	if (handle->do_compress)
+		return tracecmd_compress_pread(handle->compress, dst, len, offset);
+	return pread(handle->fd, dst, len, offset);
 }
 
 static short convert_endian_2(struct tracecmd_output *handle, short val)
@@ -134,6 +145,43 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+__hidden void out_compression_reset(struct tracecmd_output *handle, bool compress)
+{
+	if (!compress || !handle->compress)
+		return;
+	tracecmd_compress_reset(handle->compress);
+	handle->do_compress = false;
+}
+
+__hidden int out_uncompress_block(struct tracecmd_output *handle)
+{
+	int ret = 0;
+
+	if (!handle->compress)
+		return 0;
+	ret = tracecmd_uncompress_block(handle->compress);
+	if (!ret)
+		handle->do_compress = true;
+	return ret;
+}
+
+__hidden int out_compression_start(struct tracecmd_output *handle, bool compress)
+{
+	if (!compress || !handle->compress)
+		return 0;
+	tracecmd_compress_reset(handle->compress);
+	handle->do_compress = true;
+	return 0;
+}
+
+__hidden int out_compression_end(struct tracecmd_output *handle, bool compress)
+{
+	if (!compress || !handle->compress)
+		return 0;
+	handle->do_compress = false;
+	return tracecmd_compress_block(handle->compress);
+}
+
 static long add_string(struct tracecmd_output *handle, const char *string)
 {
 	int size = strlen(string) + 1;
@@ -1638,7 +1686,7 @@ static int append_options_v6(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	r = pread(handle->fd, &option, 2, offset);
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
 		return -1;
 
-- 
2.33.1

