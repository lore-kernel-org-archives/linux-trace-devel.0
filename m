Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA64C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 01:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiKJBIb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 20:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKJBIa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 20:08:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3BF1B3
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 17:08:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64F4861CE8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 01:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3934C433D6;
        Thu, 10 Nov 2022 01:08:26 +0000 (UTC)
Date:   Wed, 9 Nov 2022 20:08:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Bergin <peter@berginkonsult.se>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: make it possible to set libdir and
 mandir from outside
Message-ID: <20221109200823.38750fd6@rorschach.local.home>
In-Reply-To: <20221109194310.19a76ee2@rorschach.local.home>
References: <20221031212140.170601-1-peter@berginkonsult.se>
        <ed05620a-7ce2-cd8b-320f-9a07019758d2@berginkonsult.se>
        <20221109194310.19a76ee2@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 9 Nov 2022 19:43:10 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > This patch has been superseded by a v2 patch because I did a mistake and 
> > wrote the wrong prefix. Reference to new patch: 
> > https://lore.kernel.org/linux-trace-devel/20221101111143.191772-1-peter@berginkonsult.se/  
> 
> This one applies to libtraceevent,  I think you meant to reply to:
> 
>   https://lore.kernel.org/all/20221031212110.170564-1-peter@berginkonsult.se/

Anyway, I applied this to libtraceevent. Thanks!

-- Steve
