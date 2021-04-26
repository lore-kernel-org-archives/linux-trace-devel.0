Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685FBC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB3A61040
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhDZK7S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbhDZK7R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 06:59:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5F1C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:58:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso7557428pjb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6k1QuMWi1DXuxABNFQX31QxnfvmtMyDHcPnlY6P3pg0=;
        b=KhZ0EEHSgbEIAocAAoQiceO+B7Ta7CjAh613kr/MS1yndwNkMPOk00hTUbAdBdC/u0
         gBzxBtdDgrKOrp82P3b0M4h9KbJA0B+gVOiJIVR4oGq0GrA67IHuKYfYP8BIbNFBtzHA
         61s157J7g6/iWoNZ8qHduxiKuWZpYc3DhRjYsUxOsJ9P80IjcXJGVRy0c21Uiq6iQCye
         mDF0Z2Metg7JukIiPQCBz44OmSG70o7Www7m8VbxvN4TK41TBZeClywr2Trdqy6p1yVm
         MiSZyoeeI26msqDKi0x0PSdrALiEnBFDikgx0zS+XHcn1UaQ+DOIS1jhu/Q6ybnCkQet
         /qrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6k1QuMWi1DXuxABNFQX31QxnfvmtMyDHcPnlY6P3pg0=;
        b=f9qAaQJYdvmr8eiAbH2hg0WSKbjya6zDQH5AbIavsWvRvrzCA22iuN/G0vM/BqcLQA
         sUAaFdA6pQ044sEsptMOakhk7C0YFg+YSQZxsvQy0ozuil4isGzGi2H76N2FHSNPua8S
         DzY7nxKyuQmFvhq3gvGG1ql2Fpfi9d6uC3Whbj0BFAUDvjwJcL1YlLRgEP6ooUj7Vhax
         ip+wauE/OkAQctE+wzA403SzS3dbFJs8HEKd2of4pe08+4Onq6ONhx8OtX5Sw5zB1GB6
         3YsfVQzy9N3g1BxVzUstl24pRtxkFVrO5RG3VPe9PE700VTVuWKYtGmdukpOoR3AEX2x
         cqTg==
X-Gm-Message-State: AOAM531K/UPGRsrHnwpwBjTbepzGA/fDAi4X/SOnLvbZFHQ5EHKdU7BV
        c2qkKhQiYH79kQeed2liQyNDQL75p4eRZ0Gy+fI=
X-Google-Smtp-Source: ABdhPJwD/cmi8IoR94pvvNd8Usu3i9RhsJbwk6TsCR8hJj2hR38JomgY6G/LVylLIuZ8GHj+D7i5dvq+y32JN5+yZf0=
X-Received: by 2002:a17:902:122:b029:e8:bde2:7f6c with SMTP id
 31-20020a1709020122b02900e8bde27f6cmr18348288plb.29.1619434715412; Mon, 26
 Apr 2021 03:58:35 -0700 (PDT)
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
 <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
 <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
 <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com> <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
In-Reply-To: <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Apr 2021 13:58:18 +0300
Message-ID: <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
Subject: Re: Instructions for clock sync for tracing host/guest
To:     Joel Fernandes <joelaf@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 23, 2021 at 11:37 AM Joel Fernandes <joelaf@google.com> wrote:
>
> Apologies for the top post as I'm on Gmail mobile and only half awake at =
4.30am.  I should check but can we just scrape the crosvm PIDs from the hos=
t trace itself ? The vCPU threads are in scheduler events in the host trace=
. Of course that wouldn't work if we don't have events. Let me know if that=
 works for you or if I should find another way.
>
> By the way if sync is supposed to fall back to the ptp algo, why did it n=
ot fallback for me?

Because of a bug in the code. It assumes if KVM is detected, then qemu
is used to run the VMs.

>
> Other thoughts:
> - it would be cool if trace cmd agent was run by the host directly on the=
 guest. That might eliminate a step. I can try to see if that's possible wi=
th crosvm but it's not super high priority.

That will require to have some already established communication
channel between host and guest. We can use ssh for example, but the
user must set up in advance ssh server and pass credentials to
tracec-cmd on the host.

>
> Yes thanks for sending me any patches and happy to try.

Just sent a patch that should fix the problem. Please, test it when
you have time. The PTP-like algorithm will be used for trace
timestamps synchronization, the best accuracy can be achieved using
mono_raw trace clock:
   host# trace-cmd record -e <host events> -C mono_raw -A test@32:823
-e <guest events>

Steven, may be mono_raw clock should be the default in this case, when
PTP is used for the synchronization ?

