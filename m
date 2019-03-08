Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD2BC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 08:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBD020855
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 08:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfCHIx3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 03:53:29 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:46699 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfCHIxV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 03:53:21 -0500
Received: by mail-ua1-f67.google.com with SMTP id j8so11148898uae.13;
        Fri, 08 Mar 2019 00:53:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Epzvyc9GGSP7cfqVVNfvz4S/KW5UlhBXOeZbYred4hw=;
        b=s1Yn6trgpLNxnMgCyP+Z030k1bFjedhlFDi2z6E6cw+g6iD8rvWMYf9/ilw6og+Tis
         jUgzSHf/j8Iw+D8aosrJaNz0h2+dlru6UzDB1nX2mI6Dp7tN17GzU+WvRt5srItlUbz6
         XoqSFuCqWx/5beplAz10Vau14WklJtc+w5DEem21YmXSLl5ZUpzmCya4Z7ZFXGptMbQO
         Ts8FGgDYf7JoTDRGdic8cVMILXC3ka1rGNw/t5lgHHIimWUYqCHzqo0U4e+4pcLUqka+
         3Vwg9FEJQrcQ83+AyzfYgfJFoC8Y9N/gdt7Z/xkQQVVOUlOa/mo1ZVLx3Ffp2aYudcif
         Ob5g==
X-Gm-Message-State: APjAAAVgqHidXtZtxgG+ga/FJYwY5sRTFBDplE1tyATpu+8lLtQHJ1bK
        52y2Jg2bKnM7tOKmLZwWZHzV/LiX01QGqYptbk0=
X-Google-Smtp-Source: APXvYqzH78I36PVbTINXJE8yFq87TmwZTLoEQLDtrKnJtuRJVZeGdF4xBDJWMtLst6mGELKutdWl6GQgrnj0JuawYTM=
X-Received: by 2002:a9f:30dc:: with SMTP id k28mr9442718uab.75.1552035200158;
 Fri, 08 Mar 2019 00:53:20 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com> <20190307150343.GB258852@google.com>
In-Reply-To: <20190307150343.GB258852@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Mar 2019 09:53:07 +0100
Message-ID: <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>, atishp04@gmail.com,
        dancol@google.com, Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, qais.yousef@arm.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,

On Thu, Mar 7, 2019 at 4:03 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> On Thu, Mar 07, 2019 at 09:58:24AM +0100, Geert Uytterhoeven wrote:
> > On Fri, Mar 1, 2019 at 5:10 PM Joel Fernandes (Google)
> > <joel@joelfernandes.org> wrote:
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
> > >
> > > To build a module, the below steps have been tested on an x86 machine:
> > > modprobe kheaders
> > > rm -rf $HOME/headers
> > > mkdir -p $HOME/headers
> > > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > > cd my-kernel-module
> > > make -C $HOME/headers M=$(pwd) modules
> > > rmmod kheaders
> >
> > As the usage pattern will be accessing the individual files, what about
> > implementing a file system that provides read-only access to the internal
> > kheaders archive?
> >
> >     mount kheaders $HOME/headers -t kheaders
>
> I thought about it already. This is easier said than done though. The archive
> is compressed from 40MB to 3.6MB. If we leave it uncompressed in RAM, then it
> will take up the entire 40MB of RAM and in Android we don't even use
> disk-based swap.

Sure.

> So we will need some kind of intra file compressed memory representation that
> a filesystem can use for the backing store. I thought of RAM-backed squashfs

Right, I didn't think of squashfs. Having a kernel module that sets up an MTD
that can be mounted with squashfs is IMHO an even better (and more generic)
solution.

> but it requires squashfs-tools to be installed at build time (which my host
> distro itself didn't have).

Squashfs not being part of your host distro is not the hardest problem
to solve...

> It is just so much easier to use tar + xz at build time, and leave the
> decompression task to the user. After decompression, the files will live on
> the disk and the page-cache mechanism will free memory when/if the files fall
> off the LRUs.

I'm also considering how generic and extensible the solution is.
What if people need other build artifacts in the future (e.g. signing key to
load signed modules)?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
