Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28ED5C28D15
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D40E864F16
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhCCAEg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:04:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1574691AbhCBUA3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 15:00:29 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FE7A64F1B;
        Tue,  2 Mar 2021 19:59:48 +0000 (UTC)
Date:   Tue, 2 Mar 2021 14:59:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 6/8] trace-cmd output: Set file_state of output handle
 after copy of headers
Message-ID: <20210302145946.28bc3bdd@gandalf.local.home>
In-Reply-To: <CAPpZLN4vmvQ7dNSyt-0DWBVtdyEh_9+w9r6X-_XQmD-g3yb6QA@mail.gmail.com>
References: <20210301143724.540985351@goodmis.org>
        <20210301143857.541050724@goodmis.org>
        <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com>
        <20210302091949.263d02c8@gandalf.local.home>
        <CAPpZLN6v9swL2osRXG6nV_2J3zxvcSA1m9-LOA-30-pg3Z65Qw@mail.gmail.com>
        <20210302104835.0afea720@gandalf.local.home>
        <CAPpZLN4vmvQ7dNSyt-0DWBVtdyEh_9+w9r6X-_XQmD-g3yb6QA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2 Mar 2021 19:35:11 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Tue, Mar 2, 2021 at 5:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Tue, 2 Mar 2021 16:51:56 +0200
> > Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> >  
> > > >         handle->file_state = state;  
> > >
> > > The output handle should have the same state as the input handle,
> > > so we can just have:
> > >
> > >       handle->file_state = tracecmd_get_file_state(ihandle);
> > >
> > > There is exactly the same use case in tracecmd_get_output_handle_fd(),
> > > where the out handle is built on a partially written file.  
> >
> > The above is pretty much exactly what I did, but it eliminates error  
> 
> There is an error checking, if tracecmd_copy_headers() returns 0 then
> the ihandle state must be valid and we can use it safely.
> The tracecmd_get_file_state() could fail only in case of a NULL
> ihandle pointer.

Nevermind, I mistaken the "tracecmd_get_file_state()" as
"tracecmd_copy_headers()", I didn't notice that you introduced another API.

Sure something like this would work too.

-- Steve
