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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDDBC43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A57A261168
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhDVHj7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhDVHjn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C13C06138C
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s15so52261234edd.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3z56KHPeOsTxGurJSVvGx5wwkElfMrYzdQR3FI+Cl4I=;
        b=TMkMQuK4fxZiYIJpiTeu+sy1kmSv6DNAXdcLquYgCDQkaJeZDlQfEBfaa8S143tit9
         skbh3TwThKBGJs5H2vd0h2OYG8gQ5noBdkj9rBDnhX2mWfjLdp6mc5vf3H86LrK/rHar
         6Ou2elWKvhyPxKKuiml7XcXZQg/ihuIV7eV9E+Em18bbflvnzpmBApod7vXlFPjNQ9Bd
         cEwdSAL5SRiwtBkMLbt9aG+1yQjrQt/k/4+IiaqCj1xjUzCXXDX5Al0NWexXEOfhjPqY
         0RGccDjOtbfgNPPcnENRyIMSpFmbnsd3XVxFsRMaG1byAU8Ngn4QRrU+TcLT8Oy9Jy9l
         pdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3z56KHPeOsTxGurJSVvGx5wwkElfMrYzdQR3FI+Cl4I=;
        b=uhFsfKhXRNRLVPz7x2sJ3DL1c2xxd2OtNpgal82rKfvV19bJo0Myh+ActuHjZDqKKM
         bfEOz1pJZKpOGxfelEf0DMqLStRsECAan5BDgSULkiGEl3QBMHx5gtwm82vPQ/0qUhzJ
         dHu5av3i0fpKOd92Zo0L5la2JTUOxBWAvCznCmBwibRTrtqPLl7gEGuBG3hXi5XGN37y
         5e2eAndwNw1T8d+o6Hr02wY7MjS+91twcH/7z4zwmJFSRCVQZdiPocMfEdr/S0ixKIF1
         vcC7XYu/R7bv1H2dfHXXVHJDDMBtlmgHDsfloZjvsDSQDoNiPnKfN4M9JROCW6/93ROy
         6CnQ==
X-Gm-Message-State: AOAM532jJW9PGo3k9u1SsAX8jaSNrmM8aXQqS12rhsYn5O2zL0sINC+P
        1V+BLQp9vV39q0bktMMjyYDFGBIa9Hdlcw==
X-Google-Smtp-Source: ABdhPJzMKqAbuFSW/Vup04EYITL2NrcBgWKFlhE57MUUNyltaU6VI6MeiEaxxFF1XS1QLsy71k3WVQ==
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr2133045edu.252.1619077146827;
        Thu, 22 Apr 2021 00:39:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/10] trace-cmd library: Compress part of the trace file
Date:   Thu, 22 Apr 2021 10:38:55 +0300
Message-Id: <20210422073902.484953-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Compress some methadata of the trace.dat file. If there is compression
support, chose file version 7 and compress these parts of the file:
 - ftrace events format
 - format of recorded events
 - information of the mapping of function addresses to the function names
 - trace_printk() format strings
 - information of the mapping a PID to a process name

A new compression header is added in the file, right after the page size
information.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 190 ++++++++++++++++++++++++++++++-----
 1 file changed, 167 insertions(+), 23 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index edff7961..9d603cfe 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -58,6 +58,13 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
+
+	bool			compress;
+	unsigned int		compress_size;
+	unsigned int		commpress_capacity;
+	char			*compress_buffer;
+	struct tracecmd_compress_proto *compress_proto;
+
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
@@ -75,9 +82,31 @@ struct list_event_system {
 	char				*name;
 };
 
+static stsize_t write_compress(struct tracecmd_output *handle, const void *data, tsize_t size)
+{
+	char *buf;
+	int extend;
+
+	if (handle->commpress_capacity < handle->compress_size + size) {
+		extend = (handle->compress_size + size) - handle->commpress_capacity;
+		extend = extend < BUFSIZ ? BUFSIZ : extend;
+		buf = realloc(handle->compress_buffer, handle->commpress_capacity + extend);
+		if (!buf)
+			return -ENOMEM;
+		handle->compress_buffer = buf;
+		handle->commpress_capacity += extend;
+	}
+	memcpy(&handle->compress_buffer[handle->compress_size], data, size);
+	handle->compress_size += size;
+	return 0;
+}
+
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
+	if (handle->compress)
+		return write_compress(handle, data, size);
+
 	if (handle->msg_handle)
 		return tracecmd_msg_data_send(handle->msg_handle, data, size);
 
