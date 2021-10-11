Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE23C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF3660F57
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhJKE2k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 00:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhJKE2k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 00:28:40 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9C4C061570
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:40 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i20so46243095edj.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/En+PN6fiZdZ0MkUaQM+HWpbEYB4IWsfdlRokBFGKeI=;
        b=CkRXKUEL9EBSzJTpTRoNH8vGDD02teKI9Iz5kuUnsVrzf3fztpPHBI6UulStEpYGyA
         Wov1LvazLQT6paUIDjb0j7+6dqiJbnsJOqnWjiYWL80x+ffsw+5O3hzVTh8q0yrxqXsU
         Lfa5swsBJUr5KDm4gMZT6/Au97bD5gXQY0ju5oIgRBG4wSGFg/olQQ9/dtltFSOlQh3e
         hcHIkg9yaXoNfLLHkPFdSpK5RXQirepVd0gJdXoNUoT+8ZVAVB7ttoFMsFE8zDlX86vk
         Qmkj3hjBgtyrStZM3qgbiMDM22XLtIFeGMAspVsB2ICnIsJiJAwiCLJV4j7pmCEsnYDX
         /0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/En+PN6fiZdZ0MkUaQM+HWpbEYB4IWsfdlRokBFGKeI=;
        b=sH9aAJo2mQJH9AQklcpD+h6rACCaf1phibYxQ7xNTavBuVZiRMpT6ROlYZxqAdMWIv
         gZqj9QhGxwDR5rMt208fVnNs6TA15QaTI69dExM66kSaIH8ffLn85twn3W4qNpJZXV2O
         neL2gVnkzDJUpohVwGlUTJNbKY+MA4BwFb4rpppPEduuJjnLmYtWkwsSmOEjPTakUODc
         HI+CihI00zHHem2BoXX3zpzbaBvXc4SihEQ1xS8ZJ+RSUdbIfKt2nl8QG75JceKeUUcb
         DOMICCjBTJ7qi8to8QaYkrxTwnJodqN0JeDBzGLaRSRZu1LQ/EGAW/SUzmXM/RXWD2nR
         yF6w==
X-Gm-Message-State: AOAM531wXvmlVKOomKKDfoRzsc99kqz1bqkqfKHtnSJDNtVPY9DEHuOt
        Dk47167XLrxBoJNhW3DC5JoUd967ShVlJQ==
X-Google-Smtp-Source: ABdhPJxpl+zVy24i7RuHxr0ZVjCxPnVAzqRBnLeScH8/3Djg2BJ2SAKOjd1gIWCSisftS1WIXbVfag==
X-Received: by 2002:a17:907:75f5:: with SMTP id jz21mr22963533ejc.345.1633926399461;
        Sun, 10 Oct 2021 21:26:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j21sm3406532edr.64.2021.10.10.21.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 21:26:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/4] trace-cmd library: Add internal database for trace buffers
Date:   Mon, 11 Oct 2021 07:26:33 +0300
Message-Id: <20211011042636.1608374-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211011042636.1608374-1-tz.stoyanov@gmail.com>
References: <20211011042636.1608374-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new list with trace buffers information is added in the output
handler, and internal APIs to work with that list. Storing various trace
buffers information in the handler hides the complexity of this
logic inside the library and simplifies possible extensions in the
future.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-output.c                  | 58 ++++++++++++++++++-
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 167f3804..75680d73 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -292,6 +292,8 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 
 struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
 						   const char *name, int cpus);
+int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus);
+int tracecmd_write_buffer_info(struct tracecmd_output *handle);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 27f296dd..f0f6aeed 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -39,6 +39,14 @@ struct tracecmd_option {
 	struct list_head list;
 };
 
+struct tracecmd_buffer {
+	int				cpus;
+	void				*name;
+	tsize_t				offset;
+	struct tracecmd_option		*option;
+	struct list_head		list;
+};
+
 enum {
 	OUTPUT_FL_SEND_META	= (1 << 0),
 };
@@ -58,6 +66,7 @@ struct tracecmd_output {
 	bool			big_endian;
 
 	struct list_head	options;
+	struct list_head	buffers;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
 };
@@ -140,6 +149,7 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle)
 void tracecmd_output_free(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *option;
+	struct tracecmd_buffer *buffer;
 
 	if (!handle)
 		return;
@@ -150,6 +160,13 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 	if (handle->pevent)
 		tep_unref(handle->pevent);
 
+	while (!list_empty(&handle->buffers)) {
+		buffer = container_of(handle->buffers.next,
+				      struct tracecmd_buffer, list);
+		list_del(&buffer->list);
+		free(buffer->name);
+		free(buffer);
+	}
 	while (!list_empty(&handle->options)) {
 		option = container_of(handle->options.next,
 				      struct tracecmd_option, list);
@@ -157,6 +174,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option->data);
 		free(option);
 	}
+
 	free(handle->trace_clock);
 	free(handle);
 }
@@ -907,6 +925,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	handle->file_state = TRACECMD_FILE_ALLOCATED;
 
@@ -1323,7 +1342,7 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	char *buf;
 	int size = 8 + strlen(name) + 1;
 
-	buf = malloc(size);
+	buf = calloc(1, size);
 	if (!buf) {
 		tracecmd_warning("Failed to malloc buffer");
 		return NULL;
@@ -1345,6 +1364,38 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
+int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus)
+{
+	struct tracecmd_buffer *buf;
+
+	buf = calloc(1, sizeof(struct tracecmd_buffer));
+	if (!buf)
+		return -1;
+	buf->name = strdup(name);
+	buf->cpus = cpus;
+	if (!buf->name) {
+		free(buf);
+		return -1;
+	}
+	list_add_tail(&buf->list, &handle->buffers);
+	return 0;
+}
+
+int tracecmd_write_buffer_info(struct tracecmd_output *handle)
+{
+	struct tracecmd_option *option;
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		option = tracecmd_add_buffer_option(handle, buf->name, buf->cpus);
+		if (!option)
+			return -1;
+		buf->option = option;
+	}
+
+	return 0;
+}
+
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	int ret;
@@ -1580,7 +1631,9 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	ret = tracecmd_write_cpus(handle, cpus);
 	if (ret)
 		return ret;
-
+	ret = tracecmd_write_buffer_info(handle);
+	if (ret)
+		return ret;
 	ret = tracecmd_write_options(handle);
 	if (ret)
 		return ret;
@@ -1658,6 +1711,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->options_start = tracecmd_get_options_offset(ihandle);
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	tracecmd_close(ihandle);
 
-- 
2.31.1

