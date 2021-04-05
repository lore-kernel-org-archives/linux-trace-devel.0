Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C980BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 10:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2383613A5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 10:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhDEK4h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 06:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbhDEK4g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 06:56:36 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5083DC061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 03:56:29 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d10so3046034pgf.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 03:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ze/XBJref6FVhKRuUlZ1mo3tixI8Bbw0/3XB0jN3Ec4=;
        b=sNlWEu2hz+xe211ii8unmFasBYg26/sDJuVSV4w6aYU2MO1S43PFlHO8rbobIfmiZz
         rYkMZEad2KfB/TcvAQArATRkMIFlBkHIrA645lKU/mFSFeTOOmwVFsX8TqqF2IS47qPm
         x2sPGolia5ZVRfg3AkT9S05dJovyl3c4pYAIEYOz13gHf/w4uVc2hwERupu0QW/piFuB
         GsLhkhP/p9Wb1Pxctl5YT+wTWuo9JjlQW3gMS+rFFWCGmtMOyURZagebQKgv6axxtcuT
         vgjtLoLmH/McV97RT6PMuebv1C//vvIKbGiwj3o7L3wxsKZfxCFxQb5EGCIjoiITw48f
         gQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ze/XBJref6FVhKRuUlZ1mo3tixI8Bbw0/3XB0jN3Ec4=;
        b=Ay21zjkzBY5659yA4xWuIxC/NwHnA9RBADpuwPRGgivi0SLRnqn0Sgchy2CS1c1eyd
         eY/3rnOxqkL81CxVur4LgLVcUjYtd9QqVKMCF9htYD+GhoU5OU3XxlzGi3qhw4g37xlo
         APgOfI7HqKi7yOayWButOqqByKbb78fNjiVT3fd50v61UtviTKmceFSptolgD8fc0ND/
         jk8/3FaqDDGRGy2Cwv+cZ+BMorE6E6kclEalcNL2FnGVMl4leuljQsFEsr0itgzA/8HO
         aOBuBQduaPT4kQfM8FcEsnJSHeIyPmg7pIxlJnu18ksH7f5gOrhK3OqyaVSNI7uFcUla
         j0fg==
X-Gm-Message-State: AOAM5327KQA/E5bO9+sTIna08r+36q9pCu95IwYC/Be0hLv1NmMJIbyU
        +5oCAta/M6wD5ivyiC6+WJ0uSMFxF/tsyAxZ2Ug=
X-Google-Smtp-Source: ABdhPJx1YrqBmUtN+mqoD0hKDh97SOJvpjw3bD18QV1monLjG+hhCcfCsSdBgrlm6eg4jz7JLtW2tnULfM7AwAKkogM=
X-Received: by 2002:a63:81:: with SMTP id 123mr22056729pga.307.1617620188937;
 Mon, 05 Apr 2021 03:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210402131947.346235-1-y.karadz@gmail.com> <20210402131947.346235-6-y.karadz@gmail.com>
In-Reply-To: <20210402131947.346235-6-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 5 Apr 2021 13:56:12 +0300
Message-ID: <CAPpZLN5J7GM00DsqEiaq7yK+7fd2UENWH54xwKUWaYoYyRN30Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] libtracefs: Option's bit masks to be owned by the instance
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 2, 2021 at 4:20 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> If the instance owns two mask objects, we no longer need to
> dynamically allocate memory in tracefs_options_get_supported() and
> tracefs_options_get_enabled(). This will simplify the code on the
> caller side, since the user is no longer responsible for freeing
> those masks.
>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  Documentation/libtracefs-option-get.txt |  4 +---
>  include/tracefs.h                       |  6 +++---
>  src/tracefs-instance.c                  | 24 ++++++++++++------------
>  3 files changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
> index 9b3cb56..3290f24 100644
> --- a/Documentation/libtracefs-option-get.txt
> +++ b/Documentation/libtracefs-option-get.txt
> @@ -52,14 +52,13 @@ EXAMPLE
>  --
>  #include <tracefs.h>
>  ...
> -struct tracefs_options_mask *options;
> +const struct tracefs_options_mask *options;
>  ...
>  options = tracefs_options_get_supported(NULL);
>  if (!options) {
>         /* Failed to get supported options */
>  } else {
>         ...
> -       free(options);
>  }
>  ...
>  options = tracefs_options_get_enabled(NULL);
> @@ -67,7 +66,6 @@ if (!options) {
>         /* Failed to get options, enabled in the top instance */
>  } else {
>         ...
> -       free(options);
>  }
>  ...
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 0665e8d..9efa91a 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -132,11 +132,11 @@ enum tracefs_option_id {
>  #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
>
>  struct tracefs_options_mask;
> -bool tracefs_option_is_set(struct tracefs_options_mask *options,
> +bool tracefs_option_is_set(const struct tracefs_options_mask *options,
>                            enum tracefs_option_id id);
> -struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
> +const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
>  bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
> -struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
> +const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
>  bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id);
>  int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
>  int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index 49645eb..9cb4b6d 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -27,6 +27,8 @@ struct tracefs_instance {
>         char    *trace_dir;
>         char    *name;
>         int     flags;
> +       struct tracefs_options_mask     supported_opts;
> +       struct tracefs_options_mask     enabled_opts;
>  };
>
>  /**
> @@ -695,9 +697,8 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
>         DIR *dir = NULL;
>         long long val;
>
> -       bitmask = calloc(1, sizeof(struct tracefs_options_mask));
> -       if (!bitmask)
> -               return NULL;
> +       bitmask = enabled? &instance->enabled_opts : &instance->supported_opts;

The "instance" argument can be NULL, for the top instance. There
should be global enabled_opts and supported_opts, to be used in that
case.

[..]


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
