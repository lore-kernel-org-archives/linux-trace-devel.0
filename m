Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F98C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Oct 2021 00:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE71613CF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Oct 2021 00:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhJEAxO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 20:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbhJEAxN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 20:53:13 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B449E613B5;
        Tue,  5 Oct 2021 00:51:23 +0000 (UTC)
Date:   Mon, 4 Oct 2021 20:51:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 20/21] trace-cmd library: Refactor the logic for
 writing trace data in the file
Message-ID: <20211004205122.6a66a5ce@rorschach.local.home>
In-Reply-To: <20210914131232.3964615-21-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
 <20210914131232.3964615-21-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:31 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When a trace buffer data are written in the trace file, the buffer
> option in the file metadata is updated with the file offset of the
> tracing data. Hide this logic into the trace-cmd library.
> Added new APIs:
>  tracecmd_add_buffer_info()
>  tracecmd_write_buffer_info()
> Changed APIs:
>  tracecmd_append_buffer_cpu_data()
> Removed APIs:
>  tracecmd_add_buffer_option()

I'm thinking this patch can be broken up too.

> 
> Refactored the internal logic of tracecmd_write_cpu_data() API to be
> suitable for upcoming trace file format changes and data compression.
> The size and the offset of the trace data is saved in the file right
> after the data is written. The old logic calculates the size and offset
> in advance, but when the trace data is compressed it is hard to use
> that approach.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  .../include/private/trace-cmd-private.h       |  10 +-
>  lib/trace-cmd/include/trace-cmd-local.h       |  17 +
>  lib/trace-cmd/trace-output.c                  | 307 ++++++++++++------
>  tracecmd/trace-listen.c                       |   2 +-
>  tracecmd/trace-record.c                       |  18 +-
>  5 files changed, 235 insertions(+), 119 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index 167f3804..97cd82f8 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -290,8 +290,8 @@ struct tracecmd_option *
>  tracecmd_add_option_v(struct tracecmd_output *handle,
>  		      unsigned short id, const struct iovec *vector, int count);
>  
> -struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
> -						   const char *name, int cpus);
> +int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus);
> +int tracecmd_write_buffer_info(struct tracecmd_output *handle);
>  
>  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
>  int tracecmd_write_cmdlines(struct tracecmd_output *handle);
> @@ -303,13 +303,11 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
>  				      const char *file);
>  
>  int tracecmd_write_cpu_data(struct tracecmd_output *handle,
> -			    int cpus, char * const *cpu_data_files);
> +			    int cpus, char * const *cpu_data_files, const char *buff_name);
>  int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  			     int cpus, char * const *cpu_data_files);
>  int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
> -				    struct tracecmd_option *option,
> -				    int cpus, char * const *cpu_data_files);
> -
> +				    const char *name, int cpus, char * const *cpu_data_files);
>  struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
>  
>  /* --- Reading the Fly Recorder Trace --- */
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index 7f3b45a8..547ee5c3 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -31,7 +31,24 @@ void tracecmd_info(const char *fmt, ...);
>  #endif
>  #endif
>  
> +struct data_file_write {
> +	unsigned long long	file_size;
> +	unsigned long long	write_size;
> +	unsigned long long	soffset;
> +	unsigned long long	data_offset;
> +	unsigned long long	doffset;

Took me to look later in the code to know what "doffset" and "soffset"
is. Please keep the more verbose name, so that it is known without a
doubt what they are. "data_offset" and "size_offset" are perfectly
fine. Let's not get too cryptic, because that is what prevents people
from helping out.

> +};
> +
>  bool check_file_state(unsigned long file_version, int current_state, int new_state);
>  bool check_out_state(struct tracecmd_output *handle, int new_state);
>  
> +struct cpu_data_source {
> +	int fd;
> +	int size;
> +	off64_t offset;
> +};
> +
> +int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
> +		       struct cpu_data_source *data, const char *buff_name);
> +
>  #endif /* _TRACE_CMD_LOCAL_H */
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 20116d99..c1bfcb66 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -39,6 +39,14 @@ struct tracecmd_option {
>  	struct list_head list;
>  };
>  
> +struct tracecmd_buffer {
> +	int				cpus;
> +	void				*name;
> +	tsize_t				offset;
> +	struct tracecmd_option		*option;
> +	struct list_head		list;
> +};
> +
>  enum {
>  	OUTPUT_FL_SEND_META	= (1 << 0),
>  };
> @@ -59,6 +67,7 @@ struct tracecmd_output {
>  	bool			big_endian;
>  
>  	struct list_head	options;
> +	struct list_head	buffers;
>  	struct tracecmd_msg_handle *msg_handle;
>  	char			*trace_clock;
>  };
> @@ -141,6 +150,7 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle)
>  void tracecmd_output_free(struct tracecmd_output *handle)
>  {
>  	struct tracecmd_option *option;
> +	struct tracecmd_buffer *buffer;
>  
>  	if (!handle)
>  		return;
> @@ -151,6 +161,13 @@ void tracecmd_output_free(struct tracecmd_output *handle)
>  	if (handle->pevent)
>  		tep_unref(handle->pevent);
>  
> +	while (!list_empty(&handle->buffers)) {
> +		buffer = container_of(handle->buffers.next,
> +				      struct tracecmd_buffer, list);
> +		list_del(&buffer->list);
> +		free(buffer->name);
> +		free(buffer);
> +	}

I'd suggest adding a space here, makes it easier to read.

>  	while (!list_empty(&handle->options)) {
>  		option = container_of(handle->options.next,
>  				      struct tracecmd_option, list);
> @@ -912,6 +929,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
>  		handle->big_endian = false;
>  
>  	list_head_init(&handle->options);
> +	list_head_init(&handle->buffers);
>  
>  	handle->file_state = TRACECMD_FILE_ALLOCATED;
>  
> @@ -1324,15 +1342,14 @@ int tracecmd_append_options(struct tracecmd_output *handle)
>  	return 0;
>  }
>  
> -struct tracecmd_option *
> -tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
> -			   int cpus)
> +static struct tracecmd_option *
> +add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
>  {
>  	struct tracecmd_option *option;
>  	char *buf;
>  	int size = 8 + strlen(name) + 1;
>  
> -	buf = malloc(size);
> +	buf = calloc(1, size);
>  	if (!buf) {
>  		tracecmd_warning("Failed to malloc buffer");
>  		return NULL;
> @@ -1354,6 +1371,52 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
>  	return option;
>  }
>  
> +int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus)
> +{
> +	struct tracecmd_buffer *buf;
> +
> +	buf = calloc(1, sizeof(struct tracecmd_buffer));
> +	if (!buf)
> +		return -1;
> +	buf->name = strdup(name);
> +	buf->cpus = cpus;
> +	if (!buf->name) {
> +		free(buf);
> +		return -1;
> +	}
> +	list_add_tail(&buf->list, &handle->buffers);
> +	return 0;
> +}
> +
> +int tracecmd_write_buffer_info(struct tracecmd_output *handle)
> +{
> +	struct tracecmd_option *option;
> +	struct tracecmd_buffer *buf;
> +
> +	list_for_each_entry(buf, &handle->buffers, list) {
> +		option = add_buffer_option(handle, buf->name, buf->cpus);
> +		if (!option)
> +			return -1;
> +		buf->option = option;
> +	}
> +
> +	return 0;
> +}
> +
> +static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
> +{
> +	struct tracecmd_buffer *buf;
> +
> +	list_for_each_entry(buf, &handle->buffers, list) {
> +		if (strlen(name) == strlen(buf->name) && !strcmp(name, buf->name)) {

Why the two strlen()? That actually makes it slower, as it needs to
calculate the string lengths before the compare, which will fail on the
first miss compare. And strcmp() will not match if they are not the same
length.


> +			if (!buf->option)
> +				break;
> +			return buf->option->offset;
> +		}
> +	}
> +	return 0;
> +}
> +
>  int tracecmd_write_cmdlines(struct tracecmd_output *handle)
>  {
>  	int ret;
> @@ -1446,6 +1509,37 @@ out:
>  	return ret;
>  }
>  
> +static int update_buffer_cpu_offset(struct tracecmd_output *handle,
> +				    const char *name, tsize_t offset)
> +{
> +	tsize_t b_offset;
> +	tsize_t current;

Be easier if you added here:

	if (!name)
		name = "";

Then you just pass NULL in the other functions, and don't need to pass
this magical "" value.

> +
> +	b_offset = get_buffer_file_offset(handle, name);
> +	if (!b_offset) {
> +		tracecmd_warning("Cannot find description for buffer %s\n", name);
> +		return -1;
> +	}

Add space here.

> +	current = lseek64(handle->fd, 0, SEEK_CUR);
> +
> +	/* Go to the option data, where will write the offest */
> +	if (lseek64(handle->fd, b_offset, SEEK_SET) == (off64_t)-1) {
> +		tracecmd_warning("could not seek to %lld\n", b_offset);
> +		return -1;
> +	}
> +
> +	if (do_write_check(handle, &offset, 8))
> +		return -1;
> +
> +	/* Go back to end of file */
> +	if (lseek64(handle->fd, current, SEEK_SET) == (off64_t)-1) {
> +		tracecmd_warning("could not seek to %lld\n", offset);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +
>  static char *get_clock(struct tracecmd_output *handle)
>  {
>  	struct tracefs_instance *inst;
> @@ -1465,17 +1559,14 @@ static char *get_clock(struct tracecmd_output *handle)
>  	return handle->trace_clock;
>  }
>  
> -int tracecmd_write_cpu_data(struct tracecmd_output *handle,
> -			    int cpus, char * const *cpu_data_files)
> +__hidden int out_write_cpu_data(struct tracecmd_output *handle,
> +				int cpus, struct cpu_data_source *data, const char *buff_name)
>  {
> -	off64_t *offsets = NULL;
> -	unsigned long long *sizes = NULL;
> -	off64_t offset;
> +	struct data_file_write *data_files = NULL;
> +	tsize_t data_offs, offset;
>  	unsigned long long endian8;
> -	char *clock = NULL;
> -	off64_t check_size;
> -	char *file;
> -	struct stat st;
> +	unsigned long long read_size;
> +	char *clock;
>  	int ret;
>  	int i;
>  
> @@ -1490,97 +1581,133 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
>  		goto out_free;
>  	}
>  
> +	data_offs = lseek64(handle->fd, 0, SEEK_CUR);
>  	if (do_write_check(handle, "flyrecord", 10))
>  		goto out_free;
>  
> -	offsets = malloc(sizeof(*offsets) * cpus);
> -	if (!offsets)
> +	data_files = calloc(cpus, sizeof(struct data_file_write));

I always prefer: data_files = calloc(cpus, sizeof(*data_files));

instead, because, if you accidentally use the wrong structure, or it
changes in the future, it will allocate the wrong size.

> +	if (!data_files)
>  		goto out_free;
> -	sizes = malloc(sizeof(*sizes) * cpus);
> -	if (!sizes)
> -		goto out_free;
> -
> -	offset = lseek64(handle->fd, 0, SEEK_CUR);
> -
> -	/* hold any extra data for data */
> -	offset += cpus * (16);
> -
> -	/*
> -	 * Unfortunately, the trace_clock data was placed after the
> -	 * cpu data, and wasn't accounted for with the offsets.
> -	 * We need to save room for the trace_clock file. This means
> -	 * we need to find the size of it before we define the final
> -	 * offsets.
> -	 */
> -	clock = get_clock(handle);
> -	if (!clock)
> -		goto out_free;
> -	/* Save room for storing the size */
> -	offset += 8;
> -	offset += strlen(clock);
> -	/* 2 bytes for [] around the clock */
> -	offset += 2;
> -
> -	/* Page align offset */
> -	offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
>  
>  	for (i = 0; i < cpus; i++) {
> -		file = cpu_data_files[i];
> -		ret = stat(file, &st);
> -		if (ret < 0) {
> -			tracecmd_warning("can not stat '%s'", file);
> -			goto out_free;
> -		}
> -		offsets[i] = offset;
> -		sizes[i] = st.st_size;
> -		offset += st.st_size;
> -		offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
> -
> -		endian8 = convert_endian_8(handle, offsets[i]);
> +		data_files[i].file_size = data[i].size;
> +		/* Write 0 for trace data offset and size and store offsets of these fields */

The above comment is a bit confusing. Do you mean:

	" Place 0 for the data offset and size, and save the offsets to
	  updated them with the correct data later. " ?

> +		endian8 = 0;
> +		data_files[i].doffset = lseek64(handle->fd, 0, SEEK_CUR);
>  		if (do_write_check(handle, &endian8, 8))
>  			goto out_free;
> -		endian8 = convert_endian_8(handle, sizes[i]);
> +		data_files[i].soffset = lseek64(handle->fd, 0, SEEK_CUR);
>  		if (do_write_check(handle, &endian8, 8))
>  			goto out_free;
>  	}
>  
> -	if (save_clock(handle, clock))
> +	update_buffer_cpu_offset(handle, buff_name, data_offs);
> +	clock = get_clock(handle);
> +	if (clock && save_clock(handle, clock))
>  		goto out_free;
> -

Keep the space. There's too much code tightly together that needs
spacing, to read easier.


>  	for (i = 0; i < cpus; i++) {
> +		data_files[i].data_offset = lseek64(handle->fd, 0, SEEK_CUR);

Space.

> +		/* Page align offset */
> +		data_files[i].data_offset = (data_files[i].data_offset + (handle->page_size - 1)) & ~(handle->page_size - 1);

Either break the above into:
fse
		data_files[i].data_offset += handle->page_size - 1;
		data_files[i].data_offset &= !(handle->page_size - 1);

or add a macro called "ALIGN" (in a header, probably in a separate
patch).

#define ALIGN(val, alignment)   ((val) + ((alignment) - 1) & ~((alignment) - 1))

and then have:

		data_files[i].data_offset = ALIGN(data_files[i].data_offset, handle->page_size);


Add space.

> +		data_files[i].data_offset = lseek64(handle->fd, data_files[i].data_offset, SEEK_SET);

Why not just use "ret" since we are setting it, and the data_offset
shouldn't change.

> +		if (data_files[i].data_offset == (off64_t)-1)
> +			goto out_free;

Space.

>  		if (!tracecmd_get_quiet(handle))
>  			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
> -				i, (unsigned long long) offsets[i]);
> -		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
> -		if (offset == (off64_t)-1) {
> -			tracecmd_warning("could not seek to %lld\n", offsets[i]);
> -			goto out_free;
> +				i, (unsigned long long) data_files[i].data_offset);
                                                       ^
No space between typecast and data.

space (line)

> +		if (data[i].size) {
> +			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
> +				goto out_free;
> +			read_size = copy_file_fd(handle, data[i].fd);
> +			if (read_size != data_files[i].file_size) {
> +				errno = EINVAL;
> +				tracecmd_warning("did not match size of %lld to %lld",
> +						 read_size, data_files[i].file_size);
> +				goto out_free;
> +			}
> +			data_files[i].write_size = read_size;
> +		} else {
> +			data_files[i].write_size = 0;
>  		}
> -		check_size = copy_file(handle, cpu_data_files[i]);
> -		if (check_size != sizes[i]) {
> -			errno = EINVAL;
> -			tracecmd_warning("did not match size of %lld to %lld",
> -					 check_size, sizes[i]);
> +
> +		/* Write the real CPU data offset in the file */
> +		if (lseek64(handle->fd, data_files[i].doffset, SEEK_SET) == (off64_t)-1)
> +			goto out_free;
> +		endian8 = convert_endian_8(handle, data_files[i].data_offset);
> +		if (do_write_check(handle, &endian8, 8))
> +			goto out_free;

space.

> +		/* Write the real CPU data size in the file */
> +		if (lseek64(handle->fd, data_files[i].soffset, SEEK_SET) == (off64_t)-1)
> +			goto out_free;
> +		endian8 = convert_endian_8(handle, data_files[i].write_size);
> +		if (do_write_check(handle, &endian8, 8))
> +			goto out_free;

space.

> +		offset = data_files[i].data_offset + data_files[i].write_size;
> +		if (lseek64(handle->fd, offset, SEEK_SET) == (off64_t)-1)
>  			goto out_free;
> -		}

space.

>  		if (!tracecmd_get_quiet(handle))
>  			fprintf(stderr, "    %llu bytes in size\n",
> -				(unsigned long long)check_size);
> +				(unsigned long long)data_files[i].write_size);
>  	}
>  
> -	free(offsets);
> -	free(sizes);
> +	if (lseek64(handle->fd, 0, SEEK_END) == (off64_t)-1)
> +		goto out_free;

