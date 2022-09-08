Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3B1C54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Sep 2022 23:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiIHXeT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiIHXd2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 19:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833B01153B7
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 16:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75CB761E2C
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 23:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A782C433D6;
        Thu,  8 Sep 2022 23:30:09 +0000 (UTC)
Date:   Thu, 8 Sep 2022 19:30:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: allow pthread inclusion overrideable in
 Makefile
Message-ID: <20220908193051.10796ff0@gandalf.local.home>
In-Reply-To: <20220820020255.754420-1-warthog9@eaglescrag.net>
References: <20220820020255.754420-1-warthog9@eaglescrag.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Aug 2022 19:02:55 -0700
"John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net> wrote:

> clang fails if you attempt to inclued -lpthread in the linking phase for
> certain versions of clang (newer seems to be happier with it).  This
> should allow for -lpthread to be overridden on the builds where it's
> causing problems
> 
> Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
> ---

Applied. Thanks John!

-- Steve
