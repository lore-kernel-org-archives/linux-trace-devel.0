Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29709C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 16:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E54DF2064A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 16:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="VzAx11ix"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfCGQyh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 11:54:37 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33618 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfCGQyh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 11:54:37 -0500
Received: by mail-qt1-f194.google.com with SMTP id z39so17881017qtz.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 08:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AXHynj04NMZ0CS1NnWbfes4n6qunWNiY93VEbJEipOQ=;
        b=VzAx11ixOrKiy7adFBoN7ejFE8lbSz504yc3bt7PTgL1AQ7iGkqvPLM4JSAWH1k68a
         xTF7lVX8FjOa9kgqFtdvTb89sxk/WHkOHdxrdSlX+nWLLjkZb2MrTeKWS/sHzUq2XOrR
         9u87K/SBUPFgfPeUboPRvJ87GW7TvwunI/hSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AXHynj04NMZ0CS1NnWbfes4n6qunWNiY93VEbJEipOQ=;
        b=CAHOQehwu7Ch6ZW4k6TcWcU7CjZhzDmTa2k8PjOw+3lEygHnVjO/RtJCaRXywXA12J
         Cs8HRDm3OCPsznyzU6+8qyxpWZCELU3ITEdMdLYdoDnprdYReVsEEn50vPKTmCXqB359
         kE0aFaecJle77qUa++MUWqpaD2dx885Yzr3rlW8q0dHAljMEavFdm+MM/RW8HzRSy2Eo
         QGUkqVlRZsT3zWd2jT1rRBZvyc/c6UfrHwKZIe+H8+MFhJQM8ZlKT8pAPAmHTuGSYvxv
         3YJkvjUZHPSaMMEUtrNvVi59t8kIvxHAnEhjKCC/YLwqpe6QcyYOZ3QG3BeK5XkzZNib
         swFw==
X-Gm-Message-State: APjAAAWyZMJzahyUUDZiwJiGtKXE4mtlVSfzaGKG3XWHgJ29oX1kshBx
        +vIaX6+XnWbVM7BuKyP5sDozKA==
X-Google-Smtp-Source: APXvYqzliPKVOu92j04Ka4Y1e5wW04bOnsUK+2QUpv8l1kUxUiPSAh7U5UqyGITxuZtQfYmyyjSfLw==
X-Received: by 2002:a0c:b758:: with SMTP id q24mr11372279qve.149.1551977675747;
        Thu, 07 Mar 2019 08:54:35 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id g20sm279630qtg.4.2019.03.07.08.54.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Mar 2019 08:54:34 -0800 (PST)
Date:   Thu, 7 Mar 2019 11:54:33 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20190307165433.GA90983@google.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <20190307152303.GA9819@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307152303.GA9819@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 07, 2019 at 04:23:03PM +0100, Greg KH wrote:
> > > On Fri, Mar 1, 2019 at 5:10 PM Joel Fernandes (Google)
> > > <joel@joelfernandes.org> wrote:
> > > > Introduce in-kernel headers and other artifacts which are made available
> > > > as an archive through proc (/proc/kheaders.tar.xz file). This archive makes
> > > > it possible to build kernel modules, run eBPF programs, and other
> > > > tracing programs that need to extend the kernel for tracing purposes
> > > > without any dependency on the file system having headers and build
> > > > artifacts.
> > > >
> > > > On Android and embedded systems, it is common to switch kernels but not
> > > > have kernel headers available on the file system. Raw kernel headers
> > > > also cannot be copied into the filesystem like they can be on other
> > > > distros, due to licensing and other issues. There's no linux-headers
> > > > package on Android. Further once a different kernel is booted, any
> > > > headers stored on the file system will no longer be useful. By storing
> > > > the headers as a compressed archive within the kernel, we can avoid these
> > > > issues that have been a hindrance for a long time.
> > > >
> > > > The feature is also buildable as a module just in case the user desires
> > > > it not being part of the kernel image. This makes it possible to load
> > > > and unload the headers on demand. A tracing program, or a kernel module
> > > > builder can load the module, do its operations, and then unload the
> > > > module to save kernel memory. The total memory needed is 3.8MB.
> > > >
> > > > The code to read the headers is based on /proc/config.gz code and uses
> > > > the same technique to embed the headers.
> > > >
> > > > To build a module, the below steps have been tested on an x86 machine:
> > > > modprobe kheaders
> > > > rm -rf $HOME/headers
> > > > mkdir -p $HOME/headers
> > > > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > > > cd my-kernel-module
> > > > make -C $HOME/headers M=$(pwd) modules
> > > > rmmod kheaders
> > > 
> > > As the usage pattern will be accessing the individual files, what about
> > > implementing a file system that provides read-only access to the internal
> > > kheaders archive?
> > > 
> > >     mount kheaders $HOME/headers -t kheaders
> > 
> > I thought about it already. This is easier said than done though. The archive
> > is compressed from 40MB to 3.6MB. If we leave it uncompressed in RAM, then it
> > will take up the entire 40MB of RAM and in Android we don't even use
> > disk-based swap.
> > 
> > So we will need some kind of intra file compressed memory representation that
> > a filesystem can use for the backing store. I thought of RAM-backed squashfs
> > but it requires squashfs-tools to be installed at build time (which my host
> > distro itself didn't have).
> > 
> > It is just so much easier to use tar + xz at build time, and leave the
> > decompression task to the user. After decompression, the files will live on
> > the disk and the page-cache mechanism will free memory when/if the files fall
> > off the LRUs.
> > 
> > WDYT?
> 
> I think the compressed tarball is much simpler/easier overall.  If
> someone really wants the filesystem, they just uncompress it into a
> tmpfs mount.  It's much less moving kernel code to worry about.

Agreed, I also feel the same. thanks,

 - Joel

