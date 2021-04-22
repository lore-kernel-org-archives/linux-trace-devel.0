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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705B6C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3126121E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhDVHj7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhDVHjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:41 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B289C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:07 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h8so12087398edb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=94c09gUaJOGuAsARNtU1HFWLfCNONg67rar31r48Dyg=;
        b=VySKVNsOC54abebBHfmrtLuVZgC7px+21lnzy/VA64sfFXTX1X5JbU0h6Rp0DPMnZV
         tcn+WbKw27unbCmfAX/AC0js0AyagggtcFO6P+d/5lB5KgguhWOkvkmzlCzGDObMwRmV
         nzOByMDPfCL78pEWeV4MxOyo87tj/hfsAUKXxsuUJMCva8nFofkXDJkNmC1EWG1qD+Wj
         MpL+9H6hDkbIoNPlLnzNXz7VJz2xvtCsWch+AUw/g9LIZG0BEVgX3QteUijh7kpURNoe
         dSHnougmQOH6/1D148dBSis/NV/shzrP+TBSH/LkpJ6uhg7hDjDW+HDrKOXr4GEE6em+
         ceYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=94c09gUaJOGuAsARNtU1HFWLfCNONg67rar31r48Dyg=;
        b=F/opQxlfDqhX0HGj2hIXXHPGFJDmzuUAQVXiaD1lJl7+YjMsSBpI3HCotWanJB4BkK
         fdla8sB1IJwgAqCmOzQSqIUGXwgegjPn0DYEvrctfgqCPEckcDF3XxVHH2AvOqsRUyHC
         yelZozWueMlXyCalKPSDRm02kGz+M8TSoI5HSmxP2hbyTxc8A4RwDaHFOPK2mR3+Eec5
         2pSOrQ0g+naEnxQdDNBTD+ibjkkI1j9MTYCbFp0U/nULhljlJlFNqUQ7TfFMKmeBoWmh
         8AP9JlyOO7xcZ5SPGTq00L/z4Y7qTgENgCAIxkwgvQxp8vI3HWnjpw+dF93N9qNDcLmc
         IMvw==
X-Gm-Message-State: AOAM533nH0ZSH9MYOlFyC924P2VYV887XT5l2T4hSLVDlMIiDLiPW682
        yocvjPCXOaMecpmJxUsWeoRdTvkhI/n9UQ==
X-Google-Smtp-Source: ABdhPJxgZCok9fUlY7yX0dj7GI6LIvWVE6TkIQrL7B1wHItvjwdPr6MeL1s6m0OLEg7jDth43X8L0A==
X-Received: by 2002:aa7:c4c1:: with SMTP id p1mr2052282edr.133.1619077145959;
        Thu, 22 Apr 2021 00:39:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/10] trace-cmd library: Add support for compression algorithms
Date:   Thu, 22 Apr 2021 10:38:54 +0300
Message-Id: <20210422073902.484953-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added infrastructure to trace-cmd library for compression. Introduced
various new APIs to work with this new functionality:
 tracecmd_compress_proto_get()
 tracecmd_compress_protos_get()
 tracecmd_compress_proto_get_name()
 tracecmd_compress_proto_select()
 tracecmd_compress_proto_register()
 tracecmd_compress_data()
 tracecmd_uncompress_data()
 tracecmd_get_compress_size()

The compression algorithms are not part of this patch.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                        |   1 +
 .../include/private/trace-cmd-private.h       |  22 ++
 lib/trace-cmd/include/trace-cmd-local.h       |   2 +
 lib/trace-cmd/trace-compress.c                | 287 ++++++++++++++++++
 lib/trace-cmd/trace-util.c                    |   3 +
 5 files changed, 315 insertions(+)
 create mode 100644 lib/trace-cmd/trace-compress.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 17600318..bab4322d 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -25,6 +25,7 @@ ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync-ptp.o
 OBJS += trace-timesync-kvm.o
 endif
+OBJS += trace-compress.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 5d35b197..c562fc5d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -471,6 +471,28 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync);
 
+/* --- Compression --- */
+struct tracecmd_compress_proto;
+struct tracecmd_compress_proto *tracecmd_compress_proto_get(const char *name, const char *version);
+struct tracecmd_compress_proto *tracecmd_compress_proto_select(void);
+int tracecmd_compress_proto_register(const char *name, const char *version, int weight,
+				     int (*compress)(char *in, unsigned int in_bytes,
+						     char *out, unsigned int *out_bytes),
+				     int (*uncompress)(char *in, unsigned int in_bytes,
+						       char *out, unsigned int *out_bytes),
+				     unsigned int (*comress_size)(unsigned int bytes),
+				     bool (*is_supported)(const char *name, const char *version));
+int tracecmd_compress_protos_get(char ***names, char ***versions);
+int tracecmd_compress_proto_get_name(struct tracecmd_compress_proto *proto,
+				     const char **name, const char **version);
+int tracecmd_compress_data(struct tracecmd_compress_proto *proto,
+			   char *in, unsigned int in_bytes,
+			   char *out, unsigned int *out_bytes);
+int tracecmd_uncompress_data(struct tracecmd_compress_proto *proto,
+			     char *in, unsigned int in_bytes,
+			     char *out, unsigned int *out_bytes);
+unsigned int tracecmd_get_compress_size(struct tracecmd_compress_proto *proto, unsigned int bytes);
+
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 5578f00d..c8c51ff0 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -30,5 +30,7 @@ void tracecmd_fatal(const char *fmt, ...);
 #endif
 #endif
 
