Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E63EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 13:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E171961469
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 13:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhEGNO4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 09:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhEGNOz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 09:14:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 662CE61040;
        Fri,  7 May 2021 13:13:55 +0000 (UTC)
Date:   Fri, 7 May 2021 09:13:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] trace-cmd: Find PID of host-guest task from tracing
 vsock connection
Message-ID: <20210507091353.12cde68e@gandalf.local.home>
In-Reply-To: <098a7c9a4af4c0e6364a29eeacbd74a7505f61c0.camel@suse.com>
References: <20210506171400.7c00b731@gandalf.local.home>
        <f4c372f2138151299588b702567827a61954f775.camel@suse.com>
        <20210506214012.741cbbd7@oasis.local.home>
        <CAPpZLN48irG2cuPZi4+RAORbkxpnHudNf1wdXBdjYDmr4e8bhw@mail.gmail.com>
        <20210507075834.43497e77@gandalf.local.home>
        <098a7c9a4af4c0e6364a29eeacbd74a7505f61c0.camel@suse.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 07 May 2021 14:48:25 +0200
Dario Faggioli <dfaggioli@suse.com> wrote:

> Thanks for taking the time to explain it, and sorry for the noise. :-D

This isn't noise. I welcome the discussion. This solution is a horrible
hack. Unfortunately, the only solutions that seem to work are all horrible
hacks, and this just happens to be the best solution of the horrible hacks!

:-p

-- Steve
