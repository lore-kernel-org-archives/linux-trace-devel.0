Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C31EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E41760E52
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhKDR7y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233913AbhKDR7v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 13:59:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8E160E52;
        Thu,  4 Nov 2021 17:57:12 +0000 (UTC)
Date:   Thu, 4 Nov 2021 13:57:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4 04/10] libtracefs: Change tracefs_kprobe_info API
Message-ID: <20211104135711.6ab8826c@gandalf.local.home>
In-Reply-To: <CAPpZLN48XgUnpAc+m7bTevqzYHZC=LjResC026_Hfr9veKegWQ@mail.gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
        <20211104111047.302660-5-tz.stoyanov@gmail.com>
        <20211104123316.45632bf2@gandalf.local.home>
        <CAPpZLN48XgUnpAc+m7bTevqzYHZC=LjResC026_Hfr9veKegWQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 4 Nov 2021 19:28:49 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Thu, Nov 4, 2021 at 6:33 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu,  4 Nov 2021 13:10:41 +0200
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > +enum tracefs_dynevent_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
> > > +                                            char **system, char **event,
> > > +                                            char **prefix, char **addr, char **format)
> > > +{
> > > +     char **lv[] = { system, event, prefix, addr, format };
> > > +     char **rv[] = { &kprobe->system, &kprobe->event, &kprobe->prefix,
> > > +                     &kprobe->address, &kprobe->format };
> > > +     int i;
> > > +
> > > +     if (!kprobe)
> > > +             return TRACEFS_DYNEVENT_MAX;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(lv); i++)
> > > +             *lv[i] = NULL;  
> >
> > Do we really need to initialize them to NULL here?
> >
> > Not to mention, if one of the parameters is NULL itself, this will SEGFAULT.
> >  
> 
> I'll add a check for that. They should be set to NULL to ensure that
> free() in the error path will not segfault, if the caller passes not
> initialised pointers.

It wont, due to the fact that it starts at i and works backward down to
zero. The only items it will look at are the ones that were already
initialized. Which is why I did it that way.

> 
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(lv); i++) {  
> >
> > Nice use of ARRAY_SIZE() ;-)
> >  
> > > +             if (lv[i]) {
> > > +                     if (*rv[i]) {
> > > +                             *lv[i] = strdup(*rv[i]);
> > > +                             if (!*lv[i])
> > > +                                     goto error;
> > > +                     } else {
> > > +                             *lv[i] = NULL;
> > >                       }  

> > > +
> > > +     return kprobe->type;
> > > +
> > > +error:
> > > +     for (i--; i >= 0; i--) {

The above means that we do not need to initialize anything that wasn't
touched.

-- Steve


> > > +             if (lv[i])
> > > +                     free(*lv[i]);
> > > +     }
> > > +
> > > +     return TRACEFS_DYNEVENT_MAX;
> > >  }  
> >  
> 
> 

