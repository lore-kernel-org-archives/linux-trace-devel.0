Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE00C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 082C62465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAVR2H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgAVR2H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:28:07 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C42B2465A;
        Wed, 22 Jan 2020 17:28:06 +0000 (UTC)
Date:   Wed, 22 Jan 2020 12:28:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: generate cscope.files when building cscope
 index
Message-ID: <20200122122805.0ecfdb1f@gandalf.local.home>
In-Reply-To: <CAKvFj6o5gTRHFwjFdQJh4K-t-tdGdag6NHCjXYpW=29-yqHWww@mail.gmail.com>
References: <20200112190537.170197-1-marcgonzalez@google.com>
        <20200120173335.7ec9609f@rorschach.local.home>
        <CAKvFj6o5gTRHFwjFdQJh4K-t-tdGdag6NHCjXYpW=29-yqHWww@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 22 Jan 2020 12:21:54 -0500
Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:

> > > Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
> > > ---
> > >  Makefile | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Makefile b/Makefile
> > > index efd9ed4..0b15bf5 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -348,7 +348,8 @@ TAGS:     force
> > >
> > >  cscope: force
> > >       $(RM) cscope*
> > > -     $(call find_tag_files) | cscope -b -q
> > > +     $(call find_tag_files) > cscope.files
> > > +     cscope -b -q  
> >
> > I think the following should work too, without the need to create an
> > extra file:
> >
> > diff --git a/Makefile b/Makefile
> > index efd9ed4b..782df41b 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -348,7 +348,7 @@ TAGS:       force
> >
> >  cscope: force
> >         $(RM) cscope*
> > -       $(call find_tag_files) | cscope -b -q
> > +       $(call find_tag_files) | cscope -b -q -i-  
> 
> Hi Steven!
> 
> I think one problem with this is that it requires that you pass cscope a
> list of files to look in when using it after building the index.
> Running "cscope"
> with no arguments gives the output: "cscope: no source files found", whereas
> if cscope.files is populated, running "cscope" lets you look at everything that
> went into building the index. For example, I think running "make cscope" inside
> a kernel repository will spit out a 'cscope.files' (done in docscope()
> in ./scripts/tags.sh).
> But I guess it depends on how people usually like to use cscope (I'm
> no expert!).
> What do you think is best?

As I do my development with emacs, I honestly have no opinion on the
use of cscope. ;-)

Is it common practice to look at the file used for cscope? If it is,
then I'm OK with your approach, but we need to make sure we update
the .gitignore and clean make target to remove it.

Thanks!

-- Steve
