Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2609C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 16:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A745220652
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 16:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="hcU2U2qb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfCEQZ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 11:25:27 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44945 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfCEQZ0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 11:25:26 -0500
Received: by mail-qt1-f196.google.com with SMTP id d2so9516067qti.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 08:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/Ge2DKc8DMthB5Ba52pSQpiB9j28X+ncf3wXtDuR5vw=;
        b=hcU2U2qb1IwKk2btOW7rAxR816NBesZIYuL47lLgAbZVah0HzTaci3+4h7cMEfLGRy
         1XqC4Gp7XQjfQBCCiSHFdVzeVpUbA3gnVttlGKLXRAXl4Ro3bljQqjwCR8ekPptkNQPW
         TZXRmtLhWPNdoHId0oAp4g6rIk/WERpiDOACc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/Ge2DKc8DMthB5Ba52pSQpiB9j28X+ncf3wXtDuR5vw=;
        b=a5RJgPCTzTBvg1T/Mkek5ZIakBGel/y2dplWbMe1BoycfMX53wswACHaWIpYJ89fSO
         RRd1z5GQltrq8sVhKcRdlsuqoZzNzET2UqDXVkIwAGpdhbl5x1/juRfEz92dYGn/GzqL
         4pvRWWNK1Xn2KzBl3sdOKGBbDmD8zDYbMfkqd5+fvXwIOwXYvV8LMtImL09WjpA9fvJc
         i6B7vBqU0HbE1lCUc7uAsxsRNAav7gpwgYbtvw1bsrStyHJ3B57SYOvzkUjkp1eAOVUA
         gjG2v0qvJhJAaxgL77YxOPfmh2ZebUthso8fRw7jSmwfHJ8GNU6lAGnDpERYMfgzCDjP
         FMzw==
X-Gm-Message-State: APjAAAVYpDDRwslI7upuXmjhPjI4r5TcSxvL4XGGdeNAGsMuEqx1UGqE
        HKVL4W7HDktsPsM6WyA3cBXGTg==
X-Google-Smtp-Source: APXvYqx0cgj1Idl80RF2elhNrNAqNbVT9EMvy+T0OAAe9t1m+gzFnyvi6HlANjVdEPDtOjgo3jjzdA==
X-Received: by 2002:ac8:1b96:: with SMTP id z22mr1988621qtj.329.1551803125182;
        Tue, 05 Mar 2019 08:25:25 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id u1sm6065184qki.36.2019.03.05.08.25.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Mar 2019 08:25:23 -0800 (PST)
Date:   Tue, 5 Mar 2019 11:25:23 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
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
        mhiramat@kernel.org, qais.yousef@arm.com, rdunlap@infradead.org,
        rostedt@goodmis.org, Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190305162523.GA78911@google.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <934dc2dc-18b6-bc7c-9845-dac0577f7b47@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <934dc2dc-18b6-bc7c-9845-dac0577f7b47@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 04, 2019 at 11:48:52PM +0100, Dietmar Eggemann wrote:
> On 3/1/19 5:08 PM, Joel Fernandes (Google) wrote:
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
> > A limitation of module building with this is, since Module.symvers is
> > not available in the archive due to a cyclic dependency with building of
> > the archive into the kernel or module binaries, the modules built using
> > the archive will not contain symbol versioning (modversion). This is
> > usually not an issue since the idea of this patch is to build a kernel
> > module on the fly and load it into the same kernel. An appropriate
> > warning is already printed by the kernel to alert the user of modules
> > not having modversions when built using the archive. For building with
> > modversions, the user can use traditional header packages. For our
> > tracing usecases, we build modules on the fly with this so it is not a
> > concern.
> > 
> > (3) I have left IKHD_ST and IKHD_ED markers as is to facilitate
> > future patches that would extract the headers from a kernel or module
> > image.
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> > 
> >      Changes since v3:
> >      - Blank tar was being generated because of a one line I
> >        forgot to push. It is updated now.
> >      - Added module.lds since arm64 needs it to build modules.
> 
> Tested on x86 with eBPF scripts and exporting an alternative
> BCC_KERNEL_SOURCE.
> 
> Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

Thank you! Will repost with the tags soon.

- Joel

