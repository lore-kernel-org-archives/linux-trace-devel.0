Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF27C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 14:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6A6161108
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 14:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhJMOzi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230015AbhJMOzh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 10:55:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A2961108;
        Wed, 13 Oct 2021 14:53:33 +0000 (UTC)
Date:   Wed, 13 Oct 2021 10:53:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/3] trace-cmd: Extend host-guest time sync with
 fraction bits
Message-ID: <20211013105332.704ddf17@gandalf.local.home>
In-Reply-To: <CAPpZLN7j3xTUybuAqZ_p_ZygJCJavf_CTpfq=YLLEoO3pXxLrg@mail.gmail.com>
References: <20210923094526.765059-1-tz.stoyanov@gmail.com>
        <20210923094526.765059-2-tz.stoyanov@gmail.com>
        <20211012230442.2839503e@oasis.local.home>
        <CAPpZLN7j3xTUybuAqZ_p_ZygJCJavf_CTpfq=YLLEoO3pXxLrg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Oct 2021 12:48:55 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Wed, Oct 13, 2021 at 6:04 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu, 23 Sep 2021 12:45:24 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:  
> > > @@ -175,6 +184,12 @@ static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int cpu, char *dir_str)
> > >                                        dir_str, entry->d_name);
> > >                               kvm->vcpu_scalings[cpu] = strdup(path);
> > >                       }
> > > +                     if (!strncmp(entry->d_name, KVM_DEBUG_FRACTION_FILE,
> > > +                                  strlen(KVM_DEBUG_FRACTION_FILE))) {  
> >
> > I'm curious, why not just use strcmp(), or does "d_name" have more
> > characters than the fraction file?  
> 
> Just to be on the safe side. Currently the fraction file is with the
> longest name, but that may change in the future.\\


I'm confused, what do you mean on the safe side? What are you protecting
against? In other words, what can possibly go wrong? And I notice you do
this for all of them. I don't get it.

The only thing that this is protecting against, is if the file name becomes
"tsc-scaling-ratio-frac-bits-some-garbage-here" then it it will still
match. But other than that, you are not protecting against anything.

-- Steve


> 
> >  
> > > +                             snprintf(path, sizeof(path), "%s/%s",
> > > +                                      dir_str, entry->d_name);
> > > +                             kvm->vcpu_frac[cpu] = strdup(path);
> > > +                     }
> > >               }
> > >       }
