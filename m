Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D171C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4299D610E6
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhDGQyu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354368AbhDGQys (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 12:54:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 371EE60232;
        Wed,  7 Apr 2021 16:54:34 +0000 (UTC)
Date:   Wed, 7 Apr 2021 12:54:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Implement tracefs_warning()
Message-ID: <20210407125432.2de1382d@gandalf.local.home>
In-Reply-To: <CAPpZLN4BUmTwx1QGYLZPoWc0iTRS0GPN3vo1GkXXd9GFerToVg@mail.gmail.com>
References: <20210407051154.2422172-1-tz.stoyanov@gmail.com>
        <20210407121928.464045ee@gandalf.local.home>
        <CAPpZLN4BUmTwx1QGYLZPoWc0iTRS0GPN3vo1GkXXd9GFerToVg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 7 Apr 2021 19:46:43 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:


> I understood that idea from your comments, but have a few concerns:
> 
> 1. That way we create a dependency, not logical to the user of the libraries.

What dependency?

> 2. That print functionality is not something logically specific to the
> libtraceevent, it is not related to the main purpose of this library.

Not sure what you mean by that?

> 3. A weak function specific to each library is a more straightforward
> way and the user has the flexibility to control warnings per library.
> The overhead to add library specific wrappers to those weak functions
> is not so big.

It's an unnecessary burden. You may add libtracecmd, and want to capture
all the warnings and overwrite tracecmd_warning(), but then see that
there's other warnings coming from libtraceevent and libtracefs that you
never included (because libtracecmd pulled them in). And it's not obvious
how to deal with them.

-- Steve
