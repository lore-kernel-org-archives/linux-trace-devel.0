Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13401C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 23:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E00F561130
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 23:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbhKHXXD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 18:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233956AbhKHXWx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 18:22:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A97AE6103D;
        Mon,  8 Nov 2021 23:20:07 +0000 (UTC)
Date:   Mon, 8 Nov 2021 18:20:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] user_events: Optimize writing events by only
 copying data once
Message-ID: <20211108182006.7b09a630@gandalf.local.home>
In-Reply-To: <20211108231710.GA1521@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-10-beaub@linux.microsoft.com>
        <20211108174542.39c255e1@gandalf.local.home>
        <20211108230034.GB1452@kbox>
        <20211108180452.3ec1f4ec@gandalf.local.home>
        <20211108231710.GA1521@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 8 Nov 2021 15:17:10 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > Which reminds me that trace_event_buffer_reserve() expects to be called
> > with preemption disabled. And I'm guessing that may not be the case for you.
> >   
> 
> Thanks, should be good there:
> I have rcu_read_lock_sched() held, which will have preemption disabled
> during the various probe calls.

Ah, that's right. Thanks for the reminder.

> 
> > I'll change this so that it always disables preemption even if it uses the
> > filter buffer, and *always* disables preemption on return.

Even so, I think it's better to have it consistently disable/enable
preemption than expect the caller to do so.

-- Steve
