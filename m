Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B601D12F0
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 23:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728690841; cv=none; b=F8zlwuSVMXF+SLCgTxLE8FJ9UAH/sFNp+9+2qNQe8JvkWcxGvs6JQOx0MFwGWScJ6iCDPeEADB9yL/+o30/ppkEtnaYZeEGgbF04J73OVawy+cWD14/7+O3XNBlO6eIL4uKPKczlcPDLHeM8pSuvKEM5q/2E8300phdi+sYQNks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728690841; c=relaxed/simple;
	bh=6AmiljJ+KkHW8PUHC9TQOJu3Gx5hQsd7Tq+ogyN0zGU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N5q0WcaPVzfU5gCEJ4V4/sl+ZOdr+CYFOhYSA3ySVJiY6tn7R3a5jH4aQ9Sg+ff6HR9nLJq9G1O4Go+ilpquNvXSg0h8f4VzupclquizwocsPq5cASrIzjfjFrVCUmmgFqBDVpg3l+WUmGI5Qp6nW+OU/VNOdWbxxQRa9IPSt/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2918C4CEC3;
	Fri, 11 Oct 2024 23:54:00 +0000 (UTC)
Date: Fri, 11 Oct 2024 19:54:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd reset: Add option to preserve specific
 dynamic events
Message-ID: <20241011195411.0fe6dd81@gandalf.local.home>
In-Reply-To: <20241010085350.3479149-3-metin.kaya@arm.com>
References: <20241010085350.3479149-1-metin.kaya@arm.com>
	<20241010085350.3479149-3-metin.kaya@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Oct 2024 09:53:50 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

Hi Metin,

> One may want to preserve some of the dynamic events (e.g., kprobes)
> during a trace-cmd reset. Thus, provide -k command line option for
> trace-cmd reset to allow keeping specified events untouched during the
> reset operation.
> 
> For example, it's possible to prevent kprobes & kretprobes from being
> destroyed in trace-cmd reset with this patch:
> 
>     # Add kprobe and kretprobe for sys_open():
>     $ echo 'p do_sys_open' > /sys/kernel/tracing/kprobe_events
>     $ echo 1 > /sys/kernel/tracing/events/kprobes/p_do_sys_open_0/enable
>     $ echo 'r do_sys_open' >> /sys/kernel/tracing/kprobe_events
>     $ echo 1 > /sys/kernel/tracing/events/kprobes/r_do_sys_open_0/enable
>     $ cat /sys/kernel/tracing/kprobe_events
>     p:kprobes/p_do_sys_open_0 do_sys_open
>     r128:kprobes/r_do_sys_open_0 do_sys_open
> 
>     # Issue reset, but keep kprobes and kretprobes ('-k all' would keep
>     # all existing dynamic events):
>     $ trace-cmd reset -k kprobe -k kretprobe
>     $ cat /sys/kernel/tracing/kprobe_events
>     p:kprobes/p_do_sys_open_0 do_sys_open
>     r128:kprobes/r_do_sys_open_0 do_sys_open
> 
>     # Issue reset, but this time only keep kretprobes:
>     $ trace-cmd reset -k kretprobe
>     $ cat /sys/kernel/tracing/kprobe_events
>     r128:kprobes/r_do_sys_open_0 do_sys_open
> 
>     # Don't preserve any dynamic event:
>     $ trace-cmd reset
>     $ cat /sys/kernel/tracing/kprobe_events
>     $
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219302
> Signed-off-by: Metin Kaya <metin.kaya@arm.com>
> ---
>  tracecmd/trace-record.c | 59 ++++++++++++++++++++++++++++++++++++-----
>  tracecmd/trace-usage.c  |  5 +++-
>  2 files changed, 57 insertions(+), 7 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index c695cd23..f80b386f 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5399,11 +5399,15 @@ static void clear_error_log(void)
>  		clear_instance_error_log(instance);
>  }
>  
> -static void clear_all_dynamic_events(void)
> +static void clear_all_dynamic_events(unsigned int exclude_types)
>  {
> -	/* Clear event probes first, as they may be attached to other dynamic event */
> -	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
> -	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL, true);
> +	/*
> +	 * Clear event probes first (if they are not excluded), as they may be
> +	 * attached to other dynamic event.
> +	 */
> +	if (!(TRACEFS_DYNEVENT_EPROBE & exclude_types))

BTW, I prefer the variable first notation. Not "FLAG & var", but
"var & FLAG" as that's the way I read it in English. I read it as
"exclude_types has TRACEFS_DYNEVENT_EPROBE set" but the way it is written
it sounds like: "TRACEFS_DYNEVENT_EPROBE has exclude_types set" in my head,
and that confuses me.

