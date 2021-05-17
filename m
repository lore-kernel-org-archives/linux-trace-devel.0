Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51578C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 15:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E295611ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 15:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243912AbhEQPxx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243380AbhEQPvq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 11:51:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 518246108B;
        Mon, 17 May 2021 15:21:57 +0000 (UTC)
Date:   Mon, 17 May 2021 11:21:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sameeruddin shaik <sameeross1994@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Add support for setting tracers
Message-ID: <20210517112155.1ee38a59@gandalf.local.home>
In-Reply-To: <CAN_HWU=M-4zpL0eat2AWAPDsgxBjLJptaicNgXQ=rgWhNhjNWQ@mail.gmail.com>
References: <1621243446-7402-1-git-send-email-sameeross1994@gmail.com>
        <20210517090504.431fe8fd@gandalf.local.home>
        <CAN_HWU=M-4zpL0eat2AWAPDsgxBjLJptaicNgXQ=rgWhNhjNWQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 May 2021 20:48:35 +0530
sameeruddin shaik <sameeross1994@gmail.com> wrote:

> > BTW, when a reviewer of your code gives a code example of a better
> > implementation, you should express that in your change log. I usually use:
> >
> >  Suggested-by: ...
> >
> > So you should have:
> >
> >  Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> >
> > as the above is pretty much exact copy of the code snippet I posted.  
> okay steve,
> since i don't know, about this suggested-by, i haven't included. otherwise
> i could have done.

No problem. I'm just educating you ;-)

-- Steve
