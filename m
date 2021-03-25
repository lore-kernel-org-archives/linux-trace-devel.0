Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D66C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D9C61A1A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCYHVG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhCYHUf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 03:20:35 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529ADC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:20:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x26so1160186pfn.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7kpJIKQz1C8+VDMfZKeBH/MMbuMLtuO8WUM+nkFghvc=;
        b=pjP1OMaQmppNUNaSk0Eq0BYwh61CditRblkU6j7fM3a5+9kJp8qPzLyOBHHcgrfnFe
         wrfSiOlvXWvQzrIr6XNam7u0DogexLmJD60WAlnHhO5VuveysWRzGlJNDCRhMP6CBJDZ
         YVwPdtWq2iRnIzB7XGCXg4aRex7y0m2PeJHfX89lIKKpTkDZJK1NmuU0hgzN/qAwSFlF
         RlsdwC7mblA88SPymmnXzOptN3itY7PDRdGOFFV+FU2FER7edjaOznnJzfPAhrgGfZC5
         E7xaiCGcR6oF7HnpmRA0ds8x5zsGbwFJ1XHjl7yq+UHgYmWRF5uza7VEMOQw7Z/Z465y
         lZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7kpJIKQz1C8+VDMfZKeBH/MMbuMLtuO8WUM+nkFghvc=;
        b=et76AUvVA2PSxxGXf0da3GCw1zwB3zJFQ+dH8WZjA5fQFDxFaLTDp+uaZt/zO6D22X
         Pj2W630XxRxCbZ4RdtlEQJQS03qtu9aomB/ebNKUrhzhZdLD4x4aHOHEcQvJYRpX9OwO
         TgLrXTnzYf3gzHdBeT/ryeuBMCCTOAv656qZAaZG3lWdEsbxlANnqOWJAhRSdx32Mbov
         0DYsf5HnopuozThqk50CQ2jIYqnHd1JZI0jzcmuXwxgeSeDJM7juOPUJoWaPrITSwELL
         rQ+fSw+MgZunhXMUc/+qo7bG5VI0XP7NTmB4MdSiaxFCZwpuBXQERbpkBZzqmONN2wUt
         L02w==
X-Gm-Message-State: AOAM532qxaH6zN4DhKp/ygRZhqtyrypRMQo29ugiALfPRqc13AiboWC1
        +bLepkCg6Y61zvWTLGNaJFJZ6z+USJ+HNGsQnTM=
X-Google-Smtp-Source: ABdhPJyLoew+jQrdyEkCk713W4eS6NWeTxAFeRIlbMko/XCAWczcLo10DY4JfW8hFL3TtDYYayuRDqvcU1OSmSDwJSw=
X-Received: by 2002:aa7:8488:0:b029:1fc:f312:b24e with SMTP id
 u8-20020aa784880000b02901fcf312b24emr6396679pfn.55.1616656834692; Thu, 25 Mar
 2021 00:20:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
 <6796a75b-6a59-767f-08ec-ee0cbfd8c825@gmail.com> <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
 <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com> <CAPpZLN4yn2qn7uqNLqkxdnHfM_5SdtkjPY41atY5m-FPG3rudA@mail.gmail.com>
 <0f6e158c-43a3-4117-2a17-5a13cd6a7970@gmail.com>
In-Reply-To: <0f6e158c-43a3-4117-2a17-5a13cd6a7970@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 25 Mar 2021 09:20:18 +0200
Message-ID: <CAPpZLN5HcuFnN9_gMnS=JKeu3p9dEUWHmF6iwoh-mLPz=6WaiQ@mail.gmail.com>
Subject: Re: [PATCH v32 0/5]Timestamp synchronization of host - guest tracing session
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Stefano,

On Sat, Mar 20, 2021 at 6:17 PM Stefano De Venuto
<stefano.devenuto99@gmail.com> wrote:
>
>
>
> On 3/20/21 7:25 AM, Tzvetomir Stoyanov wrote:
> > Hi Stefano,
> >
> > On Fri, Mar 19, 2021 at 7:44 PM Stefano De Venuto
> > <stefano.devenuto99@gmail.com> wrote:
> >>
> >>
> >> On 3/19/21 12:55 PM, Tzvetomir Stoyanov wrote:
> >>> Hi Stefano,
> >>>
> >>> On Fri, Mar 19, 2021 at 12:08 PM Stefano De Venuto
> >>> <stefano.devenuto99@gmail.com> wrote:
> >> Hi!
> >>>> The commands used to record are:
> >>>>
> >>>> Host:
> >>>> # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
> >>>> msr:* -C x86-tsc sleep 1
> >>> The guest trace clock is set automatically as the host, so this
> >>> command should be enough:
> >>> # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
> >>> msr:*  sleep 1
> >>>
> >>>> Guest:
> >>>> # echo x86-tsc > /sys/kernel/tracing/trace_clock
> >>> There is no need to set manually the guest clock, it will be
> >>> overwritten by trace-cmd agent.
> >>>
> >> Thanks so much for the proper way to do it, really appreciated.
> >>>> If necessary, I can provide more info about my setup, or do more tests.
> >>> Yes, please can you send me both host and guest trace files ?
> >> Here are the trace files, host and guest respectively:
> >>
> >> - http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace.dat
> >> - http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace-tumbleweed.dat
> >>
> >>> Also, it will be useful to send me the content of the KVM debug files:
> >>>     /sys/kernel/debug/kvm/<guest ID>/vcpu<*>/tsc-offset
> >> The guest has one vcpu (vcpu0) and the content of the file is:
> >>
> >> 255647917761327
> > Looks like there is a scaling between host and guest clocks in your
> > setup, not just a simple offset. We did not test yet our
> > implementation with scaling, although both offset and scaling are part
> > of the calculations. That makes your use case very valuable for us, as
> > we have an opportunity to test it now. And yes, looks like we have a
> > bug here.
> > Please, when you have time, can you repeat again the tracing session
> > and send again both trace files + the content of the KVM debug files:
> >      /sys/kernel/debug/kvm/<guest ID>/vcpu0/tsc-offset
> >      /sys/kernel/debug/kvm/<guest ID>/vcpu0/tsc-scaling-ratio
> > I'm asking to do a new trace, as most probably these offset and
> > scaling could be different now.
> Yes, the trace files are attached to this mail.
>
> The content of tsc-offset is:
> 453568564244284
>
> The content of tsc-scaling-ratio is:
> 4294967296
>
Just submitted the v33 of the patch set, added a check for a
non-default KVM scaling. Now it should work on your setup, as the KVM
scaling there looks to be the default. I didn't test it, as we have no
machine which supports KVM scaling. This is just a workaround, we have
to implement support to KVM scaling in our algorithm.
Please, can you test if it is OK ? Note, you have to apply  these
patch sets also, as there are dependencies:
   v2 Refactoring and improvements of time sync logic
   v4 TSC trace clock to nanosecond conversion

Thanks for testing this code!

>
> Thanks and Regards,
>
> Stefano
>
> >
> > Thanks!
> >
> >>>> Thanks and Regards,
> >>>>
> >>>> Stefano
> >>> Thanks for testing this code!
> >>>
> >> Thanks for your time,
> >>
> >> Stefano
> >
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
