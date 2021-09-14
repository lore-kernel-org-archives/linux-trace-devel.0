Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC103C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A695860F36
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhINNSK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhINNSK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:10 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F343C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:52 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 196-20020a1c04cd000000b002fa489ffe1fso2053636wme.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x257PmiUOYlA+KiZnBHtOFBwk3HICB+mn/P/kKYhzPw=;
        b=pBrm0+TSteTZ/NfQbfW5+dx/dfQ/o5Gkj3zgfSdDbBRUEy6ckpNQL3q6C0M3SoV7gf
         jbA/rBCIjd49VoIw//rYTY9Fit/eONmrCO7goJDZXbjtzBlfNCOk4dcfmuBGvw+zTNG5
         KzptDpuqDhFlDG3lXJs7A3+QK36F5VYxDRLsDDzGbex7t21iAIroKiIBgXmXBXXcJTuH
         RdKL4mtjdx/b1V4ixG/Qd3oDIZda8gtUriJ1qe/j2dITN9HL7OA5Qp/y0G9mhFHT90SA
         +9Af4Kvc8CM+SU508WqghVM7v/xN6tzH62iRfSh8o2sqbB8YemBJIaHPYYEDNwNlNgqp
         jTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x257PmiUOYlA+KiZnBHtOFBwk3HICB+mn/P/kKYhzPw=;
        b=IM52Jo96nYw56nnP6P4BEB5Tma7E0mRh54Bh5QfXQ+9TWHGk4kHphdBqz21djtU+dr
         /dVy4RCnDdCgF4mb50MIvrlVmzDPrpUOPthOD+QOR2ERuoE+FTUQ+XnldrKPg5GWozG4
         UV4J+bi/Ef6EZ8lmZBaoAFI3UOuhflg6IiN2b6+hqZpIoKSEK7zF18AKEZ3913xYWm8V
         atrbicGy8APnVWMq6LXixzi9xrciLUzL5lRhhS0L0p8QEcyIv8CpXTWdxKemwjk+ckVA
         1bd/HudGoU9CSwxWC21XLTc0F/0ar/Uj5l8X6dPB4fzPdfSQEuIKMaWOZaXbssoA8MgZ
         LCaQ==
X-Gm-Message-State: AOAM533pkL8Mxep1kpKjAzADwEu9728CajBiFISRy/ITV2BzCOhLkE/q
        r19oPq4O7zw/FP0xu/VxlhkKZymOMxs=
X-Google-Smtp-Source: ABdhPJzRybLOG8dkrBRcBfNRE3kuBgAP5YQW5zAOrmtHhY6tQBoW0T8SQJOwGPTodVFN04FXdqGDtQ==
X-Received: by 2002:a1c:7f89:: with SMTP id a131mr2119106wmd.31.1631625411259;
        Tue, 14 Sep 2021 06:16:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Tue, 14 Sep 2021 16:16:29 +0300
Message-Id: <20210914131645.3966308-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c                   | 16 ++++++++++++++++
 lib/trace-cmd/trace-output.c                  | 19 +++++++++++++++++++
 3 files changed, 37 insertions(+)

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
index 3eef539f..11ee6470 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4608,6 +4608,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
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
index d9502023..edf05cfe 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1213,6 +1213,9 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *ka
  */
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (!handler || !ihandle || handler->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
@@ -1227,6 +1230,14 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct trace
 	else
 		handler->big_endian = false;
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handler->compress = tracecmd_compress_alloc(cname, cver, handler->fd,
+							    handler->pevent, handler->msg_handle);
+		if (!handler->compress)
+			return -1;
+		if (handler->file_version < FILE_VERSION_COMPRESSION)
+			handler->file_version = FILE_VERSION_COMPRESSION;
+	}
 
 	return 0;
 }
@@ -2166,6 +2177,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -2205,6 +2218,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
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

