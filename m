Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3152C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 12:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9836161182
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 12:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhEEMMi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 08:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhEEMLQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 08:11:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D484613C4;
        Wed,  5 May 2021 12:10:19 +0000 (UTC)
Date:   Wed, 5 May 2021 08:10:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joelaf@google.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Find PID of host-guest task from tracing
 vsock connection
Message-ID: <20210505081017.52b21409@gandalf.local.home>
In-Reply-To: <20210505080457.0494649b@gandalf.local.home>
References: <20210505080457.0494649b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 5 May 2021 08:04:57 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Searching for the qemu task to find what task the CID is for is not a
> reliable method, as the qemu executable may be called different names on
> different systems, and qemu may not even be used.
> 
> Instead, trace the sched_waking and kvm_exit events and do a vsock
> connection to the CID. By doing so, you can find the task that runs the
> guest.
> 
>  trace-cmd wakes up "vhost-<pid>"
>  vhost-<pid> wakes up "CPUX/KVM"
>  CPUX/KVM calls "kvm_exit"
> 
> The CPUX/KVM is the task that runs the vCPU of the guest, but we still
> need the task group leader of this task to find the task that KVM has
> for timestamp offsets and multipliers. To do that, look at the proc
> file system for the PID of the CPUX/KVM and read its status file.
> This holds "Tgid:    <pid>" where "<pid>" is the PID of the task that
> has the KVM information.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>

Joel,

Can you try this patch out on crosvm and see if it works for that too? It
should (hopefully) find the PID for the main task that it uses to sync with
KVM, and should use the KVM protocol instead of the ptp one.

That's if crosvm works the same as qemu.

-- Steve
