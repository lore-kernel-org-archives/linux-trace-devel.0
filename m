Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862DBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D4560F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhJHEPa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhJHEP3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6051C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so30323827edj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbYlw/3BiN/+et7fiQViKHmUzdeGz+I8l6jpMvYbiy4=;
        b=mcbrJq5JMm87sBjNLvBvHNXsdepjzaOlCSRQihvRsLYgSgzlv0G5T0K62kASR03NPu
         UPQaPJWPH/jxsDTc11JwqoBgDBxkkgOpWUD0PY8Qyz05Zy54zV/d7F1t9ScEGo+lN7G9
         GrrnHYBtl1plAsAFN1s3n/yqCQHxNdOt31e5JtKqhlgbKBK3t/sP5yXBxQIOywqW7C+G
         nuaqRGBlUuOUI+3RuGzuofVnL1nSBlskfNOkm5fJOc6fZ1tOEbNYEYpervUV0dlI39Ym
         bAyYjHA9SqoX/RKL3Xoc32rwmMlMp/Rqae162YosyeBD3ouq0QisNq28V9DLTJApuI6O
         p+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbYlw/3BiN/+et7fiQViKHmUzdeGz+I8l6jpMvYbiy4=;
        b=luwif87TiGvsD+DRDEuZHydPnOk0llsw7EJAGogNZK6xmqmZSueit2vWQjeoQD+kPC
         Ahvp6TYq4hBWUMXb/Uz3JWDdHr+9oaPP4uR56AoVBLQrtE+4w5P789uVU9W97EJoLALm
         qdrMaVP3O1gqI6zR8DeY8zD4yKms0wnpPI6+ixwetU5tDvgLdEzMUT7m3pFSyWVkbE5C
         48JDVxN+GuNKD+8iPAFcuOGXWTASrFuL3biHEDExvFV50hPNx4QLUlRzPZDPOO0y+CwO
         eXxar3opkqLd14EKfGBl9FdR5xxGa/22g1nX/8I33hpQ/hJ+dZ0N+7oUlXSy5bF294G3
         WPww==
X-Gm-Message-State: AOAM5328sdw3jYBBQh46iV7Odx4mWO6Gf22oOJum9OFsLRPGoE806UUn
        MKsbtZLUAPZuB+r/cmwjj7v/DrHl7gS4Rw==
X-Google-Smtp-Source: ABdhPJx2IDAR7KpXtz/sY2d65iCRQm1VlvVAXXlu+fEMQidXLhWCbghLIDJWRPTFNYfKoI2m43icsw==
X-Received: by 2002:a17:907:98f9:: with SMTP id ke25mr1230838ejc.381.1633666413456;
        Thu, 07 Oct 2021 21:13:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/10] trace-cmd library: Remove deprecated APIs for creating an output handler
Date:   Fri,  8 Oct 2021 07:13:21 +0300
Message-Id: <20211008041321.973755-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
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
index 086e6906..167f3804 100644
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
2.31.1