+int tracecmd_compress_init(void);
+void tracecmd_compress_free(void);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
new file mode 100644
index 00000000..c59c8bdb
--- /dev/null
+++ b/lib/trace-cmd/trace-compress.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <sys/time.h>
+
+#include "trace-cmd-private.h"
+#include "trace-cmd-local.h"
+
+struct tracecmd_compress_proto {
+	struct tracecmd_compress_proto *next;
+	char *proto_name;
+	char *proto_version;
+	int weight;
+
+	int (*comress_block)(char *in, unsigned int in_bytes,
+			     char *out, unsigned int *out_bytes);
+	int (*uncompress_block)(char *in, unsigned int in_bytes,
+				char *out, unsigned int *out_bytes);
+	unsigned int (*comress_size)(unsigned int bytes);
+	bool (*is_supported)(const char *name, const char *version);
+};
+
+static struct tracecmd_compress_proto *proto_list;
+
+/**
+ * tracecmd_compress_init - initialize the library with available compression algorithms
+ *
+ * Returns 0. If no compression algorithms are available, a warning is printed.
+ */
+int tracecmd_compress_init(void)
+{
+	struct timeval time;
+	int count = 0;
+
+	gettimeofday(&time, NULL);
+	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
+
+/* toDo: add here initialization of compression protocols */
+
+	if (!count)
+		tracecmd_warning("No compression support available");
+
+	return 0;
+}
+
+/**
+ * tracecmd_compress_proto_get - get handler to compression algorithm from name and version
+ * @name: name of the compression algorithm.
+ * @version: version of the compression algorithm.
+ *
+ * Returns a handler to compression algorithm, or NULL if algorithm with given name and version is
+ * not found.
+ */
+struct tracecmd_compress_proto *tracecmd_compress_proto_get(const char *name, const char *version)
+{
+	struct tracecmd_compress_proto *proto = proto_list;
+
+	if (!name)
+		return NULL;
+
+	while (proto) {
+		if (proto->is_supported && proto->is_supported(name, version))
+			return proto;
+		proto = proto->next;
+	}
+	return NULL;
+}
+
+/**
+ * tracecmd_compress_proto_select - select compression algorithm
+ *
+ * The algorithm with the lowest weight is selected.
+ * Returns a handler to compression algorithm, or NULL if no algorithms are available.
+ */
+struct tracecmd_compress_proto *tracecmd_compress_proto_select(void)
+{
+	struct tracecmd_compress_proto *proto = proto_list;
+	struct tracecmd_compress_proto *selected = NULL;
+
+	while (proto) {
+		if (!selected || selected->weight > proto->weight)
+			selected = proto;
+		proto = proto->next;
+	}
+
+	return selected;
+}
+
+/**
+ * tracecmd_compress_proto_get_name - get name and version of compression algorithm
+ * @proto: handler to compression algorithm.
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_compress_proto_get_name(struct tracecmd_compress_proto *proto,
+				     const char **name, const char **version)
+{
+	if (!proto)
+		return -1;
+	if (name)
+		*name = proto->proto_name;
+	if (version)
+		*version = proto->proto_version;
+	return 0;
+}
+
+/**
+ * tracecmd_compress_proto_register - register a new compression algorithm
+ * @name: name of the compression algorithm.
+ * @version: version of the compression algorithm.
+ * @weight: weight of the compression algorithm, lower is better.
+ * @compress: compression hook, called to compress a memory block.
+ * @uncompress: uncompression hook, called to uncompress a memory block.
+ * @comress_size: hook, called to get the required minimum size of the buffer for compression
+ *		  given number of bytes.
+ * @is_supported: check hook, called to check if compression with given name and version is
+ *		  supported by this plugin.
+ *
+ * Returns 0 on success, or -1 in case of an error. If algorithm with given name and version is
+ * already registered, -1 is returned.
+ */
+int tracecmd_compress_proto_register(const char *name, const char *version, int weight,
+				     int (*compress)(char *in, unsigned int in_bytes,
+						     char *out, unsigned int *out_bytes),
+				     int (*uncompress)(char *in, unsigned int in_bytes,
+						       char *out, unsigned int *out_bytes),
+				     unsigned int (*comress_size)(unsigned int bytes),
+				     bool (*is_supported)(const char *name, const char *version))
+{
+	struct tracecmd_compress_proto *new;
+
+	if (!name || !compress || !uncompress)
+		return -1;
+	if (tracecmd_compress_proto_get(name, version))
+		return -1;
+
+	new = calloc(1, sizeof(*new));
+	if (!new)
+		return -1;
+
+	new->proto_name = strdup(name);
+	if (!new->proto_name)
+		goto error;
+	new->proto_version = strdup(version);
+	if (!new->proto_version)
+		goto error;
+	new->comress_block = compress;
+	new->uncompress_block = uncompress;
+	new->comress_size = comress_size;
+	new->is_supported = is_supported;
+	new->weight = weight;
+	new->next = proto_list;
+	proto_list = new;
+	return 0;
+
+error:
+	free(new->proto_name);
+	free(new->proto_version);
+	free(new);
+	return -1;
+}
+
+/**
+ * tracecmd_compress_free - free the library resources, related to available compression algorithms
+ *
+ */
+void tracecmd_compress_free(void)
+{
+	struct tracecmd_compress_proto *proto = proto_list;
+	struct tracecmd_compress_proto *del;
+
+	while (proto) {
+		del = proto;
+		proto = proto->next;
+		free(del->proto_name);
+		free(del->proto_version);
+		free(del);
+	}
+	proto_list = NULL;
+}
+
+/**
+ * tracecmd_compress_data - compress a memory block
+ * @proto: handle to compression algorithm that will be used to compress the data.
+ * @in: pointer to the data that will be compressed.
+ * @in_bytes: number of bytes in @in.
+ * @out: pre-allocated memory to store the compressed data. It must be at least the size returned
+ *	by tracecmd_get_compress_size().
+ * @out_bytes: size of the allocated memory in @out. On successful return, @out_bytes is updated
+ *	       with the size of the compressed data.
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracecmd_compress_data(struct tracecmd_compress_proto *proto,
+			   char *in, unsigned int in_bytes,
+			   char *out, unsigned int *out_bytes)
+{
+	if (proto && proto->comress_block)
+		return proto->comress_block(in, in_bytes, out, out_bytes);
+	return -1;
+}
+
+/**
+ * tracecmd_uncompress_data - uncompress a memory block
+ * @proto: handle to compression algorithm that will be used to uncompress the data.
+ * @in: pointer to the data that will be uncompressed.
+ * @in_bytes: number of bytes in @in.
+ * @out: pre-allocated memory to store the uncompressed data.
+ * @out_bytes: size of the allocated memory in @out. On successful return, @out_bytes is updated
+ *	       with the size of the uncompressed data.
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracecmd_uncompress_data(struct tracecmd_compress_proto *proto,
+			     char *in, unsigned int in_bytes,
+			     char *out, unsigned int *out_bytes)
+{
+	if (proto && proto->uncompress_block)
+		return proto->uncompress_block(in, in_bytes, out, out_bytes);
+	return -1;
+}
+
+/**
+ * tracecmd_get_compress_size - get the buffer size, required to compress given data
+ * @proto: handle to compression algorithm that will be used to compress the data.
+ * @bytes: number of bytes that will be compressed.
+ *
+ * Returns the required size of the buffer for compression of @bytes, or 0 in case of an error
+ */
+unsigned int tracecmd_get_compress_size(struct tracecmd_compress_proto *proto, unsigned int bytes)
+{
+	if (proto && proto->comress_size)
+		return proto->comress_size(bytes);
+	return -1;
+}
+
+
+/**
+ * tracecmd_compress_protos_get - get a list of all supported compression algorithms and versions
+ * @names: return, array with names of all supported compression algorithms
+ * @versions: return, array with versions of all supported compression algorithms
+ *
+ * On success, the size of @names and @versions arrays is returned. Those arrays are allocated by
+ * the API and must be freed with free() by the caller. Both arrays are with same size, each name
+ * from @names corresponds to a version from @versions.
+ * On error -1 is returned and @names and @versions arrays are not allocated.
+ */
+int tracecmd_compress_protos_get(char ***names, char ***versions)
+{
+	struct tracecmd_compress_proto *proto = proto_list;
+	char **n = NULL;
+	char **v = NULL;
+	int c, i;
+
+	for (c = 0; proto; proto = proto->next)
+		;
+
+	if (c < 1)
+		return c;
+
+	n = calloc(c, sizeof(char *));
+	if (!n)
+		goto error;
+	v = calloc(c, sizeof(char *));
+	if (!n)
+		goto error;
+
+	for (i = 0; proto; proto = proto->next) {
+		n[i] = proto->proto_name;
+		v[i] = proto->proto_version;
+	}
+
+	names = &n;
+	versions = &v;
+	return c;
+
+error:
+	free(n);
+	free(v);
+	return -1;
+}
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 3ef10eae..a42499fe 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -592,9 +592,12 @@ bool tracecmd_is_version_supported(unsigned int version)
 
 int tracecmd_lib_init(void)
 {
+
+	tracecmd_compress_init();
 	return 0;
 }
 
 void tracecmd_lib_free(void)
 {
+	tracecmd_compress_free();
 }
-- 
2.30.2

