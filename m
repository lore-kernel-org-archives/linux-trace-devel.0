Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E354C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 810C960F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbhJHEYQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhJHEYP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E09C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:20 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a25so15479556edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ulj39QlGWIj2iZbN2TtCGOnuyhw30EOyLNVn/hHxpj0=;
        b=GHOdyvncxIbHqSNvxqc5B59QmD15gz2OCuhjkVVaT7wmCZjamIrmyaDJy2iSAlRpHZ
         u3YiKo8gO6RY/iGdYMOSXMDH6ZzeD5GZcpw5ofDjFp6NNUfDxUIkH/qo/6IOc7njgWu9
         QgxGHHNf6Is6820Az6hIi//S1F+JMYzTUjMmM/v8C0eSsOEf5KCWM9HF/trWa6Cg3o53
         E062jqi1W1IYfZk/9u/Kh9bxNkZn7Yw7+BFhvbBwJGyi8fLWW3lyw5bgTh74mLk7BvqL
         s5kYWH6jZyG55KeO++0dTJpomgjrteq9YNpeGh8s4ERoDhXX63iiFwHZwM96Cm08zn43
         pSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ulj39QlGWIj2iZbN2TtCGOnuyhw30EOyLNVn/hHxpj0=;
        b=NCPJmWNfgaq+eASOSKYevM/nxd5vCUQ7rDHieQzg6N3xPjSx76WXlyLuByhVbS21zv
         QMmFg73UWSqUJcuf8w8PTuf18vZvtDeZHOgiDmOay62d/bJDwU2cjzVQzO0vASz0tbyU
         SFNzhHL3L6z+rPjwE9Zjc2cCbFovnzqPnJVjxq5fQwCwqf4ePVXt+RyaRVS4POZeovrw
         STsyA9iREJR7aQKC4QkMCAdAbUBUIaWMI+grmUmsLvMbFSugPbgaqW/aGjxIr/vLrEfg
         bmC5S9MzNAwOL7pE7T2kMZ2uBPMceCEnJVYeU0yeKQdbmc/vGUr+441tzzpL37fXC3ID
         Pwqg==
X-Gm-Message-State: AOAM53112xOsEOfbG8ZGqgerfXj4M8toqp8RAq1jwJmRDOMzlCz3OW+h
        3gJp6Qhl/Asax5AOsXXxpzFymBoaMjN8Wg==
X-Google-Smtp-Source: ABdhPJy0m2vESGIZmF3vHTjJ4rqJ/sG1Ukw49nrjxHl2caAzwVcQFh1jf/16gbng2Yak5/9gNDAIFA==
X-Received: by 2002:aa7:c78f:: with SMTP id n15mr12089074eds.338.1633666938826;
        Thu, 07 Oct 2021 21:22:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 02/20] trace-cmd library: Internal helpers for compressing data
Date:   Fri,  8 Oct 2021 07:21:56 +0300
Message-Id: <20211008042214.977193-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index a3b75c08..54eec93c 100644
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
2.31.1

