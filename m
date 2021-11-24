Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78759C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 21:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352025AbhKXVmF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352145AbhKXVlL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 16:41:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830AC60F5B;
        Wed, 24 Nov 2021 21:38:00 +0000 (UTC)
Date:   Wed, 24 Nov 2021 16:37:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V7 02/14] rtla: Helper functions for rtla
Message-ID: <20211124163759.6d118d96@gandalf.local.home>
In-Reply-To: <1eb27af1d8356d17d1f8a69a362da46ae8594ab0.1635535309.git.bristot@kernel.org>
References: <cover.1635535309.git.bristot@kernel.org>
        <1eb27af1d8356d17d1f8a69a362da46ae8594ab0.1635535309.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 Oct 2021 21:26:05 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> +/*
> + * enable_tracer_by_name - enable a tracer on the given instance
> + */
> +int enable_tracer_by_name(struct tracefs_instance *inst, const char *tracer)
> +{
> +	enum tracefs_tracers t;
> +	int retval;
> +
> +	t = TRACEFS_TRACER_CUSTOM;
> +
> +	debug_msg("enabling %s tracer\n", tracer);
> +
> +	retval = tracefs_tracer_set(inst, t, tracer);

Interesting. We had discussions about having the custom option (which I
fought for, for this very reason).

> +	if (retval < 0) {
> +		if (errno == ENODEV)
> +			err_msg("tracer %s not found!\n", tracer);
> +
> +		err_msg("failed to enable the tracer %s\n", tracer);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * disable_tracer - set nop tracer to the insta
> + */
> +void disable_tracer(struct tracefs_instance *inst)
> +{
> +	enum tracefs_tracers t = TRACEFS_TRACER_NOP;
> +	int retval;
> +
> +	retval = tracefs_tracer_set(inst, t);
> +	if (retval < 0)
> +		err_msg("oops, error disabling tracer\n");
> +}
> +
> +/*
> + * create_instance - create a trace instance with *instance_name
> + */
> +struct tracefs_instance *create_instance(char *instance_name)
> +{
> +	return tracefs_instance_create(instance_name);
> +}
> +
> +/*
> + * destroy_instance - remove a trace instance and free the data
> + */
> +void destroy_instance(struct tracefs_instance *inst)
> +{
> +	tracefs_instance_destroy(inst);
> +	tracefs_instance_free(inst);
> +}
> +
> +/*
> + * save_trace_to_file - save the trace output of the instance to the file
> + */
> +int save_trace_to_file(struct tracefs_instance *inst, const char *filename)
> +{
> +	const char *file = "trace";
> +	mode_t mode = 0644;
> +	char *buffer[4096];

Did you really mean to have buffer be 4096 strings?

Or did you mean:

	char buffer[4096];

(i.e. a single string of 4096 size)?

-- Steve

> +	int out_fd, in_fd;
> +	int retval = -1;
> +
> +	in_fd = tracefs_instance_file_open(inst, file, O_RDONLY);
> +	if (in_fd < 0) {
> +		err_msg("Failed to open trace file\n");
> +		return -1;
> +	}
> +
> +	out_fd = creat(filename, mode);
> +	if (out_fd < 0) {
> +		err_msg("Failed to create output file %s\n", filename);
> +		goto out_close_in;
> +	}
> +
> +	do {
> +		retval = read(in_fd, buffer, sizeof(buffer));
> +		if (retval <= 0)
> +			goto out_close;
> +
> +		retval = write(out_fd, buffer, retval);
> +		if (retval < 0)
> +			goto out_close;
> +	} while (retval > 0);
> +
> +	retval = 0;
> +out_close:
> +	close(out_fd);
> +out_close_in:
> +	close(in_fd);
> +	return retval;
> +}
> +
> +/*
