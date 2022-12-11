Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1565AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 11 Dec 2022 02:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiLKCJ2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 21:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKCJ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 21:09:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC577101EE
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Dec 2022 18:09:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87CBE60CEE
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Dec 2022 02:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FFDC433D2;
        Sun, 11 Dec 2022 02:09:24 +0000 (UTC)
Date:   Sat, 10 Dec 2022 21:09:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Let subcommand "convert" automatically if
 possible.
Message-ID: <20221210210922.6834b53b@gandalf.local.home>
In-Reply-To: <Y5Tt6p0ONpuDVIS2@breakpoint.cc>
References: <Y5Tt6p0ONpuDVIS2@breakpoint.cc>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 10 Dec 2022 21:36:58 +0100
Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> Let the convert subcommand compress automatically if the file format
> allows it and the user did not specify it.
> This already the case the record command.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc

Oops, broken email, I'll fix.

Applied, thanks Sebastian!

-- Steve
