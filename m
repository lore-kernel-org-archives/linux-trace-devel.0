Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5974EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 18:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiBVSVH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 13:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiBVSVG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 13:21:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA327B16D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 10:20:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62B88B81C1F
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 18:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A258EC340E8;
        Tue, 22 Feb 2022 18:20:37 +0000 (UTC)
Date:   Tue, 22 Feb 2022 13:20:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] libtracefs: Add APIs for user_events to
 libtracefs
Message-ID: <20220222132036.6a4355f3@gandalf.local.home>
In-Reply-To: <20220222175045.GC1709@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220222123447.244b8f57@gandalf.local.home>
        <20220222175045.GC1709@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 09:50:45 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Yeah, I can get a v2 today I think. We keep expanding what to change in
> the thread (which is great) so I'll do my best to capture it all out in
> the v2. I plan to start in a few hours, with what we've talked about so
> far.

My only concern is that we will get an API that we want to change. But
currently I'm pretty confident that this is the API that we'll keep. We can
always add more, but once a release is out, we are stuck with that API for
good.

Thanks a lot for doing this!

-- Steve
