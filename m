Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686CBC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EFC2218B0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfB1QWz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:22:55 -0500
Received: from foss.arm.com ([217.140.101.70]:51212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfB1QWy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 11:22:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1539EA78;
        Thu, 28 Feb 2019 08:22:54 -0800 (PST)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.195.17])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8DD23F720;
        Thu, 28 Feb 2019 08:22:49 -0800 (PST)
Date:   Thu, 28 Feb 2019 16:22:46 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org,
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
        rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190228162246.yhqts47g7h3dqbjs@e107158-lin.cambridge.arm.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228135343.23kzkilig3bsioov@e107158-lin.cambridge.arm.com>
 <20190228144759.GA156098@google.com>
 <b100f0a2-7966-b6a2-dcd5-ca11abe57ead@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b100f0a2-7966-b6a2-dcd5-ca11abe57ead@arm.com>
User-Agent: NeoMutt/20171215
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 02/28/19 17:04, Dietmar Eggemann wrote:
> Hi Joel,
> 
> On 2/28/19 3:47 PM, Joel Fernandes wrote:
> > On Thu, Feb 28, 2019 at 01:53:43PM +0000, Qais Yousef wrote:
> > > Hi Joel
> > > 
> > > On 02/27/19 14:37, Joel Fernandes (Google) wrote:
> 
> [...]
> 
> > Ah good catch, I made this change for "file_list=${@:2}" in my tree but
> > forgot to push it. Below is the updated patch. Sorry and I'll refresh the
> > series with the change after we finish the discussion in the other thread.
> > Meanwhile the updated patch is as follows...
> > 
> > ---8<-----------------------
> > 
> > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> > Subject: [PATCH v3.1] Provide in-kernel headers for making it easy to extend the kernel
> > 
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
> 
> This version gives me the header files on a v5.0-rc8 kernel on my arm64 box
> but does not compile anymore on v4.20:
> 
> kernel/kheaders.c:25:22: error: expected identifier or ‘(’ before string
> constant
>  #define KH_MAGIC_END "IKHD_ED"
>                       ^
> kernel/kheaders_data.h:1:1: note: in expansion of macro ‘KH_MAGIC_END’

I believe this is caused by this change ad774086356d (kbuild: change filechk
to surround the given command with { }) which changes how filechk defined - and
since filechk_ikheadersxz is used to generate kheaders_data.h it fails when
backported because the syntax has changed.

HTH

--
Qais Yousef

>  KH_MAGIC_END;
>  ^~~~~~~~~~~~
> kernel/kheaders.c: In function ‘ikheaders_read_current’:
> kernel/kheaders.c:38:12: error: ‘kernel_headers_data’ undeclared (first use
> in this function); did you mean ‘kernel_headers_data_size’?
>             kernel_headers_data + KH_MAGIC_SIZE,
>             ^~~~~~~~~~~~~~~~~~~
>             kernel_headers_data_size
> kernel/kheaders.c:38:12: note: each undeclared identifier is reported only
> once for each function it appears in
> kernel/kheaders.c: In function ‘ikheaders_init’:
> kernel/kheaders.c:31:10: error: ‘kernel_headers_data’ undeclared (first use
> in this function); did you mean ‘kernel_headers_data_size’?
>   (sizeof(kernel_headers_data) - 1 - KH_MAGIC_SIZE * 2)
>           ^
> kernel/kheaders.c:57:23: note: in expansion of macro
> ‘kernel_headers_data_size’
>   proc_set_size(entry, kernel_headers_data_size);
>                        ^~~~~~~~~~~~~~~~~~~~~~~~
> kernel/kheaders.c: In function ‘ikheaders_read_current’:
> kernel/kheaders.c:40:1: warning: control reaches end of non-void function
> [-Wreturn-type]
>  }
> 
> 
> The reason for me to stay on v4.20 is that with v5.0-rc8 I don't have ebpf
> 'raw tracepoint' support any more on my arm64 board. But this issue is not
> related to your patch though.
> 
> Another point which supports the functionality your patch provides is the
> fact that maintainers don't want to see new TRACE_EVENTs in their code. So
> here your patch comes handy when using ebpf for tracing in embedded
> environments.
