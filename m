Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AC0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C4CA61056
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhJ1VdL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:33:11 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:56222 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231346AbhJ1VdL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 17:33:11 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-w4-jIuYlNyyPbjvm_V_nXQ-1; Thu, 28 Oct 2021 17:30:40 -0400
X-MC-Unique: w4-jIuYlNyyPbjvm_V_nXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5096F5B378;
        Thu, 28 Oct 2021 21:30:38 +0000 (UTC)
Received: from x1.com (unknown [10.22.32.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3560100EBBE;
        Thu, 28 Oct 2021 21:29:52 +0000 (UTC)
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
Subject: [PATCH V7 0/9] osnoise: Support multiple instances (for RTLA)
Date:   Thu, 28 Oct 2021 23:29:28 +0200
Message-Id: <cover.1635452903.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, osnoise and timerlat run only on a single instance only. To lift
this limitation, this series adds support for parallel instances of the
same tracer. For example, making it possible to run one osnoise instance
for the tracer output and another for a set of tracepoints.

This patchset is the kernel dependencies for RTLA. It was
being sent along with RTLA [1], but we split the kernel and
user-space patch sets.

Steve, feel free to drop the last two if they break anything.

[1] RTLA: An interface for osnoise/timerlat tracers:
    https://lore.kernel.org/lkml/cover.1635284863.git.bristot@kernel.org/

Changes from v6:
  - Fix compilation problems for the case in which osnoise
    enabled, but timerlat is not (Steven)
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
  trace/osnoise: Do not follow tracing_cpumask
  trace/osnoise: Improve comments about barrier need for NMI callbacks
  trace/osnoise: Split workload start from the tracer start
  trace/osnoise: Use start/stop_per_cpu_kthreads() on
    osnoise_cpus_write()
  trace/osnoise: Support a list of trace_array *tr
  trace/osnoise: Remove TIMERLAT ifdefs from inside functions
  trace/osnoise: Allow multiple instances of the same tracer
  trace/osnoise: Remove STACKTRACE ifdefs from inside functions
  trace/osnoise: Remove PREEMPT_RT ifdefs from inside functions

 kernel/trace/trace_osnoise.c | 607 ++++++++++++++++++++++++-----------
 1 file changed, 424 insertions(+), 183 deletions(-)

-- 
2.31.1

