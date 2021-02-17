Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6EEC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 16:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3DBD64DA1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 16:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhBQQBb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 11:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233811AbhBQQB3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 11:01:29 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E93E64DEC;
        Wed, 17 Feb 2021 16:00:47 +0000 (UTC)
Date:   Wed, 17 Feb 2021 11:00:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Add validation for reading and writing
 trace.dat files
Message-ID: <20210217110045.71771e87@gandalf.local.home>
In-Reply-To: <20210217042341.1675546-2-tz.stoyanov@gmail.com>
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
        <20210217042341.1675546-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


>  /* --- Opening and Reading the trace.dat file --- */
>  
> +enum  {
> +	TRACECMD_FILE_INIT		= (1 << 0),
> +	TRACECMD_FILE_HEADERS		= (1 << 1),
> +	TRACECMD_FILE_FTRACE_EVENTS	= (1 << 2),
> +	TRACECMD_FILE_ALL_EVENTS	= (1 << 3),
> +	TRACECMD_FILE_KALLSYMS		= (1 << 4),
> +	TRACECMD_FILE_PRINTK		= (1 << 5),
> +	TRACECMD_FILE_CMD_LINES		= (1 << 6),
> +	TRACECMD_FILE_CPU_COUNT		= (1 << 7),
> +	TRACECMD_FILE_OPTIONS		= (1 << 8),
> +	TRACECMD_FILE_CPU_LATENCY	= (1 << 9),
> +	TRACECMD_FILE_CPU_FLYRECORD	= (1 << 10),

Why did you use bits, and not just a number?

It's not that this is quantum physics and we are in multiple states at once
;-)

Order matters, so we want to make sure that when we enter one state, we are
coming in from another state.


> +};
> +#define TRACECMD_FILE_TRACE_DATA (TRACECMD_FILE_CPU_LATENCY | TRACECMD_FILE_CPU_FLYRECORD)
> +
>  enum {
>  	TRACECMD_OPTION_DONE,
>  	TRACECMD_OPTION_DATE,
> @@ -115,9 +130,7 @@ enum {
>  enum {
>  	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
>  	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
> -	TRACECMD_FL_LATENCY		= (1 << 2),
> -	TRACECMD_FL_IN_USECS		= (1 << 3),
> -	TRACECMD_FL_FLYRECORD		= (1 << 4),
> +	TRACECMD_FL_IN_USECS		= (1 << 2),
>  };
>  
>  struct tracecmd_ftrace {
> @@ -150,6 +163,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
>  void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
>  void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
>  unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
> +unsigned long tracecmd_get_file_state(struct tracecmd_input *handle);
>  unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
>  int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
>  
> @@ -273,6 +287,7 @@ struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handl
>  						   const char *name, int cpus);
>  
>  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
> +int tracecmd_write_cmdlines(struct tracecmd_output *handle);
>  int tracecmd_write_options(struct tracecmd_output *handle);
>  int tracecmd_append_options(struct tracecmd_output *handle);
>  int tracecmd_update_option(struct tracecmd_output *handle,
> @@ -500,7 +515,4 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
>  void *tracecmd_record_offset(struct tracecmd_input *handle,
>  			     struct tep_record *record);
>  
> -int save_tracing_file_data(struct tracecmd_output *handle,
> -			   const char *filename);
> -
>  #endif /* _TRACE_CMD_PRIVATE_H */
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 76bcb215..c171e93c 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -102,6 +102,7 @@ struct host_trace_info {
>  
>  struct tracecmd_input {
>  	struct tep_handle	*pevent;
> +	unsigned long		file_state;
>  	struct tep_plugin_list	*plugin_list;
>  	struct tracecmd_input	*parent;
>  	unsigned long		flags;
> @@ -161,6 +162,11 @@ unsigned long tracecmd_get_flags(struct tracecmd_input *handle)
>  	return handle->flags;
>  }
>  
> +unsigned long tracecmd_get_file_state(struct tracecmd_input *handle)
> +{
> +	return handle->file_state;
> +}
> +
>  #if DEBUG_RECORD
>  static void remove_record(struct page *page, struct tep_record *record)
>  {
> @@ -782,34 +788,40 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
>  	ret = read_header_files(handle);
>  	if (ret < 0)
>  		return -1;
> +	handle->file_state |= TRACECMD_FILE_HEADERS;
> +	tep_set_long_size(handle->pevent, handle->long_size);
>  
>  	ret = read_ftrace_files(handle, NULL);
>  	if (ret < 0)
>  		return -1;
> +	handle->file_state |= TRACECMD_FILE_FTRACE_EVENTS;
>  
>  	ret = read_event_files(handle, NULL);
>  	if (ret < 0)
>  		return -1;
> +	handle->file_state |= TRACECMD_FILE_ALL_EVENTS;
>  
>  	ret = read_proc_kallsyms(handle);
>  	if (ret < 0)
>  		return -1;
> +	handle->file_state |= TRACECMD_FILE_KALLSYMS;
>  
>  	ret = read_ftrace_printk(handle);
>  	if (ret < 0)
>  		return -1;
> +	handle->file_state |= TRACECMD_FILE_PRINTK;
>  
>  	if (read_and_parse_cmdlines(handle) < 0)
>  		return -1;
> +	handle->file_state |= TRACECMD_FILE_CMD_LINES;
>  
>  	if (read_cpus(handle) < 0)
>  		return -1;
> +	handle->file_state |= TRACECMD_FILE_CPU_COUNT;
>  
>  	if (read_options_type(handle) < 0)
>  		return -1;
>  
> -	tep_set_long_size(handle->pevent, handle->long_size);
> -
>  	return 0;
>  }
>  
> @@ -2657,6 +2669,7 @@ static int read_options_type(struct tracecmd_input *handle)
>  	if (strncmp(buf, "options", 7) == 0) {
>  		if (handle_options(handle) < 0)
>  			return -1;
> +		handle->file_state |= TRACECMD_FILE_OPTIONS;
>  		if (do_read_check(handle, buf, 10))
>  			return -1;
>  	}
> @@ -2665,9 +2678,9 @@ static int read_options_type(struct tracecmd_input *handle)
>  	 * Check if this is a latency report or flyrecord.
>  	 */
>  	if (strncmp(buf, "latency", 7) == 0)
> -		handle->flags |= TRACECMD_FL_LATENCY;
> +		handle->file_state |= TRACECMD_FILE_CPU_LATENCY;
>  	else if (strncmp(buf, "flyrecord", 9) == 0)
> -		handle->flags |= TRACECMD_FL_FLYRECORD;
> +		handle->file_state |= TRACECMD_FILE_CPU_FLYRECORD;

I think we should keep the LATENCY and FLYRECORD flags, as they have
different meanings and define the type of handle, not just the state they
are in. We can have the logic flow through different states depending on if
it is a latency or flyrecord file.

-- Steve
