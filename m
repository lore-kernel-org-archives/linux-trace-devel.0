Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7837C001DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 03:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjHIDT6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjHIDT5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 23:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7291BF0
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 20:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71E8362ED1
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 03:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657E4C433C7;
        Wed,  9 Aug 2023 03:19:55 +0000 (UTC)
Date:   Tue, 8 Aug 2023 23:19:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 6/6] libtraceeval samples: Update task-eval to use the
 histogram logic
Message-ID: <20230808231953.42207bd7@gandalf.local.home>
In-Reply-To: <20230809031313.1298605-7-rostedt@goodmis.org>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
        <20230809031313.1298605-7-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  8 Aug 2023 23:13:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Convert task-eval over to the new API.
> 
> Note, it still requires some functions for displaying the output, but
> those were added just as stubs to get an idea on how to use it.

I should add that this is still RFC, and not ready at all for inclusion.

There's lots of issues with this patch (like I see I use .number still for
the data that's of POINTER type). These will all be fixed before they go
upstream.

Anyway, I posted this so that you can have an idea of a use case for how
this will work.

-- Steve


> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |   1 +
>  samples/Makefile         |   2 +-
>  samples/task-eval.c      | 683 ++++++++++++++++++++++-----------------
>  3 files changed, 388 insertions(+), 298 deletions(-)
> 
