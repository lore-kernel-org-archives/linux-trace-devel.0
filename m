Return-Path: <SRS0=BlfF=Z7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D24C43603
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7DD1206E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfLITbD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfLITbD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 14:31:03 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C863205ED;
        Mon,  9 Dec 2019 19:31:02 +0000 (UTC)
Date:   Mon, 9 Dec 2019 14:31:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 14/18] trace-cmd: Add host trace clock as guest
 trace argument
Message-ID: <20191209143101.146cb619@gandalf.local.home>
In-Reply-To: <20191203103522.482684-15-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-15-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:18 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When tracing host and guest machines, both should use the same
> tracing clock for event timestamps. If a clock is specified
> as host tracing argument, with option "-C clock_name", the same
> is injected as guest tracing argument. If the user wants to use
> different tracing clocks, it can specify it using "-C clock_name"
> as guest tracing argument. In that case, the one specified by
> the user has higher priority.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 49730d6..e7fb1bd 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5405,6 +5405,8 @@ static void parse_record_options(int argc,
>  	char *sav;
>  	int name_counter = 0;
>  	int neg_event = 0;
> +	struct buffer_instance *instance;
> +	bool guest_config = false;

Should have a different name, like "clock_set", as "guest_config"
doesn't let us know what this is about.


>  
>  	init_common_record_context(ctx, curr_cmd);
>  
> @@ -5562,6 +5564,7 @@ static void parse_record_options(int argc,
>  			break;
>  		case 'C':
>  			ctx->instance->ftrace->clock = optarg;
> +			guest_config = true;
>  			break;
>  		case 'v':
>  			neg_event = 1;
> @@ -5779,14 +5782,26 @@ static void parse_record_options(int argc,
>  
>  	/* If --date is specified, prepend it to all guest VM flags */
>  	if (ctx->date) {
> -		struct buffer_instance *instance;
> -
>  		for_all_instances(instance) {
>  			if (is_guest(instance))
>  				add_argv(instance, "--date", true);
>  		}
>  	}
>  
> +	if (guest_config) {
> +		/* If -C is specified, prepend clock to all guest VM flags */
> +		for_all_instances(instance) {
> +			if (top_instance.ftrace->clock) {
> +				if (is_guest(instance)) {

We should only append this, if the guest didn't have a clock set
already. As the change log seems to say, if the user states a "-C
clock" for the guest, that should take precedence over the host clock
set. That is, a user may specifically state that they are using a
different clock. If we have frequency and offset set, it should still
work with different clocks.

-- Steve


> +					add_argv(instance,
> +						 (char *)top_instance.ftrace->clock,
> +						 true);
> +					add_argv(instance, "-C", true);
> +				}
> +			}
> +		}
> +	}
> +
>  	if (!ctx->filtered && ctx->instance->filter_mod)
>  		add_func(&ctx->instance->filter_funcs,
>  			 ctx->instance->filter_mod, "*");