@@ -109,6 +138,70 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+static stsize_t write_compress_data(struct tracecmd_output *handle)
+{
+	unsigned int size;
+	char *buf;
+	int endian4;
+	int ret;
+
+	size = tracecmd_get_compress_size(handle->compress_proto, handle->compress_size);
+	buf = malloc(size);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = tracecmd_compress_data(handle->compress_proto, handle->compress_buffer,
+				     handle->compress_size, buf, &size);
+	if (ret < 0)
+		goto out;
+	/* Write compressed data size */
+	endian4 = convert_endian_4(handle, size);
+	ret = do_write_check(handle, &endian4, 4);
+	if (ret < 0)
+		goto out;
+	/* Write uncompressed data size */
+	endian4 = convert_endian_4(handle, handle->compress_size);
+	ret = do_write_check(handle, &endian4, 4);
+	if (ret < 0)
+		goto out;
+	/* Write uncompressed the data */
+	ret = do_write_check(handle, buf, size);
+out:
+	free(buf);
+	return ret;
+}
+
+static inline void compression_reset(struct tracecmd_output *handle)
+{
+	if (handle->file_version < 7 || !handle->compress_proto)
+		return;
+	free(handle->compress_buffer);
+	handle->compress_buffer = NULL;
+	handle->commpress_capacity = 0;
+	handle->compress_size = 0;
+}
+
+static inline int compression_start(struct tracecmd_output *handle)
+{
+	if (handle->file_version < 7 || !handle->compress_proto)
+		return 0;
+	compression_reset(handle);
+	handle->compress = true;
+	return 0;
+}
+
+static inline int compression_end(struct tracecmd_output *handle)
+{
+	int ret;
+
+	if (handle->file_version < 7 || !handle->compress_proto)
+		return 0;
+	handle->compress = false;
+	ret = write_compress_data(handle);
+	compression_reset(handle);
+	return ret;
+}
+
 /**
  * tracecmd_set_quiet - Set if to print output to the screen
  * @quiet: If non zero, print no output to the screen
@@ -659,13 +752,17 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	}
 
 	create_event_list_item(handle, &systems, &list);
-
+	compression_start(handle);
 	ret = copy_event_system(handle, systems);
+	if (!ret)
+		ret = compression_end(handle);
+	else
+		compression_reset(handle);
 
 	free_list_events(systems);
 
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
-
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 	return ret;
 }
 
@@ -715,6 +812,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	for (slist = systems; slist; slist = slist->next)
 		count++;
 
+	compression_start(handle);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
 	if (do_write_check(handle, &endian4, 4))
@@ -730,8 +828,14 @@ static int read_event_files(struct tracecmd_output *handle,
 		ret = copy_event_system(handle, slist);
 	}
 
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	if (!ret)
+		ret = compression_end(handle);
  out_free:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+	else
+		compression_reset(handle);
+
 	free_list_events(systems);
 
 	return ret;
@@ -793,20 +897,20 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 
 	if (kallsyms)
 		path = kallsyms;
-
+	compression_start(handle);
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
@@ -814,13 +918,18 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
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
+	ret = compression_end(handle);
+out:
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+	else
+		compression_reset(handle);
+	return ret;
 }
 
 static int read_ftrace_printk(struct tracecmd_output *handle)
@@ -840,6 +949,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	if (!path)
 		return -1;
 
+	compression_start(handle);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
@@ -861,11 +971,14 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	}
 
  out:
-	handle->file_state = TRACECMD_FILE_PRINTK;
 	put_tracing_file(path);
+	if (compression_end(handle))
+		return -1;
+	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
 	put_tracing_file(path);
+	compression_reset(handle);
 	return -1;
 }
 
@@ -911,16 +1024,40 @@ out_free:
 static int select_file_version(struct tracecmd_output *handle, struct tracecmd_input *ihandle,
 			       unsigned long file_version)
 {
-	if (ihandle)
+	if (ihandle) {
 		handle->file_version = tracecmd_get_file_version(ihandle);
-	else if (file_version > 0)
+	} else if (file_version > 0) {
 		handle->file_version = file_version;
-	else
-		handle->file_version = FILE_VERSION;
+	} else {
+		handle->compress_proto = tracecmd_compress_proto_select();
+		if (handle->compress_proto)
+			handle->file_version = 7;
+		else
+			handle->file_version = 6;
+	}
 
 	return 0;
 }
 
+static int write_compression_header(struct tracecmd_output *handle)
+{
+	const char *name = NULL;
+	const char *ver = NULL;
+	char *buf;
+	int ret;
+
+	ret = tracecmd_compress_proto_get_name(handle->compress_proto, &name, &ver);
+	if (ret < 0 || !name || !ver)
+		return -1;
+	ret = asprintf(&buf, "%s %s", name, ver);
+	if (ret < 0)
+		return -1;
+	ret = do_write_check(handle, buf, strlen(buf) + 1);
+
+	free(buf);
+	return ret;
+}
+
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -996,7 +1133,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (do_write_check(handle, &endian4, 4))
 		goto out_free;
 	handle->file_state = TRACECMD_FILE_INIT;
-
+	if (handle->file_version >= 7 && write_compression_header(handle))
+		goto out_free;
 	if (ihandle)
 		return handle;
 
@@ -1329,11 +1467,17 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 				 handle->file_state);
 		return ret;
 	}
+	compression_start(handle);
+
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
-	if (ret < 0)
+	if (ret < 0) {
+		compression_reset(handle);
 		return ret;
-	handle->file_state = TRACECMD_FILE_CMD_LINES;
-	return 0;
+	}
+	ret = compression_end(handle);
+	if (!ret)
+		handle->file_state = TRACECMD_FILE_CMD_LINES;
+	return ret;
 }
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
-- 
2.30.2

