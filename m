Return-Path: <SRS0=PQ4s=S4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1D8C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 01:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1924320878
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 01:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfDZBxo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 21:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfDZBxo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 21:53:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CCBA206C1;
        Fri, 26 Apr 2019 01:53:43 +0000 (UTC)
Date:   Thu, 25 Apr 2019 21:53:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 04/30] tools/lib/traceevent: Man page for header_page
 APIs
Message-ID: <20190425215340.7881aaa3@oasis.local.home>
In-Reply-To: <20190412133811.15878-5-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-5-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:45 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create a man page for libtraceevent APIs:
>   tep_get_header_page_size(),
>   tep_get_header_timestamp_size(),
>   tep_is_old_format()
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-header_page.txt             | 105 ++++++++++++++++++
>  1 file changed, 105 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt b/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
> new file mode 100644
> index 000000000000..e1bd664ac123
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
> @@ -0,0 +1,105 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_get_header_page_size, tep_get_header_timestamp_size, tep_is_old_format -
> +Get the data stored in the header page, in kernel context.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
> +int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
> +bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
> +--
> +DESCRIPTION
> +-----------
> +These functions retrieve information from kernel context, stored in
> +/sys/kernel/debug/tracing/events/header_page. Old kernels do not have header

Let's avoid using full path names. This should be:

 stored in the tracefs events/header_page.


> +page info, so default values from user space context are used.
> +
> +The _tep_get_header_page_size()_ function returns the size of a long integer,
> +in kernel context. The _tep_ argument is trace event parser context.
> +This information is retrieved from /sys/kernel/debug/tracing/events/header_page,

Same here.

> + "commit" field.
> +
> +The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
> +in kernel context. The _tep_ argument is trace event parser context.
> +This information is retrieved from /sys/kernel/debug/tracing/events/header_page,

and here.

> + "timestamp" field.
> +
> +The _tep_is_old_format()_ function  returns if the kernel is old one and has no

The _tep_is_old_format()_ function returns true if the kernel predates
the addition of events/header_page, otherwise it returns false.


> +/sys/kernel/debug/tracing/events/header_page.
> +
> +RETURN VALUE
> +------------
> +The _tep_get_header_page_size()_ function returns the size of a long integer,
> +in bytes.
> +
> +The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
> +in bytes.
> +
> +The _tep_is_old_format()_ function returns true, if an old kernel is used to
> +generate the tracing data, which has no
> +/sys/kernel/debug/tracing/events/header_page. If the kernel is new, or _tep_ is

Just say "no event/header_page"

-- Steve

> +NULL, false is returned.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	int longsize;
> +	int timesize;
> +	bool old;
> +
> +	longsize = tep_get_header_page_size(tep);
> +	timesize = tep_get_header_timestamp_size(tep);
> +	old = tep_is_old_format(tep);
> +
> +	printf ("%s kernel is used to generate the tracing data.\n",
> +		old?"Old":"New");
> +	printf("The size of a long integer is %d bytes.\n", longsize);
> +	printf("The timestamps size is %d bytes.\n", timesize);
> +...
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

