Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6466DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiAOQEt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiAOQEs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:04:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4724DC061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 08:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAD5960DFD
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 16:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF897C36AE7;
        Sat, 15 Jan 2022 16:04:46 +0000 (UTC)
Date:   Sat, 15 Jan 2022 11:04:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 17/25] trace-cmd library: Read strings sections on
 file load
Message-ID: <20220115110445.6ea63c4a@gandalf.local.home>
In-Reply-To: <20211210105448.97850-18-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-18-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:40 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Internal strings database is added to trace input handle, containing all
> metadata strings from trace file. When a trace file is opened, all
> strings sections are located and the internal strings database is
> initialised.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/include/trace-cmd-local.h |  1 +
>  lib/trace-cmd/trace-input.c             | 64 +++++++++++++++++++++++++
>  lib/trace-cmd/trace-output.c            |  1 +
>  3 files changed, 66 insertions(+)
> 
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index 4a0a691c..ac7e7f17 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -53,5 +53,6 @@ struct cpu_data_source {
>  int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
>  		       struct cpu_data_source *data, const char *buff_name);
>  off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
> +unsigned int get_meta_strings_size(struct tracecmd_input *handle);
>  
>  #endif /* _TRACE_CMD_LOCAL_H */
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 9027729e..6cc8ee90 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -147,6 +147,9 @@ struct tracecmd_input {
>  	long long		ts_offset;
>  	struct tsc2nsec		tsc_calc;
>  
> +	unsigned int		strings_size;	/* size of the metadata strings */
> +	char			*strings;	/* metadata strings */
> +
>  	struct host_trace_info	host;
>  	double			ts2secs;
>  	char *			cpustats;
> @@ -984,6 +987,14 @@ static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_sta
>  
>  static int handle_options(struct tracecmd_input *handle);
>  
> +static const char *get_metadata_string(struct tracecmd_input *handle, int offset)
> +{
> +	if (!handle || !handle->strings || offset < 0 || handle->strings_size >= offset)
> +		return NULL;
> +
> +	return handle->strings + offset;
> +}
> +
>  static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
>  			       unsigned short *flags, unsigned long long *size, const char **description)
>  {
> @@ -1007,6 +1018,8 @@ static int read_section_header(struct tracecmd_input *handle, unsigned short *id
>  		*flags = fl;
>  	if (size)
>  		*size = sz;
> +	if (description)
> +		*description = get_metadata_string(handle, desc);
>  
>  	return 0;
>  }
> @@ -2839,6 +2852,11 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
>  	return lib;
>  }
>  
> +__hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
> +{
> +	return handle->strings_size;
> +}
> +
>  static int handle_options(struct tracecmd_input *handle)
>  {
>  	long long offset;
> @@ -3472,6 +3490,50 @@ struct hook_list *tracecmd_hooks(struct tracecmd_input *handle)
>  	return handle->hooks;
>  }
>  
> +static int init_metadata_strings(struct tracecmd_input *handle, int size)
> +{
> +	char *tmp;
> +
> +	tmp = realloc(handle->strings, handle->strings_size + size);

Hmm, I don't remember in our conversations. Did we say we would have more
than one string section? Or allow it to be broken up? How do offsets work
in such cases?

I was thinking that we could simply mmap the string section, but that won't
work if there's more than one.

-- Steve


> +	if (!tmp)
> +		return -1;
> +
> +	handle->strings = tmp;
> +	if (do_read_check(handle, handle->strings + handle->strings_size, size))
> +		return -1;
> +
> +	handle->strings_size += size;
> +
> +	return 0;
> +}
> +
> +static int read_metadata_strings(struct tracecmd_input *handle)
> +{
> +	unsigned short flags;
> +	int found = 0;
> +	unsigned short id;
> +	unsigned long long size;
> +	off64_t offset;
> +
> +	offset = lseek64(handle->fd, 0, SEEK_CUR);
> +	do {
> +		if (read_section_header(handle, &id, &flags, &size, NULL))
> +			break;
> +		if (id == TRACECMD_OPTION_STRINGS) {
> +			found++;
> +			init_metadata_strings(handle, size);
> +		} else {
> +			if (lseek64(handle->fd, size, SEEK_CUR) == (off_t)-1)
> +				break;
> +		}
> +	} while (1);
> +
> +	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
> +		return -1;
> +
> +	return found ? 0 : -1;
> +}
> +
>  /**
>   * tracecmd_alloc_fd - create a tracecmd_input handle from a file descriptor
>   * @fd: the file descriptor for the trace.dat file
> @@ -3568,6 +3630,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
>  			tracecmd_warning("Filed to read the offset of the first option section");
>  			goto failed_read;
>  		}
> +		read_metadata_strings(handle);
>  	}
>  
>  	handle->file_state = TRACECMD_FILE_INIT;
> @@ -3740,6 +3803,7 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	free(handle->cpu_data);
>  	free(handle->uname);
>  	free(handle->trace_clock);
> +	free(handle->strings);
>  	free(handle->version);
>  	close(handle->fd);
>  
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 47227728..08f74c87 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -2239,6 +2239,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
>  	handle->page_size = tracecmd_page_size(ihandle);
>  	handle->file_version = tracecmd_get_in_file_version(ihandle);
>  	handle->options_start = tracecmd_get_options_offset(ihandle);
> +	handle->strings_offs = get_meta_strings_size(ihandle);
>  	list_head_init(&handle->options);
>  	list_head_init(&handle->buffers);
>  

