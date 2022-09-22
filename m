Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67986C6FA8E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 01:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiIVBqN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 21:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiIVBqM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 21:46:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDC2A1D30
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 18:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8299CB81993
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 01:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA968C433D6;
        Thu, 22 Sep 2022 01:46:08 +0000 (UTC)
Date:   Wed, 21 Sep 2022 21:47:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John 'Warthog9' Hawley <warthog9@eaglescrag.net>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Add compile time overrides for libraries
Message-ID: <20220921214710.32235d8f@gandalf.local.home>
In-Reply-To: <20220826225904.1824344-1-warthog9@eaglescrag.net>
References: <20220826225904.1824344-1-warthog9@eaglescrag.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Aug 2022 15:59:04 -0700
John 'Warthog9' Hawley <warthog9@eaglescrag.net> wrote:

> Continuing in the ld.lld link issues trace-cmd needs to override
> -lrt -lpthread and -ldl.  This adds the ability, from the command line,
> adjust LIBS, LRT and LPTHREAD
> 
> Signed-off-by: John 'Warthog9' Hawley <warthog9@eaglescrag.net>
> ---

Applied. Thanks John!

-- Steve
