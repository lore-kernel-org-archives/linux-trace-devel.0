Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCACC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 01:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C78660FBF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 01:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhJZBLJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 21:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232679AbhJZBLJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 21:11:09 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C233860ED4;
        Tue, 26 Oct 2021 01:08:44 +0000 (UTC)
Date:   Mon, 25 Oct 2021 21:08:43 -0400
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
Subject: Re: [PATCH V5 04/20] trace/osnoise: Use
 start/stop_per_cpu_kthreads() on osnoise_cpus_write()
Message-ID: <20211025210843.36fe2829@rorschach.local.home>
In-Reply-To: <2b4ea45b1802844cffd98b6a208b22bc4664c795.1635181938.git.bristot@kernel.org>
References: <cover.1635181938.git.bristot@kernel.org>
        <2b4ea45b1802844cffd98b6a208b22bc4664c795.1635181938.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Oct 2021 19:40:29 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> When writing a new CPU mask via osnoise/cpus, if the tracer is running,
> the workload is restarted to follow the new cpumask. The restart is
> currently done using osnoise_workload_start/stop(), which disables the
> workload *and* the instrumentation. However, disabling the
> instrumentation is not necessary.
> 
> Calling start/stop_per_cpu_kthreads() is enough to apply the new
> osnoise/cpus config.
> 
> No functional change.

I nuked the "No functional change.". You can't have the changes of the
above and say there wasn't functional changes, as the first paragraph
explains the functional changes.

-- Steve
