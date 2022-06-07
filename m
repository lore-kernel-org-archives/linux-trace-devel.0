Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7FDC43334
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 16:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbiFGQRd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244679AbiFGQR2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 12:17:28 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF2BF598
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 09:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=B30EF4oa96WQUkKR2T8dBjzDukdEwZhM4hiEB+EulHw=;
  b=mpUtAInVsr5fnd6teMihO3ubqyXvr+06+i4eEnrdP/kYuLzCPUcaF4x+
   TAPRsck8lJORpIVSCtFNzdwTymv2XuoYWgKHSY8mXQagCVRe+1c8Y71rZ
   FaoVHjF943vsPL8ltco0YVdPGFm/7VaM0IyG0r8ytnG2saVWS4CNNiTjN
   M=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,284,1647298800"; 
   d="scan'208";a="39878842"
Received: from dt-lawall.paris.inria.fr ([128.93.67.65])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:17:22 +0200
Date:   Tue, 7 Jun 2022 18:17:22 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: julia@hadrien
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd report: Explain the '-l' option better in the
 man page
In-Reply-To: <20220607113007.652e14e2@gandalf.local.home>
Message-ID: <alpine.DEB.2.22.394.2206071816580.11966@hadrien>
References: <20220607113007.652e14e2@gandalf.local.home>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Tue, 7 Jun 2022, Steven Rostedt wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> The '-l' option shows latency information of each event. It is not well
> documented. Update the man page to show what the cryptic values mean.
>
> Reported-by: Julia Lawall <julia.lawall@inria.fr>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216069
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  .../trace-cmd/trace-cmd-report.1.txt          | 39 +++++++++++++++----
>  1 file changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
> index df60dd87d979..ccf635fb664b 100644
> --- a/Documentation/trace-cmd/trace-cmd-report.1.txt
> +++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
> @@ -221,13 +221,38 @@ OPTIONS
>        <idle>-0       0d.h1. 106467.859747: function:             ktime_get <-- tick_check_idle
>  ----
>
> -    The 0d.h1. denotes this information. The first character is never a '.'
> -    and represents what CPU the trace was recorded on (CPU 0). The 'd' denotes
> -    that interrupts were disabled. The 'h' means that this was called inside
> -    an interrupt handler. The '1' is the preemption disabled (preempt_count)
> -    was set to one.  The two '.'s are "need_resched" flag and kernel lock
> -    counter.  If the "need_resched" flag is set, then that character would be a
> -    'N'.
> +    The 0d.h1. denotes this information.
> +
> +    It starts with a number. This represents the CPU number that the event occurred
> +    on.
> +
> +    The second character is one of the following:
> +
> +        'd' - Interrupts are disabled
> +	'.' - Interrupts are enabled
> +	'X' - Has flags that are not yet known by trace-cmd
> +
> +    The third character is the "need rescheduling" flag.
> +
> +	'N' - A schedule is set to take place
> +	'.' - No scheduling is set
> +
> +    The forth character represents the context the event was in when it triggered

Thanks for the extra detail.

Forth should be fourth.

julia


> +
> +	'h' - Hard interrupt context
> +	's' - Soft interrupt context
> +	'H' - Hard interrupt context that interrupted a soft interrupt
> +	'.' - Normal context
> +
> +    The next is a number (should be less than 10), that represents the preemption
> +    depth (the number of times preempt_disable() is called without preempt_enable()).
> +    '.' means preemption is enabled.
> +
> +    On some systems, "migrate disable" may exist, in which case a number will be
> +    shown for that, or '.' meaning migration is enabled.
> +
> +    If lockdep in enabled on the system, then the number represents the depth of
> +    locks that are held when the event triggered. '.' means no locks are held.
>
>  *-w*::
>      If both the 'sched_switch' and 'sched_wakeup' events are enabled, then
> --
> 2.35.1
>
>
