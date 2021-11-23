Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A012C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 08:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhKWI6Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 03:58:25 -0500
Received: from smtp2.axis.com ([195.60.68.18]:55915 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235151AbhKWI6Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 03:58:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1637657717;
  x=1669193717;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YY8TztApIbu8gAM/dbGhVqhWLHuckZQpbxwj+qBG80s=;
  b=milnxrqzSFGlJnvZYmNl7BiJq7LuEXNfslWsnIveL4cISTpK9n/Eq5qU
   HzH2JkdOnO0lJNVErGPVlS4R53tQFkVYyBDdS2s8QV6V6XqjV35UywS3q
   d2J7Om45YYJc6pNQ1Shn8LrnfRVpd3oMoNgsjiYczCCwmJmTzSGOVK2ZV
   HI1lL86hpP1Vy0k/saWdt9d9zczj/BbfhJ5VW0p/xkMPhLkPt3XjqdKU3
   OGhJeLIpsmt5tIKn7L6tM2i7rJykf7dCOeC9L7X4aWuICO+hrkuJNjyt1
   clxss4VqNhaFmJaCIFnM/GshuehHhPt3Htq3BkTevdf79IQ4p+elli+XF
   w==;
Date:   Tue, 23 Nov 2021 09:55:14 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, kernel <kernel@axis.com>
Subject: Re: [PATCH] trace-cmd report: Avoid crash on unknown event
Message-ID: <20211123085514.GA12234@axis.com>
References: <20211119112420.4826-1-vincent.whitchurch@axis.com>
 <20211119094434.718922fa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211119094434.718922fa@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Nov 19, 2021 at 03:44:34PM +0100, Steven Rostedt wrote:
> On Fri, 19 Nov 2021 12:24:20 +0100
> Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:
> 
> > Do not segfault if the event cannot be found for some reason and
> > tep_find_event_by_record() returns NULL.
> > 
> > No extra warning is added since there are others ("UNKNOWN EVENT") which
> > already make it clear that something is wrong:
> > 
> >  kworker/u8:0-7 [003] 1.245773: sched_stat_runtime: comm=kworker/u8:...
> > [UNKNOWN EVENT][UNKNOWN EVENT][UNKNOWN EVENT]
> >  kworker/u8:0-7 [003] 1.245776: sched_switch: kworker/u8:0:7 [120] W...
> > 
> 
> I wonder if the following would be a better and more robust approach:
> 
> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index f7ffb89e..4b27740a 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -142,12 +142,15 @@ static struct trace_hash wakeup_hash;
>  static void print_event_name(struct trace_seq *s, struct tep_event *event)
>  {
>  	static const char *spaces = "                    "; /* 20 spaces */
> +	const char *name;
>  	int len;
>  
> -	trace_seq_printf(s, " %s: ", event->name);
> +	name = event ? event->name : "(NULL)";
> +
> +	trace_seq_printf(s, " %s: ", name);
>  
>  	/* Space out the event names evenly. */
> -	len = strlen(event->name);
> +	len = strlen(name);
>  	if (len < 20)
>  		trace_seq_printf(s, "%.*s", 20 - len, spaces);
>  }

Looks good to me.
