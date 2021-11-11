Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C59BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052CF61268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKKPOs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbhKKPOs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:48 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A44C061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:58 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g14so25479325edz.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wGtg1MjDRh2b0GvnBljxRlAXnNTb2QvLiEXxmBN//mU=;
        b=mrRHIxEvHwnEZodXYFF9449cpiR4iSSCGTnf4fWGWadqVXmpia/IKw2Kq4YNRrhoOr
         HxwEvGOxhXAuOr82G8VWlntIjnzzzWA76IQUJdlGWj3rD42Ktoj+xIyxlPy1Cfx3yl4O
         H22C87OtEj4JihxJvidubsGi8JBCfOb8fSbb9LFtKy4hmjk87+96mD864Lt15ZUsXLRn
         4xJVOudFH0pGNI7+HDY3tp/udVy4iHnm/rR7Gf7JzazNBK2k7ZQafJMKwbjrVDXWBcX3
         NWZUW5HBxq3h3b5rgeiAqYz1iJnoikTprhvenMR+2laq0JaD4EF58aQmkxMuF9hnrRfy
         OOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wGtg1MjDRh2b0GvnBljxRlAXnNTb2QvLiEXxmBN//mU=;
        b=NaBGMOcxM5b6b2zgCuLPbHDoeU7cNHQplsbW1cA9b3DId0AQa0XIVrToLhK1cKaJMq
         EHlNoqtfnW5r2grmA1s8WycVDStlCiYulAulROrNZbe0a6xSGgS+WKVFGQz+xnm1j+D+
         fGwxf+Hgn/lVtsoBZhkBM9/nEHF06mdXPgaKQL7r3vz0GOnr5GeaxQU4yYiNbXsuD+yN
         iHrI2oVq7A78+jgYHXyf+06neImexEYuXLGBNmhICZW/Ix4sD9AZfrwVCydElQGnktCK
         1s//kmiU9K+2yq+Gm0+eeFzBkZFA6BPwbIcCkdk3kTxaBql/miZp07HpytFK1yO3A8fY
         uI4Q==
X-Gm-Message-State: AOAM532tTV6UOu9rEiiYmIF6y8HT1Efly+gP4BiFAi/EIsPiVpYC58hQ
        KQZ5qNs1Ka/3ibHu6u9lKZSGPyol4MiDFw==
X-Google-Smtp-Source: ABdhPJzUtdsfon4a/9v4/jnSZdwUGZeRLw4toyiXvTtHgm4KSObLEU3rIHLvtHNHBd+cSsfiZn4/9A==
X-Received: by 2002:a17:906:3b84:: with SMTP id u4mr10186961ejf.310.1636643517521;
        Thu, 11 Nov 2021 07:11:57 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 02/20] trace-cmd library: Internal helpers for compressing data
Date:   Thu, 11 Nov 2021 17:11:35 +0200
Message-Id: <20211111151153.86855-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index fb008678..393d05e8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -40,6 +40,13 @@ void tracecmd_compress_free(void);
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
 			 char *description, enum tracecmd_section_flags flags, bool option);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e06931ce..c9cb174a 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -64,6 +64,8 @@ struct tracecmd_output {
 	unsigned long		file_version;
 	tsize_t			options_start;
 	bool			big_endian;
+	bool			do_compress;
+	struct tracecmd_compression *compress;
 
 	struct list_head	options;
 	struct list_head	buffers;
@@ -88,18 +90,27 @@ struct list_event_system {
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
@@ -127,6 +138,43 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
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
 /**
  * tracecmd_set_quiet - Set if to print output to the screen
  * @quiet: If non zero, print no output to the screen
@@ -1544,7 +1592,7 @@ static int append_options_v6(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	r = pread(handle->fd, &option, 2, offset);
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
 		return -1;
 
-- 
2.33.1

