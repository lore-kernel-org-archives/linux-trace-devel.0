Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1ABC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiAOQAD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiAOQAC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:00:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B5EC061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 08:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99AD660DE4
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 16:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AE6C36AE7;
        Sat, 15 Jan 2022 16:00:00 +0000 (UTC)
Date:   Sat, 15 Jan 2022 10:59:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 16/25] trace-cmd library: Read headers from trace
 file version 7
Message-ID: <20220115105959.591892e1@gandalf.local.home>
In-Reply-To: <20211210105448.97850-17-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-17-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:39 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Trace file version 7 has more flexible structure than version 6, headers
> are not located at fixed position in the file. A new logic is
> implemented to read and parse the headers from this new format.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 137 ++++++++++++++++++++++++++++++++----
>  1 file changed, 122 insertions(+), 15 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 8f95bf3b..9027729e 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -163,8 +163,7 @@ struct tracecmd_input {
>  	struct pid_addr_maps	*pid_maps;
>  	/* file information */
>  	struct file_section	*sections;
> -	size_t			header_files_start;
> -	size_t			ftrace_files_start;
> +	bool			options_init;
>  	unsigned long long	options_start;
>  	size_t			total_file_size;
>  
> @@ -917,19 +916,7 @@ static int read_cpus(struct tracecmd_input *handle)
>  	return 0;
>  }
>  
> -/**
> - * tracecmd_read_headers - read the header information from trace.dat
> - * @handle: input handle for the trace.dat file
> - * @state: The state to read up to or zero to read up to options.
> - *
> - * This reads the trace.dat file for various information. Like the
> - * format of the ring buffer, event formats, ftrace formats, kallsyms
> - * and printk. This may be called multiple times with different @state
> - * values, to read partial data at a time. It will always continue
> - * where it left off.
> - */
> -int tracecmd_read_headers(struct tracecmd_input *handle,
> -			  enum tracecmd_file_states state)
> +static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_states state)
>  {
>  	int ret;
>  
> @@ -995,6 +982,126 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
>  	return 0;
>  }
>  
> +static int handle_options(struct tracecmd_input *handle);
> +
> +static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
> +			       unsigned short *flags, unsigned long long *size, const char **description)
> +{
> +	unsigned short fl;
> +	unsigned short sec_id;
> +	unsigned long long sz;
> +	int desc;
> +
> +	if (read2(handle, &sec_id))
> +		return -1;
> +	if (read4(handle, (unsigned int *)&desc))
> +		return -1;
> +	if (read2(handle, &fl))
> +		return -1;
> +	if (read8(handle, &sz))
> +		return -1;
> +
> +	if (id)
> +		*id = sec_id;
> +	if (flags)
> +		*flags = fl;
> +	if (size)
> +		*size = sz;
> +
> +	return 0;
> +}
> +
> +static int handle_section(struct tracecmd_input *handle, struct file_section *section)
> +{
> +	unsigned short id, flags;
> +	unsigned long long size;
> +	int ret;
> +
> +	if (lseek64(handle->fd, section->section_offset, SEEK_SET) == (off_t)-1)
> +		return -1;
> +	if (read_section_header(handle, &id, &flags, &size, NULL))
> +		return -1;
> +	section->flags = flags;
> +	if (id != section->id)
> +		return -1;
> +
> +	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
> +
> +	switch (section->id) {
> +	case TRACECMD_OPTION_HEADER_INFO:
> +		ret = read_header_files(handle);
> +		break;
> +	case TRACECMD_OPTION_FTRACE_EVENTS:
> +		ret = read_ftrace_files(handle, NULL);
> +		break;
> +	case TRACECMD_OPTION_EVENT_FORMATS:
> +		ret = read_event_files(handle, NULL);
> +		break;
> +	case TRACECMD_OPTION_KALLSYMS:
> +		ret = read_proc_kallsyms(handle);
> +		break;
> +	case TRACECMD_OPTION_PRINTK:
> +		ret = read_ftrace_printk(handle);
> +		break;
> +	case TRACECMD_OPTION_CMDLINES:
> +		ret = read_and_parse_cmdlines(handle);
> +		break;
> +	default:
> +		ret = 0;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int read_headers_v7(struct tracecmd_input *handle)

I really like how these changes are coming. This makes the reading of the
tracing file much more manageable. Great job Tzvetomir!

Only comment to this patch is, as I've said in other patches, I don't think
we need to call this _v7, just "read_headers()" would suffice.

-- Steve


> +{
> +	struct file_section *section;
> +
> +	if (handle->options_init)
> +		return 0;
> +
> +	if (!handle->options_start)
> +		return -1;
> +
> +	if (lseek64(handle->fd, handle->options_start, SEEK_SET) == (off64_t)-1) {
> +		tracecmd_warning("Filed to goto options offset %lld", handle->options_start);
> +		return -1;
> +	}
> +
> +	if (handle_options(handle))
> +		return -1;
> +
> +	section = handle->sections;
> +	while (section) {
> +		if (handle_section(handle, section))
> +			return -1;
> +		section = section->next;
> +	}
> +
> +	handle->options_init = true;
> +	return 0;
> +}
> +
> +/**
> + * tracecmd_read_headers - read the header information from trace.dat
> + * @handle: input handle for the trace.dat file
> + * @state: The state to read up to or zero to read up to options.
> + *
> + * This reads the trace.dat file for various information. Like the
> + * format of the ring buffer, event formats, ftrace formats, kallsyms
> + * and printk. This may be called multiple times with different @state
> + * values, to read partial data at a time. It will always continue
> + * where it left off.
> + */
> +int tracecmd_read_headers(struct tracecmd_input *handle,
> +			  enum tracecmd_file_states state)
> +{
> +	if (!HAS_SECTIONS(handle))
> +		return read_headers_v6(handle, state);
> +	return read_headers_v7(handle);
> +}
> +
>  static unsigned long long calc_page_offset(struct tracecmd_input *handle,
>  					   unsigned long long offset)
>  {

