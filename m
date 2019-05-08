Return-Path: <SRS0=Ta82=TI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0F4C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 13:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AFD1214AF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557321330;
	bh=FcJSM/y2BlME+YwJKXMk2xvlnDqC5u1EXDgBURrRrFQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=De8KQMet+IE5P9/H9N6Q05IPS8nMSEwQ5hb9bO4zorQtO1XQ7p3U7vpJbZwS48Aoe
	 XO9EBlqBl9adnU7dcZNJwBcX4Cg2ajNc8J400+riht5M3ti+OV0Q0hvAHhV2Z5Dh7z
	 2vDq/rsNa3Uky84EwzHs8mpB9yEhV50e4DkFAldI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfEHNP3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 May 2019 09:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfEHNP3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 May 2019 09:15:29 -0400
Received: from tzanussi-mobl (c-98-220-238-81.hsd1.il.comcast.net [98.220.238.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5685520850;
        Wed,  8 May 2019 13:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557321328;
        bh=FcJSM/y2BlME+YwJKXMk2xvlnDqC5u1EXDgBURrRrFQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Co24EdjTGma2lIPhu3U3ZulvyXwvV1sWJYNfPsrhv5STyAuxcjDRYveSac66hi0IN
         kIGk+y2Xs2qAZ5KZtn8Md1tUAGmo9OJ0d9/z4X8LxP5S3ib2KDyq7LB2QDBd1/QySn
         xsyIa8GbUlFGiwi7SvYCY0h8B6p1qENU/fejecGk=
Message-ID: <1557321326.2167.5.camel@kernel.org>
Subject: Re: [PATCH v2] Documentation/trace: Add clarification how histogram
 onmatch works
From:   Tom Zanussi <zanussi@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Date:   Wed, 08 May 2019 08:15:26 -0500
In-Reply-To: <20190507201157.2673f2de@gandalf.local.home>
References: <20190507144946.7998-1-tstoyanov@vmware.com>
         <20190507201157.2673f2de@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Tue, 2019-05-07 at 20:11 -0400, Steven Rostedt wrote:
> Tom,
> 
> Can you review this patch.
> 

Sure.

> Jon,
> 
> After Tom gives his review, can you take this in your tree?
> 
> Thanks!
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Thanks,

Tom

> -- Steve
> 
> 
> On Tue,  7 May 2019 17:49:46 +0300
> Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
> 
> > The current trace documentation, the section describing histogram's
> > "onmatch"
> > is not straightforward enough about how this action is applied. It
> > is not
> > clear what criteria are used to "match" both events. A short note
> > is added,
> > describing what exactly is compared in order to match the events.
> > 
> > Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > ---
> >  Documentation/trace/histogram.txt | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/trace/histogram.txt
> > b/Documentation/trace/histogram.txt
> > index 7ffea6aa22e3..d97f0530a731 100644
> > --- a/Documentation/trace/histogram.txt
> > +++ b/Documentation/trace/histogram.txt
> > @@ -1863,7 +1863,10 @@ hist trigger specification.
> >  
> >      The 'matching.event' specification is simply the fully
> > qualified
> >      event name of the event that matches the target event for the
> > -    onmatch() functionality, in the form 'system.event_name'.
> > +    onmatch() functionality, in the form 'system.event_name'.
> > Histogram
> > +    keys of both events are compared to find if events match. In
> > the case
> > +    multiple histogram keys are used, both events must have the
> > same
> > +    number of keys, and the keys must match in the same order.
> >  
> >      Finally, the number and type of variables/fields in the 'param
> >      list' must match the number and types of the fields in the
> > @@ -1920,9 +1923,10 @@ hist trigger specification.
> >  	    /sys/kernel/debug/tracing/events/sched/sched_waking/tr
> > igger
> >  
> >      Then, when the corresponding thread is actually scheduled onto
> > the
> > -    CPU by a sched_switch event, calculate the latency and use
> > that
> > -    along with another variable and an event field to generate a
> > -    wakeup_latency synthetic event:
> > +    CPU by a sched_switch event (where the sched_waking key	
> > "saved_pid"
> > +    matches the sched_switch key "next_pid"), calculate the
> > latency and
> > +    use that along with another variable and an event field to
> > generate
> > +    a wakeup_latency synthetic event:
> >  
> >      # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-
> > $ts0:\
> >              onmatch(sched.sched_waking).wakeup_latency($wakeup_lat
> > ,\
> 
> 
