Return-Path: <SRS0=uy/X=6E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A29C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 21:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F04952078C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 21:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgDTVHI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 17:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgDTVHI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 17:07:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BCC20724;
        Mon, 20 Apr 2020 21:07:07 +0000 (UTC)
Date:   Mon, 20 Apr 2020 17:07:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bijan Tabatabai <bijan311@yahoo.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Stop recording when processes traced with -P
 exit
Message-ID: <20200420170706.0d813d96@gandalf.local.home>
In-Reply-To: <20200418163605.32461-1-bijan311@yahoo.com>
References: <20200418163605.32461-1-bijan311.ref@yahoo.com>
        <20200418163605.32461-1-bijan311@yahoo.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 18 Apr 2020 11:36:05 -0500
Bijan Tabatabai <bijan311@yahoo.com> wrote:

> When the -F flag is used in trace-cmd record, trace-cmd stops recording
> when the executable it is tracing terminates.
> This patch makes the -P flag act similarly.

I don't mind the idea, but I'm worried about this approach.

> 
> Signed-off-by: Bijan Tabatabai <bijan311@yahoo.com>
> ---
>  tracecmd/trace-record.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index d89b32d..b5cd4c4 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -121,8 +121,10 @@ struct filter_pids {
>  };
>  
>  static struct filter_pids *filter_pids;
> +static struct filter_pids *process_pids;
>  static int nr_filter_pids;
>  static int len_filter_pids;
> +static int nr_process_pids = 0;
>  
>  static int have_set_event_pid;
>  static int have_event_fork;
> @@ -5799,7 +5801,9 @@ static void parse_record_options(int argc,
>  			while (pid) {
>  				add_filter_pid(atoi(pid), 0);
>  				pid = strtok_r(NULL, ",", &sav);
> +				nr_process_pids++;
>  			}
> +			process_pids = filter_pids;
>  			free(pids);
>  			break;
>  		case 'c':
> @@ -6273,10 +6277,19 @@ static void record_trace(int argc, char **argv,
>  					ptrace_attach(pid->pid);
>  			}
>  		}
> -		/* sleep till we are woken with Ctrl^C */
> -		printf("Hit Ctrl^C to stop recording\n");
> -		while (!finished)
> -			trace_or_sleep(type);
> +		if (nr_process_pids) {
> +			for (pid = process_pids; pid && nr_process_pids; pid = pid->next) {
> +				if (!pid->exclude)
> +					/* Wait for the process to end */
> +					while(!kill(pid->pid, 0));

Won't that while loop just go into a spin?

What about something like a fsnotify on a /proc/<pid>/ file?

I rather have trace-cmd sleep and wake up when a task exits, than to do a
spin. Like it does for the -F option.

Thanks!

-- Steve


> +				nr_process_pids--;
> +			}
> +		} else {
> +			/* sleep till we are woken with Ctrl^C */
> +			printf("Hit Ctrl^C to stop recording\n");
> +			while (!finished)
> +				trace_or_sleep(type);
> +		}
>  	}
>  
>  	tell_guests_to_stop();

