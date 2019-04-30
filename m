Return-Path: <SRS0=xYfD=TA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1251C04AA8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B17E421743
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfD3Wgl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 18:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfD3Wgl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 18:36:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D651820854;
        Tue, 30 Apr 2019 22:36:39 +0000 (UTC)
Date:   Tue, 30 Apr 2019 18:36:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 17/30] tools/lib/traceevent: Man pages for
 libtraceevent event print related APIs
Message-ID: <20190430183638.03277d83@gandalf.local.home>
In-Reply-To: <20190412133811.15878-18-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-18-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:58 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Added new man pages, describing libtraceevent event print related APIs:
>   tep_print_event(),
>   tep_print_event_data(),
>   tep_event_info(),
>   tep_print_event_task(),
>   tep_print_event_time(),
>   tep_set_print_raw()

Yeah, here's another set that needs to change.

> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-event_print.txt             | 138 ++++++++++++++++++
>  1 file changed, 138 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
> new file mode 100644
> index 000000000000..2a0dec71fd99
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
> @@ -0,0 +1,138 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_print_event, tep_print_event_data, tep_event_info, tep_print_event_task,
> +tep_print_event_time, tep_set_print_raw - Parses the data into the print format.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +*#include <trace-seq.h>*
> +
> +void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]record, bool _use_trace_clock_);

The "use_trace_clock" needs to go. It's probably best to pass in a
precision and divisor.

	tep_print_event_time(tep, &seq, event, record, precision, divisor)

For a counter we would just have:

	0, 0)

For full nsecs:

	9, 0)

For usecs:

	6, 1000)

Where we would take the number and do:

long long divisors[] = {
	1, 10, 100, 1000, 10000, 100000, 1000000,
	10000000, 100000000, 1000000000, 10000000000 }

	ts = record->ts;
	if (divisor)
		ts /= divisor;
	if (precision) {
		if (precision > (sizeof(divisors) / sizeof(divisors[0])) {
			warn();
			last = ts;
		} else {
			first = ts / divisors[precision];
			last = ts - first * divisors[precision];
		}
		trace_seq_printf(seq, " %5lu.%0*lu", first, precision, last);
	} else
		trace_seq_printf(seq, " %12lu", ts);

something like that.


> +void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
> +void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
> +void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
> +void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
> +void *tep_set_print_raw*(struct tep_handle pass:[*]_tep_, int _print_raw_);

I'm also thinking of modifying all of these to be the bare minimum of
what they do, and have the callers do the rest.

Let's hold off on these man pages. I think we are going to rewrite a
lot of this code first.

-- Steve


> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_print_event_time()_ function writes the timestamp of the given _record_
> +into the trace sequence _s_. The _tep_ argument is trace event parser context.
> +The _use_trace_clock_ argument indicates if the tep->trace_clock should be used
> +for parsing the timestamp.
> +
> +The _tep_print_event_task()_ function writes the task command, pid and CPU of
> +the given _record_ using the given _event_ information into the trace sequence
> +_s_. The _tep_ argument is trace event parser context.
> +
> +The _tep_event_info()_ function parses the raw data from the _record_ using
> +the given _event_ information and writes the print format into the trace
> +sequence _s_.
> +
> +The _tep_print_event_data()_ function writes the name of the _record_ using the
> +given _event_ information into the trace sequence _s_ and calls
> +_tep_event_info()_ to parse and write the raw data from the _record_. The _tep_
> +argument is trace event parser context.
> +
> +The _tep_print_event()_ function writes the _record_ information. It finds the
> +corresponding event and calls _tep_print_event_task()_, _tep_print_event_time()_
> +and _tep_print_event_data()_ to parse and write the information, into the trace
> +sequence _s_. The _tep_ argument is trace event parser context.
> +The _use_trace_clock_ argument indicates if the tep->trace_clock should be used
> +for parsing the timestamp.
> +
> +The _tep_set_print_raw()_ function forces event's information to be printed in
> +raw format. It changes the behavior of _tep_event_info()_ function. The _tep_
> +argument is trace event parser context. The _print_raw_ argument specifies
> +whether to print in raw format or not.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +#include <trace-seq.h>
> +...
> +struct trace_seq seq;
> +trace_seq_init(&seq);
> +struct tep_handle *tep = tep_alloc();
> +...
> +void print_my_event(struct tep_record *record)
> +{
> +	struct tep_event *event;
> +
> +	/* print all event information */
> +	trace_seq_reset(&seq);
> +	tep_print_event(tep, &seq, record, TRUE);
> +
> +	event = tep_find_event_by_record(tep, record);
> +
> +	if (event != NULL) {
> +		/* print event timestamp */
> +		trace_seq_reset(&seq);
> +		tep_print_event_time(tep, &seq, event, record, TRUE);
> +
> +		/* print event task information */
> +		trace_seq_reset(&seq);
> +		tep_print_event_task(tep, &seq, event, record);
> +
> +		/* print event name and raw data */
> +		trace_seq_reset(&seq);
> +		tep_print_event_data(tep, &seq, event, record);
> +
> +		/* print event raw data */
> +		trace_seq_reset(&seq);
> +		tep_event_info(&seq, event, record);
> +
> +		/* print event raw data in raw format */
> +		trace_seq_reset(&seq);
> +		tep_set_print_raw(tep, 1);
> +		tep_event_info(&seq, event, record);
> +	}
> +}
> +...
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*trace-seq.h*
> +	Header file to include in order to have access to trace sequences related APIs.
> +	Trace sequences are used to allow a function to call several other functions
> +	to create a string of data to use.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

