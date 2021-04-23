Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A80C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 08:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AE21613E1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 08:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhDWIRs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Apr 2021 04:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWIRp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 04:17:45 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8FFC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Apr 2021 01:17:08 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id z16so34691959pga.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Apr 2021 01:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k1c3vCtbPuK/BC49ZBwumw40zbxi8yROLYDFIOEs1/Q=;
        b=iza/UPc8911y0OWECxsAaP6jlFaxIk7mktq3cIiYDgLAMNi72gZdt9zqsyTpy7AKfj
         B2nqHbOx7NJ7WzWTSJaSCPRY2Qk4b6FYTVGhRVMMuXCFMuBj3VHqSzdjcf/tZ7Onl3pZ
         6nb+wZFsj8mDBcZoYWsCw+HC5lUmma5aSOVQS43FaeJsIxs+D73+njxYlqbZizo7JqKx
         PHZbwROnesDk3aI8masOOl/l9aLBl3hx6uS6mHUHI+yT+s18p1TdVhUfO46fNYKI+DJF
         qM2tAExG/nBTIeElXHPaFQXsboKKc/b+dGOV7AoqXTOXkFrlR7HINPZ56isldNojuhu6
         uAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k1c3vCtbPuK/BC49ZBwumw40zbxi8yROLYDFIOEs1/Q=;
        b=kn1apO1pZKZwkaBX7MxBLwZZRZqUE9aEA3vfFZAaoSnNSC2cHpJVpfuJA7R4JfPqdM
         srd802oQLSL6Q3dtYusAvYZ8ITlROFyTlnDJm3c1iUz+5dZfQiCZ5fbF0eTBu+9y1YAH
         0Tt+XEtyfVOWiUlwWCym4fetEyOuVU0tZ7Z1Ky2vwb/yeyXPIQKUp3HyA28rISPXEta1
         MWNg7HBosmlCMM7ehwN8tZKSf9jw4pDQKV7nCqO0DPTvcInsTL8ijDDcQZnpNeRTG7xN
         xt0URAZlE3Y0ryg2zxhHJ5rAiyqFkfM2l1AxnvN93efkUzAYgA0YhSyBKpP9HGQ7viJi
         JVyQ==
X-Gm-Message-State: AOAM532ITIdF8gFpTQPN7M7FrQ+mznvsn+qj0NFHW2lq0twVGdhXzrJC
        mwmy9Amj1yOA7kaJVEySwc9KZx+frDQD3EJeojzI156EzxuLCw==
X-Google-Smtp-Source: ABdhPJxg7CoMB2TE8HpPF9zQcPmK1JHCmrN8csG/B13XW6W92Kl+TKfnThKwQUZyEQkaq9uFQKEQ9idS53aObO0dv+4=
X-Received: by 2002:a65:47ca:: with SMTP id f10mr2707591pgs.206.1619165827510;
 Fri, 23 Apr 2021 01:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
 <CAPpZLN5pTxjnrQ=x0Kq7sGko+GSVv5gPTjSgETvO9kX1hgNCpQ@mail.gmail.com>
 <20210418080435.3c3e2d24@oasis.local.home> <CAJWu+oqG9T5v_2q+crsrsPe9GMcG0OSW7kcZ5ea=r1L07WKZJA@mail.gmail.com>
 <CAPpZLN7MDoFYaJZG1+_4gUpYwt2RfAMfB=BDvGYch2eOfS342Q@mail.gmail.com>
 <CAJWu+oosbOV=cigwfkNBLSpaMt3RExWLap3u+4G7pkYqQy_EXw@mail.gmail.com>
 <CAPpZLN7=e+TL5WY7RKAo9Hm6AJGDygneqUWwoNnZexx+=KrxsQ@mail.gmail.com>
 <CAJWu+op2bU+-z6W_+XB0v2g__oGXj8Be2WWDg36E9uaCjNp+HA@mail.gmail.com>
 <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
 <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
 <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
 <20210422153845.3e6e9304@gandalf.local.home> <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
 <20210422154830.52f3e4f5@gandalf.local.home> <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
 <20210422160313.2eee1f77@gandalf.local.home> <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
 <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com> <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
In-Reply-To: <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 23 Apr 2021 11:16:50 +0300
Message-ID: <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
Subject: Re: Instructions for clock sync for tracing host/guest
To:     Joel Fernandes <joelaf@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,

