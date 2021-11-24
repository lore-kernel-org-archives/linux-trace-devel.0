Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297CEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbhKXWPB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234403AbhKXWPB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:15:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8CAB60E08;
        Wed, 24 Nov 2021 22:11:49 +0000 (UTC)
Date:   Wed, 24 Nov 2021 17:11:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V7 00/14] RTLA: An interface for osnoise/timerlat
 tracers
Message-ID: <20211124171148.1530418d@gandalf.local.home>
In-Reply-To: <cover.1635535309.git.bristot@kernel.org>
References: <cover.1635535309.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 Oct 2021 21:26:03 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> The rtla(1) is a meta-tool that includes a set of commands that
> aims to analyze the real-time properties of Linux. But instead of
> testing Linux as a black box, rtla leverages kernel tracing
> capabilities to provide precise information about the properties
> and root causes of unexpected results.
> 
> To start, it presents an interface to the osnoise and timerlat tracers.
> In the future, it will also serve as home to the rtsl [1] and other
> latency/noise tracers.
> 
> If you just want to run it, you can download the tarball here:
>   - https://bristot.me/files/rtla/tarball/rtla-0.3.tar.bz2
> 
> To compile rtla on fedora you need:
>   $ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git
>   $ cd libtraceevent/
>   $ make
>   $ sudo make install
>   $ cd ..
>   $ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git
>   $ cd libtracefs/
>   $ make
>   $ sudo make install
>   $ cd ..
>   $ sudo dnf install python3-docutils procps-devel
>   $ cd $rtla_src
>   $ make
>   $ sudo make install

Add a README to the above, so that people will know what dependencies there
are.

Thanks!

-- Steve


