Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8100C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 02:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiBVCwv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:52:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiBVCwt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 21:52:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789E025C70
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 18:52:25 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso978923pjs.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 18:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aL0wGuU1gzU8lIyooYej63NVBTTTX8Oux+VlulwFWjo=;
        b=d62UT1tEeg1ifmnwHrW2kD2hgqwwOVxOfSmeopjyhRnuKQgKzvWg4FQh01KDraoyNW
         4/5vyAoAp8d/N22IdJiR20B2nMxGmzQrN27KAeCdtvEfGzy+FiOYENU9zZvaE/uYRpLU
         RoAPMz7zenUDeZSEo+Ku7SwF+4Iq01gi0ATrt5Yr+zg/ceaGFnpYYJe7j6+9IgZ2eLJ6
         rzwtT4WQETzPjgHC3kgN0FgsJ8CZpYDKi/xDqnJ2Vybor/0eRf4IaPIZMkerOupf/5Af
         GalKVRX7iS0vCOmVU8Nu+AgZv0MYFQyyrltPLAnGeFZBjGtFnc7NAL9UQ66IXtqzFl7M
         J0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aL0wGuU1gzU8lIyooYej63NVBTTTX8Oux+VlulwFWjo=;
        b=grZGtGQ8jHnhAO3eOHNoZPPWh9VFBg3uNKIO9vBNfG7ZL5EGKd3gq1rvn54SvN59lz
         oUQeWZSYxAutf9v0XerBBRHp1ArpUZ36iX3jQmPp1m26A6elNttgR4bZBYUY8DrtzIP7
         OYyf2zr3/2jVQdoAVqWFYBuCHJFo1GiKOCkPyueUfmdsKXO1ZdbDdMd3j3t4OetJy4uG
         ZwtMVAMb2VcIIdtPk/Iy6RQFpjeGsHr4TahHNcewBWCUeVLVRKv3F43eUZzB+dM7crvH
         6VORa/ky5mj3jDPO3/+foblQgHnF7i7Dj4NVCHqTNvJKn4H0gh4TU1MUXVnaBq78xhpw
         D7KQ==
X-Gm-Message-State: AOAM532fMhZCDRweQikhX2ybVD0LaqLxX1BlhhC8tMhpsOx2Et3YUHOM
        xwiM+4zjztDwIaveg6GS1e0TraIx0GZAps+47NTV0dxE+UE=
X-Google-Smtp-Source: ABdhPJzeoR4UdrGtuwVoOFdAFZI69P4FxixWv5/Dl2fK0nSKGqHlvI/mb0rDpV1khbSGMVkpwWtQhTKxPzYNEEEqBDQ=
X-Received: by 2002:a17:90b:789:b0:1bc:293c:1445 with SMTP id
 l9-20020a17090b078900b001bc293c1445mr1875242pjz.111.1645498344990; Mon, 21
 Feb 2022 18:52:24 -0800 (PST)
MIME-Version: 1.0
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
 <20220219230151.56282-2-sebastian@breakpoint.cc> <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
 <YhOVEG2AjVPJEw0q@breakpoint.cc>
In-Reply-To: <YhOVEG2AjVPJEw0q@breakpoint.cc>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Feb 2022 04:52:08 +0200
Message-ID: <CAPpZLN6SJmpR5L5ipHVWrZwq9j4gJeXQC_D9fr8GZOUYSeNp2A@mail.gmail.com>
Subject: Re: [PATCH v2] trace-compress: Add ZSTD support.
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Feb 21, 2022 at 3:35 PM Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
>
> The zstd support is using the context aware function so there is no need
> to for the library to allocate one (including the memory) for every
> invocation. This requires to be used in a single threaded environment or
> the API needs to be extended to pass the context parameter.
>
> In most cases the input buffer was 40KiB so it does not make sense to
> use higher compression levels. Higher compression levels won't
> significantly improve the compression ration given that the every 40KiB
> block is independent. However higher compression levels will slow down
> the compression process.
>
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
> v1=E2=80=A6v2:
>   - Use HAVE_ZSTD around tracecmd_zstd_init().
>   - Make tracecmd_zstd_init() static inline so we can avoid the ifdef on
>     the user's side.

looks good to me, thanks Sebastian!
Acked-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

