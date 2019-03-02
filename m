Return-Path: <SRS0=q9un=RF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA59C43381
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 Mar 2019 02:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CD120830
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 Mar 2019 02:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="JDYOPLMI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfCBCNv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 21:13:51 -0500
Received: from conssluserg-05.nifty.com ([210.131.2.90]:64263 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfCBCNv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 21:13:51 -0500
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x222Di3H013972;
        Sat, 2 Mar 2019 11:13:44 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x222Di3H013972
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1551492825;
        bh=XbXan2AURT+UfKxn+6S042gHQGOknCAdduMwYMBjJM4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JDYOPLMIGZd1krPxT2Y2vIuqEZuky15ly+gQsFy2YwTyLTmOmHPjRjg4UxMHHhgaO
         +oRluAjIyA8pxGHfbRbmoBjTO/DwmMaEZ4/fUoYmN4WmvZ34RuRH0gUMIntpBQOMTf
         2YG7JLBlQjcEqeueDPy1ooF77DzWMK0mYOQemvpO/klUSFAdfe7MIXmjw5cop8kKhC
         kONMwDPTqLK/mWbuxeUrM9CrWp+s6f8SHMEs/634y1eVL8x1VGekP21MPskIxZZkTu
         gmTBG5QjYa23xH3lb4zQqfYNJAKQsm7DoHLmgdoUlcq37jzlLCO76cuftoHxo5Pf1R
         O2jXytJIuh0pw==
X-Nifty-SrcIP: [209.85.221.181]
Received: by mail-vk1-f181.google.com with SMTP id l62so6135257vkh.0;
        Fri, 01 Mar 2019 18:13:44 -0800 (PST)
X-Gm-Message-State: APjAAAUVaPecn6Qs1xoyLsCE9JE9xBm5/agVAwY3ExhPEkNeA9dlj7Av
        BgTjZ5Jb0S/ZO4N7/sIDvpoEub1WU5MZREOQTaU=
X-Google-Smtp-Source: APXvYqxJSj4E6d2FxisV/Gt0QMyXD3cUgk6pVEEQqAlHRoDu8/Am7aez5bzltKvKoynh/lWF4nFWLMkiCgbgZASpzcg=
X-Received: by 2002:a1f:9788:: with SMTP id z130mr4633346vkd.0.1551492823456;
 Fri, 01 Mar 2019 18:13:43 -0800 (PST)
MIME-Version: 1.0
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com>
 <20190228144306.GA138215@google.com> <CAK7LNARTHJP=HzyBg_oBBL4whpxHXeijqk=zKLYpt=1GBLNGAA@mail.gmail.com>
 <20190301171954.GA217990@google.com>
In-Reply-To: <20190301171954.GA217990@google.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 2 Mar 2019 11:13:07 +0900
X-Gmail-Original-Message-ID: <CAK7LNAShVt=zOPP1TUuBbR_H8kmc+zuLAyRXucjMMKrALkW_6A@mail.gmail.com>
Message-ID: <CAK7LNAShVt=zOPP1TUuBbR_H8kmc+zuLAyRXucjMMKrALkW_6A@mail.gmail.com>
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

On Sat, Mar 2, 2019 at 3:03 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Fri, Mar 01, 2019 at 03:25:05PM +0900, Masahiro Yamada wrote:
> [...]
> > > > I am guessing the user will run these commands
> > > > on the target system.
> > > > In other words, external modules are native-compiled.
> > > > So,
> > > >
> > > >   target-arch: arm64
> > > >   host-arch:   arm64
> > > >
> > > >
> > > > Is this correct?
> > > >
> > > >
> > > > If I understood the assumed use-case correctly,
> > > > kheaders.tar.xw will contain host-programs compiled for x86,
> > > > which will not work on the target system.
> > > >
> > >
> > > You are right, the above commands in the commit message work only if the
> > > host/target are same arch due to scripts.
> > >
> > > However we can build with arm64 device connected to a host, like this (which
> > > I tested):
> > >
> > > adb shell modprobe kheaders; adb pull /proc/kheaders.tar.xz
> > > rm -rf $HOME/headers; mkdir -p $HOME/headers
> > > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > > cd my-kernel-module
> > > make -C $HOME/headers M=$(pwd) ARCH=arm64 CROSS_COMPILE=aarch64- modules
> > > adb push test.ko /data/; adb shell rmmod kheaders
> > >
> > > The other way we can make this work is using x86 usermode emulation inside a
> > > chroot on the Android device which will make the earlier commands work. One
> > > thing to note is that Android also runs on x86 hardware so the commands in
> > > the commit message will work even for x86 Android targets already.
> > >
> > > Also note that this the "module building" part is really only one of the
> > > usecases. eBPF is another which needs the headers - and the headers are vast
> > > majority of the archive. Headers take 3.1MB out of 3.6MB of the archive on
> > > arm64 builds.
> > >
> > > How do you want to proceed here, should I mention these points in the commit
> > > message?
> >
> >
> >
> > I do not request a re-spin just for a matter of commit log,
> > but this version produces an empty tarball.
> > So, you will have a chance to update the patch anyway.
> >
> > In the next version, it would be nice to note that
> > "external modules must be built on the same host arch
> > as built vmlinux".
>
> Ok, I respun it with 1 more minor nit for arm64 building. Please take a look.


I have not checked code-diff in v3 yet.

Anyway, I will add comments to v4
if I notice something.


> > Let me ask one more question.
> >
> > I guess this patch is motivated by
> > how difficult to convey kernel headers
> > from vendors to users.
> >
> > In that situation, how will the user find
> > the right compiler to use for building external modules?
> >
> >
> >
> >
> > Greg KH said:
> >
> > We don't ever support the system of loading a module built with anything
> > other than the _exact_ same compiler than the kernel was.
> >
> >
> > For the full context, see this:
> > https://lore.kernel.org/patchwork/patch/836247/#1031547
>
> IMO this issue is not related to this patch but is just an issue with
> building external modules in general.


I do not think it is an issue of the build system, at least.

As far as I understood Greg's comment, it is troublesome
without the assumption that vmlinux and modules are built
by the same compiler.

It is related to this patch since this patch assumes use-cases
where external modules are built in a completely different environment,
where a different compiler is probably installed.



> It is up to the user to use the right
> compiler, etc. I will let Greg comment more on that.







> thanks,
>
>  - Joel
>


-- 
Best Regards
Masahiro Yamada
