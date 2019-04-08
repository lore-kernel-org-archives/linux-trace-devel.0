Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C83C10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 16:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF1420880
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 16:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="kYBqsms4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfDHQyH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 12:54:07 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:37462 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfDHQyH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 12:54:07 -0400
Received: by mail-it1-f193.google.com with SMTP id u65so205357itc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 09:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iTUAGD6lWza4tKmi+pA/GqOUIGhro2T5N3WoQ+3jgyE=;
        b=kYBqsms4GyP2kEAhIkWfhkPdLjMOxT9glTqJSYGlAbP7WcJXOaCvc6t9QIZ6wcM/h+
         Qu+uCoLvLKjC/sCtJxRMpHTrTYUFOrukcPgGjkY+8VfYBMIY2TgAB3otfGn4aC3yZ+oL
         MNXXtIGNuFb6z3lEeErFuntZ/f301f5F0+xqNx0L/Sen9u9uVMNnZrs24Ievi7yZpNGb
         Ny5RZ2sm06AkR2RhI4yg2Jp5aqBMKq0l7wNiLpFsVssB417UzE0xLdjZ9tc6TtUYsBfU
         SLTh9Khpk6nmhGl8/y24ZvS0H2gyN3BA8/3EgJCJ/Ey8E4AhSS3LLQUbE/yEfHnn9Q2p
         rTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iTUAGD6lWza4tKmi+pA/GqOUIGhro2T5N3WoQ+3jgyE=;
        b=fUtZGnQhWp7+I+acBCire20f5ocN2Yj2F5/xIfcIFwdBlYmUT3a47CaUpq1NX1eIy8
         Ua4QvbOF2UQCtSqU6fmnNdx+XqqLa5RAn2Mz5JVhjJX+Z4Q1LBi7Dx+4VWKpKbW1Jv88
         aZMKNr90M+CfLAJKOfN5tbGkLHenoDqiRJUcg5CuFyqAHLY/4EksCnZettLjG/xFC4Ik
         ROXPK8QQZpyE/x+axWKUXoKBlDhPxJfc86qCIb40jfHjeAPVX833MHhAnYplxEf/dyBw
         zadL5d2WZWTct2SytGuS24gL2mMRU+R4b5ZT3/zvs7EkVQNNLZ0k4JMRLum6mzb10M0/
         WjGw==
X-Gm-Message-State: APjAAAWga0fctHV3J/Qt+7774cph1jLanbwD/ZdxZ8k9etLNSbrdwP5a
        /uHgdOGK1N3CnTqcyN31wB7AK6HagoqtW6evnBwYHw==
X-Google-Smtp-Source: APXvYqwhR7r2iesmJKfaZ5pzDBLjiuEOFOIWt+OZN+p6wrtIl5MqoLcyYSMvgkRg01f0pg4JSLSopohg+83+pWqDW2U=
X-Received: by 2002:a24:7c9:: with SMTP id f192mr2921343itf.97.1554742446016;
 Mon, 08 Apr 2019 09:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com> <CAKOZuetS6Bg0ubxQgCBKVKeWOzuwH_C=nCRn-OPmHYJvs6sybQ@mail.gmail.com>
In-Reply-To: <CAKOZuetS6Bg0ubxQgCBKVKeWOzuwH_C=nCRn-OPmHYJvs6sybQ@mail.gmail.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Mon, 8 Apr 2019 09:53:54 -0700
Message-ID: <CAOesGMi++NMi-60smmd9f+P4C1d9oQiz-hS6QWa6ViqzqJrfBA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Daniel Colascione <dancol@google.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 8, 2019 at 9:37 AM Daniel Colascione <dancol@google.com> wrote:
>
> On Mon, Apr 8, 2019 at 9:29 AM Olof Johansson <olof@lixom.net> wrote:
> >
> > Hi,
> >
> > On Wed, Mar 20, 2019 at 9:31 AM Joel Fernandes (Google)
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
> > > have kernel headers available on the file system. Further once a
> > > different kernel is booted, any headers stored on the file system will
> > > no longer be useful. By storing the headers as a compressed archive
> > > within the kernel, we can avoid these issues that have been a hindrance
> > > for a long time.
> > >
> > > The best way to use this feature is by building it in. Several users
> > > have a need for this, when they switch debug kernels, they donot want to
> > > update the filesystem or worry about it where to store the headers on
> > > it. However, the feature is also buildable as a module in case the user
> > > desires it not being part of the kernel image. This makes it possible to
> > > load and unload the headers from memory on demand. A tracing program, or
> > > a kernel module builder can load the module, do its operations, and then
> > > unload the module to save kernel memory. The total memory needed is 3.8MB.
> > >
> > > By having the archive available at a fixed location independent of
> > > filesystem dependencies and conventions, all debugging tools can
> > > directly refer to the fixed location for the archive, without concerning
> > > with where the headers on a typical filesystem which significantly
> > > simplifies tooling that needs kernel headers.
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
> > >
> > > Additional notes:
> > > (1) external modules must be built on the same arch as the host that
> > > built vmlinux. This can be done either in a qemu emulated chroot on the
> > > target, or natively. This is due to host arch dependency of kernel
> > > scripts.
> > >
> > > (2)
> > > If module building is used, since Module.symvers is not available in the
> > > archive due to a cyclic dependency with building of the archive into the
> > > kernel or module binaries, the modules built using the archive will not
> > > contain symbol versioning (modversion). This is usually not an issue
> > > since the idea of this patch is to build a kernel module on the fly and
> > > load it into the same kernel. An appropriate warning is already printed
> > > by the kernel to alert the user of modules not having modversions when
> > > built using the archive. For building with modversions, the user can use
> > > traditional header packages. For our tracing usecases, we build modules
> > > on the fly with this so it is not a concern.
> > >
> > > (3) I have left IKHD_ST and IKHD_ED markers as is to facilitate
> > > future patches that would extract the headers from a kernel or module
> > > image.
> > >
> > > (v4 was Tested-by the following folks,
> > >  v5 only has minor changes and has passed my testing).
> > > Tested-by: qais.yousef@arm.com
> > > Tested-by: dietmar.eggemann@arm.com
> > > Tested-by: linux@manojrajarao.com
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> >
> > Sorry to be late at the party with this kind of feedback, but I find
> > the whole ".tar.gz in procfs" to be an awkward solution, especially if
> > there's expected to be userspace tooling that depends on this
> > long-term.
> > [snip]
>
> The approaches you proposed were explored in detail on this thread and
> other related threads.

Not on this thread, but maybe on others. Since they weren't linked and
referenced, I didn't find them. Having them summarized in the patch
description would be a great idea.

> The tarball in proc approach is a simple,
> pragmatic approach that allows makes a lot of scenarios Just Work
> where they didn't before.

"My pragmatic solution, your messy hack".

It's an awkward solution that will now be permanently locked in due to
the /proc interface being an ABI.

> Approaches like a new filesystem, a
> mountable block device, a custom debuginfo format, and so on add
> complexity without providing concrete gains in functionality.

It definitely provides concrete gains in functionality, in particular
it provides a significantly less fragile way of providing the data
such that having it out of sync with the running kernel is a lot less
accident-prone.

> We'd
> like to get this work into the tree sooner rather than later.

That has _never_ been a good argument for picking up something that
will need to be supported as an ABI forever.

We've solved these kind of things in the past without exporting
tarballs from the kernel. We can do it again.


I literally didn't hear a single valid reason for why this patch
should go in from you.


-Olof
