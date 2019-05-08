Return-Path: <SRS0=Ta82=TI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85226C004C9
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 00:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EF6B20675
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 00:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbfEHAMB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 May 2019 20:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfEHAMA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 May 2019 20:12:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F4F720C01;
        Wed,  8 May 2019 00:11:59 +0000 (UTC)
Date:   Tue, 7 May 2019 20:11:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] Documentation/trace: Add clarification how histogram
 onmatch works
Message-ID: <20190507201157.2673f2de@gandalf.local.home>
In-Reply-To: <20190507144946.7998-1-tstoyanov@vmware.com>
References: <20190507144946.7998-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Tom,

Can you review this patch.

Jon,

After Tom gives his review, can you take this in your tree?

Thanks!

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


On Tue,  7 May 2019 17:49:46 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> The current trace documentation, the section describing histogram's "onmatch"
> is not straightforward enough about how this action is applied. It is not
> clear what criteria are used to "match" both events. A short note is added,
> describing what exactly is compared in order to match the events.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  Documentation/trace/histogram.txt | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/trace/histogram.txt b/Documentation/trace/histogram.txt
> index 7ffea6aa22e3..d97f0530a731 100644
> --- a/Documentation/trace/histogram.txt
> +++ b/Documentation/trace/histogram.txt
> @@ -1863,7 +1863,10 @@ hist trigger specification.
>  
>      The 'matching.event' specification is simply the fully qualified
>      event name of the event that matches the target event for the
> -    onmatch() functionality, in the form 'system.event_name'.
> +    onmatch() functionality, in the form 'system.event_name'. Histogram
> +    keys of both events are compared to find if events match. In the case
> +    multiple histogram keys are used, both events must have the same
> +    number of keys, and the keys must match in the same order.
>  
>      Finally, the number and type of variables/fields in the 'param
>      list' must match the number and types of the fields in the
> @@ -1920,9 +1923,10 @@ hist trigger specification.
>  	    /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
>  
>      Then, when the corresponding thread is actually scheduled onto the
> -    CPU by a sched_switch event, calculate the latency and use that
> -    along with another variable and an event field to generate a
> -    wakeup_latency synthetic event:
> +    CPU by a sched_switch event (where the sched_waking key	"saved_pid"
> +    matches the sched_switch key "next_pid"), calculate the latency and
> +    use that along with another variable and an event field to generate
> +    a wakeup_latency synthetic event:
>  
>      # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0:\
>              onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,\

