Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbeHTQz3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 12:55:29 -0400
Date: Mon, 20 Aug 2018 10:39:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tiago Macieira <thiago.macieira@intel.com>
Subject: libtracevent build warnings on Clear Linux (gcc 8.2.0)
Message-ID: <20180820133943.GB21100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi guys,

I noticed this while working on a new perf build container for the Clear
Linux distro, can you take a look at it so that we get the build clean on Clear?

- Arnaldo

root@28864dcfe31b /git/perf # gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-generic-linux/8.2.0/lto-wrapper
Target: x86_64-generic-linux
Configured with: ../gcc-8.2.0/configure --prefix=/usr --with-pkgversion='Clear Linux OS for Intel Architecture' --libdir=/usr/lib64 --enable-libstdcxx-pch --libexecdir=/usr/lib64 --with-system-zlib --enable-shared --enable-gnu-indirect-function --disable-vtable-verify --enable-threads=posix --enable-__cxa_atexit --enable-plugin --enable-ld=default --enable-clocale=gnu --disable-multiarch --enable-multilib --enable-lto --enable-linker-build-id --build=x86_64-generic-linux --target=x86_64-generic-linux --enable-languages=c,c++,fortran,go --enable-bootstrap --with-ppl=yes --with-isl --includedir=/usr/include --with-gxx-include-dir=/usr/include/c++/ --exec-prefix=/usr --with-glibc-version=2.19 --disable-libunwind-exceptions --with-gnu-ld --with-tune=haswell --with-arch=westmere --disable-libmpx
Thread model: posix
gcc version 8.2.0 (Clear Linux OS for Intel Architecture) 
root@28864dcfe31b /git/perf # 

root@28864dcfe31b /git # swupd bundle-add c-basic
Downloading packs...

Extracting c-basic pack for version 24500
	...50%
Extracting perl-basic pack for version 24430
	...100%
Starting download of remaining update content. This may take a while...
	...100%
Finishing download of update content...
Installing bundle(s) files...
	...100%
Calling post-update helper scripts.
Successfully installed 1 bundle
root@28864dcfe31b /git # 
root@28864dcfe31b /git/perf # make -C tools/perf O=/tmp/build/perf
make: Entering directory '/git/perf/tools/perf'
  BUILD:   Doing 'make -j4' parallel build
  HOSTCC   /tmp/build/perf/fixdep.o
  HOSTLD   /tmp/build/perf/fixdep-in.o
  LINK     /tmp/build/perf/fixdep

Auto-detecting system features:
...                         dwarf: [ OFF ]
...            dwarf_getlocations: [ OFF ]
...                         glibc: [ on  ]
...                          gtk2: [ OFF ]
...                      libaudit: [ OFF ]
...                        libbfd: [ on  ]
...                        libelf: [ OFF ]
...                       libnuma: [ OFF ]
...        numa_num_possible_cpus: [ OFF ]
...                       libperl: [ on  ]
...                     libpython: [ OFF ]
...                      libslang: [ OFF ]
...                     libcrypto: [ OFF ]
...                     libunwind: [ OFF ]
...            libdw-dwarf-unwind: [ OFF ]
...                          zlib: [ on  ]
...                          lzma: [ OFF ]
...                     get_cpuid: [ on  ]
...                           bpf: [ on  ]

