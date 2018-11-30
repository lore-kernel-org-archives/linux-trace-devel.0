Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbeLADhe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 22:37:34 -0500
Date: Fri, 30 Nov 2018 11:27:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: [PATCH] tools/lib/traceevent: Sanity check of
 is_timestamp_in_us()
Message-ID: <20181130112741.25b55b9b@gandalf.local.home>
In-Reply-To: <20181128144038.21915-1-tstoyanov@vmware.com>
References: <20181128144038.21915-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 28 Nov 2018 14:40:49 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch adds a sanity check of is_timestamp_in_us() input
> parameter trace_clock. It avoids a potential segfailt in this
> function in case trace_clock is NULL.

FYI, I applied this to trace-cmd as well.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 854b68ef2e4e..12449c308853 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -5454,7 +5454,7 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
>  
>  static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
>  {
> -	if (!use_trace_clock)
> +	if (!trace_clock || !use_trace_clock)
>  		return true;
>  
>  	if (!strcmp(trace_clock, "local") || !strcmp(trace_clock, "global")
