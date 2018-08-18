Return-Path: <SRS0=G/w4=LB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55181 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbeHROYl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 18 Aug 2018 10:24:41 -0400
Date: Sat, 18 Aug 2018 13:17:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Kapshuk <alexander.kapshuk@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Benno Evers <bevers@mesosphere.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Dongjiu Geng <gengdongjiu@huawei.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kim Phillips <kim.phillips@arm.com>,
        Krister Johansen <kjlx@templeofstupid.com>,
        linux-trace-devel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Wang Nan <wangnan0@huawei.com>, x86@kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [GIT PULL 00/35] perf/core improvements and fixes
Message-ID: <20180818111718.GA19187@gmail.com>
References: <20180815150611.32080-1-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180815150611.32080-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling, this is on top of
> perf-core-for-mingo-4.19-20180809, that is not yet in tip.
> 
> Thanks,
> 
> - Arnaldo
> 
> Test results at the end of this message, as usual.
> 
> The following changes since commit 6a9405b56c274024564f9014bba97b92c91b34d6:
> 
>   perf map: Optimize maps__fixup_overlappings() (2018-08-08 15:56:00 -0300)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo-4.19-20180815
> 
> for you to fetch changes up to 6855dc41b24619c3d1de3dbd27dd0546b0e45272:
> 
>   x86: Add entry trampolines to kcore (2018-08-14 19:13:26 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements ad fixes:
> 
> kernel:
> 
> . kallsyms, x86: Export addresses of PTI entry trampolines (Alexander Shishkin)
> 
> . kallsyms: Simplify update_iter_mod() (Adrian Hunter)
> 
> . x86: Add entry trampolines to kcore (Adrian Hunter)
> 
> Hardware tracing:
> 
> . Fix auxtrace queue resize (Adrian Hunter)
> 
> Arch specific:
> 
> . Fix uninitialized ARM SPE record error variable (Kim Phillips)
> 
> . Fix trace event post-processing in powerpc (Sandipan Das)
> 
> Build:
> 
> . Fix check-headers.sh AND list path of execution (Alexander Kapshuk)
> 
> . Remove -mcet and -fcf-protection when building the python binding
>   with older clang versions (Arnaldo Carvalho de Melo)
> 
> . Make check-headers.sh check based on kernel dir (Jiri Olsa)
> 
> . Move syscall_64.tbl check into check-headers.sh (Jiri Olsa)
> 
> Infrastructure:
> 
> . Check for null when copying nsinfo.  (Benno Evers)
> 
> Libraries:
> 
> . Rename libtraceevent prefixes, prep work for making it a shared
>   library generaly available (Tzvetomir Stoyanov (VMware))
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (3):
>       perf auxtrace: Fix queue resize
>       kallsyms: Simplify update_iter_mod()
>       x86: Add entry trampolines to kcore
> 
> Alexander Kapshuk (1):
>       perf tools: Fix check-headers.sh AND list path of execution
> 
> Alexander Shishkin (1):
>       kallsyms, x86: Export addresses of PTI entry trampolines
> 
> Arnaldo Carvalho de Melo (1):
>       perf python: Remove -mcet and -fcf-protection when building with clang
> 
> Benno Evers (1):
>       perf tools: Check for null when copying nsinfo.
> 
> Jiri Olsa (2):
>       perf tools: Make check-headers.sh check based on kernel dir
>       perf tools: Move syscall_64.tbl check into check-headers.sh
> 
> Kim Phillips (1):
>       perf arm spe: Fix uninitialized record error variable
> 
> Sandipan Das (1):
>       perf probe powerpc: Fix trace event post-processing
> 
> Tzvetomir Stoyanov (VMware) (24):
>       tools lib traceevent, perf tools: Rename struct pevent to struct tep_handle
>       tools lib traceevent, perf tools: Rename 'struct pevent_record' to 'struct tep_record'
>       tools lib traceevent, perf tools: Rename pevent plugin related APIs
>       tools lib traceevent, perf tools: Rename pevent alloc / free APIs
>       tools lib traceevent, perf tools: Rename pevent find APIs
>       tools lib traceevent, perf tools: Rename pevent parse APIs
>       tools lib traceevent, perf tools: Rename pevent print APIs
>       tools lib traceevent, perf tools: Rename pevent_read_number_* APIs
>       tools lib traceevent, perf tools: Rename pevent_register_* APIs
>       tools lib traceevent, perf tools: Rename pevent_set_* APIs
>       tools lib traceevent, perf tools: Rename traceevent_* APIs
>       tools lib traceevent, perf tools: Rename 'enum pevent_flag' to 'enum tep_flag'
>       tools lib traceevent, tools lib lockdep: Rename 'enum pevent_errno' to 'enum tep_errno'
>       tools lib traceevent: Rename pevent_function* APIs
>       tools lib traceevent,  perf tools: Rename traceevent_plugin_* APIs
>       tools lib traceevent: Rename pevent_filter* APIs
>       tools lib traceevent: Rename pevent_register / unregister APIs
>       tools lib traceevent: Rename pevent_data_ APIs
>       tools lib traceevent: Rename pevent field APIs
>       tools lib traceevent: Rename pevent_find_* APIs
>       tools lib traceevent: Rename various pevent get/set/is APIs
>       tools lib traceevent: Rename internal parser related APIs
>       tools lib traceevent: Rename various pevent APIs
>       tools lib traceevent: Rename static variables and functions in event-parse.c
> 
>  arch/x86/mm/cpu_entry_area.c                       |  33 +
>  fs/proc/kcore.c                                    |   7 +-
>  include/linux/kcore.h                              |  13 +
>  kernel/kallsyms.c                                  |  51 +-
>  tools/lib/lockdep/Makefile                         |   4 +-
>  tools/lib/traceevent/Makefile                      |   4 +-
>  tools/lib/traceevent/event-parse.c                 | 696 ++++++++++-----------
>  tools/lib/traceevent/event-parse.h                 | 458 +++++++-------
>  tools/lib/traceevent/event-plugin.c                |  70 +--
>  tools/lib/traceevent/parse-filter.c                | 288 ++++-----
>  tools/lib/traceevent/plugin_cfg80211.c             |  20 +-
>  tools/lib/traceevent/plugin_function.c             |  34 +-
>  tools/lib/traceevent/plugin_hrtimer.c              |  56 +-
>  tools/lib/traceevent/plugin_jbd2.c                 |  36 +-
>  tools/lib/traceevent/plugin_kmem.c                 |  66 +-
>  tools/lib/traceevent/plugin_kvm.c                  | 154 ++---
>  tools/lib/traceevent/plugin_mac80211.c             |  28 +-
>  tools/lib/traceevent/plugin_sched_switch.c         |  60 +-
>  tools/lib/traceevent/plugin_scsi.c                 |  24 +-
>  tools/lib/traceevent/plugin_xen.c                  |  20 +-
>  tools/perf/arch/arm64/util/arm-spe.c               |   1 +
>  tools/perf/arch/powerpc/util/sym-handling.c        |   4 +-
>  tools/perf/arch/x86/Makefile                       |   3 -
>  tools/perf/builtin-kmem.c                          |   6 +-
>  tools/perf/builtin-report.c                        |   6 +-
>  tools/perf/builtin-script.c                        |   6 +-
>  tools/perf/check-headers.sh                        |  17 +-
>  tools/perf/util/auxtrace.c                         |   3 +
>  tools/perf/util/data-convert-bt.c                  |   6 +-
>  tools/perf/util/evsel.c                            |   2 +-
>  tools/perf/util/header.c                           |   6 +-
>  tools/perf/util/machine.h                          |   2 +-
>  tools/perf/util/namespaces.c                       |   3 +
>  tools/perf/util/python.c                           |  10 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |   2 +-
>  .../util/scripting-engines/trace-event-python.c    |   6 +-
>  tools/perf/util/setup.py                           |  10 +-
>  tools/perf/util/sort.c                             |  16 +-
>  tools/perf/util/sort.h                             |   2 +-
>  tools/perf/util/trace-event-parse.c                |  34 +-
>  tools/perf/util/trace-event-read.c                 |  44 +-
>  tools/perf/util/trace-event-scripting.c            |   4 +-
>  tools/perf/util/trace-event.c                      |  28 +-
>  tools/perf/util/trace-event.h                      |  20 +-
>  44 files changed, 1230 insertions(+), 1133 deletions(-)

Pulled into perf/urgent, thanks a lot Arnaldo!

	Ingo
