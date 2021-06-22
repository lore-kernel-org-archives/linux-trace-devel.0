Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7882BC4743C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 02:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54AF46113E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 02:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFVCNB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 22:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhFVCNA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 22:13:00 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C601660FDC;
        Tue, 22 Jun 2021 02:10:45 +0000 (UTC)
Date:   Mon, 21 Jun 2021 22:10:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 18/45] trace-cmd library: Hide the logic for updating
 buffer offset
Message-ID: <20210621221044.558ba166@oasis.local.home>
In-Reply-To: <20210614075029.598048-19-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
        <20210614075029.598048-19-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Jun 2021 10:50:02 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When a trace buffer data are written in the trace file, the buffer
> option in the file metadata is updated with the file offset of the
> tracing data. Hide this logic into the trace-cmd library.
> Added new APIs:
>  tracecmd_add_buffer_description()
>  tracecmd_write_buffers_description()
> Changed APIs:
>  tracecmd_append_buffer_cpu_data()
> Removed APIs:
>  tracecmd_add_buffer_option()

So I was going to add this patch with some other ones from this series,
but I'm holding off just due to the names.

We are not writing a description, we are only adding name and cpus. We
could change that to tracecmd_add_buffer_info() and tracecmd_write_buffer_info() ?
As "info" is just information about the buffer, and name / cpu is that.
But "description" usually means a bit more in depth information.

Even though the write_buffer_info() could be doing more than one
buffer, I think it still sounds best keeping it singular, as it is
writing the buffer_info section.

> 
> This internal refactoring is needed for changes, related to compression
> of the options sections of the trace file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  .../include/private/trace-cmd-private.h       |  8 +-
>  lib/trace-cmd/trace-output.c                  | 84 +++++++++++++++++--
>  tracecmd/trace-record.c                       | 16 ++--
>  3 files changed, 85 insertions(+), 23 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index ee73325c..cbb578ec 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -295,8 +295,8 @@ struct tracecmd_option *
>  tracecmd_add_option_v(struct tracecmd_output *handle,
>  		      unsigned short id, const struct iovec *vector, int count);
>  
> -struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
> -						   const char *name, int cpus);
> +int tracecmd_add_buffer_description(struct tracecmd_output *handle, const char *name, int cpus);
> +int tracecmd_write_buffers_description(struct tracecmd_output *handle);
>  
>  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
>  int tracecmd_write_cmdlines(struct tracecmd_output *handle);
> @@ -312,9 +312,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 7c7d3d76..8f8ca164 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -44,6 +44,14 @@ struct tracecmd_option {
>  	struct list_head list;
>  };
>  
> +struct tracecmd_buffer {
> +	int		cpus;
> +	void		*name;
> +	tsize_t		offset;
> +	struct tracecmd_option *option;
> +	struct list_head list;
> +};

You can add another tab to the above structure to make it look better:

struct tracecmd_buffer {
	int			cpus;
	void			*name;
	tsize_t			offset;
	struct tracecmd_option  *option;
	struct list_head 	list;
};

-- Steve