If this failed here, what makes you think it will succeed later? ;-)

Could just move it to after the free(data_files) and return error if
this happened.

>  
> +	free(data_files);
>  	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
>  
>  	return 0;
>  
>   out_free:
> -	free(offsets);
> -	free(sizes);
> +	lseek64(handle->fd, 0, SEEK_END);
> +	free(data_files);
>  	return -1;
>  }
>  
> +int tracecmd_write_cpu_data(struct tracecmd_output *handle,
> +			    int cpus, char * const *cpu_data_files, const char *buff_name)
> +{
> +	struct cpu_data_source *data;
> +	struct stat st;
> +	int size = 0;
> +	int ret;
> +	int i;
> +
> +	data = calloc(cpus, sizeof(struct cpu_data_source));
> +	if (!data)
> +		return -1;

space.

> +	for (i = 0; i < cpus; i++)
> +		data[i].fd = -1;

space.

/* nit */
Although you don't need the above initialization (see below).

> +	for (i = 0; i < cpus; i++) {
> +		ret = stat(cpu_data_files[i], &st);
> +		if (ret < 0) {
> +			tracecmd_warning("can not stat '%s'", cpu_data_files[i]);
> +			break;
> +		}
> +		data[i].fd = open(cpu_data_files[i], O_RDONLY);
> +		if (data[i].fd < 0) {
> +			tracecmd_warning("Can't read '%s'", data[i].fd);
> +			break;
> +		}
> +
> +		data[i].size = st.st_size;
> +		data[i].offset = 0;
> +		size += st.st_size;
> +	}
> +
> +	if (i < cpus)
> +		ret = -1;
> +	else
> +		ret = out_write_cpu_data(handle, cpus, data, buff_name);
> +

No need to initialize if you have:

	for (i--; i >= 0; i--) {

> +	for (i = 0; i < cpus; i++) {
> +		if (data[i].fd >= 0)

You also don't need this check.

> +			close(data[i].fd);
> +	}
> +	free(data);
> +	return ret;
> +}
> +
>  int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  			     int cpus, char * const *cpu_data_files)
>  {
> @@ -1589,41 +1716,20 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  	ret = tracecmd_write_cpus(handle, cpus);
>  	if (ret)
>  		return ret;
> -
> +	ret = tracecmd_write_buffer_info(handle);
> +	if (ret)
> +		return ret;
>  	ret = tracecmd_write_options(handle);
>  	if (ret)
>  		return ret;
>  
> -	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
> +	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files, "");

