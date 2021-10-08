Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAD2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3946C61090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhJHEYS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhJHEYR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:17 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A622C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z20so30929098edc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BzHSBWiqmJVBlrsu8Hh3kihiaFTfORc2i4irlq5+T+Q=;
        b=f55510kGjKsrM96FOSVIfZhKFvQMu90Z1ZqeV1NtmiQPDBbKw6IEuaQptTPWhDhemP
         u68Onqq4U1Gn/iCZP9jbku0Rvyqd+EGUGLvw7PMJWslSoyRd6bbdZbO8EkMiz3GQeBRP
         gEFaW3uCdGrZzNk8j09xcQAlL7+UYY9o0DsjOtcJQe9T4xO+b5H8ood0/ppfHTgG8Lyy
         cYZaDQejPBVx2aVt6zzf/Fj9P3r3TNTwEIIIP0ZVHiXsKashTCC2Iki1oLYwsM8V6Sp4
         u3HlUM9BR5l4h+IyQTFmw0aVEqrTrILuN5Gbs5Zu4VgfJMwPrwzJ6K1VQcFcGKQprg60
         BCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BzHSBWiqmJVBlrsu8Hh3kihiaFTfORc2i4irlq5+T+Q=;
        b=FiZuGydroIsm3JfCsJx3KEhd2jLqXeEIan0KGz3pcZyD964B+fdXSyDZvnv2X6+kjl
         JSdHC9ScGTPUyTkIXCUAyiPPiOh1/CpNT/7z0QPagN53rtt9JklbJhBhsv4IW/4iCzt7
         UQhpbqt6/AKhT7QVnQ6tnryuDeUSgsstCf2hdntZoYalGLXhGFHB3ljaUO6KfWPyZ8Uw
         Sh6PGogZF1TGOvUzFz169q/dFey9Pd7V7dd+8wSUhUMXnVF3Nt92ZIgLmHAyFbXZlAVd
         u1bVN5sDK9y+w4MLE3YASKWLmdAkskzOt5BvQ5zH8z8MGJZnvcTmbTe/KrWpmRTzfho7
         mHIA==
X-Gm-Message-State: AOAM531f2P14KPidcKldtf7J5cHU9uuOTQDfLMRBzbXzVJdCbxZ7YVhF
        h/9Cn697iJxnvCKSCvu5fkLKOJre+Kjimg==
X-Google-Smtp-Source: ABdhPJxH3VNYW2YcUuLATNpH9UU3uU6U4SmcyhsoQCtnYEUYhwum+VZgPLHl8nwihLQktyNq01+9Jg==
X-Received: by 2002:a50:9dc4:: with SMTP id l4mr11575218edk.208.1633666940939;
        Thu, 07 Oct 2021 21:22:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Fri,  8 Oct 2021 07:21:58 +0300
Message-Id: <20211008042214.977193-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace file output handler is allocated, based on given trace
file input handler - use the same compression algorithm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-input.c                   | 16 +++++++++++++++
 lib/trace-cmd/trace-output.c                  | 20 +++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 04b3cb41..30315c00 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -255,6 +255,8 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
 size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 71d5ea38..35b49ac6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4594,6 +4594,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_compress_proto - get name and version of compression algorithm,
+ *				      used to compress the trace file
+ * @handle: input handle for the trace.dat file
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version)
+{
+	return tracecmd_compress_proto_get_name(handle->compress, name, version);
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 54eec93c..816db13d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1209,6 +1209,9 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *ka
  */
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (!handler || !ihandle || handler->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
@@ -1220,6 +1223,15 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct trace
 	handler->file_version = tracecmd_get_in_file_version(ihandle);
 	handler->big_endian = tep_is_file_bigendian(handler->pevent);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handler->compress = tracecmd_compress_alloc(cname, cver, handler->fd,
+							    handler->pevent, handler->msg_handle);
+		if (!handler->compress)
+			return -1;
+		if (handler->file_version < FILE_VERSION_COMPRESSION)
+			handler->file_version = FILE_VERSION_COMPRESSION;
+	}
+
 	return 0;
 }
 
@@ -2167,6 +2179,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -2206,6 +2220,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							   handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			goto out_free;
+	}
 	tracecmd_close(ihandle);
 
 	return handle;
-- 
2.31.1

