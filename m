Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57E4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352435AbiASI1V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI1V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:21 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3BEC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:20 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id f21so7480921eds.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3bc2yDUheJlaiksjyLj44PAiO5rak/8S3mqzs2HiHtA=;
        b=fXd/rtFAFfQcKZqXBLHZdyleQr97neMy3vk9rqIi47xk4ahmKXMdegDR2PU3GLfTMM
         H75lKVknMyQhSXq4SnXaFevrrHOsNMRYNohvUNMqZLAvLzsedT+z7pChpgsJnVB5WS4G
         QFYr6Ss/Z+YJvTegDZSF1mqFeDJt9oBjBIOkOdoP44d4yUnjL2MhC3//KCsha5S1KmaD
         LwTJvKTFeTG/2DslezQ/j6J9xBYGOOTShZtWq7dUKfpfCfSKZ4bpqIYIvhnzZKqTw19W
         A9+m8bl0aWfw4mnOMwCA9pibmFavJx8590fFDMsTIKjvfd8dutpWz4Ielh5yf1lHdfPi
         EMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3bc2yDUheJlaiksjyLj44PAiO5rak/8S3mqzs2HiHtA=;
        b=5jPDn6mOROtveLCFCsF8y+Dvp+ise+d3FHohnkTgigJSyLpluG/FhhNjBfOcmESiS/
         ouklvZiY5Tf8sTj9Sf91X9Rry8hFUVNOOzw/OrDietjk+Xb3fP+kPixCSUmuYdpGEmL0
         YZEMZnCrSB1q5fJDqTejlvu/Y79wgYur2XwaIqYK7WlMnMs2LR1wqEtWW1M4eoi4rzic
         JkQjDXhtAgtgJTFACUpR5FTp9P8E21sSjv6mdTSOv0C9LmTsuCrNmyD9go99lTajywlg
         p22/ieEBDEbBAG8zlv+rWdEirr/BNurOZYN3C0081SdVr3hnN/BXbzlTK5dAzC9f4ysL
         p9vg==
X-Gm-Message-State: AOAM533x+4+ITKj1QHahAm/DaF4W3sZeytFhj6fLnxHEdYaK0Rx0Zkb7
        gFp/BA8KdcMYxV8+L42yOzd+DyhTUVE=
X-Google-Smtp-Source: ABdhPJzRQaRVLkzYkVukaOsFUBDndC6n5TAKdCsIxfGoYPC8nL71pbrxKTvt2F4FQiUOt+TKPbCj3A==
X-Received: by 2002:a17:906:66cb:: with SMTP id k11mr3264629ejp.85.1642580839425;
        Wed, 19 Jan 2022 00:27:19 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 02/20] trace-cmd library: Internal helpers for compressing data
Date:   Wed, 19 Jan 2022 10:26:57 +0200
Message-Id: <20220119082715.245846-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index 15baef8f..2b944913 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -70,6 +70,8 @@ struct tracecmd_output {
 
 	unsigned long long	options_start;
 	bool			big_endian;
+	bool			do_compress;
+	struct tracecmd_compression *compress;
 
 	struct list_head	options;
 	struct list_head	buffers;
@@ -100,18 +102,27 @@ static int save_string_section(struct tracecmd_output *handle);
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
@@ -139,6 +150,43 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
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
@@ -1645,7 +1693,7 @@ static int append_options_v6(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	r = pread(handle->fd, &option, 2, offset);
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
 		return -1;
 
-- 
2.34.1

