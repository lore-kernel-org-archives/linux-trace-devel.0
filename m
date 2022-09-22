Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C8AC6FA82
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 12:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiIVMia (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 08:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiIVMi3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 08:38:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CE9E7C01
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 05:38:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12DE5B8362D
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 12:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DE1C433C1;
        Thu, 22 Sep 2022 12:38:25 +0000 (UTC)
Date:   Thu, 22 Sep 2022 08:39:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zebediah Figura <zfigura@codeweavers.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tracecmd extract: Allow using --compression.
Message-ID: <20220922083927.03e55779@gandalf.local.home>
In-Reply-To: <9e39d27a-ad6c-422e-0c4d-4a7a0fb7443d@codeweavers.com>
References: <20220901205638.3247090-1-zfigura@codeweavers.com>
        <20220921214941.0d297d5d@gandalf.local.home>
        <9e39d27a-ad6c-422e-0c4d-4a7a0fb7443d@codeweavers.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Sep 2022 21:20:57 -0500
Zebediah Figura <zfigura@codeweavers.com> wrote:

> On 9/21/22 20:49, Steven Rostedt wrote:
> > On Thu,  1 Sep 2022 15:56:38 -0500
> > Zebediah Figura <zfigura@codeweavers.com> wrote:
> >   
> >> From: Zeb Figura <zfigura@codeweavers.com>
> >>
> >> This is already supported and works as expected; allow the option to be
> >> specified.  
> > 
> > Hi Zeb,
> > 
> > I'd love to accept this patch, but I need you to add your "Signed-off-by"
> > tag.
> > 
> >    See https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/tree/DCO
> > 
> > You can either resend the patch, or reply with it here.  
> 
> Oops, I swear I even specifically remember seeing that in the 
> contribution instructions, but forgot to actually add it :-(
> 
> Sent as reply.

I still, need you to write the "Signed-off-by: Name <email>" part. As I'm
not allowed to do it for you.

-- Steve

