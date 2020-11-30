Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC4AC5519F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Nov 2020 08:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C35C20731
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Nov 2020 08:14:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdiHJg4q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgK3IOB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 03:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgK3IOB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 03:14:01 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8943AC0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Nov 2020 00:13:21 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id q3so1890645pgr.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Nov 2020 00:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v9M+apUWN7u4t1w9cSEywskfyQ6/QN17NpL/2jXRsiw=;
        b=WdiHJg4q2/Of72FLozF84wvLhMPPaR48UUkbh+ZuS2eLELHxECJRUKAv61R53OUrUo
         VxhiL/slu74JfPboKqLxICt+V72Q4dis+QXUIzr8TkmXXubUt2x0lvrmERqYn7STh4AH
         8JIGDMGFckcY4Kji667FmD4Dph/Y0jtOa7pQguznVbGp8Ea3QzhTbWkMLRDdWAFEIbMx
         An71up667VnmGAXagcqgWtghv/ZtUTsdd33Tx+hCo7w9wvXpUC/oWr7sFfCxihClAspo
         CKi8m1bIiER8cS27qJLKI1HUJ/FrFg5qEp9od4Tj7PGbYeNi/N1SoKjdvXvCA/Oj/qRn
         WqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v9M+apUWN7u4t1w9cSEywskfyQ6/QN17NpL/2jXRsiw=;
        b=HY/bx0Dt2FmEIPATRyM61o/y4MbWvdq+wfimFSG7PWCGV1gKcbkmMwtvRHkFbwrruj
         p25nhTL2VZjWiOduX3AJJSoseriS9MHz9CBYvfo2d3J5tWZKGnxcXaMj6lvdZsgVg73P
         vupuaOaTEqHmt5Qm0WC5MNMLpQlyQ/KfbtEarDOOH9FXnIoobPQG2EhG1Ny+ZD5UrmHn
         nqXQ46bAjiSiiLyH3OXT+g11jHwaO+E4E3nntZO/OKhtp0rFfXxAdfqTKpUn5IrBFcZU
         EHjNLlns4XD+qBLZI7NstSz0Y5YsYolgoJHGsV3wLg3O3HIA668wi/qkWpk4pVt7tqGM
         Zh6Q==
X-Gm-Message-State: AOAM533BdkcLhJEIcqCz1DXGr+jPJzAuSaNP9m5NB+T/z4ZFtS6VGfZu
        pWAkMi3mbm1VsP+jYZXyPOS9VdGdDjpEw2uoGxdLhJr4Z/p8g7N9
X-Google-Smtp-Source: ABdhPJyk7nyyx7NZKJiA+3c2ucrgBq+57pG9BKxz+3seuLIagSFuDR5+kPZPOvC0Hkoe5VoMTJKDKv+oW3ZT8OpSelk=
X-Received: by 2002:a63:b1c:: with SMTP id 28mr17018971pgl.206.1606724001106;
 Mon, 30 Nov 2020 00:13:21 -0800 (PST)
MIME-Version: 1.0
References: <20201128192221.1165671-1-beniaminsandu@gmail.com>
In-Reply-To: <20201128192221.1165671-1-beniaminsandu@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 30 Nov 2020 10:13:04 +0200
Message-ID: <CAPpZLN6wGrXs7Go1dHQFegqt7n6ZMwEamrvF0SEuL25nR-y5Ww@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: make it build against musl C library
To:     Beniamin Sandu <beniaminsandu@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Nov 29, 2020 at 12:04 AM Beniamin Sandu <beniaminsandu@gmail.com> wrote:
>
> * add some missing headers and macros
> * set pthread affinity using pthread_setaffinity_np after creating the thread
> instead of pthread_attr_setaffinity_np (which seems to not be implemented
> in musl)
>
> Tested using https://musl.cc/x86_64-linux-musl-native.tgz
>
> Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>

