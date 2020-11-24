Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECD3C63777
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 16:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8697B206B7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 16:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7ObwY3d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390341AbgKXQVf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390271AbgKXQVf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 11:21:35 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF751C0613D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 08:21:33 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w187so4466323pfd.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 08:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/ocHGGLOFMq2WK670g34Y05nlTyxsB/mDdxx5sPUnk=;
        b=I7ObwY3duSrYaR0JIrwAP6J23JD7X+CyN00E9KfmY8/MfuLVjaIQUWK++7qazGcZrS
         p379xHup8O0/w70SrpJhlJlTQP0ylr8t+3sULgZJKeQEaHSgmqges1jwo2z2fTsDmvIv
         ke4VCf6fx3TEe9tjcawCaj2kKbHZF1+K2YyWH9yumh5B2ISYHUI1f4aTxaHOQuFG6Y3M
         ExRl5pk6wMGmXjBtDpLR0wJVNKPVDQteWccZp69cXtDAKFVgFcQOwYH96wZXaAyJftvT
         dY7SXJ+O9WRQikE5NNxblABbXFcSxWqr8b7c6nK0o/t+TKqa5f5344kuEc0DqA+pZa0X
         VBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/ocHGGLOFMq2WK670g34Y05nlTyxsB/mDdxx5sPUnk=;
        b=RkhzSPql9jdb5N8pxMwVQdm7BaBXBbHUzKA6QRJqFliDhqrhWfJxMmSFgD57A7uPuq
         L6EBGJJ7TCOUHrbc1FdukRRhV3LeC+dc17R30rr57XQ6pcK8PXkTpKGiTTJ7SArqfb6X
         OqS2bjgrIV7TCkGiB+px9AXSjWb/rpVCiXXLO6qocT82IZ6zsL2Htn6rOaVAQr+dsSlk
         dcR7qLGq34bhRZQMI18BJ6FICVDOHxtfruHWi7qyKMp+DPFrtjnnQhvHIi/ikN/PyD1l
         1QoS9BdIIGAe08SmCsYFinTNa/blffxXOLHwXvJs9T8cAssqtZZDTZk/TZIovNCRmQdn
         tJrw==
X-Gm-Message-State: AOAM532mhTcNO81JCCLKM2rbEFNXGWSbEoOx8WDpMdUPS79IOZ6iS9sJ
        lL3zDYQIxbvOGJ1oWpS32AN+Ol8myxqS/0u0GL3Wqx3xhovDQZVy
X-Google-Smtp-Source: ABdhPJw2Cdb2OhQWfOQMhvtgsm6W18+mHW4xKc3gSmuPwFerA45hXYCRU9y3GOFA9LzyUhrFy8XDWW4oZw3kgtZAtmE=
X-Received: by 2002:a17:90a:aa0e:: with SMTP id k14mr5860956pjq.153.1606234893311;
 Tue, 24 Nov 2020 08:21:33 -0800 (PST)
MIME-Version: 1.0
References: <20201124091241.3c0dbbc4@gandalf.local.home>
In-Reply-To: <20201124091241.3c0dbbc4@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 24 Nov 2020 18:21:16 +0200
Message-ID: <CAPpZLN4p1Buzs19t6Uy1xthgAMCxTcF12bE5JTv9SpEjd0j0eA@mail.gmail.com>
Subject: Re: [PATCH v2] libtracevent: Build libtraceevent.pc via "make" not
 "make install"
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Nov 24, 2020 at 4:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> "make install" copies libtraceevent.pc.template to libtraceevent.pc and then
> modifies it for the installation. This command is usually executed as root,
> and when finished, it leaves behind the libtraceevent.pc file owned by root
> and that may not be modified by the owner of the directory.
>
> Instead, have the libtraceevent.pc file created via normal "make" and then
> have the "make install" copy it to the system location.
>
> Link: https://lore.kernel.org/linux-trace-devel/20201123184940.031517790@goodmis.org
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  Changes since v1:
>     - Have libtraceevent.pc created by "make" and not simply remove
>       it after creation from the "make install". This allows us to be
>       able to debug it, if it was not created properly.
>          (Tzvetomir Stoyanov)
>
>  Makefile | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 2a6bfcc..318ec55 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -52,6 +52,9 @@ includedir_relative = traceevent
>  includedir = $(prefix)/include/$(includedir_relative)
>  includedir_SQ = '$(subst ','\'',$(includedir))'
>
> +PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
> +PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
> +
>  export man_dir man_dir_SQ INSTALL
>  export DESTDIR DESTDIR_SQ
>  export EVENT_PARSE_VERSION
> @@ -126,7 +129,7 @@ build := -f $(srctree)/build/Makefile.build dir=. obj
>  TE_IN      := $(OUTPUT)libtraceevent-in.o
>  LIB_TARGET := $(addprefix $(OUTPUT),$(LIB_TARGET))
>
> -CMD_TARGETS = $(LIB_TARGET)
> +CMD_TARGETS = $(LIB_TARGET) $(PKG_CONFIG_FILE)
>
>  TARGETS = $(CMD_TARGETS)
>
> @@ -208,15 +211,19 @@ define do_install
>         $(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
>  endef
>
> -PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
> -PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
> +define do_make_pkgconfig_file
> +       cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};    \
> +       sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE};            \
> +       sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
> +       sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
> +       sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE};
> +endef
> +
> +$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
> +       $(QUIET_GEN) $(call do_make_pkgconfig_file,$(prefix))
> +
>  define do_install_pkgconfig_file
>         if [ -n "${pkgconfig_dir}" ]; then                                      \
> -               cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};    \
> -               sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE};            \
> -               sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
> -               sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
> -               sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
>                 $(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644);     \
>         else                                                                    \
>                 (echo Failed to locate pkg-config directory) 1>&2;              \
> @@ -228,7 +235,7 @@ install_lib: all_cmd install_plugins install_headers install_pkgconfig
>                 $(call do_install_mkdir,$(libdir_SQ)); \
>                 cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
>
> -install_pkgconfig:
> +install_pkgconfig: $(PKG_CONFIG_FILE)
>         $(call QUIET_INSTALL, $(PKG_CONFIG_FILE)) \
>                 $(call do_install_pkgconfig_file,$(prefix))
>
> --
> 2.25.4
>

Thanks Steven!
Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
