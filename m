Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B54C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 22:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232F664F07
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 22:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhCOWAB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 18:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbhCOV7g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 17:59:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE16A64F4D;
        Mon, 15 Mar 2021 21:59:35 +0000 (UTC)
Date:   Mon, 15 Mar 2021 17:59:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 01/12] trace-cmd: Add initial perf interface in
 trace-cmd library
Message-ID: <20210315175934.685e7d96@gandalf.local.home>
In-Reply-To: <20210315061832.168495-2-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
        <20210315061832.168495-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Mar 2021 08:18:21 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static void default_perf_init_pe(struct perf_event_attr *pe)
> +{
> +	pe->type = PERF_TYPE_SOFTWARE;
> +	pe->sample_type = PERF_SAMPLE_CPU;
> +	pe->size = sizeof(struct perf_event_attr);
> +	pe->config = PERF_COUNT_HW_CPU_CYCLES;
> +	pe->disabled = 1;
> +	pe->exclude_kernel = 1;
> +	pe->freq = 1;
> +	pe->sample_freq = 1000;
> +	pe->inherit = 1;
> +	pe->mmap = 1;
> +	pe->comm = 1;
> +	pe->task = 1;
> +	pe->precise_ip = 1;
> +	pe->sample_id_all = 1;

I tried to compile this on an old system and it fails to compile. We'll
need to add a compile time check if the perf functions are supported by the
user space, as trace-cmd should still build on these systems.

  COMPILE FPIC           trace-perf.o
trace-perf.c: In function ‘default_perf_init_pe’:
trace-perf.c:26: error: ‘struct perf_event_attr’ has no member named ‘precise_ip’
trace-perf.c:27: error: ‘struct perf_event_attr’ has no member named ‘sample_id_all’
make[1]: *** [/work/git/trace-cmd.git/lib/trace-cmd/trace-perf.o] Error 1


-- Steve


> +	pe->read_format = PERF_FORMAT_ID |
> +			PERF_FORMAT_TOTAL_TIME_ENABLED |
> +			PERF_FORMAT_TOTAL_TIME_RUNNING;
> +}