Makefile.config:318: No libelf found. Disables 'probe' tool, jvmti and BPF support in 'perf record'. Please install libelf-dev, libelf-devel or elfutils-libelf-devel
Makefile.config:445: No sys/sdt.h found, no SDT events are defined, please install systemtap-sdt-devel or systemtap-sdt-dev
Makefile.config:518: Disabling post unwind, no support found.
Makefile.config:583: No libcrypto.h found, disables jitted code injection, please install libssl-devel or libssl-dev
Makefile.config:598: slang not found, disables TUI support. Please install slang-devel, libslang-dev or libslang2-dev
Makefile.config:612: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
Makefile.config:666: No python interpreter was found: disables Python support - please install python-devel/python-dev
Makefile.config:750: No liblzma found, disables xz kernel module decompression, please install xz-devel/liblzma-dev
Makefile.config:763: No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev
Makefile.config:814: No libbabeltrace found, disables 'perf data' CTF format support, please install libbabeltrace-dev[el]/libbabeltrace-ctf-dev
  GEN      /tmp/build/perf/common-cmds.h
  MKDIR    /tmp/build/perf/fd/
  CC       /tmp/build/perf/fd/array.o
  CC       /tmp/build/perf/event-parse.o
  LD       /tmp/build/perf/fd/libapi-in.o
  MKDIR    /tmp/build/perf/fs/
  CC       /tmp/build/perf/fs/fs.o
  MKDIR    /tmp/build/perf/fs/
  CC       /tmp/build/perf/fs/tracing_path.o
  LD       /tmp/build/perf/fs/libapi-in.o
  CC       /tmp/build/perf/cpu.o
  CC       /tmp/build/perf/debug.o
  CC       /tmp/build/perf/str_error_r.o
  LD       /tmp/build/perf/libapi-in.o
  AR       /tmp/build/perf/libapi.a
  CC       /tmp/build/perf/exec-cmd.o
  MKDIR    /tmp/build/perf/pmu-events/
  HOSTCC   /tmp/build/perf/pmu-events/json.o
event-parse.c: In function ‘tep_find_event_by_name’:
event-parse.c:3519:21: warning: ‘event’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  pevent->last_event = event;
  ~~~~~~~~~~~~~~~~~~~^~~~~~~
  MKDIR    /tmp/build/perf/pmu-events/
event-parse.c: In function ‘tep_data_lat_fmt’:
event-parse.c:5198:4: warning: ‘migrate_disable’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    trace_seq_printf(s, "%d", migrate_disable);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
event-parse.c:5205:4: warning: ‘lock_depth’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    trace_seq_printf(s, "%d", lock_depth);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  HOSTCC   /tmp/build/perf/pmu-events/jsmn.o
event-parse.c: In function ‘tep_event_info’:
event-parse.c:5045:7: warning: ‘len_arg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
       trace_seq_printf(s, format, len_arg, (char)val);
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
event-parse.c:4882:6: note: ‘len_arg’ was declared here
  int len_arg;
      ^~~~~~~
event-parse.c:4336:11: warning: ‘vsize’ may be used uninitialized in this function [-Wmaybe-uninitialized]
     val = tep_read_number(pevent, bptr, vsize);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
