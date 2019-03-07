Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC78C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C12F20851
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551972192;
	bh=lCO3T/XpRXUd0bBBzJFZCQZ2nBBRK9+DkfsiRbJa12c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jun5YFai7/IMtODifzO21MWep5yYuyhed1cRAMNWPqCxjrvp9avE/j8Y6ZWcrI1F5
	 203CLef5SJy94+J1JQ53sNAQyAkJORwOWCcdE3j1jZEIO88gIBeTKPa4TUGMwefpYN
	 iXBsVODjENmzoRXuUGv1GhaJwG8Uin1AttzsrKnQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfCGPXH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:23:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfCGPXH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:23:07 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE1A20840;
        Thu,  7 Mar 2019 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551972185;
        bh=lCO3T/XpRXUd0bBBzJFZCQZ2nBBRK9+DkfsiRbJa12c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8cROAQMU7pzNz0iJSmrs9g07QSB0UTZJB0ZtrY7ra7fexbvXRJbYCW8G1h/8jKjF
         CmX5g1gM9KLgorDDRSvvLft3pqx9ESdoMt05DBS+Vl2Vn+o9MSqOROaTTgrBCt/j5r
         WTHEiZQXaaOBwh/La/WHteiU06L01I8fs23noqmM=
Date:   Thu, 7 Mar 2019 16:23:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>, atishp04@gmail.com,
        dancol@google.com, Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
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
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190307152303.GA9819@kroah.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307150343.GB258852@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 07, 2019 at 10:03:43AM -0500, Joel Fernandes wrote:
> On Thu, Mar 07, 2019 at 09:58:24AM +0100, Geert Uytterhoeven wrote:
> > Hi Joel,
> > 
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
> 
> So we will need some kind of intra file compressed memory representation that
> a filesystem can use for the backing store. I thought of RAM-backed squashfs
> but it requires squashfs-tools to be installed at build time (which my host
> distro itself didn't have).
> 
> It is just so much easier to use tar + xz at build time, and leave the
> decompression task to the user. After decompression, the files will live on
> the disk and the page-cache mechanism will free memory when/if the files fall
> off the LRUs.
> 
> WDYT?

I think the compressed tarball is much simpler/easier overall.  If
someone really wants the filesystem, they just uncompress it into a
tmpfs mount.  It's much less moving kernel code to worry about.

thanks,

greg k-h
