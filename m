Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbeHXRRq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 13:17:46 -0400
Date: Fri, 24 Aug 2018 09:42:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tiago Macieira <thiago.macieira@intel.com>
Subject: Re: libtracevent build warnings on Clear Linux (gcc 8.2.0)
Message-ID: <20180824094259.3e7dfbc7@gandalf.local.home>
In-Reply-To: <20180820133943.GB21100@kernel.org>
References: <20180820133943.GB21100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 20 Aug 2018 10:39:43 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi guys,
> 
> I noticed this while working on a new perf build container for the Clear
> Linux distro, can you take a look at it so that we get the build clean on Clear?

These all look like the compiler is being stupid. Do you think we
really need to address it?

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
> root@28864dcfe31b /git # swupd bundle-add c-basic
> Downloading packs...
> 
> Extracting c-basic pack for version 24500
> 	...50%
> Extracting perl-basic pack for version 24430
> 	...100%
> Starting download of remaining update content. This may take a while...
> 	...100%
> Finishing download of update content...
> Installing bundle(s) files...
> 	...100%
> Calling post-update helper scripts.
> Successfully installed 1 bundle
> root@28864dcfe31b /git # 
> root@28864dcfe31b /git/perf # make -C tools/perf O=/tmp/build/perf
> make: Entering directory '/git/perf/tools/perf'
>   BUILD:   Doing 'make -j4' parallel build
>   HOSTCC   /tmp/build/perf/fixdep.o
>   HOSTLD   /tmp/build/perf/fixdep-in.o
>   LINK     /tmp/build/perf/fixdep
> 
> Auto-detecting system features:
> ...                         dwarf: [ OFF ]
> ...            dwarf_getlocations: [ OFF ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ OFF ]
> ...                      libaudit: [ OFF ]
> ...                        libbfd: [ on  ]
> ...                        libelf: [ OFF ]
> ...                       libnuma: [ OFF ]
> ...        numa_num_possible_cpus: [ OFF ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ OFF ]
> ...                      libslang: [ OFF ]
> ...                     libcrypto: [ OFF ]
> ...                     libunwind: [ OFF ]
> ...            libdw-dwarf-unwind: [ OFF ]
> ...                          zlib: [ on  ]
> ...                          lzma: [ OFF ]
> ...                     get_cpuid: [ on  ]
> ...                           bpf: [ on  ]
> 
> Makefile.config:318: No libelf found. Disables 'probe' tool, jvmti and BPF support in 'perf record'. Please install libelf-dev, libelf-devel or elfutils-libelf-devel
> Makefile.config:445: No sys/sdt.h found, no SDT events are defined, please install systemtap-sdt-devel or systemtap-sdt-dev
> Makefile.config:518: Disabling post unwind, no support found.
> Makefile.config:583: No libcrypto.h found, disables jitted code injection, please install libssl-devel or libssl-dev
> Makefile.config:598: slang not found, disables TUI support. Please install slang-devel, libslang-dev or libslang2-dev
> Makefile.config:612: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
> Makefile.config:666: No python interpreter was found: disables Python support - please install python-devel/python-dev
> Makefile.config:750: No liblzma found, disables xz kernel module decompression, please install xz-devel/liblzma-dev
> Makefile.config:763: No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev
> Makefile.config:814: No libbabeltrace found, disables 'perf data' CTF format support, please install libbabeltrace-dev[el]/libbabeltrace-ctf-dev
>   GEN      /tmp/build/perf/common-cmds.h
>   MKDIR    /tmp/build/perf/fd/
>   CC       /tmp/build/perf/fd/array.o
>   CC       /tmp/build/perf/event-parse.o
>   LD       /tmp/build/perf/fd/libapi-in.o
>   MKDIR    /tmp/build/perf/fs/
>   CC       /tmp/build/perf/fs/fs.o
>   MKDIR    /tmp/build/perf/fs/
>   CC       /tmp/build/perf/fs/tracing_path.o
>   LD       /tmp/build/perf/fs/libapi-in.o
>   CC       /tmp/build/perf/cpu.o
>   CC       /tmp/build/perf/debug.o
>   CC       /tmp/build/perf/str_error_r.o
>   LD       /tmp/build/perf/libapi-in.o
>   AR       /tmp/build/perf/libapi.a
>   CC       /tmp/build/perf/exec-cmd.o
>   MKDIR    /tmp/build/perf/pmu-events/
>   HOSTCC   /tmp/build/perf/pmu-events/json.o
> event-parse.c: In function ‘tep_find_event_by_name’:
> event-parse.c:3519:21: warning: ‘event’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   pevent->last_event = event;
>   ~~~~~~~~~~~~~~~~~~~^~~~~~~
>   MKDIR    /tmp/build/perf/pmu-events/
> event-parse.c: In function ‘tep_data_lat_fmt’:
> event-parse.c:5198:4: warning: ‘migrate_disable’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     trace_seq_printf(s, "%d", migrate_disable);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> event-parse.c:5205:4: warning: ‘lock_depth’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     trace_seq_printf(s, "%d", lock_depth);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   HOSTCC   /tmp/build/perf/pmu-events/jsmn.o
> event-parse.c: In function ‘tep_event_info’:
> event-parse.c:5045:7: warning: ‘len_arg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>        trace_seq_printf(s, format, len_arg, (char)val);
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> event-parse.c:4882:6: note: ‘len_arg’ was declared here
>   int len_arg;
>       ^~~~~~~
> event-parse.c:4336:11: warning: ‘vsize’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>      val = tep_read_number(pevent, bptr, vsize);
>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> event-parse.c:4222:6: note: ‘vsize’ was declared here
>   int vsize;
>       ^~~~~
>   CC       /tmp/build/perf/help.o
>
