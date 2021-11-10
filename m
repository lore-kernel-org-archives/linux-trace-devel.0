Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9766C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 16:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B5B560FC1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 16:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbhKJQUW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 11:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhKJQUT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 11:20:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5BA660F70;
        Wed, 10 Nov 2021 16:17:30 +0000 (UTC)
Date:   Wed, 10 Nov 2021 11:17:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Add Requires: libtracefs to libtracecmd.pc
 file
Message-ID: <20211110111729.41a7eb6b@gandalf.local.home>
In-Reply-To: <db8be415-bb25-a2fe-1d30-8e4a446154f7@gmail.com>
References: <20211109111426.7639b2a6@gandalf.local.home>
        <db8be415-bb25-a2fe-1d30-8e4a446154f7@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Nov 2021 16:12:12 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 9.11.21 г. 18:14 ч., Steven Rostedt wrote:
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > In order to not have users of libtracecmd having to also include the
> > includes and libraries for libtracefs and libraceevent, add a requires
> > field for libtracefs to the libtracecmd.pc file. As libtracefs requires
> > libtraceevent, it will pull that one in as well.
> > 
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> >   libtracecmd.pc.template | 1 +
> >   scripts/utils.mk        | 1 +
> >   2 files changed, 2 insertions(+)
> > 
> > diff --git a/libtracecmd.pc.template b/libtracecmd.pc.template
> > index dc41076e..bcf4e39d 100644
> > --- a/libtracecmd.pc.template
> > +++ b/libtracecmd.pc.template
> > @@ -6,5 +6,6 @@ Name: libtracecmd
> >   URL: https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
> >   Description: Library for creating and reading trace-cmd data files
> >   Version: LIB_VERSION
> > +Requires: libtracefs >= LIBTRACEFS_MIN_VERSION  
> 
> BTW this works also without the 'lib' prefix:
> 
> Requires: tracefs >= LIBTRACEFS_MIN_VERSION

I just tried that on Fedora, and get this:

# pkg-config --libs libtracecmd
Package tracefs was not found in the pkg-config search path.
Perhaps you should add the directory containing `tracefs.pc'
to the PKG_CONFIG_PATH environment variable
Package 'tracefs', required by 'libtracecmd', not found

-- Steve
