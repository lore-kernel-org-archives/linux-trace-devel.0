Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347B2C31E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 14:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B996207E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 14:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732633AbfFMO6z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 10:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732630AbfFMO4n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 10:56:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D34220B7C;
        Thu, 13 Jun 2019 14:56:42 +0000 (UTC)
Date:   Thu, 13 Jun 2019 10:56:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "slavomir.kaslev@gmail.com" <slavomir.kaslev@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH 0/3] trace-cmd: Fix some bugs that include issues with
 --max-graph-depth
Message-ID: <20190613105640.1f9b9d44@gandalf.local.home>
In-Reply-To: <CAE0o1NuCo-vhX9j6G_OnYi=UwMETv+eH=881z1oryzJ_6=JKuQ@mail.gmail.com>
References: <20190612181927.608151291@goodmis.org>
        <CAE0o1NuCo-vhX9j6G_OnYi=UwMETv+eH=881z1oryzJ_6=JKuQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 13 Jun 2019 14:51:48 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> On Wed, Jun 12, 2019 at 9:21 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >
> > Some last minute bugs that were found and fixed.
> >
> > Steven Rostedt (VMware) (3):
> >       trace-cmd: Fix typo in Makefile bidr to bdir
> >       trace-cmd: Have --max-graph-depth only be part of instance
> >       trace-cmd: Check the return of get_file_content() before calling add_reset_file()
> >
> > ----
> >  tracecmd/Makefile              |  2 +-
> >  tracecmd/include/trace-local.h |  2 ++
> >  tracecmd/trace-record.c        | 33 +++++++++++++++++++--------------
> >  3 files changed, 22 insertions(+), 15 deletions(-)  
> 
> Looks good to me.
> 
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
> 

Thanks Slavomir and Tzvetomir.

I'll add these patches now with both of your reviewed-bys.

-- Steve
