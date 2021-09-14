Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CADC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD5160724
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhINNSI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhINNSH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:07 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CBCC061760
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:50 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso2057981wms.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/WbC7tNCfgykiPCeK3OcLPHTUQbxsfeQD6Twyvant50=;
        b=D+tb9qml4avBfO7U3YEiEkvMiDM71qMmK0LB5q8N19jZtC/p1KPkwTMeW1fnQqi5Ey
         wKLc4Qc5z3Spn2UwVleli3FZuqZbZGKdMQ6OkqCrWhcQoUnxQvfkeiUDk3luFtfE4I3R
         WN9H0MpfLhxjCo06V0I0iiQFYugm3bsptXmA++sAn0TrNBV893xLaPNkF9jnszg3xVWJ
         0bNTrDk1Hq1p9VWVpgA399SNIsFS1AYwbwwLqozj1t4Wqdql8IBrc2W8RSbMWzTVjzLi
         7lQ7H3oplxjrQ7wYfZ0y0jHm0nH6o7XkwO9Oi/A6Mdi87hDGDMQM6zmvrhSkF6NI+rSE
         LKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/WbC7tNCfgykiPCeK3OcLPHTUQbxsfeQD6Twyvant50=;
        b=2PMSP8l9R5Tg1EEXkTe7qrEaauzL8EJbvzPRtg5n0d45yttyA2ovSj1Hmbj7o1RCk2
         rjWtFFsRirC68irguc32uydMLCX3zvrfsLA5N0IJTbkSc68vIiw06MoQfARI3pF2dULY
         VqsIJSbIr9vGjh64guw3z9IFlWInA+m9XTkkNyYC3Abmdm0qbJOYbKczSQYGYFH9J1S3
         y7W3MTSVTxL8/SXipCS2yM5w13hm134J+J/FtgB7GzbzorYhqYni4EyhceuCRfbdaGvM
         FW2GsbtFJU0wE2xkfon79/ijBxUL4dWet8USyd41+jCvght/dDFyi5uiRlxd9EicXVSY
         gkHw==
X-Gm-Message-State: AOAM533WxC9T++b4yA8I6CCyvCPvS+KzOkOkcqn7qukzVtZzyltBCZAl
        sDdWL/A+luudpIDY1jWQGCQCMDidx80=
X-Google-Smtp-Source: ABdhPJw4aUtFXYxuNJUQDhB+BbmXaIDZV8e7H4/L3VVREV+S+aeCZDxnohSC9mwyr+6luMgDk6lJCw==
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr2149862wmr.168.1631625409119;
        Tue, 14 Sep 2021 06:16:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/20] trace-cmd library: Internal helpers for compressing data
Date:   Tue, 14 Sep 2021 16:16:27 +0300
Message-Id: <20210914131645.3966308-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index bd95a1fa..304bec49 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -38,6 +38,13 @@ void tracecmd_compress_free(void);
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
index 645a8ab7..d9502023 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -65,6 +65,8 @@ struct tracecmd_output {
 	unsigned long		file_version;
 	tsize_t			options_start;
 	bool			big_endian;
+	bool			do_compress;
+	struct tracecmd_compression *compress;
 
 	struct list_head	options;
 	struct list_head	buffers;
@@ -89,18 +91,27 @@ struct list_event_system {
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
@@ -128,6 +139,43 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
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
@@ -1552,7 +1600,7 @@ static int append_options_v6(struct tracecmd_output *handle)
 	if (offset == (off_t)-1)
 		return -1;
 
-	r = pread(handle->fd, &option, 2, offset);
+	r = do_preed(handle, &option, 2, offset);
 	if (r != 2 || option != TRACECMD_OPTION_DONE)
 		return -1;
 
-- 
2.31.1

