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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF42C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4030A60C51
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhINNSH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbhINNSH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01E3C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t8so15131685wrq.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dCwJEKOeshLtdpXMCJCbKaY22zxydQd9xaL4ctaCW2c=;
        b=Eo9DBLZS+wi6AHdwM3el5ACe9K7CPgI+NfxnacRwyPsJHQCbzC6AVayLbC2NVOHU7f
         Wj3Zfe8aW1E3lD+GOi26t9LX/Ar10mA0UvG9JJap82H813kPDNR2oZRaXr3Oh2o6GQrv
         m809jYoZADt0ZrqltLgo8RPjDbV0xFAKzJV7w6XNQgGkRVNGrqExGz14ecJu3sph/0/H
         NFVYtX+2Yeida76bXX7pE71Km/eGWAsaTllgXvPHwYmumx4ZGKQsYqsADRcZbL3PVzGH
         SLazez6t6iNuq2SDUw0BJh3kZ8ta5lOeHzDBxFlkhe2ELQVBwhbd9rle7m8wLeNM4cAe
         HeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dCwJEKOeshLtdpXMCJCbKaY22zxydQd9xaL4ctaCW2c=;
        b=FJwUkaGRr5RZUzeG/AuLn7erGnSuQlVGNlKIsdJK57OfUVJyeQa1//tz2ofkQdTSjA
         fxgux/SCKcYxGFwtO/qV9ztd/LbMTsgS86lnQ3O+YIidBC6JHimO7J3MddtbyISHkPry
         CXQO9zTC84dOTZBXIHamrlUFhujj8LC3QtSQsuBM2SEwF4HzDshh3Pfd7pQC21/cTKBX
         uRZ3lo5vG3jyHTce6BK1vrsOqBtUG+tbg0QF7hNeKa9mDkAJMfE9hIHWt2w7dmtcSU71
         d5vn0f6N2qiOBn+kudmOQRuDdF8S2GXCZEwS3jGxmG1u0mrQG/KIpcT9ffhwMI55FXgT
         zl3g==
X-Gm-Message-State: AOAM5301QCCZVG9z2GndwPu6/zpAiTk+HueOp8bK5zzgS/SMMgvd+Q8r
        j4esOoke/wSTJhYS1XSYifkUAyl107Y=
X-Google-Smtp-Source: ABdhPJzI6trTMUZ6faRGp9T0DsWX8GSyW1oXLZogYjJXA5L5cSs9vPObJuuTGDTI1bQQ9wBYBr+8xg==
X-Received: by 2002:a5d:554e:: with SMTP id g14mr19060192wrw.48.1631625408171;
        Tue, 14 Sep 2021 06:16:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 01/20] trace-cmd library: Add support for compression algorithms
Date:   Tue, 14 Sep 2021 16:16:26 +0300
Message-Id: <20210914131645.3966308-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
 tracecmd_compress_copy_from()
 tracecmd_uncompress_copy_to()
 tracecmd_uncompress_chunk()
 tracecmd_load_chunks_info()

The compression algorithms are not part of this patch.

Added trace-cmd library constructor and destructor routines, used to
initialize and free compression context.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                        |   1 +
 .../include/private/trace-cmd-private.h       |  41 +
 lib/trace-cmd/include/trace-cmd-local.h       |   3 +
 lib/trace-cmd/trace-compress.c                | 907 ++++++++++++++++++
 lib/trace-cmd/trace-util.c                    |  10 +
 5 files changed, 962 insertions(+)
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
index 045fd5a1..04b3cb41 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -36,6 +36,7 @@ int *tracecmd_add_id(int *list, int id, int len);
 #define FILE_VERSION_MAX		7
 
 #define FILE_VERSION_SECTIONS		7
