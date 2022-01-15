Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181ACC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiAOQUh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:20:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41844 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbiAOQUh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:20:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37260B8006F
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 16:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E449C36AE3;
        Sat, 15 Jan 2022 16:20:34 +0000 (UTC)
Date:   Sat, 15 Jan 2022 11:20:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 25/25] trace-cmd report: Add new parameter for trace
 file version
Message-ID: <20220115112032.177cdd8f@gandalf.local.home>
In-Reply-To: <20211210105448.97850-26-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-26-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:48 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> By default, "trace-cmd report" writes in trace file version 6.

I think you mean "trace-cmd record" (and for the subject as well).

> A new parameter is added, which can be used to set desired version
> the output trace file.

space

>  "trace-cmd report --file-version <version>"

   "trace-cmd record --file-version <version>"

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 22 +++++++++++++++++++++-
>  tracecmd/trace-usage.c  |  2 +-
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 8567ae5c..1b806e78 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3698,6 +3698,8 @@ static struct tracecmd_output *create_net_output(struct common_record_context *c
>  	out = tracecmd_output_create(NULL);
>  	if (!out)
>  		return NULL;
> +	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
> +		goto error;
>  	if (tracecmd_output_set_msg(out, msg_handle))
>  		goto error;
>  	if (tracecmd_output_write_headers(out, listed_events))
> @@ -3744,6 +3746,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
>  		network_handle = tracecmd_output_create_fd(msg_handle->fd);
>  		if (!network_handle)
>  			goto error;
> +		if (tracecmd_output_set_version(network_handle, ctx->file_version))
> +			goto error;
>  		if (tracecmd_output_write_headers(network_handle, listed_events))
>  			goto error;
>  		tracecmd_set_quiet(network_handle, quiet);
> @@ -4471,7 +4475,8 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
>  	out = tracecmd_output_create(ctx->output);
>  	if (!out)
>  		goto error;
> -
> +	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
> +		goto error;
>  	if (tracecmd_output_write_headers(out, listed_events))
>  		goto error;
>  
> @@ -5780,6 +5785,7 @@ void init_top_instance(void)
>  }
>  
>  enum {
> +	OPT_file_ver		= 238,
>  	OPT_verbose		= 239,
>  	OPT_tsc2nsec		= 240,
>  	OPT_fork		= 241,
> @@ -6219,6 +6225,7 @@ static void parse_record_options(int argc,
>  			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
>  			{"poll", no_argument, NULL, OPT_poll},
>  			{"verbose", optional_argument, NULL, OPT_verbose},
> +			{"file-version", required_argument, NULL, OPT_file_ver},
>  			{NULL, 0, NULL, 0}
>  		};
>  
> @@ -6644,6 +6651,19 @@ static void parse_record_options(int argc,
>  			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
>  			recorder_flags |= TRACECMD_RECORD_POLL;
>  			break;
> +		case OPT_file_ver:
> +			cmd_check_die(ctx, CMD_start, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_set, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_extract, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_stream, *(argv+1), "--file_version");
> +			cmd_check_die(ctx, CMD_profile, *(argv+1), "--file_version");

Perhaps we should have something that just tests against record, instead of
listing everything that isn't record?

-- Steve

> +			ctx->file_version = atoi(optarg);
> +			if (ctx->file_version < FILE_VERSION_MIN ||
> +			    ctx->file_version > FILE_VERSION_MAX)
> +				die("Unsupported file version %d, "
> +				    "supported versions are from %d to %d",
> +				    ctx->file_version, FILE_VERSION_MIN, FILE_VERSION_MAX);
> +			break;
>  		case OPT_quiet:
>  		case 'q':
>  			quiet = true;
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 32b38bfd..ac12b066 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -69,7 +69,7 @@ static struct usage_help usage_help[] = {
>  		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
>  		"                                                         at the beginnig and at the end of the trace\n"
>  		"          --poll don't block while reading from the trace buffer\n"
> -		"          --verbose 'level' Set the desired log level\n"
> +		"          --file-version set the desired trace file version\n"
>  	},
>  	{
>  		"set",

