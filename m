Return-Path: <SRS0=AbPd=64=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75063C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 22:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5669B20734
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 22:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgENWnv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 May 2020 18:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbgENWnu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 May 2020 18:43:50 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B7120709;
        Thu, 14 May 2020 22:43:50 +0000 (UTC)
Date:   Thu, 14 May 2020 18:43:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bijan Tabatabai <bijan311@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Bijan Tabatabai <bijan311@yahoo.com>
Subject: Re: [PATCH v4] trace-cmd: Stop recording when processes traced with
 -P exit
Message-ID: <20200514184348.753f3c19@oasis.local.home>
In-Reply-To: <20200514164244.12858-1-bijan311@gmail.com>
References: <20200514164244.12858-1-bijan311@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 May 2020 11:42:44 -0500
Bijan Tabatabai <bijan311@gmail.com> wrote:

> From: Bijan Tabatabai <bijan311@yahoo.com>
> 
> When the -F flag is used in trace-cmd record, trace-cmd stops recording
> when the executable it is tracing terminates.
> This patch makes the -P flag act similarly.
> 
> Signed-off-by: Bijan Tabatabai <bijan311@yahoo.com>
> ---
>  v4 fixes a bug where trace-cmd would stop tracing after the processes in
>  the first instance exited.
> ---
>  

Looks good, but there's one small nit.

> @@ -6361,7 +6441,16 @@ static void record_trace(int argc, char **argv,
>  		}
>  		/* sleep till we are woken with Ctrl^C */
>  		printf("Hit Ctrl^C to stop recording\n");
> -		while (!finished)
> +		for_all_instances(instance) {
> +			/* If an instance is not tracing individual processes
> +			 * or there is an error while waiting for a process to
> +			 * exit, fallback to waiting indefinitely.
> +			 */
> +			if (!instance->nr_process_pids
> +			    || trace_wait_for_processes(instance))

My preference is:

			if (!instance->nr_process_pids ||
			    trace_wait_for_processes(instance))

But I can make this change.

Thanks!

-- Steve

> +				wait_indefinitely = true;
> +		}
> +		while (!finished && wait_indefinitely)
>  			trace_or_sleep(type, pwait);
>  	}
>  

