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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D37C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7DB761407
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhFJLhu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:50 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:40935 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhFJLhn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:43 -0400
Received: by mail-wr1-f45.google.com with SMTP id y7so1900579wrh.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mNhWGc9JKwMhf/44O4SEmqYecOnF74SysaVRk8k6W+M=;
        b=oU1yUKs5dY1elc/4RTz5DfLn5ned2ZThw9vMRBzXEkvlBGs3xGP4bZVAMKYFLobsqv
         7DPgGjEiTUMJo7x4FyJy21mxHgyInc/XplKvjUGsH/4q4s1F9DPPNSc7WiaclhhzJFkq
         2TVy+jIII/KB4TD/cvlb+DO9xUWwzp16Aiazf+tT645no3AP7LtmnLWiDJ29zHCLtdAk
         vAILD03LwA+doN4W2SP8Oa5L5Y6xKZAGr7chOUAlbdGuznoXc7lMksp/dk4vk/riDg3H
         qSSWP5212lrl0vDJ3QkemBcRXoD9l1VS3i1SVT3laQzK80vYRIAUNnc5O41oHnRyRQKX
         3M2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mNhWGc9JKwMhf/44O4SEmqYecOnF74SysaVRk8k6W+M=;
        b=jeaNwiciRbE2Rt/8axZXjMSKJlqEZtvDO7r914AwV0U7L1ASqaQ3DPh28ghFBrHDkj
         MuX+VA78r3L9AxRXc2vzdkakdl01/F2iaI7H+QiojLSMzOaTEvN+Xa3jT3jZ/lod9yTC
         xg/SH6jFwXZ1jjS9uSDBvy/V6qj9Mboy+LEqoU3UkOIS7/rftpCtG89za2cbaZVAhrun
         qWtocVQ/jlIbKxeCzecI0W83tg+wItn0SGagOVECluOSVGanEtItE9iaJ9Ev2Xw8nYwc
         4TQyswBHQk8UZQW6N7klspwVZgmEf1IPFLBAOhKaoqWel/xy2WZuw2rDVbWjHnrX4g26
         W3xg==
X-Gm-Message-State: AOAM533vhqetc/YJ4X9RpbaH4Zm2QxXfRfLt1DItnig8X4h4LsIZofFU
        BT0DsX3o5ZlxxHn/LhYukG8=
X-Google-Smtp-Source: ABdhPJw+q50sLpJ4ZFVCpQZJm0m80wkuyHC1oDPWreMOSwi8Ng6tEMsORcdwbvsmnc8L2rmqU8nD5g==
X-Received: by 2002:a05:6000:1b8d:: with SMTP id r13mr4904256wru.207.1623324887250;
        Thu, 10 Jun 2021 04:34:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 20/40] trace-cmd library: Track the offset in the option section in the trace file
Date:   Thu, 10 Jun 2021 14:34:06 +0300
Message-Id: <20210610113426.257931-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index faa8c533..10089389 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -239,6 +239,7 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
 int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
 				     const char **name, const char **version);
+size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e953909f..b76f2b47 100644
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
index 5bd33b70..1b9cf683 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -66,6 +66,7 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
+	size_t			options_start;
 
 	bool			do_compress;
 	struct tracecmd_compression *compress;
@@ -1858,6 +1859,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
+	handle->options_start = tracecmd_get_options_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.31.1

