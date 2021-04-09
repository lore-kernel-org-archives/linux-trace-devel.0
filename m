Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AB0C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D027A61168
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 04:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhDIEhM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhDIEhJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 00:37:09 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A1C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 21:36:56 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id g10so2125538plt.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 21:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8TYmLIFbfVj0LZItjhlHnZYipp9VfB1Yfa5ZOLo/38=;
        b=AhSwKH8ZuAJNP9HDhFuRqvWS+cDqBtkfe7k4FO70zFuYUXzFnpMVucO5xhY2/EHWao
         RhQz5pzEYsRuh2YXvCnjlpX9P8eNMmQ0Z2pcKHp+yaqiA5febOdJHqixFdkYYn7icCNv
         fUzZ/ONI3M+fmLGga7pKGrzykq9SRLvU5auXDOwRbFE7ic4BFuqMiihALYtISFqybQy9
         2MFUpiZ2di5IwVwuOczz87XPM3p1TziyXv3Q5H0DxYRpb2k9f4Pc5so0X2G4gCDfCcB0
         3V9FjZply2a6dLKoWbkiYgsdUk6zNGZBPaAlhvHBRqtzDJTQZkfPMnc0AaMNc27q9ZEv
         bGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8TYmLIFbfVj0LZItjhlHnZYipp9VfB1Yfa5ZOLo/38=;
        b=sKobKAJe3pv98kI6x6/DCFlA3wxnp20+9B2f5qrtzBceLDfMbmZFnaMImvAurfyOdV
         t3Xnr9e+wHdW/6A79TgbZsBCQdDsZJWTPlNiY6fc4GVUu/dVsrHSDUkN3Bv0mYVwS5de
         26vOTVJcYEaPdbq/9qA+/wiu0MkBnbwMzYM2FwETfSy3ZqtqMM6dc7EsNIJQJHbnWz7c
         QDmsFkS5ILIpYTcKEmmneCC/vfLXVU7GRbMvPIhRp7P6gUn7n62jpGH7fKl0AiKHTjDw
         EcgtoGDHBW1NMJStg0C+PgLFeVGJHpSzSAvGWfWDJFzQMt6uvvU/vp1BagOZ/eJu7hbm
         K3Vg==
X-Gm-Message-State: AOAM530TykWlq1Z7zuFyR9h9thlvGI8LnJu9bvlI7QQ1d/SZH2Sk0egc
        CUh32PCG5O+cukT9jRXTmzg6nlHmgkYbGDuCJ4zKjpj5cCuB7Q==
X-Google-Smtp-Source: ABdhPJzz+eQSw6HF9DNLMna4hzAtZtvqxSJTDOyGcc/7Hh8lnZVa8xtLHSnWbmqg2iAIYkzagg2+p/hot3OlUZpVAw8=
X-Received: by 2002:a17:90a:34c:: with SMTP id 12mr11757851pjf.100.1617943015601;
 Thu, 08 Apr 2021 21:36:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210408140024.13093-1-y.karadz@gmail.com> <20210408140024.13093-5-y.karadz@gmail.com>
In-Reply-To: <20210408140024.13093-5-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 9 Apr 2021 07:36:39 +0300
Message-ID: <CAPpZLN7G4AttMVFhwtf_YVouRtXhtNyHBK7QqEZWzAEeGhU_9Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] libtracefs: Option's bit masks to be owned by the instance
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 8, 2021 at 5:00 PM Yordan Karadzhov (VMware)
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
>  include/tracefs-local.h                 |  8 ++++++++
>  include/tracefs.h                       |  2 +-
>  src/tracefs-instance.c                  | 15 +++++++++++++++
>  src/tracefs-tools.c                     | 24 ++++++++++++++----------
>  5 files changed, 39 insertions(+), 14 deletions(-)
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
The description in the "RETURN VALUE" section should be changed also,
as now it suggests to free the bitmask returned by those APIs.

