Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E60C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Mar 2023 22:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCMWdv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 18:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCMWdu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 18:33:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820EBAB
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 15:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA131B815BE
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 22:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A64C433D2;
        Mon, 13 Mar 2023 22:33:44 +0000 (UTC)
Date:   Mon, 13 Mar 2023 18:33:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH RFC] libtraceevent: Improve exception handling in
 parse_arg_add()
Message-ID: <20230313183343.795c8c4f@gandalf.local.home>
In-Reply-To: <1e0fe72f-2dac-f825-7cd3-a5727654810a@web.de>
References: <94b6775c-406e-4b17-2984-84f1bb54f375@web.de>
        <20230313121612.3b16fcf1@gandalf.local.home>
        <1e0fe72f-2dac-f825-7cd3-a5727654810a@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 13 Mar 2023 21:35:38 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> >> diff --git a/src/event-parse.c b/src/event-parse.c
> >> index e655087..1ca5fdd 100644
> >> --- a/src/event-parse.c
> >> +++ b/src/event-parse.c
> >> @@ -6388,22 +6388,20 @@ static int parse_arg_add(struct tep_print_parse **parse, char *format,
> >>  
> >>      parg = calloc(1, sizeof(*parg));
> >>      if (!parg)
> >> -        goto error;
> >> +        return -1;
> >> +  
> 
> The first failed memory allocation does not need clean-up.
> 
> 
> >>      parg->format = strdup(format);
> >> -    if (!parg->format)
> >> -        goto error;
> >> +    if (!parg->format) {
> >> +        free(parg);  
> >            ^^^^^^^^^^
> >
> > That's clean up.  
> 
> Yes. ‒ I propose to move a single memory release into an if branch
> as a known design approach for better exception handling.

This has nothing to do with clean ups, but personal preferences. Neither is
more correct than the other. Both work. I prefer the code as is. End of
discussion.

-- Steve
