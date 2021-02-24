Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD725C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 15:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952EE64DD3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 15:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhBXPkz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 10:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235318AbhBXOSQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 09:18:16 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DDA64EDB;
        Wed, 24 Feb 2021 14:17:33 +0000 (UTC)
Date:   Wed, 24 Feb 2021 09:17:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [Bug 210643] libtracefs: Add ways to set the filtering of
 function tracing
Message-ID: <20210224091732.0d0466a3@gandalf.local.home>
In-Reply-To: <CAPpZLN7tsF8=o1RQJc2rMAdbrFgmFvZmKWK9avbCPCa42U_iDw@mail.gmail.com>
References: <20210223120130.280e7838@gandalf.local.home>
        <CAPpZLN7tsF8=o1RQJc2rMAdbrFgmFvZmKWK9avbCPCa42U_iDw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Feb 2021 09:39:49 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > --- Comment #7 from Steven Rostedt (rostedt@goodmis.org) ---
> > After some discussions on the mailing lists, I found that it is important to
> > establish the requirements that I expect of this API. I'm doing it in the
> > bugzilla instead of the mailing list (but will also forward this to the
> > mailing list), as this is more about the feature request and not about the
> > development of it.
> >
> > The prototype should be:
> >
> >  int tracefs_function_filter(struct tracefs_instance *instance,
> >                              const char * const *filters,
> >                              const char *module,
> >                              boolean reset);  
> 
> I think there should be a complementary API for deleting the filters,
> may be something like
>   int tracefs_function_filter_remove(struct tracefs_instance *instance,
>                                                         const char *
> const *filters,
>                                                         const char *module)
> It should be able to remove the filters, configured by the first API
> with the same "filters, module" input parameters.

Yes, I was going to even mention this, but figured my requirements were
long enough ;-)


-- Steve
