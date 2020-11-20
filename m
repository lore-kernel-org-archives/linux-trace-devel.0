Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3050C63697
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 03:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A92B22282
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 03:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgKTDJM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgKTDJM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 22:09:12 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 018262145D;
        Fri, 20 Nov 2020 03:09:11 +0000 (UTC)
Date:   Thu, 19 Nov 2020 22:09:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Fix `make -jN trace-cmd gui`
Message-ID: <20201119220910.1a8ec625@oasis.local.home>
In-Reply-To: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
References: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 17 Nov 2020 21:16:45 +0000
Dario Faggioli <dfaggioli@suse.com> wrote:

> Doing `make -j8 trace-cmd gui` fails like this:
> 
>   CMake Error at build/FindTraceCmd.cmake:110 (MESSAGE):
> 
>     Could not find libtraceevent!
> 
>   Call Stack (most recent call first):
>     CMakeLists.txt:24 (include)
> 
> Or like this:
> 
>   CMake Error at build/FindTraceCmd.cmake:64 (MESSAGE):
> 
>     Could not find trace-cmd!
> 
>   Call Stack (most recent call first):
>     CMakeLists.txt:20 (include)
> 
> That's because we need `trace-cmd` to have finished
> building before starting to build `gui`.
> 
> Signed-off-by: Dario Faggioli <dfaggioli@suse.com>

Thanks Dario,

I applied it. But note, we will be releasing kernelshark soon in its
own repository (a new and improved version!)

Stay tuned!

-- Steve
