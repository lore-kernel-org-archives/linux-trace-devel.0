Return-Path: <SRS0=PQ4s=S4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B32C43218
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14EAD2084F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfDZCla (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 22:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfDZCla (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 22:41:30 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C978206BA;
        Fri, 26 Apr 2019 02:41:29 +0000 (UTC)
Date:   Thu, 25 Apr 2019 22:41:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 09/30] tools/lib/traceevent: Man page for
 tep_strerror()
Message-ID: <20190425224127.3297ea1d@oasis.local.home>
In-Reply-To: <20190412133811.15878-10-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-10-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:50 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man page for tep_strerror() libtraceevent API.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-strerror.txt  | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
> new file mode 100644
> index 000000000000..b3d625d01a8d
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
> @@ -0,0 +1,80 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_strerror - Returns a string describing regular errno and tep error number.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
> +
> +--
> +DESCRIPTION
> +-----------
> +The _tep_strerror()_ function converts tep error number into a human
> +readable string.
> +The _tep_ argument is trace event parser context. The _errnum_ is a regular
> +errno, defined in errno.h, or a tep error number. The string, describing this
> +error number is copied in the _buf_ argument. The _buflen_ argument is
> +the size of the _buf_.

We should state that this is a thread safe version of strerror_r() but
is used because of the two different versions of strerror_r() depending
on GNU_SOURCE or not.

-- Steve

> +
> +RETURN VALUE
> +------------
> +The _tep_strerror()_ function returns 0, if a valid _errnum_ is
> passed and the +string is copied into _buf_. If _errnum_ is not a
> valid error number, +-1 is returned and _buf_ is not modified.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +char buf[32];
> +char *pool = calloc(1, 128);
> +if (tep == NULL) {
> +	tep_strerror(tep, TEP_ERRNO__MEM_ALLOC_FAILED, buf, 32);
> +	printf ("The pool is not initialized, %s", buf);
> +}
> +...
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

