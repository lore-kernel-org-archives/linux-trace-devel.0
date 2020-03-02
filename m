Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB7FC3F2D9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 16:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CEB32173E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 16:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCBQnh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 11:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgCBQnh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 11:43:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 360B12173E;
        Mon,  2 Mar 2020 16:43:37 +0000 (UTC)
Date:   Mon, 2 Mar 2020 11:43:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v21 11/13] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20200302114335.364b10e1@gandalf.local.home>
In-Reply-To: <20200302101404.150035-12-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
        <20200302101404.150035-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  2 Mar 2020 12:14:02 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -940,7 +1215,11 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
>  	write_uints(msg->buf, data_size, ports, nr_cpus);
>  
>  	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
> -	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
> +	msg->trace_req.flags = use_fifos ? MSG_TRACE_USE_FIFOS : 0;

Is there a reason to use "msg->trace_req" instead of "msg->trace_resp"?

-- Steve

> +	msg->trace_resp.flags = htonl(msg->trace_resp.flags);
> +	msg->trace_resp.tsync_proto = htonl(tsync_proto);
> +	msg->trace_resp.tsync_port = htonl(tsync_port);
> +
>  	msg->trace_resp.cpus = htonl(nr_cpus);
>  	msg->trace_resp.page_size = htonl(page_size);
>  	msg->trace_resp.trace_id = htonll(trace_id);
