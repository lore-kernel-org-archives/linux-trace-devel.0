Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAA8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 18:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28A0610A4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 18:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbhJ0Sbs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 14:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238534AbhJ0Sbs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 14:31:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489F26103C;
        Wed, 27 Oct 2021 18:29:21 +0000 (UTC)
Date:   Wed, 27 Oct 2021 14:29:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tao Zhou <tao.zhou@linux.dev>
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
Subject: Re: [PATCH V6 11/20] rtla/osnoise: Add the hist mode
Message-ID: <20211027142918.487cd143@gandalf.local.home>
In-Reply-To: <YXmWTOXHYXFduayt@geo.homenetwork>
References: <cover.1635284863.git.bristot@kernel.org>
        <fede3c3805cb7a70bd7c8d60ba2c5ce290cc6e1e.1635284863.git.bristot@kernel.org>
        <YXmWTOXHYXFduayt@geo.homenetwork>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Oct 2021 02:11:24 +0800
Tao Zhou <tao.zhou@linux.dev> wrote:

> > +	/* one histogram for IRQ and one for thread, per cpu */
> > +	for (cpu = 0; cpu < nr_cpus; cpu++) {
> > +		data->hist[cpu].samples = calloc(1, sizeof(*data->hist) * (entries + 1));  
> 
> @samples is a pointer to int and used for int array. The "sizeof(*data->hist)"
> should be "sizeof(int)" or am I totally wrong.

Or standard approach is: 

		data->hist[cpu].samples = calloc(1, sizeof(*data->hist->samples) * (entries + 1));

-- Steve
