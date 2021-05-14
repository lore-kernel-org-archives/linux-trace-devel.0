Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C62C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 03:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEB626143F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 03:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhENDUN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 23:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhENDUN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 23:20:13 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59BA961283;
        Fri, 14 May 2021 03:19:02 +0000 (UTC)
Date:   Thu, 13 May 2021 23:19:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] trace-cmd library: Add log levels
Message-ID: <20210513231900.4a7cfea2@oasis.local.home>
In-Reply-To: <CAPpZLN6+Tvdef-c6qgeg-f8RTpmAhxi5yy1am5FykyFVU4zTcA@mail.gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
        <20210507095333.1080910-4-tz.stoyanov@gmail.com>
        <20210513172338.79ee4d2f@gandalf.local.home>
        <CAPpZLN6+Tvdef-c6qgeg-f8RTpmAhxi5yy1am5FykyFVU4zTcA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 05:51:24 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Fri, May 14, 2021 at 12:23 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri,  7 May 2021 12:53:28 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > Removed the "weak" definition of the library log functions. Setting
> > > the desired log level can be used to silence the library logs, instead
> > > of overwriting the log functions.  
> >
> > That's not the purpose of the weak definition. It is so that a GUI (like
> > kernelshark) can turn it into a pop up if need be or show in a status
> > window. It was not for quieting the function.  
> 
> The description is not correct. All these log functions use
> tep_vprint(), which is implemented as weak. This function has
> information for the library and log severity and should be used by
> kernelshark for that purpose. That's why I removed weak library
> specific functions.

Yes, tep_vprintk() could offer this as well, but there's still no
reason to not keep them as weak. Adding log levels is still unrelated
to removing the weak attribute.

I still do not see the rationale for removing the weak attribute of
these functions. It gives more flexibility for the users, without any
downsides.

Or is there a downside that you see for keeping them weak?

-- Steve
