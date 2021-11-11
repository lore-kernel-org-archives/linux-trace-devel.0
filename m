Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7C5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E26B461108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhKKPKa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbhKKPK3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:10:29 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1D4C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:40 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v11so25424964edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Yzxwt32tMeaSZtC1D53SQQaG1YQXlxemDnOqDMvhfA=;
        b=PD0xmtQ/ZNf5h0s7jlDhBQyVE6YFPI9sme0AgYxKeRRHXybyzTu2QPrP9djjDlit/D
         2PZibSuhh0ZlM3+yUXHfhv2DLQKlp5fnUYx6aotLMD92WnkpFvAG4nThKV0sqEWPugxk
         PwTtFEYbxZwPDJ1sqINoFqbD4H8IL2obq3GhEPqxHd8RxXA+TgZPIq/1ii6bDzvn/0S7
         LZx1mxUWAiy2MIlRuRWI/Y+K1X+HJL1/8wdpPe3s8QP64bcyF5p5YdLwkPimDYcA72jd
         /L78c/Ln2acKqAPuIX38p2Aw1xoEgxdFPuhi6XXMHH8JVjzplq/mfS6h/Zay2Mbd7h3Y
         kj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Yzxwt32tMeaSZtC1D53SQQaG1YQXlxemDnOqDMvhfA=;
        b=KRMBaeeVKratxjweDkQHUEZUG60ftqw9y3iPbIMlHf4z8/VcXE6E5egxHnq/eJbPh2
         IrjSsjN/6mu8CpViL+dtCYXeU1IOYxINa4qp3qpnzNFH4K9LPAKdPVPD89CoZPD2FyDc
         rb1aohuF8idPWGBkP4dBGHu3GSZ7wcKN/HfmgX45KecsAtgg95GDWlF9VGyJoMoe6GVp
         US7U6xZBZ0FOxZwGeZFU+E3KjDottR2FPg++b20fsUkC4a1HD0/wQk5lxtkIVo7lH+MZ
         i1+CuVrw370lKBoDqzBGMP4Kfi8QMqpfQdXHVIGi5awlaEih4V+EixgjWH6toDMUxKOk
         QqCw==
X-Gm-Message-State: AOAM531wG2qUdG77JHhq1YcRGYJH9KeuhIq0uga8n5rHBTKulDT3lGRS
        s9GbqkGJC8eqIA96g+xwarcVktTzbXAy+Q==
X-Google-Smtp-Source: ABdhPJyr97h/VqqfcxBfjT7dvHKAEJ5Vh4pChby5xuQOTeeSUGcWSPbEUpgBNXTtazKwCbN9JbxOKQ==
X-Received: by 2002:a17:906:b090:: with SMTP id x16mr10052964ejy.438.1636643258630;
        Thu, 11 Nov 2021 07:07:38 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t6sm1763496edj.27.2021.11.11.07.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:07:38 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 10/10] trace-cmd library: Remove deprecated APIs for creating an output handler
Date:   Thu, 11 Nov 2021 17:07:37 +0200
Message-Id: <20211111150737.86339-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

With the introduction of the new output handler creation flow, some of
the old APIs are not used any more. Removed unused APIs:
 tracecmd_create_init_file_glob()
 tracecmd_create_init_fd_glob()
 tracecmd_create_init_fd_msg()
 tracecmd_create_init_file_override()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  12 +-
 lib/trace-cmd/trace-output.c                  | 165 ------------------
 2 files changed, 1 insertion(+), 176 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index f148d520..fb050671 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -280,19 +280,9 @@ int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
-struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
-struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list);
-struct tracecmd_output *
-tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list);
+
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
-struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
-							   const char *tracing_dir,
-							   const char *kallsyms);
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 9ea85b1c..27f296dd 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -31,11 +31,6 @@
 typedef unsigned long long	tsize_t;
 typedef long long		stsize_t;
 
