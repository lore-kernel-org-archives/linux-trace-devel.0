Return-Path: <SRS0=LhtG=MV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36889 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbeJIMkG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Oct 2018 08:40:06 -0400
Date: Tue, 9 Oct 2018 07:24:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        David Ahern <dsahern@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux trace devel <linux-trace-devel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Sanskriti Sharma <sansharm@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/12] perf/core improvements and fixes
Message-ID: <20181009052452.GA104386@gmail.com>
References: <20181009005427.6607-1-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009005427.6607-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> Test results at the end of this message, as usual.
> 
> The following changes since commit 7c5314b88da6d5af98239786772a1c44cc5eb67d:
> 
>   perf/x86/intel: Add quirk for Goldmont Plus (2018-10-02 10:14:33 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo-4.20-20181008
> 
> for you to fetch changes up to bb3dd7e7c4d5e024d607c0ec06c2a2fb9408cc99:
> 
>   tools lib traceevent, perf tools: Move struct tep_handler definition in a local header file (2018-10-08 15:05:37 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Fix building the python bindings with python3, which fixes some
>   problems with building with clang on Clear Linux (Eduardo Habkost)
> 
> . Fix coverity warnings, fixing up some error paths and plugging
>   some temporary small buffer leaks (Sanskriti Sharma)
> 
> . Adopt a wrapper for strerror_r() for the same reasons as recently
>   for libbpf (Steven Rostedt)
> 
> . S390 does not support watchpoints in 'perf test 22', check if
>   that test is supported by the arch. (Thomas Richter)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (2):
>       tools include: Adopt linux/bits.h
>       perf auxtrace: Include missing asm/bitsperlong.h to get BITS_PER_LONG
> 
> Eduardo Habkost (2):
>       perf python: Make clang_has_option() work on Python 3
>       perf python: More portable way to make CFLAGS work with clang
> 
> Sanskriti Sharma (5):
>       perf strbuf: Match va_{add,copy} with va_end
>       perf tools: Cleanup trace-event-info 'tdata' leak
>       perf tools: Free 'printk' string in parse_ftrace_printk()
>       perf tools: Avoid double free in read_event_file()
>       perf tools: Free temporary 'sys' string in read_event_files()
> 
> Steven Rostedt (VMware) (1):
>       tools lib traceevent: Separate out tep_strerror() for strerror_r() issues
> 
> Thomas Richter (1):
>       perf test: S390 does not support watchpoints in test 22
> 
> Tzvetomir Stoyanov (1):
>       tools lib traceevent, perf tools: Move struct tep_handler definition in a local header file
> 
>  tools/include/linux/bitops.h             |   7 +-
>  tools/include/linux/bits.h               |  26 +++
>  tools/lib/traceevent/Build               |   2 +
>  tools/lib/traceevent/event-parse-api.c   | 275 +++++++++++++++++++++++++++++++
>  tools/lib/traceevent/event-parse-local.h |  92 +++++++++++
>  tools/lib/traceevent/event-parse.c       |  32 +---
>  tools/lib/traceevent/event-parse.h       | 228 ++++---------------------
>  tools/lib/traceevent/event-plugin.c      |   1 +
>  tools/lib/traceevent/parse-filter.c      |   1 +
>  tools/lib/traceevent/tep_strerror.c      |  53 ++++++
>  tools/perf/check-headers.sh              |   1 +
>  tools/perf/tests/builtin-test.c          |   1 +
>  tools/perf/tests/tests.h                 |   1 +
>  tools/perf/tests/wp.c                    |  12 ++
>  tools/perf/util/auxtrace.h               |   1 +
>  tools/perf/util/setup.py                 |  16 +-
>  tools/perf/util/strbuf.c                 |  10 +-
>  tools/perf/util/trace-event-info.c       |   2 +
>  tools/perf/util/trace-event-parse.c      |  26 +--
>  tools/perf/util/trace-event-read.c       |  11 +-
>  20 files changed, 539 insertions(+), 259 deletions(-)
>  create mode 100644 tools/include/linux/bits.h
>  create mode 100644 tools/lib/traceevent/event-parse-api.c
>  create mode 100644 tools/lib/traceevent/event-parse-local.h
>  create mode 100644 tools/lib/traceevent/tep_strerror.c

Pulled, thanks a lot Arnaldo!

	Ingo
