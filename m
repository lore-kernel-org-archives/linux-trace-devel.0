Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0112C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF9C61165
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDZNwn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 09:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhDZNwm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 09:52:42 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD4DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 06:51:59 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c19so3081686pfv.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 06:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bq8hxD5M5oPlrBYfKswlGaXM0IQ3ZAwbNAzeoSxkYvI=;
        b=oSQUpyku34wbVgDRd3/xOjogMNhXX2SqtYqTgp/+Ud8RUor0r6WgS2cv38BDZQeE2j
         CYXuG3j0Mzav/7Fw7iN0DcnXkhZGBinpmAmqg2Raaa2l5PG6nZYzKut2BDJoRO9L+cFD
         RTmudy7g6tOeL1b53gLgVOtotjLK99IA01TIj+D+UOfqY7lhMT89V+zExU2p8/Ucw7Mg
         aQrLGBFzhwmT5cqvZVvA3VV+kAtdexHk71E6kd/FrfJfLyxhznCRO4PAAqB6IuSygATp
         S3LXct7hiUAgkFnhwXzpZDFqKOUou4xW4EglYuCoA1iZ8KUjrVmuYJAOGrpPk5wKkhWT
         LG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bq8hxD5M5oPlrBYfKswlGaXM0IQ3ZAwbNAzeoSxkYvI=;
        b=hKgmOocW/kr2akM7cBFXGptsu/RIOtdD0bDRRcbjlJt1syq+cbRiqMSDCSIkHudCav
         7hLUf6UjLy6oOsLqTNL5NGQ1raxRvzvgvpG2HJKZLQV22ec3wuqWQhFslC6zXBkk6H8V
         lgis71xFOHQtXUl2/HeCedGAQO24thMU1tTPN0Stzbq96fSgvRRal+HcY+76tZet2Y9T
         6e7dVzgj9/FkVugxsyjSCwv0LTvnFxMLw8Yg75eI61OBORo8ySW1NlT/bkfYlvce6Q04
         PvAcjhw1GwM6EOwZXo2FXC9dla7SfS9augEaPpSIK9uvMr3PIzR2U6G82/K91rB5Bzde
         hJaA==
X-Gm-Message-State: AOAM5306ZcVi+P9ipEBvSXTnW5p6Jrvy6tSn1aD9IjUTyeiaNJJUV1F0
        77XiRCQbDCYqZL3q1TW1l+ITxQH9m/icXivCqVw=
X-Google-Smtp-Source: ABdhPJxoILF31vcX+EyP73J0obdduQXE60dO2WHtmHekDiW1FtDZidSWyiBjreW5DZhHAhORdwaNqm0zrve6RhQPLh0=
X-Received: by 2002:a62:8817:0:b029:272:3729:e109 with SMTP id
 l23-20020a6288170000b02902723729e109mr11283089pfd.50.1619445119494; Mon, 26
 Apr 2021 06:51:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
 <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
 <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
 <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
 <20210422153845.3e6e9304@gandalf.local.home> <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
 <20210422154830.52f3e4f5@gandalf.local.home> <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
 <20210422160313.2eee1f77@gandalf.local.home> <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
 <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
 <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
 <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
 <20210425142935.52078301@rorschach.local.home> <CAPpZLN7hhypY6+s5R+JX1u2e9Typ-1O1yC9mDoEcRYKLHYGFNw@mail.gmail.com>
 <20210426085654.5a47e7e5@gandalf.local.home> <d19c679218fcb43179a711740186781f3c29265a.camel@suse.com>
In-Reply-To: <d19c679218fcb43179a711740186781f3c29265a.camel@suse.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Apr 2021 16:51:42 +0300
Message-ID: <CAPpZLN6Rvh=zVx6O_QaZoU=1nuVWdW0jF_yiriSyZ10OWoQBtQ@mail.gmail.com>
Subject: Re: Instructions for clock sync for tracing host/guest
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 4:24 PM Dario Faggioli <dfaggioli@suse.com> wrote:
>
> On Mon, 2021-04-26 at 08:56 -0400, Steven Rostedt wrote:
> > On Mon, 26 Apr 2021 13:39:32 +0300
> > Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> > > >
> > > > There, I see the guest vcpu 0 is controlled by the host thread
> > > > with pid
> > > > 129042 and vcpu 1 is controlled by host thread pid 129043.
> > >
> > > It works only in case of one VM, if there are more than one -
> > > cannot
> > > map kvm_entry event to specific VM.
> >
> >  # trace-cmd record -e sched_wakeup -e kvm_entry
> >
> > And have this:
> >
> >     vsock-client-159876 [000]1346877108580652: sched_wakeup:
> > vhost-128994:129046 [120] success=1 CPU:006
> >
> >     vhost-128994-129046 [006]1346877108678708: sched_wakeup:
> > CPU 0/KVM:129042 [120] success=1 CPU:007
> >
> >        CPU 0/KVM-129042 [007]1346877109290044: kvm_entry:
> > vcpu 0
> >
> Mmm... This is quite interesting. But there's something I don't think
> I'm understanding.
>
>
> > Instead of looking at vsock-client, look at the current pid and see
> > what
> > "vhost" it wakes up, then see what what thread it wakes up, and then
> > see if
> > it calls kvm_entry. we don't even need to know if it is a vhost. Just
> > trace
> > everything that our current thread wakes up and what those wake up
> > until
> > something calls kvm_entry.
> >
> So, what's the mapping (like, mapping between what and what) that we
> are interested in here, and what kind of into trick with vsock-client
> is helping us gather, that we don't already have by "just" looking at
> the kvm_entry events?

trace-cmd uses guest name to find:
 <guest name> ->  vhost cid, port
 <guest name> ->  PID of the process, running the VM
PID of the process, running the VM -> PIDs of the threads, running each vCPU

the kvm_entry event has information about mapping <thread PID> to
vCPU, from that thread PID we could find the process which runs the
whole VM. The problem is to find the VM name, vhost cid and port using
that process ID, we couldn't find any generic and reliable way to get
that mapping. That's why the current implementation uses a qemu
specific hack - VM name, vhost cid and port are written in the qemu
command line, which we get from /proc/<qemu pid> and parse. This does
not work with non-qemu VMs.

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
