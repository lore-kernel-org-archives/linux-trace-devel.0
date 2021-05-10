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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23CBC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB68610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhEJGRw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGRv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87017C061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g14so17328109edy.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ftQ8/DXOaPW/fIkHu0/EF4I/73JhoaER+rpDrK80TQw=;
        b=RTa0tjvpWMrm88UgPEU04gygAiH5Jk3fBmboWEWi+27CH6sYClzqv2qy+Z8X1TJfeX
         GIf8KZYGISkd82Tfr7U19S0huRRe9kMirvBetMyd8nXUmkHKGkuXegXjL0d19TGq1LTf
         OPaks3V1IPQmlpbr4P78QWNPiDknNPHaI8OFdsJzkTIbXCXOzN0jqvdICjrSMx83Z9CM
         /rRo+8BzGINGxhm7J/c5nDfAaL/FDVeRHtnJdBWSGmOTA1fR0/fkh6EVVNWuv/3LEqze
         uo11Tm0ifJVG26uZm1UdAvFSLkJlmPTcZc4J3GlP76F93r3pTcTl93U3Isxy3+Bo3XAR
         YQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ftQ8/DXOaPW/fIkHu0/EF4I/73JhoaER+rpDrK80TQw=;
        b=m0bX2lWBdk6+0ss9vFoZ/aytzo46VuOt5o0Qk0G2gxIFKq3oFqZ3/+hlDik+WCoFYx
         Tl3ZvCNaRtgPdy9JlW5t9tfIwPj0BDxEJ7wjCVZ8ubmKivvNAsuEnzonxLfV/xTR19MU
         pf0tKQLhSeEemuqrNr1csNEO8KKdkRME+9eV0RIt0UlDDCALXxkrdrV6V3+fegHXajsP
         XpLVhOONIrnZjeBk+EB1nz3NE104pHjLZD8jVgHvkATUbh0zy1zW4nst53d5tOCXiequ
         zeTHtvjbm6m34oRVkNoj82oqsS//1ZEXMSyfQMQkI2VJsfzuz1gA37Ng99eU6sQwRKyy
         xUQw==
X-Gm-Message-State: AOAM532DNwWNh2HFkMvpZKxwxJagsiAOrw8sVLzORQxKBDnS5LB3y+9p
        wdeNMeO7nhaDClwKJP6vI7fOy8KLLVTZNg==
X-Google-Smtp-Source: ABdhPJyv0U2xD9lOhYzpH66Jvbgckh3WOW34xn2aalvAi7hCNt4Mvr/HJd1lPtqC0nSUn2JkW3XLpA==
X-Received: by 2002:aa7:d513:: with SMTP id y19mr26898773edq.9.1620627405154;
        Sun, 09 May 2021 23:16:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/21] trace-cmd library: Add support for compression algorithms
Date:   Mon, 10 May 2021 09:16:22 +0300
Message-Id: <20210510061636.1794357-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added infrastructure to trace-cmd library for compression. Introduced
various new APIs to work with this new functionality:
 struct tracecmd_compression
 tracecmd_compress_init()
 tracecmd_compress_free()
 tracecmd_compress_alloc()
 tracecmd_compress_destroy()
 tracecmd_compress_block()
 tracecmd_uncompress_block()
 tracecmd_compress_reset()
 tracecmd_compress_read()
 tracecmd_compress_pread()
 tracecmd_compress_write()
 tracecmd_compress_lseek()
 tracecmd_compress_proto_get_name()
 tracecmd_compress_is_supported()
 tracecmd_compress_protos_get()
 tracecmd_compress_proto_register()
The compression algorithms are not part of this patch.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                        |   1 +
 .../include/private/trace-cmd-private.h       |  26 +
 lib/trace-cmd/include/trace-cmd-local.h       |   2 +
 lib/trace-cmd/trace-compress.c                | 535 ++++++++++++++++++
 lib/trace-cmd/trace-util.c                    |   3 +
 5 files changed, 567 insertions(+)
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
index e410a6f1..602817cb 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -463,6 +463,32 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync);
 
