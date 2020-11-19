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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFC9C6369E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 15:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD9F24654
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 15:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5ASz1F9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgKSPH4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgKSPHz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 10:07:55 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C89FC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 07:07:55 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a18so4765116pfl.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 07:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ris826pdb0UO7GvGTEt4J4VH02rjY6F1VqAd6vFo4A=;
        b=D5ASz1F9GVZo6UFviXTCLzxxrveUgtKkEEifoGtWS1hoH/YeObsJwXJAfo/xe2hFK4
         7dwaq6Juz9Vzp8zws8mdEyto7PIj6ITUj6gSaf3++P5IitFyJ1QL2WaPQD9SiDAQzztF
         YnmgkCIa2hf+wtlx7Q7TnwZ7oyTr20JXadJNhx1o+IWN0odxEsphH7AjmBL9U9Foy1kY
         iZs6AGM5KK4a+nRwv/z/VaylGiAvatVJ8+V6f2j92RV4BNgiFJiZTRX6qSOI0EFSwfGS
         uv3dGasJuypGHp12N+4MazE355Vwsv2vMQd7KFfTcq/Os03Yf9u9mGKBAFTXjFrJEj59
         8F7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ris826pdb0UO7GvGTEt4J4VH02rjY6F1VqAd6vFo4A=;
        b=h+OQCXeXb9+TiZqYbLPO7XReNvgf5L2Pb7+NG0vWuftWrM0sX6S9nn7XvyC0tVotdd
         svcIxN2HleRou6cCvqditIOiKEdqEGW1pdx5ee6h1CjW7C7h2RH+IQX7lAOyyFkS43ww
         TYSxqoHKgCRpRXQudpNQs3e6s0CjmniIuXB3RG+GbAeHZ+VUjESij8t+OVonhUe525FW
         XZMe2YvkIvIPJ/e3wGkDKfIDkNQkM5WUpAGkQmmBH+HmweYnTX3HFK8BGXSOm+DGZ76H
         n2+pwXMVOV2U0m6Yq8UjhIOqahdx9esvtdFoSUjwnHIf8Lx7du6yCv9DVHVroG0neD5z
         QQnw==
X-Gm-Message-State: AOAM533+PtkOfb/dgbGphAymlXc4bVCQzrwNOi59L2BDSNhLMmajAhyl
        D6Mq2axuUU0N62ADyG7lVQzdP8b1pw1fc+MVHlvUGM9kLULb3YQg
X-Google-Smtp-Source: ABdhPJx8kW+l3yJ7JBPLoOocrPuevFo+9clU2gg3n5Qm5cPuyKx5C37c9XjjPYATe/nUFuyPzW/+AW14/8qV6JRBgD8=
X-Received: by 2002:a17:90a:8c8d:: with SMTP id b13mr405330pjo.2.1605798475109;
 Thu, 19 Nov 2020 07:07:55 -0800 (PST)
MIME-Version: 1.0
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
 <20201117074557.180602-6-tz.stoyanov@gmail.com> <20201118164416.4cf12941@oasis.local.home>
 <20201118164611.007c6900@oasis.local.home>
In-Reply-To: <20201118164611.007c6900@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 19 Nov 2020 17:07:38 +0200
Message-ID: <CAPpZLN6=TvMukE67QK_3UK-3eU8t3QqDG0y26DnzT=wpsivxDw@mail.gmail.com>
Subject: Re: [PATCH v4.1 - 5.1/8] libtracefs: Use the permissions of the
 instances directory for instances
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 18, 2020 at 11:46 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
>
> Use the same permissions of the instances directory for the permissions of
> creating a new instance.
>
> Link: https://lore.kernel.org/linux-trace-devel/20201117074557.180602-6-tz.stoyanov@gmail.com
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  lib/tracefs/tracefs-instance.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
> index 06f33c35..13ec4f5f 100644
> --- a/lib/tracefs/tracefs-instance.c
> +++ b/lib/tracefs/tracefs-instance.c
> @@ -57,6 +57,25 @@ void tracefs_instance_free(struct tracefs_instance *instance)
>         free(instance);
>  }
>
> +static mode_t get_trace_file_permissions(char *name)
> +{
> +       mode_t rmode = 0;
> +       struct stat st;
> +       char *path;
> +       int ret;
> +
> +       path = tracefs_get_tracing_file(name);
> +       if (!path)
> +               return 0;
> +       ret = stat(path, &st);
> +       if (ret)
> +               goto out;
> +       rmode = st.st_mode & ACCESSPERMS;
> +out:
> +       tracefs_put_tracing_file(path);
> +       return rmode;
> +}
> +
>  /**
>   * tracefs_instance_create - Create a new ftrace instance
>   * @instance: Pointer to the instance to be created
> @@ -67,15 +86,18 @@ void tracefs_instance_free(struct tracefs_instance *instance)
>  int tracefs_instance_create(struct tracefs_instance *instance)
>  {
>         struct stat st;
> +       mode_t mode;
>         char *path;
>         int ret;
>
>         path = tracefs_instance_get_dir(instance);
>         ret = stat(path, &st);
> -       if (ret < 0)
> -               ret = mkdir(path, 0777);
> -       else
> +       if (ret < 0) {
> +               mode = get_trace_file_permissions("instances");
> +               ret = mkdir(path, mode);
> +       } else {
>                 ret = 1;
> +       }
>         tracefs_put_tracing_file(path);
>         return ret;
>  }
> --
> 2.25.4
>
I'm OK with that split.
Thanks, Steven!

Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
