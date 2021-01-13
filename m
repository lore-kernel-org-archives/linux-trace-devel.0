Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31BFC433E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 02:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B752242A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 02:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbhANCKe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbhAMWSv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jan 2021 17:18:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597BC23136;
        Wed, 13 Jan 2021 22:18:10 +0000 (UTC)
Date:   Wed, 13 Jan 2021 17:18:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/6] trace-cmd library man pages: Read recorded events
 from a trace file.
Message-ID: <20210113171808.23c7cf5e@gandalf.local.home>
In-Reply-To: <20201223043429.586162-4-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
        <20201223043429.586162-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


I think the below example should be also used in the tracecmd_open_head()
man page. That's because the current example in tracecmd_open_head() is
rather useless as nothing really can be done without the
tracecmd_init_data() call. By using the below example in the
tracecmd_open_head() page, it will show people a more informative way of
using that call.

Note, these man pages are already applied, any update should be done on top
of the current repo.

-- Steve


On Wed, 23 Dec 2020 06:34:26 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <trace-cmd.h>
> +...
> +struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
> +	if (!handle) {
> +		/* Failed to open trace.dat file */
> +	}
> +...
> +unsigned long long offset = 0;
> +struct tep_record *rec;
> +int cpu = 0;
> +
> +	if (tracecmd_init_data(handle) < 0) {
> +		/* Failed to initialize hadle for reading the trace data */
> +	}
> +
> +	rec = tracecmd_read_cpu_first(handle, cpu);
> +	while (rec) {
> +		...
> +		if ( /* some interesting record noticed */) {
> +			/* store the offset of the interesting record */
> +			offset = rec->offset;
> +		}
> +		...
> +		tracecmd_free_record(rec);
> +		rec = tracecmd_read_data(handle, cpu);
> +	}
> +	...
> +	if (offset) {
> +		rec = tracecmd_read_at(handle, offset, &cpu);
> +		if (rec) {
> +			/* Got record at offset on cpu */
> +			...
> +			tracecmd_free_record(rec);
> +		}
> +	}
> +
> +...
> +	tracecmd_close(hadle);
> +
