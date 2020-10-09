Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C398C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0865F222BA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388664AbgJIOyn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387664AbgJIOyn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:54:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1D422260;
        Fri,  9 Oct 2020 14:54:42 +0000 (UTC)
Date:   Fri, 9 Oct 2020 10:54:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zamir SUN <sztsian@gmail.com>
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Fix include level of Makefile scripts
Message-ID: <20201009105441.3c92e560@gandalf.local.home>
In-Reply-To: <7897620c-3039-5e4f-09d9-41606673fa63@gmail.com>
References: <20201008071858.96786-1-sztsian@gmail.com>
        <7897620c-3039-5e4f-09d9-41606673fa63@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 8 Oct 2020 15:30:08 +0800
Zamir SUN <sztsian@gmail.com> wrote:

> Note, this patch is for libtraceevent.
> 
> And I think it makes more sense to port the missing 
> scripts/utilities.mak by the maintainer rather than sending a patchset 
> with lots of historical commits from kernel, so I did not include that 
> part here.
> 
> HTH.

Thanks!

I reverted the copy and brought over the history of the Makefiles, scripts
and include headers. I also included utilities.mak.

When this becomes something that can be installed as a package, I'll give
it an official tag: libtraceevent-v1.1.0

-- Steve
