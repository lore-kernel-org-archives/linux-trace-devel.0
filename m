Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D13EC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0266920657
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qqlPiV3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfCKMbO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:31:14 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50481 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfCKMbO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 08:31:14 -0400
Received: by mail-it1-f195.google.com with SMTP id m137so6915723ita.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 05:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0987FjP4LfVMOxoj1K+8fhGzKNfamdJh9c8ctU8x1FI=;
        b=qqlPiV3nx8frT2REGaXFhlB+0UyMXXvED5qPuhEr9w2CNdx86TzV7jgdH1i4YN8iyW
         tyJNudzn3CPZcVk7Ho6WyS2k1j4E0wOmbjWnVnOLe1tyMQkm149lJR78tON9Oazi4gHY
         7/27j2rElM5ctobQLpfYuJnrSQFsfC7txazz7pLxvlZqoqDFRtYZYuiFDMYpp5hbhY5l
         8VD+S0obNYBUuFdgut6WelP1gLbPM13ipQm7e8C/uV5dpac/zg7NdjXX5OU4/+aKFgbe
         JBKLxKgf5V0zysOJZ9GOLPn6tYMbf2/SBq3I+Epk9DNbLKXvxQNU0u8nY263Gk/z5Qb7
         3NyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0987FjP4LfVMOxoj1K+8fhGzKNfamdJh9c8ctU8x1FI=;
        b=I2RUhh/gsL/mJV+cTyXIvI32b17oj6jpKVVPqwvxyeQpDc8zNiSpkRvh791RYJoE1G
         Lgqi11t1g6FUfmkHq2FLkveeIxdW9CqqifUtDjpexH/P27+jSH57HvOXkdxmNpR9N01n
         vypGnJIpn3VQ0a9kpDsgwkA/afqF01wNyite3TMZh6c6TRWGgutZCwPtivmpTb5EOHXa
         LH61uUdpsmIR8RG3Ka8fJtd+NybAUJxB1PSStMNrHiNKqJCfNHIfetGuSdLikeS/RQYB
         TN4ggu5eG1UfoSr2DTd8/HAI0Na8yeA8B1TAIJvGXG3ISP0q10rqHTH/bHmQr35ce5pD
         cFhQ==
X-Gm-Message-State: APjAAAV43cqOK8ibW1CPjxIEJkOSQcjIJVe4oqYJDBFpptDGhsjwoc2n
        tBqjrVfyvi5aVCy1dVq4847hPwYsB7x/O+cD76QQdxs=
X-Google-Smtp-Source: APXvYqy0OvOLpFtk45lSS81OQMuWdLzNZdqbTO4q0gG8zTsQBgYnlZtfWYXMbkuiEBhyvhUZF0HlKRyapm+fQWoQniU=
X-Received: by 2002:a24:918c:: with SMTP id i134mr15117449ite.92.1552307473416;
 Mon, 11 Mar 2019 05:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190308171405.15266-1-ykaradzhov@vmware.com> <20190308171405.15266-2-ykaradzhov@vmware.com>
In-Reply-To: <20190308171405.15266-2-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 11 Mar 2019 14:31:02 +0200
Message-ID: <CAE0o1Nv7xkKyFnpYYT4vfpwpQYc_LiNKPuv7aAf7PYUoEUkCTQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] kernel-shark: Define addPlugin method for KsPluginManager
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 8, 2019 at 7:14 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> The method can be used to register and load a user-defined plugin.
> All other previously loaded plugins will be reloaded.
>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsUtils.cpp | 17 +++++++++++++++++
>  kernel-shark/src/KsUtils.hpp |  3 +++
>  2 files changed, 20 insertions(+)
>
> diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
> index d7b1753..4d05bda 100644
> --- a/kernel-shark/src/KsUtils.cpp
> +++ b/kernel-shark/src/KsUtils.cpp
> @@ -596,6 +596,23 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
>         }
>  }
>
> +/** @brief Add to the list and load a user-provided plugin. All other
> + *        previously loaded plugins will be reloaded.
> + *
> + * @param fileName: the library file (.so) of the plugin.
> +*/
> +void KsPluginManager::addPlugin(const QString &fileName)
> +{
> +       kshark_context *kshark_ctx(nullptr);
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return;
> +
> +       kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
> +       registerPlugin(fileName);
> +       kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
> +}

Calling addPlugin() several times in a row will reinitialize all
already registered plugins several times and lead to quadratic
complexity. This seems wrong to me.

Maybe we should split adding plugins from (re-)initializing them so
that one can add several plugins and then have initialized once when
they are actually needed to run. Wdyt?

--Slavi

> +
>  /** Unload all plugins. */
>  void KsPluginManager::unloadAll()
>  {
> diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
> index cb95b4f..ae7f6d1 100644
> --- a/kernel-shark/src/KsUtils.hpp
> +++ b/kernel-shark/src/KsUtils.hpp
> @@ -210,6 +210,9 @@ public:
>
>         void registerPlugin(const QString &plugin);
>         void unregisterPlugin(const QString &plugin);
> +
> +       void addPlugin(const QString &fileName);
> +
>         void unloadAll();
>
>         void updatePlugins(QVector<int> pluginId);
> --
> 2.19.1
>


-- 
Slavomir Kaslev
