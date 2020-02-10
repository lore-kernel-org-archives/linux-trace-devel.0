Return-Path: <SRS0=56ke=36=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FD5C352A3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Feb 2020 16:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE5F220842
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Feb 2020 16:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgBJQja (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 11:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgBJQja (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 11:39:30 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC0C120842;
        Mon, 10 Feb 2020 16:39:29 +0000 (UTC)
Date:   Mon, 10 Feb 2020 11:39:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sztsian@gmail.com
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH 0/0] Two fixes for compiling
Message-ID: <20200210113927.49a4e0ca@gandalf.local.home>
In-Reply-To: <20200209034226.287464-1-sztsian@gmail.com>
References: <20200209034226.287464-1-sztsian@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Zamir!

Thanks for the patches.

On Sun,  9 Feb 2020 11:42:24 +0800
sztsian@gmail.com wrote:

> This contains two fixes of compiling.
> 
> The KernelShark one is to inherit libdir into kernelshark CMakeLists so
> that the libdir parsed to Makefile is honored in kernelshark.

Yodan, can you review this one?

> 
> The trace-cmd one is to remove python-gui which depends on the obsoleted
> gtk stuff.
> 
> In order to compile and test this change, the following patch from
> Tzvetomir need to be applied.
> [PATCH] kernel-shark: Fix search path for libtracefs
> https://lore.kernel.org/linux-trace-devel/20200205070743.13836-1-tz.stoyanov@gmail.com/T/#u

I will start applying these.

> 
> Note: I always send email and git commits with signature "Zamir SUN"
> before. However I see DCO requires to sign using real name, so I changed
> to fulfill the DCO.
> 

Yes, thank you for doing so.

-- Steve
