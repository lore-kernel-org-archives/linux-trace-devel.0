Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61F1C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 17:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 809AE206C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 17:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfAPRpg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 12:45:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfAPRpg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 12:45:36 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B8E720657;
        Wed, 16 Jan 2019 17:45:34 +0000 (UTC)
Date:   Wed, 16 Jan 2019 12:45:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 10/46] tools/lib/traceevent: Man page for
 tep_is_latency_format() and tep_set_latency_format()
Message-ID: <20190116124533.4ed3f389@gandalf.local.home>
In-Reply-To: <20181127154153.11315-11-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
        <20181127154153.11315-11-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 27 Nov 2018 15:42:19 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_is_latency_format() and tep_set_latency_format()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-latency_format.txt          | 100 ++++++++++++++++++
>  1 file changed, 100 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
> new file mode 100644
> index 000000000000..4b0d7d3f6ae9
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
> @@ -0,0 +1,100 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_set_latency_format,tep_is_latency_format - Get / set "latency output" format.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
> +int *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +"Latency output" format prints information about interrupts being disabled, 
> +soft irq being disabled, the "need_resched" flag being set and preempt count. 
> +This information is recorded with every event, but by default is not printed.
> +
> +The _tep_set_latency_format()_ function enables the "latency output" printing.
> +The _tep_ argument is trace event parser context. The _lat_ argument can be zero,
> +for "latency output" disabled, or non zero for "latency output" enabled.
> +Information is displayed with 6 characters. When a field is zero, or N/A, a pass:['.'] 
> +is printed. Example:
> +[verse]
> +--
> +  <idle>-0       0d.h1. 106467.859747: function:             ktime_get <-- tick_check_idle
> +--
> +The 0d.h1. denotes this information. The first character is never a pass:['.']
> +and represents what CPU the trace was recorded on (CPU 0). The pass:['d'] denotes
> +that interrupts were disabled. The pass:['h'] means that this was called inside
> +an interrupt handler. The pass:['1'] is the preemption disabled (preempt_count)
> +was set to one.  The two pass:['.']s are "need_resched" flag and kernel lock
> +counter. If the "need_resched" flag is set, then that character would be a pass:['N'].

I would like to see a more formal explanation of the output here. Then
we can say "See Latency Format section."

Latency Format
--------------

The latency format displays 5 or more fields:

 CPU #, interrupt state, scheduling state, current context, and
 preemption count.

 Field 1 is the CPU number (starting with zero).

 Field 2 is the interrupt enabled state:

   d : Interrupts are disabled
   . : Interrupts are enabled
   X : The architecture does not support this information

 Field 3 is the "need resched" state.

   N : The task is set to call the scheduler when possible, as another
       higher priority task may need to be scheduled in.
   . : The task is not set to call the scheduler.

 Field 4 is the context state.

   . : Normal context

   s : Soft interrupt context

   h : Hard interrupt context

   H : Hard interrupt context which triggered during soft interrupt
       context.

   z : NMI context

   Z : NMI context which triggered during hard interrupt context

 Field 5 is the preemption count.

   . : The preempt count is zero.

   On preemptible kernels (where the task can be scheduled out in
   arbitrary locations while in kernel context), The preempt count,
   when non zero, will prevent the kernel from scheduling out the
   current task. The preempt count number is displayed when it is not
   zero.

Depending on the kernel, it may show other fields (lock depth,
or migration disabled, which are unique to specialized kernels).

-- Steve


> +
> +The _tep_is_latency_format()_ function returns if "latency output" is enabled.
> +
> +This "Latency output" setting affects output of _tep_print_event_task()_
> +and _tep_print_event_time()_ APIs. 
> +
> +RETURN VALUE
> +------------
> +
> +The _tep_is_latency_format()_ function returns non zero if "latency output" 
> +is enabled, or zero if it is disabled.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	tep_set_latency_format(tep, 1);
> +...
> +	if (tep_is_latency_format(tep)) {
> +		/* latency output format is enabled */
> +	} else {
> +		/* latency output format is disabled */
> +	}
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_, tep_print_event_task(3), tep_print_event_time(3)
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

