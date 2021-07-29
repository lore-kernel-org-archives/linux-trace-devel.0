Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696EDC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 21:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C34760EC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 21:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhG2VCS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 17:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhG2VCS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 17:02:18 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324FF60EC0;
        Thu, 29 Jul 2021 21:02:14 +0000 (UTC)
Date:   Thu, 29 Jul 2021 17:02:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 08/87] trace-cmd library: Add support for compression
 algorithms
Message-ID: <20210729170207.47395ea8@oasis.local.home>
In-Reply-To: <20210729050959.12263-9-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:08:40 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added infrastructure to trace-cmd library for compression. Introduced
> various new APIs to work with this new functionality:
>  struct tracecmd_compression
>  tracecmd_compress_init()
>  tracecmd_compress_free()
>  tracecmd_compress_alloc()
>  tracecmd_compress_destroy()
>  tracecmd_compress_block()
>  tracecmd_uncompress_block()
>  tracecmd_compress_reset()
>  tracecmd_compress_read()
>  tracecmd_compress_pread()
>  tracecmd_compress_write()
>  tracecmd_compress_lseek()
>  tracecmd_compress_proto_get_name()
>  tracecmd_compress_is_supported()
>  tracecmd_compress_protos_get()
>  tracecmd_compress_proto_register()
>  tracecmd_compress_copy_from()
>  tracecmd_uncompress_copy_to()
>  tracecmd_uncompress_chunk()
>  tracecmd_load_chunks_info()

Patch 6 should be folded into this patch.

