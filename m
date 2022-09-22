Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6C9C6FA82
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiIVPjW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiIVPjW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D02EB116
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:39:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E338631BB
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B33CC433C1;
        Thu, 22 Sep 2022 15:39:20 +0000 (UTC)
Date:   Thu, 22 Sep 2022 11:40:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zebediah Figura <zfigura@codeweavers.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tracecmd extract: Allow using --compression.
Message-ID: <20220922114022.7cb70457@gandalf.local.home>
In-Reply-To: <60d8be78-b725-3eb1-82a4-675d39599eae@codeweavers.com>
References: <20220901205638.3247090-1-zfigura@codeweavers.com>
        <20220921214941.0d297d5d@gandalf.local.home>
        <9e39d27a-ad6c-422e-0c4d-4a7a0fb7443d@codeweavers.com>
        <20220922083927.03e55779@gandalf.local.home>
        <60d8be78-b725-3eb1-82a4-675d39599eae@codeweavers.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Sep 2022 10:26:40 -0500
Zebediah Figura <zfigura@codeweavers.com> wrote:

> > I still, need you to write the "Signed-off-by: Name <email>" part. As I'm
> > not allowed to do it for you.  
> 
> Gah, I managed to send it as a reply to myself. Sorry about this, I 
> swear I usually am more capable of sending sign-offs...

No problem.

I applied it. Thanks Zeb!

-- Steve
