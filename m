Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8914C6FA99
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Mar 2023 16:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCJQmV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 11:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjCJQmF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 11:42:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35F575A74
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Mar 2023 08:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 923DDB82348
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Mar 2023 16:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA9CC4339C;
        Fri, 10 Mar 2023 16:38:32 +0000 (UTC)
Date:   Fri, 10 Mar 2023 11:38:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH RFC] libtracefs: Improve exception handling in
 instance_alloc()
Message-ID: <20230310113830.26e7231d@gandalf.local.home>
In-Reply-To: <a81fe9db-2124-f84f-a8e9-203227ea910f@web.de>
References: <a81fe9db-2124-f84f-a8e9-203227ea910f@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Mar 2023 17:30:22 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> Hello,
> 
> I hope that the following information sources can be taken better into account.
> 
> * Centralized exiting of functions
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.3-rc1#n526
> 
> * MEM12-C: Consider using a goto chain when leaving a function on error when using and releasing resources
>   https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.+Consider+using+a+goto+chain+when+leaving+a+function+on+error+when+using+and+releasing+resources#MEM12C.Considerusingagotochainwhenleavingafunctiononerrorwhenusingandreleasingresources-CompliantSolution%28POSIX,GotoChain%29
> 
> 
> How will the chances evolve to integrate the attached change suggestion?
> 

Everything is initialized to NULL, and free(NULL) is perfectly acceptable.
Why complicate the code with more labels than needed?

So no, I will not consider this change.

-- Steve

