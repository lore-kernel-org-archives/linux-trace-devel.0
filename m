Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A417C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 02:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2700A218A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 02:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="ishsd/C0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbfB1CnR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 21:43:17 -0500
Received: from condef-02.nifty.com ([202.248.20.67]:30858 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730263AbfB1CnQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 21:43:16 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2019 21:43:14 EST
Received: from conssluserg-01.nifty.com ([10.126.8.80])by condef-02.nifty.com with ESMTP id x1S2IrhY029542
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Feb 2019 11:18:53 +0900
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x1S2IR5l004720;
        Thu, 28 Feb 2019 11:18:28 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x1S2IR5l004720
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1551320308;
        bh=n7mhpj2aC7Mve2C5o3EJ+uLUinm0cPgyBJ+lD5dirS0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ishsd/C0l9syvAMcejOYpPHGxTmJm2/72m4tLMiDWPDOEBjSsgCBoTWvgBVjzLmQ7
         b173cgYtygwaXWP7pJ/tbyNxU/OClqklKyOPR1ukfLFasbXg254jdRKR0oe/umyDtE
         6WJl8UZQ4jF5khjKPu81Iw5W9NEFOIvqa3oHEMFYtE2sWBSoZcrLOUg3u4wErJpH+S
         g4Y6F2UgOm2seAkebWv6B63nAWAg/hpVFeRQF2/15XwgCqrnb/W/3lFFRg1/G8ltV/
         4uK+awRFtWQnhmpnMs3PnAihVM6sURAbcoH9UM55lotVGhHf6ilaDVQ3tjfEwy548S
         yngLVGFboG9JQ==
X-Nifty-SrcIP: [209.85.222.43]
Received: by mail-ua1-f43.google.com with SMTP id u1so16703963uae.12;
        Wed, 27 Feb 2019 18:18:28 -0800 (PST)
X-Gm-Message-State: AHQUAuY9OquMMA0oFL+p2pOuaTvQ/bMfkBZw/xK9cWSyx/tu/pxH6uA5
        SgFcNlLShfbfT+6GtbMuTQ8T1twsWK+4PeIIXqE=
X-Google-Smtp-Source: AHgI3IbhBk+562qaiz15OAPhPLDC6T88xJ42uk/xzNQ1LvtsiTxZNM51pAkmLgyLs9h83u+0Vm/TbGP+NS3zDJvAepc=
X-Received: by 2002:a67:7bd3:: with SMTP id w202mr3591054vsc.179.1551320306983;
 Wed, 27 Feb 2019 18:18:26 -0800 (PST)
MIME-Version: 1.0
References: <20190227193748.132301-1-joel@joelfernandes.org>
In-Reply-To: <20190227193748.132301-1-joel@joelfernandes.org>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 28 Feb 2019 11:17:51 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com>
Message-ID: <CAK7LNAR=dpw7y+Y20m0n4ZqzQtqY2XrS3CKk5bQA-Azhp0SN6g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,


On Thu, Feb 28, 2019 at 4:40 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> Introduce in-kernel headers and other artifacts which are made available
> as an archive through proc (/proc/kheaders.tar.xz file). This archive makes
> it possible to build kernel modules, run eBPF programs, and other
> tracing programs that need to extend the kernel for tracing purposes
> without any dependency on the file system having headers and build
> artifacts.
>
> On Android and embedded systems, it is common to switch kernels but not
> have kernel headers available on the file system. Raw kernel headers
> also cannot be copied into the filesystem like they can be on other
> distros, due to licensing and other issues. There's no linux-headers
> package on Android. Further once a different kernel is booted, any
> headers stored on the file system will no longer be useful. By storing
> the headers as a compressed archive within the kernel, we can avoid these
> issues that have been a hindrance for a long time.
>
> The feature is also buildable as a module just in case the user desires
> it not being part of the kernel image. This makes it possible to load
> and unload the headers on demand. A tracing program, or a kernel module
> builder can load the module, do its operations, and then unload the
> module to save kernel memory. The total memory needed is 3.8MB.
>
> The code to read the headers is based on /proc/config.gz code and uses
> the same technique to embed the headers.



Please let me ask a question about the actual use-case.


To build embedded systems including Android,
I use an x86 build machine.

In other words, I cross-compile vmlinux and in-tree modules.
So,

  target-arch: arm64
  host-arch:   x86



> To build a module, the below steps have been tested on an x86 machine:
> modprobe kheaders
> rm -rf $HOME/headers
> mkdir -p $HOME/headers
> tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> cd my-kernel-module
> make -C $HOME/headers M=$(pwd) modules
> rmmod kheaders

I am guessing the user will run these commands
on the target system.
In other words, external modules are native-compiled.
So,

  target-arch: arm64
  host-arch:   arm64


Is this correct?


If I understood the assumed use-case correctly,
kheaders.tar.xw will contain host-programs compiled for x86,
which will not work on the target system.




Masahiro




> Additional notes:
> (1)
> A limitation of module building with this is, since Module.symvers is
> not available in the archive due to a cyclic dependency with building of
> the archive into the kernel or module binaries, the modules built using
> the archive will not contain symbol versioning (modversion). This is
> usually not an issue since the idea of this patch is to build a kernel
> module on the fly and load it into the same kernel. An appropriate
> warning is already printed by the kernel to alert the user of modules
> not having modversions when built using the archive. For building with
> modversions, the user can use traditional header packages. For our
> tracing usecases, we build modules on the fly with this so it is not a
> concern.
>
> (2) I have left IKHD_ST and IKHD_ED markers as is to facilitate
> future patches that would extract the headers from a kernel or module
> image.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---



--
Best Regards
Masahiro Yamada
