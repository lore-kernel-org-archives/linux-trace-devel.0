Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD84C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Mar 2023 22:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCMWgj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 18:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjCMWgi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 18:36:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDD929162
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 15:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73717B81200
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 22:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757A6C433EF;
        Mon, 13 Mar 2023 22:36:17 +0000 (UTC)
Date:   Mon, 13 Mar 2023 18:36:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH] libtracefs: Fix the label usage in check_option()
Message-ID: <20230313183615.39130acc@gandalf.local.home>
In-Reply-To: <ba3d11ce-6b52-3a6e-eb36-507c3473a4fb@web.de>
References: <dc6bda64-4909-160f-dc94-b0a7ac999234@web.de>
        <20230313124050.05750d39@gandalf.local.home>
        <ba3d11ce-6b52-3a6e-eb36-507c3473a4fb@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 13 Mar 2023 21:55:10 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> >> The label “out” was used to jump to a source code place after some
> >> failure cases. This implementation detail hindered better exception handling.  
> > "out" is a perfectly fine name.  
> 
> I got the impression that this identifier can occasionally trigger
> undesirable side effects.
> 

No it doesn't.

> 
> >> Use more appropriate labels instead.
> >>
> >> * Reorder jump targets at the end.  
> > Why?  
> 
> 
> Resources should be released in the opposite order as they were allocated.

That's a preference not a mandate.

> 
> 
> >> * Delete a condition check.  
> > Why?  
> 
> Such extra code can be avoided.

So what?

> 
> 
> >> * Omit an extra initialisation (for the variable “fd”)
> >>   which became unnecessary with this change.
> >>
> >> Fixes: f7951864c7766ba3d683e8676fe0e497991796b2 ("libtracefs: Unit tests for tracing options APIs")  
> > What was fixed???  
> 
> The exception handling was improved, wasn't it?

No it wasn't.

> 
> 
> >> +++ b/utest/tracefs-utest.c  
> > This is a test file. It's run in tests.  
> 
> I propose to enhance it a bit.

It's not enhanced at all. It's just changing to different personal
preferences and does not improve the code one iota!

-- Steve

