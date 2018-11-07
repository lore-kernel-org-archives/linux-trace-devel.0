Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbeKGJl7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 04:41:59 -0500
Date: Tue, 6 Nov 2018 19:14:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/7] tools/lib/traceevent: Implement libtraceevent man
 pages
Message-ID: <20181106191406.70ec2ed5@gandalf.local.home>
In-Reply-To: <20181106132035.7692-4-tstoyanov@vmware.com>
References: <20181106132035.7692-1-tstoyanov@vmware.com>
        <20181106132035.7692-4-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 6 Nov 2018 13:20:52 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements a man page, which documents
> tep_is_file_bigendian() and tep_set_file_bigendian()
> libtraceevent APIs
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-file_endian.txt             | 87 +++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
> new file mode 100644
> index 000000000000..403db4e23b3f
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
> @@ -0,0 +1,87 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_is_file_bigendian,tep_set_file_bigendian - Get / set the endianess of the 
> +trace.dat file 

We shouldn't mention trace.dat as libtraceevent isn't associated with
that. The trace.dat file is for trace-cmd but not perf, or other tools
using this library.

Instead reference it as, is the raw data read big endian or not. The
tep_set_file_bigendian means that the raw data being accessed by the
tep handler, is big endian. This allows the tep operations know if the
data read from the raw data matches the host endianess.

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
> +int *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
> +void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
> +
> +--
> +DESCRIPTION
> +-----------
> +The _tep_is_file_bigendian()_ function returns the endianess of the trace.dat file. 
> +The _tep_ argument is trace event parser context.
> +
> +The _tep_set_file_bigendian()_ set the endianess of the trace.dat file.
> +The _tep_ argument is trace event parser context. The _endian_ argument is the endianess:
> +	_TEP_LITTLE_ENDIAN_ - the file is in little endian format,
> +	_TEP_BIG_ENDIAN_ - the file is in big endian format.
> +This information is saved in the trace.dat file.
> +
> +RETURN VALUE
> +------------
> +The _tep_is_file_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP_BIG_ENDIAN_.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	tep_set_file_bigendian(tep, TEP_LITTLE_ENDIAN);
> +...
> +	if (TEP_BIG_ENDIAN == tep_is_file_bigendian(tep)) {
> +		/* The file is in big endian */
> +	} else {
> +		/* The file is in little endian */
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
