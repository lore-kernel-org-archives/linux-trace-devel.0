Return-Path: <SRS0=bzY5=YX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7B0CA9EC5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Oct 2019 11:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51E1A2054F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Oct 2019 11:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZXEXkY5N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfJ3LV5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 07:21:57 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38954 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfJ3LV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 07:21:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id y3so2219616ljj.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Oct 2019 04:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+5tgIc7NKlP13RxDmMGjXSk9aMJhynDI2P7YlJkgyI=;
        b=ZXEXkY5Ndof4MYocfA3heTD+yLCHvo6iFCvacATfbb7eg1Xl/gb2Ro79f5dWdFcwdh
         65ewjNgF/7eHsTYh2tPSP/Pym1ZrM1o1rTRCVgr5pju5dr/i04YK8L/ELHBW3T/2ekJe
         lic5Qv3eInHuscY8Aqsss33lm/yUpge67W1lPVOcJnzE5wIyOGvT6SchCL9xiSrTPj3y
         RZEL0yuSlqAGpabX9wckGx0HkEp9tchgT1FkptWaGESXz3dJ+M7rfa9IjAfOHaox6zxn
         CNC88dDtFcFL2SvcgjxM3kQ4PKANYLUhjFxo2WnzsOaVpBB16xdPMkL4N81PLiNrKdSs
         jclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+5tgIc7NKlP13RxDmMGjXSk9aMJhynDI2P7YlJkgyI=;
        b=Bb/H5+zWEyRqokG/UOPGds7zgFy9ShcDDICREevDOT4iZXji3fz2ge6Md+xQaIW1A4
         EX1XfQffdXUsVsosczyBNzVYQnEG0sT91YM4BfnZUGVrM5Lp7DMAFvnIJpuOk1utWKe3
         nP/a3dFBLtQ5QUnnvh5UEvz36Ljbx30+R5LzWvVR0ak5pK0HUmmqzq9nWHbcgbwl1BZe
         w+aajVd6aLuphaWgP+57cJsVx7smR8kkEI+jybDgfEwZNBnpkQjqLZAtl9cJ6Y2aZ4uK
         ruXT0t7/pnl9cWkTcLA6tRtme2DvlRtXbzSlcbgBWoFu4NFQztXgSQgYdHYScYhm+Si9
         7OBA==
X-Gm-Message-State: APjAAAUvt2o+SR8g7ENlRyAb8MNowTHm+0kCABBCb/dTcH8R9+tsUju4
        nA8w57XNVOPPServQfLNUckY1c/7Li6r1nNsQKoaP1G7lAg=
X-Google-Smtp-Source: APXvYqzLsjUmiyMk7mQIqEBkWx+7s2G2Uv4V174MWYGp6z7L0D2DpWf/lUoJ75gf1nkkcauibk3th80Nh4wXgy74MtM=
X-Received: by 2002:a2e:9249:: with SMTP id v9mr2047103ljg.184.1572434514459;
 Wed, 30 Oct 2019 04:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191029180731.2153b90c@canb.auug.org.au> <CADYN=9+aqqHVP8tKFFCTKi_zzSt=PW5JVyU2sdaThgrHpYSjzQ@mail.gmail.com>
 <20191030105553.GH25745@shell.armlinux.org.uk>
In-Reply-To: <20191030105553.GH25745@shell.armlinux.org.uk>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 30 Oct 2019 12:21:43 +0100
Message-ID: <CADYN=9L4i7BWcdhOdG-AFQjuZBU=gv7UjcV6CaO2f0q_KJKhVg@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 29
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 30 Oct 2019 at 11:56, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> Please trim your replies; there's no need to force everyone to page
> through 500 lines of Stephen's email to get to the content of your
> message.

Right, I'll keep that in mind next time.

>
> On Wed, Oct 30, 2019 at 11:25:19AM +0100, Anders Roxell wrote:
> > When I'm building an arm kernel with this .config [1], I can see this
> > build error on next tag next-20191029 and next-20191030. Tag
> > next-20191028 built fine.
> >
> >
> > $ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -skj$(getconf
> > _NPROCESSORS_ONLN) O=obj-arm-20191029 zImage
> > arm-linux-gnueabi-ld: kernel/trace/trace_preemptirq.o: in function
> > `trace_hardirqs_on':
> > trace_preemptirq.c:(.text+0x2a0): undefined reference to `return_address'
> > arm-linux-gnueabi-ld: trace_preemptirq.c:(.text+0x2dc): undefined
> > reference to `return_address'
> > arm-linux-gnueabi-ld: kernel/trace/trace_preemptirq.o: in function
> > `trace_hardirqs_off':
> > trace_preemptirq.c:(.text+0x468): undefined reference to `return_address'
> > arm-linux-gnueabi-ld: trace_preemptirq.c:(.text+0x494): undefined
> > reference to `return_address'
> > arm-linux-gnueabi-ld: kernel/trace/trace_irqsoff.o: in function
> > `start_critical_timings':
> > trace_irqsoff.c:(.text+0x798): undefined reference to `return_address'
> > arm-linux-gnueabi-ld:
> > kernel/trace/trace_irqsoff.o:trace_irqsoff.c:(.text+0xed4): more
> > undefined references to `return_address' follow
> > make[1]: *** [/srv/src/kernel/next-testing/Makefile:1074: vmlinux] Error 1
> > make[1]: Target 'zImage' not remade because of errors.
> > make: *** [Makefile:179: sub-make] Error 2
> > make: Target 'zImage' not remade because of errors.
>
> Known problem with one of Ben Dooks patches, which was dropped very
> quickly when Olof's builder spotted the issue...

aha, I missed that.

> though it looks like
> I didn't push it out.

OK.

Cheers,
Anders
