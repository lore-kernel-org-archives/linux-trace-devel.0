Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CECBC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352439AbiASI1X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI1W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:22 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91142C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:22 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cx27so7701664edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VDDOy2QmvFB+qN76D8uPWFs6HR7m9UDxa5BcE8UItZs=;
        b=iK2gmkWmnWXKc5K+m907bL+1qu2W6LD3W2Ot4qrxR6fgxOvDchpSE9zQhUxCejC4Tm
         iteciP/J3SRcRS79UPZqpndMXh/An5KRaZ/fnBGffM7Am6EZbCDg50o9011d3ee0y8ii
         utXvx6nnryhzYrzThZb7odxL1iLrLVkAg4O3AZMsF1jnJIVeOObJHwa41Aj7sYLLHcf+
         hffzd/YdoGhCaYi3kXMj8KmwIspztwVMoBuwlv3lVXECZ0Du5grujEiOilg2aG849ccY
         uU5oxSg9hw3ZEB1ja2CKP8F4J9nnS0vgZfWiy944q0p+UeP1OuQxAF8f0rmfwMBTror/
         bz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDDOy2QmvFB+qN76D8uPWFs6HR7m9UDxa5BcE8UItZs=;
        b=1HhbpemhmOAqUPV5J9Amc+cN8YOUpAnIY2+BtgqNDevJGKsHKxeHCV/YOtD1plEaFy
         WlWN/IpplaLv/ly+h+8FQ6EMPfGNERYM4fZPmc81BWqd6Fml6RjfFvygk2h+MaXlHtQz
         W7waLZ2j7M7I8O0Pfjfbayycbpi5gS892GRWqVk+UrdtSI0JkEEUEzSkpRPIdfForlZk
         s/CmbSlePGrrGlT2k4FTYkZf5u4C5nuR9/p1SFDpEiHsxPcLAG38ckCdu1sGqniFbAE8
         VSVqxCjjfrblR/xZmpNxXEywkb4K1/bjNDE80fY5EfOqWNl38kMIqc20zcPecIIrbdVo
         iF8w==
X-Gm-Message-State: AOAM533z9Jiqg9L6b2HtPF9hxuHRgDc0UXtoU+kLPcbyVx2VeQkeq1lz
        3i45hMHnaAj/Zy+XVUye+jKnkVvnQuo=
X-Google-Smtp-Source: ABdhPJziaSYE8Qk0q963yV6K/DQfjF+FxigImVtl4ZG00VQhPaDkXyBO4sO7qMdLdRcBcjZmZB5m0w==
X-Received: by 2002:a17:906:4786:: with SMTP id cw6mr18330245ejc.600.1642580841214;
        Wed, 19 Jan 2022 00:27:21 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Wed, 19 Jan 2022 10:26:59 +0200
Message-Id: <20220119082715.245846-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index f8f0ba15..bcc4c9f3 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -261,6 +261,8 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
 size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 49ada92f..a81112f0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4661,6 +4661,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
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
index 2b944913..c37fee1a 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1299,6 +1299,9 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kal
  */
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (!handle || !ihandle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
@@ -1310,6 +1313,15 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->big_endian = tep_is_file_bigendian(handle->pevent);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							    handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			return -1;
+		if (handle->file_version < FILE_VERSION_COMPRESSION)
+			handle->file_version = FILE_VERSION_COMPRESSION;
+	}
+
 	return 0;
 }
 
@@ -2270,6 +2282,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -2310,6 +2324,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
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
2.34.1