Should pass NULL instead of "" (as explained above).

>  }
>  
>  int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
> -				    struct tracecmd_option *option,
> -				    int cpus, char * const *cpu_data_files)
> +				    const char *name, int cpus, char * const *cpu_data_files)
>  {
> -	tsize_t offset;
> -	stsize_t ret;
> -
> -	offset = lseek64(handle->fd, 0, SEEK_CUR);
> -
> -	/* Go to the option data, where will write the offest */
> -	ret = lseek64(handle->fd, option->offset, SEEK_SET);
> -	if (ret == (off64_t)-1) {
> -		tracecmd_warning("could not seek to %lld\n", option->offset);
> -		return -1;
> -	}
> -
> -	if (do_write_check(handle, &offset, 8))
> -		return -1;
> -
> -	/* Go back to end of file */
> -	ret = lseek64(handle->fd, offset, SEEK_SET);
> -	if (ret == (off64_t)-1) {
> -		tracecmd_warning("could not seek to %lld\n", offset);
> -		return -1;
> -	}
> -
> -	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
> +	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files, name);
>  }
>  
>  struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
> @@ -1667,6 +1773,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
>  	handle->file_version = tracecmd_get_in_file_version(ihandle);
>  	handle->options_start = tracecmd_get_options_offset(ihandle);
>  	list_head_init(&handle->options);
> +	list_head_init(&handle->buffers);
>  
>  	tracecmd_close(ihandle);
>  
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index 0cb70b7d..d812145b 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -610,7 +610,7 @@ static int put_together_file(int cpus, int ofd, const char *node,
>  		if (ret)
>  			goto out;
>  	}
> -	ret = tracecmd_write_cpu_data(handle, cpus, temp_files);
> +	ret = tracecmd_write_cpu_data(handle, cpus, temp_files, "");

