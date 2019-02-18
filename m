Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B9CC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A714221900
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbfBRO2p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:28:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38059 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732924AbfBRO2p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:28:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so18582541wrw.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:28:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WnJDTBb6h1WP5fQfI2X2/gXyoI8P5rahgOaAWvNgyZo=;
        b=sa4KfUzCbtR6FFBTRXwslcd+koVcZIuRshGJUC4FrkVYy+Z7qmm055buOHauVbQ4bu
         76YiLrm0vsvsooNO0wOkbjTOG2aZiVGBsNDdQ16+HudVvCD+SbejtewQhzjS/qV/BJxf
         RZMD3FfhRHBR0wXFH/rPJQpnbYHvEIQcCvr+GsJh088+u+1SDrAkOuJiE7AghfhyELnC
         Zq0ZGUbqRGEYJZnJO/f2qpE66U+mW66jzV7D3aMl4K6igXopwy4/cN1y2i9l1y0TCSCe
         nDwYfT/MYaz9YQkbdZVt0BHD52f9OHl6ZZie0ct2agwCjIIYyANZlWa1do4lHL5LlxX4
         ++6Q==
X-Gm-Message-State: AHQUAuYhEU0kcds7E4g6dnRxWDks/LVZBIxq/CmBjIOUtYKR+yjIrmS4
        HtIEay050Krq+SBnYOSV+Q==
X-Google-Smtp-Source: AHgI3IbhhlONeSwpnD61gjjs7F6q6H4FYCsntk6CweouM5dt0iFTXTtd/HQyhygV8ElgIL7FR+w2cw==
X-Received: by 2002:adf:fc12:: with SMTP id i18mr15767520wrr.201.1550500122739;
        Mon, 18 Feb 2019 06:28:42 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id p6sm18101507wre.63.2019.02.18.06.28.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 18 Feb 2019 06:28:42 -0800 (PST)
Date:   Mon, 18 Feb 2019 16:28:40 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 05/11] trace-cmd: Add VM kernel tracing over
 vsockets transport
Message-ID: <20190218142838.GC11734@box>
References: <20190214141335.28144-1-kaslevs@vmware.com>
 <20190214141335.28144-6-kaslevs@vmware.com>
 <20190214150348.0f44293e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190214150348.0f44293e@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 14, 2019 at 03:03:48PM -0500, Steven Rostedt wrote:
