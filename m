Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E036C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 19:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E72CD6113E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 19:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhEFTe4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 15:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235429AbhEFTez (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 15:34:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE1526105A;
        Thu,  6 May 2021 19:33:56 +0000 (UTC)
Date:   Thu, 6 May 2021 15:33:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel-shark: Add LatencyPlot plugin
Message-ID: <20210506153355.1ca57b06@gandalf.local.home>
In-Reply-To: <20210429154421.255872-3-y.karadz@gmail.com>
References: <20210429154421.255872-1-y.karadz@gmail.com>
        <20210429154421.255872-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Apr 2021 18:44:21 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The plugin allows the user to visualize the latency between two
> events under the condition that the values of given data fields
> in the two events are identical (for example having the same PID).
> The core logic that implements the processing of the data and
> the visualization itself is implemented in:

THIS FEATURE IS FREAKING HOT!!!!

OMG! Seriously Yordan, this is awesome. I could have soooo used this in the
past. I LOVE the way the markers automatically select both the start and
end of the latency. This is a feature that will get a LOT of attention!

WAY TO GO, Yordan!

-- Steve

> 
> src/plugins/latency_plot.h,
> src/plugins/latency_plot.c and
> src/plugins/LatencyPlot.cpp
> 
> The plugin also registers its own dialog, that allows the user to
> select the events (and the matching field) to be visualized. The
> widget of the dialog gets implemented in:
> 
> src/plugins/LatencyPlotDialog.hpp
> src/plugins/LatencyPlotDialog.cpp
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
