Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFB1C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 00:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D73C619E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 00:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhCXAra (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 20:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233932AbhCXArO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 20:47:14 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D3A619E5;
        Wed, 24 Mar 2021 00:47:11 +0000 (UTC)
Date:   Tue, 23 Mar 2021 20:47:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 01/18] trace-cmd: Add initial perf interface in
 trace-cmd library
Message-ID: <20210323204709.675d18ca@oasis.local.home>
In-Reply-To: <20210322095945.259300-2-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
        <20210322095945.259300-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 11:59:28 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +void trace_perf_close(struct trace_perf *perf)
> +{
> +	if (perf->fd >= 0)
> +		close(perf->fd);
> +	perf->fd = -1;
> +	if (perf->mmap)

The above should be:

	if (perf->mmap && perf->mmap != MAP_FAILED)

-- Steve

> +		munmap(perf->mmap, (perf->pages + 1) * getpagesize());
> +	perf->mmap = NULL;
> +}
> +
> +/**
> + * trace_perf_open - Open perf session
> + *
> + * @perf: structure, representing perf context that will be opened. It must be
> + *	  initialized with trace_perf_init().
> + *
> + * Returns 0 on success, or -1 in case of an error. In case of success, the
> + * session must be closed with trace_perf_close()
> + */
> +int trace_perf_open(struct trace_perf *perf)
> +{
> +	perf->fd = syscall(__NR_perf_event_open, &perf->pe, perf->pid, perf->cpu, -1, 0);
> +	if (perf->fd < 0)
> +		return -1;
> +	fcntl(perf->fd, F_SETFL, O_NONBLOCK);
> +
> +	perf->mmap = mmap(NULL, (perf->pages + 1) * getpagesize(),
> +			  PROT_READ | PROT_WRITE, MAP_SHARED, perf->fd, 0);
> +	if (perf->mmap == MAP_FAILED)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	trace_perf_close(perf);
> +	return -1;
> +}

