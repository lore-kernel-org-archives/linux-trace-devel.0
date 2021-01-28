Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458CDC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 02:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC0D464DBD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 02:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhA1CKd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 21:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhA1CK1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 21:10:27 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0830460C3D;
        Thu, 28 Jan 2021 02:09:42 +0000 (UTC)
Date:   Wed, 27 Jan 2021 21:09:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v26 10/15] trace-cmd: Add timestamp synchronization per
 vCPU
Message-ID: <20210127210940.32cdb4f1@oasis.local.home>
In-Reply-To: <20210121074456.157658-11-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
        <20210121074456.157658-11-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Jan 2021 09:44:51 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

  
> -static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
> +#define safe_read(R, C) \
> +	{ if ((C) > size) return -EFAULT; \
> +	 (R) = tep_read_number(tep, buf, (C)); \
> +	 buf += (C); \
> +	 size -= (C); }
> +static int tsync_offset_load(struct tep_handle	*tep,
> +			     struct timesync_offsets *ts_offsets, char *buf, int size)
>  {
> -	struct host_trace_info *host = &handle->host;
> -	long long *buf8 = (long long *)buf;
> +	int start_size = size;
>  	int i, j;
>  
> -	for (i = 0; i < host->ts_samples_count; i++) {
> -		host->ts_samples[i].time = tep_read_number(handle->pevent,
> -							   buf8 + i, 8);
> -		host->ts_samples[i].offset = tep_read_number(handle->pevent,
> -						buf8 + host->ts_samples_count + i, 8);
> -		host->ts_samples[i].scaling = tep_read_number(handle->pevent,
> -						buf8 + (2 * host->ts_samples_count) + i, 8);
> -	}
> -	qsort(host->ts_samples, host->ts_samples_count,
> +	for (i = 0; i < ts_offsets->ts_samples_count; i++)
> +		safe_read(ts_offsets->ts_samples[i].time, 8);
> +	for (i = 0; i < ts_offsets->ts_samples_count; i++)
> +		safe_read(ts_offsets->ts_samples[i].offset, 8);
> +	for (i = 0; i < ts_offsets->ts_samples_count; i++)
> +		safe_read(ts_offsets->ts_samples[i].scaling, 8);

I like to follow the Linux kernel requirements for macros. Which is any
complex macro like the "safe_read" above, needs to be done in a
do { } while (0) loop, as it is safer to use than just brackets. Also,
perhaps even making a macro out of the loop too.

#define safe_read(R, C) 					\
	do {							\
		if (size < (C))					\
			return -EFAULT;				\
		(R) = tep_read_number(tep, buf, (C));		\
		buf += (C);					\
		size -= (C);					\
	} while (0)

#define safe_read_loop(type) 						\
	do {								\
		int i;							\
		for (i = 0; i < ts_offsets->ts_samples_count; i++)	\
			safe_read(ts_offsets->ts_samples[i].type, 8);	\
	} while (0)

Then replace all the above with;

	safe_read_loop(time);
	safe_read_loop(offset);
	safe_read_loop(scaling);


I'll look at this more tomorrow.

-- Steve

> +	qsort(ts_offsets->ts_samples, ts_offsets->ts_samples_count,
>  	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
>  	/* Filter possible samples with equal time */
> -	for (i = 0, j = 0; i < host->ts_samples_count; i++) {
> -		if (i == 0 || host->ts_samples[i].time != host->ts_samples[i-1].time)
> -			host->ts_samples[j++] = host->ts_samples[i];
> +	for (i = 0, j = 0; i < ts_offsets->ts_samples_count; i++) {
> +		if (i == 0 || ts_offsets->ts_samples[i].time != ts_offsets->ts_samples[i-1].time)
> +			ts_offsets->ts_samples[j++] = ts_offsets->ts_samples[i];
> +	}
> +	ts_offsets->ts_samples_count = j;
> +
> +	return start_size - size;
> +}
> +
