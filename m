Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24DDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 06:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiBUGJb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 01:09:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiBUGJb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 01:09:31 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE27B42
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 22:09:08 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id l8so12049667pls.7
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Feb 2022 22:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhM3u7Di+kOPAiiCmKJB/C7ngvXOqNE9KS961mNJq1s=;
        b=mFETxH1LQhVlVn6B5vSRJslE0RQhbgMZVkZpFB9WQmmYnwFKc47OBx6ELocpU+GcIR
         egXZm6DOfYf7Nn8Ggla/xJxIc1ticiZFlAhH0YAN5dOPYC6pje9may4eGg2PdMPrpl68
         HhnlP4na2OJ41mnLbjx3+gI+MrvCo8JWm9nuzOtA3XTlFfOYTqmroU5P7KmdUgZkcK/M
         al+Hw01UsGomi1R2LUgUjM/bvHP/D60efTjJEXhpaez2cGDJ+JsorRcY0kSuopVrmxHd
         UkDp6LFfKTLHuc7J3wf0rngYxbf6sh9k55xk6GQz33ijK7Ue5L87ANCTxXaABiteYfgq
         UtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhM3u7Di+kOPAiiCmKJB/C7ngvXOqNE9KS961mNJq1s=;
        b=lO1vmNogHALSba/Gzc6fZTnIkg6VmmjyXAx9cMvL18VRrVzhB7WsnW7e81YoH2veV3
         +DqpY3bRHB6kCTSyvDY33d89SRegsmyu41GTKmiA4310zZFVfb0hFW5gHSvskFX71PZT
         TnPeIZhRJ7S9YnhyUfQekz5m+j7Q6IPKUweiReQFTM2A4pVxH874iQgQkETCjixTNHu0
         atCEUWFRK3TKLlGd+n2Ax1ybqZ3HtO/bm5O4vbEe3NjXE2eX5Cx2Gdrf3ij5vFPMUp3w
         XLg+7vRNYxWL2EBoCAgNq+RxEBsm6DPflza2l+E9G9ATwszmq1ZiFzSJFvgrJYWe0Jmn
         hRdw==
X-Gm-Message-State: AOAM531UBbfwqkuLtDwsuleVG4yEAzLG/F5vdnAy55z9kk5ANCWw7PJA
        fdGDdJzgPrTMD1r4iu4SamOZeSNNPCkRKi51Rv8=
X-Google-Smtp-Source: ABdhPJzbEwwwroBTHqEfZaDV/VYt7eKPHCbgdJe17AuOx3IzY3aOkUvdcGL979DLUhiGQ9mXth4p0SWKkVuUrGWHPyA=
X-Received: by 2002:a17:90b:789:b0:1bc:293c:1445 with SMTP id
 l9-20020a17090b078900b001bc293c1445mr5541852pjz.111.1645423747502; Sun, 20
 Feb 2022 22:09:07 -0800 (PST)
MIME-Version: 1.0
References: <20220219230151.56282-1-sebastian@breakpoint.cc> <20220219230151.56282-2-sebastian@breakpoint.cc>
In-Reply-To: <20220219230151.56282-2-sebastian@breakpoint.cc>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 21 Feb 2022 08:08:51 +0200
Message-ID: <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd library: Add ZSTD support.
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Feb 20, 2022 at 1:02 AM Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
>

Hi Sebastian,
Thank you for contributing zstd support for trace-cmd! The zlib was
chosen for the PoC implementation of the trace file compression
support, as it is one of the widely available compression libraries.
But as you have already seen, the design allows easily adding multiple
compression algorithms. Support for a new compression library is less
than 100 lines of code, that's why I suggest to keep the zlib support
- even though the default will be zstd.

> The zstd support is using the context aware function so there is no need
> to for the library to allocate one (including the memory) for every
> invocation. This requires to be used in a single threaded environment or
> the API needs to be extended to pass the context parameter.

Good point, the current design is according to zlib - that's why there
is no context. But I like the idea to have a library specific context
and this should be added now, before the first release.

