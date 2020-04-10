Return-Path: <SRS0=Nrf9=52=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20258C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Apr 2020 01:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF722074F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Apr 2020 01:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgDJBHQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 21:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgDJBHP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 21:07:15 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC73320769;
        Fri, 10 Apr 2020 01:07:15 +0000 (UTC)
Date:   Thu, 9 Apr 2020 21:07:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Add new API tracecmd_set_merge_peer()
Message-ID: <20200409210713.6a0fccfa@oasis.local.home>
In-Reply-To: <20200409132835.79530-2-tz.stoyanov@gmail.com>
References: <20200409132835.79530-1-tz.stoyanov@gmail.com>
        <20200409132835.79530-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  9 Apr 2020 16:28:34 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +/**
> + * tracecmd_set_merge_peer - Link a tracing peer to this handle
> + * @handle: input handle for the trace.dat file
> + * @peer: input handle for the tracing peer
> + *
> + * When tracing host and one or more guest machines at the same time,
> + * guest and host are tracing peers. There is information in both trace
> + * files, related to host PID to guest vCPU mapping, timestamp synchronization
> + * and other. This information is useful when opening files at the same time and
> + * merging the events. When the host is set as a tracing peer to the guest, then
> + * the timestamps of guest's events are recalculated to match the host event's time
> + */
> +int tracecmd_set_merge_peer(struct tracecmd_input *handle,
> +			    struct tracecmd_input *peer)

I wonder it would be better to call this tracecmd_pair_peer(), like
pairing a bluetooth headset with your phone?

> +{
> +	if (!handle)
> +		return -1;
> +

This should probably fail if the host.peer_data is already set. Which
means we should also have a way to unmerge (unpair) the two. Which is
why I like the term "pair" better, as it is like paring a bluetooth
device and then unpairing it.

-- Steve


> +	handle->host.peer_data = peer;
> +	tracecmd_ref(peer);
> +	tsync_check_enable(handle);
> +
> +	return 0;
> +}
> +
>  /**
>   * tracecmd_ref - add a reference to the handle
>   * @handle: input handle for the trace.dat file
> @@ -3785,7 +3839,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
>   */
>  unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
>  {
> -	return handle->host.trace_id;
> +	return handle->host.peer_trace_id;
>  }
>  
