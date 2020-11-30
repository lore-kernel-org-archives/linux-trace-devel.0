Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C85C63777
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Nov 2020 16:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0055B2076E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Nov 2020 16:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b65XhGPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgK3QZC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 11:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgK3QZC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 11:25:02 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12938C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Nov 2020 08:24:22 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so10367158pga.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Nov 2020 08:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VkfQabC0+hrvRspxnIi1G8CDWr6jmEMEvG6Y49YLnsg=;
        b=b65XhGPYURaieEBY1GAmSy5SfM5abYDtibB4zAYXvUqgAPFFd7TGxgl0CEXn0A5ERZ
         KRJh8pPjLRfQatyiDC1UeGE9tFGng5ukrKkbN9az3WvWJ1AYFEVXzMpqWxfS0x3GjrZ/
         KQbToHvqTYPRmmQXvR9Dy3LfhfxnN0l5pW8LJ9XQyte7TqwwNGgFSVmT7ToU5Vt6sTeN
         sFKXi7ZsykWUtRjEJCUN9nhgPlBQ9P4BsVeqzoAjV5mXizvDUkiubcAv1lSL5AEQTlDb
         66vwQRLEzoop5YQgYt8JCjLCvKNOC6445UkGQEhjuTL8c/2R78Vs089/ePCYPaA8i1Y9
         kpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VkfQabC0+hrvRspxnIi1G8CDWr6jmEMEvG6Y49YLnsg=;
        b=lRvT/2wiCKNV6bctjvBzRr4kgwDM/YHvRafMFNEuUwp4Ltm2n0MoAMucg+2aad3Ar1
         8A479syR3g6M9CGXPs82/PCnsoO4RYKQ8TVSVT+UL/K7ek6Im+ePgGqC2K+4OlN0BMdS
         5etlYlXwYY6ld2c/IFfiULcIUpFprfRRMKzEGW6mpg9OgWC8Zv77s2XQTbJFxWjO9BG6
         8v7nM/fFvREy1i6vRI/4n/j2SJ8cr9vcbHOcrRQgGAjaYnjw9/fjwc5PZvnEpbrPztIx
         axatgcxObD+0AJ0yct7P4UeuESE/gzYGcor7RHiGwXckmClu5T92IEO2yT97GAQZ+p+P
         aXJw==
X-Gm-Message-State: AOAM533c8rYU6D/dMbrbYO2EYEsm2l7XIfObAo/dWz2cWYdCM4Ci/gnE
        ytHIhxoeITZ26Ahhl9DiR52Nwc9XYGkdQFz+ufY=
X-Google-Smtp-Source: ABdhPJzLQQP1bJi/QUCnjempblGe63EuHy5ARE2jR2Sipg7k/+f4XSHEWuXPjkfeWkQm2cEOhGyfhIRJYBWlBZkdw5E=
X-Received: by 2002:a62:1555:0:b029:19a:98af:f44d with SMTP id
 82-20020a6215550000b029019a98aff44dmr18219858pfv.50.1606753461579; Mon, 30
 Nov 2020 08:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20201130122755.31000-1-beniaminsandu@gmail.com>
In-Reply-To: <20201130122755.31000-1-beniaminsandu@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 30 Nov 2020 18:24:05 +0200
Message-ID: <CAPpZLN50X6=8nz3U2M6mk+KqDfxcwdr86d-6bHuV_rkphc1Xhw@mail.gmail.com>
Subject: Re: [PATCH v2] trace-cmd: make it build against musl C library
To:     Beniamin Sandu <beniaminsandu@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 30, 2020 at 2:31 PM Beniamin Sandu <beniaminsandu@gmail.com> wrote:
>
> * add some missing headers and macros
> * set pthread affinity using pthread_setaffinity_np after creating the thread
> instead of pthread_attr_setaffinity_np (which seems to not be implemented
> in musl)
>
> Tested using https://musl.cc/x86_64-linux-musl-native.tgz
>
> Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>

Thanks Beniamin!
There is one minor coding style error, as we are using the kernel's
coding style.
No need to send another version, we will fix it when pulling the patch.
Also, note that we are moving the libtracefs in its own repo:
  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
I'm going to port the libtracefs part of your patch to that repo too.

Reviewed-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

> ---
>  .../include/private/trace-cmd-private.h          |  1 +
>  lib/trace-cmd/include/trace-cmd-local.h          |  1 +
>  lib/tracefs/include/tracefs-local.h              | 12 ++++++++++++
>  lib/tracefs/tracefs-events.c                     |  1 +
>  tracecmd/include/trace-local.h                   |  1 +
>  tracecmd/trace-tsync.c                           | 16 +++++++++++-----
>  6 files changed, 27 insertions(+), 5 deletions(-)
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
> index e639788..1fce6d0 100644
> --- a/tracecmd/trace-tsync.c
> +++ b/tracecmd/trace-tsync.c
> @@ -104,13 +104,16 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
>
>         pthread_attr_init(&attrib);
>         pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> -       if (!get_first_cpu(&pin_mask, &mask_size))
> -               pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
>
>         ret = pthread_create(&instance->tsync_thread, &attrib,
>                              tsync_host_thread, &instance->tsync);
> -       if (!ret)
> +
> +       if (!ret) {
> +               if (!get_first_cpu(&pin_mask, &mask_size))
> +                       pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
>                 instance->tsync_thread_running = true;
> +       }
> +
>         if (pin_mask)
>                 CPU_FREE(pin_mask);
>         pthread_attr_destroy(&attrib);
> @@ -243,11 +246,14 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
>         pthread_attr_init(&attrib);
>         tsync->sync_proto = proto;
>         pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> -       if (!get_first_cpu(&pin_mask, &mask_size))
> -               pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
>
>         ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
>
> +       if(!ret) {

There should be a space before the open parenthesis here.

> +               if (!get_first_cpu(&pin_mask, &mask_size))
> +                       pthread_setaffinity_np(*thr_id, mask_size, pin_mask);
> +       }
> +
>         if (pin_mask)
>                 CPU_FREE(pin_mask);
>         pthread_attr_destroy(&attrib);
> --
> 2.25.1
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
