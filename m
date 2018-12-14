Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbeLNRrc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 12:47:32 -0500
Date: Fri, 14 Dec 2018 12:47:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com
Subject: Re: [PATCH v4 2/3] trace-cmd: Fix record --date flag when sending
 tracing data to a listener
Message-ID: <20181214124729.3c4f931b@gandalf.local.home>
In-Reply-To: <20181214135749.12328-3-kaslevs@vmware.com>
References: <20181214135749.12328-1-kaslevs@vmware.com>
        <20181214135749.12328-3-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 14 Dec 2018 15:57:48 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index a13b83b..57151ba 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -624,8 +624,9 @@ static void stop_all_readers(int cpus, int *pid_array)
>  }
>  
>  static int put_together_file(int cpus, int ofd, const char *node,
> -			      const char *port)
> +			     const char *port, bool write_options)
>  {
> +	struct tracecmd_output *handle;
>  	char **temp_files;
>  	int cpu;
>  	int ret = -ENOMEM;
> @@ -641,9 +642,20 @@ static int put_together_file(int cpus, int ofd, const char *node,
>  			goto out;
>  	}
>  
> -	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
> -	ret = 0;
> - out:
> +	handle = tracecmd_get_output_handle_fd(ofd);
> +	if (!handle) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	if (write_options) {
> +		tracecmd_write_cpus(handle, cpus);
> +		tracecmd_write_options(handle);
> +	}
> +	ret = tracecmd_write_cpu_data(handle, cpus, temp_files);
> +
> +out:
> +	tracecmd_output_close(handle);
>  	for (cpu--; cpu >= 0; cpu--) {
>  		put_temp_file(temp_files[cpu]);
>  	}
> @@ -692,7 +704,8 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
>  	/* wait a little to have the readers clean up */
>  	sleep(1);
>  
> -	ret = put_together_file(cpus, ofd, node, port);
> +	ret = put_together_file(cpus, ofd, node, port,
> +				msg_handle->version != 3);

Couple of thing here. Just to have it be a bit more self explanatory,
let's create a "write_options" variable for process_client(), set it,
and pass that to put_together_file(). The compiler should optimize it
out, so it's not going to affect code execution, but still is good to
see why we are doing the above test.

Second, let's make it "< 3" instead of "!= 3", because I'm sure v4 will
still do this too.

	write_options = msg_handle->version < 3;

	ret = put_together_file(cpus, ofd, node, port, write_options);


>  
>  	destroy_all_readers(cpus, pid_array, node, port);
> 


> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 129f36a..f19341b 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -2879,8 +2879,10 @@ again:
>  	return msg_handle;
>  }
>  
> +static void add_options(struct tracecmd_output *handle, char *date2ts, int flags);
> +
>  static struct tracecmd_msg_handle *
> -setup_connection(struct buffer_instance *instance)
> +setup_connection(struct buffer_instance *instance, char *date2ts, int flags)
>  {
>  	struct tracecmd_msg_handle *msg_handle;
>  	struct tracecmd_output *network_handle;
> @@ -2890,6 +2892,11 @@ setup_connection(struct buffer_instance *instance)
>  	/* Now create the handle through this socket */
>  	if (msg_handle->version == V3_PROTOCOL) {
>  		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
> +		if (msg_handle->version == 3) {

Probably should add a comment here, as to why we are checking (for
bisectability).

Since these are slight changes, I'll make the changes and add the
patch, as Yordan needs these changes quickly. Unless...

I haven't taken a look at patch 3 yet, so if there's an issue there,
then we can make these updates for v5.

-- Steve


> +			add_options(network_handle, date2ts, flags);
> +			tracecmd_write_cpus(network_handle, instance->cpu_count);
> +			tracecmd_write_options(network_handle);
> +		}
>  		tracecmd_msg_finish_sending_data(msg_handle);
>  	} else
>  		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
> @@ -2909,7 +2916,7 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
>  	free(host);
>  }
>  
> -void start_threads(enum trace_type type, int global)
> +void start_threads(enum trace_type type, int global, char *date2ts, int flags)
>  {
>  	struct buffer_instance *instance;
>  	int *brass = NULL;
> @@ -2931,7 +2938,7 @@ void start_threads(enum trace_type type, int global)
>  		int x, pid;
>  
>  		if (host) {
> -			instance->msg_handle = setup_connection(instance);
> +			instance->msg_handle = setup_connection(instance, date2ts, flags);
>  			if (!instance->msg_handle)
>  				die("Failed to make connection");
>  		}
> @@ -3085,6 +3092,26 @@ enum {
>  	DATA_FL_OFFSET		= 2,
>  };
>  
> +static void add_options(struct tracecmd_output *handle, char *date2ts, int flags)
> +{
> +	int type = 0;
> +
> +	if (date2ts) {
> +		if (flags & DATA_FL_DATE)
> +			type = TRACECMD_OPTION_DATE;
> +		else if (flags & DATA_FL_OFFSET)
> +			type = TRACECMD_OPTION_OFFSET;
> +	}
> +
> +	if (type)
> +		tracecmd_add_option(handle, type, strlen(date2ts)+1, date2ts);
> +
> +	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
> +	add_option_hooks(handle);
> +	add_uname(handle);
> +
> +}
> +
>  static void record_data(char *date2ts, int flags)
>  {
>  	struct tracecmd_option **buffer_options;
> @@ -3140,18 +3167,7 @@ static void record_data(char *date2ts, int flags)
>  		if (!handle)
>  			die("Error creating output file");
>  
> -		if (date2ts) {
> -			int type = 0;
> -
> -			if (flags & DATA_FL_DATE)
> -				type = TRACECMD_OPTION_DATE;
> -			else if (flags & DATA_FL_OFFSET)
> -				type = TRACECMD_OPTION_OFFSET;
> -
> -			if (type)
> -				tracecmd_add_option(handle, type,
> -						    strlen(date2ts)+1, date2ts);
> -		}
> +		add_options(handle, date2ts, flags);
>  
>  		/* Only record the top instance under TRACECMD_OPTION_CPUSTAT*/
>  		if (!no_top_instance() && !top_instance.msg_handle) {
> @@ -3162,13 +3178,6 @@ static void record_data(char *date2ts, int flags)
>  						    s[i].len+1, s[i].buffer);
>  		}
>  
> -		tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK,
> -				    0, NULL);
> -
> -		add_option_hooks(handle);
> -
> -		add_uname(handle);
> -
>  		if (buffers) {
>  			buffer_options = malloc(sizeof(*buffer_options) * buffers);
>  			if (!buffer_options)
> @@ -4977,7 +4986,7 @@ static void record_trace(int argc, char **argv,
>  	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
>  		signal(SIGINT, finish);
>  		if (!latency)
> -			start_threads(type, ctx->global);
> +			start_threads(type, ctx->global, ctx->date2ts, ctx->data_flags);
>  	} else {
>  		update_task_filter();
>  		tracecmd_enable_tracing();
