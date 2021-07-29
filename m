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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDC7C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2658361052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhG2FKW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhG2FKV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:21 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31EDC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:18 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x90so6372528ede.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jvd8E3STlarofaCNpnpuoFXWUhcK/XnVX81wSYHSEg=;
        b=G8hE4WnIEY/6skP44h/a14jcsJrG0NuQZzJz8zIPHdMmR3tEwwAWjRlKYfGWbER/wm
         4qoQPvqQnmOIokOCJ4CQhXDPf5ervhEid1Z3WSzjLG8qywKMgBM8DdIJiAhMnpltyVrw
         tVAKcMD1m/Bp3YvID6/MVdltc9HTDY//EXP1BxBQbYniGjPe5rTkk0TFcug0t1dvmHy+
         v5HlV9vrdPcANwRj2vvmFXNxWdVU3o4fq3eStR1hgTgiaCBsKHr5FtlNA3xEMCnMvNPT
         SwdbIoGTK7sZuNvMc4VZ8EzAs5MvHB0LbLmCyVBK4XkI7R9zt6Fi0FCckpjgr2yepUvw
         jx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jvd8E3STlarofaCNpnpuoFXWUhcK/XnVX81wSYHSEg=;
        b=RF4zTR0Hk1Xqs4DSA6zmfTMR362d0GMUWW1sCB/d44d1tR/PgSqcoPUSdgjEKzDhd1
         ZKuuNza1wqftLadQx13b4+BneHxxbBuEfKkol2dHWF1h+QtY5qV0Vm9fCsK1xLQxqxm9
         C16KgFCT1+j7ZaJyDEU9jBQyNF3IwgWUq+sCXXQE34yCc96773pFMyqM3E9Ibgl42ViB
         gS9Gp/BfK4CG33pFcC6Cl95181Yc70+r/5lT2If6XejVXfPM/XtUvIM40bucZm2IdWoN
         wH8gFh/YlafXnXCsQWvTLs6HKNHhGDphLz/FlHfGiHW3KrdZ+bHduw1L3g3MXb9YKm+d
         y/0Q==
X-Gm-Message-State: AOAM530geGKIRDP/3ldrUAVfCDi8wkajwZ05kQGNJbfZNOWShKk1MsmT
        QE8m7ei4/n6z1KvvQ8/MiGI=
X-Google-Smtp-Source: ABdhPJxfu7fyY6OwPWKSNZf2f1nzcPM0j8pKTMLv6IwZshvqI+HPwqsVDB2HaB6sWb+woFxq7TvXjA==
X-Received: by 2002:a05:6402:1057:: with SMTP id e23mr4070740edu.352.1627535417350;
        Wed, 28 Jul 2021 22:10:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 16/87] trace-cmd library: Inherit compression algorithm from input file
Date:   Thu, 29 Jul 2021 08:08:48 +0300
Message-Id: <20210729050959.12263-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 2fb15026..455ff680 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -239,6 +239,8 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
 size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8495ce35..c5b4c32e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4114,6 +4114,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
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
index 50a91cf4..42b193dc 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1077,6 +1077,9 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *ka
  */
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (!handler || !ihandle || handler->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
@@ -1091,6 +1094,14 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct trace
 	else
 		handler->big_endian = false;
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handler->compress = tracecmd_compress_alloc(cname, cver, handler->fd,
+							    handler->pevent, handler->msg_handle);
+		if (!handler->compress)
+			return -1;
+		if (handler->file_version < 7)
+			handler->file_version = 7;
+	}
 
 	return 0;
 }
@@ -1716,6 +1727,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -1754,6 +1767,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->options_start = tracecmd_get_options_offset(ihandle);
 	list_head_init(&handle->options);
 
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

