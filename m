Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0453C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Mar 2022 07:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiCCHKI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 02:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiCCHKH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 02:10:07 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1ED120F5E
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Mar 2022 23:09:22 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nPfaQ-0007ye-1c; Thu, 03 Mar 2022 08:09:18 +0100
Date:   Thu, 3 Mar 2022 08:09:17 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] trace-cmd: Use errno from zlib, if available
Message-ID: <YiBpnYaudLpde0dF@breakpoint.cc>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
 <20220302045131.387658-4-tz.stoyanov@gmail.com>
 <Yh8Zkh7nQhLZnpsU@breakpoint.cc>
 <20220302105230.179ad64a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302105230.179ad64a@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-03-02 10:52:30 [-0500], Steven Rostedt wrote:
> On Wed, 2 Mar 2022 08:15:30 +0100
> Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
> 
> > I was thinking about returning the error for compress/decompress via the
> > return value and not touching errno at all.
> 
> I know you hate the use of ERRNO in libraries and tooling, but we've decided
> to go that way for all of trace-cmd and the libraries (libtraceevent and
> libtracefs). This is just being consistent with all the other callers, and
> to do it differently will create an inconsistency in the API.

Ah okay then. In that case, the zstd interface does not set errno in the
compress or decompress callback. This might need an update to be
consistent. Otherwise the return value is < 0 and errno might still be
0.

> -- Steve

Sebastian
