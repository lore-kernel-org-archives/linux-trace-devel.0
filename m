Return-Path: <SRS0=jVtL=2A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89616C43603
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 15:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6611920836
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 15:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfLJPsc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 10:48:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727211AbfLJPsb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 10:48:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF04420836;
        Tue, 10 Dec 2019 15:48:30 +0000 (UTC)
Date:   Tue, 10 Dec 2019 10:48:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 14/18] trace-cmd: Add host trace clock as guest
 trace argument
Message-ID: <20191210104829.36071c41@gandalf.local.home>
In-Reply-To: <CAPpZLN6xhsdd8Xyocm2rRGesCsW5Wsk2X3ZiEvJW948xXda-kQ@mail.gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-15-tz.stoyanov@gmail.com>
        <20191209143101.146cb619@gandalf.local.home>
        <CAPpZLN6xhsdd8Xyocm2rRGesCsW5Wsk2X3ZiEvJW948xXda-kQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 10 Dec 2019 10:49:43 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > > +     if (guest_config) {
> > > +             /* If -C is specified, prepend clock to all guest VM flags */
> > > +             for_all_instances(instance) {
> > > +                     if (top_instance.ftrace->clock) {
> > > +                             if (is_guest(instance)) {  
> >
> > We should only append this, if the guest didn't have a clock set
> > already. As the change log seems to say, if the user states a "-C
> > clock" for the guest, that should take precedence over the host clock
> > set. That is, a user may specifically state that they are using a
> > different clock. If we have frequency and offset set, it should still
> > work with different clocks.  
> 
> The guest config string is not parsed in the host context, that's why the host
> doesn't know if a guest has an explicit  "-C clock" argument.
> I can parse the guest config here, but this will complicate the implementation.
> Using the current approach still guarantees that the user specified
> config has higher
> priority than injected one - add_argv() API prepends to the beginning
> of the string, so
> user arguments are always after the injected one. When guest parses
> the string, in case of
> duplicated "-C clock" arguments, the last one wins.

I'm confused. I'm looking at this:


	for (;;) {
		[..]
		switch (c) {
		[..]
		case 'A':
			[..]
			ctx->instance->flags |= BUFFER_FL_GUEST;
		[..]
		case 'C':
			ctx->instance->ftrace->clock = optarg;
			guest_config = true;
			break;
		[..]
		}
		[..]
	}
	[..]
	if (guest_config) {
		/* If -C is specified, prepend clock to all guest VM flags */
		for_all_instances(instance) {
			if (top_instance.ftrace->clock) {

Why can't we have here:

 if (top_instance.ftrace->clock && !instance->ftrace->clock)

If the guest instance was given a -C, I would think we don't want to add
another -C to pass to that guest?

-- Steve

				if (is_guest(instance)) {
					add_argv(instance,
						 (char *)top_instance.ftrace->clock,
						 true);
					add_argv(instance, "-C", true);
				}
			}
		}
	}
