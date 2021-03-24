Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65D7C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE23619E8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbhCXSdb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229914AbhCXSdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 14:33:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC53A61A12;
        Wed, 24 Mar 2021 18:33:09 +0000 (UTC)
Date:   Wed, 24 Mar 2021 14:33:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 06/23] trace-cmd: Add new trace-cmd clock tsc2nsec
Message-ID: <20210324143308.4f0ca709@gandalf.local.home>
In-Reply-To: <20210324143207.640ebe56@gandalf.local.home>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-7-tz.stoyanov@gmail.com>
        <20210324143207.640ebe56@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 14:32:07 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 24 Mar 2021 15:04:01 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> > +static void get_tsc_offset(struct common_record_context *ctx)
> > +{
> > +	struct buffer_instance *instance;
> > +
> > +	for_all_instances(instance) {
> > +		if (is_guest(instance) || !instance->clock)
> > +			return;

			^^^^^^^

That's the return I was talking about.

-- Steve

> > +
> > +		ctx->tsc2nsec.offset = get_clock_now(instance->clock);
> > +		return;
> > +	}
> > +
> > +	ctx->tsc2nsec.offset = get_clock_now(NULL);
> > +}  
> 
> Why is the above "return" and not "continue"?
> 
> It seems inconsistent depending on the order. If the first instance found
> is a guest or does not have a clock set, then we don't get the tsc offset,
> but if the first instance is something else we do, even if a guest or an
> instance exists.
> 
> -- Steve
> 
> 
> > +
> >  /*
> >   * This function contains common code for the following commands:
> >   * record, start, stream, profile.  

