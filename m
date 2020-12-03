Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87340C83017
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 02:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EAF721D7A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 02:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgLCCKT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727681AbgLCCKS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 21:10:18 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A73B921D7A;
        Thu,  3 Dec 2020 02:09:36 +0000 (UTC)
Date:   Wed, 2 Dec 2020 21:09:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v25 10/16] trace-cmd: Add time sync protocol flags
Message-ID: <20201202210934.3852e5c3@oasis.local.home>
In-Reply-To: <20201029111816.247241-11-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
        <20201029111816.247241-11-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 13:18:10 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added 32bit flags for the time synchronization protocols. The first added
> flag is TRACECMD_TSYNC_FLAG_INTERPOLATE, used to specify how the
> timestamps must be corrected.
>  - If the flag is set, an interpolation is performed:
>    Find the (min, max) interval from the offsets array and calculate
> offset specific to the given timestamp using interpolation in that
> interval.
>  - If the flag is not set, do not interpolate:
>    Find the (min, max) interval from the offsets array and use the
>    min offset for all timespamps within the interval.

    "timestamps"

> 
> These flags are set by the timestamp synchronization protocols at the
> protocol initialization time.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> --- a/tracecmd/trace-tsync.c
> +++ b/tracecmd/trace-tsync.c
> @@ -132,7 +132,8 @@ out:
>  static void write_guest_time_shift(struct buffer_instance *instance)
>  {
>  	struct tracecmd_output *handle;
> -	struct iovec vector[5];
> +	struct iovec vector[6];
> +	unsigned int flags;
>  	long long *scalings = NULL;
>  	long long *offsets = NULL;
>  	long long *ts = NULL;
> @@ -145,6 +146,9 @@ static void write_guest_time_shift(struct buffer_instance *instance)
>  					 &ts, &offsets, &scalings);
>  	if (ret < 0 || !count || !ts || !offsets || !scalings)
>  		return;
> +	ret = tracecmd_tsync_get_proto_flags(&instance->tsync, &flags);
> +	if (ret < 0)
> +		return;
>  
>  	file = instance->output_file;
>  	fd = open(file, O_RDWR);
> @@ -154,14 +158,16 @@ static void write_guest_time_shift(struct buffer_instance *instance)
>  	vector[0].iov_len = 8;
>  	vector[0].iov_base = &top_instance.trace_id;
>  	vector[1].iov_len = 4;
> -	vector[1].iov_base = &count;
> -	vector[2].iov_len = 8 * count;
> -	vector[2].iov_base = ts;
> +	vector[1].iov_base = &flags;
> +	vector[2].iov_len = 4;
> +	vector[2].iov_base = &count;
>  	vector[3].iov_len = 8 * count;
> -	vector[3].iov_base = offsets;
> +	vector[3].iov_base = ts;
>  	vector[4].iov_len = 8 * count;
> -	vector[4].iov_base = scalings;
> -	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 5);
> +	vector[4].iov_base = offsets;
> +	vector[5].iov_len = 8 * count;
> +	vector[5].iov_base = scalings;
> +	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
>  	tracecmd_append_options(handle);
>  	tracecmd_output_close(handle);
>  #ifdef TSYNC_DEBUG

To make the above cleaner, I would use an enum to define the vector
indexes:

enum {
	VECTOR_TRACE_ID,
	VECTOR_FLAGS,
	VECTOR_COUNT,
	VECTOR_TIMES,
	VECTOR_OFFSETS,
	VECTOR_SCALINGS,
}

And then you can make it:

	vector[VECTOR_TRACE_ID].iov_len = 8;
	vector[VECTOR_TRACE_ID].iov_base = &top_instance.trace_id;
	vector[VECTOR_FLAGS].iov_len = 4;
	vector[VECTOR_FLAGS].iov_base = &flags;
	vector[VECTOR_COUNT].iov_len = 4;
	vector[VECTOR_COUNT].iov_base = &count;
	vector[VECTOR_TIMES].iov_len = 8 * count;
	vector[VECTOR_TIMES].iov_base = ts;
	vector[VECTOR_OFFSETS].iov_len = 8 * count;
	vector[VECTOR_OFFSETS].iov_base = offsets;
	vector[VECTOR_SCALINGS].iov_len = 8 * count;
	vector[VECTOR_SCALINGS].iov_base = scalings;

It makes it obvious what each vector is used for.

This is just an opinion. You don't need to implement it. I just hate
hard coded numbers ;-)

-- Steve
