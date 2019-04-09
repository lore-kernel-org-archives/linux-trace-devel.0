Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA1FC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 15:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D402084F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 15:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfDIPAm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:00:42 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:39526 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfDIPAm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 11:00:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E94015AB;
        Tue,  9 Apr 2019 08:00:41 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.194.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4803A3F68F;
        Tue,  9 Apr 2019 08:00:37 -0700 (PDT)
Date:   Tue, 9 Apr 2019 16:00:34 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, gregkh@linuxfoundation.org,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: Re: [PATCH v6 1/2] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190409150034.qkeceveap4tblk25@e107158-lin.cambridge.arm.com>
References: <20190408212855.233198-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190408212855.233198-1-joel@joelfernandes.org>
User-Agent: NeoMutt/20171215
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 04/08/19 17:28, Joel Fernandes (Google) wrote:
> Introduce in-kernel headers which are made available as an archive
> through proc (/proc/kheaders.tar.xz file). This archive makes it
> possible to run eBPF and other tracing programs tracing programs that
> need to extend the kernel for tracing purposes without any dependency on
> the file system having headers.
> 
> On Android and embedded systems, it is common to switch kernels but not
> have kernel headers available on the file system. Further once a
> different kernel is booted, any headers stored on the file system will
> no longer be useful. By storing the headers as a compressed archive
> within the kernel, we can avoid these issues that have been a hindrance
> for a long time.
> 
> The best way to use this feature is by building it in. Several users
> have a need for this, when they switch debug kernels, they donot want to
> update the filesystem or worry about it where to store the headers on
> it. However, the feature is also buildable as a module in case the user
> desires it not being part of the kernel image. This makes it possible to
> load and unload the headers from memory on demand. A tracing program, or
> a kernel module builder can load the module, do its operations, and then
> unload the module to save kernel memory. The total memory needed is 3.8MB.
> 
> By having the archive available at a fixed location independent of
> filesystem dependencies and conventions, all debugging tools can
> directly refer to the fixed location for the archive, without concerning
> with where the headers on a typical filesystem which significantly
> simplifies tooling that needs kernel headers.
> 
> The code to read the headers is based on /proc/config.gz code and uses
> the same technique to embed the headers.
> 
> IKHD_ST and IKHD_ED markers as is to facilitate future patches that
> would extract the headers from a kernel or module image.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

I applied both patches on 5.1-rc2 and managed to compile and run several
eBPF programs using the untarred headers from /proc/kheaders.tar.xz on my juno.

Tested-by: Qais Yousef <qais.yousef@arm.com>

> ---
> 
>     v5 -> v6: (Masahiro Yamada suggestions mostly)
>     - Dropped support for module building.
>     - Rebuild archive if script changes.
>     - Move archive file list to script.
>     - Move build script to kernel directory.
> 
>     v4 -> v5:
>     (v4 was Tested-by the following folks)
>         Tested-by: qais.yousef@arm.com
>         Tested-by: dietmar.eggemann@arm.com
>         Tested-by: linux@manojrajarao.com

Thanks!

--
Qais Yousef
