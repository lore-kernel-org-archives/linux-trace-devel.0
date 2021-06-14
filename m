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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581A4C49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C28E61352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhFNHx4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:56 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:35694 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbhFNHxz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:55 -0400
Received: by mail-ed1-f54.google.com with SMTP id ba2so43439333edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aDJnSem5m9IjjShjp7Lc+1Wlm1Vn0fuQSvGLvISDyCo=;
        b=LyZFIeoW7pDPe10EDwEgGAyw/jyYlP/knNh5pThmVI5BWt/MSs9APeciwGZzRyeLnB
         eNAUdCXNG5eQ5EQU36qTsEaKvp29lRKuD7IjaYDZblGauPbHf3ajh4OAHGP5oqb0Fm6H
         KApc8osgL/DVUVet9DLmQFUcO1Bkngvo9lg8oBrTHbqyPJQPGU4956Eh6UHkxhMSLync
         ZubtW6AvAhJeFhHo47r1yTflPvWgnXtWaRDqeVsCg0UNcPKntWP6cad3Pc7HLHmZWY1M
         FyiMGVDnbNr/u/Cm4r1cE0R2sjZS+sEjU35fglnPJ2o8d4glkeN8LPkeOY6T8ml9KPe1
         dzTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aDJnSem5m9IjjShjp7Lc+1Wlm1Vn0fuQSvGLvISDyCo=;
        b=df03ccdBn9OBhNo5ivr+5Q4SQVU72va+lkumWzy+ZUfQ8XdiWw6bG9w1xMi6hy8VkN
         zWDDCRtkiuv6U0dX2/Oz6h1Du5s8RcX+6miDhomoPUoDlgCMfP81I7vUB75PGoaUUll1
         eoKopNN4MrEYF+jFm67C00oXGtSHXnwUAAI1Lxl7aG9wgsnfnE2bFkJYIX/Jbt34SnJA
         65Alh5cdJhXnVw0rcqcFY8XmHnkHx9wL6o1XUe5q5R7p+XeAjhGLvdSsJoFe5YwApnZi
         d4nz9AT4qsRJINhD67z617q0gXLP3/hE6GbE9fuHOM2m+v8+TQ4y95fbemPlXUxBD3jY
         8keA==
X-Gm-Message-State: AOAM5319AA34VsGjk2CRINiEu8xabMOPmusq2MKRW5oJOwB4A89rj3RQ
        zIE4AiSxnyxUvQVzCyWiVfPxES2fZ0NRPg==
X-Google-Smtp-Source: ABdhPJz5w6J5lbactlVa8LFRVgUsnzpmZrNIQQpCB7ztK+Qj6QNiliqmeO3vo6T+feRdiRHzVHHlDQ==
X-Received: by 2002:a05:6402:1a:: with SMTP id d26mr15820729edu.105.1623657038907;
        Mon, 14 Jun 2021 00:50:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 07/45] trace-cmd library: Add support for compression algorithms
Date:   Mon, 14 Jun 2021 10:49:51 +0300
Message-Id: <20210614075029.598048-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-compress.c                | 589 ++++++++++++++++++
 lib/trace-cmd/trace-util.c                    |   3 +
 5 files changed, 621 insertions(+)
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
index be8b3c48..ec534d51 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -464,6 +464,32 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
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
index 821b5cdb..c6591e56 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -31,5 +31,7 @@ void tracecmd_info(const char *fmt, ...);
 #endif
 #endif
 
+void tracecmd_compress_init(void);
+void tracecmd_compress_free(void);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
new file mode 100644
index 00000000..378a3e57
--- /dev/null
+++ b/lib/trace-cmd/trace-compress.c
@@ -0,0 +1,589 @@
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
+	int (*compress_block)(char *in, unsigned int in_bytes,
+			     char *out, unsigned int *out_bytes);
+	int (*uncompress_block)(char *in, unsigned int in_bytes,
+				char *out, unsigned int *out_bytes);
+	unsigned int (*compress_size)(unsigned int bytes);
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
+/**
+ * tracecmd_compress_pread - pread() on compression buffer
+ * @handle: compression handler
+ * @dst: return, store the read data
+ * @len: length of data to be read
+ * @offset: offset in the buffer of data to be read
+ *
+ * Read a @len of data from the compression buffer at given @offset,
+ * without updating the buffer pointer.
+ *
+ * On success returns the number of bytes read, or -1 on failure.
+ */
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
+/**
+ * tracecmd_compress_read - read() from compression buffer
+ * @handle: compression handler
+ * @dst: return, store the read data
+ * @len: length of data to be read
+ *
+ * Read a @len of data from the compression buffer
+ *
+ * On success returns the number of bytes read, or -1 on failure.
+ */
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
+/**
+ * tracecmd_compress_reset - Reset the compression buffer
+ * @handle: compression handler
+ *
+ * Reset the compression buffer, any data currently in the buffer will be destroyed.
+ *
+ */
+void tracecmd_compress_reset(struct tracecmd_compression *handle)
+{
+	if (!handle)
+		return;
+
+	free(handle->buffer);
+	handle->buffer = NULL;
+	handle->pointer = 0;
+	handle->capacity = 0;
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
+	char *bytes = NULL;
+	char buf[4];
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
+	if (!handle || !handle->proto ||
+	    !handle->proto->compress_size || !handle->proto->compress_block)
+		return -1;
+
+	size = handle->proto->compress_size(handle->pointer);
+	buf = malloc(size);
+	if (!buf)
+		return -1;
+	ret = handle->proto->compress_block(handle->buffer, handle->pointer, buf, &size);
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
+	/* Write compressed data */
+	ret = do_write(handle, buf, size);
+	ret = ((ret == size) ? 0 : -1);
+out:
+	tracecmd_compress_reset(handle);
+	free(buf);
+	return ret;
+}
+
+/**
+ * tracecmd_compress_write - write() to compression buffer
+ * @handle: compression handler
+ * @data: data to be written
+ * @size: size of @data
+ *
+ * Write @data of @size in the compression buffer
+ *
+ * Returns 0 on success, or -1 on failure.
+ */
+int tracecmd_compress_write(struct tracecmd_compression *handle,
+			    const void *data, unsigned long long size)
+{
+	char *buf;
+	int extend;
+
+	if (!handle)
+		return -1;
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
+ */
+void tracecmd_compress_init(void)
+{
+	struct timeval time;
+
+	gettimeofday(&time, NULL);
+	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
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
+/**
+ * tracecmd_compress_alloc - Allocate a new compression context
+ * @name: name of the compression algorithm, if NULL - auto select the best available algorithm
+ * @version: version of the compression algorithm, can be NULL
+ * @fd: file descriptor for reading / writing data
+ * @tep: tep handler, used to encode the data
+ * @msg_handle: message handler, use it for reading / writing data instead of @fd
+ *
+ * Returns NULL on failure or pointer to allocated compression context.
+ * The returned context must be freed by tracecmd_compress_destroy()
+ */
+struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const char *version,
+						     int fd, struct tep_handle *tep,
+						     struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_compression *new;
+	struct compress_proto *proto;
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
+/**
+ * tracecmd_compress_destroy - Free a compression context
+ * @handle: handle to the compression context that will be freed
+ */
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
+ * @compress_size: hook, called to get the required minimum size of the buffer for compression
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
+				     unsigned int (*compress_size)(unsigned int bytes),
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
+	new->compress_block = compress;
+	new->uncompress_block = uncompress;
+	new->compress_size = compress_size;
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
+	if (!v)
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
index 61054ad2..136260c6 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -627,9 +627,12 @@ bool tracecmd_is_version_supported(unsigned int version)
 
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

