Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D58BC636C8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 01:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D60C61178
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 01:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhGUAaL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 20:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhGUAaH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 20:30:07 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12A896113A;
        Wed, 21 Jul 2021 01:10:43 +0000 (UTC)
Date:   Tue, 20 Jul 2021 21:10:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     contact me <www@aegistudio.net>
Cc:     "Linus Torvalds" <torvalds@linuxfoundation.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-trace-devel" <linux-trace-devel@vger.kernel.org>,
        "Security Officers" <security@kernel.org>
Subject: Re: [PATCH 1/1] tracing: fix bug in rb_per_cpu_empty() that might
 cause deadloop.
Message-ID: <20210720211037.3f01efb2@oasis.local.home>
In-Reply-To: <17ac6106cb2.f47a44f4155575.7075579492521292678@aegistudio.net>
References: <YPaNxsIlb2yjSi5Y@aegistudio>
        <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
        <17ac6106cb2.f47a44f4155575.7075579492521292678@aegistudio.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Jul 2021 06:36:43 +0800
contact me <www@aegistudio.net> wrote:

> Agreed, this piece of code would be less likely to be buggy if they
> are commented by what they are judging. I will do it and send the next
> version of patch.

Please send me the clean up patch, and I'll add it to the next merge
window. You can use the comments I gave Linus. But can you test the
patch I replied to Linus with. And I'll add that one for Linus and
stable, and add you as the "Reported-by" on it.

Thanks!

-- Steve
