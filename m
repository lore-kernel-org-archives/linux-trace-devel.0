Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E0BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Oct 2021 12:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA6861186
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Oct 2021 12:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhJUM7x convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Oct 2021 08:59:53 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:32860 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230231AbhJUM7w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 08:59:52 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-xtNcsKUmNemJVp8AlK_DUA-1; Thu, 21 Oct 2021 08:57:32 -0400
X-MC-Unique: xtNcsKUmNemJVp8AlK_DUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08836100CD43;
        Thu, 21 Oct 2021 12:57:31 +0000 (UTC)
Received: from x1.com (unknown [10.22.34.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C63F108A1;
        Thu, 21 Oct 2021 12:57:02 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
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
Subject: [PATCH V4 00/19] RTLA: An interface for osnoise/timerlat tracers
Date:   Thu, 21 Oct 2021 14:56:38 +0200
Message-Id: <cover.1634820694.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The rtla(1) is a meta-tool that includes a set of commands that
aims to analyze the real-time properties of Linux. But instead of
testing Linux as a black box, rtla leverages kernel tracing
capabilities to provide precise information about the properties
and root causes of unexpected results.

To start, it presents an interface to the osnoise and timerlat tracers.
In the future, it will also serve as home to the rtsl [1] and other
latency/noise tracers.

The first five patches are a re-send of [2] that enable multiple
instances for osnoise/timerlat tracers. They are required to run the -T
option - to save a trace with osnoise: events for debugging.

The next seven patches are rtla, rtla osnoise, and rtla timerlat.

The following patches are the man pages for the tools.

To compile rtla on fedora you need:
  $ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git
  $ cd libtraceevent/
  $ make
  $ sudo make install
  $ cd ..
  $ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git
  $ cd libtracefs/
  $ make
  $ sudo make install
  $ cd ..
  $ sudo dnf install python3-docutils procps-devel
  $ cd $linux/tools/tracing/rtla/
  $ make
  $ sudo make install

This tool was be discussed at the RT-MC during LPC2021.

[1] rtsl: https://github.com/bristot/rtsl/
[2] https://lore.kernel.org/lkml/cover.1628775552.git.bristot@kernel.org/
[3] https://youtu.be/cZUzc0U1jJ4

Changes from v3:
  - Add cross-compile support (Ahmed S. Darwish)
  - Move documentation to Documentation/tools/rtla (Jonathan Corbet)
  - Use .rst format for documentation (Jonathan Corbet)
  - Use include option from .rst to group common parts of the documentation
  - Makefile (main and doc) cleanups
Changes from v2:
  - Fix the miss conception of the "size" for kernel histograms (Steven/Tom)
  - Change the --skip-zeros to --with-zeros option as the former is better
    for humans (and the latter for computers to plot charts).
  - A lot of checkpatch fixes for the user-space part.
Changes from v1:
  - Fixes -t options on osnoise tracers (-t means --trace for all tools now)
  - Fixes --bucket-size references (not --bucket_size)

Daniel Bristot de Oliveira (19):
  trace/osnoise: Do not follow tracing_cpumask
  trace/osnoise: Split workload start from the tracer start
  trace/osnoise: Use start/stop_per_cpu_kthreads() on
    osnoise_cpus_write()
  trace/osnoise: Support a list of trace_array *tr
  trace/osnoise: Allow multiple instances of the same tracer
  rtla: Real-Time Linux Analysis tool
  rtla: Helper functions for rtla
  rtla: Add osnoise tool
  rtla/osnoise: Add osnoise top mode
  rtla/osnoise: Add the hist mode
  rtla: Add timerlat tool and timelart top mode
  rtla/timerlat: Add timerlat hist mode
  rtla: Add Documentation
  rtla: Add rtla osnoise man page
  rtla: Add rtla osnoise top documentation
  rtla: Add rtla osnoise hist documentation
  rtla: Add rtla timerlat documentation
  rtla: Add rtla timerlat top documentation
  rtla: Add rtla timerlat hist documentation

 Documentation/tools/rtla/Makefile             |  41 +
 Documentation/tools/rtla/common_appendix.rst  |  12 +
 .../tools/rtla/common_hist_options.rst        |  23 +
 Documentation/tools/rtla/common_options.rst   |  24 +
 .../tools/rtla/common_osnoise_description.rst |   8 +
 .../tools/rtla/common_osnoise_options.rst     |  17 +
 .../rtla/common_timerlat_description.rst      |  10 +
 .../tools/rtla/common_timerlat_options.rst    |  16 +
 .../tools/rtla/common_top_options.rst         |   3 +
 .../tools/rtla/rtla-osnoise-hist.rst          |  66 ++
 Documentation/tools/rtla/rtla-osnoise-top.rst |  61 ++
 Documentation/tools/rtla/rtla-osnoise.rst     |  59 ++
 .../tools/rtla/rtla-timerlat-hist.rst         | 106 +++
 .../tools/rtla/rtla-timerlat-top.rst          | 145 +++
 Documentation/tools/rtla/rtla-timerlat.rst    |  57 ++
 Documentation/tools/rtla/rtla.rst             |  48 +
 kernel/trace/trace_osnoise.c                  | 410 ++++++---
 tools/tracing/rtla/Makefile                   | 102 +++
 tools/tracing/rtla/src/osnoise.c              | 837 ++++++++++++++++++
 tools/tracing/rtla/src/osnoise.h              |  87 ++
 tools/tracing/rtla/src/osnoise_hist.c         | 783 ++++++++++++++++
 tools/tracing/rtla/src/osnoise_top.c          | 567 ++++++++++++
 tools/tracing/rtla/src/rtla.c                 |  87 ++
 tools/tracing/rtla/src/timerlat.c             |  72 ++
 tools/tracing/rtla/src/timerlat.h             |   4 +
 tools/tracing/rtla/src/timerlat_hist.c        | 780 ++++++++++++++++
 tools/tracing/rtla/src/timerlat_top.c         | 581 ++++++++++++
 tools/tracing/rtla/src/trace.c                | 219 +++++
 tools/tracing/rtla/src/trace.h                |  27 +
 tools/tracing/rtla/src/utils.c                | 433 +++++++++
 tools/tracing/rtla/src/utils.h                |  56 ++
 31 files changed, 5620 insertions(+), 121 deletions(-)
 create mode 100644 Documentation/tools/rtla/Makefile
 create mode 100644 Documentation/tools/rtla/common_appendix.rst
 create mode 100644 Documentation/tools/rtla/common_hist_options.rst
 create mode 100644 Documentation/tools/rtla/common_options.rst
 create mode 100644 Documentation/tools/rtla/common_osnoise_description.rst
 create mode 100644 Documentation/tools/rtla/common_osnoise_options.rst
 create mode 100644 Documentation/tools/rtla/common_timerlat_description.rst
 create mode 100644 Documentation/tools/rtla/common_timerlat_options.rst
 create mode 100644 Documentation/tools/rtla/common_top_options.rst
 create mode 100644 Documentation/tools/rtla/rtla-osnoise-hist.rst
 create mode 100644 Documentation/tools/rtla/rtla-osnoise-top.rst
 create mode 100644 Documentation/tools/rtla/rtla-osnoise.rst
 create mode 100644 Documentation/tools/rtla/rtla-timerlat-hist.rst
 create mode 100644 Documentation/tools/rtla/rtla-timerlat-top.rst
 create mode 100644 Documentation/tools/rtla/rtla-timerlat.rst
 create mode 100644 Documentation/tools/rtla/rtla.rst
 create mode 100644 tools/tracing/rtla/Makefile
 create mode 100644 tools/tracing/rtla/src/osnoise.c
 create mode 100644 tools/tracing/rtla/src/osnoise.h
 create mode 100644 tools/tracing/rtla/src/osnoise_hist.c
 create mode 100644 tools/tracing/rtla/src/osnoise_top.c
 create mode 100644 tools/tracing/rtla/src/rtla.c
 create mode 100644 tools/tracing/rtla/src/timerlat.c
 create mode 100644 tools/tracing/rtla/src/timerlat.h
 create mode 100644 tools/tracing/rtla/src/timerlat_hist.c
 create mode 100644 tools/tracing/rtla/src/timerlat_top.c
 create mode 100644 tools/tracing/rtla/src/trace.c
 create mode 100644 tools/tracing/rtla/src/trace.h
 create mode 100644 tools/tracing/rtla/src/utils.c
 create mode 100644 tools/tracing/rtla/src/utils.h

-- 
2.31.1

