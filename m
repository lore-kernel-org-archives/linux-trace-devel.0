Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbeHTS74 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 14:59:56 -0400
Date: Mon, 20 Aug 2018 11:43:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tiago Macieira <thiago.macieira@intel.com>
Subject: Re: libtracevent build warnings on Clear Linux (gcc 8.2.0)
Message-ID: <20180820114345.09b1a9e5@gandalf.local.home>
In-Reply-To: <20180820133943.GB21100@kernel.org>
References: <20180820133943.GB21100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 20 Aug 2018 10:39:43 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi guys,
> 
> I noticed this while working on a new perf build container for the Clear
> Linux distro, can you take a look at it so that we get the build clean on Clear?

Hi Arnaldo,

Thanks for reporting this, Tzvetomir is going to take a look at the
warnings happening in the traceevent directory.

-- Steve

> 
> - Arnaldo
> 
> root@28864dcfe31b /git/perf # gcc -v
> Using built-in specs.
> COLLECT_GCC=gcc
> COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-generic-linux/8.2.0/lto-wrapper
> Target: x86_64-generic-linux
> Configured with: ../gcc-8.2.0/configure --prefix=/usr --with-pkgversion='Clear Linux OS for Intel Architecture' --libdir=/usr/lib64 --enable-libstdcxx-pch --libexecdir=/usr/lib64 --with-system-zlib --enable-shared --enable-gnu-indirect-function --disable-vtable-verify --enable-threads=posix --enable-__cxa_atexit --enable-plugin --enable-ld=default --enable-clocale=gnu --disable-multiarch --enable-multilib --enable-lto --enable-linker-build-id --build=x86_64-generic-linux --target=x86_64-generic-linux --enable-languages=c,c++,fortran,go --enable-bootstrap --with-ppl=yes --with-isl --includedir=/usr/include --with-gxx-include-dir=/usr/include/c++/ --exec-prefix=/usr --with-glibc-version=2.19 --disable-libunwind-exceptions --with-gnu-ld --with-tune=haswell --with-arch=westmere --disable-libmpx
> Thread model: posix
> gcc version 8.2.0 (Clear Linux OS for Intel Architecture) 
> root@28864dcfe31b /git/perf # 
> 
>
