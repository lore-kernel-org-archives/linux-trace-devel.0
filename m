Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A50BC4BA06
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 03:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED88524670
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 03:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgB0Dty (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 22:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbgB0Dty (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 22:49:54 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84DFA24670;
        Thu, 27 Feb 2020 03:49:53 +0000 (UTC)
Date:   Wed, 26 Feb 2020 22:49:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v19 09/15] trace-cmd: Implement new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Message-ID: <20200226224951.2781afb2@oasis.local.home>
In-Reply-To: <20200131121111.130355-10-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
        <20200131121111.130355-10-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 31 Jan 2020 14:11:05 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -2271,6 +2390,28 @@ static int handle_options(struct tracecmd_input *handle)
>  			offset = strtoll(buf, NULL, 0);
>  			handle->ts_offset += offset;
>  			break;
> +		case TRACECMD_OPTION_TIME_SHIFT:
> +			/*
> +			 * long long int (8 bytes) trace session ID
> +			 * int (4 bytes) count of timestamp offsets.
> +			 * long long array of size [count] of times,
> +			 *      when the offsets were calculated.
> +			 * long long array of size [count] of timestamp offsets.
> +			 */
> +			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
> +				break;
> +			handle->host.trace_id = tep_read_number(handle->pevent,
> +								buf, 8);
> +			handle->host.ts_samples_count = tep_read_number(handle->pevent,
> +									buf + 8, 4);
> +			samples_size = (8 * handle->host.ts_samples_count);
> +			if (size != (12 + (2 * samples_size)))
> +				break;

Instead of failing silently here, we should have some kind of warning.

-- Steve

> +			handle->host.ts_samples = malloc(2 * samples_size);
> +			if (!handle->host.ts_samples)
> +				return -ENOMEM;
> +			tsync_offset_load(handle, buf + 12);
> +			break;
