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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F969C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04DD461186
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhETDVr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhETDVr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:47 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B165C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:25 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lz27so22915136ejb.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gMo8KC9sNILqewOKWuCmRF3qHF+EaLVS8tEPPLTTOtM=;
        b=YGgP7yLtM6N2qkK66XPuL2e7jzAjL+UNqImN6112FJP2giotWztPSiHmfJF4QTU09a
         nZAWCqorR5ov6JKbiPXp7gQiDdS1Vb43zFdaldYT6XEL7GG55m6+SuW0BOPoZ7vMDmtj
         plx4vI7Sms4Vk3Tl9KV3IcKsjd06lljVuTMKawcBzMKh0Sl6Vmvoia7CQH1ynR1iyHXi
         mm4c7evEA8tA4wQjXveLF91RQ1aWesn0vV1/R5riEFDk1O1tD0Rmb2f39Fg9orsXyWuY
         O+ry2B79AncpHYDTwaAWYK6UKWrH29lMqNGCtca0ce862Ate6FlsGOCoDSnrAN1nfcfG
         Yofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gMo8KC9sNILqewOKWuCmRF3qHF+EaLVS8tEPPLTTOtM=;
        b=ju/kbGSuGzIR0oIrLz7+Ou3LUmgR71KsQZBsnahnAseU/kHTUiqAG691nTJMTnJlab
         sgT5jWGo+Ux2T695qUuJsFcSJrnEJ+gYDZu/cjA436yJV9wX0cHbvAhrjoJuILce8/eR
         iwWQ19yTdE+fH5Z4a5/jakd4cOYBi8vFcNKSmjPF5BvLo+4E8ueJTOXorP1YEJ7m/acE
         lhCLu65E7QX6pZjvX/ottq/4ZCHEcQjsavFVc448ZqJNpVads4WDspCtto+hEcq1pDek
         +WLAnVEhsq4M6xgDwBBK0zvZlg+nmAAG8E78WftbeLrZZ8V91e+62+ned+EOs+Y/sx/y
         VwRw==
X-Gm-Message-State: AOAM530BXRto1WDcifw0kb1np5Us9eP2znUDvu/0ojElX9fAaitBMeYr
        c9Y481fpDknXKvtJD5tXBBg=
X-Google-Smtp-Source: ABdhPJyyEdxDtFkX9kJGZXDfF/mUy+NX2/kWUDLONekfdf2HQKMJh+bE7iEbXrmhm0yXDIXtJ1bd2Q==
X-Received: by 2002:a17:906:458:: with SMTP id e24mr2497270eja.199.1621480824206;
        Wed, 19 May 2021 20:20:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 20/29] trace-cmd library: Track the offset in the option section in the trace file
Date:   Thu, 20 May 2021 06:19:50 +0300
Message-Id: <20210520031959.346165-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading / writing trace file, store the offset of the option
section in the file. A new internal API is added, to get the offset of
the option section from an input file handler:
 tracecmd_get_options_offset()

These changes are needed for compression of the option section from
the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
 lib/trace-cmd/trace-input.c                       | 11 +++++++++++
 lib/trace-cmd/trace-output.c                      |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d67ec86e..2c28ee04 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -239,6 +239,7 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
 int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
 				     const char **name, const char **version);
+size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ec83ab09..ee3c23f2 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -157,6 +157,7 @@ struct tracecmd_input {
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
 	size_t			event_files_start;
+	size_t			options_start;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2759,6 +2760,7 @@ static int handle_options(struct tracecmd_input *handle)
 
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
+	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
 		if (do_read_check(handle, &option, 2))
@@ -4213,6 +4215,15 @@ bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle)
 	return handle->use_trace_clock;
 }
 
+/**
+ * tracecmd_get_options_offset - get offset of the options sections in the file
+ * @handle: input handle for the trace.dat file
+ */
+size_t tracecmd_get_options_offset(struct tracecmd_input *handle)
+{
+	return handle->options_start;
+}
+
 /**
  * tracecmd_get_show_data_func - return the show data func
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 580882eb..fd899c45 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -66,6 +66,7 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
+	size_t			options_start;
 
 	bool			do_compress;
 	struct tracecmd_compression *compress;
@@ -1854,6 +1855,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_file_version(ihandle);
+	handle->options_start = tracecmd_get_options_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.31.1

