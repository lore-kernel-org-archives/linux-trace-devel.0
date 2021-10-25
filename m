Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F82C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 14:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2B460F4F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 14:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhJYOjX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 10:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232319AbhJYOjW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 10:39:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 553AC60720;
        Mon, 25 Oct 2021 14:36:59 +0000 (UTC)
Date:   Mon, 25 Oct 2021 10:36:57 -0400
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
Message-ID: <20211025103657.1c30a2c0@gandalf.local.home>
In-Reply-To: <7770e301-178f-725a-aa7f-b674b41ed20c@kernel.org>
References: <cover.1634820694.git.bristot@kernel.org>
        <6da5c06e2455e4edca4f4115199bf2bf3844798c.1634820694.git.bristot@kernel.org>
        <20211022224711.7d1cbddf@rorschach.local.home>
        <7770e301-178f-725a-aa7f-b674b41ed20c@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Oct 2021 10:08:39 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> osnoise and timerlat tracers share a lot of code, including the osnoise: events.
> 
> However, the osnoise: events have different behavior depending on which tracer
> is enabled. So, while this patch allows the same tracer to run in multiple
> instances (e.g., two instances running osnoise), it still does not allow
> instances of timerlat and osnoise in parallel (e.g., one timerlat and osnoise).
> 
> Should I add the text above to the log?

Yes please.

-- Steve