>
> In most cases the input buffer was 40KiB so it does not make sense to
> use higher compression levels. Higher compression levels won't
> significantly improve the compression ration given that the every 40KiB
> block is independent. However higher compression levels will slow down
> the compression process.
>

By default, the buffer is 10 system pages - so it could be larger on
some systems.

> The upper level stores 4 bytes compressed and decompressed size. In
> order to not save the decompressed size twice, the library won't store
> the store in each compressed block. This shrinks the frame header a
> little. In theory the ZSTD-magic (4 bytes) could be stripped away but
> that is little complicated and the 4 bytes shouldn't hurt. We could even
> enable check summing to be sure that the compressed block wasn't
> accidentally tampered.
>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  Makefile                                | 12 ++++
>  lib/trace-cmd/Makefile                  |  5 +-
>  lib/trace-cmd/include/trace-cmd-local.h |  4 ++
>  lib/trace-cmd/trace-compress-zstd.c     | 91 +++++++++++++++++++++++++
>  lib/trace-cmd/trace-compress.c          |  3 +
>  tracecmd/Makefile                       |  2 +-
>  6 files changed, 115 insertions(+), 2 deletions(-)
>  create mode 100644 lib/trace-cmd/trace-compress-zstd.c
>
> diff --git a/Makefile b/Makefile
> index f5c2cdb894f9a..109cbeb29002a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -307,6 +307,18 @@ CFLAGS += -DHAVE_ZLIB
>  $(info    Have zlib compression support)
>  endif
>
> +TEST_LIBZSTD = $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libzstd > /dev/null 2>&1 && echo y")
> +
> +ifeq ("$(TEST_LIBZSTD)", "y")
> +LIBZSTD_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
> +LIBZSTD_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
> +CFLAGS += -DHAVE_ZSTD
> +ZSTD_INSTALLED=1
> +$(info    Have ZSTD compression support)
> +endif
> +
> +export LIBZSTD_CFLAGS LIBZSTD_LDLAGS ZSTD_INSTALLED
> +
>  CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -o /dev/null -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
>  export CUNIT_INSTALLED
>
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index 1820c67b48474..da0ad4deeb4f0 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -29,6 +29,9 @@ OBJS += trace-compress.o
>  ifeq ($(ZLIB_INSTALLED), 1)
>  OBJS += trace-compress-zlib.o
>  endif
> +ifeq ($(ZSTD_INSTALLED), 1)
> +OBJS += trace-compress-zstd.o
> +endif
>
>  # Additional util objects
>  OBJS += trace-blk-hack.o
> @@ -48,7 +51,7 @@ $(DEPS): | $(bdir)
>  $(LIBTRACECMD_STATIC): $(OBJS)
>         $(Q)$(call do_build_static_lib)
>
> -LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) -lpthread
> +LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(LIBZSTD_LDLAGS) -lpthread
>
>  ifeq ($(ZLIB_INSTALLED), 1)
>  LIBS += -lz
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index 48f179d6f524a..8601a15f86f22 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -30,6 +30,10 @@ void tracecmd_info(const char *fmt, ...);
>  int tracecmd_zlib_init(void);
>  #endif
>
> +#ifdef HAVE_ZLIB

I think you mean HAVE_ZSTD here.

