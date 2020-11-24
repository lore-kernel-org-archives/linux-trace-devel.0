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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF9DC64E69
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 05:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E309206FB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 05:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fH1cTgBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgKXF0n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 00:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727692AbgKXF0n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 00:26:43 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103A9C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:26:43 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so16402204pgg.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QbVVUyz2DXfyTyAYQQ7MVrJRW0ZcQIGrG+NobVRMywU=;
        b=fH1cTgBYnWOW1t6x/j5rhZjIaPvkFmVhxREU7FXRudDra7+TF+HuL/BQwnzaPqQ3Kx
         9SAWpa85CYlBnjYOhU5X7JbVCzptgFfVcUKNPBsdymnABQMyIAcMGG6i+sNntXiJIWFL
         avs9sjCPlh8I0TSrTHQE3Meo8kYONBjQnRcMlq2vLP9VPpKPQSqFmqbfSjZWa0l+gQm4
         wINkuNcGuFPgqll7wKOvxOG3BeJcfAC+MEZE37UToSsQ8NRFXzMlsmq2wBY+yb0bDLJB
         HJkVFCGW9Y5a/T0XZPhD2hikab6GycQ5EYgFSnJeGTYl70iNtMHMuWT+eNaeoZ2LIF0G
         Wipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QbVVUyz2DXfyTyAYQQ7MVrJRW0ZcQIGrG+NobVRMywU=;
        b=ofo1xziiV4gKxIgkUG31SVRy3ajTBIMQDNMNK/GtoA2cxIsP3guCXNDETcmJaajRqI
         u0klbFnS4+9uaCVwFEE/t/DsLYzmyGrrZaN0hmJM/wNriXShAv8iPy6YrR8rCD062Fxr
         nnN0oCjKcOXip0OUkwHT7bd1NIx86IIlpb8bU2U6I4cte82KvhV/jBv1Hxw6RGMXV0fJ
         gLsJTpwh1oULvc+6Mrx6mRlhHPuh0FiokfUAkuZxz6/f37CA2GxjJB1xM8/BbzDkQy0/
         a1MouTMloFESUthvT26+lJv/Q2z/X3tA5hewHIWcm1LbeYyGakj7sJdimTRjUimaHbdb
         sDFQ==
X-Gm-Message-State: AOAM5309qCyIZ9foxogGca7nPp5vgVN8bevOfYjGINw2+lJHDfDlJPiq
        FYAsfRWJVA9NB6E4HrG6fqXirhmckbdMjIiya4KxykY52mL4t8Yp
X-Google-Smtp-Source: ABdhPJyRV5bJ8NtIp1yMlyfKZzqhCflWkOQKGblg6+yhKPmEANqyIJUHw4h1SHf8n/uBpwf3LDj2qlESQuqXEX48/ms=
X-Received: by 2002:a17:90a:8c8d:: with SMTP id b13mr3058281pjo.2.1606195602607;
 Mon, 23 Nov 2020 21:26:42 -0800 (PST)
MIME-Version: 1.0
References: <20201123184841.548901150@goodmis.org> <20201123184940.031517790@goodmis.org>
In-Reply-To: <20201123184940.031517790@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 24 Nov 2020 07:26:25 +0200
Message-ID: <CAPpZLN4MosDu7weSfpR+4FW72dRGxCVsFHGa6dV_hv1ROBGffA@mail.gmail.com>
Subject: Re: [PATCH 2/2] libtracevent: Remove tempfile libtraceevent.pc
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 23, 2020 at 8:50 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> "make install" copies libtraceevent.pc.template to libtraceevent.pc and then
> modifies it for the installation. This command is usually executed as root,
> and when finished, it leaves behind the libtraceevent.pc file owned by root.
>
> Have the "make install" clean up and remove the temporary libtraceevent.pc
> file, so that root owned files do not get left behind.

Isn't it useful to have this file after the "make install" command, for debug
purposes - to see how exactly it was modified ? The file is removed by
"make clean".

>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Makefile b/Makefile
> index 2a6bfcce814f..775fbd2b3f0e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -218,6 +218,7 @@ define do_install_pkgconfig_file
>                 sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
>                 sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
>                 $(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644);     \
> +               ${RM} ${PKG_CONFIG_FILE}; \
>         else                                                                    \
>                 (echo Failed to locate pkg-config directory) 1>&2;              \
>         fi
> --
> 2.28.0
>
>

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
