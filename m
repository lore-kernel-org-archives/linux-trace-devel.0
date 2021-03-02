Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C769C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5685964FC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhCCABV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:01:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1448442AbhCBOUb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 09:20:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E848264F12;
        Tue,  2 Mar 2021 14:19:50 +0000 (UTC)
Date:   Tue, 2 Mar 2021 09:19:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 6/8] trace-cmd output: Set file_state of output handle
 after copy of headers
Message-ID: <20210302091949.263d02c8@gandalf.local.home>
In-Reply-To: <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com>
References: <20210301143724.540985351@goodmis.org>
        <20210301143857.541050724@goodmis.org>
        <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2 Mar 2021 10:10:24 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Mon, Mar 1, 2021 at 4:38 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> >
> > Now that the input and output handles know the state they are at in reading
> > or writing, the tracecmd_copy() has to set the state of the output handle it
> > creates.
> >
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> >  lib/trace-cmd/trace-output.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> > index 6d504cbaf133..1156899a85d3 100644
> > --- a/lib/trace-cmd/trace-output.c
> > +++ b/lib/trace-cmd/trace-output.c
> > @@ -1656,6 +1656,8 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
> >         if (tracecmd_copy_headers(ihandle, handle->fd) < 0)
> >                 goto out_free;
> >
> > +       handle->file_state = TRACECMD_FILE_CMD_LINES;  
> 
> Why is the state overwritten here, isn't it more logical to be set in
> tracecmd_copy_headers(), by each function that copies a header to set

That's because the handle is not passed into tracecmd_copy_headers.

And because the handle is a struct tracecmd_output, the
tracecmd_copy_headers() which is in trace-input.c doesn't have access to
this structure, and I prefer to keep it that way.

That said, we could modify tracecmd_copy_header() to return the state that
it copied up to, or negative on error.

	state = tracecmd_copy_headers(ihandle, handle->fd);
	if (state < 0)
		goto out_free;

	handle->file_state = state;

That would be more robust!

-- Steve


> the relevant state. The last call in tracecmd_copy_headers()
> is copy_command_lines(), which should set state to
> TRACECMD_FILE_CMD_LINES in case of success.
> The state is already TRACECMD_FILE_CMD_LINES
> in tracecmd_copy_headers(), but right before its exit it
> is overwritten to the old file state. And here again it is
> overwritten back to TRACECMD_FILE_CMD_LINES.
> May be I miss something here, cannot understand the logic.
> 
> > +
> >         /* The file is all ready to have cpu data attached */
> >         return handle;
> >
> > --
> > 2.30.0
> >
> >  
> 
> 