Pass in NULL instead of "".

>  
>  out:
>  	tracecmd_output_close(handle);
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 15e07cf0..78b0f5ec 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4169,7 +4169,6 @@ static void touch_file(const char *file)
>  }
>  
>  static void append_buffer(struct tracecmd_output *handle,
> -			  struct tracecmd_option *buffer_option,
>  			  struct buffer_instance *instance,
>  			  char **temp_files)
>  {
> @@ -4197,7 +4196,7 @@ static void append_buffer(struct tracecmd_output *handle,
>  			touch_file(temp_files[i]);
>  	}
>  
> -	tracecmd_append_buffer_cpu_data(handle, buffer_option,
> +	tracecmd_append_buffer_cpu_data(handle, tracefs_instance_get_name(instance->tracefs),
>  					cpu_count, temp_files);
>  
>  	for (i = 0; i < instance->cpu_count; i++) {
> @@ -4447,7 +4446,7 @@ static void write_guest_file(struct buffer_instance *instance)
>  			die("failed to allocate memory");
>  	}
>  
> -	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files) < 0)
> +	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, "") < 0)

Pass NULL instead of "".

-- Steve


>  		die("failed to write CPU data");
>  	tracecmd_output_close(handle);
>  
> @@ -4482,7 +4481,6 @@ error:
>  
>  static void record_data(struct common_record_context *ctx)
>  {
> -	struct tracecmd_option **buffer_options;
>  	struct tracecmd_output *handle;
>  	struct buffer_instance *instance;
>  	bool local = false;
> @@ -4551,9 +4549,6 @@ static void record_data(struct common_record_context *ctx)
>  		}
>  
>  		if (buffers) {
> -			buffer_options = malloc(sizeof(*buffer_options) * buffers);
> -			if (!buffer_options)
> -				die("Failed to allocate buffer options");
>  			i = 0;
>  			for_each_instance(instance) {
>  				int cpus = instance->cpu_count != local_cpu_count ?
> @@ -4561,10 +4556,9 @@ static void record_data(struct common_record_context *ctx)
>  
>  				if (instance->msg_handle)
>  					continue;
> -
> -				buffer_options[i++] = tracecmd_add_buffer_option(handle,
> -										 tracefs_instance_get_name(instance->tracefs),
> -										 cpus);
> +				tracecmd_add_buffer_info(handle,
> +							tracefs_instance_get_name(instance->tracefs),
> +							cpus);
>  				add_buffer_stat(handle, instance);
>  			}
>  		}
> @@ -4599,7 +4593,7 @@ static void record_data(struct common_record_context *ctx)
>  				if (instance->msg_handle)
>  					continue;
>  				print_stat(instance);
> -				append_buffer(handle, buffer_options[i++], instance, temp_files);
> +				append_buffer(handle, instance, temp_files);
>  			}
>  		}
>  

