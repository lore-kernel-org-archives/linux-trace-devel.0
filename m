Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C73AC10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442B420821
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbfDPVtm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 17:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbfDPVtm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 17:49:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C4320821;
        Tue, 16 Apr 2019 21:49:40 +0000 (UTC)
Date:   Tue, 16 Apr 2019 17:49:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: Re: [PATCH v3 2/2] trace-cmd: Add --no-filter option to not filter
 recording processes
Message-ID: <20190416174939.7622c984@gandalf.local.home>
In-Reply-To: <20190415230016.13932-3-kaslevs@vmware.com>
References: <20190415230016.13932-1-kaslevs@vmware.com>
        <20190415230016.13932-3-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 16 Apr 2019 02:00:16 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Add --no-filter option which doesn't install filters for the trace-cmd recording
> processes pids.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

I'll apply this, but we should also update the man page.

-- Steve

> ---
>  tracecmd/trace-record.c | 14 +++++++++++---
>  tracecmd/trace-usage.c  |  1 +
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index dae0396..05a313b 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -86,6 +86,7 @@ static int do_ptrace;
>  
>  static int filter_task;
>  static int filter_pid = -1;
> +static bool no_filter = false;
>  
>  static int local_cpu_count;
>  
> @@ -1063,6 +1064,9 @@ static void update_task_filter(void)
>  	struct buffer_instance *instance;
>  	int pid = getpid();
>  
> +	if (no_filter)
> +		return;
> +
>  	if (filter_task)
>  		add_filter_pid(pid, 0);
>  
> @@ -4377,9 +4381,9 @@ void update_first_instance(struct buffer_instance *instance, int topt)
>  }
>  
>  enum {
> -
> -	OPT_quiet		= 246,
> -	OPT_debug		= 247,
> +	OPT_quiet		= 245,
> +	OPT_debug		= 246,
> +	OPT_no_filter		= 247,
>  	OPT_max_graph_depth	= 248,
>  	OPT_tsoffset		= 249,
>  	OPT_bycomm		= 250,
> @@ -4603,6 +4607,7 @@ static void parse_record_options(int argc,
>  			{"by-comm", no_argument, NULL, OPT_bycomm},
>  			{"ts-offset", required_argument, NULL, OPT_tsoffset},
>  			{"max-graph-depth", required_argument, NULL, OPT_max_graph_depth},
> +			{"no-filter", no_argument, NULL, OPT_no_filter},
>  			{"debug", no_argument, NULL, OPT_debug},
>  			{"quiet", no_argument, NULL, OPT_quiet},
>  			{"help", no_argument, NULL, '?'},
> @@ -4877,6 +4882,9 @@ static void parse_record_options(int argc,
>  			if (!ctx->max_graph_depth)
>  				die("Could not allocate option");
>  			break;
> +		case OPT_no_filter:
> +			no_filter = true;
> +			break;
>  		case OPT_debug:
>  			debug = 1;
>  			break;
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 9ea1906..29a7081 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -56,6 +56,7 @@ static struct usage_help usage_help[] = {
>  		"          --func-stack perform a stack trace for function tracer\n"
>  		"             (use with caution)\n"
>  		"          --max-graph-depth limit function_graph depth\n"
> +		"          --no-filter do not set any event filters\n"
>  	},
>  	{
>  		"start",

