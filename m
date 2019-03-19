Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FE7C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 16:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE7FD2075C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 16:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfCSQnk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbfCSQnk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 12:43:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6FF4206B7;
        Tue, 19 Mar 2019 16:43:39 +0000 (UTC)
Date:   Tue, 19 Mar 2019 12:43:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4] tools/lib/traceevent: Change description of few APIs
Message-ID: <20190319124338.44e49ac4@gandalf.local.home>
In-Reply-To: <CACqStofty+o7r_RasESWrv5PA8-hvXWFG+ha76Pf-6A+GZuaYw@mail.gmail.com>
References: <20190315081123.21723-1-tstoyanov@vmware.com>
        <8B1136D3-BD5A-49E8-B007-12D00050687A@vmware.com>
        <CACqStofty+o7r_RasESWrv5PA8-hvXWFG+ha76Pf-6A+GZuaYw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Mar 2019 10:35:05 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> On Mon, Mar 18, 2019 at 11:03 PM Matt Helsley <mhelsley@vmware.com> wrote:
> >
> >
> >  
> > > On Mar 15, 2019, at 1:11 AM, Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
> > >
> > > APIs descriptions should describe the purpose of the
> > > function, its parameters and return value. While working
> > > on man pages implementation, I noticed mismatches in the
> > > descriptions of few APIs. This patch changes the description
> > > of these APIs, making them consistent with the man pages:
> > > tep_print_num_field(), tep_print_func_field(),
> > > tep_get_header_page_size(), tep_get_long_size(),
> > > tep_set_long_size(), tep_get_page_size() and
> > > tep_set_page_size().
> > >
> > > Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > > ---
> > > tools/lib/traceevent/event-parse-api.c | 21 ++++++++++++---------
> > > tools/lib/traceevent/event-parse.c     |  4 ++--
> > > 2 files changed, 14 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
> > > index d4368dcc16ea..2d5d3642e3e9 100644
> > > --- a/tools/lib/traceevent/event-parse-api.c
> > > +++ b/tools/lib/traceevent/event-parse-api.c
> > > @@ -100,10 +100,10 @@ tep_data2host8(struct tep_handle *pevent, unsigned long long data)
> > > }
> > >
> > > /**
> > > - * tep_get_header_page_size - get size of the header page
> > > + * tep_get_header_page_size - get the size of a long integer, in kernel context  
> >
> > Just want to check If this comment change correct. Given the function name it looks a bit odd compared to the comment for tep_get_long_size().  
> 
> It is a copy / paste error,

Hmm, the function name is very confusing, as it is returning the kernel
context long size. Perhaps we should rename it to:

tep_get_header_long_size()

-- Steve

> Thanks Matt
> 
> 
> >  
> > >  * @pevent: a handle to the tep_handle
> > >  *
> > > - * This returns size of the header page
> > > + * This returns the size of a long integer, in kernel context
> > >  * If @pevent is NULL, 0 is returned.
> > >  */
> > > int tep_get_header_page_size(struct tep_handle *pevent)
> > > @@ -140,10 +140,11 @@ void tep_set_cpus(struct tep_handle *pevent, int cpus)
> > > }
> > >
> > > /**
> > > - * tep_get_long_size - get the size of a long integer on the current machine
> > > + * tep_get_long_size - get the size of a long integer on the traced machine
> > >  * @pevent: a handle to the tep_handle
> > >  *
> > > - * This returns the size of a long integer on the current machine
> > > + * This returns the size of a long integer on the machine,
> > > + * where the trace is generated
> > >  * If @pevent is NULL, 0 is returned.
> > >  */  
> 
> 
> 
> --
> 
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center

