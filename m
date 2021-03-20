Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7101C433E3
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Mar 2021 11:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C4E619A3
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Mar 2021 11:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhCTLT6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 20 Mar 2021 07:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCTLTg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 20 Mar 2021 07:19:36 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99ACC0613E8
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Mar 2021 03:29:52 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c204so7633765pfc.4
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Mar 2021 03:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YmOKIiV9GbxCtTCl8YJAg9d/Aq5A8eeDDvZ3G+8i3qs=;
        b=BGRSDXWr+oGmeZpElS9zp8+1FX33+R8j3e/sqdAjI9IOzGZKwdQLaB5FeC3Y91NC8+
         5urL0035LHEa8ez+oVhsnXbpS8LaG2i0i9OYnkQaUK8bJzEk7zbZxZa0302zuVoJMiXx
         6C88UEccBpP9pSjatSiFF88Q5GYlFqxqgV278nL8iz5NcqDzXexpaUsTTzhR1jJjM6Hx
         /WSepI/kMAZUg5oCv27xl557gpArMgld7htXNEhjaDwiruh6H9fy6mVG4oXEkKx4JwCJ
         0CQMOPAXG7Ih+zfkEJ7WaA1IbqZoxXzRQJqfG3c58lkZ+K0oO+s/CG8hn7dPiZxwn2+B
         VKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YmOKIiV9GbxCtTCl8YJAg9d/Aq5A8eeDDvZ3G+8i3qs=;
        b=R22QG8MROwH87ioRAIReqd+HETT1m/xzbp1mIc6m6UO1ALJorQRMGK4wFGTNDwkfaI
         Y1lNfbWf6dJFf2EZ5JqA/erj43N/biAC3s5yIposcHhjRN1f8eCtNdWSuL8P5k35A+2Q
         DAOyik2kZ0ZP4KIMmtx3LA4QMxKLsfWZUhoK0yFsZnmpkS+0o8EYklpA4ymls7Zl1HbZ
         Qlmbu52b7j56VN7YJMV6bDBlCQAIBLVC+LoSsIl/sieHoiVtjx2IT6jqQhYkwTEd9a1N
         B2ODPdIdM4xqT+5iY9RjpR+aEgX8k0FKEru+aTMhCEVSqAmelhtLcOV3Te4F94fZnuqR
         jWgw==
X-Gm-Message-State: AOAM531k5Jlwf9RSSntiHPUxhIoVCsqTRqEO1BibtxnOKX18/yMVVDrR
        cxQwkCQb5uwans4d+lWNRDbPBisKTJ6WOQBCrKQaRLfOxQRohQ==
X-Google-Smtp-Source: ABdhPJxlwtGVAoqjfL+R5z48Tmrip2e8CbOiZt+fUX/utgX/uCRtBqF1Du6v4HhpT9FMeKV+k5Qex4tnS0cb+hf4wRw=
X-Received: by 2002:a63:c143:: with SMTP id p3mr5842954pgi.44.1616221565392;
 Fri, 19 Mar 2021 23:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
 <6796a75b-6a59-767f-08ec-ee0cbfd8c825@gmail.com> <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
 <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com>
In-Reply-To: <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Sat, 20 Mar 2021 08:25:48 +0200
Message-ID: <CAPpZLN4yn2qn7uqNLqkxdnHfM_5SdtkjPY41atY5m-FPG3rudA@mail.gmail.com>
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

On Fri, Mar 19, 2021 at 7:44 PM Stefano De Venuto
<stefano.devenuto99@gmail.com> wrote:
>
>
>
> On 3/19/21 12:55 PM, Tzvetomir Stoyanov wrote:
> > Hi Stefano,
> >
> > On Fri, Mar 19, 2021 at 12:08 PM Stefano De Venuto
> > <stefano.devenuto99@gmail.com> wrote:
> Hi!
> >> The commands used to record are:
> >>
> >> Host:
> >> # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
> >> msr:* -C x86-tsc sleep 1
> > The guest trace clock is set automatically as the host, so this
> > command should be enough:
> > # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
> > msr:*  sleep 1
> >
> >> Guest:
> >> # echo x86-tsc > /sys/kernel/tracing/trace_clock
> > There is no need to set manually the guest clock, it will be
> > overwritten by trace-cmd agent.
> >
> Thanks so much for the proper way to do it, really appreciated.
> >> If necessary, I can provide more info about my setup, or do more tests.
> > Yes, please can you send me both host and guest trace files ?
> Here are the trace files, host and guest respectively:
>
> - http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace.dat
> - http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace-tumbleweed.dat
>
> > Also, it will be useful to send me the content of the KVM debug files:
> >     /sys/kernel/debug/kvm/<guest ID>/vcpu<*>/tsc-offset
> The guest has one vcpu (vcpu0) and the content of the file is:
>
> 255647917761327

Looks like there is a scaling between host and guest clocks in your
setup, not just a simple offset. We did not test yet our
implementation with scaling, although both offset and scaling are part
of the calculations. That makes your use case very valuable for us, as
we have an opportunity to test it now. And yes, looks like we have a
bug here.
Please, when you have time, can you repeat again the tracing session
and send again both trace files + the content of the KVM debug files:
     /sys/kernel/debug/kvm/<guest ID>/vcpu0/tsc-offset
     /sys/kernel/debug/kvm/<guest ID>/vcpu0/tsc-scaling-ratio
I'm asking to do a new trace, as most probably these offset and
scaling could be different now.

Thanks!

> >>
> >> Thanks and Regards,
> >>
> >> Stefano
> > Thanks for testing this code!
> >
> Thanks for your time,
>
> Stefano



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
