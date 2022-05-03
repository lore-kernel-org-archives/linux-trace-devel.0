Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F647C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 May 2022 04:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiECEUd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 May 2022 00:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiECEUc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 May 2022 00:20:32 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1365138BFC
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 May 2022 21:17:01 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id s1so3580945uac.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 May 2022 21:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6nBG3AOiLa6/3NABPV6L1foxYR7iyGMnP9QjOzy/uuo=;
        b=VCte3Off/sgkbgx160wOjYmZXAVEbUfTfArzPUK+ex6TvEv0g8b1cRflGheRcVK/15
         jXhYRclIo+NePle0P7rOrRbj2CTHmBtcImfsgP4Lo5pHAD3U0c+m+6ekcEmawR0+a68i
         kTei9pxg2GtT6nvGk+Ousu29LGSrzYxw97GRirjiPdqsIijsfnWeA8Ug49okHD4LoSFC
         7q5pycDlcluuxeJlYXRzo5Uqvb/4HR8rHcyc71y1DwHAHE9lcSG3sAiw+Y+yphkgwbrQ
         omSgMnVG8WEr3a2z7CjhKbco8umX7c77+Vo79TkoA3pda3wdArt7E/cmF9cgY3hjPsaE
         MgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6nBG3AOiLa6/3NABPV6L1foxYR7iyGMnP9QjOzy/uuo=;
        b=YWjJgakZMUw+AkbqhoEeDdTnigSKFn2WaH7d8ACn3gG7y3JX5MGbJvP4ll379pcKok
         7X5JZ0kV1TCf6TTUAIHxpOgvr2PJ/Wu3DWo1vytE7QkV3TeZEm3qdoYUIQ0X2xaDH8R4
         HKVgbS86dUXB/l+n49Z0PYKmsi313FDo2N3LEKe4BeKbSu74bBdo9ofFfUsxhzeOSb1t
         erbmBH2xgZ3NCoe79Xp9VR3L1eIh1zDM3wrmdQe06NvB4l8ET2bXaQTgS7GjOxmRw3iM
         ltzzN8Gd44A6aNKY05tTneeVD0NdaD2AABmS33KYFiylibU2EIihk4qdJI9HFzkME09S
         1B/g==
X-Gm-Message-State: AOAM530QAxD1RfE/GMr6kRQ4gzabSpEdfjniRzZQE5nVD6tPFoRJ/X0M
        2U5rK4E9gx/sN+Dphijr4P0J4uNUuUJqMYqhOPbOW2DceD7d6JAT
X-Google-Smtp-Source: ABdhPJxH375NBaiVkGWv0LC+TXqn8jQPkiuVXwBpkWHUZmyw521O3zAV26X8cUMx2TZLqyOVOf4nBrojgia2zT8TnAk=
X-Received: by 2002:ab0:160b:0:b0:35c:ca56:6e85 with SMTP id
 k11-20020ab0160b000000b0035cca566e85mr4024652uae.20.1651551420182; Mon, 02
 May 2022 21:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220502100641.1903517-1-y.karadz@gmail.com>
In-Reply-To: <20220502100641.1903517-1-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 3 May 2022 07:16:44 +0300
Message-ID: <CAPpZLN53S_GF--DtDXOyAJ34MUPEGFFvEZ3R0Z1zkWtED-L8fA@mail.gmail.com>
Subject: Re: [PATCH v3] trace-cruncher: Build trace-obj-debug.c as library
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, May 2, 2022 at 1:06 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> The code for resolving virtual address to function name gets build
> as shared library. The library is installed as package data. Later
> this library can be used by the different sub-modules of tracecruncher.
>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>
> This patch applies on top of the patch:
> https://lore.kernel.org/all/20220420080206.252356-2-tz.stoyanov@gmail.com/
>
> Changes in v2:
>  - Fixing the problem of '$ORIGIN' not being properly added to
>    the 'RUNPATH' of the shared libraries, built by the sub-modules.
>
> Changes in v3:
>  - The name of the library changet to 'libtcrunchbase.so'. Some Makefile
>    variables are changed accordingly.
>
>  Makefile | 24 +++++++++++++++++++++---
>  setup.py |  4 ++--
>  2 files changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 52428c0..d359ea6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -13,13 +13,31 @@ NC  := '\e[0m'
>
>  DOCDIR = ./docs
>
> -all:
> +CC = gcc
> +CFLAGS = -fPIC -Wall -Wextra -O2 -g
> +LDFLAGS = -shared -lbfd
> +RM = rm -rf
> +
> +TC_BASE_LIB = tracecruncher/libtcrunchbase.so
> +PY_SETUP = setup
> +
> +BASE_SRCS = src/trace-obj-debug.c
> +BASE_OBJS = $(BASE_SRCS:.c=.o)
> +
> +all: $(TC_BASE_LIB) $(PY_SETUP)
>         @ echo ${CYAN}Buildinging trace-cruncher:${NC};
> +
> +$(PY_SETUP):
>         python3 setup.py build
>
> +$(TC_BASE_LIB): $(BASE_OBJS)
> +       $(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
> +
>  clean:
> -       rm -f src/npdatawrapper.c
> -       rm -rf build
> +       ${RM} src/npdatawrapper.c
> +       ${RM} $(TC_BASE_LIB)
> +       ${RM} src/*.o
> +       ${RM} build
>
>  install:
>         @ echo ${CYAN}Installing trace-cruncher:${NC};
> diff --git a/setup.py b/setup.py
> index 58561cf..aca634c 100644
> --- a/setup.py
> +++ b/setup.py
> @@ -37,7 +37,7 @@ def add_library(lib, min_version,
>          libs_found.extend([(lib, lib_version)])
>
>  def third_party_paths():
> -    library_dirs = []
> +    library_dirs = ['$ORIGIN','tracecruncher']
>      include_dirs = [np.get_include()]
>      libs_required = [('libtraceevent', '1.5.0'),
>                       ('libtracefs',    '1.3.0'),
> @@ -61,7 +61,6 @@ include_dirs, library_dirs = third_party_paths()
>
>  def extension(name, sources, libraries):
>      runtime_library_dirs = library_dirs
> -    runtime_library_dirs.extend('$ORIGIN')
>      return Extension(name, sources=sources,
>                             include_dirs=include_dirs,
>                             library_dirs=library_dirs,
> @@ -91,6 +90,7 @@ def main():
>            url='https://github.com/vmware/trace-cruncher',
>            license='LGPL-2.1',
>            packages=find_packages(),
> +          package_data={'tracecruncher': ['*.so']},
>            ext_modules=[module_ft, module_data, module_ks],
>            classifiers=[
>                'Development Status :: 4 - Beta',
> --
> 2.32.0
>

Applied,
Thanks Yordan!


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
