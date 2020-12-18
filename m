Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13262C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 18:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87AE23B7B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 18:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgLRS4C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgLRS4C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 13:56:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385E123B77;
        Fri, 18 Dec 2020 18:55:21 +0000 (UTC)
Date:   Fri, 18 Dec 2020 13:55:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/9] libtracefs man pages: APIs for locating trace
 directory and files.
Message-ID: <20201218135519.2643e7cd@gandalf.local.home>
In-Reply-To: <20201217094626.1402191-4-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Dec 2020 11:46:20 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +DESCRIPTION
> +-----------
> +This set of APIs can be used to find the full path of the trace file
> +system mount point and trace files in it.
> +
> +The _tracefs_get_tracing_file()_ function returns the full path of the
> +file with given _name_ in the trace file system. The function works
> +only with files in the trasefs main directory, it is not trace instance
> +aware. It is recommended to use _tracefs_instance_get_file()_ and
> +_tracefs_instance_get_dir()_ instead. The returned string must be freed
> +with _tracefs_put_tracing_file()_.
> +
> +The _tracefs_put_tracing_file()_ function frees trace file name,
> +returned by _tracefs_get_tracing_file()_.
> +
> +The _tracefs_find_tracing_dir()_ function finds the mount point of the
> +trace file system and returns a full path to it. If the file system is
> +not mounted, it will mount it. The returned string must be freed.

How should it be freed?

> +
> +The _tracefs_get_tracing_dir()_ function returns the full path to the
> +trace file system. In the first function call, the mount point of the
> +tracing file system is located, cached and returned. It will mount it,
> +if it is not minted. On any subsequent call the cached path is returned.
> +The return string must _not_ be freed.
> +
> +RETURN VALUE
> +------------
> +The _tracefs_get_tracing_file()_ function returns a string or NULL in case
> +of an error. The returned string must be freed with _tracefs_put_tracing_file()_.
> +
> +The _tracefs_find_tracing_dir()_ function returns a string or NULL in case
> +of an error. The returned string must be freed.

Should state how it should be freed. tracefs_put_tracing_file() or free() ?

If it is free(), then stating:

 "The returned string must be freed with free()"

is fine.

> +
> +The _tracefs_get_tracing_dir()_ function returns a constant string or NULL
> +in case of an error. The returned string must _not_ be freed.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <tracefs.h>
> +...
> +char *trace_on = tracefs_get_tracing_file("tracing_on");
> +	if (trace_on) {
> +		...
> +		tracefs_put_tracing_file(trace_on);
> +	}
> +...
> +char *trace_dir = tracefs_find_tracing_dir();
> +	if (trace_dir) {
> +		...
> +		free(trace_dir);
> +	}
> +...
> +const char *trace_dir = tracefs_get_tracing_dir();
> +

Not a very useful example ;-)  We we can fix examples at a later time. I
plan on writing a lot of example code to post, and some can make their way
into the man pages.

-- Steve
