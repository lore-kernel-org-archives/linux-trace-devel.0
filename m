Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7DCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2BF6023F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbhJKOio convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 10:38:44 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:26421 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237679AbhJKOin (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 10:38:43 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-pguFWQECPmaCIue-eAt8vw-1; Mon, 11 Oct 2021 10:36:39 -0400
X-MC-Unique: pguFWQECPmaCIue-eAt8vw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF664112B8C7;
        Mon, 11 Oct 2021 14:36:36 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B76B19C59;
        Mon, 11 Oct 2021 14:36:32 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Kate Carcia <kcarcia@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 00/19] RTLA: An interface for osnoise/timerlat tracers
Date:   Mon, 11 Oct 2021 16:35:48 +0200
Message-Id: <cover.1633958325.git.bristot@kernel.org>
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
  $ sudo dnf install asciidoc xmlto procps-devel
  $ cd $linux/tools/tracing/rtla/
  $ make
  $ sudo make install

This tool was be discussed at the RT-MC during LPC2021 [3].

[1] rtsl: https://github.com/bristot/rtsl/
[2] https://lore.kernel.org/lkml/cover.1628775552.git.bristot@kernel.org/
[3] https://youtu.be/cZUzc0U1jJ4

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

 kernel/trace/trace_osnoise.c                  | 410 ++++++---
 tools/tracing/rtla/Documentation/Makefile     | 223 +++++
 .../tracing/rtla/Documentation/asciidoc.conf  | 118 +++
 .../rtla/Documentation/manpage-base.xsl       |  35 +
 .../rtla/Documentation/manpage-normal.xsl     |  13 +
 .../rtla/Documentation/rtla-osnoise-hist.txt  | 117 +++
 .../rtla/Documentation/rtla-osnoise-top.txt   |  98 ++
 .../rtla/Documentation/rtla-osnoise.txt       |  68 ++
 .../rtla/Documentation/rtla-timerlat-hist.txt | 162 ++++
 .../rtla/Documentation/rtla-timerlat-top.txt  | 181 ++++
 .../rtla/Documentation/rtla-timerlat.txt      |  65 ++
 tools/tracing/rtla/Documentation/rtla.txt     |  56 ++
 tools/tracing/rtla/Documentation/utils.mk     | 144 +++
 tools/tracing/rtla/Makefile                   |  71 ++
 tools/tracing/rtla/src/osnoise.c              | 846 +++++++++++++++++
 tools/tracing/rtla/src/osnoise.h              |  86 ++
 tools/tracing/rtla/src/osnoise_hist.c         | 860 ++++++++++++++++++
 tools/tracing/rtla/src/osnoise_top.c          | 566 ++++++++++++
 tools/tracing/rtla/src/rtla.c                 |  87 ++
 tools/tracing/rtla/src/timerlat.c             |  72 ++
 tools/tracing/rtla/src/timerlat.h             |   3 +
 tools/tracing/rtla/src/timerlat_hist.c        | 778 ++++++++++++++++
 tools/tracing/rtla/src/timerlat_top.c         | 578 ++++++++++++
 tools/tracing/rtla/src/trace.c                | 220 +++++
 tools/tracing/rtla/src/trace.h                |  26 +
 tools/tracing/rtla/src/utils.c                | 433 +++++++++
 tools/tracing/rtla/src/utils.h                |  55 ++
 27 files changed, 6250 insertions(+), 121 deletions(-)
 create mode 100644 tools/tracing/rtla/Documentation/Makefile
 create mode 100644 tools/tracing/rtla/Documentation/asciidoc.conf
 create mode 100644 tools/tracing/rtla/Documentation/manpage-base.xsl
 create mode 100644 tools/tracing/rtla/Documentation/manpage-normal.xsl
 create mode 100644 tools/tracing/rtla/Documentation/rtla-osnoise-hist.txt
 create mode 100644 tools/tracing/rtla/Documentation/rtla-osnoise-top.txt
 create mode 100644 tools/tracing/rtla/Documentation/rtla-osnoise.txt
 create mode 100644 tools/tracing/rtla/Documentation/rtla-timerlat-hist.txt
 create mode 100644 tools/tracing/rtla/Documentation/rtla-timerlat-top.txt
 create mode 100644 tools/tracing/rtla/Documentation/rtla-timerlat.txt
 create mode 100644 tools/tracing/rtla/Documentation/rtla.txt
 create mode 100644 tools/tracing/rtla/Documentation/utils.mk
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

