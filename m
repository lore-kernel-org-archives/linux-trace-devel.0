Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8DDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Feb 2022 20:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244765AbiBTUG0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Feb 2022 15:06:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiBTUGZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Feb 2022 15:06:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CB84B870
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 12:06:01 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nLsT0-0004T8-J5; Sun, 20 Feb 2022 21:05:58 +0100
Date:   Sun, 20 Feb 2022 21:05:58 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: trace-cmd library: Add ZSTD support.
Message-ID: <YhKfJqm33bPaExVI@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
 <20220220121143.6022d737@gandalf.local.home>
 <YhKFGF0sTLFddAWw@breakpoint.cc>
 <20220220141759.124bc6e6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220220141759.124bc6e6@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-02-20 14:17:59 [-0500], Steven Rostedt wrote:
> On Sun, 20 Feb 2022 19:14:48 +0100
> Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
> 
> > > One benefit is to just have a test case for multiple versions. And who
> > > knows, if it is an easy implementation, perhaps there's something that
> > > needs it in a very limited embedded environment? Does it really hurt
> > > keeping it, even though it may never be used?  
> > 
> > Especially in embedded environment I would prefer zstd over zlib because
> > it performance. These days, if you can allow to compile trace-cmd you
> > should be able to include zstd, too. One downside is probably that the
> > zstd library is larger than libz.
> 
> Maybe I'll make it a compile time option. Just for history sake ;-)

Keep it as a fall back if you want. Just wanted to point out the zstd
benefits.

> > Awesome. I don't know how you make trace.dat in the end but I saw that
> > there is one trace file per CPU first. Would it make sense to compress
> > these before they are written to disk?
> 
> We could do that but it would definitely not be by default. The reason is
> that the per cpu files are created with the splice command. That is, the
> data *never* goes to user space from the time it leaves the internal kernel
> ring buffer to the time it is added to the file (with zero copy, as the
> data page is taken directly from the ring buffer). Having compression would
> require passing the data to user space and back, which would mean a higher
> probability of dropped events.
> 
> Perhaps we could add the compression algorithm into the kernel? :-/

Oh I see. So we may keep that option for later. We do have compression
in kernel for various reasons (say filesystem compression (btrfs,
ubifs), initramfs, …). We could push the whole file through the
compression before splice. I may investigate some other time ;)

> -- Steve

Sebastian
