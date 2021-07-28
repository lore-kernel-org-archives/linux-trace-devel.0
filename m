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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B48C4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA57060EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhG1NdT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhG1NdQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:16 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CA1C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:14 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id nd39so4649100ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gIu/A0bizF9ladTQvsi6WLsUy1y5pvn/am1vbuXBgiE=;
        b=jtsctGDXrUNjO3aNFGjTngPpy1KnARrOz3DfDcWD716AIew3nPmdhsZ6EF7vfn4mmW
         36vYDT80G+JRbw2UZc5UyaVn7APKoiBQFgpWqckGVlUmTbjUeSOCyavnE783LnFB0zSW
         kudGZIFhbN7f33VuOaa9NHzlsO+qZyRdReGhPqSIiDfKHPus9NX1YOCJvRj/5Vdqf92R
         pJnRF++smHfdCJd7Xpv0w30whKRfELq7bBpFshuxhTNSNY1Px2NeVV24/wYmGkqAn5IP
         rheZEHgKmUAfbRR8NV4qJYBa15Im3vBMjDM1XaoO/JxBB7peLI6MsbhVnKBs91O4dN4W
         XVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gIu/A0bizF9ladTQvsi6WLsUy1y5pvn/am1vbuXBgiE=;
        b=B8YbU3HhicPMPI42X9v3GhBQBq2zhhxIBeak4rC6wpJrqXkbG3IZgowK1AvfLyvRA1
         DeCaC19uRK7ZYvb1iD6E+Z10odUZbA+U1Rp4BwOx9o20/C+2NO8byF5gV2sSb7JyRNex
         rp8P9jFW12SFIAIHPnrd4ELVS62EtpzK+rjX2oSBh7gFLkm73N7AVfoY/5whjoq2y0Zp
         tvkDSl46IFAE70p0LmwlUdv7zIIqOMaR8Vh77ewhqnqVAFsVI/BVqRVasvf1fET0A6B6
         MxgShdyLx1RGp1XQfIeBsN0t6UYCOtUn56uRuOUjtEWLfUKlAhwjtTWQT52D+aG0UtgO
         xh8w==
X-Gm-Message-State: AOAM530g6StLh1klBMOTos2L+e5Pz0noGaiJdNsY+NeNvddRzL9OkelQ
        VbJ0H8h4tVyJeC9+aiSFijY=
X-Google-Smtp-Source: ABdhPJzGYrZ1Bngszm83arLu+oRQcXmfSaMjnLecJwb1WrhKNAuXOZfFwjWrTMTk1sVv68IYFASgSA==
X-Received: by 2002:a17:906:7111:: with SMTP id x17mr26846716ejj.294.1627479193075;
        Wed, 28 Jul 2021 06:33:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 21/87] trace-cmd library: Add internal helper functon for writing headers before file sections
Date:   Wed, 28 Jul 2021 16:31:44 +0300
Message-Id: <20210728133250.234140-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 77a82cc1..6b2350f9 100644
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
index 58f3a0c5..ee28502f 100644
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

