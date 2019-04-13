Return-Path: <SRS0=1j5l=SP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99EBC10F14
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 01:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 908C820850
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 01:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="pbRnKRv+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfDMBbJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 21:31:09 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:56540 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbfDMBbI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 21:31:08 -0400
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x3D1Ukt9002455;
        Sat, 13 Apr 2019 10:30:47 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x3D1Ukt9002455
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1555119047;
        bh=AbRj27RMd8pEgTSOE0frMyOiJbfpx0njCrPKGZLSK6c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pbRnKRv+xLHb3eeq1jDA5cNVauhVhHtlXp5JMAtsmkHYaUEhRIgpaSs+qKll4O1Mt
         x28LodrRZ+6Bzes9iA/OeoXwU6X+0OtENup7F5mm6kqh05Uj6pOIptngd7/hYz/yQv
         9dEF/ALswv3hey+DAFA4HnYmDsdbmyxqVCG8YSDSotkFZ+jyaWXOzgtvERHLSjdmES
         wVHu+D+XqQI3zymI9oljqmCFVe84B9m1xU0mM7U68TTFbG1YQrkxvLFXYC8HzWHAbZ
         5U4atY51JvgvTBuqE2SCpVcmQI+1HDfVd6tGaZ8KAlOObyXeNCFtAG0V1rx6IxModu
         kZUR1qKlEgBTA==
X-Nifty-SrcIP: [209.85.217.52]
Received: by mail-vs1-f52.google.com with SMTP id f22so6578644vso.7;
        Fri, 12 Apr 2019 18:30:47 -0700 (PDT)
X-Gm-Message-State: APjAAAXXFHYe0csJOWHxRZKk/AJYs1ihBNbU0PcYthe89ldUkkB20lU6
        PaORMCH+cnf5GAW2rKb4lsJeSgoZOyzzMgJxclM=
X-Google-Smtp-Source: APXvYqxD1Mm3rjY9XlUVAqjlcWGoGiAZcdDc9L8lJwDh8hz2IxPmjfq3XOuPsiyMUcA4dxshI8iIRfFaA6SjozAmE8o=
X-Received: by 2002:a67:f714:: with SMTP id m20mr34654180vso.211.1555119045997;
 Fri, 12 Apr 2019 18:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190412195125.3891-1-joel@joelfernandes.org>
In-Reply-To: <20190412195125.3891-1-joel@joelfernandes.org>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 13 Apr 2019 10:30:10 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR=KN3gnJT5w1HgrZ5UyeiNZy_rn1Z1wWwgwy3eGF4RgQ@mail.gmail.com>
Message-ID: <CAK7LNAR=KN3gnJT5w1HgrZ5UyeiNZy_rn1Z1wWwgwy3eGF4RgQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] Provide in-kernel headers to make extending kernel easier
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Apr 13, 2019 at 4:54 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> Introduce in-kernel headers which are made available as an archive
> through proc (/proc/kheaders.tar.xz file). This archive makes it
> possible to run eBPF and other tracing programs that need to extend the
> kernel for tracing purposes without any dependency on the file system
> having headers.
>
> A github PR is sent for the corresponding BCC patch at:
> https://github.com/iovisor/bcc/pull/2312
>
> On Android and embedded systems, it is common to switch kernels but not
> have kernel headers available on the file system. Further once a
> different kernel is booted, any headers stored on the file system will
> no longer be useful. This is an issue even well known to distros.
> By storing the headers as a compressed archive within the kernel, we can
> avoid these issues that have been a hindrance for a long time.
>
> The best way to use this feature is by building it in. Several users
> have a need for this, when they switch debug kernels, they do not want to
> update the filesystem or worry about it where to store the headers on
> it. However, the feature is also buildable as a module in case the user
> desires it not being part of the kernel image. This makes it possible to
> load and unload the headers from memory on demand. A tracing program can
> load the module, do its operations, and then unload the module to save
> kernel memory. The total memory needed is 3.3MB.
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
> Other approaches were discussed such as having an in-memory mountable
> filesystem, but that has drawbacks such as requiring an in-kernel xz
> decompressor which we don't have today, and requiring usage of 42 MB of
> kernel memory to host the decompressed headers at anytime. Also this
> approach is simpler than such approaches.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---


I just noticed minor typos in comment lines (see below).

Anyway, I have no more comment from the build system of view.
So,

Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>



> diff --git a/kernel/kheaders.c b/kernel/kheaders.c
> new file mode 100644
> index 000000000000..19526294a4e8
> --- /dev/null
> +++ b/kernel/kheaders.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Provide kernel headers useful to build tracing programs
> + * such as for running eBPF tracing tools.
> + *
> + * (Borrowed code from kernel/configs.c)
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/proc_fs.h>
> +#include <linux/init.h>
> +#include <linux/uaccess.h>
> +
> +/*
> + * Define kernel_headers_data and kernel_headers_data_end, within which the the
> + * compressed kernel headers are stpred. The file is first compressed with xz.
> + */


"the the" -> "the"     ?
"stpred"  -> "stored"  ?


It is up to you if you want to send v8.




-- 
Best Regards
Masahiro Yamada
