Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966F9C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C21823403
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbhAGQhw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbhAGQhv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:37:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E72422342C;
        Thu,  7 Jan 2021 16:37:10 +0000 (UTC)
Date:   Thu, 7 Jan 2021 11:37:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/6] libtracefs: Documentation for enable / disable
 tracing APIs
Message-ID: <20210107113709.16d05842@gandalf.local.home>
In-Reply-To: <20210107083250.16295-5-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
        <20210107083250.16295-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jan 2021 10:32:48 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> New man pages with documentation about:
>  tracefs_trace_is_on();
>  tracefs_trace_on();
>  tracefs_trace_off();
>  tracefs_trace_on_fd();
>  tracefs_trace_off_fd();
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-traceon.txt | 143 +++++++++++++++++++++++++++
>  1 file changed, 143 insertions(+)
>  create mode 100644 Documentation/libtracefs-traceon.txt
> 
> diff --git a/Documentation/libtracefs-traceon.txt b/Documentation/libtracefs-traceon.txt
> new file mode 100644
> index 0000000..af4b7f7
> --- /dev/null
> +++ b/Documentation/libtracefs-traceon.txt
> @@ -0,0 +1,143 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_trace_is_on, tracefs_trace_on, tracefs_trace_off, tracefs_trace_on_fd,
> +tracefs_trace_off_fd - Functions to enable or disable tracing.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
> +int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
> +int *tracefs_trace_off*(struct tracefs_instance pass:[*]_instance_);
> +int *tracefs_trace_on_fd*(int _fd_);
> +int *tracefs_trace_off_fd*(int _fd_);
> +--
> +
> +DESCRIPTION
> +-----------
> +This set of functions can be used to check, enable or disable writing to the ring buffer in
> +the given trace instance. The tracing is enabled when writing to the ring buffer is enabled.
> +
> +The _tracefs_trace_is_on()_ function checks if tracing is enabled for the given _instance_. If
> +_instance_ is NULL, the top instance is used.
> +
> +The _tracefs_trace_on()_ and _tracefs_trace_off()_ functions set the tracing in the _instance_
> +to enable or disable state. If _instance_ is NULL, the top instance is used.
> +
> +The _tracefs_trace_on_fd()_ and _tracefs_trace_off_fd()_ functions set the tracing state to enable
> +or disable using the given _fd_. This file descriptor must be opened for writing with
> +*tracefs_instance_file_open*(3) for *tracing_on* file from desired trace instance. These functions
> +are faster than *tracefs_trace_on* and *tracefs_trace_off*.

Hmm, I think this should also add "tracefs_trace_on_get_fd()" that returns
a file descriptor on "tracing_on" on the given instance opened with O_RDWR.

	fd = tracefs_trace_on_get_fd(NULL);
	tracefs_trace_on_fd(fd);
	close(fd);

Would be the same as:

	tracefs_trace_on(NULL);

-- Steve

