Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658BEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Feb 2022 18:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbiBTSPP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Feb 2022 13:15:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiBTSPP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Feb 2022 13:15:15 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB23527EF
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 10:14:53 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nLqjQ-00040h-OS; Sun, 20 Feb 2022 19:14:48 +0100
Date:   Sun, 20 Feb 2022 19:14:48 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: trace-cmd library: Add ZSTD support.
Message-ID: <YhKFGF0sTLFddAWw@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
 <20220220121143.6022d737@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220220121143.6022d737@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-02-20 12:11:43 [-0500], Steven Rostedt wrote:
> On Sun, 20 Feb 2022 00:01:50 +0100
> Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
> 
> > Steven mentioned that trace-cmd recently gained compression support. I
> > suggest to remove zlib since there is no real benefit to use this
> > compression algorithm.
> 
> One benefit is to just have a test case for multiple versions. And who
> knows, if it is an easy implementation, perhaps there's something that
> needs it in a very limited embedded environment? Does it really hurt
> keeping it, even though it may never be used?

Especially in embedded environment I would prefer zstd over zlib because
it performance. These days, if you can allow to compile trace-cmd you
should be able to include zstd, too. One downside is probably that the
zstd library is larger than libz.

> > It might make sense to use zstd while dumping the per-CPU data files
> > disks before the trace.dat is written. It probably makes sense to use
> > zstd by default instead of storing the .dat file uncompressed.
> 
> I have a patch that does the compression by default. I'm holding off
> pushing it until I finished my testing of the compressed versions.

Awesome. I don't know how you make trace.dat in the end but I saw that
there is one trace file per CPU first. Would it make sense to compress
these before they are written to disk?

> Thanks Sebastian for this update!

You are welcome.

> -- Steve

Sebastian
