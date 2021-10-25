Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17CCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 13:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D4561027
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 13:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhJYNiH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 09:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhJYNiG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 09:38:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A11660F9D;
        Mon, 25 Oct 2021 13:35:43 +0000 (UTC)
Date:   Mon, 25 Oct 2021 09:35:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     paulmck@kernel.org, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH V4 04/19] trace/osnoise: Support a list of trace_array
 *tr
Message-ID: <20211025093541.6ced3995@gandalf.local.home>
In-Reply-To: <5f1ae99f-a7b2-e25f-800c-4e6e87b936ca@kernel.org>
References: <cover.1634820694.git.bristot@kernel.org>
        <d54f5bfa2b2fbd11393c2a69a8b5cbdd808a506d.1634820694.git.bristot@kernel.org>
        <20211022223839.476905ed@rorschach.local.home>
        <20211025032614.GN880162@paulmck-ThinkPad-P17-Gen-1>
        <5f1ae99f-a7b2-e25f-800c-4e6e87b936ca@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Oct 2021 11:10:26 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> The start/stop/reset operations are called from trace "core" operations. So they
> are all protected/serialized by trace_types_lock (by trace/core).
> 
> So, it seems that the way to go is to remove the rcu_read_lock/unlock() from
> unregister, adding a lockdep check to see if trace_types_lock is help as a bonus?

Yes, I would recommend the lockdep assert added. This way it also documents
what lock protects modification of the list.

Thanks,

-- Steve

