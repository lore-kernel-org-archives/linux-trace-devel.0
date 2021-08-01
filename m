Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766F0C4338F
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Aug 2021 22:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 516AF610A0
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Aug 2021 22:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhHAW31 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 1 Aug 2021 18:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhHAW31 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 1 Aug 2021 18:29:27 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BB70603E7;
        Sun,  1 Aug 2021 22:29:18 +0000 (UTC)
Date:   Sun, 1 Aug 2021 18:29:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 17/17] libtracefs: Add man page for tracefs_sql()
Message-ID: <20210801182916.689a84a8@rorschach.local.home>
In-Reply-To: <YQakDYRnId+bK+ue@lx-t490>
References: <20210730221824.595597-1-rostedt@goodmis.org>
        <20210730221824.595597-18-rostedt@goodmis.org>
        <YQakDYRnId+bK+ue@lx-t490>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 1 Aug 2021 15:39:25 +0200
"Ahmed S. Darwish" <a.darwish@linutronix.de> wrote:

> On Fri, Jul 30, 2021, Steven Rostedt wrote:
> > +
> > +The SQL format is as follows:
> > +
> > +*SELECT* <fields> FROM <start-event> JOIN <end-event> ON <matching-fields> WHERE <filter>
> > +
> > +Note, although the examples show the SQL commands in uppercase, they are not required to
> > +be so. That is, you can use "SELECT" or "select" or "sElEct".
> > +  
> 
> Maybe it would be helpful to mention that, unlike normal SELECT queries,
> the JOIN and ON parts above are _not_ optional?
> 
> That is, generic "one event source" queries:
> 
>   SELECT common_pid,msr,val FROM write_msr WHERE msr=72
> 
> are not supported. (I wish they were though ;-))

Actually, the sql parser should support it, but it will fail on the
creation of events. That's because I started trying to make this create
normal histograms. The problem is, that it can't really do a 1 to 1 on
histograms and selects, so I gave up. But perhaps for the subset it can
create, maybe I can still have it do so. That may require changing the
API slightly. 

I'm not a big SQL person, so I don't know all the magic and I have no
idea how to add the "values" part of the hist trigger.

I could use SQL CAST to let people redefine the types that histograms
allow, like:

   SELECT CAST(common_pid AS execname), CAST(id AS syscall) FROM sys_enter

and have that produce:

 echo 'hist:keys=common_pid.execname,id.syscall' > events/raw_syscalls/sys_enter/trigger

Any ideas for the syntax to get values? Or do people care about the
value parameter any more than just "hitcount"? I don't think I have
ever used it for anything.

> 
> BTW, thanks a lot for this work. It will finally make synthetic events
> usable!
> 

Thanks! It's also something to make it easier for me to use. And
hopefully, allow for even more complex synthetic events.

-- Steve
