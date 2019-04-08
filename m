Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9652C10F14
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 20:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D58820855
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 20:36:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="YTTLU2Hr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfDHUgF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 16:36:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36918 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfDHUgF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 16:36:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id 8so8298086pfr.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 13:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4Dhl77NcnEN5KNCPanFrgHMJnUkXbLOEGdhM5en3oLM=;
        b=YTTLU2Hr1xrIzOwkNBZrU+yNsgeqXpCHEN8nbrZvwIQ26Tyy/sDU3joxh+xHs0iAdA
         2sL0OrisYsJC1NZ29qbnc/f9anHZJjf5E9Z+A3YH6xIUrWAbd3EsqqmPYNBm9hQLpXoX
         A4cIlgem0iConH4T2E5Gy3Wt4Do8cInBgXe5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4Dhl77NcnEN5KNCPanFrgHMJnUkXbLOEGdhM5en3oLM=;
        b=QC/+wzRFZ5IObkvfTUUk6jJhWKDJ8y3Ga/vtMX8pxkgHL2eP4O8zkNsgi9mRgrr1Lw
         NiZroH4+96YaWj3QlrnwnwIcw9+j9dw8cYAZlooOC5dpNyh7oia4frD2OOdfe1zG9Jwz
         d6v7HexWyxQ1+RPa2rf3F5Kpqj/8GaVxIohzKZHmoW1+hxPSTgM+ifWZM7JddG79dJhG
         jSZ3irbq13+XW05dv0z3FOZCUVX8X1bby2N4iwjnycxsZE3bqfbMNBLeEWjNMfSU742H
         tLNX52qjEg9/XiWB4KsH9XvBskV/qIsXlgBoOqh3M/Lzhn+PQyHsqLdIQj4UR6tTZ14y
         N6GQ==
X-Gm-Message-State: APjAAAU2hyAIxQxDePiPCMoK5gNGOR/xlnqDjNSVw73vTYuRZDwPoNJQ
        1qNA9abzmuPeYI3aT5OTrZUtZA==
X-Google-Smtp-Source: APXvYqzn/WA75BC8fBNJ94ln/jYlUftis1ggfWVqoiupDc8wfXUnPyU/CETJ92EbuJoFtiEx2RFQTg==
X-Received: by 2002:aa7:8252:: with SMTP id e18mr31748020pfn.105.1554755763929;
        Mon, 08 Apr 2019 13:36:03 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id n3sm51965157pfa.99.2019.04.08.13.36.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 13:36:02 -0700 (PDT)
Date:   Mon, 8 Apr 2019 16:36:01 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Olof Johansson <olof@lixom.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qais.yousef@arm.com, dietmar.eggemann@arm.com,
        linux@manojrajarao.com, Andrew Morton <akpm@linux-foundation.org>,
        ast@kernel.org, atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190408203601.GF133872@google.com>
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 08, 2019 at 09:29:30AM -0700, Olof Johansson wrote:
> Hi,
> 
> On Wed, Mar 20, 2019 at 9:31 AM Joel Fernandes (Google)
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
> > have kernel headers available on the file system. Further once a
> > different kernel is booted, any headers stored on the file system will
> > no longer be useful. By storing the headers as a compressed archive
> > within the kernel, we can avoid these issues that have been a hindrance
> > for a long time.
> >
> > The best way to use this feature is by building it in. Several users
> > have a need for this, when they switch debug kernels, they donot want to
> > update the filesystem or worry about it where to store the headers on
> > it. However, the feature is also buildable as a module in case the user
> > desires it not being part of the kernel image. This makes it possible to
> > load and unload the headers from memory on demand. A tracing program, or
> > a kernel module builder can load the module, do its operations, and then
> > unload the module to save kernel memory. The total memory needed is 3.8MB.
> >
> > By having the archive available at a fixed location independent of
> > filesystem dependencies and conventions, all debugging tools can
> > directly refer to the fixed location for the archive, without concerning
> > with where the headers on a typical filesystem which significantly
> > simplifies tooling that needs kernel headers.
> >
> > The code to read the headers is based on /proc/config.gz code and uses
> > the same technique to embed the headers.
> >
> > To build a module, the below steps have been tested on an x86 machine:
> > modprobe kheaders
> > rm -rf $HOME/headers
> > mkdir -p $HOME/headers
> > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > cd my-kernel-module
> > make -C $HOME/headers M=$(pwd) modules
> > rmmod kheaders
> >
> > Additional notes:
> > (1) external modules must be built on the same arch as the host that
> > built vmlinux. This can be done either in a qemu emulated chroot on the
> > target, or natively. This is due to host arch dependency of kernel
> > scripts.
> >
> > (2)
> > If module building is used, since Module.symvers is not available in the
> > archive due to a cyclic dependency with building of the archive into the
> > kernel or module binaries, the modules built using the archive will not
> > contain symbol versioning (modversion). This is usually not an issue
> > since the idea of this patch is to build a kernel module on the fly and
> > load it into the same kernel. An appropriate warning is already printed
> > by the kernel to alert the user of modules not having modversions when
> > built using the archive. For building with modversions, the user can use
> > traditional header packages. For our tracing usecases, we build modules
> > on the fly with this so it is not a concern.
> >
> > (3) I have left IKHD_ST and IKHD_ED markers as is to facilitate
> > future patches that would extract the headers from a kernel or module
> > image.
> >
> > (v4 was Tested-by the following folks,
> >  v5 only has minor changes and has passed my testing).
> > Tested-by: qais.yousef@arm.com
> > Tested-by: dietmar.eggemann@arm.com
> > Tested-by: linux@manojrajarao.com
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Sorry to be late at the party with this kind of feedback, but I find
> the whole ".tar.gz in procfs" to be an awkward solution, especially if
> there's expected to be userspace tooling that depends on this
> long-term.

No problem, your feedback is welcome.

> Wouldn't it be more convenient to provide it in a standardized format
> such that you won't have to take an additional step, and always have
> This is that form IMO.

The location of the archive is fixed/known. If you are talking of the
location where the user decompresses it to, then they a;ready know where they
are decompressing to.

> Something like:
> 
>  - Pseudo-filesystem, that can just be mounted under
> /sys/kernel/headers or something (similar to debugfs or
> /proc/device-tree).

The headers are huge if uncompressed (~30MB). Currently we use xz compression
in the archive. It would be a huge waste to decompress everything into
memory such as through an in-memory filesystem. And compressing on a
per-file basis would be too slow for build time. Currently the build of the
archive is extrememly fast.

>  - Exporting something like a squashfs image instead, allowing
> loopback mounting of it (or by providing a pseudo-/dev entry for it),
> again allowing direct export of the contents and avoiding the
> extracted directory from being out of sync with currently running
> kernel.

One drawback of squashfs (other than possibly the compression ratio) is that
this would be kernel build unfriendly in comparison to tar+xz. On my machine,
squashfs-tools needed to be installed. For users who don't have this package,
that would break their kernel build.

> Having to copy and extract the tarball is the most awkward step, IMHO.
> I also find the waste of kernel memory for it to be an issue, but
> given that it can be built as a module I guess that's the obvious
> solution for those who care about memory consumption.

Yes. We discussed in previous threads that for users who really want the
archive to be completely uncompressed and in-memory, can just load the
module, decompress into tmpfs, and unload the module. That is an extra step,
yes.

We had close to 2-3 months of discussions now with various folks up until v5.
I am about to post v6 which is in line with Masahiro Yamada's expecations. In
that I will be dropping module building artifacts due to his module building
concerns and only include the headers.

thanks,

- Joel

