Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A20C3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 19:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C5320707
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 19:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgEDTNh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 15:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgEDTNh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 15:13:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE8A6206B8;
        Mon,  4 May 2020 19:13:36 +0000 (UTC)
Date:   Mon, 4 May 2020 15:13:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr
Subject: Re: [PATCH 2/2] kernel-shark: Add command line options for
 selecting plots to be shown
Message-ID: <20200504151335.6088dda5@gandalf.local.home>
In-Reply-To: <20200424132542.1620-3-y.karadz@gmail.com>
References: <20200424132542.1620-1-y.karadz@gmail.com>
        <20200424132542.1620-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 24 Apr 2020 16:25:42 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Example:
>   kernelshark -i mytrace.dat --cpu '1 4-7' --pid 11

Can we change this to use a comma instead of a space. Then we don't need to
worry about quotes.

  kernelshark -i mytrace.dat --cpu 1,4-7

That's the common format for other unix command lines. See taskset for
instance.

-- Steve


> 
> This will show CPUs: 1, 4, 5, 6, 7 and task(PID): 11.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> Suggested-by: Julia Lawall  <julia.lawall@inria.fr>
> ---
>  kernel-shark/src/KsUtils.cpp     | 24 ++++++++++++++++++++++++
>  kernel-shark/src/KsUtils.hpp     |  2 ++
>  kernel-shark/src/kernelshark.cpp | 32 +++++++++++++++++++++++++++++---
>  3 files changed, 55 insertions(+), 3 deletions(-)
> 
> 
