Return-Path: <SRS0=PQ4s=S4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F42C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0CEC2054F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfDZCrT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 22:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728983AbfDZCrT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 22:47:19 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 886AD2084F;
        Fri, 26 Apr 2019 02:47:18 +0000 (UTC)
Date:   Thu, 25 Apr 2019 22:47:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 10/30] tools/lib/traceevent: Man page for
 tep_register_trace_clock()
Message-ID: <20190425224716.630c6350@oasis.local.home>
In-Reply-To: <20190412133811.15878-11-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-11-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:51 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man page for tep_register_trace_clock() libtraceevent API.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-reg_clock.txt | 77 +++++++++++++++++++
>  1 file changed, 77 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
> new file mode 100644
> index 000000000000..8bf6c5348fcf
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
> @@ -0,0 +1,77 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_register_trace_clock - Registers the clock, used for the timestamp of
> +the events.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_register_trace_clock*(struct tep_handle pass:[*]_tep_, const char pass:[*]_trace_clock_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_register_trace_clock()_ function registers the clock, used for
> +the timestamps of the events. When an event is recorded, a timestamp is attached
> +to it. This timestamp comes from a specified clock. Supported clocks can be seen
> +in tracefs/trace_clock, the selected one is in square brackets.
> +The _tep_ argument is the trace event parser context. The _trace_clock_ argument
> +is the name of the clock, the string is copied internally.
> +
> +RETURN VALUE
> +------------
> +The _tep_register_trace_clock()_ function returns 0 in case of success.
> +If there is not enough memory to copy the _trace_clock_ string -1 is returned
> +and errno is set to ENOMEM.
>

Hmm, this is more code I think we should remove from libtraceevent, and
have the tools just set the tep flag to print in usecs or not. The
library shouldn't be setting policy.

The tools (perf, trace-cmd, etc) should just implement their own
tep_register_trace_clock() (not calling it that), and set the USEC flag
depending on what it wants.

-- Steve
