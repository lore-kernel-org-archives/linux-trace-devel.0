Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62200C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Feb 2022 14:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiBYOGr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Feb 2022 09:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiBYOGq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Feb 2022 09:06:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967F71C8D99
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Feb 2022 06:06:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4F0460C01
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Feb 2022 14:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94F8C340E7;
        Fri, 25 Feb 2022 14:06:12 +0000 (UTC)
Date:   Fri, 25 Feb 2022 09:06:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Ian Rogers <irogers@google.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] trace-cruncher: Initial support for perf
Message-ID: <20220225090611.66ca11e1@gandalf.local.home>
In-Reply-To: <CAPpZLN4RoEjhKJb+d2UB3cnJfuNzdSiu4dV8RZe=aCBUaBxWog@mail.gmail.com>
References: <20220224163711.185308-1-tz.stoyanov@gmail.com>
        <CAP-5=fVsQ2kGTvCDmovLWR00SDKQz635ftVmLphZcMM82sGKHA@mail.gmail.com>
        <CAPpZLN4RoEjhKJb+d2UB3cnJfuNzdSiu4dV8RZe=aCBUaBxWog@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Feb 2022 12:21:22 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > The comment from the bug:
> > perf can link against libbfd if available, but the result is
> > undistributable as they are licenced under GPL v2 and v3+
> > respectively.
> >  
> 
> Hi Ian, thank you for this note. Trace-cruncher is a library licensed
> under LGPLv2.1, so it should not be a problem to use libbfd. Is my
> understanding correct, as I'm not an expert in all these licences ?

trace-cruncher can link with libbfd as LGPLv2.1 is compatible with GPLv3.
But note, this will limit what can link with trace-cruncher if it is
distributed and provides a library.

That is, if you have a trace-cruncher library, even though it is LGPLv2.1,
because it links to a GPLv3 library, then anything that links to the
trace-cruncher library must be GPLv3 compatible.

This is why I separated some code out of trace-cmd (although that code has
since been removed). I took GPL code, and used it in the binary of
trace-cmd. But I kept the libtracecmd code separate, where as, the
distributed libtracecmd code (that is LGPLv2.1) never contained any GPL
code, nor did it depend on any.

And now thinking about this more, and that we are starting to include
libraries into libtracecmd (for compression and other things), we need to
look carefully at the licenses for those libraries to make sure they do not
impose any more restrictions than what LGPL has.

The general rule of thumb is that you are constrained by the strictest
rules of everything provided by a library. If any part of the library
imposes a restriction, whatever links to that library must follow that
restriction.

-- Steve