event-parse.c:4222:6: note: ‘vsize’ was declared here
  int vsize;
      ^~~~~
  CC       /tmp/build/perf/help.o
  HOSTCC   /tmp/build/perf/pmu-events/jevents.o
  HOSTLD   /tmp/build/perf/pmu-events/jevents-in.o
  CC       /tmp/build/perf/pager.o
  CC       /tmp/build/perf/event-plugin.o
  CC       /tmp/build/perf/plugin_jbd2.o
  LD       /tmp/build/perf/plugin_jbd2-in.o
  CC       /tmp/build/perf/trace-seq.o
  CC       /tmp/build/perf/plugin_hrtimer.o
  CC       /tmp/build/perf/parse-options.o
  LD       /tmp/build/perf/plugin_hrtimer-in.o
  CC       /tmp/build/perf/plugin_kmem.o
  CC       /tmp/build/perf/parse-filter.o
  LD       /tmp/build/perf/plugin_kmem-in.o
  CC       /tmp/build/perf/plugin_kvm.o
  LD       /tmp/build/perf/plugin_kvm-in.o
  CC       /tmp/build/perf/plugin_mac80211.o
  LD       /tmp/build/perf/plugin_mac80211-in.o
  CC       /tmp/build/perf/plugin_sched_switch.o
  CC       /tmp/build/perf/parse-utils.o
  CC       /tmp/build/perf/kbuffer-parse.o
  LD       /tmp/build/perf/plugin_sched_switch-in.o
  CC       /tmp/build/perf/plugin_function.o
  CC       /tmp/build/perf/run-command.o
  LD       /tmp/build/perf/libtraceevent-in.o
  LINK     /tmp/build/perf/libtraceevent.a
  CC       /tmp/build/perf/plugin_xen.o
  LD       /tmp/build/perf/plugin_function-in.o
  PERF_VERSION = 4.18.0
  CC       /tmp/build/perf/plugin_scsi.o
  LINK     /tmp/build/perf/pmu-events/jevents
  GEN      perf-archive
  LD       /tmp/build/perf/plugin_xen-in.o
  CC       /tmp/build/perf/plugin_cfg80211.o
  LINK     /tmp/build/perf/plugin_jbd2.so
  LD       /tmp/build/perf/plugin_scsi-in.o
  LINK     /tmp/build/perf/plugin_hrtimer.so
  LINK     /tmp/build/perf/plugin_kmem.so
  LINK     /tmp/build/perf/plugin_kvm.so
  LD       /tmp/build/perf/plugin_cfg80211-in.o
  LINK     /tmp/build/perf/plugin_mac80211.so
  LINK     /tmp/build/perf/plugin_sched_switch.so
  CC       /tmp/build/perf/sigchain.o
  LINK     /tmp/build/perf/plugin_function.so
  LINK     /tmp/build/perf/plugin_xen.so
  LINK     /tmp/build/perf/plugin_scsi.so
  LINK     /tmp/build/perf/plugin_cfg80211.so
  CC       /tmp/build/perf/subcmd-config.o
  GEN      perf-with-kcore
  CC       /tmp/build/perf/builtin-bench.o
  MKDIR    /tmp/build/perf/util/
  CC       /tmp/build/perf/util/annotate.o
  MKDIR    /tmp/build/perf/util/
  CC       /tmp/build/perf/util/block-range.o
  LD       /tmp/build/perf/libsubcmd-in.o
  AR       /tmp/build/perf/libsubcmd.a
  GEN      /tmp/build/perf/pmu-events/pmu-events.c
  CC       /tmp/build/perf/builtin-annotate.o
  CC       /tmp/build/perf/util/build-id.o
  CC       /tmp/build/perf/pmu-events/pmu-events.o
  LD       /tmp/build/perf/pmu-events/pmu-events-in.o
  CC       /tmp/build/perf/builtin-config.o
  CC       /tmp/build/perf/util/config.o
  GEN      /tmp/build/perf/libtraceevent-dynamic-list
  CC       /tmp/build/perf/builtin-diff.o
  CC       /tmp/build/perf/builtin-evlist.o
  CC       /tmp/build/perf/builtin-ftrace.o
  CC       /tmp/build/perf/util/ctype.o
  CC       /tmp/build/perf/util/db-export.o
  CC       /tmp/build/perf/builtin-help.o
  CC       /tmp/build/perf/util/env.o
  CC       /tmp/build/perf/builtin-sched.o
  CC       /tmp/build/perf/builtin-buildid-list.o
  CC       /tmp/build/perf/util/event.o
  CC       /tmp/build/perf/util/evlist.o
  CC       /tmp/build/perf/builtin-buildid-cache.o
  CC       /tmp/build/perf/builtin-kallsyms.o
  CC       /tmp/build/perf/util/evsel.o
  CC       /tmp/build/perf/builtin-list.o
  CC       /tmp/build/perf/util/evsel_fprintf.o
  CC       /tmp/build/perf/builtin-record.o
  CC       /tmp/build/perf/util/find_bit.o
  CC       /tmp/build/perf/util/kallsyms.o
  CC       /tmp/build/perf/builtin-report.o
  CC       /tmp/build/perf/util/levenshtein.o
  CC       /tmp/build/perf/builtin-stat.o
  CC       /tmp/build/perf/util/llvm-utils.o
  CC       /tmp/build/perf/util/mmap.o
  CC       /tmp/build/perf/util/memswap.o
  BISON    /tmp/build/perf/util/parse-events-bison.c
  CC       /tmp/build/perf/builtin-timechart.o
  CC       /tmp/build/perf/util/perf_regs.o
  CC       /tmp/build/perf/arch/common.o
  MKDIR    /tmp/build/perf/arch/x86/util/
  CC       /tmp/build/perf/arch/x86/util/header.o
  MKDIR    /tmp/build/perf/arch/x86/util/
  CC       /tmp/build/perf/arch/x86/util/tsc.o
  CC       /tmp/build/perf/arch/x86/util/pmu.o
  CC       /tmp/build/perf/builtin-top.o
  CC       /tmp/build/perf/arch/x86/util/kvm-stat.o
  CC       /tmp/build/perf/builtin-script.o
  CC       /tmp/build/perf/arch/x86/util/perf_regs.o
  CC       /tmp/build/perf/arch/x86/util/group.o
  CC       /tmp/build/perf/arch/x86/util/machine.o
  CC       /tmp/build/perf/arch/x86/util/event.o
  MKDIR    /tmp/build/perf/arch/x86/tests/
  CC       /tmp/build/perf/arch/x86/tests/arch-tests.o
  MKDIR    /tmp/build/perf/arch/x86/tests/
  CC       /tmp/build/perf/arch/x86/tests/rdpmc.o
  CC       /tmp/build/perf/arch/x86/util/auxtrace.o
  CC       /tmp/build/perf/arch/x86/tests/perf-time-to-tsc.o
  CC       /tmp/build/perf/arch/x86/util/intel-pt.o
  CC       /tmp/build/perf/arch/x86/tests/insn-x86.o
  LD       /tmp/build/perf/arch/x86/tests/libperf-in.o
  CC       /tmp/build/perf/arch/x86/util/intel-bts.o
  CC       /tmp/build/perf/builtin-kmem.o
  CC       /tmp/build/perf/util/path.o
  CC       /tmp/build/perf/util/print_binary.o
  LD       /tmp/build/perf/arch/x86/util/libperf-in.o
  CC       /tmp/build/perf/util/rbtree.o
  LD       /tmp/build/perf/arch/x86/libperf-in.o
  LD       /tmp/build/perf/arch/libperf-in.o
  CC       /tmp/build/perf/util/libstring.o
  MKDIR    /tmp/build/perf/ui/
  CC       /tmp/build/perf/ui/setup.o
  MKDIR    /tmp/build/perf/ui/
  CC       /tmp/build/perf/ui/helpline.o
  CC       /tmp/build/perf/util/bitmap.o
  CC       /tmp/build/perf/ui/progress.o
  CC       /tmp/build/perf/util/hweight.o
  CC       /tmp/build/perf/ui/util.o
  CC       /tmp/build/perf/util/smt.o
  CC       /tmp/build/perf/util/strbuf.o
  CC       /tmp/build/perf/util/string.o
  CC       /tmp/build/perf/ui/hist.o
  CC       /tmp/build/perf/util/strlist.o
  CC       /tmp/build/perf/builtin-lock.o
  CC       /tmp/build/perf/util/strfilter.o
  CC       /tmp/build/perf/util/top.o
  CC       /tmp/build/perf/util/usage.o
  CC       /tmp/build/perf/util/dso.o
  CC       /tmp/build/perf/util/symbol.o
  CC       /tmp/build/perf/builtin-kvm.o
  MKDIR    /tmp/build/perf/ui/stdio/
  CC       /tmp/build/perf/ui/stdio/hist.o
  CC       /tmp/build/perf/util/symbol_fprintf.o
  CC       /tmp/build/perf/util/color.o
  CC       /tmp/build/perf/builtin-inject.o
  CC       /tmp/build/perf/util/metricgroup.o
  CC       /tmp/build/perf/util/header.o
  LD       /tmp/build/perf/ui/libperf-in.o
  MKDIR    /tmp/build/perf/scripts/perl/Perf-Trace-Util/
  CC       /tmp/build/perf/scripts/perl/Perf-Trace-Util/Context.o
  CC       /tmp/build/perf/builtin-mem.o
  CC       /tmp/build/perf/util/callchain.o
  LD       /tmp/build/perf/scripts/perl/Perf-Trace-Util/libperf-in.o
  CC       /tmp/build/perf/builtin-data.o
  LD       /tmp/build/perf/scripts/libperf-in.o
  CC       /tmp/build/perf/trace/beauty/clone.o
  CC       /tmp/build/perf/builtin-version.o
  CC       /tmp/build/perf/trace/beauty/fcntl.o
  CC       /tmp/build/perf/builtin-c2c.o
  CC       /tmp/build/perf/trace/beauty/flock.o
  CC       /tmp/build/perf/trace/beauty/ioctl.o
  CC       /tmp/build/perf/trace/beauty/kcmp.o
  CC       /tmp/build/perf/util/values.o
  CC       /tmp/build/perf/trace/beauty/pkey_alloc.o
  CC       /tmp/build/perf/trace/beauty/prctl.o
  CC       /tmp/build/perf/util/debug.o
  CC       /tmp/build/perf/trace/beauty/socket.o
  CC       /tmp/build/perf/trace/beauty/statx.o
  LD       /tmp/build/perf/trace/beauty/libperf-in.o
  CC       /tmp/build/perf/util/machine.o
  CC       /tmp/build/perf/builtin-trace.o
  MKDIR    /tmp/build/perf/bench/
  CC       /tmp/build/perf/bench/sched-messaging.o
  CC       /tmp/build/perf/util/map.o
  MKDIR    /tmp/build/perf/bench/
  CC       /tmp/build/perf/bench/sched-pipe.o
  CC       /tmp/build/perf/bench/mem-functions.o
  CC       /tmp/build/perf/util/pstack.o
  CC       /tmp/build/perf/bench/futex-hash.o
  CC       /tmp/build/perf/bench/futex-wake.o
  CC       /tmp/build/perf/util/session.o
  MKDIR    /tmp/build/perf/tests/
  CC       /tmp/build/perf/tests/builtin-test.o
  CC       /tmp/build/perf/bench/futex-wake-parallel.o
  MKDIR    /tmp/build/perf/tests/
  CC       /tmp/build/perf/tests/parse-events.o
  CC       /tmp/build/perf/bench/futex-requeue.o
  CC       /tmp/build/perf/perf.o
  CC       /tmp/build/perf/bench/futex-lock-pi.o
  CC       /tmp/build/perf/bench/mem-memcpy-x86-64-lib.o
  CC       /tmp/build/perf/bench/mem-memcpy-x86-64-asm.o
  CC       /tmp/build/perf/bench/mem-memset-x86-64-asm.o
  CC       /tmp/build/perf/tests/dso-data.o
  CC       /tmp/build/perf/util/syscalltbl.o
  LD       /tmp/build/perf/bench/perf-in.o
  CC       /tmp/build/perf/util/ordered-events.o
  CC       /tmp/build/perf/util/namespaces.o
  CC       /tmp/build/perf/tests/attr.o
  CC       /tmp/build/perf/tests/vmlinux-kallsyms.o
  CC       /tmp/build/perf/util/comm.o
  CC       /tmp/build/perf/util/thread.o
  CC       /tmp/build/perf/util/thread_map.o
  CC       /tmp/build/perf/tests/openat-syscall.o
  CC       /tmp/build/perf/tests/openat-syscall-all-cpus.o
  CC       /tmp/build/perf/tests/openat-syscall-tp-fields.o
  CC       /tmp/build/perf/util/trace-event-parse.o
  CC       /tmp/build/perf/util/parse-events-bison.o
  CC       /tmp/build/perf/tests/mmap-basic.o
  CC       /tmp/build/perf/tests/perf-record.o
  BISON    /tmp/build/perf/util/pmu-bison.c
  CC       /tmp/build/perf/util/trace-event-read.o
  CC       /tmp/build/perf/tests/evsel-roundtrip-name.o
  CC       /tmp/build/perf/tests/evsel-tp-sched.o
  CC       /tmp/build/perf/util/trace-event-info.o
  CC       /tmp/build/perf/util/trace-event-scripting.o
  CC       /tmp/build/perf/tests/fdarray.o
  CC       /tmp/build/perf/util/trace-event.o
  CC       /tmp/build/perf/tests/pmu.o
  CC       /tmp/build/perf/util/svghelper.o
  CC       /tmp/build/perf/tests/hists_common.o
  CC       /tmp/build/perf/util/sort.o
  CC       /tmp/build/perf/tests/hists_link.o
  CC       /tmp/build/perf/tests/hists_filter.o
  CC       /tmp/build/perf/tests/hists_output.o
  CC       /tmp/build/perf/tests/hists_cumulate.o
  CC       /tmp/build/perf/util/hist.o
  CC       /tmp/build/perf/tests/python-use.o
  CC       /tmp/build/perf/tests/bp_signal.o
  CC       /tmp/build/perf/tests/bp_signal_overflow.o
  CC       /tmp/build/perf/tests/bp_account.o
  CC       /tmp/build/perf/tests/task-exit.o
  CC       /tmp/build/perf/util/util.o
  CC       /tmp/build/perf/tests/sw-clock.o
  CC       /tmp/build/perf/tests/mmap-thread-lookup.o
  CC       /tmp/build/perf/util/xyarray.o
  CC       /tmp/build/perf/util/cpumap.o
  CC       /tmp/build/perf/tests/thread-mg-share.o
  CC       /tmp/build/perf/tests/switch-tracking.o
  CC       /tmp/build/perf/tests/keep-tracking.o
  CC       /tmp/build/perf/tests/code-reading.o
  CC       /tmp/build/perf/util/cgroup.o
  CC       /tmp/build/perf/tests/sample-parsing.o
  CC       /tmp/build/perf/util/target.o
  CC       /tmp/build/perf/tests/parse-no-sample-id-all.o
  CC       /tmp/build/perf/util/rblist.o
  CC       /tmp/build/perf/util/intlist.o
  CC       /tmp/build/perf/util/vdso.o
  CC       /tmp/build/perf/tests/kmod-path.o
  CC       /tmp/build/perf/tests/thread-map.o
  CC       /tmp/build/perf/util/counts.o
  CC       /tmp/build/perf/util/stat.o
  CC       /tmp/build/perf/util/stat-shadow.o
  CC       /tmp/build/perf/tests/llvm.o
  CC       /tmp/build/perf/util/record.o
  CC       /tmp/build/perf/util/srcline.o
  CC       /tmp/build/perf/tests/bpf.o
  CC       /tmp/build/perf/tests/topology.o
  CC       /tmp/build/perf/util/data.o
  CC       /tmp/build/perf/util/tsc.o
  CC       /tmp/build/perf/util/cloexec.o
  CC       /tmp/build/perf/util/call-path.o
  CC       /tmp/build/perf/util/rwsem.o
  CC       /tmp/build/perf/tests/mem.o
  CC       /tmp/build/perf/util/thread-stack.o
  CC       /tmp/build/perf/util/auxtrace.o
  MKDIR    /tmp/build/perf/util/intel-pt-decoder/
  CC       /tmp/build/perf/tests/cpumap.o
  CC       /tmp/build/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.o
  CC       /tmp/build/perf/tests/stat.o
  MKDIR    /tmp/build/perf/util/intel-pt-decoder/
  GEN      /tmp/build/perf/util/intel-pt-decoder/inat-tables.c
  CC       /tmp/build/perf/util/intel-pt-decoder/intel-pt-log.o
  MKDIR    /tmp/build/perf/util/scripting-engines/
  CC       /tmp/build/perf/util/scripting-engines/trace-event-perl.o
  CC       /tmp/build/perf/tests/event_update.o
  CC       /tmp/build/perf/util/intel-pt-decoder/intel-pt-decoder.o
  CC       /tmp/build/perf/tests/event-times.o
  CC       /tmp/build/perf/util/intel-pt.o
  LD       /tmp/build/perf/util/scripting-engines/libperf-in.o
  CC       /tmp/build/perf/tests/expr.o
  CC       /tmp/build/perf/util/intel-bts.o
  CC       /tmp/build/perf/tests/backward-ring-buffer.o
  CC       /tmp/build/perf/util/intel-pt-decoder/intel-pt-insn-decoder.o
  CC       /tmp/build/perf/tests/sdt.o
  CC       /tmp/build/perf/tests/is_printable_array.o
  CC       /tmp/build/perf/util/arm-spe.o
  CC       /tmp/build/perf/tests/bitmap.o
  LD       /tmp/build/perf/util/intel-pt-decoder/libperf-in.o
  CC       /tmp/build/perf/util/arm-spe-pkt-decoder.o
  CC       /tmp/build/perf/tests/perf-hooks.o
  CC       /tmp/build/perf/util/s390-cpumsf.o
  CC       /tmp/build/perf/util/parse-branch-options.o
  CC       /tmp/build/perf/util/dump-insn.o
  CC       /tmp/build/perf/util/parse-regs-options.o
  CC       /tmp/build/perf/tests/clang.o
  CC       /tmp/build/perf/util/term.o
  CC       /tmp/build/perf/util/help-unknown-cmd.o
  CC       /tmp/build/perf/util/mem-events.o
  CC       /tmp/build/perf/tests/unit_number__scnprintf.o
  CC       /tmp/build/perf/tests/mem2node.o
  CC       /tmp/build/perf/util/vsprintf.o
  CC       /tmp/build/perf/util/drv_configs.o
  CC       /tmp/build/perf/util/units.o
  CC       /tmp/build/perf/tests/llvm-src-base.o
  CC       /tmp/build/perf/util/time-utils.o
  BISON    /tmp/build/perf/util/expr-bison.c
  CC       /tmp/build/perf/util/branch.o
  CC       /tmp/build/perf/tests/llvm-src-kbuild.o
  CC       /tmp/build/perf/util/mem2node.o
  CC       /tmp/build/perf/tests/llvm-src-prologue.o
  CC       /tmp/build/perf/tests/llvm-src-relocation.o
  CC       /tmp/build/perf/util/symbol-minimal.o
  CC       /tmp/build/perf/util/zlib.o
  CC       /tmp/build/perf/util/demangle-java.o
  LD       /tmp/build/perf/tests/perf-in.o
  LD       /tmp/build/perf/perf-in.o
  CC       /tmp/build/perf/util/demangle-rust.o
  CC       /tmp/build/perf/util/perf-hooks.o
  FLEX     /tmp/build/perf/util/parse-events-flex.c
  FLEX     /tmp/build/perf/util/pmu-flex.c
  CC       /tmp/build/perf/util/pmu-bison.o
  CC       /tmp/build/perf/util/expr-bison.o
  CC       /tmp/build/perf/util/parse-events.o
  CC       /tmp/build/perf/util/parse-events-flex.o
  CC       /tmp/build/perf/util/pmu.o
  CC       /tmp/build/perf/util/pmu-flex.o
  LD       /tmp/build/perf/util/libperf-in.o
  LD       /tmp/build/perf/libperf-in.o
  AR       /tmp/build/perf/libperf.a
  LINK     /tmp/build/perf/perf
make: Leaving directory '/git/perf/tools/perf'
root@28864dcfe31b /git/perf # 
