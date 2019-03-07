Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CECC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 08:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A71F20675
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 08:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbfCGI6i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 03:58:38 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34342 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfCGI6h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 03:58:37 -0500
Received: by mail-ua1-f67.google.com with SMTP id a42so9950505uad.1;
        Thu, 07 Mar 2019 00:58:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kzfE04vMH7gLJVW787Hjtm/7lSGeh2p+9g333/HMtVs=;
        b=mlcCQ9nizPyltaPtWgfxxkAZk4bUhlYWDPgZbec4d6RgcNAhCno+8tG1cYtUeuRCgQ
         bHuwmsX9a8tcmopd6tXHaiP6GIJyOX1mdox1EZ1g2U0hKJvHzyC/xIKM2w9ySul9fGvn
         TJAy+sOdO58/MWhol2nQ8Pk/r0K8DwNvuGtI/0zEgy9m6qsIpj8vgX3LxDnnfCfcL0rP
         kywgI26knh8fcer9A3wzh9mDqv7OFHIM4kezJgnkWS1mQSUAhhiOgua4cZ4HNOFmXZF5
         +qIg5/8JUa3MT//HNqVLA5uf43KT47tpnUV/pKJjl7a8dE+T6Z2r3tFAOviY7IufD/OH
         LKvQ==
X-Gm-Message-State: APjAAAX1E2/9UhylZZ2edTLM05ndzSSZEKpKLHI5qVWAoGGYjBiI3RaV
        2yafkfkYpiXVdSSHXW3gJeZq/mRIbMp2D8zwSUM=
X-Google-Smtp-Source: APXvYqyEUghFrAtY7qZEMPA1GVSq8i6Lxl4st8GZgGvA3sEjedoQ3XydQkJfNjP2qaoddEMaDODpnLO/Ncn9M9zuURo=
X-Received: by 2002:ab0:6419:: with SMTP id x25mr6308005uao.20.1551949115911;
 Thu, 07 Mar 2019 00:58:35 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
In-Reply-To: <20190301160856.129678-1-joel@joelfernandes.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 7 Mar 2019 09:58:24 +0100
Message-ID: <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>, atishp04@gmail.com,
        dancol@google.com, Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, qais.yousef@arm.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,

On Fri, Mar 1, 2019 at 5:10 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
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

As the usage pattern will be accessing the individual files, what about
implementing a file system that provides read-only access to the internal
kheaders archive?

    mount kheaders $HOME/headers -t kheaders

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
