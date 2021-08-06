Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF4AC4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Aug 2021 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B612361004
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Aug 2021 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhHFUzk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 16:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231603AbhHFUzk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 16:55:40 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6698061078;
        Fri,  6 Aug 2021 20:55:23 +0000 (UTC)
Date:   Fri, 6 Aug 2021 16:55:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: Re: [PATCH 2/2] tracing: Update to the event probes
Message-ID: <20210806165516.370c1f26@oasis.local.home>
In-Reply-To: <20210716000406.27c22e3a@oasis.local.home>
References: <20210716032632.272262604@goodmis.org>
        <20210716033150.039236101@goodmis.org>
        <20210716000406.27c22e3a@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Jul 2021 00:04:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Also, we must make it where writing into the event's trigger files does
> not touch these triggers (as we saw that will crash the system!).

Tzvetomir,

I know I was able to crash the kernel before, but I do not remember how
I did it, and trying various things, I have not been able to crash it
with these patches.

I may continue to try a little more, otherwise, I'll just stop and go
ahead and review your latest patch.

-- Steve
