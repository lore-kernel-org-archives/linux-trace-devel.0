Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66727C19F2A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Aug 2022 17:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiHDRtX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 13:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiHDRtW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 13:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778891147C
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Aug 2022 10:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1413C614FE
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Aug 2022 17:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15097C433D6;
        Thu,  4 Aug 2022 17:49:19 +0000 (UTC)
Date:   Thu, 4 Aug 2022 13:49:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Document new proxy args for {agent,record}
Message-ID: <20220804134918.180c3a67@gandalf.local.home>
In-Reply-To: <20220804103729.1.Ia9701619f867f6acbec9e20bf89ed41979fcce87@changeid>
References: <20220804103729.1.Ia9701619f867f6acbec9e20bf89ed41979fcce87@changeid>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Aug 2022 10:37:43 -0700
Brian Norris <briannorris@chromium.org> wrote:

> Largely cribbed off the commit message introducing these:
> 
> 4f9d216ee312 trace-cmd: Add agent proxy communications between record and agent
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> NB: I may not have all the vsock/VM/proxy lingo quite right, so feel
> free to correct!

Content looks good. I'll fix up the change log though ;-)

Thanks!

-- Steve
