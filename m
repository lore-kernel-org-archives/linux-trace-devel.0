Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73500C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 16:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48CB920854
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 16:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfCMQ2m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 12:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbfCMQ2l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 12:28:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29114206BA;
        Wed, 13 Mar 2019 16:28:41 +0000 (UTC)
Date:   Wed, 13 Mar 2019 12:28:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 10/46] tools/lib/traceevent: Man page for
 tep_is_latency_format() and tep_set_latency_format()
Message-ID: <20190313122839.0766a6e0@gandalf.local.home>
In-Reply-To: <20190308133654.21264-11-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-11-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:18 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +  <idle>-0       0d.h1. 106467.859747: function:             ktime_get <-- tick_check_idle
> +--
> +The 0d.h1. denotes this information. The first character is never a pass:['.']
> +and represents what CPU the trace was recorded on (CPU 0). The pass:['d'] denotes
> +that interrupts were disabled. The pass:['h'] means that this was called inside
> +an interrupt handler. The pass:['1'] is the preemption disabled (preempt_count)
> +was set to one.  The two pass:['.']s are "need_resched" flag and kernel lock

There is no kernel lock counter.

Should delete that last '.' in the example.

-- Steve

> +counter. If the "need_resched" flag is set, then that character would be a pass:['N'].
> +See 'LATENCY FORMAT' section.
