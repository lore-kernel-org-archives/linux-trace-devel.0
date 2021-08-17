Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463CBC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 15:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1634660F58
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbhHQPo5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 11:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233372AbhHQPo5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 11:44:57 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 878CF60F58;
        Tue, 17 Aug 2021 15:44:23 +0000 (UTC)
Date:   Tue, 17 Aug 2021 11:44:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 31/87] trace-cmd library: Fit CPU latency trace data
 in the new trace file version 7 format
Message-ID: <20210817114416.252e117e@oasis.local.home>
In-Reply-To: <20210729050959.12263-32-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-32-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:03 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Trace file version 7 format is based on sections. To fit the latency
> trace data in this structure, a new section and option for it is
> defined:
>   BUFFER_LAT
> It is similar to the BUFFER section which holds the flyrecord data, but
> has a latency specific design. The BUFFER_LAT section has:

Actually, let's call it BUFFER_TEXT.

Although we do it for "latency" format, which I'm thinking we should
call it something different for v7, the real difference is that it's
text and not binary. Perhaps we can save other formats as "text".

In fact, I think v7 should allow for a mixture of TEXT and BINARY
buffers.

-- Steve

>  - section header, as all other sections
>  - compression of the trace data, optional
>  - corresponding trace option, pointing to the section
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
