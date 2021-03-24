Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB95AC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A531B619EE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhCXB1G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhCXB1B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:27:01 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA0DB619ED;
        Wed, 24 Mar 2021 01:27:00 +0000 (UTC)
Date:   Tue, 23 Mar 2021 21:26:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 05/18] trace-cmd: Add a new option in trace file
 metadata for tsc2nsec conversion
Message-ID: <20210323212659.1a719671@oasis.local.home>
In-Reply-To: <20210322095945.259300-6-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
        <20210322095945.259300-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 11:59:32 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new option is added in the trace.dat file for holding the multiplier
> and shift, used for converting TSC trace clock to nanoseconds.
> 

Did you forgot to commit something in this patch? because the below
change doesn't match the change log. I was expecting to see the code
that adds the new option, but the code below is only code to have
trace-cmd dump output it.

-- Steve


> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  .../include/private/trace-cmd-private.h       |  1 +
>  tracecmd/trace-dump.c                         | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index a4637046..ce3d8dc0 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -125,6 +125,7 @@ enum {
>  	TRACECMD_OPTION_TRACEID,
>  	TRACECMD_OPTION_TIME_SHIFT,
>  	TRACECMD_OPTION_GUEST,
> +	TRACECMD_OPTION_TSC2NSEC,
>  };
>  
>  enum {
> diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
> index 4bdfd53f..31b9d201 100644
> --- a/tracecmd/trace-dump.c
> +++ b/tracecmd/trace-dump.c
> @@ -483,6 +483,22 @@ out:
>  	free(buf);
>  }
>  
> +void dump_option_tsc2nsec(int fd, int size)
> +{
> +	int mult, shift;
> +	unsigned long long offset;
> +
> +	do_print(OPTIONS, "\n\t\t[Option TSC2NSEC, %d bytes]\n", size);
> +
> +	if (read_file_number(fd, &mult, 4))
> +		die("cannot read tsc2nsec multiplier");
> +	if (read_file_number(fd, &shift, 4))
> +		die("cannot read tsc2nsec shift");
> +	if (read_file_number(fd, &offset, 8))
> +		die("cannot read tsc2nsec offset");
> +	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
> +}
> +
>  static void dump_options(int fd)
>  {
>  	unsigned short option;
> @@ -543,6 +559,9 @@ static void dump_options(int fd)
>  		case TRACECMD_OPTION_GUEST:
>  			dump_option_guest(fd, size);
>  			break;
> +		case TRACECMD_OPTION_TSC2NSEC:
> +			dump_option_tsc2nsec(fd, size);
> +			break;
>  		default:
>  			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
>  				 option, size);

