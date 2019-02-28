Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CB3C10F00
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595162184A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:01:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="fcfxUFrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfB1PA5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:00:57 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43986 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbfB1PA5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 10:00:57 -0500
Received: by mail-qt1-f195.google.com with SMTP id y4so23767293qtc.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Feb 2019 07:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=URNHzscQ4qPaUJmS41Sp3RUkVJopCE5QU3VQWfAy40E=;
        b=fcfxUFrx/N1MBaUtE/U8RR6YEfsLOEuRvK0zDOUeqgKoBrzdNIbhG3iljCtSo5q0H4
         wtSf8W1cB213EF+MPYb4NjJNFK54xv3wB/SUj/5zMKCrB/qT/SZOZlVkq9vUie6/s170
         /v+3IvK5wB4f59ckQzb7Qk3SZuyczvveHohZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=URNHzscQ4qPaUJmS41Sp3RUkVJopCE5QU3VQWfAy40E=;
        b=W1JMuyQG2AUYxQOHdSjFQpbGEX+HQb34jeuV6oW3EgzGoq/BEP4UbYneQOgttfwYuS
         BVJW56DHbiHlYQL73Yzu0w2BvtTcKYKuRgS7rA3DfXic3PqdkHbWWynEOGrSdPKgiQB0
         IPXqGTrEOxtkWtGFvJGpM58r6Oq9F6QspP+j26zR0SrrGZhPTkdxTctbqMi29zyMHT7X
         IAl37uGAQgJz9aFiriuC4lMU+3hM9YlH8g7UTypRdZdN2I+Pmgny6k8njUiOmWqjlYBP
         XsXxijNg79FSjBl4mx89uzd0t5DkAQjyQ66Gbi3ZmW717ZtS5eRSnJRz/vHV9C3E2Bnq
         1rmQ==
X-Gm-Message-State: APjAAAW2ATNHwbpREiGrckJXOm2Q046bUv056xrFyrNVh7sw0Y1ixG01
        0sqsky0y6vyW4n+muA3vM28BKw==
X-Google-Smtp-Source: APXvYqzKilytzk378eGD4qTDx1kWARmEnreULgNUEcUhQHobD7w7yarR03QQ7RdG9yyz3WUGj/Fiag==
X-Received: by 2002:a0c:9acb:: with SMTP id k11mr6562969qvf.197.1551366056148;
        Thu, 28 Feb 2019 07:00:56 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id s76sm6597265qki.42.2019.02.28.07.00.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 07:00:55 -0800 (PST)
Date:   Thu, 28 Feb 2019 10:00:54 -0500
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
Message-ID: <20190228150054.GB156098@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228173444.54403795211d80ba540b61cb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228173444.54403795211d80ba540b61cb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 05:34:44PM +0900, Masami Hiramatsu wrote:
> Hi Joel,
> 
> On Wed, 27 Feb 2019 14:37:47 -0500
> "Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:
> 
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
> 
> Hmm, isn't it easier to add kernel-headers package on Android?

I have already been down that road. In the Android ecosystem, the Android
teams only provide a "userspace system image" which goes on the system
partition of the flash (and a couple other images are also provided but
system is the main one). The system image cannot contain GPL source code. It
is also not possible to put kernel headers for every kernel version on the
system images that ship and is not practical. Android boots on 1000s of forked
kernels. It does not make sense to provide headers on the system image for
every kernel version and I already had many discussions on the subject with
the teams, it is something that is just not done. Now for kernel modules,
there's another image called the "vendor image" which is flashed onto the
vendor parition, this is where kernel modules go.  This vendor image is not
provided by Google for non-Pixel devices. So we have no control over what
goes there BUT we do know that kernel modules that are enabled will go there,
and we do have control over enforcing that certain kernel modules should be
built and available as they are mandatory for Android to function properly.
We would also possibly make it a built-in option as well. Anyway my point is
keeping it in the kernel is really the easiest and the smartest choice IMO.

> > The feature is also buildable as a module just in case the user desires
> > it not being part of the kernel image. This makes it possible to load
> > and unload the headers on demand. A tracing program, or a kernel module
> > builder can load the module, do its operations, and then unload the
> > module to save kernel memory. The total memory needed is 3.8MB.
> 
> But it also requires to install build environment (tools etc.)
> on the target system...

Yes, that's true. Check the other thread with Masahiro that we are discussing
this point on and let us continue discussing there:
https://lore.kernel.org/patchwork/patch/1046307/#1238223
https://lore.kernel.org/patchwork/patch/1046307/#1238491

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
> 
> It seems a bit complex, but no difference from compared with carrying
> kheaders.tar.gz. I think we would better have a psudo filesystem
> which can mount this compressed header file directly :) Then it becomes
> simpler, like
> 
> modprobe headerfs
> mkdir $HOME/headers
> mount -t headerfs $HOME/headers
> 
> And this doesn't consume any disk-space.

I felt using a compressed tar is really the easiest way because of all the
tools are already available. There isn't a compressed in-ram filesystem right
now that I'm aware off that can achieve the kind of high compression ratio
this patchset does.

thanks,

 - Joel

