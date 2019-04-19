Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BC5C282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D556C20645
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JalocRJs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfDSSyy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:54:54 -0400
Received: from mail-vs1-f48.google.com ([209.85.217.48]:42772 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfDSSyy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:54:54 -0400
Received: by mail-vs1-f48.google.com with SMTP id f15so3278287vsk.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 11:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NnwydNYSlUSAqidHm+0nMcU/5NGjNnmzjU/EMcm4LJg=;
        b=JalocRJsLLszp5JoZZ7MvESHgOISJL30gz7/6DqMfp88ywnh00nZ2nGXovjMQUylL8
         bPE9+4L3JqWwuw9U46NFHkXysqfGZhD5KqnDr9b5vrrWesjrS1h4JxfgFunPzWslm6WI
         82x3CR5+gWg3396c9pMSqcuhWrQ+rl0NACZ5jrP7x8BidDEx3dnRcQG7zP8ysa2IVRoo
         1y+v9gRihcfzquYbHZNJSOKRLklemgOBpg3UcqBINjO3GvJ1UWvMAdAHKaR/YnUelwqU
         cDpnB4a5o6JkCFon7m+hZMpo3bG4ouKuMp3YzmRDIPzVtVadjZZhogbuwFpJaqRrRabb
         Psfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NnwydNYSlUSAqidHm+0nMcU/5NGjNnmzjU/EMcm4LJg=;
        b=gcbaTeWT+PvKuG0LpngLGyRPbdlTH1iFGAvwH7nCqr3w379XI3TvKt0UJ3tBH1hwbg
         6+tvjFMGd6fZPvhhV+6ltiGbbF8eUfOkGwQQJcE2bfUJUf+WLVGwAu+A1H3WpwHM2VlY
         0VmhkXHMk3hNiFT9jQEmLNZXDcCzmeKS4AuzqY+pcOKPs1N2cAjvYKrLQpRFW8dmZ+ck
         B/PstaLMZSl0b7WVcEKKwW24tgYoQ9EWabk4GakDvgkC/KqWnCFlQFCNgdQGyskCYgUZ
         oh/y6pVxNjXQESfQjNE7eDvpVAoTIuzKnG59w0WkbYa9CywJR85cvYV6TNTj4EwpLDd3
         8O+Q==
X-Gm-Message-State: APjAAAWFt+EoGel3NvyvznI7/YZ69ReaUiuTo8dOFGQF6S3qm/fHtFXm
        N+UwBmfc4McuOYZBlFM7stnbYtFMKyqiR3wN1L1wG3c=
X-Google-Smtp-Source: APXvYqwuabeGZADzizTfdFcd6f2gXDgoSO5/uhXth9ckAfJ/cTkAEt2zvCvO4Lkicqis4SPCC6zO39HZmJmzxw/FB6M=
X-Received: by 2002:a67:f588:: with SMTP id i8mr1269396vso.91.1555658979647;
 Fri, 19 Apr 2019 00:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190418152146.27232-1-ykaradzhov@vmware.com> <20190418152146.27232-9-ykaradzhov@vmware.com>
In-Reply-To: <20190418152146.27232-9-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 19 Apr 2019 10:29:27 +0300
Message-ID: <CAE0o1NtiXyL9RW2+t6mS2nXkH=ZQz2vukDMz3f4dTiLBxJG+8w@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] kernel-shark: Handle the case when the marker
 points to a filtered entry
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 18, 2019 at 6:23 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> Markers can point to entries that are filtered out. When switching
> the marker it may happen that new Active Marker points to an entry
> that is filtered. In this case no actions must be taken and a warning
> message for the user must be displayed.
>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsTraceViewer.cpp | 27 +++++++++++++++++----------
>  kernel-shark/src/KsTraceViewer.hpp |  2 ++
>  2 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
> index 04a38b8..85da64f 100644
> --- a/kernel-shark/src/KsTraceViewer.cpp
> +++ b/kernel-shark/src/KsTraceViewer.cpp
> @@ -61,7 +61,8 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
>    _graphFollowsCheckBox(this),
>    _graphFollows(true),
>    _mState(nullptr),
> -  _data(nullptr)
> +  _data(nullptr),
> +  _em(this)
>  {
>         this->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Maximum);
>
> @@ -493,15 +494,21 @@ void KsTraceViewer::markSwitch()
>                 QModelIndex index =
>                         _proxyModel.mapFromSource(_model.index(row, 0));
>
> -               /*
> -                * The row of the active marker will be colored according to
> -                * the assigned property of the current state of the Dual
> -                * marker. Auto-scrolling is temporarily disabled because we
> -                * do not want to scroll to the position of the marker yet.
> -                */
> -               _view.setAutoScroll(false);
> -               _view.selectRow(index.row());
> -               _view.setAutoScroll(true);
> +               if (index.isValid()) {
> +                       /*
> +                        * The row of the active marker will be colored according to
> +                        * the assigned property of the current state of the Dual
> +                        * marker. Auto-scrolling is temporarily disabled because we
> +                        * do not want to scroll to the position of the marker yet.
> +                        */
> +                       _view.setAutoScroll(false);
> +                       _view.selectRow(index.row());
> +                       _view.setAutoScroll(true);
> +               } else {
> +                       _view.clearSelection();
> +                       QString err("The marker's entry is filtered out.");
> +                       _em.showMessage(err);

When is this error message going to be cleared? I don't think it
changes atm unless a new error comes along.

-- Slavi