+#define FILE_VERSION_COMPRESSION	7
 
 enum {
 	RINGBUF_TYPE_PADDING		= 29,
@@ -154,6 +155,7 @@ enum {
 	TRACECMD_FL_IN_USECS		= (1 << 2),
 	TRACECMD_FL_RAW_TS		= (1 << 3),
 	TRACECMD_FL_SECTIONED		= (1 << 4),
+	TRACECMD_FL_COMPRESSION		= (1 << 5),
 };
 
 struct tracecmd_ftrace {
@@ -487,6 +489,45 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync);
 
+/* --- Compression --- */
+struct tracecmd_compress_chunk {
+	unsigned int		size;
+	unsigned int		zsize;
+	off64_t			zoffset;
+	off64_t			offset;
+};
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
+off64_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off64_t offset, int whence);
+int tracecmd_compress_proto_get_name(struct tracecmd_compression *compress,
+				     const char **name, const char **version);
+bool tracecmd_compress_is_supported(const char *name, const char *version);
+int tracecmd_compress_protos_get(char ***names, char ***versions);
+int tracecmd_compress_proto_register(const char *name, const char *version, int weight,
+				     int (*compress)(const char *in, unsigned int in_bytes,
+						     char *out, unsigned int *out_bytes),
+				     int (*uncompress)(const char *in, unsigned int in_bytes,
+						       char *out, unsigned int *out_bytes),
+				     unsigned int (*comress_size)(unsigned int bytes),
+				     bool (*is_supported)(const char *name, const char *version));
+int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
+				unsigned long long *read_size, unsigned long long *write_size);
+int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
+				unsigned long long *read_size, unsigned long long *write_size);
+int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
+			      struct tracecmd_compress_chunk *chunk, char *data);
+int tracecmd_load_chunks_info(struct tracecmd_compression *handle,
+			      struct tracecmd_compress_chunk **chunks_info);
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index b29236dc..bd95a1fa 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -32,6 +32,9 @@ struct data_file_write {
 	unsigned long long	doffset;
 };
 
