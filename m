Return-Path: <SRS0=PQ4s=S4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A21C43218
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 823092084F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfDZCiV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 22:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbfDZCiV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 22:38:21 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58F7206BA;
        Fri, 26 Apr 2019 02:38:19 +0000 (UTC)
Date:   Thu, 25 Apr 2019 22:38:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 08/30] tools/lib/traceevent: Man page for page size
 APIs
Message-ID: <20190425223817.511cc690@oasis.local.home>
In-Reply-To: <20190412133811.15878-9-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-9-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:49 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for libtraceevent APIs:
>   tep_get_page_size()
>   tep_set_page_size()
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-page_size.txt | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
> new file mode 100644
> index 000000000000..2496b2cb2980
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
> @@ -0,0 +1,80 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_get_page_size, tep_set_page_size - Get / set the size of a memory page on
> +the machine, where the trace is generated
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
> +the machine, where the trace is generated. The _tep_ argument is trace
> +event parser context.
> +
> +The _tep_set_page_size()_ function stores in the _tep_ context the size of a
> +memory page on the machine, where the trace is generated.
> +The _tep_ argument is trace event parser context.
> +The _page_size_ argument is the size of a memory page, in bytes.
> +
> +RETURN VALUE
> +------------
> +The _tep_get_page_size()_ function returns size of the memory page, in bytes.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>

Let's add:

#include <unistd.h>

> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	int page_size = 4096;

	int page_size = getpagesize();

	tep_set_page_size(tep, page_size);

	printf("The page size for this machine is %d\n", tep_get_page_size(tep));

> +	tep_set_page_size(tep, page_size);
> +	if ( 4096 != tep_get_page_size(tep)) {
> +		/* Something wrong happened, page size is not set as expected */

We don't want people thinking our code is buggy ;-)

-- Steve

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