> 
> The tracing option (-t) depends some kernel patches that are
> available at [2].
> 
> This tool was be discussed at the RT-MC during LPC2021 [3]
> 
> [1] rtsl: https://github.com/bristot/rtsl/
> [2] https://lore.kernel.org/lkml/cover.1635533292.git.bristot@kernel.org/
> [3] https://youtu.be/cZUzc0U1jJ4
> 
> Changes from v6:
>   - Revisited osnoise option config functions
>   - Properly handles offline CPUs
>   - Some cleanups
>   - Fixed an histogram allocation problem (Tao Zhou)
>   - Revisited open()/read()/write() (Tao Zhou)
> Changes from v5:
>   - Fix retval check in save_trace_to_file() (Tao Zhou)
>   - Fix goto logic in save_trace_to_file() (Tao Zhou)
>   - Removed unused save_trace_pipe_to_file() function
>   - Correctly handle an error on osnoise_set_* functions during
>     "apply config" for all tools (Tao Zhou)
> Changes from v3:
>   - Add cross-compile support (Ahmed S. Darwish)
>   - Move documentation to Documentation/tools/rtla (Jonathan Corbet)
>   - Use .rst format for documentation (Jonathan Corbet)
>   - Use include option from .rst to group common parts of the documentation
>   - Makefile (main and doc) cleanups
> Changes from v2:
>   - Fix the miss conception of the "size" for kernel histograms (Steven/Tom)
>   - Change the --skip-zeros to --with-zeros option as the former is better
>     for humans (and the latter for computers to plot charts).
>   - A lot of checkpatch fixes for the user-space part.
> Changes from v1:
>   - Fixes -t options on osnoise tracers (-t means --trace for all tools now)
>   - Fixes --bucket-size references (not --bucket_size)
> 
> Daniel Bristot de Oliveira (14):
>   rtla: Real-Time Linux Analysis tool
>   rtla: Helper functions for rtla
>   rtla: Add osnoise tool
>   rtla/osnoise: Add osnoise top mode
>   rtla/osnoise: Add the hist mode
>   rtla: Add timerlat tool and timelart top mode
>   rtla/timerlat: Add timerlat hist mode
>   rtla: Add Documentation
>   rtla: Add rtla osnoise man page
>   rtla: Add rtla osnoise top documentation
>   rtla: Add rtla osnoise hist documentation
>   rtla: Add rtla timerlat documentation
>   rtla: Add rtla timerlat top documentation
>   rtla: Add rtla timerlat hist documentation
> 
>  Documentation/tools/rtla/Makefile             |   41 +
>  Documentation/tools/rtla/common_appendix.rst  |   12 +
>  .../tools/rtla/common_hist_options.rst        |   23 +
>  Documentation/tools/rtla/common_options.rst   |   24 +
>  .../tools/rtla/common_osnoise_description.rst |    8 +
>  .../tools/rtla/common_osnoise_options.rst     |   17 +
>  .../rtla/common_timerlat_description.rst      |   10 +
>  .../tools/rtla/common_timerlat_options.rst    |   16 +
>  .../tools/rtla/common_top_options.rst         |    3 +
>  .../tools/rtla/rtla-osnoise-hist.rst          |   66 ++
>  Documentation/tools/rtla/rtla-osnoise-top.rst |   61 +
>  Documentation/tools/rtla/rtla-osnoise.rst     |   59 +
>  .../tools/rtla/rtla-timerlat-hist.rst         |  106 ++
>  .../tools/rtla/rtla-timerlat-top.rst          |  145 +++
>  Documentation/tools/rtla/rtla-timerlat.rst    |   57 +
>  Documentation/tools/rtla/rtla.rst             |   48 +
>  tools/tracing/rtla/Makefile                   |  102 ++
>  tools/tracing/rtla/src/osnoise.c              | 1017 +++++++++++++++++
>  tools/tracing/rtla/src/osnoise.h              |   96 ++
>  tools/tracing/rtla/src/osnoise_hist.c         |  799 +++++++++++++
>  tools/tracing/rtla/src/osnoise_top.c          |  577 ++++++++++
>  tools/tracing/rtla/src/rtla.c                 |   87 ++
>  tools/tracing/rtla/src/timerlat.c             |   72 ++
>  tools/tracing/rtla/src/timerlat.h             |    4 +
>  tools/tracing/rtla/src/timerlat_hist.c        |  820 +++++++++++++
>  tools/tracing/rtla/src/timerlat_top.c         |  615 ++++++++++
>  tools/tracing/rtla/src/trace.c                |  192 ++++
>  tools/tracing/rtla/src/trace.h                |   27 +
>  tools/tracing/rtla/src/utils.c                |  433 +++++++
>  tools/tracing/rtla/src/utils.h                |   56 +
>  30 files changed, 5593 insertions(+)
>  create mode 100644 Documentation/tools/rtla/Makefile
>  create mode 100644 Documentation/tools/rtla/common_appendix.rst
>  create mode 100644 Documentation/tools/rtla/common_hist_options.rst
>  create mode 100644 Documentation/tools/rtla/common_options.rst
>  create mode 100644 Documentation/tools/rtla/common_osnoise_description.rst
>  create mode 100644 Documentation/tools/rtla/common_osnoise_options.rst
>  create mode 100644 Documentation/tools/rtla/common_timerlat_description.rst
>  create mode 100644 Documentation/tools/rtla/common_timerlat_options.rst
>  create mode 100644 Documentation/tools/rtla/common_top_options.rst
>  create mode 100644 Documentation/tools/rtla/rtla-osnoise-hist.rst
>  create mode 100644 Documentation/tools/rtla/rtla-osnoise-top.rst
>  create mode 100644 Documentation/tools/rtla/rtla-osnoise.rst
>  create mode 100644 Documentation/tools/rtla/rtla-timerlat-hist.rst
>  create mode 100644 Documentation/tools/rtla/rtla-timerlat-top.rst
>  create mode 100644 Documentation/tools/rtla/rtla-timerlat.rst
>  create mode 100644 Documentation/tools/rtla/rtla.rst
>  create mode 100644 tools/tracing/rtla/Makefile
>  create mode 100644 tools/tracing/rtla/src/osnoise.c
>  create mode 100644 tools/tracing/rtla/src/osnoise.h
>  create mode 100644 tools/tracing/rtla/src/osnoise_hist.c
>  create mode 100644 tools/tracing/rtla/src/osnoise_top.c
>  create mode 100644 tools/tracing/rtla/src/rtla.c
>  create mode 100644 tools/tracing/rtla/src/timerlat.c
>  create mode 100644 tools/tracing/rtla/src/timerlat.h
>  create mode 100644 tools/tracing/rtla/src/timerlat_hist.c
>  create mode 100644 tools/tracing/rtla/src/timerlat_top.c
>  create mode 100644 tools/tracing/rtla/src/trace.c
>  create mode 100644 tools/tracing/rtla/src/trace.h
>  create mode 100644 tools/tracing/rtla/src/utils.c
>  create mode 100644 tools/tracing/rtla/src/utils.h
> 

