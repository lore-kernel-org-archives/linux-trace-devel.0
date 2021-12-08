Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E61C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Dec 2021 23:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhLHX2V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:28:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48334 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhLHX2V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 18:28:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED1D8B822BD
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Dec 2021 23:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72722C00446;
        Wed,  8 Dec 2021 23:24:46 +0000 (UTC)
Date:   Wed, 8 Dec 2021 18:24:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] libtracefs: New APIs for getting the raw format of
 synth event
Message-ID: <20211208182445.26419168@gandalf.local.home>
In-Reply-To: <85fef0bf-879d-06a9-f2fd-de2d0171fb1d@gmail.com>
References: <20211206151352.361507-1-y.karadz@gmail.com>
        <20211207171351.2928503d@gandalf.local.home>
        <85fef0bf-879d-06a9-f2fd-de2d0171fb1d@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 8 Dec 2021 15:31:26 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> >>    remove_start_hist:
> >> -	remove_hist(synth->instance, synth->start_event, start_hist);
> >> +	remove_hist(synth->instance, synth->start_event, synth->start_hist);
> >>    remove_synthetic:
> >> -	free(end_hist);
> >> -	free(start_hist);
> >>   	tracefs_dynevent_destroy(synth->dyn_event, false);  
> > I just realized that on error, we do not free the synthetic event
> > descriptor. So there is a memory leak.
> >   
> 
> Do we need to free the synthetic event here?
> 
> The event gets allocated with 'tracefs_synth_alloc()' and the user is responsible for calling 'tracefs_synth_free()' in 
> order to free the memory.
> The fact that 'tracefs_synth_create()' may fail doesn't change this.

Ah, you're correct. I was thinking that we allocated it here, but forgot we
separated create and alloc.

-- Steve
