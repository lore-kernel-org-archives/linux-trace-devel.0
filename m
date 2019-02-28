Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2044DC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 14:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8C992133D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 14:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="djRCHGM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbfB1OnK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 09:43:10 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42339 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733092AbfB1OnK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 09:43:10 -0500
Received: by mail-qk1-f196.google.com with SMTP id y140so12190652qkb.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Feb 2019 06:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cTzZ+jBzhBKBC9koFTOHSqdF0r4IeCtKb9o43A56W24=;
        b=djRCHGM6xyWnb/rZILutRNlrFznsNd950mQxPIraDc4N4MkApJvlbLRBnCz2g0/MwO
         5o9VePwH7b8jQ0xHUA0TBsWkNHT38WBB13ymW02g7CTuQx6/Dr8Y5fcRwAv8XCILRKsc
         2dAaY+obDktQlvE0FY7Lg89JoXLrZ+LVAlMoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cTzZ+jBzhBKBC9koFTOHSqdF0r4IeCtKb9o43A56W24=;
        b=qpHA0BYXwQrIknP0LPD7+0F2q24pkPIJ/jLKaKSfD0d8xd9qz87dftEzIlyCBGfbY/
         5irUIiiehZVkytb13DpX7tXWRIwKXnXy2vxTPWqK4Me9meoxZZuD/1HAhsn4b/OK1eeu
         Ce/I/Bx95qfrWRDesi58N/Zar9+TOJJpZ8o8Em30rBB4lQudjTxGdeZEAkWbCryTfN2/
         w+G2V6Wt2mTPXIlNeMu00yhb1sCYnuW1pXBzcLKqNHHpXUrbOwShPF8UGOOMVw+wvGsg
         l4DQYQ5x+MYS0Xf23DUt/GGuSpBNasL5wptyld5M9i3M4V8uHcVQdHu9VRw/tehLLwEZ
         n4/g==
X-Gm-Message-State: APjAAAXVPjMIw6uY94Iv3lFKnFaxch27AQKkScrIfVH+iWVT+ZtcVWUc
        JPdvo1HUWmrH/ixNjnAaosJoxA==
X-Google-Smtp-Source: AHgI3IZ1fOakwHf4jD1MpkjQ+dO10XDpEzQo3NIp9jX1THaPYqECh+SOlPkRotJLPId0Xzkv/UoR5A==
X-Received: by 2002:a05:620a:146a:: with SMTP id j10mr6329700qkl.243.1551364988377;
        Thu, 28 Feb 2019 06:43:08 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id j9sm9920854qtb.30.2019.02.28.06.43.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 06:43:07 -0800 (PST)
Date:   Thu, 28 Feb 2019 09:43:06 -0500
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
Message-ID: <20190228144306.GA138215@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 11:17:51AM +0900, Masahiro Yamada wrote:
> Hi Joel,
> 
> 
> On Thu, Feb 28, 2019 at 4:40 AM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
> >
> > Introduce in-kernel headers and other artifacts which are made available
> > as an archive through proc (/proc/kheaders.tar.xz file). This archive makes
> > it possible to build kernel modules, run eBPF programs, and other
> > tracing programs that need to extend the kernel for tracing purposes
> > without any dependency on the file system having headers and build
> > artifacts.
> >
> > On Android and embedded systems, it is common to switch kernels but not
> > have kernel headers available on the file system. Raw kernel headers
> > also cannot be copied into the filesystem like they can be on other
> > distros, due to licensing and other issues. There's no linux-headers
> > package on Android. Further once a different kernel is booted, any
> > headers stored on the file system will no longer be useful. By storing
> > the headers as a compressed archive within the kernel, we can avoid these
> > issues that have been a hindrance for a long time.
> >
> > The feature is also buildable as a module just in case the user desires
> > it not being part of the kernel image. This makes it possible to load
> > and unload the headers on demand. A tracing program, or a kernel module
> > builder can load the module, do its operations, and then unload the
> > module to save kernel memory. The total memory needed is 3.8MB.
> >
> > The code to read the headers is based on /proc/config.gz code and uses
> > the same technique to embed the headers.
> 
> 
> 
> Please let me ask a question about the actual use-case.
> 
> 
> To build embedded systems including Android,
> I use an x86 build machine.
> 
> In other words, I cross-compile vmlinux and in-tree modules.
> So,
> 
>   target-arch: arm64
>   host-arch:   x86
> 
> 
> 
> > To build a module, the below steps have been tested on an x86 machine:
> > modprobe kheaders
> > rm -rf $HOME/headers
> > mkdir -p $HOME/headers
> > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > cd my-kernel-module
> > make -C $HOME/headers M=$(pwd) modules
> > rmmod kheaders
> 
> I am guessing the user will run these commands
> on the target system.
> In other words, external modules are native-compiled.
> So,
> 
>   target-arch: arm64
>   host-arch:   arm64
> 
> 
> Is this correct?
> 
> 
> If I understood the assumed use-case correctly,
> kheaders.tar.xw will contain host-programs compiled for x86,
> which will not work on the target system.
> 

You are right, the above commands in the commit message work only if the
host/target are same arch due to scripts.

However we can build with arm64 device connected to a host, like this (which
I tested):

adb shell modprobe kheaders; adb pull /proc/kheaders.tar.xz
rm -rf $HOME/headers; mkdir -p $HOME/headers
tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
cd my-kernel-module
make -C $HOME/headers M=$(pwd) ARCH=arm64 CROSS_COMPILE=aarch64- modules
adb push test.ko /data/; adb shell rmmod kheaders

The other way we can make this work is using x86 usermode emulation inside a
chroot on the Android device which will make the earlier commands work. One
thing to note is that Android also runs on x86 hardware so the commands in
the commit message will work even for x86 Android targets already.

Also note that this the "module building" part is really only one of the
usecases. eBPF is another which needs the headers - and the headers are vast
majority of the archive. Headers take 3.1MB out of 3.6MB of the archive on
arm64 builds.

How do you want to proceed here, should I mention these points in the commit
message?

thanks,

 - Joel

