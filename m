Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95640C74A2B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 16:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61C7120844
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 16:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfGJQbx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 12:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbfGJQbx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 12:31:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BC220844;
        Wed, 10 Jul 2019 16:31:51 +0000 (UTC)
Date:   Wed, 10 Jul 2019 12:31:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: kernel-shark: Avoid a duplicate error
 message from capture
Message-ID: <20190710123150.43b2719e@gandalf.local.home>
In-Reply-To: <CAE858AmPCXOTqx+80ukPMG3ovSTeoiMWSesMKR6iFVBQ+jkw_Q@mail.gmail.com>
References: <20190710153906.32048-1-y.karadz@gmail.com>
        <CAE858AmPCXOTqx+80ukPMG3ovSTeoiMWSesMKR6iFVBQ+jkw_Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Jul 2019 19:00:43 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On Wed, Jul 10, 2019, 18:39 Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> wrote:
> 
> > If the capture process finishes with an error the _captureError() slot
> > will print an error message. We do not need to print identical message
> > in _captureFinished().
> >
> > However, we have to keep in mind that the process that we started is
> > "pkexec" and the capture dialog is a child process of "pkexec". So if
> > the capture dialog failed to start or crashed the "pkexec" process
> > itself will have a normal exit, however its return value will be
> > different from 0 (it will just pass the return value of the capture
> > dialog executable). In this case _captureError() is not triggered,
> > but we still want to see an error message.
> >
> > Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> > ---
> >  kernel-shark/src/KsMainWindow.cpp | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel-shark/src/KsMainWindow.cpp
> > b/kernel-shark/src/KsMainWindow.cpp
> > index 29d44d9..c127ad1 100644
> > --- a/kernel-shark/src/KsMainWindow.cpp
> > +++ b/kernel-shark/src/KsMainWindow.cpp
> > @@ -1180,7 +1180,7 @@ void KsMainWindow::_captureFinished(int ret,
> > QProcess::ExitStatus st)
> >                 return;
> >         }
> >
> > -       if (ret != 0 || st != QProcess::NormalExit) {
> > +       if (ret != 0 || st == QProcess::NormalExit) {
> >
> 
> Ohh, I made stupid mistake in the rush. Must use AND instead of OR

Heh, want me to just make the fix, or can you send a v2?

-- Steve

> 
>                 QString message = "Capture process failed:<br>";
> >
> >                 message += capture->errorString();
> > --
> > 2.20.1
> >
> >

