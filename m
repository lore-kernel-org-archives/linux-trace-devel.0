Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E02FC4167D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352370AbiASIZc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352404AbiASIZb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:31 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ECAC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 30so7614570edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7PpO5wes0CmxlKpspqIMBO3n609WxZs0QKDjgxIZHIQ=;
        b=TwDoH0JGp2jTcL/Cb3ykrz0BjuUPPOSNp0dWQRIY5s8RgCsRIGFdtMp3nbzfu2QIUL
         XsqKiSSNmLLLn5hvNdg5Lr7F/sWbuDqt8dsnItV7EI0b3YfKCrSxU/7Fl/DgJ/GrnnZI
         7XJu729PMrIG0CEBT7jmAs7lZ7pFjJscDDSivLYfg4V/R4y6eKQvhhn7eU+KdoDvwwKw
         lWYf6OWXPiRlZgUC/leacMfpnelZi6AZyFMPEiLFOPlLFN7ADaNQpt5G58YFb49vBuO7
         y2AAo2NDY8JNnS/xjtozNNLmnjF1UCTsSoMdDW5CXoTVDWjPhXa+Xal8Hhh+hqGS7JyO
         IIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7PpO5wes0CmxlKpspqIMBO3n609WxZs0QKDjgxIZHIQ=;
        b=SqoWWBTnuX0x3rip+zWyPZkLaTkCDUXWNtaZ+UbhZlJU/OsbcQXNj4Tv4hCFIN+PLN
         c4P1Q2MGbO74HUlaiBrW0P9J/5FLAgd3d10mHzt0WTCUqofL14PBuvTpKY9Un9fkoGL0
         aUvmbeYTEXuk8PCO5NoFDCV5eTp9TDPVq/SUEflUyI2YxE0HemBnPr8iOFrM7MCp0YtJ
         8gKKm7bug7azPCNBJ5eF1bc13i10IVSqfeeNSa5M6r+2hT9o6iNsusTDNcgz9wFa2Df1
         ir+H44sMPNsp/Br1OiOcvKJPtjKB26Cj3aJGELlZ7UtqnVMCxDJzt2CSyLD9k6bkAJuz
         7+sA==
X-Gm-Message-State: AOAM530pz0ZU7NsGyW2yPpA39amaJjynQu3mHzhEXVPJe6qOCHn9qNri
        jI6Iad+8G2rWQ2GhLHD0eDHG+4pHSo0=
X-Google-Smtp-Source: ABdhPJx9n9u6sttvEPGEOT4z7LnCXAHllltIN0JaLeL5URyi7cHSFoMyTi7hiyw/nUrDfhk2UMukMA==
X-Received: by 2002:a05:6402:31e9:: with SMTP id dy9mr28977294edb.65.1642580729320;
        Wed, 19 Jan 2022 00:25:29 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 19/25] trace-cmd library: Handle the extended DONE option
Date:   Wed, 19 Jan 2022 10:25:01 +0200
Message-Id: <20220119082507.245600-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7 the DONE option is extended to store the offset
in the file to the next options section. This way a list of options
sections can be stored in the file. Added logic to recursively read all
option sections from the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 43 +++++++++++++++++++++++--
 lib/trace-cmd/trace-output.c            |  2 +-
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index ac7e7f17..b4f3d8c8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -53,6 +53,7 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 unsigned int get_meta_strings_size(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1eb92f2a..7f418a44 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -179,6 +179,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	bool			options_init;
 	unsigned long long	options_start;
+	unsigned long long	options_last_offset;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2870,6 +2871,32 @@ __hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
 	return handle->strings_size;
 }
 
+__hidden unsigned long long get_last_option_offset(struct tracecmd_input *handle)
+{
+	return handle->options_last_offset;
+}
+
+static int handle_option_done(struct tracecmd_input *handle, char *buf, int size)
+{
+	unsigned long long offset;
+
+	if (size < 8)
+		return -1;
+
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if (offset >= size)
+		handle->options_last_offset = offset - size;
+
+	offset = tep_read_number(handle->pevent, buf, 8);
+	if (!offset)
+		return 0;
+
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return handle_options(handle);
+}
+
 static inline int save_read_number(struct tep_handle *tep, char *data, int *data_size,
 				   int *read_pos, int bytes, unsigned long long *num)
 {
@@ -2978,19 +3005,27 @@ static int handle_options(struct tracecmd_input *handle)
 	long long offset;
 	unsigned short option;
 	unsigned int size;
+	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
 	char *buf;
 	int cpus;
 	int ret;
 
-	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	if (!HAS_SECTIONS(handle)) {
+		handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	} else {
+		if (read_section_header(handle, &id, &flags, NULL, NULL))
+			return -1;
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+	}
 
 	for (;;) {
 		if (read2(handle, &option))
 			return -1;
 
-		if (option == TRACECMD_OPTION_DONE)
+		if (!HAS_SECTIONS(handle) && option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
@@ -3130,6 +3165,10 @@ static int handle_options(struct tracecmd_input *handle)
 			section_add_or_update(handle, option, -1,
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
+		case TRACECMD_OPTION_DONE:
+			ret = handle_option_done(handle, buf, size);
+			free(buf);
+			return ret;
 
 		default:
 			tracecmd_warning("unknown option %d", option);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 2b5671ae..fe4fcf64 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2254,7 +2254,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->options_start = get_last_option_offset(ihandle);
 	handle->strings_offs = get_meta_strings_size(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
-- 
2.34.1

