Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCD5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 07:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbiCBHN5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 02:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbiCBHN4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 02:13:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A032522E7
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 23:13:14 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nPJAd-0000e1-Tm; Wed, 02 Mar 2022 08:13:11 +0100
Date:   Wed, 2 Mar 2022 08:13:11 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 5/5] trace-cmd: Use context hooks in zstd
Message-ID: <Yh8ZBxPVe9FYw/OU@breakpoint.cc>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
 <20220302045131.387658-6-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302045131.387658-6-tz.stoyanov@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-03-02 06:51:31 [+0200], Tzvetomir Stoyanov (VMware) wrote:
> Using global compression context could be a limitation in multithreaded
> use cases. Use context hooks instead of global compression context.
> 
> Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Sebastian
