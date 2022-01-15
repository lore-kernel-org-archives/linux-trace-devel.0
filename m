Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F59DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiAOQKW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiAOQKW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3507EC061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 08:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EE43B8092A
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 16:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9CBC36AE3;
        Sat, 15 Jan 2022 16:10:18 +0000 (UTC)
Date:   Sat, 15 Jan 2022 11:10:17 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 18/25] trace-cmd library: Read extended BUFFER option
Message-ID: <20220115111017.5b16bcb2@gandalf.local.home>
In-Reply-To: <20211210105448.97850-19-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-19-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:41 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

The "space police" are back!

> The BUFFER option is extended in trace file version 7. It holds CPU
> metadata related to the recorded CPU traces. Also, there is a new
> BUFFER_TEXT option for describing the latency trace data. A new logic
> is implemented for these new options.

space

> In trace file version 7, the top buffer is saved as other buffers in the
> file, no special treatment. But saving the top buffer in the list of
> buffers in the input handler causes problems. It breaks the legacy logic
> of trace-cmd library users, which have special logic for trace buffers
> processing. That's why "top_buffer" member is added in the input handler
> structure, to hold the top buffer.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 139 +++++++++++++++++++++++++++++++-----
>  1 file changed, 122 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 6cc8ee90..5625e367 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -74,9 +74,19 @@ struct cpu_data {
>  	int			pipe_fd;
>  };
>  
> +struct cpu_file_data {
> +	int			cpu;
> +	unsigned long long	offset;
> +	unsigned long long	size;
> +};
> +
>  struct input_buffer_instance {
>  	char			*name;
>  	size_t			offset;
> +	char			*clock;
> +	bool			latency;
> +	int			cpus;
> +	struct cpu_file_data	*cpu_data;
>  };
>  
>  struct ts_offset_sample {
> @@ -156,6 +166,7 @@ struct tracecmd_input {
>  	char *			uname;
>  	char *			version;
>  	char *			trace_clock;
> +	struct input_buffer_instance	top_buffer;
>  	struct input_buffer_instance	*buffers;
>  	int			parsing_failures;
>  	struct guest_trace_info	*guest;
> @@ -2857,13 +2868,109 @@ __hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
>  	return handle->strings_size;
>  }
>  
> +static inline int save_read_number(struct tep_handle *tep, char *data, int *data_size,
> +				   int *read_pos, int bytes, unsigned long long *num)
> +{
> +	if (bytes > *data_size)
> +		return -1;

space

> +	*num = tep_read_number(tep, (data + *read_pos), bytes);
> +	*read_pos += bytes;
> +	*data_size -= bytes;
> +	return 0;
> +}
> +
> +static inline char *save_read_string(char *data, int *data_size, int *read_pos)
> +{
> +	char *str;
> +
> +	if (*data_size < 1)
> +		return NULL;

space

> +	str = strdup(data + *read_pos);
> +	if (!str)
> +		return NULL;

space

> +	*data_size -= (strlen(str) + 1);
> +	if (*data_size < 0) {
> +		free(str);
> +		return NULL;
> +	}

space

> +	*read_pos += (strlen(str) + 1);
> +
> +	return str;
> +}
> +
> +static int handle_buffer_option(struct tracecmd_input *handle,
> +				unsigned short id, char *data, int size)
> +{
> +	struct input_buffer_instance *buff;
> +	unsigned long long tmp;
> +	int rsize = 0;
> +	char *name;
> +	int i;
> +
> +	if (save_read_number(handle->pevent, data, &size, &rsize, 8, &tmp))
> +		return -1;

space

> +	name = save_read_string(data, &size, &rsize);
> +	if (!name)
> +		return -1;
> +
> +	if (*name == '\0') {
> +		/* top buffer */
> +		buff = &handle->top_buffer;
> +	} else {
> +		buff = realloc(handle->buffers, sizeof(*handle->buffers) * (handle->nr_buffers + 1));
> +		if (!buff) {
> +			free(name);
> +			return -1;
> +		}
> +		handle->buffers = buff;
> +		handle->nr_buffers++;
> +
> +		buff = &handle->buffers[handle->nr_buffers - 1];
> +	}
> +	memset(buff, 0, sizeof(struct input_buffer_instance));
> +	buff->name = name;
> +	buff->offset = tmp;

space

> +	if (!HAS_SECTIONS(handle))
> +		return 0;
> +
> +	/* file sections specific data */
> +	buff->clock = save_read_string(data, &size, &rsize);
> +	if (!buff->clock)
> +		return -1;

space

> +	if (*name == '\0' && !handle->trace_clock)
> +		handle->trace_clock = strdup(buff->clock);

space

> +	if (id == TRACECMD_OPTION_BUFFER) {
> +		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
> +			return -1;
> +		buff->cpus = tmp;
> +		if (!buff->cpus)
> +			return 0;
> +		buff->cpu_data = calloc(buff->cpus, sizeof(struct cpu_file_data));
> +		if (!buff->cpu_data)
> +			return -1;
> +		for (i = 0; i < buff->cpus; i++) {
> +			if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
> +				return -1;
> +			buff->cpu_data[i].cpu = tmp;
> +			if (save_read_number(handle->pevent, data,
> +					     &size, &rsize, 8, &buff->cpu_data[i].offset))
> +				return -1;
> +			if (save_read_number(handle->pevent, data,
> +					     &size, &rsize, 8, &buff->cpu_data[i].size))
> +				return -1;
> +		}
> +	} else {
> +		buff->latency = true;
> +	}
> +	return 0;
> +}
> +

-- Steve

>  static int handle_options(struct tracecmd_input *handle)
>  {
>  	long long offset;
>  	unsigned short option;
>  	unsigned int size;
>  	char *cpustats = NULL;
> -	struct input_buffer_instance *buffer;
>  	struct hook_list *hook;
>  	char *buf;
>  	int cpus;
> @@ -2954,21 +3061,10 @@ static int handle_options(struct tracecmd_input *handle)
>  			handle->cpustats = cpustats;
>  			break;
>  		case TRACECMD_OPTION_BUFFER:
> -			/* A buffer instance is saved at the end of the file */
> -			handle->nr_buffers++;
> -			handle->buffers = realloc(handle->buffers,
> -						  sizeof(*handle->buffers) * handle->nr_buffers);
> -			if (!handle->buffers)
> -				return -ENOMEM;
> -			buffer = &handle->buffers[handle->nr_buffers - 1];
> -			buffer->name = strdup(buf + 8);
> -			if (!buffer->name) {
> -				free(handle->buffers);
> -				handle->buffers = NULL;
> -				return -ENOMEM;
> -			}
> -			offset = *(unsigned long long *)buf;
> -			buffer->offset = tep_read_number(handle->pevent, &offset, 8);
> +		case TRACECMD_OPTION_BUFFER_TEXT:
> +			ret = handle_buffer_option(handle, option, buf, size);
> +			if (ret < 0)
> +				return ret;
>  			break;
>  		case TRACECMD_OPTION_TRACECLOCK:
>  			if (!handle->ts2secs)
> @@ -3757,6 +3853,13 @@ void tracecmd_ref(struct tracecmd_input *handle)
>  	handle->ref++;
>  }
>  
> +static inline void free_buffer(struct input_buffer_instance *buf)
> +{
> +	free(buf->name);
> +	free(buf->clock);
> +	free(buf->cpu_data);
> +}
> +
>  /**
>   * tracecmd_close - close and free the trace.dat handle
>   * @handle: input handle for the trace.dat file
> @@ -3813,8 +3916,9 @@ void tracecmd_close(struct tracecmd_input *handle)
>  		free(del_sec);
>  	}
>  
> +	free_buffer(&handle->top_buffer);
>  	for (i = 0; i < handle->nr_buffers; i++)
> -		free(handle->buffers[i].name);
> +		free_buffer(&handle->buffers[i]);
>  	free(handle->buffers);
>  
>  	tracecmd_free_hooks(handle->hooks);
> @@ -4258,6 +4362,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
>  		return NULL;
>  
>  	*new_handle = *handle;
> +	memset(&new_handle->top_buffer, 0, sizeof(new_handle->top_buffer));
>  	new_handle->cpu_data = NULL;
>  	new_handle->nr_buffers = 0;
>  	new_handle->buffers = NULL;