-static struct tracecmd_event_list all_event_list = {
-	.next = NULL,
-	.glob = "all"
-};
-
 struct tracecmd_option {
 	unsigned short	id;
 	int		size;
@@ -1119,139 +1114,6 @@ int tracecmd_output_write_headers(struct tracecmd_output *handler,
 	return 0;
 }
 
-static int select_file_version(struct tracecmd_output *handle,
-				struct tracecmd_input *ihandle)
-{
-	if (ihandle)
-		handle->file_version = tracecmd_get_in_file_version(ihandle);
-	else
-		handle->file_version = FILE_VERSION;
-
-	return 0;
-}
-
-static struct tracecmd_output *
-create_file_fd(int fd, struct tracecmd_input *ihandle,
-	       const char *tracing_dir,
-	       const char *kallsyms,
-	       struct tracecmd_event_list *list,
-	       struct tracecmd_msg_handle *msg_handle)
-{
-	struct tracecmd_output *handle;
-	struct tep_handle *pevent;
-	char buf[BUFSIZ];
-	int endian4;
-
-	handle = malloc(sizeof(*handle));
-	if (!handle)
-		return NULL;
-	memset(handle, 0, sizeof(*handle));
-
-	list_head_init(&handle->options);
-
-	handle->fd = fd;
-	if (tracing_dir) {
-		handle->tracing_dir = strdup(tracing_dir);
-		if (!handle->tracing_dir)
-			goto out_free;
-	}
-
-	handle->msg_handle = msg_handle;
-
-	if (select_file_version(handle, ihandle))
-		goto out_free;
-
-	buf[0] = 23;
-	buf[1] = 8;
-	buf[2] = 68;
-	memcpy(buf + 3, "tracing", 7);
-
-	if (do_write_check(handle, buf, 10))
-		goto out_free;
-
-	sprintf(buf, "%lu", handle->file_version);
-	if (do_write_check(handle, buf, strlen(buf) + 1))
-		goto out_free;
-
-	/* get endian and page size */
-	if (ihandle) {
-		pevent = tracecmd_get_tep(ihandle);
-		/* Use the pevent of the ihandle for later writes */
-		handle->pevent = tracecmd_get_tep(ihandle);
-		tep_ref(pevent);
-		if (tep_is_file_bigendian(pevent))
-			buf[0] = 1;
-		else
-			buf[0] = 0;
-		handle->page_size = tracecmd_page_size(ihandle);
-	} else {
-		if (tracecmd_host_bigendian())
-			buf[0] = 1;
-		else
-			buf[0] = 0;
-		handle->page_size = getpagesize();
-	}
-
-	if (do_write_check(handle, buf, 1))
-		goto out_free;
-
-	/* save size of long (this may not be what the kernel is) */
-	buf[0] = sizeof(long);
-	if (do_write_check(handle, buf, 1))
-		goto out_free;
-
-	endian4 = convert_endian_4(handle, handle->page_size);
-	if (do_write_check(handle, &endian4, 4))
-		goto out_free;
-	handle->file_state = TRACECMD_FILE_INIT;
-
-	if (ihandle)
-		return handle;
-
-	if (read_header_files(handle))
-		goto out_free;
-
-	if (read_ftrace_files(handle))
-		goto out_free;
-
-	if (read_event_files(handle, list))
-		goto out_free;
-
-	if (read_proc_kallsyms(handle))
-		goto out_free;
-
-	if (read_ftrace_printk(handle))
-		goto out_free;
-
-	return handle;
-
- out_free:
-	tracecmd_output_close(handle);
-	return NULL;
-}
-
-static struct tracecmd_output *create_file(const char *output_file,
-					   struct tracecmd_input *ihandle,
-					   const char *tracing_dir,
-					   const char *kallsyms,
-					   struct tracecmd_event_list *list)
-{
-	struct tracecmd_output *handle;
-	int fd;
-
-	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
-		return NULL;
-
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL);
-	if (!handle) {
-		close(fd);
-		unlink(output_file);
-	}
-
-	return handle;
-}
-
 /**
  * tracecmd_add_option_v - add options to the file
  * @handle: the output file handle name
@@ -1825,26 +1687,6 @@ error:
 	return NULL;
 }
 
-struct tracecmd_output *
-tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list)
-{
-	return create_file_fd(msg_handle->fd, NULL, NULL, NULL, list, msg_handle);
-}
-
-struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list)
-{
-	return create_file_fd(fd, NULL, NULL, NULL, list, NULL);
-}
-
-struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list)
-{
-	return create_file(output_file, NULL, NULL, NULL, list);
-}
-
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
 {
 	struct tracecmd_output *handle;
@@ -1863,13 +1705,6 @@ struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
 	return handle;
 }
 
-struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
-							   const char *tracing_dir,
-							   const char *kallsyms)
-{
-	return create_file(output_file, NULL, tracing_dir, kallsyms, &all_event_list);
-}
-
 /**
  * tracecmd_copy - copy the headers of one trace.dat file for another
  * @ihandle: input handle of the trace.dat file to copy
-- 
2.33.1

