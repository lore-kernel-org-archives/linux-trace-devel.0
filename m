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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5CAC43216
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E3860FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhG1NdO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbhG1NdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D501C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:09 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id nd39so4648675ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5FMNYHvaaFkCN2izTyY6IL8uWP1MS4ouJwuMg94+YAw=;
        b=JNgWd4HDh1ZwrdMS6w+t+RwhEWgajbXE576zYH342io2gBi3XXHx3OeAF6T1EIi0MC
         b9jsaLG9/1jdeVjuMHmi/jX7Cg/ztDvqOp4p/kwmyfmwAwvw7MZtBjtzFpavVHmWYtQD
         4FAE0zg3xWwFWo5fPozYzh2cPxzUcvN9MhbhJFkQAq4LPClPJjNFdquXHclecezD+fUL
         j2fQw2Kjbe/nK2G03Ioj723cM6rWsVmUDS47XjsUCh7I3kI7gVDShI7wI40oSkr8pkkD
         Hv/Tg1Iwrq2MzpIdb1ZP+3w7eEOk/nT5x0/wjll2o5BaWKcwEBKKFw3q00LWOKe+VAUs
         sZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FMNYHvaaFkCN2izTyY6IL8uWP1MS4ouJwuMg94+YAw=;
        b=QZMf0APfc2B1nOcazLH0MdxNoao7kRdvfu6M4lV4zaiyMtejSHldnBkP4dOZpddpdZ
         +1JYkjt84QceReer6r2fDb5M2FDE3stJeVMPmYv9mI8/zJSC4XL86UlfuiDbA4Wy4AWx
         Sz1avPT6eTU3F482LJ9330sR69p93ptqQje9QBYLvLQHadvm3Y1TqSpI+91Rmdom0aER
         +wbOuXldOWApgC1yRO33NV9twOm/TfzEPnm4Xphcrf3wDT8gJxjWgd6eBPm8DVLGw8Wu
         476sXmwjc+TYEwIh4dTRBKCKcLtxSG/47JFHYdL4oYF9BfUxjAa+04EFrwWkAXxsESmP
         /AGQ==
X-Gm-Message-State: AOAM532IWEFTi6xoqDED00bpUCplxD2qoGrLH1WJ1zwKrSIanDBWfErF
        n0sAJtOe4fAFOj7IvbbPWd0qwtl19jndew==
X-Google-Smtp-Source: ABdhPJxd9EeS3QhFwosPSO6+P54wX/9fsfs+zO96vuVl6b0cgCgf2/AwwwtmmAQvInWQma/YXq6HEw==
X-Received: by 2002:a17:907:aa7:: with SMTP id bz7mr26509792ejc.396.1627479188145;
        Wed, 28 Jul 2021 06:33:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 16/87] trace-cmd library: Inherit compression algorithm from input file
Date:   Wed, 28 Jul 2021 16:31:39 +0300
Message-Id: <20210728133250.234140-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 07613135..28eb4d1e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4115,6 +4115,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
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
index 2c10575e..b0ec0c51 100644
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

