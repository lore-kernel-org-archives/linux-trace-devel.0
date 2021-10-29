Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BDEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 13:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D94761167
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 13:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJ2NEQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231418AbhJ2NEP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 09:04:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB22B60F93;
        Fri, 29 Oct 2021 13:01:45 +0000 (UTC)
Date:   Fri, 29 Oct 2021 09:01:44 -0400
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
Subject: Re: [PATCH V7 8/9] trace/osnoise: Remove STACKTRACE ifdefs from
 inside functions
Message-ID: <20211029090144.49f43936@gandalf.local.home>
In-Reply-To: <b2c51cb7-1561-a23b-bba2-d8a8c5d27691@kernel.org>
References: <cover.1635452903.git.bristot@kernel.org>
        <2cab388e4faaf3fc3496a1c18ec09a8bc7c36c3f.1635452903.git.bristot@kernel.org>
        <b2c51cb7-1561-a23b-bba2-d8a8c5d27691@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 Oct 2021 14:31:27 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> > +	/*
> > +	 * 0 is disabled, so it will never be > than latency.
> > +	 */
> > +	if (osnoise_data.print_stack > latency)
> > +		return;  
> 
> Oops, I placed the comment, but forgot to place the check. This if should be:
> 
> if (!osnoise_data.print_stack || osnoise_data.print_stack > latency)
> 	return;

Or I could've had a V8!

  https://www.youtube.com/watch?v=qYo0lVVH2wU

-- Steve
