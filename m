Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296E2C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 14:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiAZOQv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 09:16:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41532 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242039AbiAZOQu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 09:16:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B9361537
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 14:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99121C340E3;
        Wed, 26 Jan 2022 14:16:48 +0000 (UTC)
Date:   Wed, 26 Jan 2022 09:16:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 01/20] trace-cmd library: Add support for compression
 algorithms
Message-ID: <20220126091646.225f4f15@gandalf.local.home>
In-Reply-To: <CAPpZLN7EYCuAS=uU_BzS1r_G8TBcfDta3nbSFwykPFuzgbwJNA@mail.gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
        <20220119082715.245846-2-tz.stoyanov@gmail.com>
        <20220123174851.52f0e2bb@rorschach.local.home>
        <CAPpZLN6BpbaThK66MJaykk7gSPDq2qQHkbmunQeT0NyMNMGnAw@mail.gmail.com>
        <20220124150335.2516da99@gandalf.local.home>
        <CAPpZLN6_VNmH3O1GML6cPfXJwp2K-SJseVd4fe=bbLZR8pm8PA@mail.gmail.com>
        <20220125100809.528667ef@gandalf.local.home>
        <CAPpZLN4ET-wF2BcQzEb99F8LFADVDYZR6_kdo4530XC=1eJG3Q@mail.gmail.com>
        <CAPpZLN7EYCuAS=uU_BzS1r_G8TBcfDta3nbSFwykPFuzgbwJNA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 26 Jan 2022 06:56:13 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > I didn't know about that realloc optimization (check if requested size
> > fits into already allocated memory). In that case, we can use the
> > requested size in both places. But still allocate a page aligned
> > buffer in buffer_extend(), to avoid frequent reallocs (although
> > realloc will be called almost every time).
> >  
> 
> I did some tests, these extra realloc() calls actually cause 7-8% slow
> down on writing compressed trace files. So, I decided to go with the
> other approach - use capacity_read and capacity_write.

Interesting. I'm curious to what exactly that test was.

Anyway, numbers talk, so it's best to save the actual size and capacity
separately then, right? And only call the realloc when you need to grow the
array.

-- Steve
