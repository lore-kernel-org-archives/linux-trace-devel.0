Return-Path: <SRS0=1gjG=RE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EAAC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 03:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED28120857
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 03:26:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="K3znNruK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfCAD0O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 22:26:14 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:47082 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfCAD0O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 22:26:14 -0500
Received: by mail-qt1-f196.google.com with SMTP id z25so26181304qti.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Feb 2019 19:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4HvsB3jJ0Dp/E1S7E1dBpxrM0q7K1Aooctc0ps6wdg4=;
        b=K3znNruKXsPkV3daH0Q7GVBEW7K2/IekZ2XvmkOts8S0ARGxYthQodoquUz8p3uNwT
         Avrmj11p5txcpAcr62oWvQ7Sg/gto3CCjMoHNOKLdkf2x04y3Rltl0rnOBMra7b01O54
         XAlmOIDJciNQ7KsiCjJFMkdYElM1u29yPuOMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4HvsB3jJ0Dp/E1S7E1dBpxrM0q7K1Aooctc0ps6wdg4=;
        b=UWTyeLsk/EGFoaA6jlt1HgGLq5rQV/gkw9RW85IIAJvqwO3zLdpjQSWD28v5p2x6oE
         WDg+C6hhBK51tVdPFdQHHEZeGfcceh47qiu88jlSXpsLrbaMcBw5JzxddP2Jv316i7tf
         Z3q4e/Bm/GF29zcR1i++6ntZeH+U79Fh3bfwnWRYe561CVtPi321yZNvt4SewC2e0dy9
         mXfjUuUxVqBTeoQR7mSMdTjjGkTQ+v3E6PBwuGo0daN173lJcHRKJaySTswxD7soe6nk
         AzXxeYVGW6xRt46Dt+qhjEslJQcs/qowN73j7HbfVHiW73cvt+smvca5UkZGvbB8C0+D
         7OBA==
X-Gm-Message-State: APjAAAV8M+RMaODnP/gKPCXs9F2hkqEFOeR3ye7SBbFBdUGfG1mNtRAe
        Rr2pRpCc7jdMjyOYSiX8LGAsdQ==
X-Google-Smtp-Source: APXvYqwUR57fVRU1DyCmIEmnC5nDu0Hz5lGrD9ADjOdGoVyBzjd3P0kGTd+yfccn8Vf85AZmO3PlZw==
X-Received: by 2002:ac8:1a38:: with SMTP id v53mr2240667qtj.380.1551410772957;
        Thu, 28 Feb 2019 19:26:12 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id s5sm5749721qkf.87.2019.02.28.19.26.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 19:26:12 -0800 (PST)
Date:   Thu, 28 Feb 2019 22:26:11 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
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
Message-ID: <20190301032611.GA78818@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228173444.54403795211d80ba540b61cb@kernel.org>
 <20190228150054.GB156098@google.com>
 <20190301112826.ced40b59fb7e8118fa5b40d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301112826.ced40b59fb7e8118fa5b40d6@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 01, 2019 at 11:28:26AM +0900, Masami Hiramatsu wrote:
> Hi Joel,

Hi Masami,

> On Thu, 28 Feb 2019 10:00:54 -0500
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > > Hmm, isn't it easier to add kernel-headers package on Android?
> > 
> > I have already been down that road. In the Android ecosystem, the Android
> > teams only provide a "userspace system image" which goes on the system
> > partition of the flash (and a couple other images are also provided but
> > system is the main one). The system image cannot contain GPL source code. It
> > is also not possible to put kernel headers for every kernel version on the
> > system images that ship and is not practical. Android boots on 1000s of forked
> > kernels. It does not make sense to provide headers on the system image for
> > every kernel version and I already had many discussions on the subject with
> > the teams, it is something that is just not done. Now for kernel modules,
> > there's another image called the "vendor image" which is flashed onto the
> > vendor parition, this is where kernel modules go.  This vendor image is not
> > provided by Google for non-Pixel devices. So we have no control over what
> > goes there BUT we do know that kernel modules that are enabled will go there,
> > and we do have control over enforcing that certain kernel modules should be
> > built and available as they are mandatory for Android to function properly.
> > We would also possibly make it a built-in option as well. Anyway my point is
> > keeping it in the kernel is really the easiest and the smartest choice IMO.
> 
> Sorry, I'm not convinced yet. This sounds like "because Android decided not
> to put the header files on vendor partition, but kernel module is OK"
> Why don't google ask vendors to put their kernel headers (or header tarball)
> on vendor partition instead?

May be Google can do that, but I think you missed the point of the patches.
Making it a module is not mandatory, people can build it into the kernel as
well (CONFIG_IKHEADERS_PROC=y). In this case, the proc entry will be
available on boot without any dependency on the filesystem. If you go through
the other threads such as folks from ARM who replied, they just boot a kernel
image for debug purpose and want headers on device available without any
additional step of copying headers to the filesystem. And folks from Google
also said that they wanted a built-in option.

There are many usecases for this, I have often run into issues with Linux
over the years not only with Android, but other distros, where I boot custom
kernels with no linux-headers package. This is quite painful. It is
convenient to have it as /proc file since the file is dependent on kernel
being booted up and this will work across all Linux distros and systems. I
feel that if you can keep an open mind about it, you will see that a lot of
people will use this feature if it is accepted and there is a lot of positive
feedback in earlier posts of this set.

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
> > > It seems a bit complex, but no difference from compared with carrying
> > > kheaders.tar.gz. I think we would better have a psudo filesystem
> > > which can mount this compressed header file directly :) Then it becomes
> > > simpler, like
> > > 
> > > modprobe headerfs
> > > mkdir $HOME/headers
> > > mount -t headerfs $HOME/headers
> > > 
> > > And this doesn't consume any disk-space.
> > 
> > I felt using a compressed tar is really the easiest way because of all the
> > tools are already available.
> 
> As I asked above, if the pure tarball is useful, you can simply ask vendors
> to put the header tarball on their vendor directory. I feel making it as
> a module is not a right way.

I don't see what is the drawback of making it a module, it makes it well
integrated into kernel build and ecosystem. I also didn't see any
justification you're providing about why it cannot be a module. If you go
through this and earlier threads, a lot of people are Ok with having a module
option. And I asked several top kernel maintainers at LPC and many people
suggested having it as a module.

> > There isn't a compressed in-ram filesystem right
> > now that I'm aware off that can achieve the kind of high compression ratio
> > this patchset does.
> 
> I think if linux can support something like tarfs(or compressed initramfs)
> in kernel, it gives linux an improvement not only a hack. :-)

Agreed, that sounds like a good idea. I will consider doing it once the
series in its current form can be accepted. I am saying so since this series
is simple, and I can do that as a next step since that idea will take a lot
of time to implement. But I am keen on doing it.

thanks,

 - Joel

