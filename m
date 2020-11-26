Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0609BC56202
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 03:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80369217A0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 03:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkY/QcSF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgKZDxb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 22:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730187AbgKZDxa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 22:53:30 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7076C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 19:53:30 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id x15so492055pll.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 19:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yeUwR9x8KiF4pSg7hqbOZ9n4J6EZm50vIEAT2mBsfNU=;
        b=NkY/QcSFGQ6FS7TzQ1G4Ee/LUVz3PdVKbSlyMJxGL6KW6qccUHWUIqVOAJ0qvVuP3S
         412/Ip1Uw2A/hWJCpD9gN7hJ32HcIDlrwH/JTR0MliF+QWOwFMtMSFZdAaffevQH/LEz
         Rc+3bLb9A+FE9fKQg7YsVcfdf9XkklAIlIF5XPuCBk6pHqfByUMmKd8lBlpciRrTwKqP
         oBQnbiVqeabqMQiYI++G45BctNMH1KxVYuvxNCwN/EDpHB9zO7RDZO2ttyT8ear2hrUs
         Wi4txmERssiepxwHSBb22sz6nlhiG6xxO+vKum11W8KxXtM2/nBjNCpRIcLbRBFkpl4A
         9H9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yeUwR9x8KiF4pSg7hqbOZ9n4J6EZm50vIEAT2mBsfNU=;
        b=TObSAD3CE0+kuLIL/VyUqgJAcqX+Dd2KjQWLXozylPBZ7IC4DIjKe+8pHzPz0vQY1t
         lQ+tFr5pVJAwG2fZCZHsKc+wCG2nzLuUbvcio0gs8LnuxFFjWx1HrG3cWAo+ifS6gDkY
         8pGxhe0HLGhUdV5l3iYjr2oaMz9mEwz2IrdofkgKZypegVMuprYQft8ba3+lwxJvgnjv
         Fs+Sarh0mhhwDZ06W92m2/AvHlQTaA1XcUVBy28vEBEFowidsxkrLmRlMLHfzz+a2pIL
         ocK972mOj4GdKLvn3/VezGSzZb8t7FhJbklC88BdDZqGoCNcnlo/qcbySvxvqRSp7S8m
         nmAQ==
X-Gm-Message-State: AOAM531ovVLHjzjOdRi/PaZ9VlAIHVZj4iGViS1/jQWX2RBfGaPxydAK
        YaIzseYmJxt70gnxW/VUeWJOf+1uV3KuSzVoXtikPnFZb48dWg==
X-Google-Smtp-Source: ABdhPJxS/RlIf61FjpgY2zYph1fWVH3E9ok1OBJZL/QwCvl791wqgRyzTl4+3ESnwUIGGP9jfAquMNUrTING1NVxGAA=
X-Received: by 2002:a17:902:ed52:b029:d7:d0af:f89f with SMTP id
 y18-20020a170902ed52b02900d7d0aff89fmr1176072plb.26.1606362810045; Wed, 25
 Nov 2020 19:53:30 -0800 (PST)
MIME-Version: 1.0
References: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
 <20201119220910.1a8ec625@oasis.local.home> <64d58c3297d6915362678c5799bd3d363489bda3.camel@suse.com>
 <02672da2-8b62-a573-786d-1cb8f5970e85@gmail.com> <849f846631f3014c3eff7f37a7d61493e2af66a9.camel@suse.com>
 <20201120090828.4b62d4b7@gandalf.local.home> <4aafe6e3fd34a17ab4c9bf4514b5a9b7d65ca6ea.camel@suse.com>
