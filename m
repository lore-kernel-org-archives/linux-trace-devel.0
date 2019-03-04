Return-Path: <SRS0=JN9e=RH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70231C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 05:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E8020815
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 05:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="rzeLVpeH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfCDFl2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 00:41:28 -0500
Received: from conssluserg-02.nifty.com ([210.131.2.81]:47900 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfCDFl2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 00:41:28 -0500
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x245fLAA025290;
        Mon, 4 Mar 2019 14:41:21 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x245fLAA025290
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1551678082;
        bh=fd7Of/RFciDnI4bwj/V+dn8GdN2GPKprLJQyL4wxXBo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rzeLVpeHhvhjaYqrZPwzSjiGj6fQr4nHdGGLHLFTTlTm+KNTfqrW7SeR3dxmJn+7H
         9v9gxfe54Sc9/lZtmsFsyLvhfcBrFeaFicXGLuMgsIERwGXnDrnCP+yTF9VlaQ+pEk
         D4/YgkC0oghPcx9AtlWf3BkfmHhNntzwjlhYuAC8CYsYfdEzixo+wUarLU6IdoMrqS
         OYF578TAkJPHdHFDV9lHa5nRKXp4oKcu7oVjovg40/om8cZYP1Wkto9+BM/jfq2uE8
         TIIcCU47G7R1TxKr3xci3lacfra1k+pxwLKgqw5d4/N32BcgpnVeQnhyluVEFC22T+
         XUE+LBmyDtoTw==
X-Nifty-SrcIP: [209.85.222.41]
Received: by mail-ua1-f41.google.com with SMTP id f88so3341693uaf.2;
        Sun, 03 Mar 2019 21:41:21 -0800 (PST)
X-Gm-Message-State: APjAAAVC2XSIcRt+dvC2VOiCt6dE5PoAdLvZ2Q7XFFXPOftYQYP/2gDp
        heKxP4qL2KhCBZ+FOB3/PzYPv2txAYwcLJl3GAI=
X-Google-Smtp-Source: APXvYqyPPEx0wGlFVEm5kGkNBVxHvI83kgzQe50YS8QPN8XSsohyGA0FlLJZ79hNleEgd4ICUcEybcckSWwaCV9cGyk=
X-Received: by 2002:a05:6102:18f:: with SMTP id r15mr8771531vsq.215.1551678080712;
 Sun, 03 Mar 2019 21:41:20 -0800 (PST)
MIME-Version: 1.0
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com>
 <20190228144306.GA138215@google.com> <CAK7LNARTHJP=HzyBg_oBBL4whpxHXeijqk=zKLYpt=1GBLNGAA@mail.gmail.com>
 <20190301171954.GA217990@google.com> <CAK7LNAShVt=zOPP1TUuBbR_H8kmc+zuLAyRXucjMMKrALkW_6A@mail.gmail.com>
 <20190302023940.GA55262@google.com>
In-Reply-To: <20190302023940.GA55262@google.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 4 Mar 2019 14:40:44 +0900
X-Gmail-Original-Message-ID: <CAK7LNATjNE2g_HJnuqvTU7NuUeeUCa0Ogxf0Qru0yzkOT+n2-w@mail.gmail.com>
Message-ID: <CAK7LNATjNE2g_HJnuqvTU7NuUeeUCa0Ogxf0Qru0yzkOT+n2-w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        qais.yousef@arm.com, Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

> > > > Let me ask one more question.
> > > >
> > > > I guess this patch is motivated by
> > > > how difficult to convey kernel headers
> > > > from vendors to users.
> > > >
> > > > In that situation, how will the user find
> > > > the right compiler to use for building external modules?
> > > >
> > > >
> > > >
> > > >
> > > > Greg KH said:
> > > >
> > > > We don't ever support the system of loading a module built with anything
> > > > other than the _exact_ same compiler than the kernel was.
> > > >
> > > >
> > > > For the full context, see this:
> > > > https://lore.kernel.org/patchwork/patch/836247/#1031547
> > >
> > > IMO this issue is not related to this patch but is just an issue with
> > > building external modules in general.
> >
> >
> > I do not think it is an issue of the build system, at least.
> >
> > As far as I understood Greg's comment, it is troublesome
> > without the assumption that vmlinux and modules are built
> > by the same compiler.
> > It is related to this patch since this patch assumes use-cases
> > where external modules are built in a completely different environment,
> > where a different compiler is probably installed.
>
> Yes, but what I'm trying to say is the same issue exists with all other
> solutions today that do this. Such as debian you have linux-headers package.


Distributions provide the compiler in the standard path (/usr/bin/gcc),
and users are supposed to use it for building external modules.
That's the difference.



> A user could totally use the build artifacts obtained from somewhere to build
> a kernel module with a completely different compiler. That issue has just to
> do with the reality, and isn't an issue caused by any one solution such as
> this one.  I agree care must be taken whenever user is building external
> kernel modules independent of kernel sources.  Did I miss something else?
>
> thanks a lot,
>
>  - Joel
>

--
Best Regards
Masahiro Yamada
