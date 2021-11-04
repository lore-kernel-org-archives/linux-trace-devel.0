Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8886C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 01:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB1F460C49
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 01:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhKDBUB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhKDBT7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 21:19:59 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4386054E;
        Thu,  4 Nov 2021 01:17:21 +0000 (UTC)
Date:   Wed, 3 Nov 2021 21:17:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] libtracefs: New APIs for dynamic events
Message-ID: <20211103211718.5b0987ae@rorschach.local.home>
In-Reply-To: <20211103130319.0c932fce@gandalf.local.home>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
        <20211103154417.246999-3-tz.stoyanov@gmail.com>
        <20211103130319.0c932fce@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 3 Nov 2021 13:03:19 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed,  3 Nov 2021 17:44:08 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> > +static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
> > +			     char *line, struct tracefs_dynevent **ret_dyn)
> > +{
> > +	struct tracefs_dynevent *dyn;
> > +	char *format = NULL;
> > +	char *address;
> > +	char *system;
> > +	char *prefix;
> > +	char *event;
> > +	char *sav;
> > +
> > +	if (strncmp(line, desc->prefix, strlen(desc->prefix)))
> > +		return -1;
> > +
> > +	prefix = strtok_r(line, ":", &sav);
> > +	if (!prefix)
> > +		return -1;  
> 
> What if the user adds a name for the event?
> 
> 	p:name system/event
> 
> ?

Ignore this. I see now that this isn't for user input, but how you
parse the dynamic event file, which has the format of:

 p:system/event ...

I was thinking this was user input not the content from the kernel.

-- Steve

