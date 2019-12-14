Return-Path: <SRS0=Y+mp=2E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8D8C43603
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 Dec 2019 15:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7FD520706
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 Dec 2019 15:39:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4MHvgDV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfLNPjI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 14 Dec 2019 10:39:08 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43113 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfLNPjI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 14 Dec 2019 10:39:08 -0500
Received: by mail-ed1-f68.google.com with SMTP id dc19so1538497edb.10
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 Dec 2019 07:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oyyCdQ15bvjUBH+vbCGgddX5QGcJampe1IvyK8c9RIQ=;
        b=N4MHvgDV5/lDtpVvPQGIXQry9jt2RfkIfzDevu5iCdTLz8OwfR8Jrhnvl0ru4p48lr
         /F2xHOMRzvXzyr08K2Lxd/C1AMt6TYblTSCy6nk0MNbvEEyBQJMTNSQ1/j2lejkxOmL/
         8mZbUx//K8ggAL1FmfrJ1WSMdOQiFF40p5lg9RW53D1MfDDNBB5Bsy6SQig1f9FogNBf
         nEx6u/BsGXp+fJeiDHGfAO/CWQRfg7kop7B+LSOfQF5NNtrk8VaQd05KeYQ2LGSXpc8X
         LUkW18KQHxhsynmaowDeavn1rx6MXWSLA8r47MwV8DUq99JIFtBl31NT70o/PaDdl8yo
         9H6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oyyCdQ15bvjUBH+vbCGgddX5QGcJampe1IvyK8c9RIQ=;
        b=URa8qVd6/wVu6GfzPt0Zee6+FUxdE0SOxliLjNd4TTmZdDllESpY1HEs5ofrtJffFt
         R86QtVarlS0HasGmRd6vxxHu/6899Lxy5U9UPwYhq3aZPVSYbc2FB5ruWKo2+lHbPbne
         CGUPiTsNUk6S6MBHT9I0DgvSbsUcJ8iqo5ntyDl85/AzEhucmc3Pr12PkSqZ325kezfJ
         w7g2IBW435B7BxW3Iboh0iyex5QMdiKNLMv+HzJmGdD5X43CNY8RH8E2hh4c/Y0tjROl
         OcWaEXnrmXHw5QQZdUQZMghnG/ioZr7+BiUWSqDZqYdWnbFDFti11NgVCQrHBkamKeFX
         pofw==
X-Gm-Message-State: APjAAAUHP0n/DoOlAo6r3xeYROqDyv82Rx7yv+FR4THLXbkBjuVkllSR
        tbnDajmyXl7tAAfjYhrPTLXOUpWgb7vsxRTS08E=
X-Google-Smtp-Source: APXvYqzxRF3sfHM0E8Y2Vfi4iyhwNnjXNNsLi6JqEQ3WzDLyUqS5jK63jFZBj8F0CBp9oRjLG8egg/iG/VfT2v+js+E=
X-Received: by 2002:aa7:d8d7:: with SMTP id k23mr9991075eds.287.1576337946493;
 Sat, 14 Dec 2019 07:39:06 -0800 (PST)
MIME-Version: 1.0
References: <CAJ8z9b0dJrkpDsU8-XWQbVVKqtocCPG+ARO4rkdboxLX_dJ2DA@mail.gmail.com>
 <20191212122538.58747672@gandalf.local.home>
In-Reply-To: <20191212122538.58747672@gandalf.local.home>
From:   John Koepi <john.koepi@gmail.com>
Date:   Sat, 14 Dec 2019 17:38:30 +0200
Message-ID: <CAJ8z9b1RD4gyPg8_B2sW=ULEjLRLTZrCAWc=k2=d8wSrhMBbOQ@mail.gmail.com>
Subject: Re: traceevent support for kernels with CONFIG_GCC_PLUGIN_STRUCTLEAK=y
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Filed at https://bugzilla.kernel.org/show_bug.cgi?id=205857

-- Ivan

On Thu, Dec 12, 2019 at 7:25 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 12 Dec 2019 19:07:46 +0200
> John Koepi <john.koepi@gmail.com> wrote:
>
> > > $ cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_io_submit/format
> > > name: sys_enter_io_submit
> > > ID: 897
> > > format:
> > > field:unsigned short common_type; offset:0; size:2; signed:0;
> > > ...
> > > field:struct iocb __attribute__((user)) * __attribute__((user)) * iocbpp; offset:32; size:8; signed:0;
> > > ...
> >
> > Having __attribute__ leaked into syscalls format, it makes its
> > impossible for the traceevent lib from the kernel/tools/lib to
> > parse such fields, like in the example above.
> >
> > This in its turn makes it impossible to use tracing for those syscalls:
> >
> > > $ sudo perf record -e syscalls:sys_enter_io_submit -aR
> > > libtraceevent: No such file or directory
> > >  Error: expected type 4 but read 5
> >
> > Thus, tracing does not work for some syscalls in Arch Linux kernels.
> > And I suppose for all kernels that built with structleak plugin support.
> >
> > Reproduce: https://github.com/sitano/traceevent_attribute
> >
> > My question:
> >
> > Is it a bug that the traceevent lib does not support parsing __attribute__
> > in syscalls formats?
> >
> > or it is a bug of the SYSCALL_DEFINEx macroses / build system that
> > they do allow C attributes to leak?
> >
> > maybe this is already fixed in the latest kernel? or maybe I am missing
> > something?
>
> Thanks for the report. This looks like something we can have
> libtraceveent handle, no need to change the kernel.
>
> Could you file a bug report?
>
>   https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---
>
> -- Steve
>
