Return-Path: <SRS0=JN9e=RH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CA3C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 22:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 289642070B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 22:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfCDWtB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 17:49:01 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:41120 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfCDWtB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 17:49:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 273D3EBD;
        Mon,  4 Mar 2019 14:49:00 -0800 (PST)
Received: from [0.0.0.0] (e107985-lin.cambridge.arm.com [10.1.194.38])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22B923F706;
        Mon,  4 Mar 2019 14:48:54 -0800 (PST)
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
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
References: <20190301160856.129678-1-joel@joelfernandes.org>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <934dc2dc-18b6-bc7c-9845-dac0577f7b47@arm.com>
Date:   Mon, 4 Mar 2019 23:48:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190301160856.129678-1-joel@joelfernandes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 3/1/19 5:08 PM, Joel Fernandes (Google) wrote:
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
> 
> To build a module, the below steps have been tested on an x86 machine:
> modprobe kheaders
> rm -rf $HOME/headers
> mkdir -p $HOME/headers
> tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> cd my-kernel-module
> make -C $HOME/headers M=$(pwd) modules
> rmmod kheaders
> 
> Additional notes:
> (1) external modules must be built on the same arch as the host that
> built vmlinux. This can be done either in a qemu emulated chroot on the
> target, or natively. This is due to host arch dependency of kernel
> scripts.
> 
> (2)
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
> (3) I have left IKHD_ST and IKHD_ED markers as is to facilitate
> future patches that would extract the headers from a kernel or module
> image.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
> 
>      Changes since v3:
>      - Blank tar was being generated because of a one line I
>        forgot to push. It is updated now.
>      - Added module.lds since arm64 needs it to build modules.

Tested on x86 with eBPF scripts and exporting an alternative 
BCC_KERNEL_SOURCE.

Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
