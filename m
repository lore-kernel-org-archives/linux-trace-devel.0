Return-Path: <SRS0=a/08=Z3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2166AC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 00:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E70CE24667
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 00:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfLEA7y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 19:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbfLEA7y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 19:59:54 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A8224667;
        Thu,  5 Dec 2019 00:59:52 +0000 (UTC)
Date:   Wed, 4 Dec 2019 19:59:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 13/18] trace-cmd: Add guest information in host's
 trace.dat file
Message-ID: <20191204195951.15e6f0b9@gandalf.local.home>
In-Reply-To: <20191203103522.482684-14-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-14-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:17 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> New trace.dat option is introduced: TRACECMD_OPTION_GUEST.
> Written in the host's trace.dat file, it contains information about
> guests, traced at the same time: guest trace ID, number of VCPUs and
> PIDs of the host tasks, running those VCPU. The data is stored in
> the file as NULL terminated string:
> 	"Guest %s %llu %d\n" -> guest name, number of VCPUs
> 	"%d %d\n" -> VCPU, PID of host task
> 	.....
> 	"%d %d\n" -> VCPU, PID of host task
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h |   1 +
>  lib/trace-cmd/trace-input.c   | 113 ++++++++++++++++++++++++++++++++++
>  tracecmd/trace-record.c       |  45 ++++++++++++++
>  3 files changed, 159 insertions(+)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 1240b4a..17badf2 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -88,6 +88,7 @@ enum {
>  	TRACECMD_OPTION_PROCMAPS,
>  	TRACECMD_OPTION_TRACEID,
>  	TRACECMD_OPTION_TIME_SHIFT,
> +	TRACECMD_OPTION_GUEST,
>  };
>  
>  enum {
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index a6b675a..e36ebaa 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -79,6 +79,14 @@ struct ts_offset_sample {
>  	long long	offset;
>  };
>  
> +struct guest_trace_info {
> +	struct guest_trace_info	*next;
> +	char			*name;
> +	unsigned long long	trace_id;
> +	int			vcpu_count;
> +	int			*cpu_pid;
> +};
> +
>  struct host_trace_info {
>  	bool			sync_enable;
>  	unsigned long long	trace_id;
> @@ -112,6 +120,7 @@ struct tracecmd_input {
>  	char *			trace_clock;
>  	struct input_buffer_instance	*buffers;
>  	int			parsing_failures;
> +	struct guest_trace_info	*guest;
>  
>  	struct tracecmd_ftrace	finfo;
>  
> @@ -2294,6 +2303,73 @@ static int trace_traceid_load(struct tracecmd_input *handle, char *buf)
>  	return -1;
>  }
>  
> +static void trace_guests_free(struct tracecmd_input *handle)
> +{
> +	struct guest_trace_info *guest;
> +
> +	while (handle->guest) {
> +		guest = handle->guest;
> +		handle->guest = handle->guest->next;
> +		free(guest->name);
> +		free(guest->cpu_pid);
> +		free(guest);
> +	}
> +}
> +
> +static int trace_guest_load(struct tracecmd_input *handle, char *buf)
> +{
> +	struct guest_trace_info *guest = NULL;
> +	unsigned long long tid;
> +	char *line;
> +	int cpu, pid;
> +
> +	line = strchr(buf, '\n');
> +	if (!line)
> +		goto error;
> +	*line = '\0';
> +
> +	guest = calloc(1, sizeof(struct guest_trace_info));
> +	if (!guest)
> +		goto error;
> +
> +	if (sscanf(buf, "%*s %ms %llu %d", &guest->name, &tid, &cpu) != 3)
> +		goto error;
> +	guest->trace_id = tid;
> +	guest->vcpu_count = cpu;
> +
> +	guest->cpu_pid = calloc(guest->vcpu_count, sizeof(int));
> +	if (!guest->cpu_pid)
> +		goto error;
> +
> +	buf = line + 1;
> +	line = strchr(buf, '\n');
> +	while (line) {
> +		*line = '\0';
> +		if (sscanf(buf, "%d %d", &cpu, &pid) != 2)
> +			goto error;
> +
> +		if (cpu < guest->vcpu_count)
> +			guest->cpu_pid[cpu] = pid;
> +		buf = line + 1;
> +		if (!*buf)
> +			break;
> +
> +		line = strchr(buf, '\n');

Hmm, strtok_r() seems more appropriate here than strchr(), then you
don't need to deal with the *line = '\0'.


> +	}
> +
> +	guest->next = handle->guest;
> +	handle->guest = guest;
> +	return 0;
> +
> +error:
> +	if (guest) {
> +		free(guest->cpu_pid);
> +		free(guest->name);
> +		free(guest);
> +	}
> +	return -1;
> +}
> +
>  #define STR_PROCMAP_LINE_MAX	(PATH_MAX+22)
>  static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
>  {
> @@ -2558,6 +2634,10 @@ static int handle_options(struct tracecmd_input *handle)
>  			if (buf[size-1] == '\0')
>  				trace_traceid_load(handle, buf);
>  			break;
> +		case TRACECMD_OPTION_GUEST:
> +			if (buf[size-1] == '\0')
> +				trace_guest_load(handle, buf);
> +			break;
>  		default:
>  			warning("unknown option %d", option);
>  			break;
> @@ -3217,6 +3297,7 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	handle->pid_maps = NULL;
>  
>  	trace_tsync_offset_free(&handle->host);
> +	trace_guests_free(handle);
>  
>  	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
>  		tracecmd_close(handle->parent);
> @@ -3673,6 +3754,38 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
>  	return handle->trace_id;
>  }
>  
> +/**
> + * tracecmd_get_guest_cpumap - get the mapping of guest VCPU to host process
> + * @handle: input handle for the trace.dat file
> + * @trace_id: ID of the guest tracing session

@name, @vcpu_count, and @cpu_pid should still be up in the above
section.

> + *
> + * Returns @name of the guest, number of VPUs (@vcpu_count)
> + * and array @cpu_pid with size @vcpu_count. Array index is VCPU id, array
> + * content is PID of the host process, running this VCPU.
> + *
> + * This information is stored in host trace.dat file
> + */
> +int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
> +			      unsigned long long trace_id,
> +			      char *name,

name isn't returned.

> +			      int *vcpu_count, int *cpu_pid)
> +{
> +	struct guest_trace_info	*guest = handle->guest;
> +
> +	while (guest) {
> +		if (guest->trace_id == trace_id)
> +			break;
> +		guest = guest->next;
> +	}
> +	if (!guest)
> +		return -1;
> +
> +	name = guest->name;

The above doesn't do anything, and will probably be optimized out by
the compiler.

-- Steve


> +	*vcpu_count = guest->vcpu_count;
> +	cpu_pid = guest->cpu_pid;
> +	return 0;
> +}
> +
>  /**
>   * tracecmd_get_tsync_peer - get the trace session id of the peer host
>   * @handle: input handle for the trace.dat file
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index e51134f..49730d6 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -2884,6 +2884,19 @@ struct guest {
>  static struct guest *guests;
>  static size_t guests_len;
>  
> +static struct guest *get_guest_info(unsigned int guest_cid)
> +{
> +	int i;
> +
> +	if (!guests)
> +		return NULL;
> +
> +	for (i = 0; i < guests_len; i++)
> +		if (guest_cid == guests[i].cid)
> +			return guests + i;
> +	return NULL;
> +}
> +
>  static char *get_qemu_guest_name(char *arg)
>  {
>  	char *tok, *end = arg;
> @@ -3689,6 +3702,33 @@ static void append_buffer(struct tracecmd_output *handle,
>  	}
>  }
>  
> +static void
> +add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
> +{
> +	struct guest *guest = get_guest_info(instance->cid);
> +	struct trace_seq s;
> +	int i;
> +
> +	if (!guest)
> +		return;
> +	for (i = 0; i < VCPUS_MAX; i++)
> +		if (!guest->cpu_pid[i])
> +			break;
> +
> +	trace_seq_init(&s);
> +
> +	trace_seq_printf(&s, "Guest %s %llu %d\n",
> +			 guest->name, instance->trace_id, i);
> +	for (i = 0; i < VCPUS_MAX; i++) {
> +		if (!guest->cpu_pid[i])
> +			break;
> +		trace_seq_printf(&s, "%d %d\n", i, guest->cpu_pid[i]);
> +	}
> +	trace_seq_terminate(&s);
> +	tracecmd_add_option(handle, TRACECMD_OPTION_GUEST,
> +			    s.len + 1, s.buffer);
> +	trace_seq_destroy(&s);
> +}
>  
>  static void
>  add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
> @@ -3976,6 +4016,11 @@ static void record_data(struct common_record_context *ctx)
>  			add_pid_maps(handle, instance);
>  		}
>  
> +		for_all_instances(instance) {
> +			if (is_guest(instance))
> +				add_guest_info(handle, instance);
> +		}
> +
>  		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
>  
>  		for (i = 0; i < max_cpu_count; i++)

