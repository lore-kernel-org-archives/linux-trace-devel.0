Return-Path: <SRS0=jdea=3M=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A23FC2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 21:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC4F621D7D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 21:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAWVI1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 16:08:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgAWVI1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 16:08:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93CB121835;
        Thu, 23 Jan 2020 21:08:26 +0000 (UTC)
Date:   Thu, 23 Jan 2020 16:08:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: generate cscope.files when building cscope
 index
Message-ID: <20200123160825.256d5be4@gandalf.local.home>
In-Reply-To: <CAKvFj6odA2Ac2NvQ5zzc3=4wG18uXc-ECEQDWr+wjpS8G1TGiA@mail.gmail.com>
References: <20200112190537.170197-1-marcgonzalez@google.com>
        <20200120173335.7ec9609f@rorschach.local.home>
        <CAKvFj6o5gTRHFwjFdQJh4K-t-tdGdag6NHCjXYpW=29-yqHWww@mail.gmail.com>
        <20200122122805.0ecfdb1f@gandalf.local.home>
        <CAKvFj6qxHBHk3G61qqo8vMeu9JFQ_3VuiwJZs4X8EBfYX00sag@mail.gmail.com>
        <20200122140830.2111942e@gandalf.local.home>
        <CAKvFj6odA2Ac2NvQ5zzc3=4wG18uXc-ECEQDWr+wjpS8G1TGiA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 23 Jan 2020 14:51:53 -0500
Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:

> On Wed, Jan 22, 2020 at 2:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 22 Jan 2020 13:49:40 -0500
> > Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:  
> > >  
> > > > then I'm OK with your approach, but we need to make sure we update
> > > > the .gitignore and clean make target to remove it.  
> > >
> > > Ah good point! I'll send out another version if this way's the way to go.  
> >
> > Yes, please do. Thanks!  
> 
> Ah actually, should these be covered by the 'cscope* ' lines in
> .gitignore and the clean make target?
>

Ah, I guess they are ;-)

OK, I'll take your original patch. Thanks!

-- Steve
