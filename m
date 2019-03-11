Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28D9C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ECB42075C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="twwNHile"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfCKMJw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:09:52 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52603 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfCKMJw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 08:09:52 -0400
Received: by mail-it1-f196.google.com with SMTP id g17so6824801ita.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 05:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3PmT+OlaYiYqDcyoiaIaRy+XcbBwLZSQTsgM7+5EO/A=;
        b=twwNHilefWibFO1h0KKqXRAL1GexZu0PyEQf3yzfxNZWp69oMN6EziBuhA1a7TZitU
         jm46oJ23bgJfkR8H2ZM0q6LMI+QPEYp8rXwDP4BYcGa4SuUPEMT5g4sUcmiZVsSD63Zl
         ax8FyDV9bwTJ/681sdjnI3bNJPvq8FZyu2QRt3v6LLpBhzJhnBbQ7AGUC+0qpdnoYxcl
         WSGQTer54Ctr3ltYF8GQ88aIqYmdILm6GUAL2Z972Ox88r9KCqg+3/SY2eZ8uFLKVQvy
         UQB9xmuVnNymkKBl0+QcozcjFa10s3IWiUfo6b2UE0bCFGUAI/gu1T49R8QWMP65oord
         kHdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3PmT+OlaYiYqDcyoiaIaRy+XcbBwLZSQTsgM7+5EO/A=;
        b=sqeLHnJqlDUe86m4WSCwS7nCq4vVOn6+FvcEBBDZ/0f0sCilF7PGDdcJeq5LwXdv+0
         9inFmd3JROZNO8z1s7XFh5fXHNHZMPltIGhH++FSBnse6D3gHvU/dsJt+vVV0SKeaw0q
         wz7UpP7iJ/RuPQD/i1qby4Lm/ghHablgl8kiKPMEBxY/+8bDzG6iiK5ryklkERFG7HbM
         RWRDq4FaO9VOIxA8PijeBBQy8fHzon0/u2qdFWuaxazFd2iyOhFU3hy1BpXcbEgQo/G6
         /sfRhQRI0Cx+4dTEl9DpSd3I7seqiLXlea5MZeKQPqNPks6EeD50phNRBCx5MCipXaVX
         A/Ag==
X-Gm-Message-State: APjAAAV04z7f8aGqukJaD4zhiFdJSSCetEz259vHWbYK5+bwzLwHGq1R
        uFwo1yj6XpHlrk2Yh+Jkv6ZEIvXVPxwouDCwQMyHxpg=
X-Google-Smtp-Source: APXvYqw4ZiCYm1bo2tbFCxxvNnr7zq0PjRwnvg2iGROl27IIk8gs1Mb57lSvddUlujkNur0hTy5yrX5h6qhRSm+NU18=
X-Received: by 2002:a02:8a4a:: with SMTP id e10mr1059677jal.120.1552306190215;
 Mon, 11 Mar 2019 05:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190307154316.19194-1-ykaradzhov@vmware.com> <20190307154316.19194-5-ykaradzhov@vmware.com>
In-Reply-To: <20190307154316.19194-5-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 11 Mar 2019 14:09:39 +0200
Message-ID: <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 7, 2019 at 5:44 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> const char *lib = plugin.toStdString().c_str();
>
> This line is a bad idea because the returned array may (will) be
> invalidated when the destructor of std::string is called.
>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsUtils.cpp | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
> index 34b2e2d..d7b1753 100644
> --- a/kernel-shark/src/KsUtils.cpp
> +++ b/kernel-shark/src/KsUtils.cpp
> @@ -439,7 +439,7 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
>
>         auto lamRegUser = [&kshark_ctx](const QString &plugin)
>         {
> -               const char *lib = plugin.toStdString().c_str();
> +               const char *lib = plugin.toLocal8Bit().data();
>                 kshark_register_plugin(kshark_ctx, lib);
>         };
>
> @@ -474,7 +474,7 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
>
>         auto lamUregUser = [&kshark_ctx](const QString &plugin)
>         {
> -               const char *lib = plugin.toStdString().c_str();
> +               const char *lib = plugin.toLocal8Bit().data();
>                 kshark_unregister_plugin(kshark_ctx, lib);
>         };

Doesn't the new version have the same problem with the temporary QByteArray?

How about saving the data in a local std::string/QByteArray variable?

               std::string lib = plugin.toStdString();
               kshark_register_plugin(kshark_ctx, lib.c_str());

Thanks!


--
Slavomir Kaslev
