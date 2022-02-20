Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F54C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Feb 2022 19:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiBTTSY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Feb 2022 14:18:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiBTTSX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Feb 2022 14:18:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF91F50B3D
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 11:18:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A56360EB8
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 19:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8437BC340E8;
        Sun, 20 Feb 2022 19:18:00 +0000 (UTC)
Date:   Sun, 20 Feb 2022 14:17:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: trace-cmd library: Add ZSTD support.
Message-ID: <20220220141759.124bc6e6@gandalf.local.home>
In-Reply-To: <YhKFGF0sTLFddAWw@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
        <20220220121143.6022d737@gandalf.local.home>
        <YhKFGF0sTLFddAWw@breakpoint.cc>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 20 Feb 2022 19:14:48 +0100
Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> > One benefit is to just have a test case for multiple versions. And who
> > knows, if it is an easy implementation, perhaps there's something that
> > needs it in a very limited embedded environment? Does it really hurt
> > keeping it, even though it may never be used?  
> 
> Especially in embedded environment I would prefer zstd over zlib because
> it performance. These days, if you can allow to compile trace-cmd you
> should be able to include zstd, too. One downside is probably that the
> zstd library is larger than libz.

Maybe I'll make it a compile time option. Just for history sake ;-)


> 
> > > It might make sense to use zstd while dumping the per-CPU data files
> > > disks before the trace.dat is written. It probably makes sense to use
> > > zstd by default instead of storing the .dat file uncompressed.  
> > 
> > I have a patch that does the compression by default. I'm holding off
> > pushing it until I finished my testing of the compressed versions.  
> 
> Awesome. I don't know how you make trace.dat in the end but I saw that
> there is one trace file per CPU first. Would it make sense to compress
> these before they are written to disk?

We could do that but it would definitely not be by default. The reason is
that the per cpu files are created with the splice command. That is, the
data *never* goes to user space from the time it leaves the internal kernel
ring buffer to the time it is added to the file (with zero copy, as the
data page is taken directly from the ring buffer). Having compression would
require passing the data to user space and back, which would mean a higher
probability of dropped events.

Perhaps we could add the compression algorithm into the kernel? :-/

-- Steve