> 
> The compression algorithms are not part of this patch.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/Makefile                        |   1 +
>  .../include/private/trace-cmd-private.h       |  39 +
>  lib/trace-cmd/include/trace-cmd-local.h       |   3 +
>  lib/trace-cmd/trace-compress.c                | 910 ++++++++++++++++++
>  lib/trace-cmd/trace-util.c                    |   4 +-
>  5 files changed, 955 insertions(+), 2 deletions(-)
>  create mode 100644 lib/trace-cmd/trace-compress.c
> 
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index 17600318..bab4322d 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -25,6 +25,7 @@ ifeq ($(VSOCK_DEFINED), 1)
>  OBJS += trace-timesync-ptp.o
>  OBJS += trace-timesync-kvm.o
>  endif
> +OBJS += trace-compress.o
>  
>  # Additional util objects
>  OBJS += trace-blk-hack.o
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index 68715580..72729c57 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -468,6 +468,45 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
>  int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
>  				    struct tracecmd_time_sync *tsync);
>  
> +/* --- Compression --- */
> +struct tracecmd_compress_chunk {
> +	unsigned int		size;
> +	unsigned int		zsize;
> +	unsigned long long	zoffset;
> +	unsigned long long	offset;

I wonder if the above type should be "off64_t" as that is the official
type returned by lseek64().

> +};
> +struct tracecmd_compression;
> +struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const char *version,
> +						     int fd, struct tep_handle *tep,
> +						     struct tracecmd_msg_handle *msg_handle);
> +void tracecmd_compress_destroy(struct tracecmd_compression *handle);
> +int tracecmd_compress_block(struct tracecmd_compression *handle);
> +int tracecmd_uncompress_block(struct tracecmd_compression *handle);
> +void tracecmd_compress_reset(struct tracecmd_compression *handle);
> +int tracecmd_compress_read(struct tracecmd_compression *handle, char *dst, int len);
> +int tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, int len, off_t offset);
> +int tracecmd_compress_write(struct tracecmd_compression *handle,
> +			    const void *data, unsigned long long size);
> +off64_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off64_t offset, int whence);
> +int tracecmd_compress_proto_get_name(struct tracecmd_compression *compress,
> +				     const char **name, const char **version);
> +bool tracecmd_compress_is_supported(const char *name, const char *version);
> +int tracecmd_compress_protos_get(char ***names, char ***versions);
> +int tracecmd_compress_proto_register(const char *name, const char *version, int weight,
> +				     int (*compress)(char *in, unsigned int in_bytes,
> +						     char *out, unsigned int *out_bytes),
> +				     int (*uncompress)(char *in, unsigned int in_bytes,
> +						       char *out, unsigned int *out_bytes),
> +				     unsigned int (*comress_size)(unsigned int bytes),
> +				     bool (*is_supported)(const char *name, const char *version));
> +int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
> +				unsigned long long *read_size, unsigned long long *write_size);
> +int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
> +				unsigned long long *read_size, unsigned long long *write_size);
> +int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
> +			      struct tracecmd_compress_chunk *chunk, char *data);
> +int tracecmd_load_chunks_info(struct tracecmd_compression *handle,
> +			      struct tracecmd_compress_chunk **chunks_info);
>  /* --- Plugin handling --- */
>  extern struct tep_plugin_option trace_ftrace_options[];
>  
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index 7691cc05..2a622003 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -31,6 +31,9 @@ void tracecmd_info(const char *fmt, ...);
>  #endif
>  #endif
>  
> +void tracecmd_compress_init(void);
> +void tracecmd_compress_free(void);
> +
>  off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
>  
>  #endif /* _TRACE_CMD_LOCAL_H */
> diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
> new file mode 100644
> index 00000000..5572acd6
> --- /dev/null
> +++ b/lib/trace-cmd/trace-compress.c
> @@ -0,0 +1,910 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2021, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdlib.h>
> +#include <sys/time.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <unistd.h>
> +
> +#include "trace-cmd-private.h"
> +#include "trace-cmd-local.h"
> +
> +struct compress_proto {
> +	struct compress_proto *next;
> +	char *proto_name;
> +	char *proto_version;
> +	int weight;
> +
> +	int (*compress_block)(char *in, unsigned int in_bytes,
> +			     char *out, unsigned int *out_bytes);
> +	int (*uncompress_block)(char *in, unsigned int in_bytes,
> +				char *out, unsigned int *out_bytes);

Are both char * expected to be modified? That is, can we change
"char *in" to "const char *in"?

> +	unsigned int (*compress_size)(unsigned int bytes);
> +	bool (*is_supported)(const char *name, const char *version);
> +};
> +
> +static struct compress_proto *proto_list;
> +
> +struct tracecmd_compression {
> +	int				fd;
> +	unsigned int			capacity;
> +	unsigned long			pointer;
> +	char				*buffer;
> +	struct compress_proto		*proto;
> +	struct tep_handle		*tep;
> +	struct tracecmd_msg_handle	*msg_handle;
> +};
> +
> +static int read_fd(int fd, char *dst, int len)
> +{
> +	size_t size = 0;
> +	int r;
> +
> +	do {
> +		r = read(fd, dst+size, len);
> +		if (r > 0) {
> +			size += r;
> +			len -= r;
> +		} else
> +			break;
> +	} while (r > 0);
> +
> +	if (len)
> +		return -1;
> +	return size;
> +}
> +
> +static long long write_fd(int fd, const void *data, size_t size)
> +{
> +	long long tot = 0;
> +	long long w;
> +
> +	do {
> +		w = write(fd, data + tot, size - tot);
> +		tot += w;
> +
> +		if (!w)
> +			break;
> +		if (w < 0)
> +			return w;
> +	} while (tot != size);
> +
> +	return tot;
> +}
> +
> +static long long do_write(struct tracecmd_compression *handle,
> +			  const void *data, unsigned long long size)
> +{
> +	int ret;
> +
> +	if (handle->msg_handle) {
> +		ret = tracecmd_msg_data_send(handle->msg_handle, data, size);
> +		if (ret)
> +			return -1;
> +		return size;
> +	}
> +	return write_fd(handle->fd, data, size);
> +}
> +
> +/**
> + * tracecmd_compress_lseek - Move the read/write pointer into the compression buffer
> + * @handle: compression handler
> + * @offset: number of bytes to move the pointer, can be negative or positive
> + * @whence: the starting position of the pointer movement,
> + *
> + * Returns the new file pointer on success, or -1 in case of an error.
> + */
> +off64_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off64_t offset, int whence)
> +{
> +	unsigned long p, extend;
> +	char *buf;
> +
> +	if (!handle || !handle->buffer)
> +		return (off64_t)-1;
> +
> +	switch (whence) {
> +	case SEEK_CUR:
> +		p = handle->pointer + offset;
> +		break;
> +	case SEEK_END:
> +		p = handle->capacity + offset;
> +		break;
> +	case SEEK_SET:
> +		p = offset;
> +		break;
> +	default:
> +		return (off64_t)-1;
> +	}
> +
> +	if (p <= handle->capacity) {
> +		handle->pointer = p;
> +	} else {
> +		extend = p - handle->capacity;
> +		extend = extend < BUFSIZ ? BUFSIZ : extend;

I wonder if we should always keep the buffer a multiple of BUFSIZ. That
is, if extend is just one byte bigger than BUFSIZ, then we are going to
immediately extend again at the next write.

Instead, have:

		extend = ((extend / BUFSIZ + 1) * BUFSIZ;

The above '/' is a integer divide, that rounds down.

	(extend / BUFSIZ) will return the number of BUFSIZ that fit in
	extend. Then we add 1 (as we want one more than is currently needed.
	Multiply that number by BUFSIZ, and now we have a size that is
	a multiple of BUFSIZ that can fully fit the extend.

This should help reduce the number of realloc()s that are required.

> +		buf = realloc(handle->buffer, handle->capacity + extend);
> +		if (!buf)
> +			return (off64_t)-1;
> +		handle->buffer = buf;
> +		handle->capacity += extend;
> +		handle->pointer = p;
> +	}
> +
> +	return p;
> +}
> +
> +static int compress_read(struct tracecmd_compression *handle, char *dst, int len)
> +{
> +	int s;
> +
> +	if (handle->pointer + len > handle->capacity)
> +		s = handle->capacity - handle->pointer;
> +	else
> +		s = len;
> +	memcpy(dst, handle->buffer + handle->pointer, s);
> +
> +	return s;
> +}
> +
> +/**
> + * tracecmd_compress_pread - pread() on compression buffer
> + * @handle: compression handler
> + * @dst: return, store the read data
> + * @len: length of data to be read
> + * @offset: offset in the buffer of data to be read
> + *
> + * Read a @len of data from the compression buffer at given @offset,
> + * without updating the buffer pointer.
> + *
> + * On success returns the number of bytes read, or -1 on failure.
> + */
> +int tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, int len, off_t offset)
> +{
> +	int ret;
> +
> +	if (!handle || !handle->buffer || offset > handle->capacity)
> +		return -1;
> +
> +	ret = tracecmd_compress_lseek(handle, offset, SEEK_SET);
> +	if (ret < 0)
> +		return ret;
> +	return compress_read(handle, dst, len);
> +}
> +
> +/**
> + * tracecmd_compress_read - read() from compression buffer
> + * @handle: compression handler
> + * @dst: return, store the read data
> + * @len: length of data to be read
> + *
> + * Read a @len of data from the compression buffer
> + *
> + * On success returns the number of bytes read, or -1 on failure.
> + */
> +int tracecmd_compress_read(struct tracecmd_compression *handle, char *dst, int len)
> +{
> +	int ret;
> +
> +	if (!handle || !handle->buffer)
> +		return -1;
> +
> +	ret = compress_read(handle, dst, len);
> +	if (ret > 0)
> +		handle->pointer += ret;
> +
> +	return ret;
> +}
> +
> +/**
> + * tracecmd_compress_reset - Reset the compression buffer
> + * @handle: compression handler
> + *
> + * Reset the compression buffer, any data currently in the buffer will be destroyed.
> + *
> + */
> +void tracecmd_compress_reset(struct tracecmd_compression *handle)
> +{
> +	if (!handle)
> +		return;
> +
> +	free(handle->buffer);
> +	handle->buffer = NULL;
> +	handle->pointer = 0;
> +	handle->capacity = 0;
> +}
> +
> +/**
> + * tracecmd_uncompress_block - uncompress a memory block
> + * @handle: compression handler
> + *
> + * Read compressed memory block from the file and uncompress it into internal buffer.
> + * The tracecmd_compress_read() can be used to read the uncompressed data from the buffer
> + *
> + * Returns 0 on success, or -1 in case of an error.
> + */
> +int tracecmd_uncompress_block(struct tracecmd_compression *handle)
> +{
> +	unsigned int s_uncompressed;
> +	unsigned int s_compressed;
> +	char *bytes = NULL;
> +	char buf[4];
> +	int ret;
> +
> +	if (!handle || !handle->proto || !handle->proto->uncompress_block)
> +		return -1;
> +	tracecmd_compress_reset(handle);
> +
> +	if (read(handle->fd, buf, 4) != 4)
> +		return -1;
> +	s_compressed = tep_read_number(handle->tep, buf, 4);
> +	if (read(handle->fd, buf, 4) != 4)
> +		return -1;
> +	s_uncompressed = tep_read_number(handle->tep, buf, 4);
> +
> +	handle->buffer = malloc(s_uncompressed);
> +	if (!handle->buffer)
> +		return -1;
> +	bytes = malloc(s_compressed);
> +	if (!bytes)
> +		goto error;
> +
> +	if (read_fd(handle->fd, bytes, s_compressed) < 0)
> +		goto error;
> +	ret = handle->proto->uncompress_block(bytes, s_compressed,
> +					      handle->buffer, &s_uncompressed);
> +	if (ret)
> +		goto error;
> +	free(bytes);
> +	handle->pointer = 0;
> +	handle->capacity = s_uncompressed;
> +	return 0;
> +error:
> +	tracecmd_compress_reset(handle);
> +	free(bytes);
> +	return -1;
> +}
> +
> +/**
> + * tracecmd_compress_block - compress a memory block
> + * @handle: compression handler
> + *
> + * Compress the content of the internal memory buffer and write the compressed data in the file
> + * The tracecmd_compress_write() can be used to write data into the internal memory buffer, before
> + * calling this API.
> + *
> + * Returns 0 on success, or -1 in case of an error.
> + */
> +int tracecmd_compress_block(struct tracecmd_compression *handle)
> +{
> +	unsigned int size;
> +	char *buf;
> +	int endian4;
> +	int ret;
> +
> +	if (!handle || !handle->proto ||
> +	    !handle->proto->compress_size || !handle->proto->compress_block)
> +		return -1;
> +
> +	size = handle->proto->compress_size(handle->pointer);
> +	buf = malloc(size);
> +	if (!buf)
> +		return -1;
> +	ret = handle->proto->compress_block(handle->buffer, handle->pointer, buf, &size);
> +	if (ret < 0)
> +		goto out;
> +	/* Write compressed data size */
> +	endian4 = tep_read_number(handle->tep, &size, 4);
> +	ret = do_write(handle, &endian4, 4);
> +	if (ret != 4)
> +		goto out;
> +	/* Write uncompressed data size */
> +	endian4 = tep_read_number(handle->tep, &handle->pointer, 4);
> +	ret = do_write(handle, &endian4, 4);
> +	if (ret != 4)
> +		goto out;
> +	/* Write compressed data */
> +	ret = do_write(handle, buf, size);
> +	ret = ((ret == size) ? 0 : -1);
> +out:
> +	tracecmd_compress_reset(handle);
> +	free(buf);
> +	return ret;
> +}
> +
> +/**
> + * tracecmd_compress_write - write() to compression buffer
> + * @handle: compression handler
> + * @data: data to be written
> + * @size: size of @data
> + *
> + * Write @data of @size in the compression buffer
> + *
> + * Returns 0 on success, or -1 on failure.
> + */
> +int tracecmd_compress_write(struct tracecmd_compression *handle,
> +			    const void *data, unsigned long long size)
> +{
> +	char *buf;
> +	int extend;
> +
> +	if (!handle)
> +		return -1;
> +
> +	if (handle->capacity < handle->pointer + size) {
> +		extend = (handle->pointer + size) - handle->capacity;
> +		extend = extend < BUFSIZ ? BUFSIZ : extend;
> +		buf = realloc(handle->buffer, handle->capacity + extend);
> +		if (!buf)
> +			return -1;

Ug, you have the same allocation logic again. Please put this into a
helper function. And then, if you make a change into how it is updated,
you only need to do it in one place.

> +		handle->buffer = buf;
> +		handle->capacity += extend;
> +	}
> +	memcpy(&handle->buffer[handle->pointer], data, size);
> +	handle->pointer += size;
> +	return 0;
> +}
> +
> +/**
> + * tracecmd_compress_init - initialize the library with available compression algorithms
> + */
> +void tracecmd_compress_init(void)
> +{
> +	struct timeval time;
> +
> +	gettimeofday(&time, NULL);
> +	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
> +
> +#ifdef HAVE_ZLIB
> +	tracecmd_zlib_init();
> +#endif

The above looks like it belongs in the introduction of the zlib
compression patch.

> +}
> +
> +static struct compress_proto *compress_proto_select(void)
> +{
> +	struct compress_proto *proto = proto_list;
> +	struct compress_proto *selected = NULL;
> +
> +	while (proto) {
> +		if (!selected || selected->weight > proto->weight)
> +			selected = proto;
> +		proto = proto->next;
> +	}
> +
> +	return selected;
> +}
> +


> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 0f49a21a..4e1b8427 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -627,10 +627,10 @@ bool tracecmd_is_version_supported(unsigned int version)
>  
>  static void __attribute__ ((constructor)) tracecmd_lib_init(void)
>  {
> -
> +	tracecmd_compress_init();
>  }
>  
>  static void __attribute__((destructor)) tracecmd_lib_free(void)
>  {
> -
> +	tracecmd_compress_free();
>  }

As I said earlier. This patch should be the one that introduces these
handlers.

-- Steve
