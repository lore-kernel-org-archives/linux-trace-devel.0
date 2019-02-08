Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCBFC169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 21:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D0E020863
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 21:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfBHVjR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 16:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbfBHVjR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 16:39:17 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60D72084D;
        Fri,  8 Feb 2019 21:39:15 +0000 (UTC)
Date:   Fri, 8 Feb 2019 16:39:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/7] trace-cmd: Added support for negative time
 offsets in trace.dat file
Message-ID: <20190208163914.220ffcb8@gandalf.local.home>
In-Reply-To: <20190208134918.5618-3-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
        <20190208134918.5618-3-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Feb 2019 15:49:13 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> When synchronizing timestamps between different machines, there are cases
> when the time offset is negative. This patch changes the way time offset is
> written and read from trace.dat file - as signed decimal, instead of hex.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h |   2 +-
>  lib/trace-cmd/trace-input.c   |   6 +-
>  tracecmd/trace-read.c         |   4 +-
>  tracecmd/trace-record.c       | 120 +++++++++++++++++-----------------
>  4 files changed, 66 insertions(+), 66 deletions(-)

Can you break this patch into two. One that moves the code around, and
the other that makes the changes. It's easier to review and see what
changed that way.

Thanks!

-- Steve

> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 3d72430..b2ff6f9 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -126,7 +126,7 @@ int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
>  void tracecmd_create_top_instance(char *name);
>  void tracecmd_remove_instances(void);
>  
> -void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
> +void tracecmd_set_ts_offset(struct tracecmd_input *handle, long long offset);
>  void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
>  
>  void tracecmd_print_events(struct tracecmd_input *handle, const char *regex);
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index b628570..33ad7d1 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -100,7 +100,7 @@ struct tracecmd_input {
>  	bool			read_page;
>  	bool			use_pipe;
>  	struct cpu_data 	*cpu_data;
> -	unsigned long long	ts_offset;
> +	long long		ts_offset;
>  	double			ts2secs;
>  	char *			cpustats;
>  	char *			uname;
> @@ -2091,7 +2091,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
>  }
>  
>  void tracecmd_set_ts_offset(struct tracecmd_input *handle,
> -			    unsigned long long offset)
> +			    long long offset)
>  {
>  	handle->ts_offset = offset;
>  }
> @@ -2108,7 +2108,7 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
>  
>  static int handle_options(struct tracecmd_input *handle)
>  {
> -	unsigned long long offset;
> +	long long offset;
>  	unsigned short option;
>  	unsigned int size;
>  	char *cpustats = NULL;
> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index 804022a..e309672 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -58,7 +58,7 @@ static struct list_head handle_list;
>  struct input_files {
>  	struct list_head	list;
>  	const char		*file;
> -	unsigned long long	tsoffset;
> +	long long		tsoffset;
>  	unsigned long long	ts2secs;
>  };
>  static struct list_head input_files;
> @@ -1413,7 +1413,7 @@ void trace_report (int argc, char **argv)
>  	struct input_files *inputs;
>  	struct handle_list *handles;
>  	enum output_type otype;
> -	unsigned long long tsoffset = 0;
> +	long long tsoffset = 0;
>  	unsigned long long ts2secs = 0;
>  	unsigned long long ts2sc;
>  	int show_stat = 0;
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 43d782e..01b360a 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -203,6 +203,12 @@ enum trace_cmd {
>  	CMD_record_agent,
>  };
>  
> +enum {
> +	DATA_FL_NONE		= 0,
> +	DATA_FL_DATE		= 1,
> +	DATA_FL_OFFSET		= 2,
> +};
> +
>  struct common_record_context {
>  	enum trace_cmd curr_cmd;
>  	struct buffer_instance *instance;
> @@ -3234,7 +3240,60 @@ again:
>  	return msg_handle;
>  }
>  
> -static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
> +static void add_option_hooks(struct tracecmd_output *handle)
> +{
> +	struct hook_list *hook;
> +	int len;
> +
> +	for (hook = hooks; hook; hook = hook->next) {
> +		len = strlen(hook->hook);
> +		tracecmd_add_option(handle, TRACECMD_OPTION_HOOK,
> +				    len + 1, hook->hook);
> +	}
> +}
> +
> +static void add_uname(struct tracecmd_output *handle)
> +{
> +	struct utsname buf;
> +	char *str;
> +	int len;
> +	int ret;
> +
> +	ret = uname(&buf);
> +	/* if this fails for some reason, just ignore it */
> +	if (ret < 0)
> +		return;
> +
> +	len = strlen(buf.sysname) + strlen(buf.nodename) +
> +		strlen(buf.release) + strlen(buf.machine) + 4;
> +	str = malloc(len);
> +	if (!str)
> +		return;
> +	sprintf(str, "%s %s %s %s", buf.sysname, buf.nodename, buf.release, buf.machine);
> +	tracecmd_add_option(handle, TRACECMD_OPTION_UNAME, len, str);
> +	free(str);
> +}
> +
> +static void add_options(struct tracecmd_output *handle,
> +			struct common_record_context *ctx)
> +{
> +	int type = 0;
> +
> +	if (ctx->date2ts) {
> +		if (ctx->data_flags & DATA_FL_DATE)
> +			type = TRACECMD_OPTION_DATE;
> +		else if (ctx->data_flags & DATA_FL_OFFSET)
> +			type = TRACECMD_OPTION_OFFSET;
> +	}
> +
> +	if (type)
> +		tracecmd_add_option(handle, type,
> +				    strlen(ctx->date2ts)+1, ctx->date2ts);
> +
> +	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
> +	add_option_hooks(handle);
> +	add_uname(handle);
> +}
>  
>  static struct tracecmd_msg_handle *
>  setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
> @@ -3505,40 +3564,6 @@ add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance
>  				    instance->s_save[i].buffer);
>  }
>  
> -static void add_option_hooks(struct tracecmd_output *handle)
> -{
> -	struct hook_list *hook;
> -	int len;
> -
> -	for (hook = hooks; hook; hook = hook->next) {
> -		len = strlen(hook->hook);
> -		tracecmd_add_option(handle, TRACECMD_OPTION_HOOK,
> -				    len + 1, hook->hook);
> -	}
> -}
> -
> -static void add_uname(struct tracecmd_output *handle)
> -{
> -	struct utsname buf;
> -	char *str;
> -	int len;
> -	int ret;
> -
> -	ret = uname(&buf);
> -	/* if this fails for some reason, just ignore it */
> -	if (ret < 0)
> -		return;
> -
> -	len = strlen(buf.sysname) + strlen(buf.nodename) +
> -		strlen(buf.release) + strlen(buf.machine) + 4;
> -	str = malloc(len);
> -	if (!str)
> -		return;
> -	sprintf(str, "%s %s %s %s", buf.sysname, buf.nodename, buf.release, buf.machine);
> -	tracecmd_add_option(handle, TRACECMD_OPTION_UNAME, len, str);
> -	free(str);
> -}
> -
>  static void print_stat(struct buffer_instance *instance)
>  {
>  	int cpu;
> @@ -3553,31 +3578,6 @@ static void print_stat(struct buffer_instance *instance)
>  		trace_seq_do_printf(&instance->s_print[cpu]);
>  }
>  
> -enum {
> -	DATA_FL_NONE		= 0,
> -	DATA_FL_DATE		= 1,
> -	DATA_FL_OFFSET		= 2,
> -};
> -
> -static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
> -{
> -	int type = 0;
> -
> -	if (ctx->date2ts) {
> -		if (ctx->data_flags & DATA_FL_DATE)
> -			type = TRACECMD_OPTION_DATE;
> -		else if (ctx->data_flags & DATA_FL_OFFSET)
> -			type = TRACECMD_OPTION_OFFSET;
> -	}
> -
> -	if (type)
> -		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
> -
> -	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
> -	add_option_hooks(handle);
> -	add_uname(handle);
> -}
> -
>  static void write_guest_file(struct buffer_instance *instance)
>  {
>  	struct tracecmd_output *handle;

