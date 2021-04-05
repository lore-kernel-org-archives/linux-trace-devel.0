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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C730AC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 10:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 786D8613A3
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 10:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhDEKvB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 06:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhDEKvB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 06:51:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBB7C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 03:50:55 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso5637623pjb.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 03:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/aYxZQ0sIfNAwEaDuoi7f74flPIbK1A9jqzEG3fIY9I=;
        b=kzTVvaswmtxx7GIAwQuAeeIHOYWSqTfKPuue8RKejnCjvECww9wv/Fj3xYCRfequWV
         QAonO+UGCzcCxLnILegru0O4yr5Wezf+vjkYYD7RFINbreL5S0q4qtRQLr4HW9O7iGc/
         FO/kYuIRsvpeUHWLD+JirnOsil/g9Tan4Jk0tK5PBQG8EIRf5rlHrpaUGQkWi8260qBL
         VYMZWJdJ/WHoSFKujgU1E3Gd7oe+gwk3GnH2AhS4HJNxT3P6L5EZmt8ipxj0W6kVZrlB
         gC2iQPI/rpPuOYJ9YQrX1FaZg+2kYNgMLjW89KrRadKkNpYTHnym2fZlEA15zjH7QZVh
         go7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/aYxZQ0sIfNAwEaDuoi7f74flPIbK1A9jqzEG3fIY9I=;
        b=inbvSCnyjfLEz3WzV3ogYyEFDvG6bKCnZ2urSdHkkrwMke/r+fQSP3qzL9ADXszNtE
         h1cCV0Du1YqdkgqVyeZgz+hLq9NbFBltrHZZNKKxmj6fJEl9hb/oV2vwKOzdx3TqQfBQ
         CtEOpGY+LSbq8y2zrWpJUCoOy6LGtu8VIzwz/3tjXHWGy60DP1OKtYwVD73k3F7kapsK
         mfpg7eLwNhnSw+GIKoBCuqycIf4+GpV348o0k78WnQhY3tHwtpMlXjN6qjo42wlxBk1h
         tG4DKDg3zJw7/n9K8CFQzwlEuS4UGww6yfX5JGcDgub/Vd020kGhqLFF2tDllGpYnFtN
         b4vg==
X-Gm-Message-State: AOAM533qRKwySm1WBNZ2cPVBWhViWm+ADOWvK+Q9jgREpzzaaZ5G0IaC
        jav8hZNBEYvaE+h56jQZwI1FDmc11triHKO8kJs=
X-Google-Smtp-Source: ABdhPJwFqDShIixhxbd84V/doQYOvuqB95N8x1vqGoIYHL0Z0CT1kbO5vJBM/KRoK2w66S6zqXBCqCOVpklzdc4ee3k=
X-Received: by 2002:a17:90a:6343:: with SMTP id v3mr25687798pjs.153.1617619855077;
 Mon, 05 Apr 2021 03:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210402131947.346235-1-y.karadz@gmail.com> <20210402131947.346235-6-y.karadz@gmail.com>
In-Reply-To: <20210402131947.346235-6-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 5 Apr 2021 13:50:38 +0300
Message-ID: <CAPpZLN5rj-O+fzxf=AR1NbUUDtyjJUXw5Kn5O8nSuZiK554p4g@mail.gmail.com>
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
>  ..

The description of the return value of tracefs_options_get_supported()
and tracefs_options_get_enabled() should be changed also, as it
suggests to free the return value;

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

This makes the API not thread safe. There should be no problem with
supported options, as they cannot be changed at runtime. I think it is
OK to limit the APIs , as I see no use case to call them from multiple
threads on the same instance, but this should be described in the
documentation.

> +
>         dname = tracefs_instance_get_file(instance, "options");
>         if (!dname)
>                 goto error;
> @@ -727,7 +728,6 @@ error:
>         if (dir)
>                 closedir(dir);
>         tracefs_put_tracing_file(dname);
> -       free(bitmask);
>         return NULL;
>  }
>
> @@ -735,10 +735,10 @@ error:
>   * tracefs_options_get_supported - Get all supported trace options in given instance
>   * @instance: ftrace instance, can be NULL for the top instance
>   *
> - * Returns allocated bitmask structure with all trace options, supported in given
> - * instance, or NULL in case of an error. The returned structure must be freed with free()
> + * Returns bitmask structure with all trace options, supported in given instance,
> + * or NULL in case of an error.
>   */
> -struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
> +const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
>  {
>         return trace_get_options(instance, false);

As supported options cannot be changed at runtime, they can be read
only once. The next calls can return the already initialised bitmask
with supported options.

>  }
> @@ -747,10 +747,10 @@ struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instan
>   * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
>   * @instance: ftrace instance, can be NULL for the top instance
>   *
> - * Returns allocated bitmask structure with all trace options, enabled in given
> - * instance, or NULL in case of an error. The returned structure must be freed with free()
> + * Returns allocated bitmask structure with all trace options, enabled in given instance,
> + * or NULL in case of an error.
>   */
> -struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
> +const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
>  {
>         return trace_get_options(instance, true);
>  }
> @@ -758,7 +758,7 @@ struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance
>  static int trace_config_option(struct tracefs_instance *instance,
>                                enum tracefs_option_id id, bool set)
>  {
> -       char *set_str = set ? "1" : "0";
> +       const char *set_str = set ? "1" : "0";
>         char file[PATH_MAX];
>         const char *name;
>
> @@ -846,7 +846,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
>   * Returns true if an option with given id is set in the bitmask,
>   * false if it is not set.
>   */
> -bool tracefs_option_is_set(struct tracefs_options_mask *options,
> +bool tracefs_option_is_set(const struct tracefs_options_mask *options,
>                            enum tracefs_option_id id)
>  {
>         if (id > TRACEFS_OPTION_INVALID)
> --
> 2.27.0
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
