Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7EAC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09FF02075C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ov6EEWCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfCKMUf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:20:35 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43940 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfCKMUf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 08:20:35 -0400
Received: by mail-io1-f65.google.com with SMTP id y6so3791453ioq.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 05:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uQvJ8n8aoKcHzZo5O0VJV+P/KyuCQ2hzJxwDFSc0tKs=;
        b=ov6EEWCQLFmS+UEp9pFBntPbrDiCbFJHV3gAa/DZytvDhnipt9KTNFGIN1r8sEnxgf
         fUT1SGqgr23bh75Oaw3yCCzmhV+R6OjeQ8yiI5shxFM505wD4EeC8/VLFnWhDOc8EhnQ
         i3OgH8U3exiQEWeaTq08eSrK6ZbZWI0cvfBspPNH6YPOvWI7KiZQFkkfS6pbLtftKgUF
         hXLbyB1vyTOQr30L1lL/HsTYO1b1XUbUURoJ6bvKQwj0dJqo2OMMb5zY+3bgcykwMTMy
         orlEJnJocrGNccnFDAzVzM70/ad7ybbwbyUcuVaJjE6+vu/rPkaQItZbnNipGUsUDzyc
         fXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uQvJ8n8aoKcHzZo5O0VJV+P/KyuCQ2hzJxwDFSc0tKs=;
        b=suEHdABlofKkM1mJE5xkopUiYQ0SxGayEo5Rf+IcptGX8G5b+MBBppnCNzYyKhBE0u
         Oi3VHyVsCJ4OAK8X95HvaRCRXA9DZrOqrzd99df3CyOOSnG30ML17Cksqb1j7cGbD5JG
         Gq1POkpX9nVWapjs2BCm7FI6Q4mh/kRjYUEIMdhtj+mDquynlZ6S375ltrujIdKqluUZ
         21cHtBNpfY9WIu00y1UqctHB3zE1NExQyn2MWHkFtLw6ga9jQqfrfH5DfGEn95U0Zx0o
         XqR/RhflCyf4HnHFeEXJv90oKrX3NV/d79PGvLffmoxqn+XSL/fIeExTvmSzzeAkNjRG
         DMEw==
X-Gm-Message-State: APjAAAWscS97xCGaMMoCM3rzoIk4CV7u9ny8i/Om8FD1TDsNQcmCYKP4
        qzdIFz+B8e0oNivlrUYJi6IQQSjMJpJ+FdbOP/M2JXojTg==
X-Google-Smtp-Source: APXvYqztcchJZ0PjMLG5ruzPeCYIEbZcbUnkBb+SWgO2BFzLcsfEHOIz9M332IUVHXjVRQr12+oMKuDL5Brl1Ux4/M4=
X-Received: by 2002:a5d:8190:: with SMTP id u16mr17859030ion.238.1552306834520;
 Mon, 11 Mar 2019 05:20:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190308171512.15372-1-ykaradzhov@vmware.com> <20190308171512.15372-3-ykaradzhov@vmware.com>
In-Reply-To: <20190308171512.15372-3-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 11 Mar 2019 14:20:23 +0200
Message-ID: <CAE0o1NsO5nqemTQ5v2HR9bixVKeiO9Dc8=D9-w36o7b15O9P=A@mail.gmail.com>
Subject: Re: [PATCH 2/3] kernel-shark: Save the configuration information in ${HOME}/.kshark
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 8, 2019 at 7:16 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> By default the "Last session" configuration file will be saved in
> ${HOME}/.kshark

${HOME}/.config/foobar seems to be the standard path these days for
config files[1]. Wdyt about switching it to ${HOME}/.config/khark?

[1] https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

-- Slavi

>
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  Makefile                    | 2 +-
>  kernel-shark/CMakeLists.txt | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index b780718..967c364 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -254,7 +254,7 @@ all_cmd: $(CMD_TARGETS)
>  CMAKE_COMMAND = /usr/bin/cmake
>
>  $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> -       $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
> +       $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DKS_CONF_DIR=$(HOME)/.kshark ..
>
>  gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>         $(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 20ced14..3c3beb0 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -14,7 +14,7 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
>
>  # Make a directory to hold configuration files. To change this do:
>  # cmake .. -DKS_CONF_DIR=/your/preferred/path
> -set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
> +set(KS_CONF_DIR "$ENV{HOME}/.kshark" CACHE STRING "Directory for configuration files.")
>  file(MAKE_DIRECTORY ${KS_CONF_DIR})
>
>  include(${KS_DIR}/build/FindTraceCmd.cmake)
> @@ -59,7 +59,8 @@ include_directories(${KS_DIR}/src/
>  message("")
>  message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
>  message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
> -message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
> +message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS}\n)
> +message(STATUS "config. files saved in ${KS_CONF_DIR}")
>
>  add_subdirectory(${KS_DIR}/src)
>  add_subdirectory(${KS_DIR}/examples)
> --
> 2.19.1
>


-- 
Slavomir Kaslev
