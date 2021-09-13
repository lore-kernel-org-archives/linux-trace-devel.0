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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A987C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E976960FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbhIMMn0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbhIMMnZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:25 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A411C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:10 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id s24so6543933wmh.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fCEcFUPk4LuocBOj4/4arEZQy38dO9Jl5rIjrAm+ExY=;
        b=qeZXDI8YoMYyMK7E8lveTweKaC7rvLVwlsLuE9X5DFSu6A0RMfXztbxqzxB5/J5m8X
         h7oVGxRhlksh/2C3IAzksjvj1wJvXdFqL0SL6FUqtqOTSrovwBUOq+GSAkhdMPuSRvgP
         3vmaBxfnthVhbKRT2SyQ91+oepN+cziPOPyqBRKylOzHXkvHHwy0lZ5ffkGvu0n23dXd
         y6MVMiVI6e+WAbogZdCHV5gXl6ULeZydQBDq60v1eh++DH5LteieEvf0CZ947eJti6/j
         zZnjGIojBavQCx4YqckUyPManrKx5KzM+SeoMIuuiXHFQlu9qia2OQpAhP1Gou7koMKI
         8O8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fCEcFUPk4LuocBOj4/4arEZQy38dO9Jl5rIjrAm+ExY=;
        b=IS0HpSDhC9N1WgbdP++MsIO/4np+JC/DkLq6wqbxHblnwuBes5YnZJrKMvNl/Wik6D
         V3+NsWaLfqe220XK7JzRClDhoQXjYnx9v9UCQmvXskEYKXcDxfFCC3XJm/IyQLGQ31BI
         w5GSyJ6bbGizM5CkvdcHCKOKOCEz6ag5mIqkj16Q71vGqWJIoa6f7xUJSpyZjjWo3qdv
         yhP10QxpovQKpii+L+4hDlwKzjYLhj6AhXuWDWE/XvzpQnChA9WloV7QNGc1ufA5yjOE
         EvJWcSqmMFaSNTXtpoHzXPXQFJdLHZWpSOwoE/cZLeePI9Nw2PPtaPcsTHsfVQQq3YHp
         NTRg==
X-Gm-Message-State: AOAM5303+zE4L//6+Feg3mmde53ItmQvrtyoFaf14Ljz4nRR6RScCoT7
        MwOB1ffv104UaAH2DZkbiWV1/vdaawM=
X-Google-Smtp-Source: ABdhPJwbIyWVVw+YuErUHYrO+ZGVbRrnvK25hqJ2Ehx1/ABajVNPxm3L70zXZ0JmUvpqF2fUnhBBGA==
X-Received: by 2002:a1c:1d56:: with SMTP id d83mr5564061wmd.74.1631536928605;
        Mon, 13 Sep 2021 05:42:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Mon, 13 Sep 2021 15:41:47 +0300
Message-Id: <20210913124203.3677760-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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
index 25d376f7..2ea8f5a5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4606,6 +4606,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
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
index 2a694f7f..a655d35f 100644
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

