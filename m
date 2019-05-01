Return-Path: <SRS0=6oeL=TB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06A6C43219
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 May 2019 01:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 868B22087B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 May 2019 01:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfEABmB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 21:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbfEABl7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 21:41:59 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4DB12087B;
        Wed,  1 May 2019 01:41:58 +0000 (UTC)
Date:   Tue, 30 Apr 2019 21:41:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 29/30] tools/lib/traceevent: Man pages for APIs, used
 to extract common fields from a record
Message-ID: <20190430214157.54ac84cb@oasis.local.home>
In-Reply-To: <20190412133811.15878-30-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-30-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:38:10 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +
> +enum *trace_flag_type* {
> +	_TRACE_FLAG_IRQS_OFF_,
> +	_TRACE_FLAG_IRQS_NOSUPPOR_,

Hmm, do we really need to save one character here? That should be:

	_TRACE_FLAG_IRQS_NOSUPPORT_

Lets change the code to do this.

-- Steve

> +	_TRACE_FLAG_NEED_RESCHED_,
> +	_TRACE_FLAG_HARDIRQ_,
> +	_TRACE_FLAG_SOFTIRQ_,
> +};
> +
