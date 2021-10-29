Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DADC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9A460FF2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJ2TDV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:03:21 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:35040 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbhJ2TDV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 15:03:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-AW6qNnEhMgyS1eYwQiutTw-1; Fri, 29 Oct 2021 15:00:48 -0400
X-MC-Unique: AW6qNnEhMgyS1eYwQiutTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FA341006AA2;
        Fri, 29 Oct 2021 19:00:46 +0000 (UTC)
Received: from x1.com (unknown [10.22.10.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A48255D9CA;
        Fri, 29 Oct 2021 19:00:38 +0000 (UTC)
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
Subject: [PATCH V8 0/9] tracing/osnoise: Support multiple instances (for RTLA)
Date:   Fri, 29 Oct 2021 21:00:26 +0200
Message-Id: <cover.1635533292.git.bristot@kernel.org>
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

Currently, osnoise and timerlat run only on a single instance. To reduce
this limitation, this series adds support for parallel instances of the
same tracer. That is, it is possible to run two instances of osnoise
tracer with different configurations. For example, one for the tracer
output and another for a set of tracepoints.

This patchset is the kernel dependencies for RTLA. This patchset was
being sent along with RTLA [1], but we split the kernel and
user-space patch sets.

[1] RTLA: An interface for osnoise/timerlat tracers:
    https://lore.kernel.org/lkml/cover.1635284863.git.bristot@kernel.org/

Changes from v7:
  - Fix check for print_stack disabled
  - Fix thread/sofitrq filter when TIMERLAT ifdef is enabled
    Both fixes for the patches added in the v6.
Changes from v6:
  - Fix compilation problems for the case in which osnoise
    enabled, but timerlat disabled (Steven)
  - Remove ifdefs from inside functions (Steven)

Changes that happened while in the RTLA patchset:
  - Fix comment on start_per_cpu_kthreads() (Steven)
  - Fix msg log on patch 1
  - Add comments about the barrier need for trace_nmi_enter/exit
  - Fix RCU usage in osnoise_unregister_instance() (Steven/Paul)
  - Add lockdep checks in osnoise_unregister/unregister_instance()
    (Steven/Paul)
  - Improve the explanation about the multi instances support (Steven)


Daniel Bristot de Oliveira (9):
  tracing/osnoise: Do not follow tracing_cpumask
  tracing/osnoise: Improve comments about barrier need for NMI callbacks
  tracing/osnoise: Split workload start from the tracer start
  tracing/osnoise: Use start/stop_per_cpu_kthreads() on
    osnoise_cpus_write()
  tracing/osnoise: Support a list of trace_array *tr
  tracing/osnoise: Remove TIMERLAT ifdefs from inside functions
  tracing/osnoise: Allow multiple instances of the same tracer
  tracing/osnoise: Remove STACKTRACE ifdefs from inside functions
  tracing/osnoise: Remove PREEMPT_RT ifdefs from inside functions

 kernel/trace/trace_osnoise.c | 615 ++++++++++++++++++++++++-----------
 1 file changed, 434 insertions(+), 181 deletions(-)

-- 
2.31.1

