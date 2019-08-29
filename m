Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8635CC3A59F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 16:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61C3C2189D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 16:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfH2QiQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 12:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbfH2QiP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 12:38:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B08206BB;
        Thu, 29 Aug 2019 16:38:14 +0000 (UTC)
Date:   Thu, 29 Aug 2019 12:38:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] trace-cmd: Move trace-cmd global variable
 "quiet" to libtracecmd
Message-ID: <20190829123813.1291e62f@gandalf.local.home>
In-Reply-To: <CAPpZLN7o8HOSg4=Xrx+zeUn9iyQa=wt2wn+0HzF9qsnEYMrXQQ@mail.gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
        <20190814084712.28188-5-tz.stoyanov@gmail.com>
        <20190828155946.6efd8cec@gandalf.local.home>
        <CAPpZLN7o8HOSg4=Xrx+zeUn9iyQa=wt2wn+0HzF9qsnEYMrXQQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Aug 2019 14:39:43 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Wed, Aug 28, 2019 at 10:59 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 14 Aug 2019 11:47:04 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > >  void tracecmd_set_quiet(int quiet);
> > >  int tracecmd_get_quiet(void);  
> >
> > I rather make this a parameter to the descriptor:
> >
> >         tracecmd_set_quiet(struct tracecmd_output *handle, bool quiet);
> >         tracecmd_get_quiet(struct tracecmd output *handle);
> >
> > As we may have multiple handles and perhaps we don't want all of them
> > quiet.
> >  
> It makes sense to have "quiet" per tracecmd_output handler, but when I
> started to modify the code,
> I noticed one flow where tracecmd_get_quiet() is used and there is no
> tracecmd_output handler available -
> in check_plugin(). We have either to drop the usage of
> tracecmd_get_quiet() in check_plugin(), or leave the scope of
> "quiet" to be for the whole library.

We can still have a global variable in trace-record.c called quiet. And
that gets set by the parameter:

	case OPT_quite:
	case 'q':
		quiet = 1;
		break;

[..]

	tracecmd_set_quiet(handle, quiet);

This is the proper way to handle it. The functions local to
trace-record.c, can just use its own quiet state variable, but when we
set quiet, we use the tracecmd_set_quiet() to notify the library that
it too should be quiet.

-- Steve

