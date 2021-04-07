Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7E6C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3601D61284
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354405AbhDGQ4G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354403AbhDGQ4F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 12:56:05 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF79861284;
        Wed,  7 Apr 2021 16:55:55 +0000 (UTC)
Date:   Wed, 7 Apr 2021 12:55:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Implement tracefs_warning()
Message-ID: <20210407125554.17b480e5@gandalf.local.home>
In-Reply-To: <20210407125432.2de1382d@gandalf.local.home>
References: <20210407051154.2422172-1-tz.stoyanov@gmail.com>
        <20210407121928.464045ee@gandalf.local.home>
        <CAPpZLN4BUmTwx1QGYLZPoWc0iTRS0GPN3vo1GkXXd9GFerToVg@mail.gmail.com>
        <20210407125432.2de1382d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 7 Apr 2021 12:54:32 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > 3. A weak function specific to each library is a more straightforward
> > way and the user has the flexibility to control warnings per library.
> > The overhead to add library specific wrappers to those weak functions
> > is not so big.  
> 
> It's an unnecessary burden. You may add libtracecmd, and want to capture
> all the warnings and overwrite tracecmd_warning(), but then see that
> there's other warnings coming from libtraceevent and libtracefs that you
> never included (because libtracecmd pulled them in). And it's not obvious
> how to deal with them.

I'm fine if you want to make them all weak, but I really like to have a
single function that can control all of them.

-- Steve
