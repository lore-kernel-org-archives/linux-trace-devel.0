Return-Path: <SRS0=q9un=RF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6BBC43381
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 Mar 2019 02:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8092C20823
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 Mar 2019 02:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="fevPHetG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfCBCjo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 21:39:44 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41138 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfCBCjn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 21:39:43 -0500
Received: by mail-qk1-f195.google.com with SMTP id y15so15534899qki.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Mar 2019 18:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5Temr26glEFV5oBvptkrenNBwbSVXvaTPHPZBdA7hho=;
        b=fevPHetGuRxApcOMs7+xRchWUctf+oj1jQqEq46J109zotdV7Y2+0pdX4q79SgjvX5
         UVzx1FJ/2GGQCg4V9qIjmPNHu8BA5s6eZJtubMrLUEIeyc/al1fnL48cn4TibRFZT0ym
         bNUWQQUM1tpWtBk2SDHB1B8LQPEAHQm/OHd+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5Temr26glEFV5oBvptkrenNBwbSVXvaTPHPZBdA7hho=;
        b=F322Fpr8IfcPOKtiKjGSKHOH7LwL+g5zy6EqdtwSQhnbqcQDara5bogIzOcTT5GoED
         V0eleTCLGXKqJLTMrzuQ5F4uOuMJWjWCdZ3XCf9EwMCQitD+omCczL8eLdbT+V9ZmJwQ
         yz/iQkjLpwA/XNTIVEDHvwZs7lhim0Cg4O3FSVrV7QMaRGdEIVyzIwhky8/o/Zltznd2
         bm5j3AygWEFyzhV3aLVQOT9auvSLyEzcOnTXS4WB7sTGOtf8T547lp1RIPTB+r+02ERc
         kbgu6BaSC8FrUbzwQKzDwSXgHuaiv/zEFfyElhKtlz9prcpa5OQYDF5Z3JEQkIqRzO5P
         wh3A==
X-Gm-Message-State: APjAAAU0gb7iKbQex0XH2nwEvDQ/Cbbz2lRA4m5C3nwHOx/vsbL9FKvO
        ge3VRi1a17INJzdZSBocYjO2dQ==
X-Google-Smtp-Source: APXvYqws/TPWsG/bS5u7wD2HdripLz6HAVECeBO8vtpK9O2+uSxGPz857GonmrvABkuB4UebSYCU1w==
X-Received: by 2002:a37:f506:: with SMTP id l6mr6466129qkk.110.1551494382200;
        Fri, 01 Mar 2019 18:39:42 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id h10sm24209069qta.3.2019.03.01.18.39.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 18:39:41 -0800 (PST)
Date:   Fri, 1 Mar 2019 21:39:40 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
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
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190302023940.GA55262@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com>
 <20190228144306.GA138215@google.com>
 <CAK7LNARTHJP=HzyBg_oBBL4whpxHXeijqk=zKLYpt=1GBLNGAA@mail.gmail.com>
 <20190301171954.GA217990@google.com>
 <CAK7LNAShVt=zOPP1TUuBbR_H8kmc+zuLAyRXucjMMKrALkW_6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAShVt=zOPP1TUuBbR_H8kmc+zuLAyRXucjMMKrALkW_6A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Mar 02, 2019 at 11:13:07AM +0900, Masahiro Yamada wrote:
> On Sat, Mar 2, 2019 at 3:03 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > On Fri, Mar 01, 2019 at 03:25:05PM +0900, Masahiro Yamada wrote:
> > [...]
> > > > > I am guessing the user will run these commands
> > > > > on the target system.
> > > > > In other words, external modules are native-compiled.
> > > > > So,
> > > > >
> > > > >   target-arch: arm64
> > > > >   host-arch:   arm64
> > > > >
> > > > >
> > > > > Is this correct?
> > > > >
> > > > >
> > > > > If I understood the assumed use-case correctly,
> > > > > kheaders.tar.xw will contain host-programs compiled for x86,
> > > > > which will not work on the target system.
> > > > >
> > > >
> > > > You are right, the above commands in the commit message work only if the
> > > > host/target are same arch due to scripts.
> > > >
> > > > However we can build with arm64 device connected to a host, like this (which
> > > > I tested):
> > > >
> > > > adb shell modprobe kheaders; adb pull /proc/kheaders.tar.xz
> > > > rm -rf $HOME/headers; mkdir -p $HOME/headers
> > > > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > > > cd my-kernel-module
> > > > make -C $HOME/headers M=$(pwd) ARCH=arm64 CROSS_COMPILE=aarch64- modules
> > > > adb push test.ko /data/; adb shell rmmod kheaders
> > > >
> > > > The other way we can make this work is using x86 usermode emulation inside a
> > > > chroot on the Android device which will make the earlier commands work. One
> > > > thing to note is that Android also runs on x86 hardware so the commands in
> > > > the commit message will work even for x86 Android targets already.
> > > >
> > > > Also note that this the "module building" part is really only one of the
> > > > usecases. eBPF is another which needs the headers - and the headers are vast
> > > > majority of the archive. Headers take 3.1MB out of 3.6MB of the archive on
> > > > arm64 builds.
> > > >
> > > > How do you want to proceed here, should I mention these points in the commit
> > > > message?
> > >
> > >
> > >
> > > I do not request a re-spin just for a matter of commit log,
> > > but this version produces an empty tarball.
> > > So, you will have a chance to update the patch anyway.
> > >
> > > In the next version, it would be nice to note that
> > > "external modules must be built on the same host arch
> > > as built vmlinux".
> >
> > Ok, I respun it with 1 more minor nit for arm64 building. Please take a look.
> 
> 
> I have not checked code-diff in v3 yet.
> 
> Anyway, I will add comments to v4
> if I notice something.

Ok. Since all your comments from previous series were addressed, it would be
nice to get your Acked-by tag for v4 unless you have further comments or
concerns.

> > > Let me ask one more question.
> > >
> > > I guess this patch is motivated by
> > > how difficult to convey kernel headers
> > > from vendors to users.
> > >
> > > In that situation, how will the user find
> > > the right compiler to use for building external modules?
> > >
> > >
> > >
> > >
> > > Greg KH said:
> > >
> > > We don't ever support the system of loading a module built with anything
> > > other than the _exact_ same compiler than the kernel was.
> > >
> > >
> > > For the full context, see this:
> > > https://lore.kernel.org/patchwork/patch/836247/#1031547
> >
> > IMO this issue is not related to this patch but is just an issue with
> > building external modules in general.
> 
> 
> I do not think it is an issue of the build system, at least.
> 
> As far as I understood Greg's comment, it is troublesome
> without the assumption that vmlinux and modules are built
> by the same compiler.
> It is related to this patch since this patch assumes use-cases
> where external modules are built in a completely different environment,
> where a different compiler is probably installed.

Yes, but what I'm trying to say is the same issue exists with all other
solutions today that do this. Such as debian you have linux-headers package.
A user could totally use the build artifacts obtained from somewhere to build
a kernel module with a completely different compiler. That issue has just to
do with the reality, and isn't an issue caused by any one solution such as
this one.  I agree care must be taken whenever user is building external
kernel modules independent of kernel sources.  Did I miss something else?

thanks a lot,

 - Joel