> +		tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
> +	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL & ~exclude_types, true);
>  }
>  
>  static void clear_func_filters(void)
> @@ -6036,11 +6040,51 @@ void trace_restart(int argc, char **argv)
>  	exit(0);
>  }
>  
> +/**
> + * find_dynevent_type - Find string formatted dynamic event type
> + *			in "enum tracefs_dynevent_type".
> + *
> + * @type: Dynamic event type in string format.
> + *
> + * Returns an unsigned int value for the event specified in @type.
> + */
> +static unsigned int find_dynevent_type(const char *type)
> +{
> +	/* WARN: Should be kept in sync with "enum tracefs_dynevent_type". */
> +	if (!strcmp(type, "kprobe"))
> +		return TRACEFS_DYNEVENT_KPROBE;
> +	else if (!strcmp(type, "kretprobe"))
> +		return TRACEFS_DYNEVENT_KRETPROBE;
> +	else if (!strcmp(type, "uprobe"))
> +		return TRACEFS_DYNEVENT_UPROBE;
> +	else if (!strcmp(type, "uretprobe"))
> +		return TRACEFS_DYNEVENT_URETPROBE;
> +	else if (!strcmp(type, "eprobe"))
> +		return TRACEFS_DYNEVENT_EPROBE;
> +	else if (!strcmp(type, "synth"))
> +		return TRACEFS_DYNEVENT_SYNTH;
> +	else if (!strcmp(type, "all"))
> +		/*
> +		 * Unfortunately TRACEFS_DYNEVENT_ALL does not work here.
> +		 * Because tracefs_dynevent_destroy_all() assumes 0 means all
> +		 * and destroys all dynamic events.
> +		 */
> +		return (TRACEFS_DYNEVENT_KPROBE |
> +			TRACEFS_DYNEVENT_KRETPROBE |
> +			TRACEFS_DYNEVENT_UPROBE |
> +			TRACEFS_DYNEVENT_URETPROBE |
> +			TRACEFS_DYNEVENT_EPROBE |
> +			TRACEFS_DYNEVENT_SYNTH);

return is not a function. You don't need the parenthesis.

> +	else
> +		die("Invalid event type '%s'!\n", type);
> +}
> +
>  void trace_reset(int argc, char **argv)
>  {
>  	int c;
>  	int topt = 0;
>  	struct buffer_instance *instance = &top_instance;
> +	unsigned int excluded_types = 0;
>  
>  	init_top_instance();
>  
> @@ -6048,7 +6092,7 @@ void trace_reset(int argc, char **argv)
>  	int last_specified_all = 0;
>  	struct buffer_instance *inst; /* iterator */
>  
> -	while ((c = getopt(argc-1, argv+1, "hab:B:td")) >= 0) {
> +	while ((c = getopt(argc-1, argv+1, "hab:B:tdk:")) >= 0) {
>  
>  		switch (c) {
>  		case 'h':
> @@ -6102,6 +6146,9 @@ void trace_reset(int argc, char **argv)
>  				instance->flags &= ~BUFFER_FL_KEEP;
>  			}
>  			break;
> +		case 'k':
> +			excluded_types |= find_dynevent_type(optarg);
> +			break;
>  		default:
>  			usage(argv);
>  			break;
> @@ -6112,7 +6159,7 @@ void trace_reset(int argc, char **argv)
>  	set_buffer_size();
>  	clear_filters();
>  	clear_triggers();
> -	clear_all_dynamic_events();
> +	clear_all_dynamic_events(excluded_types);
>  	clear_error_log();
>  	/* set clock to "local" */
>  	reset_clock();
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 8bbf2e3e..f159e5e1 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -193,7 +193,7 @@ static struct usage_help usage_help[] = {
>  	{
>  		"reset",
>  		"disable all kernel tracing and clear the trace buffers",
> -		" %s reset [-b size][-B buf][-a][-d][-t]\n"
> +		" %s reset [-b size][-B buf][-k event][-a][-d][-t]\n"
>  		"          Disables the tracer (may reset trace file)\n"
>  		"          Used in conjunction with start\n"
>  		"          -b change the kernel buffer size (in kilobytes per CPU)\n"
> @@ -201,6 +201,9 @@ static struct usage_help usage_help[] = {
>  		"          -B reset the given buffer instance (may specify multiple -B)\n"
>  		"          -a reset all instances (except top one)\n"
>  		"          -t reset the top level instance (useful with -B or -a)\n"
> +		"          -k keep dynamic event during reset. Valid values are:\n"
> +		"              'kprobe', 'kretprobe', 'uprobe', 'uretprobe',\n"
> +		"              'eprobe', 'synth' and 'all'.\n"
>  	},
>  	{
>  		"clear",

Could you send a patch that updates the man page:

   Documentation/trace-cmd/trace-cmd-reset.1.txt

As well as one that handles bash completion, so people don't need to
remember what to type.

   tracecmd/trace-cmd.bash

Thanks,

-- Steve

