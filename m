Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4174BC6FA99
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Mar 2023 17:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCJRVC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 12:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCJRVB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 12:21:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B53310D320
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Mar 2023 09:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F95E61B86
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Mar 2023 17:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF215C433D2;
        Fri, 10 Mar 2023 17:20:55 +0000 (UTC)
Date:   Fri, 10 Mar 2023 12:20:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH RFC] libtracefs: Improve exception handling in
 instance_alloc()
Message-ID: <20230310122054.56dd5377@gandalf.local.home>
In-Reply-To: <8271ccb8-6a78-689a-a1f9-c9717f1916c1@web.de>
References: <a81fe9db-2124-f84f-a8e9-203227ea910f@web.de>
        <20230310113830.26e7231d@gandalf.local.home>
        <8271ccb8-6a78-689a-a1f9-c9717f1916c1@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Mar 2023 18:02:55 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> >> How will the chances evolve to integrate the attached change suggestion?
> >>  
> > Everything is initialized to NULL, and free(NULL) is perfectly acceptable.  
> 
> I propose to avoid unnecessary data processing.

No it won't. instance_alloc() is a slow operation, no need to
micro-optimize it.

> 
> 
> 
> > Why complicate the code with more labels than needed?  
> 
> 
> * The control flow can become a bit smaller because a redundant null pointer check
>   will not be performed.
> 
> * Less function calls will be performed in some failure cases.
> 

Who cares?

> 
> 
> > So no, I will not consider this change.  
> 
> I am curious under which circumstances the shown change possibilities will become
> more attractive.

There is none.

-- Steve
