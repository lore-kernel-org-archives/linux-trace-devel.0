Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA80C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbiAZJtP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiAZJtO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:14 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A323C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:14 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id m4so37788741ejb.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zaWki1L2mBXq2T5kEviy2ASNdiN58d9j/z9BuEtePu4=;
        b=brrgCTp+1q5u/RAnhrym2TIBek65bAJIrUJMpZWkmxqwcXqlakwFV6f4kh6Yuw4zJ5
         QCEnby1zV8rZW6S10x3/lHcdn1Xkm4I0SbJbpBzxSpc6bDTOkhdLgWOlPRMDGGhY+Oz7
         SArShcPh9UM5MyinP9gjboaWOzB4u2JyR3sC9aXP72CSTgbytHSJc//qcyRC4mjaxKrp
         mhJ2IcairHvxqoTTbGNzxufvs40qhtYRCNPUhQE/vYPjB4nll2bbZJCIUBU2vHNrA56R
         /FWHnqbXPQANkXpTbR3jIJvoo5K9hx8G7Wpr0m1slKE4TKlAoOLwNu4NYq7nhdzDLsZT
         5OwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zaWki1L2mBXq2T5kEviy2ASNdiN58d9j/z9BuEtePu4=;
        b=ynFKkcY+5EH89vs8WLYWJN54pDJiKE2816q1psC4LTJCGxOgCm9Url8e15hxKDBg7X
         08kwLXnu/MZWm+IOBJ4/ffzN9Nm+W8ZtbjVc6iN1ICGp+wDcdyA8pOWVnErLe4HTyKpW
         k2o3HTqy44PiGa4GfhpX2icxbkdYAisiNl8u3DyKS+II/ecmiq3ThpkX+cNAx9K37ZAz
         CNKE+ehXsnkT6SVsD9cOEJzOtL+h4m70J+4TMHqIfGS9ey+vfuCxlqpbsMoK1VSM+c/J
         Ml0GHOl6MuqmhaShdYpWqTBZnQBg4dRI4l1S/RTI2nX7IgIV4b8DKPFabBqsyFwlwpvh
         zryQ==
X-Gm-Message-State: AOAM533aA9m8252SkcWLDsXtZYfhjK/Hd58uM94u1beFuQKJ0VwexH36
        YJ8V3UJ5u021Df6xXyy+jspPcQXMMV8=
X-Google-Smtp-Source: ABdhPJxyprRtkCxY2h/BXlnO9gDmod/DMl4Utbu8DmJ+YiV1oenrwOtjrKvs4O7j++EEA30HCJ9Q7g==
X-Received: by 2002:a17:906:b1c2:: with SMTP id bv2mr20651340ejb.395.1643190552638;
        Wed, 26 Jan 2022 01:49:12 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 02/20] trace-cmd library: Internal helpers for compressing data
Date:   Wed, 26 Jan 2022 11:48:48 +0200
Message-Id: <20220126094906.570451-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the output trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  7 +++
 lib/trace-cmd/trace-output.c            | 65 +++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 3 deletions(-)

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
index 15baef8f..87481e33 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -70,6 +70,8 @@ struct tracecmd_output {
 
 	unsigned long long	options_start;
 	bool			big_endian;
+	bool			do_compress;
+	struct tracecmd_compression *compress;
 
 	struct list_head	options;
 	struct list_head	buffers;
@@ -100,6 +102,9 @@ static int save_string_section(struct tracecmd_output *handle);
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
+	if (handle->do_compress)
+		return tracecmd_compress_buffer_write(handle->compress, data, size);
+
 	if (handle->msg_handle)
 		return tracecmd_msg_data_send(handle->msg_handle, data, size);
 
@@ -108,10 +113,21 @@ do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 
 static inline off64_t do_lseek(struct tracecmd_output *handle, off_t offset, int whence)
 {
+	if (handle->do_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
+
 	if (handle->msg_handle)
 		return msg_lseek(handle->msg_handle, offset, whence);
-	else
-		return lseek64(handle->fd, offset, whence);
+
+	return lseek64(handle->fd, offset, whence);
+}
+
+static inline int do_preed(struct tracecmd_output *handle, void *dst, int len, off_t offset)
+{
+	if (handle->do_compress)
+		return tracecmd_compress_pread(handle->compress, dst, len, offset);
+
+	return pread(handle->fd, dst, len, offset);
 }
 
 static short convert_endian_2(struct tracecmd_output *handle, short val)
@@ -139,6 +155,49 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+__hidden void out_compression_reset(struct tracecmd_output *handle, bool compress)
+{
+	if (!compress || !handle->compress)
+		return;
+
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
+
+	ret = tracecmd_uncompress_block(handle->compress);
+	if (!ret)
+		handle->do_compress = true;
+
+	return ret;
+}
+
+__hidden int out_compression_start(struct tracecmd_output *handle, bool compress)
+{
+	if (!compress || !handle->compress)
+		return 0;
+
+	tracecmd_compress_reset(handle->compress);
+	handle->do_compress = true;
+
+	return 0;
+}
+
+__hidden int out_compression_end(struct tracecmd_output *handle, bool compress)
+{
+	if (!compress || !handle->compress)
+		return 0;
+
+	handle->do_compress = false;
+	return tracecmd_compress_block(handle->compress);
+}
+
 static long add_string(struct tracecmd_output *handle, const char *string)
 {
 	int size = strlen(string) + 1;
@@ -1645,7 +1704,7 @@ static int append_options_v6(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	r = pread(handle->fd, &option, 2, offset);
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
 		return -1;
 
-- 
2.34.1

