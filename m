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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A175C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4214560EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhG1NdQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbhG1NdP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:15 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC82AC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:13 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id v21so4685750ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yP0w3hR9cnD5pIoUVIHXkit0HZQ947t6zwO00IOryxg=;
        b=CXYk75ti7q6hfo1m2SvcRcxnB/2MVeK1F/CHw+oaYqpDCTW20sHx/mbcHSpU/kHYBu
         YPZqULe/8JGr50pnYdlLP76fhR+PWgWQt+2i0gP0hwpyqm0cJHkVNWiBGjBg284fHqRl
         YvXU7/LY3/Sk8KdVpA0a5pc0bnmaSpGGeJpEhH6dXbEuhX8Lw4E7VyX1s/LjQSxyIZs0
         LzAghZg9FngRCm6T1QTILO/D3Ksf7BUdM3kDfq8UEfou+64ofIpCM5sZYqsQTFtFb6Tb
         SN105MpgI8PICUKJRuf4EZFKhXkNHbIwoBi0k+Y7nKekSjFoy7NWX5SkuIYhnzfDZ/4i
         p27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yP0w3hR9cnD5pIoUVIHXkit0HZQ947t6zwO00IOryxg=;
        b=lqEtTcwoFFEXqliMJXIzWk43+26j29OrwWB6kYrh4G/QI4Q6XyAp/FuJcN3PApDYlw
         DIloOKfn6azxWzmUYHA5U3R0T/HwPOi8jDhi/CRJsSKsS1EkIzA5I0S3yWh57oP06yNj
         o/xD3XgAhUr+0SxmVnPlv0Gs6N/ZmWLkH6llm6DATKRXKPUi0jDLfl6uIwQhgkvYrzDn
         eAYTsP3pvEV3l0oV2yUgRNOkouYTwjp3ONCpfhBJTHC0cAm9VrcMM1jAhYc+iVF65O82
         7T0Iudh1qGPVsC26hT7kqzMpvispk/qe3zb8nKgqgUeAZGPekIrKnbOP66Q74zLffJl2
         ojvQ==
X-Gm-Message-State: AOAM531RYQSVNb1eNC3Ex2582PuVn/VAnrW5KyUuPlF6pyvLNRLxNEAK
        UVJ2Nl5tGZ7Kn8tK7jFt4vM=
X-Google-Smtp-Source: ABdhPJwvwvYfnA60HXaE9UTAVgLL2TXgVxOkQWJ8d2IzL0CxDWT8yAK2zZFoRb1WStTArstxo0gv5g==
X-Received: by 2002:a17:906:dfdb:: with SMTP id jt27mr27837257ejc.138.1627479192231;
        Wed, 28 Jul 2021 06:33:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 20/87] trace-cmd library: Compress part of the trace file
Date:   Wed, 28 Jul 2021 16:31:43 +0300
Message-Id: <20210728133250.234140-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Compress part of the trace.dat file metadata. If there is compression
support, compress these parts of the file:
 - ftrace events format
 - format of recorded events
 - information of the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 131 ++++++++++++++++++++++++-----------
 1 file changed, 92 insertions(+), 39 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 004c783c..58f3a0c5 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -366,12 +366,12 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
-static int read_header_files(struct tracecmd_output *handle)
+static int read_header_files(struct tracecmd_output *handle, bool compress)
 {
 	tsize_t size, check_size, endian8;
 	struct stat st;
 	char *path;
-	int fd;
+	int fd = -1;
 	int ret;
 
 	if (!check_out_state(handle, TRACECMD_FILE_HEADERS)) {
@@ -384,26 +384,30 @@ static int read_header_files(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	if (compress)
+		out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* old style did not show this info, just add zero */
 		put_tracing_file(path);
 		if (do_write_check(handle, "header_page", 12))
-			return -1;
+			goto out_close;
 		size = 0;
 		if (do_write_check(handle, &size, 8))
-			return -1;
+			goto out_close;
 		if (do_write_check(handle, "header_event", 13))
-			return -1;
+			goto out_close;
 		if (do_write_check(handle, &size, 8))
-			return -1;
+			goto out_close;
+		if (compress && out_compression_end(handle))
+			goto out_close;
 		return 0;
 	}
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		tracecmd_warning("can't read '%s'", path);
-		return -1;
+		goto out_close;
 	}
 
 	/* unfortunately, you can not stat debugfs files for size */
@@ -419,18 +423,18 @@ static int read_header_files(struct tracecmd_output *handle)
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
 		errno = EINVAL;
-		return -1;
+		goto out_close;
 	}
 	put_tracing_file(path);
 
 	path = get_tracing_file(handle, "events/header_event");
 	if (!path)
-		return -1;
+		goto out_close;
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		tracecmd_warning("can't read '%s'", path);
-		return -1;
+		goto out_close;
 	}
 
 	size = get_size_fd(fd);
@@ -444,16 +448,19 @@ static int read_header_files(struct tracecmd_output *handle)
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
-		return -1;
+		goto out_close;
 	}
 	put_tracing_file(path);
-
+	if (compress && out_compression_end(handle))
+		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
 
 	return 0;
 
  out_close:
