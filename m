Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B830C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Oct 2021 02:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C76AB6101C
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Oct 2021 02:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJWCtc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Oct 2021 22:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230230AbhJWCtc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Oct 2021 22:49:32 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A698D60EFE;
        Sat, 23 Oct 2021 02:47:12 +0000 (UTC)
Date:   Fri, 22 Oct 2021 22:47:11 -0400
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
Subject: Re: [PATCH V4 05/19] trace/osnoise: Allow multiple instances of the
 same tracer
Message-ID: <20211022224711.7d1cbddf@rorschach.local.home>
In-Reply-To: <6da5c06e2455e4edca4f4115199bf2bf3844798c.1634820694.git.bristot@kernel.org>
References: <cover.1634820694.git.bristot@kernel.org>
 <6da5c06e2455e4edca4f4115199bf2bf3844798c.1634820694.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Oct 2021 14:56:43 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> Allow more than one instance of the same tracer. The workload will
> start when the first trace_array (instance) is registered and will
> stop when the last instance is unregistered.
> 


> Osnoise and timerlat are still mutually exclusive because of the
> different behavior of the osnoise: tracepoints.

I don't understand what the above means, or how it is relative to this
commit?

-- Steve
