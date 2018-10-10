Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbeJJWo4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 18:44:56 -0400
Date: Wed, 10 Oct 2018 11:22:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] kernel-shark-qt: Add KernalShark Utils
Message-ID: <20181010112214.320b61fc@gandalf.local.home>
In-Reply-To: <4eb2711d-5462-26a7-3ffb-a71035322521@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
        <20181008151629.13973-3-ykaradzhov@vmware.com>
        <20181009123419.22fe49f2@gandalf.local.home>
        <4eb2711d-5462-26a7-3ffb-a71035322521@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 10 Oct 2018 17:12:40 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> On  9.10.2018 19:34, Steven Rostedt wrote:
> >> +	if (!kshark_instance(&kshark_ctx))
> >> +		return;
> >> +
> >> +	switch (filterId) {
> >> +		case KS_SHOW_EVENT_FILTER:
> >> +		case KS_HIDE_EVENT_FILTER:
> >> +			kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
> >> +			kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);  
> > Hmm, I'm curious to why you clear both SHOW/HIDE filters if the
> > filterId is one of SHOW or HIDE?
> > 
> > Perhaps a comment should be here explaining it too.
> > 
> >   
> 
> This enforces that we cannot have both SHOW and HIDE filters being set.
> I think that, having SHOW and HIDE filters set in the same time can be 
> useful in very limited number of cases. On the other hand this is an 
> easy way to confuse yourself.
> 
> Note that this restriction is at the level of the GUI code. The C API 
> allows for having both SHOW and HIDE filters in the same time.
>

Actually, there are real uses to do both. You may want to show a
specific kind of event, and then you may want to filter a subset of
that event.

-- Steve
