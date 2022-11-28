Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B813DC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Nov 2022 18:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiK1Sho (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Nov 2022 13:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiK1ShV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Nov 2022 13:37:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3362DF0A
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Nov 2022 10:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB3BE61386
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Nov 2022 18:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD79C4314E;
        Mon, 28 Nov 2022 18:37:17 +0000 (UTC)
Date:   Mon, 28 Nov 2022 13:37:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bean Huo <beanhuo@iokpp.de>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] libtracefs: Fix wrong return value in
 tracefs_tracing_dir_is_mounted()
Message-ID: <20221128133715.288fb265@gandalf.local.home>
In-Reply-To: <e6c020fc59cd3a2333806fbaf2a90092866fb7b7.camel@iokpp.de>
References: <20221128132106.291101-1-beanhuo@iokpp.de>
        <20221128102410.5ccf784d@gandalf.local.home>
        <e6c020fc59cd3a2333806fbaf2a90092866fb7b7.camel@iokpp.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 28 Nov 2022 16:41:54 +0100
Bean Huo <beanhuo@iokpp.de> wrote:

> I used to reply on tracefs_tracing_dir(). But after updated the
> libtracefs yesterday, I found my app doesn't work as before, then
> checked the changelog, and switch to use
> tracefs_tracing_dir_is_mounted. 

OK, so this is a regression and needs to be fixed.


> 
> in your latest libtracefs:
> 
> 
> const char *tracefs_tracing_dir(void) {
> 
> ...
> tracing_dir = trace_find_tracing_dir(false);//shold be changed to true?
> ...

Ah, I think I see the issue here. If it returns NULL, then we need to do
more. I'll take a look into this later today.

Thanks for reporting this.

-- Steve


> 	
> }
> 
> 
> __hidden char *trace_find_tracing_dir(bool debugfs)
> {
>         return find_tracing_dir(debugfs, false);
> }
> 
> 
> 
> static char *find_tracing_dir(bool debugfs, bool mount) {
> 
> ...
> 	if (!mount || mount_debugfs() < 0)
> 		return NULL;
> 
> 
> ...
> 
> 
> }

