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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D7BC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21CC61052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhG2FK0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbhG2FK0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F8DC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h8so6414377ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kD3+Fb2srAq0Ymc8SYIc9EwpBab2zSxSmmk3yxgTfio=;
        b=PXCTHVrdorkLNJf/dOH621uuS95dFSFojdTmBi13V0xH21QsV5bq4woerywjJY75G/
         mlq0bc2lUygR9w6esMMu28a5oQaOFLVHFw8dgspLGnPpfr5A+Ca97uy51LRLCtjqwNgh
         UmticKISt9TZrp9qoklJ7g5co2gmSW42Eg9mvE6uydi5KuLx8k7S+AtP/pO6woqG3pj1
         NzSwaGrRweFdqBavxE9eITqVP0wsGOKomDIvnPxF4AMyPwc3K9x5UeASoS9qcT5Ynyw5
         pDuzWg04bzIiVPo/EgmL68hs77+Ev9Jpy4PVbkke0ADWhIkh6v8AQ3WUjVJnznsNc325
         0xhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kD3+Fb2srAq0Ymc8SYIc9EwpBab2zSxSmmk3yxgTfio=;
        b=bB4yiMnUCXZw2+cfPijwhrGejRmABIRHsyw2qbSLtqLj16kwgDUY3XFdGfnXKlmVud
         e8hEosKPFt4Tp0svU87BnIX7RM/z//WXz+isiWg00WjcyL3KwlabJcS8Y7mkS9Ei4CrO
         lJJrkKPeQxKg75avnfm83PBIanKwwAVqyoeupt0l70eRQgDkJDfXCjc46K+FIj0khuyJ
         m2wpGnbVrmg4VqSRWjaI5QnKGv9CIBMKtFwZBQLDXWKzh073/OSffJsykMTFeuX8+lks
         4Mt+qrTE4NX+e9VGdgCcgN4CCWff8qyBtflPz+XaBN0/lvOlEbCuhil/xCoCTOgt2QQi
         wCoQ==
X-Gm-Message-State: AOAM532HGgxcEWf/IQmza/s2zJFSiUjkcYRmSbeKJFZhqKsrmn5VCBzi
        dnmMFSoxev9eKtRMbtHT86W8cjGWfQ7bxA==
X-Google-Smtp-Source: ABdhPJwgyPX8z2S1lnV5R9/elacMkhWWjUJJ8Zf58F5zjFp/o3oU+KnN8VXEmatseai7va7qHT+1pA==
X-Received: by 2002:a05:6402:781:: with SMTP id d1mr3992984edy.32.1627535422137;
        Wed, 28 Jul 2021 22:10:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 21/87] trace-cmd library: Add internal helper functon for writing headers before file sections
Date:   Thu, 29 Jul 2021 08:08:53 +0300
Message-Id: <20210729050959.12263-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce headers before each file section, in trace file version 7. The
section header has the following format:
 <2 bytes>, header ID
 <string>, null terminated ASCII string, description of the header
 <2 bytes>, section flags:
     1: the section is compressed
 <4 bytes>, size of the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h                 |  5 ++
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/include/trace-cmd-local.h       |  4 ++
 lib/trace-cmd/trace-output.c                  | 70 +++++++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6984db86..6c76b928 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -15,6 +15,11 @@ enum tracecmd_open_flags {
 	TRACECMD_FL_LOAD_NO_PLUGINS		= 1 << 0, /* Do not load plugins */
 	TRACECMD_FL_LOAD_NO_SYSTEM_PLUGINS	= 1 << 1, /* Do not load system plugins */
 };
+
+enum tracecmd_section_flags {
+	TRACECMD_SEC_FL_COMPRESS	= 1 << 0, /* the section is compressed */
+};
+
 struct tracecmd_input *tracecmd_open_head(const char *file, int flags);
 struct tracecmd_input *tracecmd_open(const char *file, int flags);
 struct tracecmd_input *tracecmd_open_fd(int fd, int flags);
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ee224903..77948fbb 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -135,6 +135,7 @@ enum {
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
+	TRACECMD_OPTION_MAX,
 };
 
 enum {
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index f799ea8d..2a23d9e0 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -42,6 +42,10 @@ int in_uncompress_block(struct tracecmd_input *handle);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
+unsigned long long
+out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			 char *description, enum tracecmd_section_flags flags, bool option);
+int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
 
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 5d3fd58f..74192ea2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -366,6 +366,76 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
+__hidden unsigned long long
+out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			 char *description, enum tracecmd_section_flags flags, bool option)
+{
+	tsize_t endian8;
+	tsize_t offset;
+	short endian2;
+	int size;
+
+	if (header_id >= TRACECMD_OPTION_MAX)
+		return -1;
+	if (handle->file_version < 7)
+		return 0;
+	if (!handle->compress)
+		flags &= ~TRACECMD_SEC_FL_COMPRESS;
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	if (option) {
+		endian8 = convert_endian_8(handle, offset);
+		if (!tracecmd_add_option(handle, header_id, 8, &endian8))
+			return -1;
+	}
+	/* Section ID */
+	endian2 = convert_endian_2(handle, header_id);
+	if (do_write_check(handle, &endian2, 2))
+		return (off_t)-1;
+
+	/* Section description */
+	if (do_write_check(handle, description, strlen(description) + 1))
+		return (off_t)-1;
+	/* Section flags */
+	endian2 = convert_endian_2(handle, flags);
+	if (do_write_check(handle, &endian2, 2))
+		return (off_t)-1;
+
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	size = 0;
+	/* Reserve for section size */
+	if (do_write_check(handle, &size, 4))
+		return (off_t)-1;
+	return offset;
+}
+
+__hidden int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset)
+{
+	unsigned long long current;
+	unsigned int endian4;
+	int size;
+
+	if (handle->file_version < 7 || offset == 0)
+		return 0;
+
+	current = do_lseek(handle, 0, SEEK_CUR);
+	/* The real size is the difference between the saved offset and
+	 * the current offset - 4 bytes, the reserved space for the section size.
+	 */
+	size = current - offset;
+	if (size < 4)
+		return -1;
+	size -= 4;
+	if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	endian4 = convert_endian_4(handle, size);
+	if (do_write_check(handle, &endian4, 4))
+		return -1;
+	if (do_lseek(handle, current, SEEK_SET) == (off_t)-1)
+		return -1;
+	return 0;
+}
+
 static int read_header_files(struct tracecmd_output *handle, bool compress)
 {
 	tsize_t size, check_size, endian8;
-- 
2.31.1

