Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5708C28CC5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CDD064F3A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbhCCADD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384531AbhCBPFT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 10:05:19 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D248C0611BE
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Mar 2021 06:52:14 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o6so2152841pjf.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Mar 2021 06:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xups9Q8qqoUAEm9RaHZ+lfcpVAadEMjp8LLnLaee6ag=;
        b=SEh4ZH3XUMwAnLMCt1c66E3od/NLa5mK/OofZOUiH8MU+vA0sOjKYyFWUzjmoi6OMh
         HiOxTH0nxHid8JeUVIVD+7SQOEua8tdZV2FxH3P63GQhYGa/ySZFNIlaHIVi9rZ6Voe+
         m6lEBto+F+VRnN5TM9VOg4523STREjs0Kn4+RQcwxC82lKgeuyTP8g5QNA9dxLvxdS59
         HZmGyIp8QIVRUiWXigR5P12wf+AU25YGY869L2z3+DBkpcQHUUB4iaAPNJiMJIXvMdv2
         +D3v0OgSJnHAJw6AatODcUcWYPb1WxLZBX9rxVcruSJZyirTB2fKiSpaCm72IE0+w5Nq
         j5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xups9Q8qqoUAEm9RaHZ+lfcpVAadEMjp8LLnLaee6ag=;
        b=Y56GgrEJy4rs0ON5e47QRki2N7igXcyqrCmPoh9WoHnEJPqqHE7Tn0qpIzJE/WF4gu
         8gSBQTVu+vOHGcwCekDaZt8ahrLMNsQ6MPi+AarYHGa1Y2/S/k8tKMSN5kswB6tJtGMB
         KBEgx0KusKkMzuyjQTNoxPZLSFTh3QfpiWjhHeS1lqCeVy+8KSo1IIUZiLgN+0A+SWKz
         kTheuee5EAXmn6+le8X15zFx9MzQic6L42Ew00wqbBrEVk7Gk46882DcjxbIDGp5rrfs
         pjtfbUCKHCjSltkNUcqPZz+fSIYNsS3vpCITLMgMLoxbrrfR4i9w21411z+BU3oul0iz
         jC2A==
X-Gm-Message-State: AOAM531S6plt8G8qWh3Vxa458UMSlqgfOghE3y8BOHMVDKrdhL0y4v1+
        qzuwT0iFK4kl6zseS+QV2fTXX3IEvL4R9/WVJypzfzxzdnOX9A==
X-Google-Smtp-Source: ABdhPJyx9obJOxNqRg7LIMWXj+wCgT827KXKJkMinEnORJDg5wP/LKS67RnZKu/PjUn2GUIHweWmSM06N5LPyOhe7fM=
X-Received: by 2002:a17:902:70c5:b029:e4:4ce3:90f5 with SMTP id
 l5-20020a17090270c5b02900e44ce390f5mr3885748plt.58.1614696733609; Tue, 02 Mar
 2021 06:52:13 -0800 (PST)
MIME-Version: 1.0
References: <20210301143724.540985351@goodmis.org> <20210301143857.541050724@goodmis.org>
 <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com> <20210302091949.263d02c8@gandalf.local.home>
In-Reply-To: <20210302091949.263d02c8@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 2 Mar 2021 16:51:56 +0200
Message-ID: <CAPpZLN6v9swL2osRXG6nV_2J3zxvcSA1m9-LOA-30-pg3Z65Qw@mail.gmail.com>
Subject: Re: [PATCH 6/8] trace-cmd output: Set file_state of output handle
 after copy of headers
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 2, 2021 at 4:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 2 Mar 2021 10:10:24 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > On Mon, Mar 1, 2021 at 4:38 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > >
> > > Now that the input and output handles know the state they are at in reading
> > > or writing, the tracecmd_copy() has to set the state of the output handle it
> > > creates.
> > >
> > > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > ---
> > >  lib/trace-cmd/trace-output.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> > > index 6d504cbaf133..1156899a85d3 100644
> > > --- a/lib/trace-cmd/trace-output.c
> > > +++ b/lib/trace-cmd/trace-output.c
> > > @@ -1656,6 +1656,8 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
> > >         if (tracecmd_copy_headers(ihandle, handle->fd) < 0)
> > >                 goto out_free;
> > >
> > > +       handle->file_state = TRACECMD_FILE_CMD_LINES;
> >
> > Why is the state overwritten here, isn't it more logical to be set in
> > tracecmd_copy_headers(), by each function that copies a header to set
>
> That's because the handle is not passed into tracecmd_copy_headers.
>
> And because the handle is a struct tracecmd_output, the
> tracecmd_copy_headers() which is in trace-input.c doesn't have access to
> this structure, and I prefer to keep it that way.
>
> That said, we could modify tracecmd_copy_header() to return the state that
> it copied up to, or negative on error.
>
>         state = tracecmd_copy_headers(ihandle, handle->fd);
>         if (state < 0)
>                 goto out_free;
>
>         handle->file_state = state;

The output handle should have the same state as the input handle,
so we can just have:

      handle->file_state = tracecmd_get_file_state(ihandle);

There is exactly the same use case in tracecmd_get_output_handle_fd(),
where the out handle is built on a partially written file.

>
> That would be more robust!
>
> -- Steve
>
>
> > the relevant state. The last call in tracecmd_copy_headers()
> > is copy_command_lines(), which should set state to
> > TRACECMD_FILE_CMD_LINES in case of success.
> > The state is already TRACECMD_FILE_CMD_LINES
> > in tracecmd_copy_headers(), but right before its exit it
> > is overwritten to the old file state. And here again it is
> > overwritten back to TRACECMD_FILE_CMD_LINES.
> > May be I miss something here, cannot understand the logic.
> >
> > > +
> > >         /* The file is all ready to have cpu data attached */
> > >         return handle;
> > >
> > > --
> > > 2.30.0
> > >
> > >
> >
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
