Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F7BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346765AbhLBM0M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358088AbhLBMZe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:34 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56737C061763
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:12 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id e3so115336548edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bqFZF3pWrlSg8OwoFjin00DzdswcDokwSgxyltkZlJ4=;
        b=J3WlcRgBOB49TOG2gB+ykVNFl9Pb9KoCBLuJSyp4vH/+zNm6POM8KsDWpjXtV0u47T
         B0PPtESTieD8+T4ZsXs59VvUaoiBzZfDMg4iFbhixkXnqgo7OzOmC4qVyhvDcz3NDVpw
         CHkB9ed3PRNvmGjRCPgJKOjihSUnh5wXaXEOpewFZQ1oTLUbmgHEd/A6HdRXg99LyYsm
         o25TTl3GEWyCV0FxJv5lqB0CcVaMdeO6+9tI9ksGglmCcIaW/i2NpgK17Ug+9iSLDfqc
         634OwcEJQntYJYYjYFXG5q8eclV2o4wi7Rz6v2q4Wd5yokiGMYOOsK0HrIr7A6AeLvKZ
         EGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bqFZF3pWrlSg8OwoFjin00DzdswcDokwSgxyltkZlJ4=;
        b=A0uiB4JrPvJMscKyRfgLavkvbfTEKp4i9T/6H2Cmvw4lDpahs04sorN2Z0aNgEEZuC
         UOgHGNr2f8qNj/oRivvWb/u4w3haWlqXMR8N1bEIRJP9iAOkK9Fwqvcvfp2JHxvjVMsk
         duqM46Z/RpmCVwK5rhLU10GActvcXHLpwL9wzJkQN5zqoveM49xrvY90OHy4AJ5O0yzI
         B19WG7Deryiwo3BgFE7C2D88h0q1S2BAU8NUHCzkcu0EMddu8oPgjzrAhr5X84+m49ty
         bGEvDzLktf5KNYzsQD/MvgtuXBSFIJ+dWtsnrC5dTLt124x4iYmrSXE2+xZMwVbqNGaU
         huZw==
X-Gm-Message-State: AOAM533H3gkXeilm8hE8UXCVl8mylbwthWteCkcP1P3zFpgSEkF6ZXZ3
        TH0pjuik72HLkOvzk77u7v9TecQ1iUE79Q==
X-Google-Smtp-Source: ABdhPJwi/C/b6m4XtNQdu5BAgGQbU1/aDxsF1Yfq8iejcxwZS1RN1QsODrBeiGiJjJj58k7nF6AJPQ==
X-Received: by 2002:a17:907:75d3:: with SMTP id jl19mr15279982ejc.520.1638447730898;
        Thu, 02 Dec 2021 04:22:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 17/23] trace-cmd library: Handle the extended DONE option
Date:   Thu,  2 Dec 2021 14:21:46 +0200
Message-Id: <20211202122152.43275-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c             | 42 +++++++++++++++++++++++--
 lib/trace-cmd/trace-output.c            |  2 +-
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 4a0a691c..f4b68352 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -53,5 +53,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index abab218e..629abcda 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -176,6 +176,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	bool			options_init;
 	unsigned long long	options_start;
+	unsigned long long	options_last_offset;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2858,6 +2859,30 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
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
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if (offset >= size)
+		handle->options_last_offset = offset - size;
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
@@ -2960,19 +2985,27 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3112,7 +3145,10 @@ static int handle_options(struct tracecmd_input *handle)
 			section_add_or_update(handle, option, -1,
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
-
+		case TRACECMD_OPTION_DONE:
+			ret = handle_option_done(handle, buf, size);
+			free(buf);
+			return ret;
 		default:
 			tracecmd_warning("unknown option %d", option);
 			break;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 408828a9..c613c2ff 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2162,7 +2162,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->options_start = get_last_option_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.33.1

