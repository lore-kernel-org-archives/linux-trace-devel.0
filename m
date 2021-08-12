Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB72C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30BC86023D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhHLOUJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:20:09 -0400
Received: from gateway31.websitewelcome.com ([192.185.144.219]:48011 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhHLOUJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 10:20:09 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Aug 2021 10:20:09 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id DF4AC170658
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 08:57:34 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id EBDCmS5LpjSwzEBDCmmZqQ; Thu, 12 Aug 2021 08:57:34 -0500
X-Authority-Reason: nr=8
Received: from host-79-56-204-120.retail.telecomitalia.it ([79.56.204.120]:54910 helo=f34.bristot.me)
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mEBDC-004IPl-1D; Thu, 12 Aug 2021 08:57:34 -0500
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] osnoise: Support multiple instances
Date:   Thu, 12 Aug 2021 15:57:19 +0200
Message-Id: <cover.1628775552.git.bristot@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.56.204.120
X-Source-L: No
X-Exim-ID: 1mEBDC-004IPl-1D
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-56-204-120.retail.telecomitalia.it (f34.bristot.me) [79.56.204.120]:54910
X-Source-Auth: kernel@bristot.me
X-Email-Count: 1
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, osnoise and timerlat run only on a single instance. To reduce
this limitation, this series adds support for parallel instances of the
same tracer. That is, it is possible to run two instances of osnoise
tracer with different configurations. For example, one for the tracer
output and another for a set of tracepoints.

Daniel Bristot de Oliveira (5):
  trace/osnoise: Do not follow tracing_cpumask
  trace/osnoise: Split workload start from the tracer start
  trace/osnoise: Use start/stop_per_cpu_kthreads() on
    osnoise_cpus_write()
  trace/osnoise: Support a list of trace_array *tr
  trace/osnoise: Allow multiple instances of the same tracer

 kernel/trace/trace_osnoise.c | 410 ++++++++++++++++++++++++-----------
 1 file changed, 289 insertions(+), 121 deletions(-)

-- 
2.31.1

