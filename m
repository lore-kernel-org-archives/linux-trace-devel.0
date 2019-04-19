Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3445C282E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 20:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74DD22171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 20:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e72CGUm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfDSUGf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 16:06:35 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34759 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfDSUGf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 16:06:35 -0400
Received: by mail-ua1-f67.google.com with SMTP id c6so2055153uan.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 13:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WckyHcOKwMYQcxTEb2KH4OpOxBzOla8VyzdlMY6+yv4=;
        b=e72CGUm8qK5knIuG+naakjBbwE5PldkX9AhucwjNTSxEvKWJ/CzrQafb/qiSM9zIgP
         qL7fzZCouvR2v1sDjABau2tcCVoj1MhABHBDLZEnnN6cV4FEHAfXw7aCSzdF6Cbq3Pnf
         PmpgUEL64Rr60/zamd3fQM0+fnNhub6otx9HLBVNCl/macztD1751OlORAMaUA6hPRXw
         pzBtphya5Ycx3xf5O+7p4gFsLz4pkjBy8qFjFDLh3/P5ObNEB66fJP6Ns8OYvsm74nKS
         G5bOHbhMr9E81frb4HWgORaqh0SvmowUUf55IcQ8+OdJgD905X3rMuF1TFkua9I8jTXT
         PBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WckyHcOKwMYQcxTEb2KH4OpOxBzOla8VyzdlMY6+yv4=;
        b=B6aS/sCY0ugETS3u0PlWZF+ZkbIk7GH0H41nfD7FFQcADuK/16RHweL6KewAbxd01w
         x88c072Lf+IM85MdEpZA0Y9GsifaqocpryVKa6dendWu1FxVx3nnhlz362ohVosSW+1G
         Nt0CWuutGs7VYXhsDnm8jLk45lZk+HNq842/pEOjITAIA8sKUTMo7F/WV9rRPSJ0cfH8
         wSzwlWOHupc5upKI6P4lndb/GL7WnF6WqrbmCNzWhwhJZUZS3ZAurfjU9kfJj5vDDfTP
         LFcuNhw0FmvoIG8a2fdnjuc3Hb2lBWICaZIchnvIGRrYFfCnC3ifpHEo0EQ2BJW46J/4
         t21w==
X-Gm-Message-State: APjAAAVm7T4gLwNdOnzYX994f6Hh3dBsAAL0wn0xZ9sBPw6NF6JliUnj
        zkszgHBcSHV4G5ouT1nNDRzqAtnAurxH9lgaUxxHotoq+Q==
X-Google-Smtp-Source: APXvYqwX1QL0WaRLQXf10mkzxm8ArIrh+YArYzB+JCYQDtZxTBx4Rf0dtNvR+SzaoZofRI5J9nkCfOpJ4dFz7oOV9Yo=
X-Received: by 2002:a9f:2f1a:: with SMTP id x26mr1266559uaj.20.1555658951302;
 Fri, 19 Apr 2019 00:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190418152146.27232-1-ykaradzhov@vmware.com> <20190418152146.27232-4-ykaradzhov@vmware.com>
In-Reply-To: <20190418152146.27232-4-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 19 Apr 2019 10:26:40 +0300
Message-ID: <CAE0o1NvnsJp+hxm=vxtuBvDuNuUYUduGfoC7MkxdSqNjPf_1Pg@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] kernel-shark: Add logic for the initial path of
 Open-File dialogs
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
> If the application has been started from the source code directory,
> all OpenFile dialogs will start there. If the application has been
> started from its installation location, all Open File dialogs will
> start at ${HOME}.
>
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsCaptureDialog.cpp |  6 +++---
>  kernel-shark/src/KsMainWindow.cpp    | 12 ++++++------
>  kernel-shark/src/KsUtils.hpp         | 15 +++++++++++++++
>  3 files changed, 24 insertions(+), 9 deletions(-)

[...]

> diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
> index c8b5e88..877c62a 100644
> --- a/kernel-shark/src/KsUtils.hpp
> +++ b/kernel-shark/src/KsUtils.hpp
> @@ -111,6 +111,21 @@ inline QString Ts2String(int64_t ts, int prec)
>
>  bool matchCPUVisible(struct kshark_context *kshark_ctx,
>                               struct kshark_entry *e, int cpu);
> +
> +/**
> + * @brief Get the directory to be used when opening QFileDialog. If the
> + *       application has been started from the source code directory, all
> + *       Open File dialogs will start there. If the application has been
> + *       started from its installation location, all Open File dialogs will
> + *       start at ${HOME}.
> + */
> +inline QString dialogDir()
> +{
> +       QString path = QCoreApplication::applicationFilePath();
> +
> +       return (path.contains(KS_DIR)) ? KS_DIR : QDir::homePath();

Nit: no need for the parenthesis around `path.contains(KS_DIR)`

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

As a user of KernelShark who keeps his traces in ~/tmp, I still think
that opening the last directory used and saving it between KernelShark
invocations would be a great feature. But I don't think there's any
KernelShark global config being saved atm so having this as a follow
up in the future is fine.

Cheers,

-- Slavi
