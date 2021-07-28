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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56884C43214
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D3A60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhG1NdJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbhG1NdG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:06 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D341C0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id v21so4684910ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gD1fFlFDk8THxLOYebfD7ec/YaNLUhOYZ1Q7DZHtULo=;
        b=ncjJM9wEnuhnJsw1r/0e0jWnyvl3Z6xUqOKdXsCE8ZamfNSy9F1AndwiK2VWGYFCe9
         oS76dsm9U4ggKBlbfVZtvKi6wBd5QbA7kzth9quDR+OFDXU1Q1CPdrDeeN6QE1KTweUX
         zXpGtOAFDTZJSKqL0ZJb4ba8kDr/eoFwiy3p0kTQ+J5X2ZtH3ibO+E7IMNnwJ4T44Zfn
         TtVRXQE3gZT0sw4W7hp5FGIQVH6wmhuleJYoDFKUFt+Twq2J+8+2DpY4OI9CUhgENUfd
         OAIvUyXVZ7NX3byuOeu6cn/+EngixB6DA1HfJIwIFHo37/tBTPykvgV5dnD4disHWt5c
         9zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gD1fFlFDk8THxLOYebfD7ec/YaNLUhOYZ1Q7DZHtULo=;
        b=KdBaWW7bD/15onjqPcyzLpSHOIlWz7nlQlsz4nEgawhB4ll+ZtWkdp7OSCpk7b3M92
         2PAavORE4BIkZGqE3wWkYKmnITI2z5w2OImAaR5affg9jZsUNJJuW24rr6W71VdK92tn
         TwX6WMGGtPt2kPkj8uH/9JW/2jX9hGyQj2ZxguvG6S/FgNP0oPUQbLcuZjxQZLzc4vBo
         +62AkyfOlLZi0dIXFwvzpOBqI4rVamGt+cfLUJ1aQglMY98O5lHCFXMUE3P5nx6ECuN7
         08e9QA7pyaeFjC6XlDRBgaCoQyxG3ERHz7Xsnc0xTehvVm6BQvTziJ/fyn77lwFIExvA
         euDg==
X-Gm-Message-State: AOAM530kdx5YGvFc/3XuGFznMLEsdOcla980Riq0TM/QqkV/qKvBrQBo
        Ve/n8vNSSqxR2Q8LJ3ACECU=
X-Google-Smtp-Source: ABdhPJyOZ3BvpFPt27WVvS3JnAESzBUDkKlkEiIeYq0HCrxoHMt75CJ68NqQ8jlwezi2QcoTqrEqvQ==
X-Received: by 2002:a17:906:24d3:: with SMTP id f19mr16069781ejb.391.1627479182265;
        Wed, 28 Jul 2021 06:33:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/87] trace-cmd library: Internal helpers for compressing data
Date:   Wed, 28 Jul 2021 16:31:33 +0300
Message-Id: <20210728133250.234140-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index eb85f095..fa361766 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -34,7 +34,15 @@ void tracecmd_info(const char *fmt, ...);
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
+int out_uncompress_block(struct tracecmd_output *handle);
+int out_compression_start(struct tracecmd_output *handle);
+int out_compression_end(struct tracecmd_output *handle);
+void out_compression_reset(struct tracecmd_output *handle);
+unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+					int fd, unsigned long long max,
+					unsigned long long *write_size);
 
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 
+
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

