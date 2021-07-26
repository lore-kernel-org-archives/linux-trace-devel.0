Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1774C4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 15:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D968860F59
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 15:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbhGZOoQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhGZOoQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 10:44:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B2E660F58;
        Mon, 26 Jul 2021 15:24:44 +0000 (UTC)
Date:   Mon, 26 Jul 2021 11:24:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH] libtracefs: Remove "traceevent/" from referencing
 libtraceevent headers
Message-ID: <20210726112442.4574ffba@oasis.local.home>
In-Reply-To: <a359be7c-3d90-7941-2eee-d8cdc225e4a5@gmail.com>
References: <20210716220649.46aab3f7@rorschach.local.home>
        <a359be7c-3d90-7941-2eee-d8cdc225e4a5@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Jul 2021 13:25:41 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index 7e1927b..2649417 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -9,7 +9,7 @@
> >   #include <sys/stat.h>
> >   #include <fcntl.h>
> >   #include <sched.h>
> > -#include <traceevent/event-parse.h>
> > +#include <event-parse.h>  
> 
> Perhaps we need a similar patch for "trace-cmd.h".

Like this?

  https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/commit/?h=trace-cmd-stable-v2.9&id=c3bf2ced24528debba6e6c48c77e3868cdb3dec1


I pushed it for v2.9 because it was broken if libtraceeevent was
installed. I'll make sure it's there for the development branch as well.

-- Steve
