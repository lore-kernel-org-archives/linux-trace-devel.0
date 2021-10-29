Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BABC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 02:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0140F61179
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 02:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhJ2Cnt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 22:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhJ2Cnn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 22:43:43 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B87B61166;
        Fri, 29 Oct 2021 02:41:13 +0000 (UTC)
Date:   Thu, 28 Oct 2021 22:41:11 -0400
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
Subject: Re: [PATCH V7 0/9] osnoise: Support multiple instances (for RTLA)
Message-ID: <20211028224111.1d8c8bed@rorschach.local.home>
In-Reply-To: <cover.1635452903.git.bristot@kernel.org>
References: <cover.1635452903.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Oct 2021 23:29:28 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> Currently, osnoise and timerlat run only on a single instance only. To lift
> this limitation, this series adds support for parallel instances of the
> same tracer. For example, making it possible to run one osnoise instance
> for the tracer output and another for a set of tracepoints.
> 
> This patchset is the kernel dependencies for RTLA. It was
> being sent along with RTLA [1], but we split the kernel and
> user-space patch sets.
> 
> Steve, feel free to drop the last two if they break anything.
> 
> [1] RTLA: An interface for osnoise/timerlat tracers:
>     https://lore.kernel.org/lkml/cover.1635284863.git.bristot@kernel.org/
> 

Much better.

The only thing I would recommend now, is to write selftests to test
both osnoise and timerlat tracers. Note, this should be a separate
patch set.

-- Steve
