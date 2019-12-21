Return-Path: <SRS0=3JjO=2L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EA3C43603
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 01:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E872B2082E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 01:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLUBXX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 20:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfLUBXX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 20:23:23 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ACCD2070C;
        Sat, 21 Dec 2019 01:23:22 +0000 (UTC)
Date:   Fri, 20 Dec 2019 20:23:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Shuah Khan <shuahkhan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] selftests/ftrace: fix glob selftest
Message-ID: <20191220202320.18e6c653@rorschach.local.home>
In-Reply-To: <20191220073240.GA72310@tuxmaker.boeblingen.de.ibm.com>
References: <20191218074427.96184-1-svens@linux.ibm.com>
        <20191218074427.96184-2-svens@linux.ibm.com>
        <20191219183151.58d81624@gandalf.local.home>
        <20191220162746.d0889aeac721f8e4d400db64@kernel.org>
        <20191220073240.GA72310@tuxmaker.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Dec 2019 08:32:40 +0100
Sven Schnelle <svens@linux.ibm.com> wrote:


> > Thanks Steve to CC to me.
> > BTW, are there any reason why we use different symbols for different
> > glob patterns?
> > I mean we can use 'schedul*', '*chedule' and '*sch*ule' as test
> > glob patterns.  
> 
> Don't know, but i don't see a reason why we should have different patterns. If
> there's an agreement that we prefer a common pattern i can update the patch and
> resend.


I think I liked trying other functions just to make sure that it was
working to add a bit of churn to the mix (for the unlikely case that
schedule has some fluke case).

We could just switch it all to use schedule, or we can change "aw" to
"spin".

-- Steve
