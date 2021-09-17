Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CBCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1DD60E94
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241700AbhIQPqu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:46:50 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:27464 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234037AbhIQPqt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 11:46:49 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-GmwR4cziPhaTXv3B2e0c3Q-1; Fri, 17 Sep 2021 11:45:23 -0400
X-MC-Unique: GmwR4cziPhaTXv3B2e0c3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 519F71084681;
        Fri, 17 Sep 2021 15:45:21 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 141525D9C6;
        Fri, 17 Sep 2021 15:45:01 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Kate Carcia <kcarcia@redhat.com>,
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
Subject: [RFC 00/19] RTLA: An interface for osnoise/timerlat tracers
Date:   Fri, 17 Sep 2021 17:43:43 +0200
Message-Id: <cover.1631889858.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

The next seven patches are rtla, rtla osnoise, and rtla timerlat, and
the following patches are the man pages for the tools.

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

This tool will be discussed at the RT-MC during LPC2021.

RTLA stands for Real-Time Linux Analysis.

[1] rtsl: https://github.com/bristot/rtsl/
[2] https://lore.kernel.org/lkml/cover.1628775552.git.bristot@kernel.org/

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

