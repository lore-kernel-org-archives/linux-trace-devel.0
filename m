Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD36C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 12:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiAOMxw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 07:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiAOMxw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 07:53:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C887BC061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 04:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9C7B80108
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 12:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F83DC36AE7;
        Sat, 15 Jan 2022 12:53:49 +0000 (UTC)
Date:   Sat, 15 Jan 2022 07:53:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 04/25] trace-cmd library: Add strings section in
 trace file version 7
Message-ID: <20220115075347.66d46b7f@rorschach.local.home>
In-Reply-To: <20211210105448.97850-5-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:27 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In the trace file metadata there are various dynamic strings. Collecting
> all these strings in a dedicated section in the file simplifies parsing
> of the metadata. The string section is added in trace files version 7,
> at the end of the file.

Does it have to be at the end of the file?

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  .../include/private/trace-cmd-private.h       |  2 +
>  lib/trace-cmd/trace-output.c                  | 63 +++++++++++++++++++
>  tracecmd/trace-record.c                       |  1 +
>  3 files changed, 66 insertions(+)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index ed25d879..ed8fbf11 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -138,6 +138,7 @@ enum {
>  	TRACECMD_OPTION_TIME_SHIFT,
>  	TRACECMD_OPTION_GUEST,
>  	TRACECMD_OPTION_TSC2NSEC,
> +	TRACECMD_OPTION_STRINGS,
>  };
>  
>  enum {
> @@ -301,6 +302,7 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle);
>  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
>  int tracecmd_write_cmdlines(struct tracecmd_output *handle);
>  int tracecmd_write_options(struct tracecmd_output *handle);
> +int tracecmd_write_meta_strings(struct tracecmd_output *handle);
>  int tracecmd_append_options(struct tracecmd_output *handle);
>  void tracecmd_output_close(struct tracecmd_output *handle);
>  void tracecmd_output_free(struct tracecmd_output *handle);
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 4d165ac2..ed505db6 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -62,6 +62,8 @@ struct tracecmd_output {
>  	bool			quiet;
>  	unsigned long		file_state;
>  	unsigned long		file_version;
> +	unsigned long		strings_p;
> +	unsigned long		strings_offs;

Can you add a comment to what the above are to represent?

Especially out of context, it's hard to know how this is suppose to
work.

>  	size_t			options_start;
>  	bool			big_endian;
>  
> @@ -69,6 +71,8 @@ struct tracecmd_output {
>  	struct list_head	buffers;
>  	struct tracecmd_msg_handle *msg_handle;
>  	char			*trace_clock;
> +	char			*strings;
> +

Remove the extra space.

>  };
>  
>  struct list_event {
> @@ -85,6 +89,8 @@ struct list_event_system {
>  
>  #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
>  
> +static int save_string_section(struct tracecmd_output *handle);
> +

I won't ask you to fix it, but it's best not to introduce a static
function that is not used, and if need be, just combine the patches.

Again, without use cases, it's hard to know if this is doing what you
say it is doing.

>  static stsize_t
>  do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
>  {
> @@ -127,6 +133,22 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
>  	return tep_read_number(handle->pevent, &val, 8);
>  }
>  
> +static long add_string(struct tracecmd_output *handle, const char *string)
> +{
> +	int size = strlen(string) + 1;
> +	int pos = handle->strings_p;
> +	char *strings;
> +
> +	strings = realloc(handle->strings, pos + size);
> +	if (!strings)
> +		return -1;
> +	handle->strings = strings;
> +	memcpy(handle->strings + pos, string, size);
> +	handle->strings_p += size;
> +
> +	return handle->strings_offs + pos;

What is the above suppose to be returning? What is strings_off?

> +}
> +
>  /**
>   * tracecmd_set_quiet - Set if to print output to the screen
>   * @quiet: If non zero, print no output to the screen
> @@ -185,6 +207,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
>  		free(option);
>  	}
>  
> +	free(handle->strings);
>  	free(handle->trace_clock);
>  	free(handle);
>  }
> @@ -194,6 +217,11 @@ void tracecmd_output_close(struct tracecmd_output *handle)
>  	if (!handle)
>  		return;
>  
> +	if (handle->file_version >= FILE_VERSION_SECTIONS) {

Shouldn't the above be if (HAS_SECTIONS(handle)) ?

-- Steve

> +		/* write strings section */
> +		save_string_section(handle);
> +	}
> +
>  	if (handle->fd >= 0) {
>  		close(handle->fd);
>  		handle->fd = -1;
> @@ -332,6 +360,32 @@ int tracecmd_ftrace_enable(int set)
>  	return ret;
>  }
>  
> +static int save_string_section(struct tracecmd_output *handle)
> +{
> +	if (!handle->strings || !handle->strings_p)
> +		return 0;
> +
> +	if (!check_out_state(handle, TRACECMD_OPTION_STRINGS)) {
> +		tracecmd_warning("Cannot write strings, unexpected state 0x%X",
> +				 handle->file_state);
> +		return -1;
> +	}
> +
> +	if (do_write_check(handle, handle->strings, handle->strings_p))
> +		goto error;
> +
> +	handle->strings_offs += handle->strings_p;
> +	free(handle->strings);
> +	handle->strings = NULL;
> +	handle->strings_p = 0;
> +	handle->file_state = TRACECMD_OPTION_STRINGS;
> +	return 0;
> +
> +error:
> +	return -1;
> +}
> +
> +
>  static int read_header_files(struct tracecmd_output *handle)
>  {
>  	tsize_t size, check_size, endian8;
> @@ -1328,6 +1382,15 @@ int tracecmd_write_options(struct tracecmd_output *handle)
>  	return 0;
>  }
>  
> +int tracecmd_write_meta_strings(struct tracecmd_output *handle)
> +{
> +	if (!HAS_SECTIONS(handle))
> +		return 0;
> +
> +	return save_string_section(handle);
> +}
> +
> +
>  int tracecmd_append_options(struct tracecmd_output *handle)
>  {
>  	struct tracecmd_option *options;
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 7b2b59bb..f599610e 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4093,6 +4093,7 @@ static void setup_agent(struct buffer_instance *instance,
>  	tracecmd_write_cmdlines(network_handle);
>  	tracecmd_write_cpus(network_handle, instance->cpu_count);
>  	tracecmd_write_options(network_handle);
> +	tracecmd_write_meta_strings(network_handle);
>  	tracecmd_msg_finish_sending_data(instance->msg_handle);
>  	instance->network_handle = network_handle;
>  }

