Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3377C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 16:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BEC6206C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 16:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732221AbfAPQct (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:32:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405697AbfAPQct (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 11:32:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205A520657;
        Wed, 16 Jan 2019 16:32:48 +0000 (UTC)
Date:   Wed, 16 Jan 2019 11:32:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 07/46] tools/lib/traceevent: Man page for
 tep_get_cpus() and tep_set_cpus()
Message-ID: <20190116113246.3fd6258e@gandalf.local.home>
In-Reply-To: <20181127154153.11315-8-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
        <20181127154153.11315-8-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 27 Nov 2018 15:42:15 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_get_cpus() and tep_set_cpus() as part of the
> libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-cpus.txt      | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
> new file mode 100644
> index 000000000000..81d9b4c83bee
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
> @@ -0,0 +1,78 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_get_cpus,tep_set_cpus - Get / set the number of CPUs, which have tracing 
> +data recorded.

A better way to say this is:

"which have a tracing buffer representing it. Note, the buffer may be
empty".

That's because the way it is currently written sounds like empty
buffers wont be counted.

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
> +The _tep_get_cpus()_ function gets the number of CPUs, which have tracing 
> +data recorded in the _tep_ context. The _tep_ argument is trace event parser 
> +context.
> +
> +The _tep_set_cpus()_ function sets the number of CPUs, which have tracing 
> +data recorded. The _tep_ argument is trace event parser context. The _cpu_
> +argument is the number of CPUs with tracing data.

Update these too.

Thanks!

(also make sure the next patch is run through checkpatch to make sure
it doesn't have any whitespace errors).

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

