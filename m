Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC516C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C611F61059
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbhHLOAk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232351AbhHLOAj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 10:00:39 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 505C76104F;
        Thu, 12 Aug 2021 14:00:12 +0000 (UTC)
Date:   Thu, 12 Aug 2021 10:00:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 1/2] libtracefs: Add random number to keep synthetic
 variables unique
Message-ID: <20210812100010.0f3922d1@oasis.local.home>
In-Reply-To: <13bed3a6-7e39-eec2-2421-a80081302a81@gmail.com>
References: <20210812005546.910833-1-rostedt@goodmis.org>
        <20210812005546.910833-2-rostedt@goodmis.org>
        <13bed3a6-7e39-eec2-2421-a80081302a81@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 11:34:57 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > @@ -957,7 +960,15 @@ static char *new_arg(struct tracefs_synth *synth)
> >   	char *arg;
> >   	int ret;
> >   
> > -	ret = asprintf(&arg, "__arg__%d", cnt);
> > +	/* Create a unique argument name */
> > +	if (!synth->arg_name[0]) {
> > +		srand(time(NULL));  
> 
> Nit: Have in mind that time(NULL) has 1 second resolution. Fast consecutive calls (within a second) of this function can 
> generate identical random numbers.
> This can be mitigated if we do something like this:
> 
> 		struct timeval now;
> 
> 		gettimeofday(&now, NULL);
> 		srand(now.tv_usec);

So you are saying that if one thread created two synthetic events
within a second, then this could give the same value. Yeah, I can see
that could happen. I was hoping to avoid the declaring the "now" and
calling gettimeofday().

Also, looking more into this, I see that rand() is not safe in thread
context (it may not be a problem, but there's no guarantee), and
perhaps we should just open code it, to be on the safe side.

Thanks for the review.

-- Steve
