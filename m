Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B46C282E3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 20:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 543F32171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 20:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEWo8TpY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfDSUnQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 16:43:16 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:56020 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfDSUnQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 16:43:16 -0400
Received: by mail-it1-f196.google.com with SMTP id y134so10024357itc.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LX6sK0aLm1rw71XYqJI7JGyQQaGyjgbk5E1MlVseNRI=;
        b=UEWo8TpYh/LTsDDgyBY6NH/tONcKhHwIueExd9HITFoQFFKWSyYZ3D6BpIVpAmf4KQ
         brWBitzOs/HCEUhWHwhPc7B1c0pAvKVHPn0+h6Fht93VjXQaylCWsiUfcsGqlV+9AtxJ
         8Re2YuI0b5NeO5Mv9nUN1KrGXaVAbhyCeJ1MB8QJ4HkxnO2SAkYARJupDxPggXqa0xA/
         YTaVr0gNkSL6H+p5e/i8yVJs756c5AKGkia/cbTZ97HVqXyxAZD45pAiIwLrbbhOZ0/0
         agT3Qc16WKXIkyP1YVOsOIRN6l3yVhDkx2V7eAUrDb5t4vPN2xxzRRHzlaCDWhuN0j6G
         Afrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LX6sK0aLm1rw71XYqJI7JGyQQaGyjgbk5E1MlVseNRI=;
        b=DdBv8BO2dZhjdso/t4djIjL+I++7kfnig0bDrn4f59SDQm5RPpgzm+7R+An32WbHoJ
         Jbzu2r1Il4OKqCAFzPXbMo97Lm4vhQ0AMAp8rMg61613IyXAOVfqFQkCJtLc71sU8CVR
         9WvaYIKAJL3P7f+sxKi8ygs9rfvy4uuenSF9OeRMYaAKlYNVnn0B1CtWrfzeTcO/2ceD
         3bHD7B0au58sWxeoryncb3e/e/plrsiGsXpTUMhmNBU2aM3KuAtlapROydYM3BDAIoP6
         L6RrfYdMHTDDdT0Zo80o3LLDYEe451KWY0TeS8VL6vc5yfDY1jqUc9X4U5Wy42cIrVIa
         IN7g==
X-Gm-Message-State: APjAAAXJLMCCBM6EQTOMPkf2bBefNbwdgkHU5X8i13aOrp4rLVTcb6kD
        OjF/MsdCOuffs1nD2BICPS9rLSgOEq3U9bH0BUdmdk50mg==
X-Google-Smtp-Source: APXvYqxLy4cKU1SQdqvjJdjqRtRPshep4Hld1dWJcByOFUkkD7phDenhWyjsarzcCqs8cd8pDtWcgNbpGOWc1bR+vOY=
X-Received: by 2002:a24:6a8b:: with SMTP id l133mr1786432itc.92.1555658389820;
 Fri, 19 Apr 2019 00:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190418152146.27232-1-ykaradzhov@vmware.com> <20190418152146.27232-2-ykaradzhov@vmware.com>
In-Reply-To: <20190418152146.27232-2-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 19 Apr 2019 10:19:38 +0300
Message-ID: <CAE0o1NtWOkUWvmsc+RtJjM8LdD1Fp8C8wEir-WPj2GCxUhz+8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 18, 2019 at 6:22 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> By default the "Last session" configuration file will be saved in
> ${HOME}/.cache/kernelshark. If ${HOME}/.cache/kernelshark doesn't exist,
> it will be created automatically. The user can select another directory
> to be used to store the cached data. This can be done by setting the
> environment variable KS_USER_CACHE_DIR. In this case if the path (the
> value of KS_USER_CACHE_DIR) doesn't exist the user will be asked before
> create it.
>
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>

Nit: two identical Signed-off-by tags

> ---
>  kernel-shark/src/KsMainWindow.cpp | 68 +++++++++++++++++++++++++++----
>  kernel-shark/src/KsMainWindow.hpp |  4 ++
>  2 files changed, 63 insertions(+), 9 deletions(-)
>
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 7afb721..cf2db74 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp

[...]

> -void KsMainWindow::_restoreSession()
> +QString KsMainWindow::_getCacheDir()
> +{
> +       QString dir;
> +
> +       auto lamMakePath = [&] (bool ask) {
> +               if (ask) {
> +                       QMessageBox::StandardButton reply;
> +                       QString err("KernelShark cache directory not found!\n");
> +                       QString question =
> +                               QString("Do you want to create %1").arg(dir);
> +
> +                       reply = QMessageBox::question(this, "KernelShark",
> +                                                     err + question,
> +                                                     QMessageBox::Yes |
> +                                                     QMessageBox::No);
> +
> +                       if (reply == QMessageBox::No) {
> +                               dir.clear();
> +                               return;
> +                       }
> +               }
> +
> +               QDir().mkpath(dir);
> +       };
> +
> +       dir = getenv("KS_USER_CACHE_DIR");
> +       if (!dir.isEmpty()) {
> +               if (!QDir(dir).exists())
> +                       lamMakePath(true);
> +       } else {
> +               dir = QString(getpwuid(getuid())->pw_dir) +
> +                     "/.cache/kernelshark";

Nit: s/QString(getpwuid(getuid())->pw_dir)/QDir::homePath()/

Everything else looks great with the patch
Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

--Slavi