-	close(fd);
+	out_compression_reset(handle);
+	if (fd >= 0)
+		close(fd);
 	return -1;
 }
 
@@ -680,7 +687,7 @@ create_event_list_item(struct tracecmd_output *handle,
 	 tracecmd_warning("Insufficient memory");
 }
 
-static int read_ftrace_files(struct tracecmd_output *handle)
+static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 {
 	struct list_event_system *systems = NULL;
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
@@ -693,9 +700,15 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	}
 
 	create_event_list_item(handle, &systems, &list);
-
+	if (compress)
+		out_compression_start(handle);
 	ret = copy_event_system(handle, systems);
-
+	if (compress) {
+		if (!ret)
+			ret = out_compression_end(handle);
+		else
+			out_compression_reset(handle);
+	}
 	free_list_events(systems);
 
 	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
@@ -717,7 +730,7 @@ create_event_list(struct tracecmd_output *handle,
 }
 
 static int read_event_files(struct tracecmd_output *handle,
-			    struct tracecmd_event_list *event_list)
+			    struct tracecmd_event_list *event_list, bool compress)
 {
 	struct list_event_system *systems;
 	struct list_event_system *slist;
@@ -748,12 +761,12 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-
+	if (compress)
+		out_compression_start(handle);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
 		goto out_free;
-
 	ret = 0;
 	for (slist = systems; !ret && slist; slist = slist->next) {
 		if (do_write_check(handle, slist->name,
@@ -763,9 +776,19 @@ static int read_event_files(struct tracecmd_output *handle,
 		}
 		ret = copy_event_system(handle, slist);
 	}
-
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	if (ret)
+		goto out_free;
+	if (compress) {
+		ret = out_compression_end(handle);
+		if (ret)
+			goto out_free;
+	}
  out_free:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		out_compression_reset(handle);
+
 	free_list_events(systems);
 
 	return ret;
@@ -811,7 +834,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle)
+static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
@@ -827,19 +850,21 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
 	if (handle->kallsyms)
 		path = handle->kallsyms;
 
+	if (compress)
+		out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
 		size = 0;
 		endian4 = convert_endian_4(handle, size);
-		if (do_write_check(handle, &endian4, 4))
-			return -1;
-		return 0;
+		ret = do_write_check(handle, &endian4, 4);
+		goto out;
 	}
 	size = get_size(path);
 	endian4 = convert_endian_4(handle, size);
-	if (do_write_check(handle, &endian4, 4))
-		return -1;
+	ret = do_write_check(handle, &endian4, 4);
+	if (ret)
+		goto out;
 
 	set_proc_kptr_restrict(0);
 	check_size = copy_file(handle, path);
@@ -847,16 +872,25 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
 		errno = EINVAL;
 		tracecmd_warning("error in size of file '%s'", path);
 		set_proc_kptr_restrict(1);
-		return -1;
+		ret = -1;
+		goto out;
 	}
 	set_proc_kptr_restrict(1);
 
-	handle->file_state = TRACECMD_FILE_KALLSYMS;
-
-	return 0;
+	if (compress) {
+		ret = out_compression_end(handle);
+		if (ret)
+			goto out;
+	}
+out:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+	else
+		out_compression_reset(handle);
+	return ret;
 }
 
-static int read_ftrace_printk(struct tracecmd_output *handle)
+static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 {
 	unsigned int size, check_size, endian4;
 	struct stat st;
@@ -873,6 +907,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	if (compress)
+		out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -894,11 +930,14 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	}
 
  out:
-	handle->file_state = TRACECMD_FILE_PRINTK;
 	put_tracing_file(path);
+	if (compress && out_compression_end(handle))
+		return -1;
+	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
 	put_tracing_file(path);
+	out_compression_reset(handle);
 	return -1;
 }
 
@@ -1267,21 +1306,25 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list)
 {
+	bool compress = false;
+
 	if (!handler || handler->file_state < TRACECMD_FILE_ALLOCATED)
 		return -1;
 
 	/* Write init data, if not written yet */
 	if (handler->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handler))
 		return -1;
-	if (read_header_files(handler))
+	if (handler->compress)
+		compress = true;
+	if (read_header_files(handler, compress))
 		return -1;
-	if (read_ftrace_files(handler))
+	if (read_ftrace_files(handler, compress))
 		return -1;
-	if (read_event_files(handler, list))
+	if (read_event_files(handler, list, compress))
 		return -1;
-	if (read_proc_kallsyms(handler))
+	if (read_proc_kallsyms(handler, compress))
 		return -1;
-	if (read_ftrace_printk(handler))
+	if (read_ftrace_printk(handler, compress))
 		return -1;
 	return 0;
 }
@@ -1526,9 +1569,19 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 				 handle->file_state);
 		return -1;
 	}
+
+	if (handle->compress)
+		out_compression_start(handle);
+
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
-	if (ret < 0)
+	if (ret < 0) {
+		out_compression_reset(handle);
 		return ret;
+	}
+
+	if (handle->compress && out_compression_end(handle))
+		return -1;
+
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
 	return 0;
 }
-- 
2.31.1

