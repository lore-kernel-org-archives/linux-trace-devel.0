Return-Path: <SRS0=dEKL=OV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:37318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbeLLQRO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Dec 2018 11:17:14 -0500
Date: Wed, 12 Dec 2018 11:17:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] trace-cmd: Fix record --date flag when sending
 tracing data to a listener
Message-ID: <20181212111711.30990a0f@gandalf.local.home>
In-Reply-To: <20181205091524.4789-4-kaslevs@vmware.com>
References: <20181205091524.4789-1-kaslevs@vmware.com>
        <20181205091524.4789-4-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed,  5 Dec 2018 11:15:24 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h |  7 +++--
>  tracecmd/trace-listen.c       |  7 +++--
>  tracecmd/trace-output.c       | 24 ++++++++++++----
>  tracecmd/trace-record.c       | 52 +++++++++++++++++++----------------
>  4 files changed, 57 insertions(+), 33 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 7cce592..7dc1fb4 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -245,6 +245,7 @@ struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
>  					    const void *data);
>  struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
>  						   const char *name, int cpus);
> +int tracecmd_write_options(struct tracecmd_output *handle, int cpus);
>  int tracecmd_update_option(struct tracecmd_output *handle,
>  			   struct tracecmd_option *option, int size,
>  			   const void *data);
> @@ -257,8 +258,10 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
>  				    struct tracecmd_option *option,
>  				    int cpus, char * const *cpu_data_files);
> -int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files);
> -int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files);
> +int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files,
> +			     bool write_options);
> +int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files,
> +				bool write_options);
>  
>  /* --- Reading the Fly Recorder Trace --- */
>  
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index b5379f5..83fd5d1 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -624,7 +624,7 @@ static void stop_all_readers(int cpus, int *pid_array)
>  }
>  
>  static int put_together_file(int cpus, int ofd, const char *node,
> -			      const char *port)
> +			     const char *port, bool write_options)

I'd like to avoid passing arguments like this if we can avoid it. And I
think we can, by breaking up the current functions.

The tracecmd_attach_cpu_data_*() was attempting to do too much without
the callers having to deal with handles. But I think that's a mistake,
because it turns this into hacks.


>  {
>  	char **temp_files;
>  	int cpu;
> @@ -641,7 +641,7 @@ static int put_together_file(int cpus, int ofd, const char *node,
>  			goto out;
>  	}
>  
> -	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
> +	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files, write_options);

Let's break this function up, and have the caller deal with a
tracecmd_output *handle.

We can have:

	handle = tracecmd_get_output_handle_fd(ofd);
	if (write_options) {
		tracecmd_write_cpus(handle, cpus);
		tracecmd_write_options(handle);
	}
	tracecmd_write_cpu_data(handle, cpus, temp_files);

Also, let's have this patch come before patch 2/3, such that there's no
path to write the options until the boosting to v3.

-- Steve


>  	ret = 0;
>   out:
>  	for (cpu--; cpu >= 0; cpu--) {
> @@ -692,7 +692,8 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
>  	/* wait a little to have the readers clean up */
>  	sleep(1);
>  
> -	ret = put_together_file(cpus, ofd, node, port);
> +	ret = put_together_file(cpus, ofd, node, port,
> +				msg_handle->version != V3_PROTOCOL);
>  
>  	destroy_all_readers(cpus, pid_array, node, port);
>  
