Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AFEC43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 16:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D139661040
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 16:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhCaQjS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234050AbhCaQjP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 12:39:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 624946100C;
        Wed, 31 Mar 2021 16:39:14 +0000 (UTC)
Date:   Wed, 31 Mar 2021 12:39:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 08/13 v2] libtracefs: Allow for setting filters with
 regex expressions
Message-ID: <20210331123912.6295e9c1@gandalf.local.home>
In-Reply-To: <96e9fc99-53c5-ea5a-7e5d-5ea6dafc1f7c@gmail.com>
References: <20210330005123.151740983@goodmis.org>
        <20210330005248.391852830@goodmis.org>
        <96e9fc99-53c5-ea5a-7e5d-5ea6dafc1f7c@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 1 Apr 2021 22:03:02 +0530
sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> hi steve,
> 
> On 30/03/21 6:21 am, Steven Rostedt wrote:
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> >
> > All for full "regex(3)" processing of setting functions in the
> > set_ftrace_filter file. Check if the filter passed in is just a glob
> > expression that the kernel can process, or if it is a regex that should look
> > at the available_filter_functions list instead.
> >
> > If it is a regex, it will read the available_filter_functions and write in
> > each function as it finds it.
> >
> > Link: https://lore.kernel.org/linux-trace-devel/20210323013225.451281989@goodmis.org
> >
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> >   Documentation/libtracefs-function-filter.txt |  10 ++
> >   src/tracefs-tools.c                          | 139 ++++++++++++++++---
> >   2 files changed, 128 insertions(+), 21 deletions(-)
> >
> > diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
> > index c0c89f372c21..88aa3b923d54 100644
> > --- a/Documentation/libtracefs-function-filter.txt
> > +++ b/Documentation/libtracefs-function-filter.txt
> > @@ -32,6 +32,16 @@ _errs_, is a pointer to an array of strings, which will be allocated if
> >   any of filters fail to match any available function, If _errs_ is NULL, it will
> >   be ignored.
> >   
> > +A filter in the array of _filters_ may be either a straight match of a
> > +function, a glob or regex(3). a glob is where '*' matches zero or more
> > +characters, '?' will match zero or one character, and '.' only matches a
> > +period. If the filter is determined to be a regex (where it contains
> > +anything other than alpha numeric characters, or '.', '*', '?') the filter
> > +will be processed as a regex(3) following the rules of regex(3), and '.' is
> > +not a period, but will match any one character. To force a regular
> > +expression, either prefix the filter with a '^' or append it with a '$' as
> > +all filters will act as complete matches of functions anyway.
> > +  
> 
> if we give the filter as regex "^ext4*$" from user side, ideally it 
> should match the ext4 filter functions, if i am not wrong, its not 
> matching any filter in the available_filter_functions

If you add the "^" and/or "$" it makes it into a regex. The above means
that the filter will match "ext", "ext4", "ext44", "ext4444444"

Because "*" means zero or more of the previous character. So, unless
there's a function that matches one of the above, it wont match anything
else.

If you left off the "^" and "$" then it would be a glob, where "*" means
zero or more of any character. But if you want the same in regex, you need
to use:

 "^ext4.*$"


> 
> is this expected behaviour?
> 
> if we give the filter as glob "ext4*" from userside, its making the 
> regex and matching the ext4 filter functions in the 
> available_filter_functions.

Yes, because the conversion changes the glob "ext4*" into "^ext4.*$".

Also, for email etiquette, please sign you last comment, or cut the rest of
the reply. That way I don't have to scroll the rest of the email to know if
there's anything else you commented on.

-- Steve
