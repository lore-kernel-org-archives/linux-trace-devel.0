Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E5CC43334
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 16:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbiFGQ3z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiFGQ3z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 12:29:55 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294B9FC4E0
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 09:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=m0PbXMeeKuwQehJ0KgLCpOzlRSPCJtotCoa5OlRYrYg=;
  b=Z5P9q3oVAG+BIdnGxlH0pXlZCUeLWdQptFPWaDKxcs/XaKIIDfLMHXKY
   rLbkMB37RINC/itp2RtpNfbVx6mcvbePD/JJS4xdmgayjVQdGjZbLF6um
   HKakga2WO97g+v1O8bBGgO8mYAOs2/7Iq+Rb8UA9QH2DVTqbBsrUfW1o7
   Q=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,284,1647298800"; 
   d="scan'208";a="39880399"
Received: from dt-lawall.paris.inria.fr ([128.93.67.65])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:29:52 +0200
Date:   Tue, 7 Jun 2022 18:29:52 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: julia@hadrien
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH v2] trace-cmd report: Explain the '-l' option better in
 the man  page
In-Reply-To: <20220607122857.2dd8b761@gandalf.local.home>
Message-ID: <alpine.DEB.2.22.394.2206071829360.11966@hadrien>
References: <20220607122857.2dd8b761@gandalf.local.home>
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

Acked-by: Julia Lawall <julia.lawall@inria.fr>

>
> Reported-by: Julia Lawall <julia.lawall@inria.fr>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216069
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/all/20220607113007.652e14e2@gandalf.local.home/
>
>  - May the fourth be with you (not force or forth) (Julia Lawall)
>
>  - Also change 8 spaces into a tab.
>
>  .../trace-cmd/trace-cmd-report.1.txt          | 39 +++++++++++++++----
>  1 file changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
> index df60dd87d979..985f8acee9b4 100644
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
> +	'd' - Interrupts are disabled
> +	'.' - Interrupts are enabled
> +	'X' - Has flags that are not yet known by trace-cmd
> +
> +    The third character is the "need rescheduling" flag.
> +
> +	'N' - A schedule is set to take place
> +	'.' - No scheduling is set
> +
> +    The fourth character represents the context the event was in when it triggered
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
