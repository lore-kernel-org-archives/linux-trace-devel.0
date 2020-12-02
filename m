Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0926C83016
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 19:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8E322201
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 19:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389752AbgLBTYL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 14:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389751AbgLBTYL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 14:24:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42E622240;
        Wed,  2 Dec 2020 19:23:29 +0000 (UTC)
Date:   Wed, 2 Dec 2020 14:23:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beniamin Sandu <beniaminsandu@gmail.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: make it build against musl C library
Message-ID: <20201202142327.3b178edf@gandalf.local.home>
In-Reply-To: <CABQJdOGMr6tbsH=nLeCVJ5sVdDBvg2Ba-wL4d9T7ey50RYZn4Q@mail.gmail.com>
References: <20201202040802.327203-1-tz.stoyanov@gmail.com>
        <20201202093647.78d861ec@oasis.local.home>
        <CABQJdOGMr6tbsH=nLeCVJ5sVdDBvg2Ba-wL4d9T7ey50RYZn4Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2 Dec 2020 20:43:58 +0200
Beniamin Sandu <beniaminsandu@gmail.com> wrote:

> Hey guys,
> 
> Sorry to hijack your thread, my previous replies got bounced back by
> the mailing list (although I sent them in Plain Text mode), so just
> trying again now to see if it works...
> 

I see this in both my INBOX and in my trace-devel folder.

-- Steve
