Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9176C6377D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 14:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE706128A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 14:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhGVNvr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 09:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232272AbhGVNvq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 09:51:46 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F116101E;
        Thu, 22 Jul 2021 14:32:21 +0000 (UTC)
Date:   Thu, 22 Jul 2021 10:32:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Haoran Luo <www@aegistudio.net>
Cc:     "mingo" <mingo@redhat.com>,
        "linux-trace-devel" <linux-trace-devel@vger.kernel.org>,
        "security" <security@kernel.org>
Subject: Re: [PATCH v3 1/1] tracing: fix bug in rb_per_cpu_empty() that
 might cause deadloop.
Message-ID: <20210722103214.62f5e328@oasis.local.home>
In-Reply-To: <17acd4d149d.104a6dc15126082.6584458652825480326@aegistudio.net>
References: <YPgrN85WL9VyrZ55@aegistudio>
        <17acd4d149d.104a6dc15126082.6584458652825480326@aegistudio.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Jul 2021 16:20:18 +0800
Haoran Luo <www@aegistudio.net> wrote:

> Pardon me again for my poor English, and thank you for reading such verbose
> explanation of mine.

It was well written. No need to be pardoned ;-)

I'm not sure why you wrote this up, because you didn't have to. I
thought everything was self explanatory, but maybe that's because I
have a lot of background information that others may not have, and
others would benefit from that write up.

Anyway, I'm working on some other bug fixes, and once I have a set of
patches that need to go mainline, I'll include your patch with it, run
it through my tests, and then post it to Linus.

Thanks!

-- Steve
