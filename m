Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D18C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77D2613C6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242129AbhDFMga (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhDFMga (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 08:36:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0646D613C4;
        Tue,  6 Apr 2021 12:36:21 +0000 (UTC)
Date:   Tue, 6 Apr 2021 08:36:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Add CODING_STYLE and CONTRIBUTE documents
Message-ID: <20210406083620.28b2d9dd@gandalf.local.home>
In-Reply-To: <326561d9-81de-76a9-1e0d-f98ad23024d5@gmail.com>
References: <20210405151959.1d6901b2@gandalf.local.home>
        <326561d9-81de-76a9-1e0d-f98ad23024d5@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 7 Apr 2021 06:28:35 +0530
sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> > +Finally, you can use the git "send-email" functionality:
> > +
> > +  git --send-email --from='<your-email> --to='linux-trace-devel@vger.kernel.org' HEAD~1..HEAD  
> I think, we should add a line about "checking the patch using the 
> checkpatch script, before sending the email", what you say?

I'll add that, although I will say to think of checkpatch as more of a
guide and not a requirement. I find there's a lot of checkpatch fixes
that cause the code to be less readable. But I agree that it is useful for
someone just entering the project.

> 
> Another suggestion is,
> 
> we should document about, how to apply the mailing list patches, which 
> are not yet mainlined. people can search in the internet, but different 
> forums will give different approaches.

And I can give different approaches ;-)  The approach I gave to you with
patchwork may not be the best either. If I do add something here, it will
to use a new tool called "b4".

For example, you can apply this patch with:

 $ b4 am 20210405151959.1d6901b2@gandalf.local.home

Where I used the Message-ID of my email. It also works with series.

Anyway, thanks for the input. This was the reason I included you on this
patch.

-- Steve
