Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7C2C4332B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 02:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0441664ED5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 02:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhBSCEh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 21:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhBSCEg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 21:04:36 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 194E464ECF;
        Fri, 19 Feb 2021 02:03:55 +0000 (UTC)
Date:   Thu, 18 Feb 2021 21:03:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
Message-ID: <20210218210352.61470b93@oasis.local.home>
In-Reply-To: <20201203060226.476475-6-tz.stoyanov@gmail.com>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
 <20201203060226.476475-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  3 Dec 2020 08:02:26 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int perf_mmap(struct perf_cpu *perf)
> +{
> +	mmap_mask = NUM_PAGES * getpagesize() - 1;
> +
> +	/* associate a buffer with the file */
> +	perf->mpage = mmap(NULL, (NUM_PAGES + 1) * getpagesize(),
> +			PROT_READ | PROT_WRITE, MAP_SHARED, perf->perf_fd, 0);
> +	if (perf->mpage == MAP_FAILED)
> +		return -1;
> +	return 0;
> +}

BTW, I found that the above holds the conversions we need for the local
clock!

        printf("time_shift=%d\n", perf->mpage->time_shift);
        printf("time_mult=%d\n", perf->mpage->time_mult);
        printf("time_offset=%lld\n", perf->mpage->time_offset);

Which gives me:

time_shift=31
time_mult=633046315
time_offset=-115773323084683

[ one for each CPU ]

The ftrace local clock is defined by:

u64 notrace trace_clock_local(void)
{
	u64 clock;
	preempt_disable_notrace();
	clock = sched_clock();
	preempt_enable_notrace();
	return clock;
}

Where

u64 sched_clock(void)
{
	if (static_branch_likely(&__use_tsc)) { // true
		u64 tsc_now = rdtsc();

		/* return the value in ns */
		return cycles_2_ns(tsc_now);
	}

and

static __always_inline unsigned long long cycles_2_ns(unsigned long long cyc)
{
	struct cyc2ns_data data;
	unsigned long long ns;

	cyc2ns_read_begin(&data); // <- this is where the data comes from

	ns = data.cyc2ns_offset;
	ns += mul_u64_u32_shr(cyc, data.cyc2ns_mul, data.cyc2ns_shift);

	cyc2ns_read_end();

	return ns;
}

__always_inline void cyc2ns_read_begin(struct cyc2ns_data *data)
{
	int seq, idx;

	preempt_disable_notrace();

	do {
		seq = this_cpu_read(cyc2ns.seq.seqcount.sequence);
		idx = seq & 1;

		data->cyc2ns_offset = this_cpu_read(cyc2ns.data[idx].cyc2ns_offset);
		data->cyc2ns_mul    = this_cpu_read(cyc2ns.data[idx].cyc2ns_mul);
		data->cyc2ns_shift  = this_cpu_read(cyc2ns.data[idx].cyc2ns_shift);

	} while (unlikely(seq != this_cpu_read(cyc2ns.seq.seqcount.sequence)));
}

The offset, multiplier and shift are from the cyc2ns.data[idx] (per
cpu) is what determines the conversion from x86 cycles to nanoseconds.

Does user space have access to that? Yes! Via perf!

void arch_perf_update_userpage(struct perf_event *event,
			       struct perf_event_mmap_page *userpg, u64 now)
{
[..]
	cyc2ns_read_begin(&data);

	offset = data.cyc2ns_offset + __sched_clock_offset;

	/*
	 * Internal timekeeping for enabled/running/stopped times
	 * is always in the local_clock domain.
	 */
	userpg->cap_user_time = 1;
	userpg->time_mult = data.cyc2ns_mul;
	userpg->time_shift = data.cyc2ns_shift;
	userpg->time_offset = offset - now;

Those above values are the ones I printed at the beginning of this
email.

Hence, we can use x86-tsc as the clock for both the host and guest, and
then using perf find out how to convert that to what the 'local' clock
would produce. At least the multiplier and the shfit.

-- Steve