> On Thu, 14 Feb 2019 16:13:29 +0200
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
> 
> >  void start_threads(enum trace_type type, struct common_record_context *ctx)
> >  {
> >  	struct buffer_instance *instance;
> > -	int *brass = NULL;
> >  	int total_cpu_count = 0;
> >  	int i = 0;
> >  	int ret;
> >  
> > -	for_all_instances(instance)
> > +	for_all_instances(instance) {
> > +		/* Start the connection now to find out how many CPUs we need */
> > +		if (instance->flags & BUFFER_FL_GUEST)
> > +			connect_to_agent(instance);
> >  		total_cpu_count += instance->cpu_count;
> > +	}
> >  
> >  	/* make a thread for every CPU we have */
> > -	pids = malloc(sizeof(*pids) * total_cpu_count * (buffers + 1));
> > +	pids = calloc(total_cpu_count * (buffers + 1), sizeof(*pids));
> >  	if (!pids)
> > -		die("Failed to allocat pids for %d cpus", total_cpu_count);
> > -
> > -	memset(pids, 0, sizeof(*pids) * total_cpu_count * (buffers + 1));
> > +		die("Failed to allocate pids for %d cpus", total_cpu_count);
> >  
> >  	for_all_instances(instance) {
> > +		int *brass = NULL;
> >  		int x, pid;
> >  
> > -		if (host) {
> > +		if (instance->flags & BUFFER_FL_AGENT) {
> > +			setup_agent(instance, ctx);
> > +		} else if (instance->flags & BUFFER_FL_GUEST) {
> > +			setup_guest(instance);
> > +		} else if (host) {
> >  			instance->msg_handle = setup_connection(instance, ctx);
> >  			if (!instance->msg_handle)
> >  				die("Failed to make connection");
> > @@ -3139,13 +3444,14 @@ static void print_stat(struct buffer_instance *instance)
> >  {
> >  	int cpu;
> >  
> > +	if (quiet)
> > +		return;
> 
> Hmm, this looks unrelated to this patch, and looks like it should have
> been in a patch by itself. As a clean up.
> 
> > +
> >  	if (!is_top_instance(instance))
> > -		if (!quiet)
> > -			printf("\nBuffer: %s\n\n", instance->name);
> > +		printf("\nBuffer: %s\n\n", instance->name);
> >  
> >  	for (cpu = 0; cpu < instance->cpu_count; cpu++)
> > -		if (!quiet)
> > -			trace_seq_do_printf(&instance->s_print[cpu]);
> > +		trace_seq_do_printf(&instance->s_print[cpu]);
> >  }
> >  
> >  enum {
> > @@ -3171,7 +3477,44 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
> >  	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
> >  	add_option_hooks(handle);
> >  	add_uname(handle);
> > +}
> > +
> > +static void write_guest_file(struct buffer_instance *instance)
> > +{
> > +	struct tracecmd_output *handle;
> > +	int cpu_count = instance->cpu_count;
> > +	char *file;
> > +	char **temp_files;
> > +	int i, fd;
> > +
> > +	file = get_guest_file(output_file, instance->name);
> > +	fd = open(file, O_RDWR);
> > +	if (fd < 0)
> > +		die("error opening %s", file);
> > +	put_temp_file(file);
> > +
> > +	handle = tracecmd_get_output_handle_fd(fd);
> > +	if (!handle)
> > +		die("error writing to %s", file);
> >  
> > +	temp_files = malloc(sizeof(*temp_files) * cpu_count);
> > +	if (!temp_files)
> > +		die("failed to allocate temp_files for %d cpus",
> > +		    cpu_count);
> > +
> > +	for (i = 0; i < cpu_count; i++) {
> > +		temp_files[i] = get_temp_file(instance, i);
> > +		if (!temp_files[i])
> > +			die("failed to allocate memory");
> > +	}
> > +
> > +	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files) < 0)
> > +		die("failed to write CPU data");
> > +	tracecmd_output_close(handle);
> > +
> > +	for (i = 0; i < cpu_count; i++)
> > +		put_temp_file(temp_files[i]);
> > +	free(temp_files);
> >  }
> >  
> >  static void record_data(struct common_record_context *ctx)
> > @@ -3185,7 +3528,9 @@ static void record_data(struct common_record_context *ctx)
> >  	int i;
> >  
> >  	for_all_instances(instance) {
> > -		if (instance->msg_handle)
> > +		if (instance->flags & BUFFER_FL_GUEST)
> > +			write_guest_file(instance);
> > +		else if (host && instance->msg_handle)
> >  			finish_network(instance->msg_handle);
> >  		else
> >  			local = true;
> > @@ -4404,6 +4749,7 @@ void trace_stop(int argc, char **argv)
> >  		c = getopt(argc-1, argv+1, "hatB:");
> >  		if (c == -1)
> >  			break;
> > +
> >  		switch (c) {
> >  		case 'h':
> >  			usage(argv);
> > @@ -4566,6 +4912,63 @@ static void init_common_record_context(struct common_record_context *ctx,
> >  #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
> >  #define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
> >  #define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
> > +#define IS_AGENT(ctx) ((ctx)->curr_cmd == CMD_record_agent)
> > +
> > +static void add_argv(struct buffer_instance *instance, char *arg, bool prepend)
> > +{
> > +	instance->argv = realloc(instance->argv,
> > +				 (instance->argc + 1) * sizeof(char *));
> > +	if (!instance->argv)
> > +		die("Can not allocate instance args");
> > +	if (prepend) {
> > +		memmove(instance->argv + 1, instance->argv,
> > +			instance->argc * sizeof(*instance->argv));
> > +		instance->argv[0] = arg;
> > +	} else {
> > +		instance->argv[instance->argc] = arg;
> > +	}
> > +	instance->argc++;
> > +}
> > +
> > +static void add_arg(struct buffer_instance *instance,
> > +		    int c, const char *opts,
> > +		    struct option *long_options, char *optarg)
> > +{
> > +	char *ptr;
> > +	char *arg;
> > +	int ret;
> > +	int i;
> > +
> > +	/* Short or long arg */
> > +	if (!(c & 0x80)) {
> > +		ret = asprintf(&arg, "-%c", c);
> > +		if (ret < 0)
> > +			die("Can not allocate argument");
> > +		ptr = strstr(opts, arg+1);
> > +		if (!ptr)
> > +			return; /* Not found? */
> 
> This leaks arg, as arg was allocated with asprintf(). Need a
> "free(arg)" here.

Bah! Another left over from the VIRT-SERVER branch. Reorganized this function
for the next iteration.
