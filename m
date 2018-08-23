Return-Path: <SRS0=UHVd=LG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53534 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728915AbeHWMAC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Aug 2018 08:00:02 -0400
Date: Thu, 23 Aug 2018 10:31:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Jack Henschel <jackdev@mailbox.org>,
        Jan Beulich <JBeulich@suse.com>,
        Jaroslav =?utf-8?B?xaBrYXJ2YWRh?= <jskarvad@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joe Mario <jmario@redhat.com>,
        linux-trace-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Feiner <pfeiner@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sai Praneeth <sai.praneeth.prakhya@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Wang Nan <wangnan0@huawei.com>, Yonghong Song <yhs@fb.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
Message-ID: <20180823083124.GA10800@gmail.com>
References: <20180820161602.6830-1-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180820161602.6830-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pullimg,
> 
> - Arnaldo
> 
> 
> Test results at the end of this message, as usual.
> 
> The following changes since commit 5804b11034a21e4287daaf017c5ad60ad7af8d67:
> 
>   Merge tag 'perf-core-for-mingo-4.19-20180815' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2018-08-18 13:11:51 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo-4.19-20180820
> 
> for you to fetch changes up to 78303650e4cd873c6c4276c6fe3e768ff0b46d22:
> 
>   tools arch: Update arch/x86/lib/memcpy_64.S copy used in 'perf bench mem memcpy' (2018-08-20 10:17:14 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> LLVM/clang/eBPF: (Arnaldo Carvalho de Melo)
> 
> - Allow passing options to llc in addition to to clang.
> 
> Hardware tracing: (Jack Henschel)
> 
> - Improve error message for PMU address filters, clarifying availability of
>   that feature in hardware having hardware tracing such as Intel PT.
> 
> Python interface: (Jiri Olsa)
> 
> - Fix read_on_cpu() interface.
> 
> ELF/DWARF libraries: (Jiri Olsa)
> 
> - Fix handling of the combo compressed module file + decompressed associated
>   debuginfo file.
> 
> Build (Rasmus Villemoes)
> 
> - Disable parallelism for 'make clean', avoiding multiple submakes deleting
>   the same files and causing the build to fail on systems such as Yocto.
> 
> Kernel ABI copies: (Arnaldo Carvalho de Melo)
> 
> - Update tools's copy of x86's cpufeatures.h.
> 
> - Update arch/x86/lib/memcpy_64.S copy used in 'perf bench mem memcpy'.
> 
> Miscellaneous: (Steven Rostedt)
> 
> - Change libtraceevent to SPDX License format.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (3):
>       perf llvm: Allow passing options to llc in addition to clang
>       tools arch x86: Update tools's copy of cpufeatures.h
>       tools arch: Update arch/x86/lib/memcpy_64.S copy used in 'perf bench mem memcpy'
> 
> Jack Henschel (1):
>       perf parser: Improve error message for PMU address filters
> 
> Jiri Olsa (15):
>       perf tools: Get rid of dso__needs_decompress() call in read_object_code()
>       perf tools: Get rid of dso__needs_decompress() call in symbol__disassemble()
>       perf tools: Get rid of dso__needs_decompress() call in __open_dso()
>       perf tools: Make decompress_to_file() function static
>       perf tools: Make is_supported_compression() static
>       perf tools: Add compression id into 'struct kmod_path'
>       perf tools: Store compression id into struct dso
>       perf tools: Use compression id in decompress_kmodule()
>       perf tools: Move the temp file processing into decompress_kmodule
>       perf tools: Add is_compressed callback to compressions array
>       perf tools: Add lzma_is_compressed function
>       perf tools: Add gzip_is_compressed function
>       perf tools: Remove ext from struct kmod_path
>       perf mmap: Store real cpu number in 'struct perf_mmap'
>       perf python: Fix pyrf_evlist__read_on_cpu() interface
> 
> Rasmus Villemoes (1):
>       perf tools: Disable parallelism for 'make clean'
> 
> Steven Rostedt (VMware) (1):
>       tools lib traceevent: Change to SPDX License format
> 
>  tools/arch/x86/include/asm/cpufeatures.h |   3 +-
>  tools/arch/x86/lib/memcpy_64.S           |   2 +-
>  tools/lib/traceevent/event-parse.c       |  16 +---
>  tools/lib/traceevent/event-plugin.c      |  16 +---
>  tools/lib/traceevent/event-utils.h       |  16 +---
>  tools/lib/traceevent/kbuffer-parse.c     |  17 +---
>  tools/lib/traceevent/parse-filter.c      |  16 +---
>  tools/lib/traceevent/parse-utils.c       |  16 +---
>  tools/lib/traceevent/trace-seq.c         |  16 +---
>  tools/perf/Makefile                      |   4 +-
>  tools/perf/tests/code-reading.c          |   4 +-
>  tools/perf/tests/kmod-path.c             | 136 +++++++++++++++----------------
>  tools/perf/util/annotate.c               |   4 +-
>  tools/perf/util/compress.h               |   2 +
>  tools/perf/util/dso.c                    | 111 ++++++++++++-------------
>  tools/perf/util/dso.h                    |  13 ++-
>  tools/perf/util/evlist.c                 |   2 +-
>  tools/perf/util/llvm-utils.c             |  31 ++++++-
>  tools/perf/util/llvm-utils.h             |   9 ++
>  tools/perf/util/lzma.c                   |  20 +++++
>  tools/perf/util/machine.c                |   4 +-
>  tools/perf/util/mmap.c                   |   3 +-
>  tools/perf/util/mmap.h                   |   3 +-
>  tools/perf/util/parse-events.c           |  20 ++---
>  tools/perf/util/python.c                 |  20 ++++-
>  tools/perf/util/zlib.c                   |  18 ++++
>  26 files changed, 256 insertions(+), 266 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
