Return-Path: <SRS0=a1Iv=2B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB55C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 15:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A4621556
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 15:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfLKPBC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727457AbfLKPBC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 10:01:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24AE9214AF;
        Wed, 11 Dec 2019 15:01:02 +0000 (UTC)
Date:   Wed, 11 Dec 2019 10:01:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 14/18] trace-cmd: Add host trace clock as guest
 trace argument
Message-ID: <20191211100100.45bb34f8@gandalf.local.home>
In-Reply-To: <CAPpZLN7bY8=PMwJnB02SRrdxiTRJjE-RwAwnADQBy5oFfhcffQ@mail.gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-15-tz.stoyanov@gmail.com>
        <20191209143101.146cb619@gandalf.local.home>
        <CAPpZLN6xhsdd8Xyocm2rRGesCsW5Wsk2X3ZiEvJW948xXda-kQ@mail.gmail.com>
        <20191210104829.36071c41@gandalf.local.home>
        <CAPpZLN7bY8=PMwJnB02SRrdxiTRJjE-RwAwnADQBy5oFfhcffQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 Dec 2019 10:21:44 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> In case of a guest ("-A" option), the logic skips the switch(), so the
> guest args are not parsed.
> There is a check, right before the switch() :

Ah, thanks, I forgot about that.


> 
>         /*
>          * If the current instance is to record a guest, then save
>          * all the arguments for this instance.
>          */
>         if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
>             add_arg(ctx->instance, c, opts, long_options, optarg);
>             continue;
>         }
> 
> I can put inside that if() a check for "-C" guest argument, but it
> will look like a hack.

I disagree. It's no more of a "hack" than appending a "-C" to the
arguments. I think it's the right solution. We can simply add:

	if (c == 'C')
		ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;

Then we could test if that flag is set for the instance below.

-- Steve

> 
> The confusion is that guest_config is set to true for any "-C" host argument,
> including those for instances, but only the one from the top instance
> is used to inject
> guest clock arg.
> 
> 
> > -- Steve
> >
> >                                 if (is_guest(instance)) {
> >                                         add_argv(instance,
> >                                                  (char *)top_instance.ftrace->clock,
> >                                                  true);
> >                                         add_argv(instance, "-C", true);
> >                                 }
> >                         }
> >                 }
> >         }  
> 
> 
> 

