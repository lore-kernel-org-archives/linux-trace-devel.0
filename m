Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC56C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD562084F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:16:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d0fLY9Gb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfCKMQM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:16:12 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44143 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfCKMQM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 08:16:12 -0400
Received: by mail-io1-f66.google.com with SMTP id u12so3784906iop.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 05:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mW4/D+pqaqPl/294QuVkkIcM1pIfPSoqB4U5DQUJ03A=;
        b=d0fLY9GbVflCdnB0RnhzCxM19W6eLBwVHPrz5Yo7FfjqRftHgDyAq2cuUCSLpdWu59
         U4sMLuCjkA4dnIADDjHbAZchBdciJbZyDLiCn+gtyJtorYVJAIje9QYqXSY9hUEZzN1d
         0pzc/64FG5RS7X7EbcZ7jBO8nxc2iVHuvVqZhrHMIMMo1lB9rI4aaKwKuEE+ePyw9vTT
         OKnl/K8ivtwXBR7AQOAmyTubRTBJWmRiBX5SCR/mCP+fJ6uYWP7YrY93ngPIEAd24ob3
         5hxcpOU5LxbC4J4k46s4pXJJJZFPHF0KXsKuh8BLwNP0pGbdD4HX0PdE908LyHTxUEsA
         IjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mW4/D+pqaqPl/294QuVkkIcM1pIfPSoqB4U5DQUJ03A=;
        b=aGwUIJMJTUOxsZ4nRaHta96503uxj8K9w3XbAyVRHr/pz3oL82Z+gJ/bRZAZjQhDUw
         JqKGSVsWvoE2dC6NmS1GpH4FsumbZUx+On0gtRVGvP2jcrQOUNXWDg8XtbGObf17i57w
         s8hZOrsXCsZs1TSs2CkHJVKuMiXy11eoLy6I5IiIum9f53MtIEfUNqiTfRAGW1ShOjqI
         EO+3C0c0l2Vy7ib28jOnEAttJt3xhY7zDP1J+9VS8oXpwQwLwcybtABgu8ztY5DnWovg
         tl6WrBnsD14Tx+uV4m4VstcIUd6uLHmGUzYvCUehPkNWzKPd6JIhTG2ENAa4r18LNmOD
         trpw==
X-Gm-Message-State: APjAAAXc5CJx2IZWDvpCTHAHjYi1QOjOYPxR2QnTs1pISOJFUjsZjELZ
        R4bOZpfH2/Z3sXbt/Endaou0ejpnGm7gRToc/Q==
X-Google-Smtp-Source: APXvYqwGvNFs64EfZrybega3j42barzEdqmyn/Kz0N5TAHntxgtj8l/gNtP09gT+S2l4jf87JS6xKAc9OskIA78HtrU=
X-Received: by 2002:a5d:9947:: with SMTP id v7mr17540621ios.81.1552306571244;
 Mon, 11 Mar 2019 05:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190308171512.15372-1-ykaradzhov@vmware.com> <20190308171512.15372-4-ykaradzhov@vmware.com>
In-Reply-To: <20190308171512.15372-4-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 11 Mar 2019 14:16:00 +0200
Message-ID: <CAE0o1NsC2AFgO53EumUC+kB8-0Ed8+k5dmrEsGfiCUhf5AAVPA@mail.gmail.com>
Subject: Re: [PATCH 3/3] kernel-shark: Set the location of .kshark directory
 via env. variable
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
> The environment variable ${KS_CONF_DIR} can be used to specify the
> directory where the "Last session" configuration file will be saved.
>
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 19 ++++++++++++-------
>  kernel-shark/src/KsMainWindow.hpp |  2 ++
>  2 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 2d61c3f..7f39c14 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -133,9 +133,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>  KsMainWindow::~KsMainWindow()
>  {
>         kshark_context *kshark_ctx(nullptr);
> -       QString file = KS_CONF_DIR;
> -
> -       file += "/lastsession.json";
> +       QString file = _getLastSessionFile();
>
>         _updateSession();
>         kshark_save_config_file(file.toLocal8Bit().data(),
> @@ -368,12 +366,19 @@ void KsMainWindow::_open()
>                 loadDataFile(fileName);
>  }
>
> -void KsMainWindow::_restorSession()
> +QString KsMainWindow::_getLastSessionFile()
>  {
> -       QString file = KS_CONF_DIR;
> -       file += "/lastsession.json";
> +       const char *file = getenv("KS_CONF_DIR");
>
> -       loadSession(file);
> +       if (!file)
> +               file = KS_CONF_DIR;
> +
> +       return QString(file) +  "/lastsession.json";
> +}
> +
> +void KsMainWindow::_restorSession()

Nit: typo _restorSession()  -> _restoreSession()

> +{
> +       loadSession(_getLastSessionFile());
>         _graph.updateGeom();
>  }
>
> diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
> index 0727631..9b7ec6d 100644
> --- a/kernel-shark/src/KsMainWindow.hpp
> +++ b/kernel-shark/src/KsMainWindow.hpp
> @@ -153,6 +153,8 @@ private:
>
>         void _open();
>
> +       QString _getLastSessionFile();
> +
>         void _restorSession();
>
>         void _importSession();
> --
> 2.19.1
>


-- 
Slavomir Kaslev
