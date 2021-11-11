Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8273C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91E82610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhKKPOv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbhKKPOu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:50 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720CAC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:01 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c8so25070993ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xfcpFr0c8aAQ8Msg55A2Qs5AvZyFozphkKbqcj6Nqz4=;
        b=YdX9o+7ppJTONKs09DX9shEcxdfpNgCxmG0w9svNYKxxi55T4CUmUBP9J22mhio2l+
         L0TtyBlvt/JAjycYVRsutC983K/bDxUpM51eeo/Bt6qdTH82fOj0MKqSaK7g54LNCQPc
         n/fhkR0RmS2UhPzcWaPJkKMW4EqlLId2kiXFodKGMOfEKDSbRYN2aJJpC6sc7xVtP3EF
         JdRwbuI8ahez5MhkD6LzdackzG1kyjGwOoPGds+3CWSsBI63vpC6KPoFPgc4VZSNV1Qk
         7Ib3E77NoNKOc5YF9WIze7qQ5eGBSAE1wr9YBuHupuPFrpEfCTvjM2NU9G39Waqvf5A1
         Z+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xfcpFr0c8aAQ8Msg55A2Qs5AvZyFozphkKbqcj6Nqz4=;
        b=zHIXhb+KeDaYBBFlw347L+kJ9W6o2upm7LfoPWz2Hv6ly6rzE/aVw1VFrGYwTYJOav
         GYy4SbtDPRXn7umtYBeLb4vDjqC34KEKScXZGFKv1X01E+tBA8+puR25O3kl4mSGtShR
         WpSVAzhM22mt6YGvvbTRXwHKHNo1D1d/i1+70eCwQiZS68NHFCRqTz4LKezHEPpqO6NT
         3nu6ClAabXEq9E31Aibfw+OJzXYCdXn7eQlzrQYdHn1Adyh3pUGqa5WsTHyocMu7awR8
         R2pny+pFkfn/c7SfNK/nFgZYzIFWroe0S2xk0qE9m3Kd+/9ndgF6BxLUaHVe1/QSP4e3
         IJDw==
X-Gm-Message-State: AOAM532wZ4lHZoixnCDoo8J4M1X7cKeq1e5WdRTokS5cIq3ksM+7UT8l
        iwHZ+Oe7j2pFTlM43RE9TUD4DAGVgnJUrA==
X-Google-Smtp-Source: ABdhPJzRYlKYQ0/Z5y3UDA430RRCQ2oFzBho0bh7naFTFoFhmLX+31Ehc6UzxRVe1oguYP7HEFGhEA==
X-Received: by 2002:a17:906:fcd9:: with SMTP id qx25mr10547121ejb.326.1636643520034;
        Thu, 11 Nov 2021 07:12:00 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Thu, 11 Nov 2021 17:11:37 +0200
Message-Id: <20211111151153.86855-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index 0c7027dd..d5aea618 100644
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
index f0b7b3eb..a3cc600d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4593,6 +4593,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
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
index c9cb174a..8f822323 100644
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
 
@@ -2170,6 +2182,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -2209,6 +2223,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
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
2.33.1

