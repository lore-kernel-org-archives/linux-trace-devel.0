Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E4EC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C117213A2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfCMRdX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfCMRdX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 13:33:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E3612070D;
        Wed, 13 Mar 2019 17:33:22 +0000 (UTC)
Date:   Wed, 13 Mar 2019 13:33:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 20/46] tools/lib/traceevent: Man pages for
 tep_print_event(), tep_print_event_data(), tep_event_info(),
 tep_print_event_task() and tep_print_event_time()
Message-ID: <20190313133320.646f36e1@gandalf.local.home>
In-Reply-To: <20190308133654.21264-21-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-21-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:28 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_print_event(), tep_print_event_data(),
> tep_event_info(), tep_print_event_task() and tep_print_event_time()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-event_print.txt             | 126 ++++++++++++++++++
>  1 file changed, 126 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
> new file mode 100644
> index 000000000000..8fea72705645
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
> @@ -0,0 +1,126 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_print_event,tep_print_event_data,tep_event_info,tep_print_event_task,tep_print_event_time - Parses the data into the print format.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +*#include <trace-seq.h>*
> +
> +void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]record, bool _use_trace_clock_);
> +void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
> +void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
> +void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
> +void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_print_event_time()_ function prints the timestamp of the _record_ using
> +the given _event_ information as trace sequence in _s_.

The above should be worded different, as it sounds like it gets the
information from _s_.

Should say "writes the timestamp of the given _record_ into the trace
sequence _s_."


> The _tep_ argument is
> +trace event parser context. The _use_trace_clock_ argument indicates if
> +the tep->trace_clock should be used for parsing the timestamp.
> +
> +The _tep_print_event_task()_ function prints the task command, pid and CPU of
> +the _record_ using the given _event_ information as trace sequence in _s_.

Same here.

> +The _tep_ argument is trace event parser context.
> +
> +The _tep_event_info()_ function parses the raw data from the _record_ using
> +the given _event_ information and writes the print format as trace sequence in
> +_s_.

The above is correct and what the other two should look like.

> +
> +The _tep_print_event_data()_ function writes the _event_ name  as trace
> +sequence in _s_ and calls _tep_event_info()_ to parse and write the raw data
> +from the _record_. The _tep_ argument is trace event parser context.

The above needs to be fixed.

> +
> +The _tep_print_event()_ function prints the _record_ information as trace
> +sequence in _s_. It finds the corresponding event and calls

The above needs to be fixed.

-- Steve

> +_tep_print_event_task()_,_tep_print_event_time()_ and _tep_print_event_data()_
> +to parse and print the information.
> +The _tep_ argument is trace event parser context. The _use_trace_clock_
> +argument indicates if the tep->trace_clock should be used for parsing
> +the timestamp.
> +
