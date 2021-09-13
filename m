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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B45C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 312EE60FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbhIMMb0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:25 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0341AC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:10 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q11so14403264wrr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tb+yLbsxfo++BYsRLWBcxjT4Gb/rMmPEQmK9DUpx/KU=;
        b=ix2exfJlX4PwkPTZPXczzy8gu26qF6o/rjJTUvBLM3O4RpXFiuez3O2RESQVawDtn6
         ek1Rq38aoSCoYYjG4DAxkjM7X/VcSp+FbZK2h+M9ByJNKxfzltY22++nOI0eKw4DLrFx
         cL6kqIvM8pzKh/3XBaqY11RKAJLTln4k+MVO6PHYum8llGmjVEL9eHTq7muVGSpKEPaO
         w4BHetzMMlLdzXs8LbNlWx2/DOgyi4nzmYNNfv2S71U6F5WaAt/kohQFD2lzNRM1qy2/
         Rcj2sf6Ds9lHLdlR05Ni8tPD/CeVGA7Wb1cZULWrd70qUX0szR/RZrRmxxrcMZh0LG+I
         v4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tb+yLbsxfo++BYsRLWBcxjT4Gb/rMmPEQmK9DUpx/KU=;
        b=IJA8Blr4oxIR8DYEB8GYomWSJsSjpqleKM3EWeqHLwZOSs1Ku+2sIpJoTTFMK/J1Tn
         v0v4RC0taI/D1N3HtLFbo3W8jKmE6eVo6dB2PTxU15Dt0wtFcoby91vASazZ4pJ6JTUL
         XT9dVkL10FAF7qqJC9gj8t8Lr0g57XI5UJ5HgeKEuhxS4rulmhSjkizy6sIojgSpedfz
         cUhYyq3EKMneZIh18zeA4DEwBNP+s8/84xEvQZQQuSyKCAH+O/BAIo7ldTYrPN2HKSYl
         gK9MNBfbdyL00ZAoCXFNWJmvQYiskqhGn27WYWU8rhtRttY/s6AZKiOMBa3v4eA1vJs+
         KnCQ==
X-Gm-Message-State: AOAM530lKJY27D9N8fxcYn4FYzqN6psyR2H1ItcZhqWKBXeon8CzvXRt
        fCzHnor+TAeaugLqeBRVptizX1U1wj4=
X-Google-Smtp-Source: ABdhPJyyHFs4Xn3xJ7ItNLtu70fIeyRA8rwYrCO2At5becNDJwn8Hn7X5wzV+obMU9AXglBmOA/CgQ==
X-Received: by 2002:a05:6000:374:: with SMTP id f20mr12308818wrf.129.1631536208605;
        Mon, 13 Sep 2021 05:30:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 19/25] trace-cmd library: Handle the extended DONE option
Date:   Mon, 13 Sep 2021 15:29:41 +0300
Message-Id: <20210913122947.3673239-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
index 405b7dae..b29236dc 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -49,5 +49,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f90d003d..009d272f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -175,6 +175,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	bool			options_init;
 	unsigned long long	options_start;
+	unsigned long long	options_last_offset;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2871,6 +2872,30 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
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
@@ -2971,19 +2996,27 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3120,7 +3153,10 @@ static int handle_options(struct tracecmd_input *handle)
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
index 810b7265..4e2c132d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2150,7 +2150,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->options_start = get_last_option_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.31.1

