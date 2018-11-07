Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbeKGJrw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 04:47:52 -0500
Date: Tue, 6 Nov 2018 19:19:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/7] tools/lib/traceevent: Implement libtraceevent man
 pages
Message-ID: <20181106191958.2c07ec17@gandalf.local.home>
In-Reply-To: <20181106132035.7692-6-tstoyanov@vmware.com>
References: <20181106132035.7692-1-tstoyanov@vmware.com>
        <20181106132035.7692-6-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 6 Nov 2018 13:20:54 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements a man page, which documents
> tep_is_latency_format() and tep_set_latency_format()
> libtraceevent APIs
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-latency_format.txt          | 98 +++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
> new file mode 100644
> index 000000000000..a7eaed5d1a7e
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
> @@ -0,0 +1,98 @@
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
> +soft irq being disabled, the "need_resched" flag being set, preempt count, 
> +and big kernel lock. This information is recorded with every event, but by 

The "big kernel lock" no longer exists (Yay!!!), we can remove that
line.

> +default is not printed.
> +
> +The _tep_set_latency_format()_ function enables the "latency output" printing.
> +The _tep_ argument is trace event parser context. The _lat_ argument can be zero,
> +for "latency output" disabled, or non zero for "latency output" enabled.

Hmm, perhaps we should change that parameter to true or false.

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
> +
> +The _tep_is_latency_format()_ function returns if "latency output" is enabled.

We need to add somewhere in this description about
tep_print_event_task() and tep_print_event_time() which is what this
affects. As tep_print_event*() creates the string to output and is
affected by this format.

We may change this before we release the final output.

-- Steve

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
