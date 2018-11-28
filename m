Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:60692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbeK1OVR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 09:21:17 -0500
Date: Tue, 27 Nov 2018 22:21:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: kaslevs@vmware.com
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix record --date flag when sending tracing
 data to a listener
Message-ID: <20181127222112.7e07774c@vmware.local.home>
In-Reply-To: <20181114154328.14731-1-kaslevs@vmware.com>
References: <20181114154328.14731-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Hi Slavomir,

One minor nit of this patch.

On Wed, 14 Nov 2018 17:43:28 +0200
kaslevs@vmware.com wrote:

> diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
> index 078ed5e..2e8031c 100644
> --- a/lib/traceevent/event-parse.c
> +++ b/lib/traceevent/event-parse.c
> @@ -5411,7 +5411,7 @@ void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
>  
>  static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
>  {
> -	if (!use_trace_clock)
> +	if (!trace_clock || !use_trace_clock)
>  		return true;
>  
>  	if (!strcmp(trace_clock, "local") || !strcmp(trace_clock, "global")

This should be a separate patch, and it needs to be pushed to the Linux
kernel. Can you work with Tzvetomir in doing it?

Thanks!

-- Steve
