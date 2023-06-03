Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DCAC7EE24
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 04:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjFCEJp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 00:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjFCEJo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 00:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640D5E41
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 21:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E91916069D
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 04:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F005CC433D2;
        Sat,  3 Jun 2023 04:09:41 +0000 (UTC)
Date:   Sat, 3 Jun 2023 00:09:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd record: Remove redundant check of instance in
 allocate_instance()
Message-ID: <20230603000938.144f7e70@rorschach.local.home>
In-Reply-To: <325a00ce-72c0-bfbd-10b4-30db178500bb@web.de>
References: <20230602040123.3ce83b19@rorschach.local.home>
        <325a00ce-72c0-bfbd-10b4-30db178500bb@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Jun 2023 15:12:11 +0200
Markus Elfring <Markus.Elfring@web.de> wrote:

> > The error path only happens after the instance has been allocated.
> > No need to check if it exists again.
> >
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217127  
> 
> Will it be more appropriate to refer to an other bug report here?

I first wasn't going to bother with it, but then I started modifying
code around it where you mention this in the above mentioned bug, and
tagged that one. I can modify it to have you original one (I'll do that
internally, not with a v2).

> 
> 2023-03-04
> Improve exception handling in allocate_instance()
> https://bugzilla.kernel.org/show_bug.cgi?id=217128
> 
> 
> Will any additional adjustments become helpful for jump targets
> in this function implementation?

No need to spend cycles on this. It's a very slow path. Optimizing it
is nothing more than an academic exercise.

-- Steve
