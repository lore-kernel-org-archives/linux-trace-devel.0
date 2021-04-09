Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50681C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2657E61165
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhDIN7y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDIN7x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 09:59:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9682661108;
        Fri,  9 Apr 2021 13:59:40 +0000 (UTC)
Date:   Fri, 9 Apr 2021 09:59:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] libtracefs: Add new API for open trace marker file
Message-ID: <20210409095939.0868c651@gandalf.local.home>
In-Reply-To: <CAPpZLN6s1_XHYbBUmDwSeCEAk_M-ec2FXnf-F1kH3q6mOaWzGA@mail.gmail.com>
References: <20210409042739.3179257-1-tz.stoyanov@gmail.com>
        <20210409091215.03ceca3d@gandalf.local.home>
        <CAPpZLN6s1_XHYbBUmDwSeCEAk_M-ec2FXnf-F1kH3q6mOaWzGA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 9 Apr 2021 16:47:25 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Fri, Apr 9, 2021 at 4:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri,  9 Apr 2021 07:27:39 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > Added new APIs for working with trace marker files of given instance.
> > > Write strings in the trace_marker file:
> > >  tracefs_print_init();
> > >  tracefs_printf();
> > >  tracefs_vprintf();
> > >  tracefs_print_close();
> > > Write binary data in trace_marker_raw file:
> > >  tracefs_binary_init();
> > >  tracefs_binary_write();
> > >  tracefs_binary_close();  
> >
> > Thanks Tzvetomir, this looks exactly like what I wanted.
> >
> > A few nits with the code, but I may take this series as is and then add
> > these changes on top, since I want to get this library done this week. Let
> > me know if you have any issues with what I plan on changing, or just let me
> > know if you are OK with it.  
> 
> I'm OK with these changes. I was wondering about using a mutex to
> protect the open, close and write, but decided to wait for your
> changes that introduce the mutex and then to reuse it.

Right. But as I stated, we don't want to protect the write itself, because
we need to keep that as low overhead as possible, and just document that
there's no protection with writing and the close. But multiple writes will
work against opening and that's all that is needed.

-- Steve

