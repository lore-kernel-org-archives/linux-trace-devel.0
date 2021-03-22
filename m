Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99CFC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76D3861974
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCVKNf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCVKN1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 06:13:27 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938F5C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:13:26 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c204so10602167pfc.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qswiv1/+dGqVLSrShCsDWs74hzbhoxPOEtH4guss+9Y=;
        b=UpSK3Owzv3AAYZ+x5MbXcj288Pnaf2jJlIPcHux3m1fh5dwraGWoyZ6we2zyaqKipw
         fBGpLDCN2tlLb+MlIeTqPYZ4cN2uKvVRKz+4XW9ZeNhqb2Wm3Ntnj44II/Ewv3OD0KpL
         p4acYlcph0JFj9V7JIbo5ktbSO6jH1BO34FLJsNpvmps7Wx6GtvlQYfUVefbEg5HDVH1
         bLdpVlqg1BRSOVkDrN/5JfxSbFN8r8UU95ZzLrdlLBawEDktis5XbfUNj9Pz4Dynzbn1
         O1DUoo3rPl5kD5UQx8RjL5imfIywiVDjHhwD/s/o+DizI2+sAaoVygTCdVwRGNhwACMS
         ZeXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qswiv1/+dGqVLSrShCsDWs74hzbhoxPOEtH4guss+9Y=;
        b=PmBRxekFgByuylu6LJayvPM1JvqsYDZ+gCb6vvTiv7H/Q+BK9nBt7SIdJRpHAE6YMx
         671QuIJ68FO0of8i++0nRqWBVOoPcNvftRCwp1dzGf+e6g8iC/AO2ZrTY5n8aJoDKehq
         T4Yi90J8swociagPwIgcQM5zSnhvd60TajxQmGauOupOfNy/57Ku3wyCXzd15CRktmFh
         VTK7Iif6pjWLN1TEZRI2vIgjGHHZ8p3oawSeKuoA+GvR5qRQ2NslCkyC1lFTWrVRHXDa
         H5O138ijHt/2H/N61723UkhoRCgr2j6UrZRKnSBLtqMVszIfVRdN2BgmY2t2ZEDNl6XR
         3TUQ==
X-Gm-Message-State: AOAM531lAGQfAjKdY1pnJ1Vc0LjUNmAIV6Mo2yBJn+YV8XtnfWKXhXsd
        QEnYGK09olVY+ZyZE86AAECMGyXZBwXD3asoxdM=
X-Google-Smtp-Source: ABdhPJxNxHi+hUnkfbUkx0slZaSRAK+NTnldsvpxZ0JT/NSmomKtnMcC47C0hFFbJTKw4spDyw7UyjhOEryko7tZYEY=
X-Received: by 2002:aa7:9394:0:b029:1f4:2b30:4cdb with SMTP id
 t20-20020aa793940000b02901f42b304cdbmr21446016pfe.50.1616408006171; Mon, 22
 Mar 2021 03:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
 <6796a75b-6a59-767f-08ec-ee0cbfd8c825@gmail.com> <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
 <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com> <CAPpZLN4yn2qn7uqNLqkxdnHfM_5SdtkjPY41atY5m-FPG3rudA@mail.gmail.com>
 <0f6e158c-43a3-4117-2a17-5a13cd6a7970@gmail.com>
In-Reply-To: <0f6e158c-43a3-4117-2a17-5a13cd6a7970@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 22 Mar 2021 12:13:09 +0200
Message-ID: <CAPpZLN7ChRzU1b2t1KSbT+MB0An=CJJxnDizaO41K=XSz8sb6g@mail.gmail.com>
Subject: Re: [PATCH v32 0/5]Timestamp synchronization of host - guest tracing session
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

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

Confirmed, the problem is in the trace-cmd logic that works with the
KVM scaling.  Looks like tsc-scaling-ratio is the default KVM scaling
on your machine, (1 << 32), and in that case the scaling should be
ignored in our calculations. I still have no solution, going to
analyze how the KVM scaling works.

Thanks, Stafano!

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
