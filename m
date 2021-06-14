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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1035CC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE82C61357
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhFNHxy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:54 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:38579 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhFNHxy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:54 -0400
Received: by mail-ej1-f41.google.com with SMTP id og14so15066183ejc.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LfohAIDa1mQgoxdChOqInkj7fzUNXVsse9vwxp5gcE4=;
        b=g780ofVyD8yXCcCay5uLyoKPrbhYVxC11g8luvnDkCNXqoB7UlmY9m9MLvnqd/xTg1
         fjMjVa/lvSMjzLAUYFoCW4ouGPy9/02pLUedx1clfpiGZlbnfOybS+5qYL2BTDNjyRUJ
         mfRl0khWNL4HvNl3JbzaEz0rHcSbQjUIJm3O6R2Hz8Vpv3brGVLXE2Pba0vq2LUhabzw
         VAXG5Z0cVzJB/47GUJeZfUpdnWB1yJkDSnyMpHdpc4Q/BhlJVgMCAZ7WwnLc53LJrlvk
         k8dD3k1bD6ol0gNVM8UWuZNGHwhz/YHnm1R6x33f4GdsZBS+RTioODnalehtw17HjIrL
         hhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LfohAIDa1mQgoxdChOqInkj7fzUNXVsse9vwxp5gcE4=;
        b=aGWxe1KYzZ2YiTdrh0FS151Qu3+9x7R/x2QzOzPMWj6ierJoO0SoRC7cISw9wTmh6K
         Z//95EHDwEtlHy7VI+l+0vnOl3HtNxvN/KF7imn5j9Q8JrqdE2+KSV5dl8v2vZXMzcn9
         FA0kZk0bgFTZiuKe93p6LgzBC9Dk7VMETUDhoJTcEpKa3cCfbYUaDmQrxWxWh3cvofzK
         JrkLmHznRqTAu5bbPtN8YFJR3J+8eCsU9y3yb002t9hsodGWiyr96vESAcgmaTKWpw9z
         5prgGcVAmOLrCLf6ffIaJwpyKBx4KrcrAmX8gHq3R4m2Gd3/F5vWUZkd+E97SPy+r7VZ
         Gf8A==
X-Gm-Message-State: AOAM531c0YqyAS2vIeKrvCVh3CNAc3tYJj17fk3OnqIvq5k1Q1hccYuV
        ZaiVjASdP33F3zIR3te7XkA=
X-Google-Smtp-Source: ABdhPJx6mqEa+uiAQDpx5D+rj1V72VzT+QALuoeNE52dNShxIir+C4KHuQu97XYgRtiVb90eFAJ9xQ==
X-Received: by 2002:a17:906:5488:: with SMTP id r8mr14260934ejo.374.1623657051216;
        Mon, 14 Jun 2021 00:50:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 20/45] trace-cmd library: Track the offset in the option section in the trace file
Date:   Mon, 14 Jun 2021 10:50:04 +0300
Message-Id: <20210614075029.598048-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index 7830f643..bad234c4 100644
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