> +
>  enum {
>  	OUTPUT_FL_SEND_META	= (1 << 0),
>  };
> @@ -63,6 +71,7 @@ struct tracecmd_output {
>  	struct tracecmd_compression *compress;
>  
>  	struct list_head	options;
> +	struct list_head	buffers;
>  	struct tracecmd_msg_handle *msg_handle;
>  	char			*trace_clock;
>  };
> @@ -189,6 +198,7 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle)
>  void tracecmd_output_free(struct tracecmd_output *handle)
>  {
>  	struct tracecmd_option *option;
> +	struct tracecmd_buffer *buffer;
>  
>  	if (!handle)
>  		return;
> @@ -199,6 +209,13 @@ void tracecmd_output_free(struct tracecmd_output *handle)
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
>  	while (!list_empty(&handle->options)) {
>  		option = container_of(handle->options.next,
>  				      struct tracecmd_option, list);
> @@ -1071,6 +1088,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
>  		goto out_free;
>  
>  	list_head_init(&handle->options);
> +	list_head_init(&handle->buffers);
>  
>  	buf[0] = 23;
>  	buf[1] = 8;
> @@ -1369,9 +1387,8 @@ int tracecmd_append_options(struct tracecmd_output *handle)
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
> @@ -1399,6 +1416,53 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
>  	return option;
>  }
>  
> +int tracecmd_add_buffer_description(struct tracecmd_output *handle, const char *name, int cpus)
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
> +int tracecmd_write_buffers_description(struct tracecmd_output *handle)
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
> +	return 0;
> +}
> +
> +static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
> +{
> +	struct tracecmd_buffer *buf;
> +
> +	list_for_each_entry(buf, &handle->buffers, list) {
> +		if (strlen(name) == strlen(buf->name) && !strcmp(name, buf->name)) {
> +			if (handle->file_version >= 7)
> +				return buf->offset;
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
> @@ -1643,18 +1707,23 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  }
>  
>  int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
> -				    struct tracecmd_option *option,
> -				    int cpus, char * const *cpu_data_files)
> +				    const char *name, int cpus, char * const *cpu_data_files)
>  {
> +	tsize_t b_offset;
>  	tsize_t offset;
>  	stsize_t ret;
>  
> +	b_offset = get_buffer_file_offset(handle, name);
> +	if (!b_offset) {
> +		tracecmd_warning("Cannot find description for buffer %s\n", name);
> +		return -1;
> +	}
>  	offset = lseek64(handle->fd, 0, SEEK_CUR);
>  
>  	/* Go to the option data, where will write the offest */
> -	ret = lseek64(handle->fd, option->offset, SEEK_SET);
> +	ret = lseek64(handle->fd, b_offset, SEEK_SET);
>  	if (ret == (off64_t)-1) {
> -		tracecmd_warning("could not seek to %lld\n", option->offset);
> +		tracecmd_warning("could not seek to %lld\n", b_offset);
>  		return -1;
>  	}
>  
> @@ -1713,6 +1782,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
>  	handle->page_size = tracecmd_page_size(ihandle);
>  	handle->file_version = tracecmd_get_in_file_version(ihandle);
>  	list_head_init(&handle->options);
> +	list_head_init(&handle->buffers);
>  
>  	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
>  		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index d3362e5b..eff6f2f0 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4152,7 +4152,6 @@ static void touch_file(const char *file)
>  }
>  
>  static void append_buffer(struct tracecmd_output *handle,
> -			  struct tracecmd_option *buffer_option,
>  			  struct buffer_instance *instance,
>  			  char **temp_files)
>  {
> @@ -4180,7 +4179,7 @@ static void append_buffer(struct tracecmd_output *handle,
>  			touch_file(temp_files[i]);
>  	}
>  
> -	tracecmd_append_buffer_cpu_data(handle, buffer_option,
> +	tracecmd_append_buffer_cpu_data(handle, tracefs_instance_get_name(instance->tracefs),
>  					cpu_count, temp_files);
>  
>  	for (i = 0; i < instance->cpu_count; i++) {
> @@ -4441,7 +4440,6 @@ static void write_guest_file(struct buffer_instance *instance)
>  
>  static void record_data(struct common_record_context *ctx)
>  {
> -	struct tracecmd_option **buffer_options;
>  	struct tracecmd_output *handle;
>  	struct buffer_instance *instance;
>  	bool local = false;
> @@ -4512,9 +4510,6 @@ static void record_data(struct common_record_context *ctx)
>  		}
>  
>  		if (buffers) {
> -			buffer_options = malloc(sizeof(*buffer_options) * buffers);
> -			if (!buffer_options)
> -				die("Failed to allocate buffer options");
>  			i = 0;
>  			for_each_instance(instance) {
>  				int cpus = instance->cpu_count != local_cpu_count ?
> @@ -4522,10 +4517,9 @@ static void record_data(struct common_record_context *ctx)
>  
>  				if (instance->msg_handle)
>  					continue;
> -
> -				buffer_options[i++] = tracecmd_add_buffer_option(handle,
> -										 tracefs_instance_get_name(instance->tracefs),
> -										 cpus);
> +				tracecmd_add_buffer_description(handle,
> +								tracefs_instance_get_name(instance->tracefs),
> +								cpus);
>  				add_buffer_stat(handle, instance);
>  			}
>  		}
> @@ -4560,7 +4554,7 @@ static void record_data(struct common_record_context *ctx)
>  				if (instance->msg_handle)
>  					continue;
>  				print_stat(instance);
> -				append_buffer(handle, buffer_options[i++], instance, temp_files);
> +				append_buffer(handle, instance, temp_files);
>  			}
>  		}
>  

