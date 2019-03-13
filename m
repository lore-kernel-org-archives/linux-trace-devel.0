Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298BFC10F03
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076002075C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfCMTLb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbfCMTLa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:11:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D622173C;
        Wed, 13 Mar 2019 19:11:29 +0000 (UTC)
Date:   Wed, 13 Mar 2019 15:11:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 27/46] tools/lib/traceevent: Man pages for
 tep_filter_alloc(), tep_filter_free() and tep_filter_reset()
Message-ID: <20190313151127.3dbd014b@gandalf.local.home>
In-Reply-To: <20190308133654.21264-28-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-28-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:35 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages tep_filter_alloc(), tep_filter_free() and tep_filter_reset()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-filter.txt    | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter.txt
> new file mode 100644
> index 000000000000..6335bcc10c6c
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-filter.txt
> @@ -0,0 +1,85 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_filter_alloc,tep_filter_free,tep_filter_reset - Create / free / reset an event filter.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass:[*]_tep_);
> +void *tep_filter_free*(struct tep_event_filter pass:[*]_filter_);
> +void *tep_filter_reset*(struct tep_event_filter pass:[*]_filter_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_filter_alloc()_ function creates a new event filter. The _tep_ argument
> +is the trace event parser context.

We need more description on what a filter is. Hmm, perhaps we should
make all the filter functions in one man page. This way the one man
page can show how filters are used.

That is, combine this patch with the next 4 patches.

-- Steve

> +
> +The _tep_filter_free()_ function frees an event filter and all resources that it
> +had used.
> +
> +The _tep_filter_reset()_ function removes all rules from an event filter and
> +resets it.
> +
> +RETURN VALUE
> +------------
> +The _tep_filter_alloc()_ function returns a pointer to the newly created event
> +filter, or NULL in case of an error.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +struct tep_event_filter *filter = tep_filter_alloc(tep);
> +if (filter == NULL) {
> +	/* Failed to create the filter */
> +}
> +...
> +tep_filter_reset(filter);
> +...
> +tep_filter_free(filter);
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