+void tracecmd_compress_init(void);
+void tracecmd_compress_free(void);
+
 bool check_file_state(unsigned long file_version, int current_state, int new_state);
 bool check_out_state(struct tracecmd_output *handle, int new_state);
 
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
new file mode 100644
index 00000000..b198b8dc
--- /dev/null
+++ b/lib/trace-cmd/trace-compress.c
@@ -0,0 +1,907 @@
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
+	int (*compress_block)(const char *in, unsigned int in_bytes,
+			     char *out, unsigned int *out_bytes);
+	int (*uncompress_block)(const char *in, unsigned int in_bytes,
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
+static inline int buffer_extend(struct tracecmd_compression *handle, unsigned int size)
+{
+	int extend;
+	char *buf;
+
+	if (size <= handle->capacity)
+		return 0;
+
+	extend = ((size - handle->capacity) / BUFSIZ + 1) * BUFSIZ;
+	buf = realloc(handle->buffer, handle->capacity + extend);
+	if (!buf)
+		return -1;
+	handle->buffer = buf;
+	handle->capacity += extend;
+
+	return 0;
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
+off64_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off64_t offset, int whence)
+{
+	unsigned long p;
+
+	if (!handle || !handle->buffer)
+		return (off64_t)-1;
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
+		return (off64_t)-1;
+	}
+
+	if (buffer_extend(handle, p))
+		return (off64_t)-1;
+
+	handle->pointer = p;
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
+	if (!handle)
+		return -1;
+
+	if (buffer_extend(handle, (handle->pointer + size)))
+		return -1;
+
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
+
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
+				     int (*compress)(const char *in, unsigned int in_bytes,
+						     char *out, unsigned int *out_bytes),
+				     int (*uncompress)(const char *in, unsigned int in_bytes,
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
+
+/**
+ * tracecmd_compress_copy_from - Copy and compress data from a file
+ * @handle: compression handler
+ * @fd: file descriptor to uncompressed data to copy from
+ * @chunk_size: size of one compression chunk
+ * @read_size: in - max bytes to read from @fd, 0 to read till the EOF
+ *	       out - size of the uncompressed data read from @fd
+ * @write_size: return, size of the compressed data written into @handle
+ *
+ * This function reads uncompressed data from given @fd, compresses the data using the @handle
+ * compression context and writes the compressed data into the fd associated with the @handle.
+ * The data is compressed on chunks with given @chunk_size size.
+ * The compressed data is written in the format:
+ *  - 4 bytes, chunks count
+ *  - for each chunk:
+ *    - 4 bytes, size of compressed data in this chunk
+ *    - 4 bytes, uncompressed size of the data in this chunk
+ *    - data, bytes of <size of compressed data in this chunk>
+ *
+ * On success 0 is returned, @read_size and @write_size are updated with the size of
+ * read and written data.
+ */
+int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
+				unsigned long long *read_size, unsigned long long *write_size)
+{
+	unsigned int rchunk = 0;
+	unsigned int chunks = 0;
+	unsigned int wsize = 0;
+	unsigned int rsize = 0;
+	unsigned int rmax = 0;
+	unsigned int csize;
+	unsigned int size;
+	unsigned int all;
+	unsigned int r;
+	off64_t offset;
+	char *buf_from;
+	char *buf_to;
+	int endian4;
+	int ret;
+
+	if (!handle || !handle->proto ||
+	    !handle->proto->compress_block || !handle->proto->compress_size)
+		return 0;
+	if (read_size)
+		rmax = *read_size;
+	csize = handle->proto->compress_size(chunk_size);
+	buf_from = malloc(chunk_size);
+	if (!buf_from)
+		return -1;
+	buf_to = malloc(csize);
+	if (!buf_to)
+		return -1;
+	/* save the initial offset and write 0 chunks */
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	write_fd(handle->fd, &chunks, 4);
+
+	do {
+		all = 0;
+		if (rmax > 0 && (rmax - rsize) < chunk_size)
+			rchunk = (rmax - rsize);
+		else
+			rchunk = chunk_size;
+
+		do {
+			r = read(fd, buf_from + all, rchunk - all);
+			all += r;
+
+			if (r <= 0)
+				break;
+		} while (all != rchunk);
+
+
+		if (r < 0 || (rmax > 0 && rsize >= rmax))
+			break;
+		rsize += all;
+		size = csize;
+		if (all > 0) {
+			ret = handle->proto->compress_block(buf_from, all, buf_to, &size);
+			if (ret < 0) {
+				if (errno == EINTR)
+					continue;
+				break;
+			}
+			/* Write compressed data size */
+			endian4 = tep_read_number(handle->tep, &size, 4);
+			ret = write_fd(handle->fd, &endian4, 4);
+			if (ret != 4)
+				break;
+			/* Write uncompressed data size */
+			endian4 = tep_read_number(handle->tep, &all, 4);
+			ret = write_fd(handle->fd, &endian4, 4);
+			if (ret != 4)
+				break;
+			/* Write the compressed data */
+			ret = write_fd(handle->fd, buf_to, size);
+			if (ret != size)
+				break;
+			/* data + compress header */
+			wsize += (size + 8);
+			chunks++;
+		}
+	} while (all > 0);
+	free(buf_from);
+	free(buf_to);
+	if (all)
+		return -1;
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+	endian4 = tep_read_number(handle->tep, &chunks, 4);
+	/* write chunks count*/
+	write_fd(handle->fd, &chunks, 4);
+	lseek64(handle->fd, offset, SEEK_SET);
+	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
+		return -1;
+	if (read_size)
+		*read_size = rsize;
+	if (write_size)
+		*write_size = wsize;
+	return 0;
+}
+
+/**
+ * tracecmd_load_chunks_info - Read compression chunks information from the file
+ * @handle: compression handler
+ * @chunks_info: return, array with compression chunks information
+ *
+ * This function reads information of all compression chunks in the current compression block from
+ * the file and fills that information in a newly allocated array @chunks_info which is returned.
+ *
+ * On success count of compression chunks is returned. Array of that count is allocated and
+ * returned in @chunks_info. Each entry describes one compression chunk. On error -1 is returned.
+ * In case of success, @chunks_info must be freed by free().
+ */
+int tracecmd_load_chunks_info(struct tracecmd_compression *handle,
+			      struct tracecmd_compress_chunk **chunks_info)
+{
+	struct tracecmd_compress_chunk *chunks = NULL;
+	unsigned long long size = 0;
+	unsigned int count = 0;
+	off64_t offset;
+	int ret = -1;
+	char buf[4];
+	int i;
+
+	if (!handle)
+		return -1;
+
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if (offset == (off64_t)-1)
+		return -1;
+
+	if (read(handle->fd, buf, 4) != 4)
+		return -1;
+	count = tep_read_number(handle->tep, buf, 4);
+	if (!count) {
+		ret = 0;
+		goto out;
+	}
+	chunks = calloc(count, sizeof(struct tracecmd_compress_chunk));
+	if (!chunks)
+		goto out;
+	for (i = 0; i < count; i++) {
+		chunks[i].zoffset = lseek64(handle->fd, 0, SEEK_CUR);
+		if (chunks[i].zoffset == (off_t)-1)
+			goto out;
+		if (read(handle->fd, buf, 4) != 4)
+			goto out;
+		chunks[i].zsize = tep_read_number(handle->tep, buf, 4);
+		chunks[i].offset = size;
+		if (read(handle->fd, buf, 4) != 4)
+			goto out;
+		chunks[i].size = tep_read_number(handle->tep, buf, 4);
+		size += chunks[i].size;
+		if (lseek64(handle->fd, chunks[i].zsize, SEEK_CUR) == (off64_t)-1)
+			goto out;
+	}
+
+	ret = count;
+out:
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off64_t)-1)
+		ret = -1;
+
+	if (ret > 0 && chunks_info)
+		*chunks_info = chunks;
+	else
+		free(chunks);
+
+	return ret;
+}
+
+/**
+ * tracecmd_uncompress_chunk - Uncompress given compression chunk.
+ * @handle: compression handler
+ * @chunk: chunk, that will be uncompressed in @data
+ * @data: Preallocated memory for uncompressed data. Must have enough space to hold
+ * the uncompressed data
+ *
+ * This function uncompresses the chunk described by @chunk and stores the uncompressed data in
+ * the preallocated memory @data.
+ *
+ * On success 0 is returned and the uncompressed data is stored in @data. On error -1 is returned.
+ */
+int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
+			      struct tracecmd_compress_chunk *chunk, char *data)
+{
+	char *bytes_in = NULL;
+	unsigned int size;
+	int ret = -1;
+
+	if (!handle || !handle->proto || !handle->proto->uncompress_block || !chunk || !data)
+		return -1;
+
+	if (lseek64(handle->fd, chunk->zoffset + 8, SEEK_SET) == (off_t)-1)
+		return -1;
+	bytes_in = malloc(chunk->zsize);
+	if (!bytes_in)
+		return -1;
+	if (read_fd(handle->fd, bytes_in, chunk->zsize) < 0)
+		goto out;
+	size = chunk->size;
+	if (handle->proto->uncompress_block(bytes_in, chunk->zsize, data, &size))
+		goto out;
+	ret = 0;
+out:
+	free(bytes_in);
+	return ret;
+}
+
+/**
+ * tracecmd_uncompress_copy_to - Uncompress data and copy to a file
+ * @handle: compression handler
+ * @fd: file descriptor to uncompressed data to copy into
+ * @read_size: return, size of the compressed data read from @handle
+ * @write_size: return, size of the uncompressed data written into @fd
+ *
+ * This function reads compressed data from the fd, associated with @handle, uncompresses it
+ * using the @handle compression context and writes the uncompressed data into the fd.
+ * The compressed data must be in the format:
+ *  - 4 bytes, chunks count
+ *  - for each chunk:
+ *    - 4 bytes, size of compressed data in this chunk
+ *    - 4 bytes, uncompressed size of the data in this chunk
+ *    - data, bytes of <size of compressed data in this chunk>
+ *
+ * On success 0 is returned, @read_size and @write_size are updated with the size of
+ * read and written data.
+ */
+int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
+				unsigned long long *read_size, unsigned long long *write_size)
+{
+	unsigned int s_uncompressed;
+	unsigned int s_compressed;
+	unsigned int rsize = 0;
+	unsigned int wsize = 0;
+	char *bytes_out = NULL;
+	char *bytes_in = NULL;
+	int size_out = 0;
+	int size_in = 0;
+	int chunks;
+	char buf[4];
+	char *tmp;
+	int ret;
+
+	if (!handle || !handle->proto || !handle->proto->uncompress_block)
+		return -1;
+
+	if (read(handle->fd, buf, 4) != 4)
+		return -1;
+	chunks = tep_read_number(handle->tep, buf, 4);
+	rsize += 4;
+	while (chunks) {
+		if (read(handle->fd, buf, 4) != 4)
+			break;
+		s_compressed = tep_read_number(handle->tep, buf, 4);
+		rsize += 4;
+		if (read(handle->fd, buf, 4) != 4)
+			break;
+		s_uncompressed = tep_read_number(handle->tep, buf, 4);
+		rsize += 4;
+		if (!bytes_in || size_in < s_compressed) {
+			tmp = realloc(bytes_in, s_compressed);
+			if (!tmp)
+				break;
+			bytes_in = tmp;
+			size_in = s_compressed;
+		}
+
+		if (!bytes_out || size_out < s_uncompressed) {
+			tmp = realloc(bytes_out, s_uncompressed);
+			if (!tmp)
+				break;
+			bytes_out = tmp;
+			size_out = s_uncompressed;
+		}
+
+		if (read_fd(handle->fd, bytes_in, s_compressed) < 0)
+			break;
+		rsize += s_compressed;
+		ret = handle->proto->uncompress_block(bytes_in, s_compressed,
+						      bytes_out, &s_uncompressed);
+		if (ret)
+			break;
+		write_fd(fd, bytes_out, s_uncompressed);
+		wsize += s_uncompressed;
+		chunks--;
+	}
+	free(bytes_in);
+	free(bytes_out);
+	if (chunks)
+		return -1;
+	if (read_size)
+		*read_size = rsize;
+	if (write_size)
+		*write_size = wsize;
+	return 0;
+}
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index d28b6ec2..97db6ed9 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -625,6 +625,16 @@ bool tracecmd_is_version_supported(unsigned int version)
 	return false;
 }
 
+static void __attribute__ ((constructor)) tracecmd_lib_init(void)
+{
+	tracecmd_compress_init();
+}
+
+static void __attribute__((destructor)) tracecmd_lib_free(void)
+{
+	tracecmd_compress_free();
+}
+
 __hidden bool check_file_state(unsigned long file_version, int current_state, int new_state)
 {
 	switch (new_state) {
-- 
2.31.1

