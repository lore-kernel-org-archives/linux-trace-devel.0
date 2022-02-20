Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF81C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Feb 2022 17:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiBTRMM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Feb 2022 12:12:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiBTRML (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Feb 2022 12:12:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D37255B0
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 09:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 545EAB80D33
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 17:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E10C340E8;
        Sun, 20 Feb 2022 17:11:44 +0000 (UTC)
Date:   Sun, 20 Feb 2022 12:11:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: trace-cmd library: Add ZSTD support.
Message-ID: <20220220121143.6022d737@gandalf.local.home>
In-Reply-To: <20220219230151.56282-1-sebastian@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 20 Feb 2022 00:01:50 +0100
Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> Steven mentioned that trace-cmd recently gained compression support. I
> suggest to remove zlib since there is no real benefit to use this
> compression algorithm.

One benefit is to just have a test case for multiple versions. And who
knows, if it is an easy implementation, perhaps there's something that
needs it in a very limited embedded environment? Does it really hurt
keeping it, even though it may never be used?

> It might make sense to use zstd while dumping the per-CPU data files
> disks before the trace.dat is written. It probably makes sense to use
> zstd by default instead of storing the .dat file uncompressed.

I have a patch that does the compression by default. I'm holding off
pushing it until I finished my testing of the compressed versions.

Thanks Sebastian for this update!

-- Steve
