Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731049AbeKGJfu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 04:35:50 -0500
Date: Tue, 6 Nov 2018 19:07:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/7] tools/lib/traceevent: Implement libtraceevent man
 pages
Message-ID: <20181106190759.0ea9796e@gandalf.local.home>
In-Reply-To: <20181106132035.7692-3-tstoyanov@vmware.com>
References: <20181106132035.7692-1-tstoyanov@vmware.com>
        <20181106132035.7692-3-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Subject should be: tools/lib/traceevent: Man pages for tep_get_cpus()
and tep_set_cpus()

On Tue, 6 Nov 2018 13:20:51 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements a man page, which documents
> tep_get_cpus() and tep_set_cpus() libtraceevent APIs

BTW, "implements" isn't the right word. Also, it is looked down on to
reference "this patch" as people know this is a patch. What I would say
instead is:

"Create man pages for tep_get_cpus() and tep_set_cpus() as part of the
libtraceevent APIs".



> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-cpus.txt      | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
> new file mode 100644
> index 000000000000..f9ed0a02d653
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
> @@ -0,0 +1,78 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_get_cpus,tep_set_cpus - Get / set the numbers of CPUs, which have tracing 

 "the number of"

> +data recorded.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_get_cpus*(struct tep_handle pass:[*]_tep_);
> +void *tep_set_cpus*(struct tep_handle pass:[*]_tep_, int _cpus_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_get_cpus()_ functions gets the number of CPUs, which have tracing 

" function gets the"

> +data recorded. The _tep_ argument is trace event parser context.

 "data recorded in the _tep_ context."

> +
> +The _tep_set_cpus()_ functions sets the number of CPUs, which have tracing 

 " function sets"

> +data recorded. The _tep_ argument is trace event parser context. The _cpu_
> +argument is the number of CPUs with tracing data. This information is saved 
> +in the trace.dat file.

How is it saved in the trace.dat file?

-- Steve


> +
> +RETURN VALUE
> +------------
> +The _tep_get_cpus()_ functions returns the number of CPUs, which have tracing 
> +data recorded.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	tep_set_cpus(tep, 5);
> +...
> +	printf("We have tracing data for %d CPUs", tep_get_cpus(tep));
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
