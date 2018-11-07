Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388387AbeKGJvh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 04:51:37 -0500
Date: Tue, 6 Nov 2018 19:23:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 6/7] tools/lib/traceevent: Implement libtraceevent man
 pages
Message-ID: <20181106192343.1831edd8@gandalf.local.home>
In-Reply-To: <20181106132035.7692-7-tstoyanov@vmware.com>
References: <20181106132035.7692-1-tstoyanov@vmware.com>
        <20181106132035.7692-7-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 6 Nov 2018 13:20:56 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements a man page, which documents
> tep_get_page_size() and tep_set_page_size()
> libtraceevent APIs
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-page_size.txt | 79 +++++++++++++++++++
>  1 file changed, 79 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
> new file mode 100644
> index 000000000000..d2bad8dca42d
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
> @@ -0,0 +1,79 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_get_page_size,tep_set_page_size - Get / set the size of a memory page on the 
> +machine, where the trace is generated 
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
> +void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_get_page_size()_ function returns the size of a memory page on 
> +the machine, where the trace is generated. The _tep_ argument is trace event parser context.
> +
> +The _tep_set_page_size()_ function sets the size of a memory page on the machine, 
> +where the trace is generated. The _tep_ argument is trace event parser context.

Note, we don't actually set the memory page size of the machine, that's
already fixed ;-)

We use tep_set_page_size() to tell the tep handler what the page size
is for the raw data it is parsing, and we use tep_get_page_size to
retrieve what the page_size is for the handler. The get_page_size is
used by plugins that need to know this information.

-- Steve




> +The _page_size_ argument is the size of a memory page, in bytes. 
> +This information is saved in the trace.dat file. 
> +
> +RETURN VALUE
> +------------
> +The _tep_get_page_size()_ function returns size, in bytes, of the memory page.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	int page_size = 4096;
> +	tep_set_page_size(tep, page_size);
> +	if ( 4096 != tep_get_page_size(tep)) {
> +		/* Something wrong happened, page size is not set as expected */
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
