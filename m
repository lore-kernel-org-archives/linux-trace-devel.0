Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA64C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 17:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562882220F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 17:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgLURTs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 12:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgLURTs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 12:19:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B82632220F;
        Mon, 21 Dec 2020 17:19:06 +0000 (UTC)
Date:   Mon, 21 Dec 2020 12:19:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] libtracefs man pages: APIs for initializing a
 tep handler with trace events from the local system.
Message-ID: <20201221121905.70ea53be@gandalf.local.home>
In-Reply-To: <20201221060252.177890-8-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
        <20201221060252.177890-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I've applied everything up to this patch, but this patch will need to be
updated more than just a tweak, so I'm not pulling it in.


On Mon, 21 Dec 2020 08:02:51 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Documented APIs:
> tracefs_local_events()
> tracefs_local_events_system()
> tracefs_fill_local_events()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-events-tep.txt | 131 ++++++++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100644 Documentation/libtracefs-events-tep.txt
> 
> diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
> new file mode 100644
> index 0000000..a01ce0e
> --- /dev/null
> +++ b/Documentation/libtracefs-events-tep.txt
> @@ -0,0 +1,131 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_local_events, tracefs_local_events_system, tracefs_fill_local_events -
> +Initialize a tep handler with trace events from the local system.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +*#include <event-parse.h>*

No need for the "event-parse.h"

> +
> +struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
> +struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
> +int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +Functions for initializing a tep handler with trace events from the local system.
> +
> +The _tracefs_local_events()_ function allocates a new _tep_ handler and
> +initializes it with events from all trace systems, located in the given
> +_tracing_dir_ directory. This could be NULL or tracefs mount point, for
> +trace events in top instance, or full path to a trace instance, for trace
> +events in that instance.

The definition of _tracing_dir_ needs to be updated to what the other
patches were. They shouldn't mention the full path to a trace instance.



> +
> +The _tracefs_local_events_system()_ function allocates a new _tep_ handler
> +and initializes it with events from specified trace systems _sys_names_,
> +located in the given _tracing_dir_ directory. This could be NULL or tracefs
> +mount point, for trace events in top instance, or full path to a trace instance,
> +for trace events in that instance. The _sys_names_ argument is an array of
> +trace system names, that will be used for _tep_ handler initialization.
> +The last element in that array must be a NULL pointer.
> +
> +The _tracefs_fill_local_events()_ function initializes already allocated _tep_
> +handler with events from all trace systems, located in the given _tracing_dir_
> +directory. This could be NULL or tracefs mount point, for trace events in
> +the top instance, or full path to a trace instance, for trace events in that
> +instance. The _tep_ argument must be a pointer to already allocated tep
> +handler, that is going to be initialized. The _parsing_failures_ argument
> +could be NULL or a pointer to an integer, where the number of failures while
> +parsing the event files are returned.

Same with the above two.

> +
> +RETURN VALUE
> +------------
> +The _tracefs_local_events()_ and _tracefs_local_events_system()_ functions
> +return pointer to allocated and initialized _tep_ handler, or NULL in
> +case of an error. The returned _tep_ handler must be freed with _tep_free()_.

 "must be freed with _tep_free(3)_" 

As there is a man page for that one.

Thanks!

-- Steve


> +
> +The _tracefs_fill_local_events()_ function returns -1 in case of an error or
> +0 otherwise.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <tracefs.h>
> +#include <event-parse.h>
> +
> +struct tep_event *tep;
> +...
> +	tep = tracefs_local_events(NULL);
> +	if (!tep) {
> +		/* Failed to initialise tep handler with local events from top instance */
> +		...
> +	}
> +...
> +	tep_free(tep);
> +...
> +	const char *systems[] = {"ftrace", "irq", NULL};
> +	tep = tracefs_local_events_system(NULL, systems);
> +	if (!tep) {
> +		/* Failed to initialise tep handler with local events from
> +		 * ftrace and irq systems in top instance.
> +		 */
> +		...
> +	}
> +...
> +	tep_free(tep);
> +...
> +	int parsing_failures;
> +	tep = tep_alloc();
> +	if (!tep) {
> +		/* Failed to allocate a tep handler */
> +		...
> +	}
> +	if (tracefs_fill_local_events(NULL, tep, &parsing_failures) < 0) {
> +		/* Failed to initialise tep handler with local events from top instance */
> +	}
> +...
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

