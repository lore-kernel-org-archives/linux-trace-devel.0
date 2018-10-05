Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:60334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbeJEX2P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 19:28:15 -0400
Date: Fri, 5 Oct 2018 12:28:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20181005122846.4b974dbd@gandalf.local.home>
In-Reply-To: <20181005122225.522155df@gandalf.local.home>
References: <20181005122225.522155df@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 5 Oct 2018 12:22:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> +/**
> + * tep_get_first_event - returns the first event in the events array
> + * @tep: a handle to the tep_handle
> + *
> + * This returns pointer to the first element of the events array
> + * If @tep is NULL, NULL is returned.
> + */
> +struct tep_event_format *tep_get_first_event(struct tep_handle *tep)
> +{
> +	if(tep && tep->events)
> +		return tep->events[0];
> +
> +	return NULL;
> +}
> +

Hold off on pulling this in. This patch has some whitespace issues that
need to be cleaned up.

Thanks!

-- Steve
