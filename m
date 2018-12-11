Return-Path: <SRS0=Vqi0=OU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbeLKQ5A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Dec 2018 11:57:00 -0500
Date: Tue, 11 Dec 2018 11:56:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tools/lib/traceevent: make libtraceevent thread
 safe
Message-ID: <20181211115657.31468fe5@gandalf.local.home>
In-Reply-To: <20181205092200.2291-2-tstoyanov@vmware.com>
References: <20181205092200.2291-1-tstoyanov@vmware.com>
        <20181205092200.2291-2-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 5 Dec 2018 09:22:12 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +void set_thread_local_event_cache(struct tep_handle *tep, struct tep_event *event)
> +{
> +	tep_thread_local.tep = tep;
> +	tep_thread_local.last_event = event;
> +}
> +
> +

FYI,

Your file ended up with an extra blank line at the end. I deleted it,
but that does make git complain when applying this patch.

-- Steve

> diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
> index bc35dc8..cacdcc4 100644
