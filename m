Return-Path: <SRS0=3JjO=2L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F62C43603
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 03:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2612D206C3
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 03:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLUDTs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 22:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfLUDTr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 22:19:47 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94BA206C3;
        Sat, 21 Dec 2019 03:19:46 +0000 (UTC)
Date:   Fri, 20 Dec 2019 22:19:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v18 12/18] trace-cmd: Implement new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Message-ID: <20191220221945.79f7f466@rorschach.local.home>
In-Reply-To: <20191213153029.133570-13-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
        <20191213153029.133570-13-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Dec 2019 17:30:23 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -2370,6 +2489,28 @@ static int handle_options(struct tracecmd_input *handle)
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
> +			handle->host.ts_samples = malloc(2 * samples_size);
> +			if (!handle->host.ts_samples)
> +				return -ENOMEM;
> +			tsync_offset_load(handle, buf + 12);
> +			break;
>  		case TRACECMD_OPTION_CPUSTAT:
>  			buf[size-1] = '\n';
>  			cpustats = realloc(cpustats, cpustats_size + size + 1);
> @@ -3078,6 +3219,8 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	trace_pid_map_free(handle->pid_maps);
>  	handle->pid_maps = NULL;
>  
> +	trace_tsync_offset_free(&handle->host);

You need to add in tracecmd_buffer_instance_handle() something like:

	memset(&new_handle->host, 0, sizeof(new_handle->host));

or make a copy of it. Because if the host created sub buffers along
with the top level, you get multiple frees on the host.ts_samples, as
the new_handle will have a pointer to the original handle.

This is the same bug fixed by ca4b997b6505df3ce for trace_clock.

-- Steve


> +
>  	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
>  		tracecmd_close(handle->parent);
>  	else {
