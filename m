Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9866DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84DE7610E5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhKBNv7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 09:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbhKBNv5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 09:51:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34077610E5;
        Tue,  2 Nov 2021 13:49:16 +0000 (UTC)
Date:   Tue, 2 Nov 2021 09:49:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 03/12] libtracefs: New kprobes APIs
Message-ID: <20211102094914.0b9c0a45@gandalf.local.home>
In-Reply-To: <98a9177a-a255-8d35-a647-943c31c316cd@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
        <20211101090904.81454-4-tz.stoyanov@gmail.com>
        <78703fa1-f811-a50c-6b5d-db68f6dbf21c@gmail.com>
        <CAPpZLN4iJvmz-_EZV0TY6cGTSDDf=6V7DVPEEUAOaMjsGyaoUA@mail.gmail.com>
        <98a9177a-a255-8d35-a647-943c31c316cd@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2 Nov 2021 09:43:16 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > 2. Expose the dynevent_... APIs directly:
> >      struct tracefs_dynevent *synth =
> > tracefs_dynevent_alloc(TRACE_DYNEVENT_SYNTH, ...);  
> 
> I would prefer taking this approach. It is OK to also have several helper constructors like tracefs_kprobe_alloc(), 
> tracefs_synth_alloc(), etc. that will call internally dynevent_alloc().
> 
> In principle having multiple constructors is OK.

I agree with having multiple constructors, as that makes it easier to think
about what is being created and how to manipulate it. The dynamic event
structure has a type field and it should be used to make sure that
modifications that only should happen to kprobes only happens on dynamic
events created as a kprobe, and errors on everything else.

> 
> 
> >      struct tracefs_dynevent *kprobe =
> > tracefs_dynevent_alloc(TRACE_DYNEVENT_KPROBE, ...);
> > 
> >      ret = tracefs_dynevent_create(synth);
> >      ret = tracefs_dynevent_create(kprobe);
> >   
> 
> Yes, this is OK as well.

Agreed.

> 
> We only have a single type (struct tracefs_dynevent) so there must be a single create. And what is even more important: 
> there must be ONLY ONE destructor.

I wouldn't be so strong as to use "must" but I do agree that it will
simplify the usage of the API. It would be more analogous to free() where
you have several different constructors that state in the man page (must be
freed with free). Same here. Each constructor's man page must state: "must
be freed with tracefs_dynevent_free()"

Removing from the system any dynamic event should also just use
tracefs_dynevent_destroy(). Having the type of event in the structure means
that knowing how to destroy it can be multiplexed inside the library, and
not burden the user in such cases. This way, the user could create a bunch
of dynamic event types in an array or linked list, and destroy them at the
end without having to keep track of which one is which.

-- Steve

> 
> Think about the usecase of the APIs. You create an object using one of the constructors. Later at some point you want to 
> use the objects and after this finally you want to destroy it. If we have multiple/specialized "create" and "destroy" 
> versions for the same object type, the user must somehow keep its own record of which constructor had been used trough 
> the entire live of the object in order to know which is the proper destructor to call at the end.
