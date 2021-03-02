Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D16C433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2187264FC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhCBX5a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835218AbhCBEuP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 23:50:15 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12745C06178B
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Mar 2021 20:49:35 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id e9so1095524pjs.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Mar 2021 20:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P86KPrj/4T2pUogxL3baD0l6NFUzQAx62jMqFUOjrLg=;
        b=cp0CSNMI7CYg7dsLeCZCXQ5XeXeP1P9bvb7eP3uTJqo32xdj2ZkFvJdSSNalBwC/v2
         GJQq/wRKIRpSiZsyvOWy1m14gfub35neJX+la6wMIFlnnDo+WiMH9eglslzfY8XCRtB9
         5FRTxTzknbmlCyO6JmwjLwWtxlV8gRx7LNtQZkif3EJAzB1TAjkm/9tqVAFekl5DA6ra
         6InhOOUaKsZ7rSe6UmchmpjKxgtifwv6YaLZwIOkPgPr+CNMyw9Syrq5lGVo9liLx+KD
         7WZzKEZXvxey6dUtGHaZepAM0sAsNYHY91lPsBdJ76pOaEuAzhGv6XJy42QlgPKALaXk
         XnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P86KPrj/4T2pUogxL3baD0l6NFUzQAx62jMqFUOjrLg=;
        b=llHse+nm9waXRPgrOWSz1YPUTYxhHhbDmSx+ky+0ScT92VdIBGaKivpAcIJ7O6CQTF
         9j10hrB2L9Jd1vrELzBp9lhwQ6F+mKwSaKO+fTPJlG+28KU09lDNeoWAl2Kg9QjsExft
         gPLtbmKaEH1WdkoIQbhrkhuvpAQil/BLUKkXop9RjRzFvxkynjR2xBvw8ABvll+Zr2pU
         5FJANxdlXVXUVoSBzIKNXukiVnI4vkCu5bO/lsSwxbZXd//+V2vfqtnu6Ws/WQGCbe/0
         J+TZgF1zv5a8rUCuRE0QcG4j0pAstxQvOMbUmNUGbIeOUAQZXLQni1q8iPF3Tkn/J3pJ
         FrAQ==
X-Gm-Message-State: AOAM532+sY18Wwh+g7vct6nUl7ERkQfieBFqW1BmZlgnNqrumEJ48OQ8
        RomOCDeQjqW90KEPk1keIgx3BynFQOWuNQ3UAfo1mk4qDfkfuQ==
X-Google-Smtp-Source: ABdhPJyMhWoI1TUq4J9En3aXJ9JoGtlG4MeOq7RMzdV03RrNPxkqjHDMKjVVa1NX2XvOW66cok+8GUt1HoeDQhgUTnY=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr2501194pjb.2.1614660574443;
 Mon, 01 Mar 2021 20:49:34 -0800 (PST)
MIME-Version: 1.0
References: <20210301143724.540985351@goodmis.org> <20210301143856.948525416@goodmis.org>
In-Reply-To: <20210301143856.948525416@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 2 Mar 2021 06:49:18 +0200
Message-ID: <CAPpZLN5fdY+rb6s=X6bNykiqrjuTprvZxay9iDSEQxJXHURh3A@mail.gmail.com>
Subject: Re: [PATCH 2/8] trace-cmd: Create API tracecmd_read_pre_headers()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Mon, Mar 1, 2021 at 4:38 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> The trace-cmd restore operation can create a partial header to read the
> trace event formats and kallsyms and other data into a stand alone header
> before it has access to the cpu data. Then it will also read this header to
> put together a broken trace, and it reads the header that does not have the
> cpu data attached to it.
>
> In order to handle this case, it needs a way to read the headers but stop
> short of reading the CPU information. That requires breaking up
> tracecmd_read_headers() with just stopping short of adding the cpu data.

While looking at these changes, I think it could be more flexible instead of
introducing a new API, to enhance the existing tracecmd_read_headers().
We can add an additional (optional) parameter to point out what headers
to be read, i.e. the desired new state of reading the file. Something like that:
   int tracecmd_read_headers(struct tracecmd_input *handle, int state);
It will read the file from its current file_state to the desired state.
The API could be called multiple times, to progress the reading of the
file, header by header if needed, or a bunch of headers.



>
> A new API is added called tracecmd_read_pre_headers() that does exactly that.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  .../include/private/trace-cmd-private.h       |  1 +
>  lib/trace-cmd/trace-input.c                   | 25 ++++++++++++++++---
>  tracecmd/trace-restore.c                      |  2 +-
>  3 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index fc968cc9efe1..c7ef3af7c8f7 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -153,6 +153,7 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
>  struct tracecmd_input *tracecmd_alloc(const char *file, int flags);
>  struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags);
>  void tracecmd_ref(struct tracecmd_input *handle);
> +int tracecmd_read_pre_headers(struct tracecmd_input *handle);
>  int tracecmd_read_headers(struct tracecmd_input *handle);
>  int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
>  int tracecmd_long_size(struct tracecmd_input *handle);
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 9ef7b9f16951..9e1a44540201 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -772,14 +772,17 @@ static int read_cpus(struct tracecmd_input *handle)
>  }
>
>  /**
> - * tracecmd_read_headers - read the header information from trace.dat
> + * tracecmd_read_pre_headers - read the header information from trace.dat
>   * @handle: input handle for the trace.dat file
>   *
>   * This reads the trace.dat file for various information. Like the
>   * format of the ring buffer, event formats, ftrace formats, kallsyms
> - * and printk.
> + * and printk, but stops before reading cpu and options.
> + *
> + * This is needed by the restore operation where the header does not
> + * have the CPU information yet.
>   */
> -int tracecmd_read_headers(struct tracecmd_input *handle)
> +int tracecmd_read_pre_headers(struct tracecmd_input *handle)
>  {
>         int ret;
>
> @@ -815,6 +818,22 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
>                 return -1;
>         handle->file_state = TRACECMD_FILE_CMD_LINES;
>
> +       return 0;
> +}
> +
> +/**
> + * tracecmd_read_headers - read the header information from trace.dat
> + * @handle: input handle for the trace.dat file
> + *
> + * This reads the trace.dat file for various information. Like the
> + * format of the ring buffer, event formats, ftrace formats, kallsyms
> + * and printk.
> + */
> +int tracecmd_read_headers(struct tracecmd_input *handle)
> +{
> +       if (tracecmd_read_pre_headers(handle))
> +               return -1;
> +
>         if (read_cpus(handle) < 0)
>                 return -1;
>         handle->file_state = TRACECMD_FILE_CPU_COUNT;
> diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
> index 13f803053582..bf6940991178 100644
> --- a/tracecmd/trace-restore.c
> +++ b/tracecmd/trace-restore.c
> @@ -122,7 +122,7 @@ void trace_restore (int argc, char **argv)
>                 if (!ihandle)
>                         die("error reading file %s", input);
>                 /* make sure headers are ok */
> -               if (tracecmd_read_headers(ihandle) < 0)
> +               if (tracecmd_read_pre_headers(ihandle) < 0)
>                         die("error reading file %s headers", input);
>
>                 handle = tracecmd_copy(ihandle, output);
> --
> 2.30.0
>
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
