Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9788C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 16:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLUQf4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiLUQfz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 11:35:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ABB21806
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 08:35:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE263B81AF5
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 16:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9B2C433D2;
        Wed, 21 Dec 2022 16:35:51 +0000 (UTC)
Date:   Wed, 21 Dec 2022 11:35:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: Show multi-line events in quick view
Message-ID: <20221221113549.549f58b4@gandalf.local.home>
In-Reply-To: <4470bb69-1558-5775-67ff-9b6b0779f573@gmail.com>
References: <20221214154643.43a4e137@gandalf.local.home>
        <4470bb69-1558-5775-67ff-9b6b0779f573@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 20 Dec 2022 18:51:03 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
> I wonder if the context menu is the best place to display those 
> multi-line events. This menu is quite busy already and if you want to 
> check a number of events, each time you have to open it then close it 
> and reopen it again in order to see the next event. I think this can be 
> a bit annoying.

It doesn't annoy me ;-)

> 
> An alternative can be to use the dual marker. For example we can make it 
> to work such that all lines of the event selected with the markers are 
> shown directly into the table.
> 
> I am attaching a RFC patch that that implements this. Note that I didn't 
> time to fully test and debug this for all corner cases, but it should 
> work at leas for the most straight-forward  use case. Please try it and 
> tell me what you think.
> 

This works too. Either way, as long as I can get to the data.

Also, for another feature request. Is it possible to implement a copy of
the text in the list view? I would like to select text and copy it so that
I can paste it into other windows.

Thanks!

-- Steve
