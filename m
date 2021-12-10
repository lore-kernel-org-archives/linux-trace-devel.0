Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E00C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbhLJK6m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbhLJK6m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:42 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D22C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:07 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so28283356edd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JtadsFVK6wgToj2YoVlhTAbfcezvFiQMYBJv4VVguP8=;
        b=pvSIXcicoYZC8jN/cOwO2uajBzr2X+qWbRpxlKdQLQY0CE/JKifgvbJyM5NkVN7YKw
         Hg5qB0htiNend5n/kcI3LnEhknLswIHlFoFza+p59853ZwUz1YRX+doBIPhlKvK9E05T
         Q0YY8R3k7Q/BfZF9jiqb/CBc2h8+B9hDsLOJZq2nC0UYWudhKWzxbGVwp+bTtGhueLzZ
         XvPMc/o9rB+gd17Q8cPZC5O1aO3X3yq98ObuYWkqPAhSqwDnkcexRNruXHaThLjnw+Nc
         UMQZa+edF0EfnB/m7StPsdnq6Ouv/5HeVbtpCpn5X4FcKuJTiWwok6HipkMc57Lxo9D0
         7rYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JtadsFVK6wgToj2YoVlhTAbfcezvFiQMYBJv4VVguP8=;
        b=LpMsIehQKeA6TfxT4QVcPjHaZ0+Lp06kl6wanGPzkjyHzPvStsPatvnUyU51At+vbq
         zFQA1p2Au85SwhnyNUNCZ6WO5rtwuarfAPzux4VhGROCjoksU4/bZCsywS+O5WVA4Ems
         23SOKblQZAD8hRFYuI5fMCsURxHAg4O5LTYwNntwzfn58WP7TCcwUL4s4BhtcpGIfZ/0
         vviZfGsmt7PpHGon7lUBnFsd0tMLv2ctkGkqdnzpT9n4bXNA4H48SADUVEK0JtYwKFKR
         fEHuaxdHLj6NqlNDQhJXt8WMqWKSGTqR5rXAm2GxKpXwbSuzGsuAw8q5Er0eGNE277Vq
         pMFw==
X-Gm-Message-State: AOAM530RzdnVFJQmCCInT2v4rC6lYv0VV4K90mDK3XuzaVG+P3eZEgO1
        5N/P8uzmM1BR6YKNNHA3z7KxHyq8oNE=
X-Google-Smtp-Source: ABdhPJwauHnprr+yvqlr+v+MXOGaJorT3uKZM6Uu1H218ETuMDCNKPva4iEVsViu+7pYWAtxNnNycg==
X-Received: by 2002:a17:906:390:: with SMTP id b16mr23884711eja.123.1639133705642;
        Fri, 10 Dec 2021 02:55:05 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 17/25] trace-cmd library: Read strings sections on file load
Date:   Fri, 10 Dec 2021 12:54:40 +0200
Message-Id: <20211210105448.97850-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Internal strings database is added to trace input handle, containing all
metadata strings from trace file. When a trace file is opened, all
strings sections are located and the internal strings database is
initialised.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 64 +++++++++++++++++++++++++
 lib/trace-cmd/trace-output.c            |  1 +
 3 files changed, 66 insertions(+)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 4a0a691c..ac7e7f17 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -53,5 +53,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned int get_meta_strings_size(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9027729e..6cc8ee90 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -147,6 +147,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	unsigned int		strings_size;	/* size of the metadata strings */
+	char			*strings;	/* metadata strings */
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -984,6 +987,14 @@ static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_sta
 
 static int handle_options(struct tracecmd_input *handle);
 
+static const char *get_metadata_string(struct tracecmd_input *handle, int offset)
+{
+	if (!handle || !handle->strings || offset < 0 || handle->strings_size >= offset)
+		return NULL;
+
+	return handle->strings + offset;
+}
+
 static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
 			       unsigned short *flags, unsigned long long *size, const char **description)
 {
@@ -1007,6 +1018,8 @@ static int read_section_header(struct tracecmd_input *handle, unsigned short *id
 		*flags = fl;
 	if (size)
 		*size = sz;
+	if (description)
+		*description = get_metadata_string(handle, desc);
 
 	return 0;
 }
@@ -2839,6 +2852,11 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
+__hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
+{
+	return handle->strings_size;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	long long offset;
@@ -3472,6 +3490,50 @@ struct hook_list *tracecmd_hooks(struct tracecmd_input *handle)
 	return handle->hooks;
 }
 
+static int init_metadata_strings(struct tracecmd_input *handle, int size)
+{
+	char *tmp;
+
+	tmp = realloc(handle->strings, handle->strings_size + size);
+	if (!tmp)
+		return -1;
+
+	handle->strings = tmp;
+	if (do_read_check(handle, handle->strings + handle->strings_size, size))
+		return -1;
+
+	handle->strings_size += size;
+
+	return 0;
+}
+
+static int read_metadata_strings(struct tracecmd_input *handle)
+{
+	unsigned short flags;
+	int found = 0;
+	unsigned short id;
+	unsigned long long size;
+	off64_t offset;
+
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	do {
+		if (read_section_header(handle, &id, &flags, &size, NULL))
+			break;
+		if (id == TRACECMD_OPTION_STRINGS) {
+			found++;
+			init_metadata_strings(handle, size);
+		} else {
+			if (lseek64(handle->fd, size, SEEK_CUR) == (off_t)-1)
+				break;
+		}
+	} while (1);
+
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return found ? 0 : -1;
+}
+
 /**
  * tracecmd_alloc_fd - create a tracecmd_input handle from a file descriptor
  * @fd: the file descriptor for the trace.dat file
@@ -3568,6 +3630,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 			tracecmd_warning("Filed to read the offset of the first option section");
 			goto failed_read;
 		}
+		read_metadata_strings(handle);
 	}
 
 	handle->file_state = TRACECMD_FILE_INIT;
@@ -3740,6 +3803,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->cpu_data);
 	free(handle->uname);
 	free(handle->trace_clock);
+	free(handle->strings);
 	free(handle->version);
 	close(handle->fd);
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 47227728..08f74c87 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2239,6 +2239,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->strings_offs = get_meta_strings_size(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.33.1

