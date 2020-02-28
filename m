Return-Path: <SRS0=HcHG=4Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D209BC3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Feb 2020 17:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A651F246A8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Feb 2020 17:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgB1RlU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Feb 2020 12:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgB1RlU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 12:41:20 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9103A246A3;
        Fri, 28 Feb 2020 17:41:19 +0000 (UTC)
Date:   Fri, 28 Feb 2020 12:41:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v20 13/15] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20200228124118.712d6e9a@gandalf.local.home>
In-Reply-To: <20200227142001.61577-14-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
        <20200227142001.61577-14-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

After applying this patch, my recordings stopped working. That's because
I'm still using fifos. I found the reason for this below.

On Thu, 27 Feb 2020 16:19:59 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -940,7 +1215,11 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
>  	write_uints(msg->buf, data_size, ports, nr_cpus);
>  
>  	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
> -	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);

> +	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
> +	msg->trace_resp.flags = htonl(msg->trace_resp.flags);

The above is what broke. That should be:

	msg->trace_resp.flags = use_fifos ? MSG_TRACE_USE_FIFOS : 0;
	msg->trace_resp.flags = htonl(msg->trace_resp.flags);

-- Steve


> +	msg->trace_resp.tsync_proto = htonl(tsync_proto);
> +	msg->trace_resp.tsync_port = htonl(tsync_port);
> +
>  	msg->trace_resp.cpus = htonl(nr_cpus);
>  	msg->trace_resp.page_size = htonl(page_size);
>  	msg->trace_resp.trace_id = htonll(trace_id);
