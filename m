Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4ADC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 08:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25EEB218AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 08:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551342892;
	bh=1Ok9YCr1jJh+ph2hLY5yswrP0Etv+EN2lqnJ2dIYNEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=UrPvmvLhCf2OOosnDvkdG/6yS32iWb5/dTeHSmlDU9uBfyZGZCB6tXIDjcemztun2
	 1MsMn6Kv7dRTvo8dW7uaPG/1C7oJ0nRVH+0l+onXLGXWl7cEIt3hi+z1TbXIP/i8K2
	 HoEP4zsh11lCayy/jTHTGuphAsahQnuec1JD4gY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfB1Iev (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:34:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfB1Iev (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 03:34:51 -0500
Received: from devbox (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60F7F2184A;
        Thu, 28 Feb 2019 08:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551342890;
        bh=1Ok9YCr1jJh+ph2hLY5yswrP0Etv+EN2lqnJ2dIYNEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7vNW/WnLyGCiFP/iPFpM9V6ReNy4dm+oKYu1clucazlY5Hp828V+u5ybb/eOqxgC
         RUlyvXnxAP50ZBYbd4repUlMsHsPn/LhP9lYEgR08hDKK8V10cuKB+vFnn1eGCuEgh
         SDr6s1zLoYhUky0DwEeyp1OjbH3vIDHEp9uCKqTw=
Date:   Thu, 28 Feb 2019 17:34:44 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
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
        mhiramat@kernel.org, paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        qais.yousef@arm.com, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-Id: <20190228173444.54403795211d80ba540b61cb@kernel.org>
In-Reply-To: <20190227193748.132301-1-joel@joelfernandes.org>
References: <20190227193748.132301-1-joel@joelfernandes.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,

On Wed, 27 Feb 2019 14:37:47 -0500
"Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:

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

Hmm, isn't it easier to add kernel-headers package on Android?

> The feature is also buildable as a module just in case the user desires
> it not being part of the kernel image. This makes it possible to load
> and unload the headers on demand. A tracing program, or a kernel module
> builder can load the module, do its operations, and then unload the
> module to save kernel memory. The total memory needed is 3.8MB.

But it also requires to install build environment (tools etc.)
on the target system...

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

It seems a bit complex, but no difference from compared with carrying
kheaders.tar.gz. I think we would better have a psudo filesystem
which can mount this compressed header file directly :) Then it becomes
simpler, like

modprobe headerfs
mkdir $HOME/headers
mount -t headerfs $HOME/headers

And this doesn't consume any disk-space.

Thank you,




-- 
Masami Hiramatsu <mhiramat@kernel.org>