>
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 076b013..eb8c81b 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -25,6 +25,8 @@ struct tracefs_instance {
>         int                     flags;
>         int                     ftrace_filter_fd;
>         int                     ftrace_notrace_fd;
> +       struct tracefs_options_mask     supported_opts;
> +       struct tracefs_options_mask     enabled_opts;
>  };
>
>  extern pthread_mutex_t toplevel_lock;
> @@ -48,4 +50,10 @@ char *trace_find_tracing_dir(void);
>  #define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) /* 0666*/
>  #endif
>
> +struct tracefs_options_mask *
> +supported_opts_mask(struct tracefs_instance *instance);
> +
> +struct tracefs_options_mask *
> +enabled_opts_mask(struct tracefs_instance *instance);
> +
>  #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index e1fbef6..ea9dbd0 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -132,7 +132,7 @@ enum tracefs_option_id {
>  #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
>
>  struct tracefs_options_mask;
> -bool tracefs_option_is_set(struct tracefs_options_mask *options,
> +bool tracefs_option_is_set(const struct tracefs_options_mask *options,
>                            enum tracefs_option_id id);
>  struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
>  bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index 599c3a7..74122aa 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -21,6 +21,21 @@
>
>  #define FLAG_INSTANCE_NEWLY_CREATED    (1 << 0)
>
> +struct tracefs_options_mask    toplevel_supported_opts;
> +struct tracefs_options_mask    toplevel_enabled_opts;
> +
> +__hidden inline struct tracefs_options_mask *
> +supported_opts_mask(struct tracefs_instance *instance)
> +{
> +       return instance? &instance->supported_opts : &toplevel_supported_opts;
> +}
> +
> +__hidden inline struct tracefs_options_mask *
> +enabled_opts_mask(struct tracefs_instance *instance)
> +{
> +       return instance? &instance->enabled_opts : &toplevel_enabled_opts;
> +}
> +
>  /**
>   * instance_alloc - allocate a new ftrace instance
>   * @trace_dir - Full path to the tracing directory, where the instance is
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index fc9644a..b6967db 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -211,6 +211,7 @@ enum tracefs_option_id tracefs_option_id(const char *name)
>  static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
>                                                       bool enabled)
>  {
> +       pthread_mutex_t *lock = instance ? &instance->lock : &toplevel_lock;
>         struct tracefs_options_mask *bitmask;
>         enum tracefs_option_id id;
>         char file[PATH_MAX];
> @@ -219,9 +220,6 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
>         DIR *dir = NULL;
>         long long val;
>
> -       bitmask = calloc(1, sizeof(struct tracefs_options_mask));
> -       if (!bitmask)
> -               return NULL;
>         dname = tracefs_instance_get_file(instance, "options");
>         if (!dname)
>                 goto error;
> @@ -229,6 +227,11 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
>         if (!dir)
>                 goto error;
>
> +       bitmask = enabled? enabled_opts_mask(instance) :
> +                          supported_opts_mask(instance);
> +
> +       pthread_mutex_lock(lock);
> +       bitmask->mask = 0;
>         while ((dent = readdir(dir))) {
>                 if (*dent->d_name == '.')
>                         continue;
> @@ -242,6 +245,8 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
>                 if (id > TRACEFS_OPTION_INVALID)
>                         bitmask->mask |= (1ULL << (id - 1));
>         }
> +       pthread_mutex_unlock(lock);
> +
>         closedir(dir);
>         tracefs_put_tracing_file(dname);
>
> @@ -251,7 +256,6 @@ error:
>         if (dir)
>                 closedir(dir);
>         tracefs_put_tracing_file(dname);
> -       free(bitmask);
>         return NULL;
>  }
>
> @@ -259,8 +263,8 @@ error:
>   * tracefs_options_get_supported - Get all supported trace options in given instance
>   * @instance: ftrace instance, can be NULL for the top instance
>   *
> - * Returns allocated bitmask structure with all trace options, supported in given
> - * instance, or NULL in case of an error. The returned structure must be freed with free()
> + * Returns bitmask structure with all trace options, supported in given instance,
> + * or NULL in case of an error.
>   */
>  struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
>  {
> @@ -271,8 +275,8 @@ struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instan
>   * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
>   * @instance: ftrace instance, can be NULL for the top instance
>   *
> - * Returns allocated bitmask structure with all trace options, enabled in given
> - * instance, or NULL in case of an error. The returned structure must be freed with free()
> + * Returns bitmask structure with all trace options, enabled in given instance,
> + * or NULL in case of an error.
>   */
>  struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
>  {
> @@ -282,7 +286,7 @@ struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance
>  static int trace_config_option(struct tracefs_instance *instance,
>                                enum tracefs_option_id id, bool set)
>  {
> -       char *set_str = set ? "1" : "0";
> +       const char *set_str = set ? "1" : "0";
>         char file[PATH_MAX];
>         const char *name;
>
> @@ -370,7 +374,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
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
