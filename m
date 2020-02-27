Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E73CC4BA06
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 03:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C5E2468A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 03:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgB0D4P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 22:56:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgB0D4P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 22:56:15 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8495F24650;
        Thu, 27 Feb 2020 03:56:14 +0000 (UTC)
Date:   Wed, 26 Feb 2020 22:56:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v19 10/15] trace-cmd: Add guest information in host's
 trace.dat file
Message-ID: <20200226225613.08a0c7bd@oasis.local.home>
In-Reply-To: <20200131121111.130355-11-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
        <20200131121111.130355-11-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 31 Jan 2020 14:11:06 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int trace_guest_load(struct tracecmd_input *handle, char *buf, int size)
> +{
> +	struct guest_trace_info *guest = NULL;
> +	int cpu;
> +	int i;
> +
> +	guest = calloc(1, sizeof(struct guest_trace_info));
> +	if (!guest)
> +		goto error;
> +
> +	/*
> +	 * Guest name, null terminated string
> +	 * long long (8 bytes) trace-id
> +	 * int (4 bytes) number of guest CPUs
> +	 * array of size number of guest CPUs:
> +	 *	int (4 bytes) Guest CPU id
> +	 *	int (4 bytes) Host PID, running the guest CPU
> +	 */
> +
> +	guest->name = strndup(buf, size);
> +	if (!guest->name)
> +		goto error;
> +	buf += strlen(guest->name) + 1;
> +	size -= strlen(guest->name) + 1;
> +
> +	if (size < sizeof(long long))
> +		goto error;
> +	guest->trace_id = tep_read_number(handle->pevent, buf, sizeof(long long));
> +	buf += sizeof(long long);

Don't we need:

	size -= sizeof(long long);

> +
> +	if (size < sizeof(int))
> +		goto error;
> +	guest->vcpu_count = tep_read_number(handle->pevent, buf, sizeof(int));
> +	buf += sizeof(int);

	size -= sizeof(int);

> +
> +	guest->cpu_pid = calloc(guest->vcpu_count, sizeof(int));
> +	if (!guest->cpu_pid)
> +		goto error;
> +
> +	for (i = 0; i < guest->vcpu_count; i++) {
> +		if (size < 2 * sizeof(int))
> +			goto error;
> +		cpu = tep_read_number(handle->pevent, buf, sizeof(int));
> +		buf += sizeof(int);
> +		if (cpu >= guest->vcpu_count)
> +			goto error;
> +		guest->cpu_pid[cpu] = tep_read_number(handle->pevent,
> +						      buf, sizeof(int));
> +		buf += sizeof(int);

		size -= 2 * sizeof(int);

-- Steve

> +	}
> +
> +	guest->next = handle->guest;
> +	handle->guest = guest;
> +	return 0;
> +
> +error:
> +	if (guest) {
> +		free(guest->cpu_pid);
> +		free(guest->name);
> +		free(guest);
> +	}
> +	return -1;
> +}
> +
