Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1582EC2D0E3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 00:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBFD820739
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 00:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgIPAby (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbgIONoG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Sep 2020 09:44:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CFC20872;
        Tue, 15 Sep 2020 13:41:42 +0000 (UTC)
Date:   Tue, 15 Sep 2020 09:41:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: tep_free_plugin_paths() function in libtraceevent
Message-ID: <20200915094140.25474a64@gandalf.local.home>
In-Reply-To: <466701766794299d1c238f450c89fac07e43744b.camel@decadent.org.uk>
References: <e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk>
        <20200914212945.GC166601@kernel.org>
        <CAPpZLN5Wt3dFxxLh1aCN43kJWAadsPXga7wXGUxDDPzHW3Ot=Q@mail.gmail.com>
        <466701766794299d1c238f450c89fac07e43744b.camel@decadent.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Sep 2020 14:26:48 +0100
Ben Hutchings <ben@decadent.org.uk> wrote:

> On Tue, 2020-09-15 at 16:12 +0300, Tzvetomir Stoyanov wrote:
> > On Tue, Sep 15, 2020 at 12:29 AM Arnaldo Carvalho de Melo
> > <arnaldo.melo@gmail.com> wrote:  
> > > Em Fri, Sep 11, 2020 at 03:08:16AM +0100, Ben Hutchings escreveu:  
> > > > I noticed that the new function tep_free_plugin_paths() is exported
> > > > from libtraceevent, but is only declared in a private header file.  
> > 
> > Hi Ben,
> > The tep_free_plugin_paths() function is supposed to be an internal
> > function, not an API - that's why it is in a private header. What do you
> > mean by "exported": the "tep_" prefix, or the fact that it is not static?  
> 
> It is exported from the shared library, i.e. it's included in the
> library's dynamic symbols.  That means that it could be called by a
> program using the library, and would conflict with a function defined
> by the program.

Of course a program that uses this shouldn't have any tep_ prefix
functions ;-)

> 
> > I can remove the prefix, if that is what bothers you.  
> 
> No, exporting symbols without that prefix would make conflicts more
> likely.

Right!

> 
> > The function is
> > defined in event-plugin.c and is used in event-parse.c, that's why it
> > cannot be made static without a library redesign.  
> 
> Yes, I realise that.  However you can define it as "hidden":
> <https://gcc.gnu.org/onlinedocs/gcc-10.2.0/gcc/Common-Function-Attributes.html#index-visibility-function-attribute>.

Ah, that's how libraries can hide non static functions. I learned something
new today!

Tzvetomir,


Let's only have functions that are part of the library's API start with
"tep_", and all other functions not have "tep_" in the name (so we know
which ones are exported and which ones are not).

Then any function that doesn't start with "tep_" should either be static,
or hidden.

#define __hidden __attribute__((visibility ("hidden")))

static void foo ()
{
}

void __hidden bar ()
{
}


-- Steve

