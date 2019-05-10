Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8025C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 18:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84416217D6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 18:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfEJS35 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 14:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727642AbfEJS35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 14:29:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60FA321841;
        Fri, 10 May 2019 18:29:56 +0000 (UTC)
Date:   Fri, 10 May 2019 14:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 25/26] tools/lib/traceevent: Man pages for APIs, used
 to extract common fields from a record
Message-ID: <20190510142954.0ab4e582@gandalf.local.home>
In-Reply-To: <20190503091119.23399-26-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
        <20190503091119.23399-26-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  3 May 2019 12:11:18 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
> @@ -0,0 +1,137 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_data_type, tep_data_pid,tep_data_preempt_count, tep_data_flags -
> +Extract common fields from a record.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +enum *trace_flag_type* {
> +	_TRACE_FLAG_IRQS_OFF_,
> +	_TRACE_FLAG_IRQS_NOSUPPORT_,

Changed here OK.

> +	_TRACE_FLAG_NEED_RESCHED_,
> +	_TRACE_FLAG_HARDIRQ_,
> +	_TRACE_FLAG_SOFTIRQ_,
> +};
> +
> +int *tep_data_type*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
> +int *tep_data_pid*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
> +int *tep_data_preempt_count*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
> +int *tep_data_flags*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
> +--



> +The _tep_data_flags()_ function gets the latency flags from the record _rec_.
> +It reads the "common_flags" field. The _tep_ argument is the trace event parser
> +context. Supported latency flags are:
> +[verse]
> +--
> +	_TRACE_FLAG_IRQS_OFF_,		Interrupts are disabled.
> +	_TRACE_FLAG_IRQS_NOSUPPOR_,	Reading IRQ flag is not supported by the architecture.

Forgot to change here. I'll fix.

-- Steve

> +	_TRACE_FLAG_NEED_RESCHED_,	Task needs rescheduling.
> +	_TRACE_FLAG_HARDIRQ_,		Hard IRQ is running.
> +	_TRACE_FLAG_SOFTIRQ_,		Soft IRQ is running.
> +--
> +
