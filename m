Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988B0C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 21:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F4DC6128E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 21:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhFVVlB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 17:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVVlB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 17:41:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81BF761042;
        Tue, 22 Jun 2021 21:38:44 +0000 (UTC)
Date:   Tue, 22 Jun 2021 17:38:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd split: Copy trace_clock from input handler to
 output handler
Message-ID: <20210622173843.496b0ca3@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.22.394.2106222322590.80759@hadrien>
References: <20210622171338.6447f199@gandalf.local.home>
        <alpine.DEB.2.22.394.2106222322590.80759@hadrien>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Jun 2021 23:25:23 +0200 (CEST)
Julia Lawall <julia.lawall@inria.fr> wrote:

> > Add a new function to retrieve the trace_clock from the input handle, to
> > be used to pass it to the output handle before appending the CPU data.  
> 
> Just to confirm, is it still possible to run trace-cmd split without being
> root?

Yes, it was a bug that you couldn't read it as non-root. And it shouldn't be
reading the local trace_clock anyway, even if you are root.

1) because it could be splitting a trace.dat file from another machine
   (which is what I was doing)

2) the trace_clock of the machine could have changed since the trace was
   run.

-- Steve
