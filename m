Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F37C282E2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40BDD20652
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfDSSYP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbfDSSYO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:24:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE11222E0;
        Fri, 19 Apr 2019 17:48:41 +0000 (UTC)
Date:   Fri, 19 Apr 2019 13:48:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH v2 3/8] kernel-shark: Add logic for the initial path of
 Open-File dialogs
Message-ID: <20190419134840.475fcbfe@gandalf.local.home>
In-Reply-To: <CAE0o1NvnsJp+hxm=vxtuBvDuNuUYUduGfoC7MkxdSqNjPf_1Pg@mail.gmail.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
        <20190418152146.27232-4-ykaradzhov@vmware.com>
        <CAE0o1NvnsJp+hxm=vxtuBvDuNuUYUduGfoC7MkxdSqNjPf_1Pg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Apr 2019 10:26:40 +0300
Slavomir Kaslev <slavomir.kaslev@gmail.com> wrote:

> On Thu, Apr 18, 2019 at 6:22 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> >
> > If the application has been started from the source code directory,
> > all OpenFile dialogs will start there. If the application has been
> > started from its installation location, all Open File dialogs will
> > start at ${HOME}.
> >
> > Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> > ---
> >  kernel-shark/src/KsCaptureDialog.cpp |  6 +++---
> >  kernel-shark/src/KsMainWindow.cpp    | 12 ++++++------
> >  kernel-shark/src/KsUtils.hpp         | 15 +++++++++++++++
> >  3 files changed, 24 insertions(+), 9 deletions(-)  
> 
> [...]
> 
> > diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
> > index c8b5e88..877c62a 100644
> > --- a/kernel-shark/src/KsUtils.hpp
> > +++ b/kernel-shark/src/KsUtils.hpp
> > @@ -111,6 +111,21 @@ inline QString Ts2String(int64_t ts, int prec)
> >
> >  bool matchCPUVisible(struct kshark_context *kshark_ctx,
> >                               struct kshark_entry *e, int cpu);
> > +
> > +/**
> > + * @brief Get the directory to be used when opening QFileDialog. If the
> > + *       application has been started from the source code directory, all
> > + *       Open File dialogs will start there. If the application has been
> > + *       started from its installation location, all Open File dialogs will
> > + *       start at ${HOME}.
> > + */
> > +inline QString dialogDir()
> > +{
> > +       QString path = QCoreApplication::applicationFilePath();
> > +
> > +       return (path.contains(KS_DIR)) ? KS_DIR : QDir::homePath();  
> 
> Nit: no need for the parenthesis around `path.contains(KS_DIR)`
> 
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
> 
> As a user of KernelShark who keeps his traces in ~/tmp, I still think
> that opening the last directory used and saving it between KernelShark
> invocations would be a great feature. But I don't think there's any
> KernelShark global config being saved atm so having this as a follow
> up in the future is fine.
> 

Perhaps not save it between bringing up kernelshark, but at least to
remember it during the execution time.

Also, I think having the cwd be the default location would be a good
idea, then you could just run kernelshark from /tmp and it will be the
location you see.

-- Steve
