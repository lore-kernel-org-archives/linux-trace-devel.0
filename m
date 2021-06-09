Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB6EC48BCF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 20:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BCF3613DC
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 20:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhFIUTO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 16:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhFIUTO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 16:19:14 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA0D613D4;
        Wed,  9 Jun 2021 20:17:18 +0000 (UTC)
Date:   Wed, 9 Jun 2021 16:17:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Add option to poll trace buffers
Message-ID: <20210609161717.10e259b2@oasis.local.home>
In-Reply-To: <20210602100542.076a4b4e@oasis.local.home>
References: <20210602090803.12233-1-nsaenzju@redhat.com>
        <20210602100542.076a4b4e@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2 Jun 2021 10:05:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed,  2 Jun 2021 11:08:03 +0200
> Nicolas Saenz Julienne <nsaenzju@redhat.com> wrote:
> 
> > NOTE: I'm aware that TRACECMD_RECORD_POLL kind of clashes with
> >       TRACECMD_RECORD_BLOCK. That's why I renamed it. There might be a
> >       clean way to merge them into a single flag, but it's not clear to
> >       me why was TRACECMD_RECORD_BLOCK needed in the first place (since
> >       it only affects splicing).  
> 
> Yeah that was poorly named, and was added when streaming was added (not
> recording to a file, but to simply read from splice). I don't remember
> exactly all that happened back them, but you are correct, it can
> probably be better organized.
> 
> Thanks for sending the patch, I'll have a look at it this week.

FYI, I pushed this patch up to the git repo.

Thanks,

-- Steve

