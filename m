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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8A2C43331
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E97664F2B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhCBX6a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376826AbhCBINY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 03:13:24 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43071C061793
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Mar 2021 00:10:41 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b15so1415261pjb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Mar 2021 00:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LYsutr4XJA0p+FLpXe8laItuT8k2DnvURC9XURprY/g=;
        b=KK/8aJ/v3ez1RTBeoykk7Ga0DVJiXP4S6AmDQxcMTxihUObVlZA3nnX0YKNxICe5UA
         5AVRwO6gqV1EN+4Pk2GBAu6gM+Zhj8cj2XnOh//4M1ISl205olCxMj4rwNTXU368V858
         dDwWfnKhGNUjRtXV/4dWqzUY+YJZNDuVhSOW3VKGzhGC9rDOq7ufSHMcsHva0h0EjeI8
         1kS7jHeuanr4SiL2+g/dqgJWZp9LyoNCkWKF0C4XgJu/AyWHekv9HWxM2Tg+4gHhNUWh
         DfHFsEJqAeqnmXfJ2DtoCdWJQgarLtPdR6Ng51K0EbEJ7bbiWO4XZiHhmSM7PuJ40cdt
         kmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LYsutr4XJA0p+FLpXe8laItuT8k2DnvURC9XURprY/g=;
        b=mb1QqkkkciXEZf27ejx+Vucen+2i2wMmjL3phN9y3f3vzxc7MOngQAqjE/EhGOh5bX
         nfecloaMVcq97CLYRu6MTF1DLz43yJeYf9Uss3Ulo1NMzMsrs7VRMpNP3JWoRVmwlylj
         ZV25NgdTZmTu92dIbD0k9PK4JA5K2UkN2HQf+nx3pk98UMQVfKLBl5Qgvv0sSQ/Hert7
         T6Y2tvrnOBlOtq8dEmXQoJRoQ3GTXZiVYJVeLIo8chwKjgOEoBCDhPW1w7XFLVOU7QvP
         GGSGOPeay0sQmEn15qUzzmjpZkunpyd2mmCIawbSvkJIQzZvJzlIUnjcXLemU8vLteeP
         1KVA==
X-Gm-Message-State: AOAM533+F06tu6QiB7I0OMy//hNOwCG4TbxPRKZ11YfwumxQ7LVNZX+V
        SAH/dv6tI1mfdKo/VQrZ6LUIrvGue+h3at+gqdVNdGrJogI2wQ==
X-Google-Smtp-Source: ABdhPJyXsflzx9vCvlFKyYxxn+d8sfI7fBH1BGJQt7kXEjK4+GVDGmE4VjsVNoywhl/aNXX1uTaMoFKPDPEMJaIFilY=
X-Received: by 2002:a17:902:70c5:b029:e4:4ce3:90f5 with SMTP id
 l5-20020a17090270c5b02900e44ce390f5mr2561963plt.58.1614672640825; Tue, 02 Mar
 2021 00:10:40 -0800 (PST)
MIME-Version: 1.0
References: <20210301143724.540985351@goodmis.org> <20210301143857.541050724@goodmis.org>
In-Reply-To: <20210301143857.541050724@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 2 Mar 2021 10:10:24 +0200
Message-ID: <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com>
Subject: Re: [PATCH 6/8] trace-cmd output: Set file_state of output handle
 after copy of headers
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 1, 2021 at 4:38 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> Now that the input and output handles know the state they are at in reading
> or writing, the tracecmd_copy() has to set the state of the output handle it
> creates.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  lib/trace-cmd/trace-output.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 6d504cbaf133..1156899a85d3 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -1656,6 +1656,8 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
>         if (tracecmd_copy_headers(ihandle, handle->fd) < 0)
>                 goto out_free;
>
> +       handle->file_state = TRACECMD_FILE_CMD_LINES;

Why is the state overwritten here, isn't it more logical to be set in
tracecmd_copy_headers(), by each function that copies a header to set
the relevant state. The last call in tracecmd_copy_headers()
is copy_command_lines(), which should set state to
TRACECMD_FILE_CMD_LINES in case of success.
The state is already TRACECMD_FILE_CMD_LINES
in tracecmd_copy_headers(), but right before its exit it
is overwritten to the old file state. And here again it is
overwritten back to TRACECMD_FILE_CMD_LINES.
May be I miss something here, cannot understand the logic.

> +
>         /* The file is all ready to have cpu data attached */
>         return handle;
>
> --
> 2.30.0
>
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
