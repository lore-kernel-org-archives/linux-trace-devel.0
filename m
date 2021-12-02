Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78441C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhLBM2j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbhLBM2i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:38 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865D8C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:15 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y12so115202851eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uqS6FFyiUt0C7g7rtUtam5Y2FPLT2botWa/gIDeNprg=;
        b=Z3soMD3HZBN3V4ycdor3uU9xDwlSEyGB8TUlvpbCuDEPFcg9qv0d0hGI+vgky8Xln3
         BXxwCagBN9wIWr011k5ntSuBGCosyNeKJ1fyiWBRVA5zTE7w8goIyUKufta0qn0gYQRR
         BGBZpTe7RNq88HTPrvEDW1MNOPxSxIj41Noh+MNwRxQudBBLiAX+n3/UslXDAOyXinKP
         9junYNAUSbsIsvGwx7apBUgRy69EAu6I1KMW/jrsUPYjhQzEzKZixkc4lHZ6xIa6Vrap
         bF18M4TD2bSZ+YB8jEZqaS6ust96i7UQsCzhms7NR9kM2glSTCJ2117k9FkoVmq2Axtk
         iWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uqS6FFyiUt0C7g7rtUtam5Y2FPLT2botWa/gIDeNprg=;
        b=nx/KwkFM+YHNc2EjpZZkHx7GIbQK08xL9nHMlZbujVh7CErlt4TjDZM7+uWGb77mu5
         JIX/CjS7S9RFOslOWxbEk3A6l2OBS9mI1U6M4LQDAVNVi2ymnytcLVUU/u5LHM1fBtht
         OhZm6n0PuJ80SYhwyZjhYP0qbjOZmhm57JD6+OTv/8ZBDUlUTnFUAlQEWavqHRanp50C
         +VV9XH3ZEc/R71brEo9ydbVQ0Dl3NtMd+FTrImOBSwDcTs/Pf5S34iyZgqpZibVYDwhg
         hqXvn24ha6kbruZgJStulxWZtMA3oClLeSzFDAAu5xENHkPM8bJ1WZt/VAgL5MZHb+Og
         IBOg==
X-Gm-Message-State: AOAM533Bf0m3CXxW53hIXr8zyKeCxaHaDF3/XzJnwN0GtdMhinuBTEOF
        I+pkL3VrSnzymBXPmADzkPXm3s1YYrQArQ==
X-Google-Smtp-Source: ABdhPJzgvp9VbPmYxl9HcqBznTWwYA1Jo+dnG5ZkK5dodjXKOSEb7g5h76XshHfWkUlzl/C//JwkOA==
X-Received: by 2002:a17:907:9488:: with SMTP id dm8mr15198581ejc.36.1638447912523;
        Thu, 02 Dec 2021 04:25:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Thu,  2 Dec 2021 14:24:51 +0200
Message-Id: <20211202122507.43572-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index fea75f54..9cdd56a9 100644
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
index f6d60aea..8db43708 100644
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
index 455fa93b..7906fd92 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1225,6 +1225,9 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kal
  */
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (!handle || !ihandle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
@@ -1236,6 +1239,15 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
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
 
@@ -2178,6 +2190,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -2217,6 +2231,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
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