On Fri, Apr 23, 2021 at 1:50 AM Joel Fernandes <joelaf@google.com> wrote:
>
> Looks like my trace.dat files bounced from goodmis.org so I uploaded them here:
> https://drive.google.com/file/d/16wGsVo4PJ0kYQGAy195dfBW0RHSWVkx0/view?usp=sharing
>
> ---------- Forwarded message ---------
> From: Joel Fernandes <joelaf@google.com>
> Date: Thu, Apr 22, 2021 at 6:46 PM
> Subject: Re: Instructions for clock sync for tracing host/guest
> To: Steven Rostedt <rostedt@goodmis.org>, Yordan Karadzhov (VMware)
> <y.karadz@gmail.com>
> Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
>
>
> On Thu, Apr 22, 2021 at 5:12 PM Joel Fernandes <joelaf@google.com> wrote:
> >
> > On Thu, Apr 22, 2021 at 4:03 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Thu, 22 Apr 2021 15:49:21 -0400
> > > Joel Fernandes <joelaf@google.com> wrote:
> > >
> > > > On Thu, Apr 22, 2021 at 3:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > >
> > > > > On Thu, 22 Apr 2021 15:43:37 -0400
> > > > > Joel Fernandes <joelaf@google.com> wrote:
> > > > >
> > > > > > >  # trace-cmd record -e irq -e sched -e kvm -A test@32:823 -e sched
> > > > > >
> > > > > > OMG, that worked, thank you Steve and Tzvetomir !!!!!
> > > > >
> > > > > Technically, you can probably leave off "-e irq", but I do find it rather
> > > > > useful. But then, I add "-e irq" to the guest as well. It lets me see how
> > > > > interrupts transpire from the host to the guest.
> > > >
> > > > Got it thanks for the tip. Will report back any issues I see.
> > >
> > > And you know you can pull this up into KernelShark as well, right?
> > >
> > > Checkout the development version from Yordan's repository:
> > >
> > >
> > >  $ git clone https://github.com/yordan-karadzhov/kernel-shark.git
> > >  $ cd kernel-shark
> > >  $ git checkout origin/yordan_devel
> > >  $ cmake .
> > >  $ make
> > >  $ sudo make install
> > >
> > > Then run kernelshark with:
> > >
> > >  $ kernelshark trace-host.dat -a trace-guest.dat
> > >
> > > (obviously, using the actual names of the trace.dat files for the host and
> > > the guest)
> > >
> > > Then you can select: Plots -> KVM Combo Plots
> > >
> > > Then select the "all" box, and then apply. Then you get something like this:
> > >
> > >   http://rostedt.org/private/ks-host-guest.png
> > >
> > > Where you see how the tasks mapping to the host and guest are aligned.
> > >
> > > That is, if everything works fine.
> >
> > Yes, I sort of knew KernelShark had this support, but so glad you sent
> > me more details on how to do it, I'll try it out. I am also wondering
> > how the bars of the vCPUs will look like because you can have vCPU
> > threads migrated to different physical CPUs. I will go try it out and
> > see what comes up :-)
>
> Hi all, Just wanted to report my progress today:
>
> When I try to open the guest+host trace with the yordan_devel branch and command
> kernelshark ~/vm-host-trace/trace.dat -a ~/vm-host-trace/trace-test.dat
>
> I get the following in the console: https://pastebin.com/raw/EmbsyuB8
>
> And the GUI looks like the attached picture, I don't see any mention
> of KVM like Steve sees in
> http://rostedt.org/private/ks-host-guest.png . What am I missing?
>
> I also zipped and attached my trace files to this email. Could you
> take a look at them?

Looks like there is a gap in our implementation, affecting your use
case. We rely too much on the quemu guest information that we gather,
which is missing on your setup. As this information is not mandatory,
the implementation should not rely on it. What we need:
 - PID of the process, running the guest VM. In case of KVM, we use
this PID to get the KVM guest TSC clock parameters, needed for better
host and guest trace timestamps synchronization. Without this PID, KVM
cannot be used for timestamps synchronization. The logic should fail
back to a PTP-like algorithm, which is more generic, works in all
environments, but is less accurate than KVM logic.
 - PIDs of each thread, running a guest virtual CPU. This is not
required for the tracing, but for better trace visualisation in
KernelShark. It helps to map the host task to a vCPU and to visualise
them together.

Currently we collect that information from quemu, is there a way to
get it from crosvm ? If yes, a crosvm support can be implemented in
trace-cmd. But as I said, it is not mandatory to have it for the
trace, I can send you a patch next week addressing this gap in the
implementation.

Thanks for testing this code!

>
> My kernelshark HEAD commit is: 070d657 ("kernel-shark: Add KVMCombo
> plugin") . Let me know if I should be building some other commit sha.
>
> Adding Yordan to this email as well.
>
> Thanks a lot!
> -Joel



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
