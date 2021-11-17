Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F16C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C8561A62
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbhKQRNi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 12:13:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239223AbhKQRNQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 12:13:16 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 614BA619EA;
        Wed, 17 Nov 2021 17:10:17 +0000 (UTC)
Date:   Wed, 17 Nov 2021 12:10:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Introduce configurable ring buffer page size
Message-ID: <20211117121015.55f6e1f1@gandalf.local.home>
In-Reply-To: <20211117154101.38659-1-tz.stoyanov@gmail.com>
References: <20211117154101.38659-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Nov 2021 17:40:58 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: "Tzvetomir Stoyanov (VMware)" <tstoyanov@vmware.com>
> 
> Currently the size of one buffer page is global for all buffers and it
> is hard coded to one system page. The patch set introduces configurable
> ring buffer page size, per ring buffer. A new user space interface is
> introduced, which allows to change the page size of the ftrace buffer, per
> ftrace instance.

A few of nits.

1. Even the cover letter should have a category ("tracing:").
2. The category is "tracing:" not "trace:"
3. These are kernel changes and should be sent to lkml and not
   linux-trace-devel, as that mailing list is for tooling.

-- Steve

> 
> Tzvetomir Stoyanov (VMware) (3):
>   [RFC] trace: Page size per ring buffer
>   [RFC] trace: Add interface for configuring trace ring buffer size
>   [WiP] trace: Set new size of the ring buffer page
> 
>  include/linux/ring_buffer.h |   5 +-
>  kernel/trace/ring_buffer.c  | 251 +++++++++++++++++++++++++++---------
>  kernel/trace/trace.c        |  47 +++++++
>  kernel/trace/trace_events.c |  71 ++++++++--
>  4 files changed, 304 insertions(+), 70 deletions(-)
> 

