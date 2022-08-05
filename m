Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D35C00140
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbiHEPua (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241316AbiHEPuP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3847B78A
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:47:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEDD261616
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDBBC433D7;
        Fri,  5 Aug 2022 15:47:49 +0000 (UTC)
Date:   Fri, 5 Aug 2022 11:47:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Document new proxy args for {agent,record}
Message-ID: <20220805114748.6e470854@gandalf.local.home>
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

Applied. Thanks Brian!

-- Steve