> +int tracecmd_zstd_init(void);
> +#endif
> +
>  struct data_file_write {
>         unsigned long long      file_size;
>         unsigned long long      write_size;
> diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
> new file mode 100644
> index 0000000000000..fc5e350f32509
> --- /dev/null
> +++ b/lib/trace-cmd/trace-compress-zstd.c
> @@ -0,0 +1,91 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2022, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> + *
> + */
> +#include <stdlib.h>
> +#include <zstd.h>
> +#include <errno.h>
> +
> +#include "trace-cmd-private.h"
> +
> +#define __ZSTD_NAME            "zstd"
> +#define __ZSTD_WEIGTH          5
> +
> +static ZSTD_CCtx *ctx_c;
> +static ZSTD_DCtx *ctx_d;
> +
> +static int zstd_compress(const char *in, unsigned int in_bytes,
> +                        char *out, unsigned int *out_bytes)
> +{
> +       size_t ret;
> +
> +       ret = ZSTD_compress2(ctx_c, out, *out_bytes, in, in_bytes);
> +       if (ZSTD_isError(ret))
> +               return -1;
> +       *out_bytes = ret;
> +       return 0;
> +}
> +
> +static int zstd_decompress(const char *in, unsigned int in_bytes,
> +                          char *out, unsigned int *out_bytes)
> +{
> +       size_t ret;
> +
> +       ret = ZSTD_decompressDCtx(ctx_d, out, *out_bytes, in, in_bytes);
> +       if (ZSTD_isError(ret)) {
> +               errno = -EINVAL;
> +               return -1;
> +       }
> +       *out_bytes = ret;
> +       errno = 0;
> +       return 0;
> +}
> +
> +static unsigned int zstd_compress_bound(unsigned int in_bytes)
> +{
> +       return ZSTD_compressBound(in_bytes);
> +}
> +
> +static bool zstd_is_supported(const char *name, const char *version)
> +{
> +       if (!name)
> +               return false;
> +       if (strcmp(name, __ZSTD_NAME))
> +               return false;
> +
> +       return true;
> +}
> +
> +int tracecmd_zstd_init(void)
> +{
> +       int ret = 0;
> +       size_t r;
> +
> +       ctx_c = ZSTD_createCCtx();
> +       ctx_d = ZSTD_createDCtx();
> +       if (!ctx_c || !ctx_d)
> +               goto err;
> +
> +       r = ZSTD_CCtx_setParameter(ctx_c, ZSTD_c_contentSizeFlag, 0);
> +       if (ZSTD_isError(r))
> +               goto err;
> +
> +       ret = tracecmd_compress_proto_register(__ZSTD_NAME,
> +                                              ZSTD_versionString(),
> +                                              __ZSTD_WEIGTH,
> +                                              zstd_compress,
> +                                              zstd_decompress,
> +                                              zstd_compress_bound,
> +                                              zstd_is_supported);

I think tracecmd_compress_proto_register() should be extend  with two new hooks:
    void *(*new_context)(void),
    void (*free_context)(void *),
and ctx_c,  ctx_d should be allocated and freed there. Currently, that
logic in trace-cmd is in a single thread. That may change in the
future, and then the current design will be a limitation.

> +       if (!ret)
> +               return 0;
> +err:
> +       ZSTD_freeCCtx(ctx_c);
> +       ZSTD_freeDCtx(ctx_d);
> +       ctx_c = NULL;
> +       ctx_d = NULL;
> +       if (ret < 0)
> +               return ret;
> +       return -1;
> +}
> diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
> index 210d58b602577..a14155a321f45 100644
> --- a/lib/trace-cmd/trace-compress.c
> +++ b/lib/trace-cmd/trace-compress.c
> @@ -390,6 +390,9 @@ void tracecmd_compress_init(void)
>  #ifdef HAVE_ZLIB
>         tracecmd_zlib_init();
>  #endif
> +#ifdef HAVE_ZSTD
> +       tracecmd_zstd_init();
> +#endif
>  }
>
>  static struct compress_proto *compress_proto_select(void)
> diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> index 56742f0afa2f8..355f04723ad7c 100644
> --- a/tracecmd/Makefile
> +++ b/tracecmd/Makefile
> @@ -49,7 +49,7 @@ all_objs := $(sort $(ALL_OBJS))
>  all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
>
>  CONFIG_INCLUDES =
> -CONFIG_LIBS    = -lrt -lpthread $(TRACE_LIBS)
> +CONFIG_LIBS    = -lrt -lpthread $(TRACE_LIBS) $(LIBZSTD_LDLAGS)
>  CONFIG_FLAGS   =
>
>  ifeq ($(ZLIB_INSTALLED), 1)
> --
> 2.35.1
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
