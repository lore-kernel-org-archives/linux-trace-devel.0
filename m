Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD22AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbiAOQMY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiAOQMY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:12:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6849C061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 08:12:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63555B808D4
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 16:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0827C36AE7;
        Sat, 15 Jan 2022 16:12:20 +0000 (UTC)
Date:   Sat, 15 Jan 2022 11:12:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 19/25] trace-cmd library: Handle the extended DONE
 option
Message-ID: <20220115111219.2be8707f@gandalf.local.home>
In-Reply-To: <20211210105448.97850-20-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-20-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:42 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

I love my spaces ;-)

> In trace file version 7 the DONE option is extended to store the offset
> in the file to the next options section. This way a list of options
> sections can be stored in the file. Added logic to recursively read all
> option sections from the file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/include/trace-cmd-local.h |  1 +
>  lib/trace-cmd/trace-input.c             | 42 +++++++++++++++++++++++--
>  lib/trace-cmd/trace-output.c            |  2 +-
>  3 files changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index ac7e7f17..b4f3d8c8 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -53,6 +53,7 @@ struct cpu_data_source {
>  int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
>  		       struct cpu_data_source *data, const char *buff_name);
>  off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
> +unsigned long long get_last_option_offset(struct tracecmd_input *handle);
>  unsigned int get_meta_strings_size(struct tracecmd_input *handle);
>  
>  #endif /* _TRACE_CMD_LOCAL_H */
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 5625e367..a25919a3 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -179,6 +179,7 @@ struct tracecmd_input {
>  	struct file_section	*sections;
>  	bool			options_init;
>  	unsigned long long	options_start;
> +	unsigned long long	options_last_offset;
>  	size_t			total_file_size;
>  
>  	/* For custom profilers. */
> @@ -2868,6 +2869,30 @@ __hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
>  	return handle->strings_size;
>  }
>  
> +__hidden unsigned long long get_last_option_offset(struct tracecmd_input *handle)
> +{
> +	return handle->options_last_offset;
> +}
> +
> +static int handle_option_done(struct tracecmd_input *handle, char *buf, int size)
> +{
> +	unsigned long long offset;
> +
> +	if (size < 8)
> +		return -1;

space

> +	offset = lseek64(handle->fd, 0, SEEK_CUR);
> +	if (offset >= size)
> +		handle->options_last_offset = offset - size;

space

> +	offset = tep_read_number(handle->pevent, buf, 8);
> +	if (!offset)
> +		return 0;
> +
> +	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
> +		return -1;
> +
> +	return handle_options(handle);
> +}
> +
>  static inline int save_read_number(struct tep_handle *tep, char *data, int *data_size,
>  				   int *read_pos, int bytes, unsigned long long *num)
>  {
> @@ -2970,19 +2995,27 @@ static int handle_options(struct tracecmd_input *handle)
>  	long long offset;
>  	unsigned short option;
>  	unsigned int size;
> +	unsigned short id, flags;
>  	char *cpustats = NULL;
>  	struct hook_list *hook;
>  	char *buf;
>  	int cpus;
>  	int ret;
>  
> -	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
> +	if (!HAS_SECTIONS(handle)) {
> +		handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
> +	} else {
> +		if (read_section_header(handle, &id, &flags, NULL, NULL))
> +			return -1;
> +		if (id != TRACECMD_OPTION_DONE)
> +			return -1;
> +	}
>  
>  	for (;;) {
>  		if (read2(handle, &option))
>  			return -1;
>  
> -		if (option == TRACECMD_OPTION_DONE)
> +		if (!HAS_SECTIONS(handle) && option == TRACECMD_OPTION_DONE)
>  			break;
>  
>  		/* next 4 bytes is the size of the option */
> @@ -3122,7 +3155,10 @@ static int handle_options(struct tracecmd_input *handle)
>  			section_add_or_update(handle, option, -1,
>  					      tep_read_number(handle->pevent, buf, 8), 0);
>  			break;
> -
> +		case TRACECMD_OPTION_DONE:
> +			ret = handle_option_done(handle, buf, size);
> +			free(buf);
> +			return ret;

space

>  		default:
>  			tracecmd_warning("unknown option %d", option);
>  			break;

-- Steve

> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 08f74c87..1fa83e93 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -2238,7 +2238,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
>  	tep_ref(handle->pevent);
>  	handle->page_size = tracecmd_page_size(ihandle);
>  	handle->file_version = tracecmd_get_in_file_version(ihandle);
> -	handle->options_start = tracecmd_get_options_offset(ihandle);
> +	handle->options_start = get_last_option_offset(ihandle);
>  	handle->strings_offs = get_meta_strings_size(ihandle);
>  	list_head_init(&handle->options);
>  	list_head_init(&handle->buffers);

