Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CFCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhLBM2f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhLBM2e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:34 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360C7C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:12 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id t5so115449315edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KpTIxeAACJKs5iFeyI0KTMzRKHfHKLzDZVcXaDc7wqo=;
        b=jVqb4P0Dxxcutt6tNPqlnwggsOhzKrz9OPRWVhSn2vFuS8wbmgJ7A/Bzym8b1eaNyC
         JklGgVFsrUfJbaAEWVRdwpM41WsMP3u/NuqDbdPNLEVJwjF3MCM11K2HeD2rSvFtPfwu
         +5IpyL+HfZ7QoL0zi3Q3DMRPW02p77JfMFdo4gNcAouUmZ3Y3yWdviR5DG4UtBArd1IU
         LrnoFa41ymdQLZCz5Akr1hZCeWcMkUh524GMTvqboPHfaIRwEci6aJkZ39j58N55+zqG
         Qqm7raX9G24HwbfVoof0fYnia6CKtUub75/nfLiub1PyPXhDwTtzDbmGg3C1DdgAfWdp
         pLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KpTIxeAACJKs5iFeyI0KTMzRKHfHKLzDZVcXaDc7wqo=;
        b=dTMbKiFUD4PRIUMj9SSCiNEE2DeEX8L1qOx+5UV9wMR1clYwW5GNfD2OoUZx+V5Zto
         E1KnHotmf0zD5AjM/QAnZt/zDz7RDpOgJcdQlPaibsacl93Q988TIkAH9z4FAk1S2SWv
         1tgwOMocN1P0iBJgKd2HEsT+2DKn8EnLBWHref1fampn+t7J82vWPhMzADhopD0DqcJL
         42Txb8UK/uCg1bMes8GFgHZr2k1IhxXQA+qkwjisMDcvkdoQdR1gFMJ0PUnKp5s6C31V
         bAeguWiijUw44kpU9oGcl56Frx3ZdZyAMbn7pc6VPV+UnVeOG61AuRDbKKFu/CMBpYlE
         VzPw==
X-Gm-Message-State: AOAM530CMgU1ojKHxIQbTPxylhmWcMZsixKwVZA7MF+PlLbI0YKc2gtC
        CCywbdp1NpYvSkDsXPXNi13i9LiCrVnGNg==
X-Google-Smtp-Source: ABdhPJxXN54N36eXdE/mePIZhLvNbObXBDEOKtqBwctTS2J5/NUJhUF631CIfkFbkXNP0OcneSQ0pw==
X-Received: by 2002:a17:906:12db:: with SMTP id l27mr15130312ejb.244.1638447910598;
        Thu, 02 Dec 2021 04:25:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 02/20] trace-cmd library: Internal helpers for compressing data
Date:   Thu,  2 Dec 2021 14:24:49 +0200
Message-Id: <20211202122507.43572-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index 23970341..4d58438b 100644
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
index e57d32ba..455fa93b 100644
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
@@ -90,18 +92,27 @@ static int write_options_v7(struct tracecmd_output *handle);
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
@@ -129,6 +140,43 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
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
@@ -1562,7 +1610,7 @@ static int append_options_v6(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	r = pread(handle->fd, &option, 2, offset);
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
 		return -1;
 
-- 
2.33.1

