Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37AEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 16:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A24660EE9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 16:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhKIQKT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 11:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhKIQKT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 11:10:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3149661002;
        Tue,  9 Nov 2021 16:07:33 +0000 (UTC)
Date:   Tue, 9 Nov 2021 11:07:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] trace-cmd: Dump fraction bits from
 TRACECMD_OPTION_TIME_SHIFT
Message-ID: <20211109110731.5e728340@gandalf.local.home>
In-Reply-To: <20211014150204.2485499-5-tz.stoyanov@gmail.com>
References: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
        <20211014150204.2485499-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Oct 2021 18:02:04 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +		read_file_number(fd, &cpus_data[j].count, 4);
> +		size -= 4;
> +		do_print(OPTIONS, "%lld [samples count for CPU %d]\n", cpus_data[j].count, j);
> +		cpus_data[j].times = calloc(cpus_data[j].count, sizeof(long long));
> +		cpus_data[j].offsets = calloc(cpus_data[j].count, sizeof(long long));
> +		cpus_data[j].scalings = calloc(cpus_data[j].count, sizeof(long long));

> +		cpus_data[j].frac = calloc(cpus_data[j].count, sizeof(long long));

> +		if (!cpus_data[j].times || !cpus_data[j].offsets ||
> +		    !cpus_data[j].scalings || !cpus_data[j].frac)
> +			goto out;
> +		for (i = 0; i < cpus_data[j].count; i++) {
> +			if (size < 8)
> +				goto out;
> +			read_file_number(fd, cpus_data[j].times + i, 8);
> +			size -= 8;
> +		}
> +		for (i = 0; i < cpus_data[j].count; i++) {
> +			if (size < 8)
> +				goto out;
> +			read_file_number(fd, cpus_data[j].offsets + i, 8);
> +			size -= 8;
> +		}
> +		for (i = 0; i < cpus_data[j].count; i++) {
> +			if (size < 8)
> +				goto out;
> +			read_file_number(fd, cpus_data[j].scalings + i, 8);
> +			size -= 8;
> +		}
> +	}
>  
> +	if (size > 0) {
> +		for (j = 0; j < cpus; j++) {
> +			if (!cpus_data[j].frac)
> +				goto out;
> +			for (i = 0; i < cpus_data[j].count; i++) {
> +				if (size < 8)
> +					goto out;
> +				read_file_number(fd, cpus_data[j].frac + i, 8);
> +				size -= 8;
> +			}
> +		}
>  	}
> +
> +	for (j = 0; j < cpus; j++) {
> +		for (i = 0; i < cpus_data[j].count; i++)
> +			do_print(OPTIONS, "\t%lld %lld %llu %llu[offset * scaling >> fraction @ time]\n",
> +				 cpus_data[j].offsets[i], cpus_data[j].scalings[i],
> +				 cpus_data[j].frac[i], cpus_data[j].times[i]);
> +
> +	}
> +
>  out:
> -	free(times);
> -	free(offsets);
> -	free(scalings);
> +	if (j < cpus)
> +		do_print(OPTIONS, "Broken time shift option\n");
> +	for (j = 0; j < cpus; j++) {
> +		free(cpus_data[j].times);
> +		free(cpus_data[j].offsets);
> +		free(cpus_data[j].scalings);

Looks like you forgot to add:

		free(cpus_data[j].frac);

This is the only issue I found in this series. I'll just add a patch to fix
it and move on.

Thanks!

-- Steve


> +	}
> +	free(cpus_data);
