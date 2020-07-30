Return-Path: <SRS0=u2KR=BJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45613C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 00:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ED6C207F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 00:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgG3ALq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jul 2020 20:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgG3ALp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jul 2020 20:11:45 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1552A2075D;
        Thu, 30 Jul 2020 00:11:44 +0000 (UTC)
Date:   Wed, 29 Jul 2020 20:11:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix build with binutils 2.35
Message-ID: <20200729201143.455ffcc2@oasis.local.home>
In-Reply-To: <20200729205927.GH433799@kernel.org>
References: <20200725010623.GA194964@decadent.org.uk>
        <20200728121908.GG40195@kernel.org>
        <20200728090806.10e43f96@oasis.local.home>
        <20200729205927.GH433799@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 29 Jul 2020 17:59:27 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Tue, Jul 28, 2020 at 09:08:06AM -0400, Steven Rostedt escreveu:
> > On Tue, 28 Jul 2020 09:19:08 -0300
> > Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> >   
> > > Em Sat, Jul 25, 2020 at 02:06:23AM +0100, Ben Hutchings escreveu:  
> > > > In binutils 2.35, 'nm -D' changed to show symbol versions along with
> > > > symbol names, with the usual @@ separator.  When generating
> > > > libtraceevent-dynamic-list we need just the names, so strip off the
> > > > version suffix if present.    
> > > 
> > > Steven, have you seen this one?  
> > 
> > Yeah, I saw it. Just haven't gotten to it yet ;-)  
> 
> So, I've stumbled on this on debian:experimental:
> 
>   LINK     /tmp/build/perf/perf
> /usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: ignoring invalid character `@' in script
> /usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: ignoring invalid character `@' in script
> /usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: syntax error in dynamic list
> collect2: error: ld returned 1 exit status
> make[2]: *** [Makefile.perf:637: /tmp/build/perf/perf] Error 1
> 
> I'll tentatively add this patch to see if it then passes all the tests
> everywhere...
> 
> -

I'd say go ahead and apply it.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
