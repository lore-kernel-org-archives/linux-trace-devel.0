Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CB8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 23:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351410AbhLGACR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 19:02:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33624 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbhLGACR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 19:02:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA98BCE1869
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 23:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0903C004DD;
        Mon,  6 Dec 2021 23:58:44 +0000 (UTC)
Date:   Mon, 6 Dec 2021 18:58:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] libtracefs: New API for getting the raw format of a
 histogram
Message-ID: <20211206185843.6b721000@gandalf.local.home>
In-Reply-To: <20211206150855.361202-2-y.karadz@gmail.com>
References: <20211206150855.361202-1-y.karadz@gmail.com>
        <20211206150855.361202-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Dec 2021 17:08:53 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +/*
> + * tracefs_hist_echo_fmt - show the raw format of the histogram
> + * @seq: A trace_seq to store the format string
> + * @hist: The histogram to read format from
> + *
> + * This show the raw format that describes the state of the histogram.
> + *
> + * Returns the size of the format string on succes -1 on error.
> + */
> +int tracefs_hist_echo_fmt(struct trace_seq *seq,
> +			  struct tracefs_instance *instance,
> +			  struct tracefs_hist *hist)
> +{
> +	const char *event = hist->event_name;
> +	const char *system = hist->system;
> +	int fmt_size;
> +	char *path;
> +	char *fmt;
> +
> +	path = tracefs_event_get_file(instance, system, event, "trigger");
> +	if (!path)
> +		return -1;
> +
> +	fmt = tracefs_event_file_read(instance, system, event, path,
> +				      &fmt_size);

First, path should just be "trigger" as tracefs_event_file_read() is a
short cut to get to the files for the event. I'm surprised that this even
worked.

> +	if (!fmt)
> +		return -1;
> +
> +	trace_seq_puts(seq, fmt);

Second, just reading the trigger file is not useful, as the trigger file
holds triggers, not just histograms. And you can have more than one
histogram in the trigger file. For instance, I could do:

 # cd /sys/kernel/debug/tracing/events/sched/sched_switch
 # echo stacktrace > trigger
 # echo 'hist:keys=prev_pid' >> trigger
 # echo 'hist:keys=next_pid' >> trigger
 # cat trigger
stacktrace:unlimited
hist:keys=prev_pid:vals=hitcount:sort=hitcount:size=2048 [active]
hist:keys=next_pid:vals=hitcount:sort=hitcount:size=2048 [active]

Is this really what you want?

-- Steve

> +	tracefs_put_tracing_file(path);
> +
> +	return fmt_size;
> +}
> +
>  /*
>   * tracefs_hist_command - Create, start, pause, destroy a histogram for an event
>   * @instance: The instance the histogram will be in (NULL for toplevel)

