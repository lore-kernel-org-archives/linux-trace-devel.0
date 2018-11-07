Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbeKGJnt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 04:43:49 -0500
Date: Tue, 6 Nov 2018 19:15:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 4/7] tools/lib/traceevent: Implement libtraceevent man
 pages
Message-ID: <20181106191556.4b199def@gandalf.local.home>
In-Reply-To: <20181106132035.7692-5-tstoyanov@vmware.com>
References: <20181106132035.7692-1-tstoyanov@vmware.com>
        <20181106132035.7692-5-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 6 Nov 2018 13:20:53 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements a man page, which documents
> tep_is_host_bigendian() and tep_set_host_bigendian()
> libtraceevent APIs
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-host_endian.txt             | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> new file mode 100644
> index 000000000000..23e085db8d54
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> @@ -0,0 +1,85 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_is_host_bigendian,tep_set_host_bigendian - Get / set the endianess of the local host.

Probably need to state more about the endianness of the machine running
the code. That is, the local host represents the machine executing the
current code.

-- Steve


> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +enum *tep_endian* {
> +	TEP_LITTLE_ENDIAN = 0,
> +	TEP_BIG_ENDIAN
> +};
> +
> +int *tep_is_host_bigendian*(struct tep_handle pass:[*]_tep_);
> +void *tep_set_host_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_is_host_bigendian()_ function returns the endianess of the local host 
> +The _tep_ argument is trace event parser context.
> +
> +The _tep_set_host_bigendian()_ set the endianess of the local host.
> +The _tep_ argument is trace event parser context. The _endian_ argument is the endianess:
> +	_TEP_LITTLE_ENDIAN_ - the host is little endian,
> +	_TEP_BIG_ENDIAN_ - the host is big endian.
> +
> +RETURN VALUE
> +------------
> +The _tep_is_host_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP_BIG_ENDIAN_.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	tep_set_host_bigendian(tep, TEP_LITTLE_ENDIAN);
> +...
> +	if (TEP_BIG_ENDIAN == tep_is_host_bigendian(tep)) {
> +		/* The local host is big endian */
> +	} else {
> +		/* The local host is little endian */
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
