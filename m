Return-Path: <SRS0=PQ4s=S4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61CFC43218
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2B7020878
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfDZCBm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 22:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfDZCBm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 22:01:42 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46421206C1;
        Fri, 26 Apr 2019 02:01:41 +0000 (UTC)
Date:   Thu, 25 Apr 2019 22:01:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 07/30] tools/lib/traceevent: Man page for host endian
 APIs
Message-ID: <20190425220139.50eacb33@oasis.local.home>
In-Reply-To: <20190412133811.15878-8-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-8-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:48 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for libtraceevent APIs:
>   tep_is_bigendian(),
>   tep_is_local_bigendian(),
>   tep_set_local_bigendian()
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-host_endian.txt             | 106 ++++++++++++++++++
>  1 file changed, 106 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> new file mode 100644
> index 000000000000..f313d64c4e7e
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> @@ -0,0 +1,106 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_is_bigendian, tep_is_local_bigendian, tep_set_local_bigendian - Get / set
> +the endianness of the local machine.
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
> +int *tep_is_bigendian*(void);
> +bool *tep_is_local_bigendian*(struct tep_handle pass:[*]_tep_);
> +void *tep_set_local_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
> +--
> +
> +DESCRIPTION
> +-----------
> +
> +The _tep_is_bigendian()_ gets the endianness of the machine, executing
> +the function.
> +
> +The _tep_is_local_bigendian()_ function gets the endianness of the local
> +machine, saved in the _tep_ handler. The _tep_ argument is the trace event
> +parser context.

We probably should reference somewhere that using
tep_is_local_bigendian() is a bit faster than calling
tep_is_bigendian() even though they should return the same result. This
allows the calculation of determining if the running machine is big
endian or not to be cached in the tep handler.

> +
> +The _tep_set_local_bigendian()_ function sets the endianness of the local
> +machine in the _tep_ handler. The _tep_ argument is trace event parser context.
> +The _endian_ argument is the endianness:
> +[verse]
> +--
> +	_TEP_LITTLE_ENDIAN_ - the machine is little endian,
> +	_TEP_BIG_ENDIAN_ - the machine is big endian.
> +--
> +
> +RETURN VALUE
> +------------
> +The _tep_is_bigendian()_ function returns non zero if the endianness of the
> +machine, executing the code, is big endian and zero otherwise.
> +
> +The _tep_is_local_bigendian()_ function returns true, if the endianness of the
> +local machine, saved in the _tep_ handler, is big endian, or false otherwise.
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

Looks like we slipped in a host. Anyway, it would be more logical to do
this the way it would be used instead of just showing calls to these
functions.

	struct tep_handle *tep = tep_alloc();

	if (tep_is_bigendian())
		tep_set_local_bigendian(tep, TEP_BIG_ENDIAN);
	else
		tep_set_local_bigendian(tep, TEP_LITTLE_ENDIAN);

	if (tep_is_local_bigendian(tep))
		printf("This machine you are running on is bigendian\n");

-- Steve

> +...
> +	if (tep_is_local_bigendian(tep)) {
> +		/* The stored local host endian is big */
> +	} else {
> +		/* The stored local host endian is little */
> +	}
> +...
> +	if (tep_is_bigendian()) {
> +		/* The local host endian is big */
> +	} else {
> +		/* The local host endian is little */
> +	}
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the
> library APIs. +*-ltraceevent*
> +	Linker switch to add when building a program that uses the
> library. +--
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
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man
> page. +--
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

