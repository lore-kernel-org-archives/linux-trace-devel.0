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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA58C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACA560FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhG1Ndl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbhG1Ndk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:40 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F652C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:39 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y7so1012220eda.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5EzgByu9zsBqVPgoYYjuHSjkMa8gi6KexktRVVE57l0=;
        b=CxJXH2hkn82EQE99g1Wzbxwe9aykPrXjMfExuK8vZZaZy+EWPFDpSSFpR68QVJGkGl
         jmIsleBwl6xnfVeK8bpE5+oj5DxMtgJQw7wBJ5GqYgkKQFvnzusxa3GL793eBoIJAdsH
         WmZbN9QaobwKT40WpyNFeCwOaswjfYBcuARFf4mCz7wiBJP315jyj8bmm/qyCIEOW691
         CIZcm3Np9pa+WZzyUmQiQmYiWMZKadSAoKZkOmI37HSVz3wZAryu6WLchH6r7OZa0IIE
         bQk2egcv3ZHwJzVNsIieQgs4VMZnK6hVYT2g0XHf/WQK77eV0aFteqpsCMbEzr7fBA25
         joOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5EzgByu9zsBqVPgoYYjuHSjkMa8gi6KexktRVVE57l0=;
        b=WWvWA5dVJNLV1bY2SjvpKD6fc8tgGe+11b15kZI34BLBSikbPZHSGBIlcep1CjnYg5
         U/cJ8oWHSF8ZpPebffD5uPe0+QEaSYjyJWQBpVLiYkyFgqoNWarNv7TAY1UJwAnJBrPA
         IuRB5SDedvacS8EZlJjmyMLeBWEtVkPw/z2bBJLxXV/DtA9f1OCGbDAssgY8PssCfPew
         med1rjt+KCtoaR5nb8lXkBeVAA3c25vDaPDE91iL0Pb3+IKggC4334rnmuWg92yKteo8
         0ZHvvxcHgoZGSOMK7oq8fhwtXU08S+7B4Ve5R5qJp/WCJ8y7CBy1olDMjiCMVcEH2LAe
         EIgg==
X-Gm-Message-State: AOAM530kUBNJakM1cL9nPfevawVkykqRsMOHfSPEx5UaCorJuX6gt/s4
        jifSp93RXqto4YXF2oZbTG0=
X-Google-Smtp-Source: ABdhPJyrHsvIMK03uo0b/0ogf274CGyz5W1iLyS3PVMJSAksRLTfT3p2/VnRfJHXuH3+WpO/oGEHWQ==
X-Received: by 2002:a50:ed14:: with SMTP id j20mr17279783eds.323.1627479217676;
        Wed, 28 Jul 2021 06:33:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 45/87] trace-cmd library: Read headers from trace file version 7
Date:   Wed, 28 Jul 2021 16:32:08 +0300
Message-Id: <20210728133250.234140-46-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has more flexible structure than version 6, headers
are not located at fixed position in the file. A new logic is
implemented to read and parse the headers from this new format.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 150 ++++++++++++++++++++++++++++++++----
 1 file changed, 136 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2c626d37..e288c55f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -164,7 +164,8 @@ struct tracecmd_input {
 	struct pid_addr_maps	*pid_maps;
 	/* file information */
 	struct file_section	*sections;
-	size_t			options_start;
+	bool			options_init;
+	unsigned long long	options_start;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -961,19 +962,7 @@ static int read_cpus(struct tracecmd_input *handle)
 	return 0;
 }
 
-/**
- * tracecmd_read_headers - read the header information from trace.dat
- * @handle: input handle for the trace.dat file
- * @state: The state to read up to or zero to read up to options.
- *
- * This reads the trace.dat file for various information. Like the
- * format of the ring buffer, event formats, ftrace formats, kallsyms
- * and printk. This may be called multiple times with different @state
- * values, to read partial data at a time. It will always continue
- * where it left off.
- */
-int tracecmd_read_headers(struct tracecmd_input *handle,
-			  enum tracecmd_file_states state)
+static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_states state)
 {
 	int ret;
 
@@ -1039,6 +1028,139 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	return 0;
 }
 
+static int handle_options(struct tracecmd_input *handle);
+
+static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
+			       unsigned short *flags, unsigned int *size, char **description)
+{
+	unsigned short fl;
+	char *desc = NULL;
+	unsigned short sec_id;
+	unsigned int sz;
+
+	if (read2(handle, &sec_id))
+		return -1;
+	desc = read_string(handle);
+	if (!desc)
+		return -1;
+	if (read2(handle, &fl))
+		goto error;
+	if (read4(handle, &sz))
+		goto error;
+
+	if (id)
+		*id = sec_id;
+	if (flags)
+		*flags = fl;
+	if (size)
+		*size = sz;
+	if (description)
+		*description = desc;
+	else
+		free(desc);
+	return 0;
+
+error:
+	free(desc);
+	return -1;
+}
+
+static int handle_section(struct tracecmd_input *handle, struct file_section *section)
+{
+	unsigned short id, flags;
+	unsigned int size;
+	int ret;
+
+	if (lseek64(handle->fd, section->section_offset, SEEK_SET) == (off_t)-1)
+		return -1;
+	if (read_section_header(handle, &id, &flags, &size, NULL))
+		return -1;
+	section->flags = flags;
+	if (id != section->id)
+		return -1;
+
+	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
+
+	switch (section->id) {
+	case TRACECMD_OPTION_HEADER_INFO:
+		ret = read_header_files(handle);
+		break;
+	case TRACECMD_OPTION_FTRACE_EVENTS:
+		ret = read_ftrace_files(handle, NULL);
+		break;
+	case TRACECMD_OPTION_EVENT_FORMATS:
+		ret = read_event_files(handle, NULL);
+		break;
+	case TRACECMD_OPTION_KALLSYMS:
+		ret = read_proc_kallsyms(handle);
+		break;
+	case TRACECMD_OPTION_PRINTK:
+		ret = read_ftrace_printk(handle);
+		break;
+	case TRACECMD_OPTION_CMDLINES:
+		ret = read_and_parse_cmdlines(handle);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
+	return ret;
+}
+
+static int read_headers_v7(struct tracecmd_input *handle)
+{
+	struct file_section *section;
+
+	if (handle->options_init)
+		return 0;
+
+	if (!handle->options_start)
+		return -1;
+
+	if (lseek64(handle->fd, handle->options_start, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("Filed to goto options offset %lld", handle->options_start);
+		return -1;
+	}
+
+	if (handle_options(handle))
+		return -1;
+
+	section = handle->sections;
+	while (section) {
+		if (handle_section(handle, section))
+			return -1;
+		section = section->next;
+	}
+
+	handle->options_init = true;
+	return 0;
+}
+
+/**
+ * tracecmd_read_headers - read the header information from trace.dat
+ * @handle: input handle for the trace.dat file
+ * @state: The state to read up to or zero to read up to options.
+ *
+ * This reads the trace.dat file for various information. Like the
+ * format of the ring buffer, event formats, ftrace formats, kallsyms
+ * and printk. This may be called multiple times with different @state
+ * values, to read partial data at a time. It will always continue
+ * where it left off.
+ */
+int tracecmd_read_headers(struct tracecmd_input *handle,
+			  enum tracecmd_file_states state)
+{
+	if (handle->file_version < 7)
+		return read_headers_v6(handle, state);
+	return read_headers_v7(handle);
+}
+
 static unsigned long long calc_page_offset(struct tracecmd_input *handle,
 					   unsigned long long offset)
 {
-- 
2.31.1

