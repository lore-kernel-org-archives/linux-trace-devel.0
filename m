Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED2AC2BBD5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 19:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0786F23B84
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 19:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733193AbgLRTYa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 14:24:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730082AbgLRTYa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 14:24:30 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E40D23B84;
        Fri, 18 Dec 2020 19:23:49 +0000 (UTC)
Date:   Fri, 18 Dec 2020 14:23:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] libtracefs man pages: APIs for working with trace
 systems and events.
Message-ID: <20201218142347.000357df@gandalf.local.home>
In-Reply-To: <20201217094626.1402191-5-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Dec 2020 11:46:21 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> --- /dev/null
> +++ b/Documentation/libtracefs-events.txt
> @@ -0,0 +1,140 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_event_systems, tracefs_system_events, tracefs_iterate_raw_events -
> +Work with trace systems and events.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +*#include <event-parse.h>*

Let's remove all references of event-parse.h, as tracefs.h should already
handle that.

> +
> +char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
> +char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
> +int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +Trace systems and events related APIs.
> +
> +The _tracefs_event_systems()_ function returns array of strings with the
> +names of all registered trace systems, located in the given _tracing_dir_
> +directory. This could be NULL or tracefs mount point, for trace systems in
> +top instance, or full path to a trace instance, for trace systems in that
> +instance. The last entry in the array is a NULL pointer. The array must
> +be freed with _tracefs_list_free()_ API.

Since an instance always has the same event directory structure as the top
instance (and soon this will be even more guaranteed, when they will all
share the same directory internally), I would leave out the mentioning of
the path to the trace systems of an instance.

What I would mention, is that the path may be of a copy of a directory (for
example, copying an event directory from another machine).

 "This could be NULL or the location of the tracefs mount point for the
 trace systems of the local machine, or it may be a path to a copy of the
 tracefs directory from another machine."

> +
> +The _tracefs_system_events()_ function returns array of strings with the
> +names all registered trace events for given trace system, located in the

 "given trace system specified by _system_, located in the"

> +given _tracing_dir_ directory. This could be NULL or tracefs mount point,
> +for trace events in top instance, or full path to a trace instance, for
> +trace events in that instance. The last entry in the array as a NULL
> +pointer. The array must be freed with _tracefs_list_free()_ API.

Same update as for tracefs_event_systems().

> +
> +The _tracefs_iterate_raw_events()_ function iterates through all recorded
> +events in the raw trace ring buffer. It requires an initialized _tep_
> +handler. The ring buffer being iterated is in the given _instance_, or
> +in the top instance if _instance_ is NULL. It can filter events
> +for given _cpus_ only, a CPU mask of _cpu_size_ size, or walk through all
> +recorded events, if _cpus_ is a NULL pointer. The _callback_ is called for
> +every recorded event from the ring buffer. The _callback_context_ parameter
> +is passed to the _callback_. Parameters of the _callback_ are _tep_ event
> +handler; a pointer to recorded event, _struct tep_record_; the _cpu_ on
> +which the event had been happened and the user specified _callback_context_.
> +If the _callback_ returns non-zero, the iteration stops.

I would reword the above differently, as the above is too close to the
implementation doesn't really explain its purpose.

 "The _tracefs_interate_raw_events()_ function will read the tracefs raw
 data buffers and call the specified _callback_ function for every event it
 encounters. An initialized _tep_ handler is required (See
 *tracefs_local_events*(3)). If _instance_ is NULL, then the toplevel
 tracefs buffer is used, otherwise the buffer for the corresponding
 _instance_ is read. To filter only on a subset of CPUs, _cpus_ and
 _cpu_size_ may be set to only call _callback_ with events that occurred on
 the CPUs specified, otherwise if _cpus_ is NULL then the _callback_
 function will be called for all events, and _cpu_size_ is ignored. The
 _callback_ function will be called with the following parameters: A
 pointer to a struct tep_event that corresponds to the type of event the
 record is; The record representing the event; The CPU that the event
 occurred on; and a pointer to _context_."


> +
> +RETURN VALUE
> +------------
> +The _tracefs_event_systems()_ and __tracefs_system_events()_ functions return
> +an array of strings. The last element in that array is a NULL pointer. The array
> +must be freed with _tracefs_list_free()_ API. In case of an error, NULL is returned.
> +
> +The _tracefs_iterate_raw_events()_ function returns -1 in case of an error or
> +0 otherwise.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <tracefs.h>
> +#include <event-parse.h>

No need for the event-parse.h.

-- Steve


> +
> +char **systems = tracefs_event_systems(NULL);
> +
> +	if (systems) {
> +		int i = 0;
> +		/* Got registered trace systems from the top trace instance */
> +		while (systems[i]) {
> +			char **events = tracefs_system_events(NULL, systems[i]);
> +			if (events) {
> +				/* Got registered events in system[i] from the top trace instance */
> +				int j = 0;
> +
> +				while (events[j]) {
> +					/* Got event[j] in system[i] from the top trace instance */
> +					j++;
> +				}
> +				tracefs_list_free(events);
> +			}
> +			i++;
> +		}
> +		tracefs_list_free(systems);
> +	}
> +....
> +static int records_walk(struct tep_event *tep, struct tep_record *record, int cpu, void *context)
> +{
> +	/* Got recorded event on cpu */
> +	return 0;
> +}
> +...
> +struct tep_event *tep = tracefs_local_events(NULL);
> +
> +	if (!tep) {
> +		/* Failed to initialise tep handler with local events */
> +		...
> +	}
> +	if (tracefs_iterate_raw_events(tep, NULL, NULL, 0, records_walk, NULL) < 0) {
> +		/* Error walking through the recorded raw events */
> +	}
> +	tep_free(tep);
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*tracefs.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltracefs*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtracefs(3)_,
> +_libtraceevent(3)_,
> +_trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtracefs is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> \ No newline at end of file

