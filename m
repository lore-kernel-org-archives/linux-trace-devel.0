Return-Path: <SRS0=1gjG=RE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FE4C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 02:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6968218AE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551407314;
	bh=3r7LDN99AtOgf3aUEAmOBEPGqH4rCbezf2u14v7BmaI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=i6nbOEv+ncLNmNScdnRRkV9HSw07e2QckiaxkwN6tCm87LueyPsmvqUgDMt9GtPO9
	 94pY3sjUIXNxtDuTdx0vMSRcSK1oGNvb2IWLD4NZ6lD3e/Mmz3DcoLj9mC8mIdXiP/
	 sUryFbE47K7mOBuPACbzMBcCMkDNqD7hJNWbag8Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfCAC2d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 21:28:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbfCAC2d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 21:28:33 -0500
Received: from devnote (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54AA020863;
        Fri,  1 Mar 2019 02:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551407311;
        bh=3r7LDN99AtOgf3aUEAmOBEPGqH4rCbezf2u14v7BmaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MIBX/Wka7GdLd3NzBPKuyZcoeVkBINW2XGxXfkscX541WIiPbgY2xIm0s4cA4uLdt
         +uXCAZUFC4MwbCmjUDwklrvJ3NZyeG/mVZ9hkKWx2Ode8v6Xzcw5Vy5/5BM1tFPRJg
         ARl/U/enFGsQSI8y+9DPbKyC+rvAsC2A0YwM4iXU=
Date:   Fri, 1 Mar 2019 11:28:26 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        qais.yousef@arm.com, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-Id: <20190301112826.ced40b59fb7e8118fa5b40d6@kernel.org>
In-Reply-To: <20190228150054.GB156098@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
        <20190228173444.54403795211d80ba540b61cb@kernel.org>
        <20190228150054.GB156098@google.com>
X-Mailer: Sylpheed 3.5.0 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,

On Thu, 28 Feb 2019 10:00:54 -0500
Joel Fernandes <joel@joelfernandes.org> wrote:

> > Hmm, isn't it easier to add kernel-headers package on Android?
> 
> I have already been down that road. In the Android ecosystem, the Android
> teams only provide a "userspace system image" which goes on the system
> partition of the flash (and a couple other images are also provided but
> system is the main one). The system image cannot contain GPL source code. It
> is also not possible to put kernel headers for every kernel version on the
> system images that ship and is not practical. Android boots on 1000s of forked
> kernels. It does not make sense to provide headers on the system image for
> every kernel version and I already had many discussions on the subject with
> the teams, it is something that is just not done. Now for kernel modules,
> there's another image called the "vendor image" which is flashed onto the
> vendor parition, this is where kernel modules go.  This vendor image is not
> provided by Google for non-Pixel devices. So we have no control over what
> goes there BUT we do know that kernel modules that are enabled will go there,
> and we do have control over enforcing that certain kernel modules should be
> built and available as they are mandatory for Android to function properly.
> We would also possibly make it a built-in option as well. Anyway my point is
> keeping it in the kernel is really the easiest and the smartest choice IMO.

Sorry, I'm not convinced yet. This sounds like "because Android decided not
to put the header files on vendor partition, but kernel module is OK"
Why don't google ask vendors to put their kernel headers (or header tarball)
on vendor partition instead?

> 
> > > The feature is also buildable as a module just in case the user desires
> > > it not being part of the kernel image. This makes it possible to load
> > > and unload the headers on demand. A tracing program, or a kernel module
> > > builder can load the module, do its operations, and then unload the
> > > module to save kernel memory. The total memory needed is 3.8MB.
> > 
> > But it also requires to install build environment (tools etc.)
> > on the target system...
> 
> Yes, that's true. Check the other thread with Masahiro that we are discussing
> this point on and let us continue discussing there:
> https://lore.kernel.org/patchwork/patch/1046307/#1238223
> https://lore.kernel.org/patchwork/patch/1046307/#1238491
> 
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
> > It seems a bit complex, but no difference from compared with carrying
> > kheaders.tar.gz. I think we would better have a psudo filesystem
> > which can mount this compressed header file directly :) Then it becomes
> > simpler, like
> > 
> > modprobe headerfs
> > mkdir $HOME/headers
> > mount -t headerfs $HOME/headers
> > 
> > And this doesn't consume any disk-space.
> 
> I felt using a compressed tar is really the easiest way because of all the
> tools are already available.

As I asked above, if the pure tarball is useful, you can simply ask vendors
to put the header tarball on their vendor directory. I feel making it as
a module is not a right way.

> There isn't a compressed in-ram filesystem right
> now that I'm aware off that can achieve the kind of high compression ratio
> this patchset does.

I think if linux can support something like tarfs(or compressed initramfs)
in kernel, it gives linux an improvement not only a hack. :-)

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