In-Reply-To: <4aafe6e3fd34a17ab4c9bf4514b5a9b7d65ca6ea.camel@suse.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 26 Nov 2020 05:53:13 +0200
Message-ID: <CAPpZLN70+CkZWPK_XAv3WyPUC02yY98WoMwqMCNu2sRQiQ_QCA@mail.gmail.com>
Subject: Re: Accuracy of traces sync [Was: Re: [PATCH] Fix `make -jN trace-cmd gui`]
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 26, 2020 at 2:15 AM Dario Faggioli <dfaggioli@suse.com> wrote:
>
> On Fri, 2020-11-20 at 09:08 -0500, Steven Rostedt wrote:
> > On Fri, 20 Nov 2020 14:43:21 +0100
> > Dario Faggioli <dfaggioli@suse.com> wrote:
> > >
> > > So, you often say that "the accuracy of the synchronization
> > > protocol is
> > > XX ms". Now, I guess that means that an event in the guest and the
> >
> > Note, we are usually microsecond (us) apart, not millisecond (ms) ;-)
> >
> Ah, yes, sure... And sorry about that! I know it us, I'm not sure how I
> ended up writing ms. That would be quite terrible indeed! :-D
>
> > > corresponding event in the host (or vice versa) are XX ms apart.
> > > And
> > > that's even after the synchronization of the two traces, is that
> > > right?
> >
> > At plumbers we talked with Thomas Gleixner and he suggested ideas of
> > how to
> > get to the actual shifts used in the hardware that should give us
> > exact
> > timestamp offsets. We are currently working on that.
> >
> Yes, I remember that, I attended the BoF.
>
> > But in the mean time,
> > the P2P is giving us somewhere between 5 and 10 us accuracy. And
> > that's
> > simply because the jitter of the vsock connection (which is used for
> > the
> > synchronization at start and end of the traces) has a 5 to 10 us
> > jitter,
> > and it's not possible to get a more accurate than the medium that is
> > being
> > used.
> >
> Yes, with a student that I was helping with his thesis, we applied one
> debug patch to trace-cmd that you have on this list, and we tried the
> different synchronization strategies, frequency, etc.
>
> > > Question is, how do you measure that? Sure, I can look manually for
> > > an
> > > occurrence of the pattern that I described above: i.e., an event in
> > > the
> > > guest, then the corresponding one in the host and compute the
> > > difference between the timestamps.
> >
> > You mean, how we measure the accuracy? It's usually done by seeing
> > when we
> > have events from the guest showing up when we should be in the host
> > (it's
> > like seeing events from userspace when you are in the kernel).
> >
> Ok, makes sense. I need to try it first hand to make sure I've properly
> understood it, though. I'll collect some more tracing and looks for
> situations like these.
>
> Thanks!
>
> > > But do you have a way to do so automatically, or with a
> > > script/program,
> > > etc?
> >
> > We have talked about having something scan to find cases where the
> > guest
> > event happens in kernel and do some post processing shifting, but
> > haven't
> > gotten there yet.
> >
> Yep, as said, I was thinking at it as a way to measure how accurately
> the traces are synched, but indeed once one has it, it can even use it
> to actually synch them better.

Hi Dario
There is one approach to measure the accuracy of the synchronisation.
May be you remember the suggestions proposed in the BoF - KVM exposes
the clock offset and scaling factor in the /proc FS. In the last
version of the time
sync patch set, v25, I've implemented such logic - when x86-tsc is used for
trace clock source, the offset is read from the KVM debug FS. In theory this
should bring the best synchronisation, but I still see some guest events in
wrong order according to the host events.
I use the offset exposed from KVM as a reference - run PTP algorithm using
the x86-tsc trace clock and compare the calculated offset with the one from
the KVM debug FS.
We still need to find a way to improve the synchronisation accuracy for cases
when other hypervisors and trace clocks are used.


>
> But I understand how it's rather tricky.
>
> > If the hardware settings can work, then there will be no
> > need to do so.
> >
> Indeed. Well, perhaps it could still be useful, as a test/check whether
> things are working? :-)
>
> Regards
> --
> Dario Faggioli, Ph.D
> http://about.me/dario.faggioli
> Virtualization Software Engineer
> SUSE Labs, SUSE https://www.suse.com/
> -------------------------------------------------------------------
> <<This happens because _I_ choose it to happen!>> (Raistlin Majere)



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
