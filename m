Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598C4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Oct 2021 02:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3672361038
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Oct 2021 02:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhJWC1i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Oct 2021 22:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhJWC1i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Oct 2021 22:27:38 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B4C36101C;
        Sat, 23 Oct 2021 02:25:18 +0000 (UTC)
Date:   Fri, 22 Oct 2021 22:25:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 02/19] trace/osnoise: Split workload start from the
 tracer start
Message-ID: <20211022222517.744bbca1@rorschach.local.home>
In-Reply-To: <90bfad2bdd348f85b1ff473077de676f75ab445c.1634820694.git.bristot@kernel.org>
References: <cover.1634820694.git.bristot@kernel.org>
        <90bfad2bdd348f85b1ff473077de676f75ab445c.1634820694.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Oct 2021 14:56:40 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> +/*
> + * osnoise_workload_stop - stop the workload and unhook the events
> + */
> +static void osnoise_workload_stop(void)
> +{
> +	if (!osnoise_busy)
> +		return;
> +
> +	trace_osnoise_callback_enabled = false;

I know this is just moving this code, but the original code had this
issue too, but there should be a comment here to why we need the
compiler barrier.

-- Steve


> +	barrier();
> +
> +	stop_per_cpu_kthreads();
> +
> +	unhook_irq_events();
> +	unhook_softirq_events();
> +	unhook_thread_events();
> +
> +	osnoise_busy = false;
> +}
> +