>
>  Makefile                                | 12 ++++
>  lib/trace-cmd/Makefile                  |  5 +-
>  lib/trace-cmd/include/trace-cmd-local.h |  9 +++
>  lib/trace-cmd/trace-compress-zstd.c     | 91 +++++++++++++++++++++++++
>  lib/trace-cmd/trace-compress.c          |  1 +
>  tracecmd/Makefile                       |  2 +-
>  6 files changed, 118 insertions(+), 2 deletions(-)
>  create mode 100644 lib/trace-cmd/trace-compress-zstd.c
>
> diff --git a/Makefile b/Makefile
> index f5c2cdb894f9a..109cbeb29002a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -307,6 +307,18 @@ CFLAGS +=3D -DHAVE_ZLIB
>  $(info    Have zlib compression support)
>  endif
>
> +TEST_LIBZSTD =3D $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 li=
bzstd > /dev/null 2>&1 && echo y")
> +
> +ifeq ("$(TEST_LIBZSTD)", "y")
> +LIBZSTD_CFLAGS =3D $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
> +LIBZSTD_LDLAGS =3D $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
> +CFLAGS +=3D -DHAVE_ZSTD
> +ZSTD_INSTALLED=3D1
> +$(info    Have ZSTD compression support)
> +endif
> +
> +export LIBZSTD_CFLAGS LIBZSTD_LDLAGS ZSTD_INSTALLED
> +
>  CUNIT_INSTALLED :=3D $(shell if (printf "$(pound)include <CUnit/Basic.h>=
\n void main(){CU_initialize_registry();}" | $(CC) -o /dev/null -x c - -lcu=
nit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
>  export CUNIT_INSTALLED
>
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index 1820c67b48474..da0ad4deeb4f0 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -29,6 +29,9 @@ OBJS +=3D trace-compress.o
>  ifeq ($(ZLIB_INSTALLED), 1)
>  OBJS +=3D trace-compress-zlib.o
>  endif
> +ifeq ($(ZSTD_INSTALLED), 1)
> +OBJS +=3D trace-compress-zstd.o
> +endif
>
>  # Additional util objects
>  OBJS +=3D trace-blk-hack.o
> @@ -48,7 +51,7 @@ $(DEPS): | $(bdir)
>  $(LIBTRACECMD_STATIC): $(OBJS)
>         $(Q)$(call do_build_static_lib)
>
> -LIBS =3D $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) -lpthread
> +LIBS =3D $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(LIBZSTD_LDLAGS) =
-lpthread
>
>  ifeq ($(ZLIB_INSTALLED), 1)
>  LIBS +=3D -lz
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/incl=
ude/trace-cmd-local.h
> index 48f179d6f524a..a16e488a6bed1 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -30,6 +30,15 @@ void tracecmd_info(const char *fmt, ...);
>  int tracecmd_zlib_init(void);
>  #endif
>
> +#ifdef HAVE_ZSTD
> +int tracecmd_zstd_init(void);
> +#else
> +static inline int tracecmd_zstd_init(void)
> +{
> +       return 0;
> +}
> +#endif
> +
>  struct data_file_write {
>         unsigned long long      file_size;
>         unsigned long long      write_size;
> diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-co=
mpress-zstd.c
> new file mode 100644
> index 0000000000000..fc5e350f32509
> --- /dev/null
> +++ b/lib/trace-cmd/trace-compress-zstd.c
> @@ -0,0 +1,91 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2022, Sebastian Andrzej Siewior <sebastian@breakpoint.c=
c>
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
> +       ret =3D ZSTD_compress2(ctx_c, out, *out_bytes, in, in_bytes);
> +       if (ZSTD_isError(ret))
> +               return -1;
> +       *out_bytes =3D ret;
> +       return 0;
> +}
> +
> +static int zstd_decompress(const char *in, unsigned int in_bytes,
> +                          char *out, unsigned int *out_bytes)
> +{
> +       size_t ret;
> +
> +       ret =3D ZSTD_decompressDCtx(ctx_d, out, *out_bytes, in, in_bytes)=
;
> +       if (ZSTD_isError(ret)) {
> +               errno =3D -EINVAL;
> +               return -1;
> +       }
> +       *out_bytes =3D ret;
> +       errno =3D 0;
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
> +       int ret =3D 0;
> +       size_t r;
> +
> +       ctx_c =3D ZSTD_createCCtx();
> +       ctx_d =3D ZSTD_createDCtx();
> +       if (!ctx_c || !ctx_d)
> +               goto err;
> +
> +       r =3D ZSTD_CCtx_setParameter(ctx_c, ZSTD_c_contentSizeFlag, 0);
> +       if (ZSTD_isError(r))
> +               goto err;
> +
> +       ret =3D tracecmd_compress_proto_register(__ZSTD_NAME,
> +                                              ZSTD_versionString(),
> +                                              __ZSTD_WEIGTH,
> +                                              zstd_compress,
> +                                              zstd_decompress,
> +                                              zstd_compress_bound,
> +                                              zstd_is_supported);
> +       if (!ret)
> +               return 0;
> +err:
> +       ZSTD_freeCCtx(ctx_c);
> +       ZSTD_freeDCtx(ctx_d);
> +       ctx_c =3D NULL;
> +       ctx_d =3D NULL;
> +       if (ret < 0)
> +               return ret;
> +       return -1;
> +}
> diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compres=
s.c
> index 210d58b602577..4fca7019ee048 100644
> --- a/lib/trace-cmd/trace-compress.c
> +++ b/lib/trace-cmd/trace-compress.c
> @@ -390,6 +390,7 @@ void tracecmd_compress_init(void)
>  #ifdef HAVE_ZLIB
>         tracecmd_zlib_init();
>  #endif
> +       tracecmd_zstd_init();
>  }
>
>  static struct compress_proto *compress_proto_select(void)
> diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> index 56742f0afa2f8..355f04723ad7c 100644
> --- a/tracecmd/Makefile
> +++ b/tracecmd/Makefile
> @@ -49,7 +49,7 @@ all_objs :=3D $(sort $(ALL_OBJS))
>  all_deps :=3D $(all_objs:$(bdir)/%.o=3D$(bdir)/.%.d)
>
>  CONFIG_INCLUDES =3D
> -CONFIG_LIBS    =3D -lrt -lpthread $(TRACE_LIBS)
> +CONFIG_LIBS    =3D -lrt -lpthread $(TRACE_LIBS) $(LIBZSTD_LDLAGS)
>  CONFIG_FLAGS   =3D
>
>  ifeq ($(ZLIB_INSTALLED), 1)
> --
> 2.35.1
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