Hi Beniamin,
Thanks for testing trace-cmd with different build environments and
sending this patch.
I looked at the changes, they look good to me in general. I have two
small comments.

> ---
>  lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
>  lib/trace-cmd/include/trace-cmd-local.h           |  1 +
>  lib/tracefs/include/tracefs-local.h               | 12 ++++++++++++
>  lib/tracefs/tracefs-events.c                      |  1 +
>  tracecmd/include/trace-local.h                    |  1 +
>  tracecmd/trace-tsync.c                            | 11 +++++++----
>  6 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index 458760e..a0dac5d 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -6,6 +6,7 @@
>  #ifndef _TRACE_CMD_PRIVATE_H
>  #define _TRACE_CMD_PRIVATE_H
>
> +#include <sys/types.h>
>  #include "traceevent/event-parse.h"
>  #include "trace-cmd/trace-cmd.h"
>
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index d0a7365..0cd2744 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -6,6 +6,7 @@
>  #ifndef _TRACE_CMD_LOCAL_H
>  #define _TRACE_CMD_LOCAL_H
>
> +#include <byteswap.h>
>  #include "trace-cmd-private.h"
>
>  /* Can be overridden */
> diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
> index 9cc371b..bdbf89e 100644
> --- a/lib/tracefs/include/tracefs-local.h
> +++ b/lib/tracefs/include/tracefs-local.h
> @@ -13,4 +13,16 @@ void warning(const char *fmt, ...);
>  int str_read_file(const char *file, char **buffer);
>  char *trace_append_file(const char *dir, const char *name);
>
> +#ifndef ACCESSPERMS
> +#define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
> +#endif
> +
> +#ifndef ALLPERMS
> +#define ALLPERMS (S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO) /* 07777 */
> +#endif
> +
> +#ifndef DEFFILEMODE
> +#define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) /* 0666*/
> +#endif
> +
>  #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
> index 80a25ee..a4e5215 100644
> --- a/lib/tracefs/tracefs-events.c
> +++ b/lib/tracefs/tracefs-events.c
> @@ -13,6 +13,7 @@
>  #include <errno.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> +#include <limits.h>
>
>  #include "kbuffer.h"
>  #include "tracefs.h"
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 28d1b4e..85c7e03 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -8,6 +8,7 @@
>
>  #include <sys/types.h>
>  #include <dirent.h>    /* for DIR */
> +#include <limits.h>
>
>  #include "trace-cmd-private.h"
>  #include "event-utils.h"
> diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
> index e639788..2cbe7f2 100644
> --- a/tracecmd/trace-tsync.c
> +++ b/tracecmd/trace-tsync.c
> @@ -104,11 +104,13 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
>
>         pthread_attr_init(&attrib);
>         pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> -       if (!get_first_cpu(&pin_mask, &mask_size))
> -               pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
>
>         ret = pthread_create(&instance->tsync_thread, &attrib,
>                              tsync_host_thread, &instance->tsync);
> +
> +       if (!get_first_cpu(&pin_mask, &mask_size))
> +               pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
> +
The new affinity should be set only in case pthread_create() does not
return any error.
This new logic could be moved where the ret is checked for error.

>         if (!ret)
>                 instance->tsync_thread_running = true;
>         if (pin_mask)
> @@ -243,11 +245,12 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
>         pthread_attr_init(&attrib);
>         tsync->sync_proto = proto;
>         pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> -       if (!get_first_cpu(&pin_mask, &mask_size))
> -               pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
>
>         ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
>
> +       if (!get_first_cpu(&pin_mask, &mask_size))
> +               pthread_setaffinity_np(*thr_id, mask_size, pin_mask);
> +
The same here, the new affinity should not be set in case of
pthread_create() failure.

>         if (pin_mask)
>                 CPU_FREE(pin_mask);
>         pthread_attr_destroy(&attrib);
> --
> 2.25.1
>

--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
