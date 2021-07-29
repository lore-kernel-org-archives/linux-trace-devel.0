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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B32FC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14A5E61019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhG2FK1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhG2FK0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:26 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92603C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:22 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gs8so8387283ejc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vD8oZEarNcLf46w6Gd8RWY6YpF3Juu4LYg6zlxfdM6I=;
        b=fnSa/ranWc5XU+YJ7Ruo0UhO4bG0dFGTIwQM0sSWmShitE7SKvtF9ls+HsvMiCjSak
         DK/F4jbuN2MBdTT1J/8WaZemL9Hi8sgFBXuaganDdf28QO19RLizIygbZekeeucf17mh
         7k+q+USQY15CikjLfJlTdGk1+ahLTnoY1zCIe8laJrXJI1fM0lQCiPskqzU75/6qAMZE
         eXFgfQGgSH1TIu6m46tn4FR/VqxwlZ5a1xsWdpJOd3q2kcX3WXV4UBlosT16+NP38tAh
         ZG5l367f4EwcCIVq1YUN9izYtg9tF4NnkbzvFLB9EfuRAcK3VADuEJh44xrwFnR53MD6
         0wwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vD8oZEarNcLf46w6Gd8RWY6YpF3Juu4LYg6zlxfdM6I=;
        b=BL9KDCC5FDiBizH6UjOJNIboxGBeW6eBdF8OlxInuIc/4cQHwuCRezDOtv6TwJCcID
         1X34QBjCx4Prw9UtReOWhOZMPNvjMEvIyJD53ejnMvjw+HVGhwp9hHPX9HIltO53Ttoq
         cThbWYHPIKEymKDILuHIhST1ikROEvCUq6wRcWO74lHErZdrfjK/l6nhwMlfCWn1OOB5
         r3LMzhtbEfBzTtjFhtgjOVrCjoU4Ls1X2n9OqmzMpmWSX4kzwk74muGr7xoWYmF0LGCF
         b1pYzT+jimgFmyTKYQOGJ0dHPM+FpPfc+1qRxWsd/uuH6xs+VzM769TLRtH1FzXIFMjl
         /9Qg==
X-Gm-Message-State: AOAM531gZ/w8nc/6oN0tcHXnLk9/caigS4j4NzO0X/k07Qik7Ke1qux2
        NCfMIr+Vma/vSc2WpSL9sEUQ/N4Fkdm54g==
X-Google-Smtp-Source: ABdhPJwt1YJUbIZOjr/SQeOzm0TJ9EQHVafT51An14K0IEj6Z6kSsCOYekvWqsedlnGWZDtMISAVAA==
X-Received: by 2002:a17:906:1919:: with SMTP id a25mr2273441eje.161.1627535421166;
        Wed, 28 Jul 2021 22:10:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 20/87] trace-cmd library: Compress part of the trace file
Date:   Thu, 29 Jul 2021 08:08:52 +0300
Message-Id: <20210729050959.12263-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 130 +++++++++++++++++++++++++----------
 1 file changed, 92 insertions(+), 38 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index d348d6a5..5d3fd58f 100644
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
@@ -748,7 +761,8 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-
+	if (compress)
+		out_compression_start(handle);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -763,9 +777,19 @@ static int read_event_files(struct tracecmd_output *handle,
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
@@ -811,7 +835,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle)
+static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
@@ -827,19 +851,21 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -847,16 +873,25 @@ static int read_proc_kallsyms(struct tracecmd_output *handle)
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
@@ -873,6 +908,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	if (compress)
+		out_compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -894,11 +931,14 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
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
 
@@ -1270,21 +1310,25 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
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
@@ -1529,9 +1573,19 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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

