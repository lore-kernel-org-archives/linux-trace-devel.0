Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704F9C636CA
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Jul 2021 03:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B88761009
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Jul 2021 03:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhGQDDX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Jul 2021 23:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232547AbhGQDDX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Jul 2021 23:03:23 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F6761009;
        Sat, 17 Jul 2021 03:00:27 +0000 (UTC)
Date:   Fri, 16 Jul 2021 23:00:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH] libtracefs: Remove "traceevent/" from referencing
 libtraceevent headers
Message-ID: <20210716230025.03dbe106@rorschach.local.home>
In-Reply-To: <20210716220649.46aab3f7@rorschach.local.home>
References: <20210716220649.46aab3f7@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


John,

It was libtracefs that had the flaw that made trace-cmd 2.9 fail to build.
This patch fixes it. I pushed it to the main branch, and also released
a libtracefs-1.2.3 that has this fix as well.

-- Steve


On Fri, 16 Jul 2021 22:06:49 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> "pkg-config --cflags --libtraceevent" produces the full path to the
> libtraceevent headers (including the "traceevent/" portion). There is no
> need to add that part in the headers.
> 
> Particularly the one in the main tracefs.h that trace-cmd uses. The
> version 2.9.4 causes the header to include the libtraceevent/event-parse.h
> that is local, when it should be using the system headers, and causes it
> to fail the build.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  include/tracefs.h    | 2 +-
>  src/tracefs-events.c | 2 +-
>  src/tracefs-utils.c  | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 7e1927b..2649417 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -9,7 +9,7 @@
>  #include <sys/stat.h>
>  #include <fcntl.h>
>  #include <sched.h>
> -#include <traceevent/event-parse.h>
> +#include <event-parse.h>
>  
>  char *tracefs_get_tracing_file(const char *name);
>  void tracefs_put_tracing_file(char *name);
> diff --git a/src/tracefs-events.c b/src/tracefs-events.c
> index 7febc2a..8d84838 100644
> --- a/src/tracefs-events.c
> +++ b/src/tracefs-events.c
> @@ -15,7 +15,7 @@
>  #include <fcntl.h>
>  #include <limits.h>
>  
> -#include <traceevent/kbuffer.h>
> +#include <kbuffer.h>
>  
>  #include "tracefs.h"
>  #include "tracefs-local.h"
> diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
> index 6750336..600cdf2 100644
> --- a/src/tracefs-utils.c
> +++ b/src/tracefs-utils.c
> @@ -15,8 +15,8 @@
>  #include <unistd.h>
>  #include <errno.h>
>  
> -#include <traceevent/event-parse.h>
> -#include <traceevent/event-utils.h>
> +#include <event-parse.h>
> +#include <event-utils.h>
>  #include "tracefs.h"
>  #include "tracefs-local.h"
>  

