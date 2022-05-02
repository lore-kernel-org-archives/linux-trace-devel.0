Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30F5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 May 2022 03:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357084AbiEBDXw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 1 May 2022 23:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349452AbiEBDXl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 1 May 2022 23:23:41 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170FF12A8E
        for <linux-trace-devel@vger.kernel.org>; Sun,  1 May 2022 20:20:12 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id q2so12554726vsr.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 01 May 2022 20:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ruXMHVZ63XXTt6bQZrbcnejCpyNQMEh7mWp3ktWeJWw=;
        b=HFfzJHqLhe6RKTeCQU3OQ0J+6C/5R6ZlCK8dhJbXDdab+bsq8InyNAey/tbAjeivro
         VjtweAduV/+ZnepyPABWUi4IRQOW+pRTHpU59+fVZQluLQmkCjPkkMOyPDkXvEaM2Lbn
         EVscYnHPTt0ZerLQwf/1KNosLCIMiLhIz7/V6rtzGU9u1oVnojPfFDJofy49eFQ1cm7i
         SEx8YuDEcPAKUMKVYmnDsBaUEYg7SvtOI5x18JKwpMub7xTWGawyJBdKswqNpiehINho
         94f0QxogFXeq3e/tCWtIQvVKxRLrhiUnTkvQEPFJrKMJf2Xpxy4YEtbVysdVZ/2DiBDU
         e9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ruXMHVZ63XXTt6bQZrbcnejCpyNQMEh7mWp3ktWeJWw=;
        b=WNLDWKHTmJbk4gBI9ebnz4ZMkhbkWnUj1h/aJ5lYv2zr7PutMT+3751Gl1FAYg6w/O
         RuL1b8TKMj595TdtD70sAcwHcXNldfYFvQHFCpNPnNN06ujhB6nO9w2POw6NTXw5S8p0
         bA4OY4CsUmQOCv3JfznEV34fs3toKdLaGxqbkzXLZre2jhfOSsSfSB9kLoCy3ike4bfG
         qOLseDGq6x1EeF1WSz1JllkVchX3F9fDeldrEU7JOCJtpFdd9psbe+/zXnyj7dx4TSay
         wRQd/7vtqpqp+TiKcFnmy9wOMQLJWmu8CgK4j5TjgwA022kbw8yg7NWfXkYlz8ojYO3G
         /T6w==
X-Gm-Message-State: AOAM5334Pxn+A98GhSjs1E5GMInAhbtET1wkRxSKfX4NOV4wxqlK3l42
        nTE3aF0FPy/zcJ7rYyz+sl7D2LzLZuPY5osfJedFjf929AVeZeVY
X-Google-Smtp-Source: ABdhPJyphp4Aqz1/suZoVVqdWWxY6a9ICPScQn1F4/P8Z2WNOgffnqME83bOuNW6NfYtmtRolwU1rbqxBO4YBHVVfUU=
X-Received: by 2002:a05:6102:274f:b0:32c:c3f2:7235 with SMTP id
 p15-20020a056102274f00b0032cc3f27235mr2854769vsu.82.1651461611202; Sun, 01
 May 2022 20:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220430102859.1769397-1-y.karadz@gmail.com>
In-Reply-To: <20220430102859.1769397-1-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 2 May 2022 06:19:55 +0300
Message-ID: <CAPpZLN4u2xSuSvvnzW=XFJsg0qWPnhRvw3Opi=FzXiDhD9P73A@mail.gmail.com>
Subject: Re: [PATCH v2] trace-cruncher: Build trace-obj-debug.c as library
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Apr 30, 2022 at 1:29 PM Yordan Karadzhov (VMware)
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
>  Makefile | 24 +++++++++++++++++++++---
>  setup.py |  4 ++--
>  2 files changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 52428c0..9b62c4a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -13,13 +13,31 @@ NC  := '\e[0m'
>
>  DOCDIR = ./docs
>
> -all:
> +CC = gcc
> +CFLAGS = -fPIC -Wall -Wextra -O2 -g
> +LDFLAGS = -shared
> +RM = rm -rf
> +
> +DBG_LIB = tracecruncher/libobjdebug.so

Having an internal library to share and reuse code is very useful. It
can be used for a lot of common code, not only for bfd wrappers.
Please, can you change the name of the library to be more common? I
would suggest libtccommon.so, libtcbase.so or something like that.
Thanks!

> +PY_SETUP = setup
> +
> +DBG_SRCS = src/trace-obj-debug.c
> +DBG_OBJS = src/trace-obj-debug.o
> +
> +all: $(DBG_LIB) $(PY_SETUP)
>         @ echo ${CYAN}Buildinging trace-cruncher:${NC};
> +
> +$(PY_SETUP):
>         python3 setup.py build
>
> +$(DBG_LIB): $(DBG_OBJS)
> +       $(CC) ${LDFLAGS} -o $@ $^ -L./tracecruncher -lbfd
> +
>  clean:
> -       rm -f src/npdatawrapper.c
> -       rm -rf build
> +       ${RM} src/npdatawrapper.c
> +       ${RM} $(DBG_LIB)
> +       ${RM} src/*.o
> +       ${RM} build
>
>  install:
>         @ echo ${CYAN}Installing trace-cruncher:${NC};
> diff --git a/setup.py b/setup.py
> index 58561cf..d9e296b 100644
> --- a/setup.py
> +++ b/setup.py
> @@ -37,7 +37,7 @@ def add_library(lib, min_version,
>          libs_found.extend([(lib, lib_version)])
>
>  def third_party_paths():
> -    library_dirs = []
> +    library_dirs = ['$ORIGIN', 'tracecruncher']
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
> +          package_data={'tracecruncher': ['libobjdebug.so']},
>            ext_modules=[module_ft, module_data, module_ks],
>            classifiers=[
>                'Development Status :: 4 - Beta',
> --
> 2.32.0
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