+/* --- Compression --- */
+struct tracecmd_compression;
+struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const char *version,
+						     int fd, struct tep_handle *tep,
+						     struct tracecmd_msg_handle *msg_handle);
+void tracecmd_compress_destroy(struct tracecmd_compression *handle);
+int tracecmd_compress_block(struct tracecmd_compression *handle);
+int tracecmd_uncompress_block(struct tracecmd_compression *handle);
+void tracecmd_compress_reset(struct tracecmd_compression *handle);
+int tracecmd_compress_read(struct tracecmd_compression *handle, char *dst, int len);
+int tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, int len, off_t offset);
+int tracecmd_compress_write(struct tracecmd_compression *handle,
+			    const void *data, unsigned long long size);
+off_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off_t offset, int whence);
+int tracecmd_compress_proto_get_name(struct tracecmd_compression *compress,
+				     const char **name, const char **version);
+bool tracecmd_compress_is_supported(const char *name, const char *version);
+int tracecmd_compress_protos_get(char ***names, char ***versions);
+int tracecmd_compress_proto_register(const char *name, const char *version, int weight,
+				     int (*compress)(char *in, unsigned int in_bytes,
+						     char *out, unsigned int *out_bytes),
+				     int (*uncompress)(char *in, unsigned int in_bytes,
+						       char *out, unsigned int *out_bytes),
+				     unsigned int (*comress_size)(unsigned int bytes),
+				     bool (*is_supported)(const char *name, const char *version));
+
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index e8533b22..862283fc 100644
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
index 00000000..0f7e318a
--- /dev/null
+++ b/lib/trace-cmd/trace-compress.c
@@ -0,0 +1,535 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <sys/time.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <unistd.h>
+
+#include "trace-cmd-private.h"
+#include "trace-cmd-local.h"
+
+struct compress_proto {
+	struct compress_proto *next;
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
+static struct compress_proto *proto_list;
+
+struct tracecmd_compression {
+	int				fd;
+	unsigned int			capacity;
+	unsigned long			pointer;
+	char				*buffer;
+	struct compress_proto		*proto;
+	struct tep_handle		*tep;
+	struct tracecmd_msg_handle	*msg_handle;
+};
+
+static int read_fd(int fd, char *dst, int len)
+{
+	size_t size = 0;
+	int r;
+
+	do {
+		r = read(fd, dst+size, len);
+		if (r > 0) {
+			size += r;
+			len -= r;
+		} else
+			break;
+	} while (r > 0);
+
+	if (len)
+		return -1;
+	return size;
+}
+
+static long long write_fd(int fd, const void *data, size_t size)
+{
+	long long tot = 0;
+	long long w;
+
+	do {
+		w = write(fd, data + tot, size - tot);
+		tot += w;
+
+		if (!w)
+			break;
+		if (w < 0)
+			return w;
+	} while (tot != size);
+
+	return tot;
+}
+
+static long long do_write(struct tracecmd_compression *handle,
+			  const void *data, unsigned long long size)
+{
+	int ret;
+
+	if (handle->msg_handle) {
+		ret = tracecmd_msg_data_send(handle->msg_handle, data, size);
+		if (ret)
+			return -1;
+		return size;
+	}
+	return write_fd(handle->fd, data, size);
+}
+
+/**
+ * tracecmd_compress_lseek - Move the read/write pointer into the compression buffer
+ * @handle: compression handler
+ * @offset: number of bytes to move the pointer, can be negative or positive
+ * @whence: the starting position of the pointer movement,
+ *
+ * Read compressed memory block from the file and uncompress it into internal buffer.
+ * The tracecmd_compress_read() can be used to read the uncompressed data from the buffer
+ *
+ * Returns the new file pointer on success, or -1 in case of an error.
+ */
+off_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off_t offset, int whence)
+{
+	unsigned long p, extend;
+	char *buf;
+
+	if (!handle || !handle->buffer)
+		return (off_t)-1;
+
+	switch (whence) {
+	case SEEK_CUR:
+		p = handle->pointer + offset;
+		break;
+	case SEEK_END:
+		p = handle->capacity + offset;
+		break;
+	case SEEK_SET:
+		p = offset;
+		break;
+	default:
+		return (off_t)-1;
+	}
+
+	if (p <= handle->capacity) {
+		handle->pointer = p;
+	} else {
+		extend = p - handle->capacity;
+		extend = extend < BUFSIZ ? BUFSIZ : extend;
+		buf = realloc(handle->buffer, handle->capacity + extend);
+		if (!buf)
+			return (off_t)-1;
+		handle->buffer = buf;
+		handle->capacity += extend;
+		handle->pointer = p;
+	}
+
+	return p;
+}
+
+static int compress_read(struct tracecmd_compression *handle, char *dst, int len)
+{
+	int s;
+
+	if (handle->pointer + len > handle->capacity)
+		s = handle->capacity - handle->pointer;
+	else
+		s = len;
+	memcpy(dst, handle->buffer + handle->pointer, s);
+
+	return s;
+}
+
+int tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, int len, off_t offset)
+{
+	int ret;
+
+	if (!handle || !handle->buffer || offset > handle->capacity)
+		return -1;
+
+	ret = tracecmd_compress_lseek(handle, offset, SEEK_SET);
+	if (ret < 0)
+		return ret;
+	return compress_read(handle, dst, len);
+}
+
+int tracecmd_compress_read(struct tracecmd_compression *handle, char *dst, int len)
+{
+	int ret;
+
+	if (!handle || !handle->buffer)
+		return -1;
+
+	ret = compress_read(handle, dst, len);
+	if (ret > 0)
+		handle->pointer += ret;
+
+	return ret;
+}
+
+void tracecmd_compress_reset(struct tracecmd_compression *handle)
+{
+	if (handle) {
+		free(handle->buffer);
+		handle->buffer = NULL;
+		handle->pointer = 0;
+		handle->capacity = 0;
+	}
+}
+
+/**
+ * tracecmd_uncompress_block - uncompress a memory block
+ * @handle: compression handler
+ *
+ * Read compressed memory block from the file and uncompress it into internal buffer.
+ * The tracecmd_compress_read() can be used to read the uncompressed data from the buffer
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracecmd_uncompress_block(struct tracecmd_compression *handle)
+{
+	unsigned int s_uncompressed;
+	unsigned int s_compressed;
+	char buf[4];
+	char *bytes = NULL;
+	int ret;
+
+	if (!handle || !handle->proto || !handle->proto->uncompress_block)
+		return -1;
+	tracecmd_compress_reset(handle);
+
+	if (read(handle->fd, buf, 4) != 4)
+		return -1;
+	s_compressed = tep_read_number(handle->tep, buf, 4);
+	if (read(handle->fd, buf, 4) != 4)
+		return -1;
+	s_uncompressed = tep_read_number(handle->tep, buf, 4);
+
+	handle->buffer = malloc(s_uncompressed);
+	if (!handle->buffer)
+		return -1;
+	bytes = malloc(s_compressed);
+	if (!bytes)
+		goto error;
+
+	if (read_fd(handle->fd, bytes, s_compressed) < 0)
+		goto error;
+	ret = handle->proto->uncompress_block(bytes, s_compressed,
+					      handle->buffer, &s_uncompressed);
+	if (ret)
+		goto error;
+	free(bytes);
+	handle->pointer = 0;
+	handle->capacity = s_uncompressed;
+	return 0;
+error:
+	tracecmd_compress_reset(handle);
+	free(bytes);
+	return -1;
+}
+
+/**
+ * tracecmd_compress_block - compress a memory block
+ * @handle: compression handler
+ *
+ * Compress the content of the internal memory buffer and write the compressed data in the file
+ * The tracecmd_compress_write() can be used to write data into the internal memory buffer, before
+ * calling this API.
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracecmd_compress_block(struct tracecmd_compression *handle)
+{
+	unsigned int size;
+	char *buf;
+	int endian4;
+	int ret;
+
+	size = handle->proto->comress_size(handle->pointer);
+	buf = malloc(size);
+	if (!buf)
+		return -1;
+	ret = handle->proto->comress_block(handle->buffer, handle->pointer, buf, &size);
+	if (ret < 0)
+		goto out;
+	/* Write compressed data size */
+	endian4 = tep_read_number(handle->tep, &size, 4);
+	ret = do_write(handle, &endian4, 4);
+	if (ret != 4)
+		goto out;
+	/* Write uncompressed data size */
+	endian4 = tep_read_number(handle->tep, &handle->pointer, 4);
+	ret = do_write(handle, &endian4, 4);
+	if (ret != 4)
+		goto out;
+	/* Write uncompressed the data */
+	ret = do_write(handle, buf, size);
+	ret = ((ret == size) ? 0 : -1);
+out:
+	tracecmd_compress_reset(handle);
+	free(buf);
+	return ret;
+}
+
+int tracecmd_compress_write(struct tracecmd_compression *handle,
+			    const void *data, unsigned long long size)
+{
+	char *buf;
+	int extend;
+
+	if (handle->capacity < handle->pointer + size) {
+		extend = (handle->pointer + size) - handle->capacity;
+		extend = extend < BUFSIZ ? BUFSIZ : extend;
+		buf = realloc(handle->buffer, handle->capacity + extend);
+		if (!buf)
+			return -1;
+		handle->buffer = buf;
+		handle->capacity += extend;
+	}
+	memcpy(&handle->buffer[handle->pointer], data, size);
+	handle->pointer += size;
+	return 0;
+}
+
+/**
+ * tracecmd_compress_init - initialize the library with available compression algorithms
+ *
+ * Returns 0. If no compression algorithms are available, a warning is printed.
+ */
+int tracecmd_compress_init(void)
+{
+	struct timeval time;
+
+	gettimeofday(&time, NULL);
+	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
+
+	return 0;
+}
+
+static struct compress_proto *compress_proto_select(void)
+{
+	struct compress_proto *proto = proto_list;
+	struct compress_proto *selected = NULL;
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
+
+struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const char *version,
+						     int fd, struct tep_handle *tep,
+						     struct tracecmd_msg_handle *msg_handle)
+{
+	struct compress_proto *proto;
+	struct tracecmd_compression *new;
+
+	if (name) {
+		proto = proto_list;
+		while (proto) {
+			if (proto->is_supported && proto->is_supported(name, version))
+				break;
+			proto = proto->next;
+		}
+	} else {
+		proto = compress_proto_select();
+	}
+	if (!proto)
+		return NULL;
+
+	new = calloc(1, sizeof(*new));
+	if (!new)
+		return NULL;
+	new->fd = fd;
+	new->tep = tep;
+	new->msg_handle = msg_handle;
+	new->proto = proto;
+	return new;
+}
+
+void tracecmd_compress_destroy(struct tracecmd_compression *handle)
+{
+	tracecmd_compress_reset(handle);
+	free(handle);
+}
+
+/**
+ * tracecmd_compress_is_supported - check if compression algorithm with given name and
+ *				    version is supported
+ * @name: name of the compression algorithm.
+ * @version: version of the compression algorithm.
+ *
+ * Returns true if the algorithm with given name and version is supported or false if it is not.
+ */
+bool tracecmd_compress_is_supported(const char *name, const char *version)
+{
+	struct compress_proto *proto = proto_list;
+
+	if (!name)
+		return NULL;
+
+	while (proto) {
+		if (proto->is_supported && proto->is_supported(name, version))
+			return true;
+		proto = proto->next;
+	}
+	return false;
+}
+
+/**
+ * tracecmd_compress_proto_get_name - get name and version of compression algorithm
+ * @compress: compression handler.
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_compress_proto_get_name(struct tracecmd_compression *compress,
+				     const char **name, const char **version)
+{
+	if (!compress || !compress->proto)
+		return -1;
+	if (name)
+		*name = compress->proto->proto_name;
+	if (version)
+		*version = compress->proto->proto_version;
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
+	struct compress_proto *new;
+
+	if (!name || !compress || !uncompress)
+		return -1;
+	if (tracecmd_compress_is_supported(name, version))
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
+	struct compress_proto *proto = proto_list;
+	struct compress_proto *del;
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
+	struct compress_proto *proto = proto_list;
+	char **n = NULL;
+	char **v = NULL;
+	int c, i;
+
+	for (c = 0; proto; proto = proto->next)
+		c++;
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
+	proto = proto_list;
+	for (i = 0; i < c && proto; i++) {
+		n[i] = proto->proto_name;
+		v[i] = proto->proto_version;
+		proto = proto->next;
+	}
+
+	*names = n;
+	*versions = v;
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
2.31.1