>
>
> On Fri, Apr 23, 2021, 4:17 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> =
wrote:
>>
>> Hi Joel,
>>
>> On Fri, Apr 23, 2021 at 1:50 AM Joel Fernandes <joelaf@google.com> wrote=
:
>> >
>> > Looks like my trace.dat files bounced from goodmis.org so I uploaded t=
hem here:
>> > https://drive.google.com/file/d/16wGsVo4PJ0kYQGAy195dfBW0RHSWVkx0/view=
?usp=3Dsharing
>> >
>> > ---------- Forwarded message ---------
>> > From: Joel Fernandes <joelaf@google.com>
>> > Date: Thu, Apr 22, 2021 at 6:46 PM
>> > Subject: Re: Instructions for clock sync for tracing host/guest
>> > To: Steven Rostedt <rostedt@goodmis.org>, Yordan Karadzhov (VMware)
>> > <y.karadz@gmail.com>
>> > Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
>> >
>> >
>> > On Thu, Apr 22, 2021 at 5:12 PM Joel Fernandes <joelaf@google.com> wro=
te:
>> > >
>> > > On Thu, Apr 22, 2021 at 4:03 PM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>> > > >
>> > > > On Thu, 22 Apr 2021 15:49:21 -0400
>> > > > Joel Fernandes <joelaf@google.com> wrote:
>> > > >
>> > > > > On Thu, Apr 22, 2021 at 3:48 PM Steven Rostedt <rostedt@goodmis.=
org> wrote:
>> > > > > >
>> > > > > > On Thu, 22 Apr 2021 15:43:37 -0400
>> > > > > > Joel Fernandes <joelaf@google.com> wrote:
>> > > > > >
>> > > > > > > >  # trace-cmd record -e irq -e sched -e kvm -A test@32:823 =
-e sched
>> > > > > > >
>> > > > > > > OMG, that worked, thank you Steve and Tzvetomir !!!!!
>> > > > > >
>> > > > > > Technically, you can probably leave off "-e irq", but I do fin=
d it rather
>> > > > > > useful. But then, I add "-e irq" to the guest as well. It lets=
 me see how
>> > > > > > interrupts transpire from the host to the guest.
>> > > > >
>> > > > > Got it thanks for the tip. Will report back any issues I see.
>> > > >
>> > > > And you know you can pull this up into KernelShark as well, right?
>> > > >
>> > > > Checkout the development version from Yordan's repository:
>> > > >
>> > > >
>> > > >  $ git clone https://github.com/yordan-karadzhov/kernel-shark.git
>> > > >  $ cd kernel-shark
>> > > >  $ git checkout origin/yordan_devel
>> > > >  $ cmake .
>> > > >  $ make
>> > > >  $ sudo make install
>> > > >
>> > > > Then run kernelshark with:
>> > > >
>> > > >  $ kernelshark trace-host.dat -a trace-guest.dat
>> > > >
>> > > > (obviously, using the actual names of the trace.dat files for the =
host and
>> > > > the guest)
>> > > >
>> > > > Then you can select: Plots -> KVM Combo Plots
>> > > >
>> > > > Then select the "all" box, and then apply. Then you get something =
like this:
>> > > >
>> > > >   http://rostedt.org/private/ks-host-guest.png
>> > > >
>> > > > Where you see how the tasks mapping to the host and guest are alig=
ned.
>> > > >
>> > > > That is, if everything works fine.
>> > >
>> > > Yes, I sort of knew KernelShark had this support, but so glad you se=
nt
>> > > me more details on how to do it, I'll try it out. I am also wonderin=
g
>> > > how the bars of the vCPUs will look like because you can have vCPU
>> > > threads migrated to different physical CPUs. I will go try it out an=
d
>> > > see what comes up :-)
>> >
>> > Hi all, Just wanted to report my progress today:
>> >
>> > When I try to open the guest+host trace with the yordan_devel branch a=
nd command
>> > kernelshark ~/vm-host-trace/trace.dat -a ~/vm-host-trace/trace-test.da=
t
>> >
>> > I get the following in the console: https://pastebin.com/raw/EmbsyuB8
>> >
>> > And the GUI looks like the attached picture, I don't see any mention
>> > of KVM like Steve sees in
>> > http://rostedt.org/private/ks-host-guest.png . What am I missing?
>> >
>> > I also zipped and attached my trace files to this email. Could you
>> > take a look at them?
>>
>> Looks like there is a gap in our implementation, affecting your use
>> case. We rely too much on the quemu guest information that we gather,
>> which is missing on your setup. As this information is not mandatory,
>> the implementation should not rely on it. What we need:
>>  - PID of the process, running the guest VM. In case of KVM, we use
>> this PID to get the KVM guest TSC clock parameters, needed for better
>> host and guest trace timestamps synchronization. Without this PID, KVM
>> cannot be used for timestamps synchronization. The logic should fail
>> back to a PTP-like algorithm, which is more generic, works in all
>> environments, but is less accurate than KVM logic.
>>  - PIDs of each thread, running a guest virtual CPU. This is not
>> required for the tracing, but for better trace visualisation in
>> KernelShark. It helps to map the host task to a vCPU and to visualise
>> them together.
>>
>> Currently we collect that information from quemu, is there a way to
>> get it from crosvm ? If yes, a crosvm support can be implemented in
>> trace-cmd. But as I said, it is not mandatory to have it for the
>> trace, I can send you a patch next week addressing this gap in the
>> implementation.
>>
>> Thanks for testing this code!
>>
>> >
>> > My kernelshark HEAD commit is: 070d657 ("kernel-shark: Add KVMCombo
>> > plugin") . Let me know if I should be building some other commit sha.
>> >
>> > Adding Yordan to this email as well.
>> >
>> > Thanks a lot!
>> > -Joel
>>
>>
>>
>> --
>> Tzvetomir (Ceco) Stoyanov
>> VMware Open Source Technology Center



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
