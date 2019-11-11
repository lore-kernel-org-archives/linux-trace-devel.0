Return-Path: <SRS0=zoIR=ZD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E25C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Nov 2019 22:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7065420659
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Nov 2019 22:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfKKWwG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 17:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbfKKWwG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 17:52:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F06B3214DB;
        Mon, 11 Nov 2019 22:52:04 +0000 (UTC)
Date:   Mon, 11 Nov 2019 17:52:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     vincent.donnefort@arm.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Message-ID: <20191111175203.252cc439@gandalf.local.home>
In-Reply-To: <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
        <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Nov 2019 10:51:06 +0000
vincent.donnefort@arm.com wrote:

> From: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> The tracing file saved_cmdlines_size allows setting the number of entries
> that saved_cmdlines will contain. The latter is then dumped into the
> trace.dat file to map PIDs with comm. The default value is 128.
> 
> Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 7260d27..a4e10a4 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -229,6 +229,7 @@ struct common_record_context {
>  	int topt;
>  	int do_child;
>  	int run_command;
> +	int saved_cmdlines_size;
>  };
>  
>  static void add_reset_file(const char *file, const char *val, int prio)
> @@ -1810,6 +1811,39 @@ static void set_options(void)
>  	}
>  }
>  
> +static void set_saved_cmdlines_size(struct common_record_context *ctx)
> +{
> +	char *path, *str;
> +	int fd, len, ret;
> +
> +	if (!ctx->saved_cmdlines_size)
> +		return;
> +
> +	path = tracecmd_get_tracing_file("saved_cmdlines_size");
> +	if (!path)
> +		goto err;
> +
> +	reset_save_file(path, RESET_DEFAULT_PRIO);
> +
> +	fd = open(path, O_WRONLY);
> +	tracecmd_put_tracing_file(path);
> +	if (fd < 0)
> +		goto err;
> +
> +	len = asprintf(&str, "%d", ctx->saved_cmdlines_size);
> +	if (len < 0)
> +		die("%s couldn't allocate memory", __func__);
> +
> +	if (write(fd, str, len) > 0)
> +		ret = 0;
> +
> +	close(fd);
> +	free(str);
> +err:
> +	if (ret)
> +		warning("Couldn't set saved_cmdlines_size");
> +}
> +
>  static int trace_check_file_exists(struct buffer_instance *instance, char *file)
>  {
>  	struct stat st;
> @@ -5480,7 +5514,7 @@ static void parse_record_options(int argc,
>  		if (IS_EXTRACT(ctx))
>  			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
>  		else
> -			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
> +			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:kK:sSiTm:M:H:qK";
>  		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
>  		if (c == -1)
>  			break;
> @@ -5741,6 +5775,9 @@ static void parse_record_options(int argc,
>  		case 'k':
>  			keep = 1;
>  			break;
> +		case 'K':
> +			ctx->saved_cmdlines_size = atoi(optarg);
> +			break;

Perhaps we should make this a long variable --cmdline-size(?), and not
yet give it a short option. 

>  		case 'i':
>  			ignore_event_not_found = 1;
>  			break;
> @@ -5990,6 +6027,7 @@ static void record_trace(int argc, char **argv,
>  			enable_events(instance);
>  	}
>  
> +	set_saved_cmdlines_size(ctx);
>  	set_buffer_size();
>  	update_plugins(type);
>  	set_options();
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index b5788f7..ddfb480 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -47,6 +47,7 @@ static struct usage_help usage_help[] = {
>  		"          -b change kernel buffersize (in kilobytes per CPU)\n"
>  		"          -B create sub buffer and following events will be enabled here\n"
>  		"          -k do not reset the buffers after tracing.\n"
> +		"          -K change kernel saved_cmdlines_size\n"

We would also want to update the man pages too.

Thanks!

-- Steve

>  		"          -i do not fail if an event is not found\n"
>  		"          -q print no output to the screen\n"
>  		"          --quiet print no output to the screen\n"

