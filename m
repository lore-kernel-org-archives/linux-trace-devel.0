Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAA4C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 16:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 104F82184E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 16:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfCNQIz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 12:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfCNQIz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 12:08:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7E32184C;
        Thu, 14 Mar 2019 16:08:54 +0000 (UTC)
Date:   Thu, 14 Mar 2019 12:08:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools lib traceevent, perf tools: Move struct
 tep_handler definition in a local header file
Message-ID: <20190314120852.592eed46@gandalf.local.home>
In-Reply-To: <20181010105105.826-1-tstoyanov@vmware.com>
References: <20181010105105.826-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Oct 2018 10:51:17 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +++ b/lib/traceevent/event-parse-api.c
> @@ -0,0 +1,401 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +
> +#include "event-parse.h"
> +#include "event-parse-local.h"
> +#include "event-utils.h"
> +
> +/**
> + * tep_get_event - returns the event with the given index
> + * @tep: a handle to the tep_handle
> + * @index: index of the requested event, in the range 0 .. nr_events
> + *
> + * This returns pointer to the element of the events array with the given index
> + * If @tep is NULL, or @index is not in the range 0 .. nr_events, NULL is returned.
> + */
> +struct tep_event_format *tep_get_event(struct tep_handle *tep, int index)
> +{
> +	if (tep && tep->events && index < tep->nr_events)
> +		return tep->events[index];
> +
> +	return NULL;
> +}

It looks like a upstream backport added this function to the
event-parse-api.c file to accommodate kernelshark.

Please be careful not to do this on backports. If you need to add
functionality, it needs to be a separate patch so that we can upstream
it. Otherwise, I get confused to see why the traceevent code is
different between trace-cmd and linux/tools when all the commits have
been added.

-- Steve

> +++ b/kernel-shark-qt/examples/datafilter.c
> @@ -83,9 +83,9 @@ int main(int argc, char **argv)
>  	puts("\n\n");
>  
>  	/* Show only "sched" events. */
> -	n_evts = kshark_ctx->pevent->nr_events;
> +	n_evts = tep_get_events_count(kshark_ctx->pevent);
>  	for (i = 0; i < n_evts; ++i) {
> -		event = kshark_ctx->pevent->events[i];
> +		event = tep_get_event(kshark_ctx->pevent, i);
>  		if (strcmp(event->system, "sched") == 0)
>  			kshark_filter_add_id(kshark_ctx, KS_SHOW_EVENT_FILTER,
>  							 event->id);
