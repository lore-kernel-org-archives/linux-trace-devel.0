Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806ADC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 02:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E6A613FA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 02:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhDUCSW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 22:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233950AbhDUCSW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 22:18:22 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA7D761406;
        Wed, 21 Apr 2021 02:17:48 +0000 (UTC)
Date:   Tue, 20 Apr 2021 22:17:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-trace-devel@vger.kernel.org, dfaggioli@suse.com
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
Message-ID: <20210420221746.1899d496@oasis.local.home>
In-Reply-To: <7edad92d-3297-fd42-9ac2-0334816fb524@gmail.com>
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
        <7edad92d-3297-fd42-9ac2-0334816fb524@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 20 Apr 2021 11:12:59 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:


> > diff --git a/examples/checker.c b/examples/checker.c
> > new file mode 100644
> > index 0000000..0b04343
> > --- /dev/null
> > +++ b/examples/checker.c
> > @@ -0,0 +1,202 @@  
> 
> The first problem is that this patch fails to apply. My guess is that 
> you hand-edited the patch and removed some lines starting with "+". Note 
> that the total number of additions and removals in the file is indicated 
> in the line above. If this number does not match the number of lines 
> starting with "+", the patch will fail to apply.
> 
> As a general advise - try to avoid hand-editing patches unless you are 
> certain you know what you are doing.

Or hand edit the patches using emacs ;-)

That's because emacs has a "patch mode" that updates those numbers when
you modify the patch!

-- Steve
