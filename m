Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91A9C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3BE61053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhG2FKQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbhG2FKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:15 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F48C0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:12 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x14so6360384edr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iYdN1F0j8Ay3XJukVi6oM/G3+VgQFJICm7Q0fdgZNqU=;
        b=AmpqxE/Rw/fGM9h3zuB7BiOIINIPJUYOnV/ENn+k4R9cyoxTKY5ZLkCbnJs7D3pdRd
         M3Q7lrdx9kgXpBQp12618ipTuauD4ccK1VqGAfWEfRdSSgU6rRjdD0YWeCbXzICMODZE
         Zqmh0jYFeQAv7rAugnv3oMMZlT7NnUyg+359OOJGo8eMQCSXZVQFKor/77owqJKOn9T2
         f7sKbSU30D0pSKtRG6wBYIuwA9/5zAfJk3ce3SKGfXpiTGlZkoQTq5YR9gZYOgIsQYzN
         uArX1PFJ9piXLWOcUgeZ2wN2KUAR4WENVyZLVB6yNsm9H2djICkhKhemN7HwckovHbT2
         yf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iYdN1F0j8Ay3XJukVi6oM/G3+VgQFJICm7Q0fdgZNqU=;
        b=TxICUikp6ZNMOPojIhdaDz2i21SLWTXxd2oV9fwaBJb+BatBt5fq9xmTDaJ4z7PuQa
         RAqPCsOj1D5o8wNOj9Sjips6raDw7OmvDE8L3cirErwV/4kjpptxFeqnsJXk6SHVXtAP
         p2VH0bwdtRL57dCKuDszTFIjW4fas0lDVYuGQsah1/Bjws8kAO+9Lgl53NMBLQT/bgSK
         yqObnbdwToTEojcIRnyAp4UGh3RgcQD/pawyCMkVfAprjazHpNufsCmIl55P9yyoBn/a
         qWoVMctD16+PckQUAvrwVvbyKzOB531u3hT2GkKxln86XHKypCW8w1LwuhJP4AERf0yi
         DT+A==
X-Gm-Message-State: AOAM5320kgzotQEIRV7XIoI7wu3aInXHE3my5HG5/6dtyRPbdW+BtMu1
        oJIICQAn1Yn4Yc7IKO2QwCAIpP43s9rkjg==
X-Google-Smtp-Source: ABdhPJxsIzpnWXO6YavAmPYY9y7QQG/8bMUBS68XOXX60M6RL8o5/iNj2iOHqKFn4+Pjoweb/CD7KQ==
X-Received: by 2002:a05:6402:516f:: with SMTP id d15mr4089087ede.210.1627535411538;
        Wed, 28 Jul 2021 22:10:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 10/87] trace-cmd library: Internal helpers for compressing data
Date:   Thu, 29 Jul 2021 08:08:42 +0300
Message-Id: <20210729050959.12263-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the output trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  8 ++++
 lib/trace-cmd/trace-output.c            | 64 ++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 2a622003..14c4dd08 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -34,6 +34,14 @@ void tracecmd_info(const char *fmt, ...);
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
+int out_uncompress_block(struct tracecmd_output *handle);
+int out_compression_start(struct tracecmd_output *handle);
+int out_compression_end(struct tracecmd_output *handle);
+void out_compression_reset(struct tracecmd_output *handle);
+unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+					int fd, unsigned long long max,
+					unsigned long long *write_size);
+
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a8de107c..552889c6 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -59,6 +59,8 @@ struct tracecmd_output {
 	unsigned long		file_state;
 	unsigned long		file_version;
 	size_t			options_start;
+	bool			do_compress;
+	struct tracecmd_compression *compress;
 
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
@@ -77,15 +79,36 @@ struct list_event_system {
 	char				*name;
 };
 
-static stsize_t
-do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
+__hidden long long
+do_write_check(struct tracecmd_output *handle, const void *data, long long size)
 {
+	if (handle->do_compress)
+		return tracecmd_compress_write(handle->compress, data, size);
+
 	if (handle->msg_handle)
 		return tracecmd_msg_data_send(handle->msg_handle, data, size);
 
 	return __do_write_check(handle->fd, data, size);
 }
 
+static inline off64_t do_lseek(struct tracecmd_output *handle, off_t offset, int whence)
+{
+	if (handle->do_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
+	else if (handle->msg_handle)
+		return msg_lseek(handle->msg_handle, offset, whence);
+	else
+		return lseek64(handle->fd, offset, whence);
+}
+
+static inline int do_preed(struct tracecmd_output *handle, void *dst, int len, off_t offset)
+{
+	if (handle->do_compress)
+		return tracecmd_compress_pread(handle->compress, dst, len, offset);
+	else
+		return pread(handle->fd, dst, len, offset);
+}
+
 static short convert_endian_2(struct tracecmd_output *handle, short val)
 {
 	if (!handle->pevent)
@@ -111,6 +134,43 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+__hidden void out_compression_reset(struct tracecmd_output *handle)
+{
+	if (!handle->compress)
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
+__hidden int out_compression_start(struct tracecmd_output *handle)
+{
+	if (!handle->compress)
+		return 0;
+	tracecmd_compress_reset(handle->compress);
+	handle->do_compress = true;
+	return 0;
+}
+
+__hidden int out_compression_end(struct tracecmd_output *handle)
+{
+	if (!handle->compress)
+		return 0;
+	handle->do_compress = false;
+	return tracecmd_compress_block(handle->compress);
+}
+
 /**
  * tracecmd_set_quiet - Set if to print output to the screen
  * @quiet: If non zero, print no output to the screen
-- 
2.31.1

