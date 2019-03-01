Return-Path: <SRS0=1gjG=RE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6BDC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 06:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 371452084F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 06:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="jlitbj2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfCAGZ7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 01:25:59 -0500
Received: from conssluserg-04.nifty.com ([210.131.2.83]:41369 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfCAGZ7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 01:25:59 -0500
X-Greylist: delayed 101229 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2019 01:25:57 EST
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x216PgT9019527;
        Fri, 1 Mar 2019 15:25:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x216PgT9019527
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1551421543;
        bh=CPTIQj4MJjEqWQPvI7EAGkqlSEzE35Ksp0rPBhizPpc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jlitbj2tuEj96fvC7Iv3DwItUhmOGKWjIgTFjL75XOg+Mzinqmo+OcJMUw26T4X/R
         sY13fXi5UYPLsCNBOKPdpWiCmwsY0cASLEeYd+nmqOD/VVF06OGzAVSzf82meTSGmg
         ucyiftFJRGgDJhHmtVIiMdd8d6iSD8nuGBSTtibSG7+4xOu9edu7tvUAzRuTfCL5Fs
         lu0OVMQHXmzDwRsRT7Gczfi50xMwwIlZ7MsfZeCe7oW0z0hOnMW8fNdqvC2u7RSC6L
         TCaF6nSK1rbG4Pq6jecL/3jzWSMD+aRtQg+QNG1bNJfvaKRy9g8n3pVofN6R/Hze/p
         2H6u50rqdNHUA==
X-Nifty-SrcIP: [209.85.222.49]
Received: by mail-ua1-f49.google.com with SMTP id s15so21449771uap.6;
        Thu, 28 Feb 2019 22:25:43 -0800 (PST)
X-Gm-Message-State: APjAAAVOpB/6OK5GsF3WCxSbRKQ9X1HqhN4Ootinau7AsM6fRaYCeoep
        M1dZ3CGCV+xKefWJlPMUhH/sQQRpydCCGnOE3kE=
X-Google-Smtp-Source: APXvYqyO9icQE5soySUmzB8GfMt5HnNE/JNtqj1SEDSugKyv8JvaVQ7JQ4VBi120aSeFDO3UmQZl00jja98Q29etx3I=
X-Received: by 2002:ab0:2a01:: with SMTP id o1mr1643096uar.42.1551421542201;
 Thu, 28 Feb 2019 22:25:42 -0800 (PST)
MIME-Version: 1.0
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com> <20190228144306.GA138215@google.com>
In-Reply-To: <20190228144306.GA138215@google.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 1 Mar 2019 15:25:05 +0900
X-Gmail-Original-Message-ID: <CAK7LNARTHJP=HzyBg_oBBL4whpxHXeijqk=zKLYpt=1GBLNGAA@mail.gmail.com>
Message-ID: <CAK7LNARTHJP=HzyBg_oBBL4whpxHXeijqk=zKLYpt=1GBLNGAA@mail.gmail.com>
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

On Fri, Mar 1, 2019 at 12:06 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Thu, Feb 28, 2019 at 11:17:51AM +0900, Masahiro Yamada wrote:
> > Hi Joel,
> >
> >
> > On Thu, Feb 28, 2019 at 4:40 AM Joel Fernandes (Google)
> > <joel@joelfernandes.org> wrote:
> > >
> > > Introduce in-kernel headers and other artifacts which are made available
> > > as an archive through proc (/proc/kheaders.tar.xz file). This archive makes
> > > it possible to build kernel modules, run eBPF programs, and other
> > > tracing programs that need to extend the kernel for tracing purposes
> > > without any dependency on the file system having headers and build
> > > artifacts.
> > >
> > > On Android and embedded systems, it is common to switch kernels but not
> > > have kernel headers available on the file system. Raw kernel headers
> > > also cannot be copied into the filesystem like they can be on other
> > > distros, due to licensing and other issues. There's no linux-headers
> > > package on Android. Further once a different kernel is booted, any
> > > headers stored on the file system will no longer be useful. By storing
> > > the headers as a compressed archive within the kernel, we can avoid these
> > > issues that have been a hindrance for a long time.
> > >
> > > The feature is also buildable as a module just in case the user desires
> > > it not being part of the kernel image. This makes it possible to load
> > > and unload the headers on demand. A tracing program, or a kernel module
> > > builder can load the module, do its operations, and then unload the
> > > module to save kernel memory. The total memory needed is 3.8MB.
> > >
> > > The code to read the headers is based on /proc/config.gz code and uses
> > > the same technique to embed the headers.
> >
> >
> >
> > Please let me ask a question about the actual use-case.
> >
> >
> > To build embedded systems including Android,
> > I use an x86 build machine.
> >
> > In other words, I cross-compile vmlinux and in-tree modules.
> > So,
> >
> >   target-arch: arm64
> >   host-arch:   x86
> >
> >
> >
> > > To build a module, the below steps have been tested on an x86 machine:
> > > modprobe kheaders
> > > rm -rf $HOME/headers
> > > mkdir -p $HOME/headers
> > > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > > cd my-kernel-module
> > > make -C $HOME/headers M=$(pwd) modules
> > > rmmod kheaders
> >
> > I am guessing the user will run these commands
> > on the target system.
> > In other words, external modules are native-compiled.
> > So,
> >
> >   target-arch: arm64
> >   host-arch:   arm64
> >
> >
> > Is this correct?
> >
> >
> > If I understood the assumed use-case correctly,
> > kheaders.tar.xw will contain host-programs compiled for x86,
> > which will not work on the target system.
> >
>
> You are right, the above commands in the commit message work only if the
> host/target are same arch due to scripts.
>
> However we can build with arm64 device connected to a host, like this (which
> I tested):
>
> adb shell modprobe kheaders; adb pull /proc/kheaders.tar.xz
> rm -rf $HOME/headers; mkdir -p $HOME/headers
> tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> cd my-kernel-module
> make -C $HOME/headers M=$(pwd) ARCH=arm64 CROSS_COMPILE=aarch64- modules
> adb push test.ko /data/; adb shell rmmod kheaders
>
> The other way we can make this work is using x86 usermode emulation inside a
> chroot on the Android device which will make the earlier commands work. One
> thing to note is that Android also runs on x86 hardware so the commands in
> the commit message will work even for x86 Android targets already.
>
> Also note that this the "module building" part is really only one of the
> usecases. eBPF is another which needs the headers - and the headers are vast
> majority of the archive. Headers take 3.1MB out of 3.6MB of the archive on
> arm64 builds.
>
> How do you want to proceed here, should I mention these points in the commit
> message?



I do not request a re-spin just for a matter of commit log,
but this version produces an empty tarball.
So, you will have a chance to update the patch anyway.

In the next version, it would be nice to note that
"external modules must be built on the same host arch
as built vmlinux".




Let me ask one more question.

I guess this patch is motivated by
how difficult to convey kernel headers
from vendors to users.

In that situation, how will the user find
the right compiler to use for building external modules?




Greg KH said:

We don't ever support the system of loading a module built with anything
other than the _exact_ same compiler than the kernel was.


For the full context, see this:
https://lore.kernel.org/patchwork/patch/836247/#1031547


-- 
Best Regards
Masahiro Yamada
