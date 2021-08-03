Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C80C4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 13:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095F360F58
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 13:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhHCNsq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 09:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236213AbhHCNsq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 09:48:46 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E81C860EE8;
        Tue,  3 Aug 2021 13:48:34 +0000 (UTC)
Date:   Tue, 3 Aug 2021 09:48:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] libtraceevent: Add tep_print_selected_fields()
Message-ID: <20210803094832.34891886@oasis.local.home>
In-Reply-To: <75f05e4c-49bb-a2d9-cdae-58d801e58179@gmail.com>
References: <20210802112714.67631-1-y.karadz@gmail.com>
        <20210802122933.1873b6f8@oasis.local.home>
        <75f05e4c-49bb-a2d9-cdae-58d801e58179@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 3 Aug 2021 15:42:02 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 2.08.21 г. 19:29, Steven Rostedt wrote:
> > What I was talking about is to change tep_print_field() to do something like:
> > 
> > Take the current tep_print_field() and turn it into static _tep_print_field().
> > 
> >   [ Not even compiled tested ]
> >   
> 
> Hi Steven,
> 
> I am not able to make sense from the code below.
> 
> > void tep_print_field(struct trace_seq *s, void *data,
> > 		     struct tep_format_field *field)
> > {
> > 	struct tep_event = field->event;
> > 	struct tep_print_parse = event->print_fmt.print_cache;
> > 	struct tep_handle *tep = event->tep;
> > 	unsigned int offset, len;
> > 
> > 	if (event->flags & TEP_EVENT_FL_FAILED)
> > 		goto out;
> > 
> > 	if (field->flags & TEP_FIELD_IS_DYNAMIC)
> > 		dynamic_offset(tep, field, data, &offset, &len);
> > 
> > 	for (;parse; parse = parse->next) {  
> 
> You need
>          if (!parse->arg)
> 			continue;

Sure. Like I said, I never even compiled this ;-)

> 
> > 		if (parse->type == PRINT_FMT_STRING)
> > 			continue;
> > 		if (parse->arg->type != TEP_PRINT_FIELD)
> > 			continue;  
> 
> I can't understand the idea of those two checks. I printed the values and they don't seem to have any selective power.

Well, the print_cache stores portions of the print fmt format string. Where if you have something like:


  print fmt: "fd: 0x%08lx, offset: 0x%08lx, count: 0x%08lx", ((unsigned long)(REC->fd)), ((unsigned long)(REC->offset)), ((unsigned long)(REC->count))

The "fd: " part is a PRINT_FMT_STRING. We don't want anything to do with that.

But the cache part that has fields, should be an arg of type
TEP_PRINT_FIELD, which should be mapped to some field to print. That
is, one of the REC->fd, REC->offset or REC->count.

That's what you are looking to see how to print it. As it also contains
how that field should be printed normally.


> 
> > 		if (parse->arg->field.field->field != field)
> > 			continue;
> >   
> 
> This does not compile. I guess you mean
>   		if (parse->arg->field.field != field)
>   			continue;
> 
> however "parse->arg->field.field" looks like unused memory (NULL or 0xffffffff) and this check always fails.
> 
> Maybe we must call some of the process_XXX()static functions first in order to make your new version of 
> tep_print_field() works?

How are you calling it? After loading the tep with tracefs_local_events()?

Because it should be loaded via tep_parse_event(), which calll
parse_args() and load the args to the event.

Basically we should be doing what print_event_cache() does, but only
for the field we are interested in.

-- Steve

