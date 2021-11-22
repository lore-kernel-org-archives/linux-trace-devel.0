Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2D7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 14:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhKVPAq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 10:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239113AbhKVPAp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 10:00:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 873866054E;
        Mon, 22 Nov 2021 14:57:37 +0000 (UTC)
Date:   Mon, 22 Nov 2021 09:57:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        mingo@redhat.com, mtosatti@redhat.com, nilal@redhat.com,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] arm64/tracing: add cntvct based trace clock
Message-ID: <20211122095735.2340f38f@gandalf.local.home>
In-Reply-To: <20211119102117.22304-2-nsaenzju@redhat.com>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
        <20211119102117.22304-2-nsaenzju@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Nov 2021 11:21:17 +0100
Nicolas Saenz Julienne <nsaenzju@redhat.com> wrote:

> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM64_TRACE_CLOCK_H
> +#define _ASM_ARM64_TRACE_CLOCK_H
> +
> +#include <linux/types.h>
> +
> +extern u64 notrace trace_clock_arm64_cntvct(void);
> +
> +# define ARCH_TRACE_CLOCKS \
> +	{ trace_clock_arm64_cntvct, "cntvct", .in_ns = 0 },
> +
> +#endif  /* _ASM_ARM64_TRACE_CLOCK_H */

So this will appear as a usable clock in trace-cmd.

And since this will be used to synchronize between host and guest like the
x86_tsc is used, that means that trace-cmd needs to know that this is the
an arch "CPU" clock. I wonder if we should rename x86_clock (or at least
make it an alias) to "kvm_clock". Then we can have trace-cmd use
"kvm_clock" as the clock for synchronization between host and guests for
all architectures?

Thinking about this, instead of renaming it, I'll add code to create an
alias to these clocks. Then every arch can pick what clock is used that is
the same between hosts and guests such that user space tooling doesn't have
to keep a database of what clocks are used for synchronization between
hosts and guests for each arch.

I'll go add some code ;-)

-- Steve
