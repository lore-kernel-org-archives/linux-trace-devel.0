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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F752C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 04:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC8B64EED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 04:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCREXX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 00:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhCREXW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 00:23:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F02BC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 21:23:22 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v23so635285ple.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 21:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wopp2cKAV7GrQA0t7RhUxS57XuzBy/y8w+7FWqmbrl8=;
        b=EmzWbaoLPx/GeOBxGeP74bhbMlJWfKDEK11VFB0RnIdBnjqUIYBL4yJv2Phv4yw5z5
         95W75wOgAc0/rVdzLvoQ4P9ruoBZOYbRCfTMANGVfUMl95ZH3L+TUqF2hiMa6WgkWjHZ
         hPnXLzzDS0e1cfqO4Ob5PEfunBBDR9XP6uboAOiISLGpURKqZMSToJoyu5FeUvHKH4YZ
         jdQZ4fQvQD0EEHisJp+YNYYZecl1IpHT/SYF3ZncI4Bp5RzNf3nC8+xDxbqxRZ2LVtP+
         TZYagbfeD9at8r7hX3Xk3kmXEwHkgfySehuTUmGT9jpvenBEblr/Wxa1Y3GiKM9hPHmZ
         3BWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wopp2cKAV7GrQA0t7RhUxS57XuzBy/y8w+7FWqmbrl8=;
        b=b6FtJfzYJwY0nWun4pr7DlixRCXzkuFe2tqhBGRSiju57HO1MJ25Rk/j0HE7Y6zOdN
         D6rGr+OxWP6mkhcZK3kSKS3ftdrDCvIqLY4EfbXiqLuqWT/0V5jQUhk0Pegw5UzPoKuO
         LnEQnQGIkKW0lB/8Oyu9zGsxjeVzz2sVSqqBPfTI+iuicPgCf56bz0YOKrLL/uS6T+qx
         nxldeXHzwnm8VijM0nOpEBoijhzjNWgvxpDI/gSLfpuIUwxd4ZjJ0OF7v2Qe4ySzNmfo
         hNCMK3RpRYW5MrZ2/ZPKALmSpWj4kHPOvam3BwBEi48+6m7hK3zyV7AKdXBGXUsiqb0T
         P2Ew==
X-Gm-Message-State: AOAM532DIU698jmgAduHlQCLAMZIpcEr5NzlOpcbPKzS2HBw0T3otkB7
        L5LhdH5wuIHRn+GnQtMgDBujb+b7YJ1UraC2en4=
X-Google-Smtp-Source: ABdhPJzEC5388VspIhrs4a7QYvK2VnsQ+bwBWtjDv/P/hi0+H4hqwlbXnGjGWoITsK3YvvG+assYrDzRysS6iPZbuGY=
X-Received: by 2002:a17:902:dcd4:b029:e6:5398:609f with SMTP id
 t20-20020a170902dcd4b02900e65398609fmr7646266pll.58.1616041401727; Wed, 17
 Mar 2021 21:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <1616081417-4107-1-git-send-email-sameeruddin.shaik8@gmail.com>
In-Reply-To: <1616081417-4107-1-git-send-email-sameeruddin.shaik8@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Mar 2021 06:23:05 +0200
Message-ID: <CAPpZLN6MFmDar-7gvtb7Ke3=NrxWo==2BZQcKc7961ew8YXd7w@mail.gmail.com>
Subject: Re: [PATCH v2] libtracefs: An API to set the filtering of functions
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Sameer,
I have only one comment on this version:

On Wed, Mar 17, 2021 at 6:02 PM Sameeruddin shaik
<sameeruddin.shaik8@gmail.com> wrote:
>
> This new API will write the function filters into the
> set_ftrace_filter file.
>
> tracefs_function_filter()
>
> https://bugzilla.kernel.org/show_bug.cgi?id=210643
>
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> ---
> Error handling is addressed as per the comments
> if filters[i] is not NULL, then only we are going inside for loop, at the asprintf i think it won't be necessary to check the filters[i] is NULL or not again, when it throws error, if i am wrong please correct me.
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index f3eec62..c1f07b0 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -145,5 +145,6 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
>  int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
>  int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
>  const char *tracefs_option_name(enum tracefs_option_id id);
> -
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
> +                           const char *module, bool reset, const char ***errs);
>  #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index e2dfc7b..ca6077b 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -18,6 +18,7 @@
>  #include "tracefs-local.h"
>
>  #define TRACE_CTRL     "tracing_on"
> +#define TRACE_FILTER   "set_ftrace_filter"
>
>  static const char * const options_map[] = {
>         "unknown",
> @@ -387,3 +388,108 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
>         if (options && id > TRACEFS_OPTION_INVALID)
>                 options->mask &= ~(1ULL << (id - 1));
>  }
> +
> +static int controlled_write(const char *filter_path, const char **filters,
> +                           const char *module, bool reset, const char ***errs)
> +{
> +       int flags = reset ? O_TRUNC : O_APPEND;
> +       const char **e = NULL;
> +       char *each_str = NULL;
> +       int write_size = 0;
> +       int size = 0;
> +       int fd = -1;
> +       int ret = 0;
> +       int j = 0;
> +       int i;
> +
> +       fd = open(filter_path, O_WRONLY | flags);
> +       if (fd < 0)
> +               return 1;
> +
> +       for (i = 0; filters[i]; i++) {
> +               if (module)
> +                       write_size = asprintf(&each_str, "%s:mod:%s ", filters[i], module);
> +               else
> +                       write_size = asprintf(&each_str, "%s ", filters[i]);
> +               if (write_size < 0) {
> +                       ret = 1;
> +                       goto error;
> +               }
> +               size = write(fd, each_str, write_size);
> +               /* compare written bytes*/
> +               if (size < write_size) {
> +                       if (errs) {
> +                               e = realloc(e, (j + 1) * (sizeof(char *)));
> +                               if (!e) {

The commonly used pattern when working with realloc is to use a
temporary pointer for the return value. The problem when using the
same pointer is that in case of a realloc() error, it will return NULL
which will overwrite our original pointer and we will lose it. The old
memory is still valid, realloc() does not free it in case of an error,
but we cannot access it as the old pointer is overwritten with that
NULL. So, I would suggest something like that:
                              e_new = realloc(e, (j + 1) * (sizeof(char *)));
                              if (!e_new) {
                                       free(e);
                                       ret = 1;
                                       goto error;
                               } else
                                     e = e_new;


> +                                       ret = 1;
> +                                       goto error;
> +                               }
> +                               e[j++] = filters[i];
> +                               ret -= 1;
> +                       }
> +               }
> +               free(each_str);
> +               each_str = NULL;
> +       }
> +       if (errs) {
> +               e = realloc(e, (j + 1) * (sizeof(char *)));
> +               if (!e) {
> +                       free(e);

The same comment as above. Here "e" is already NULL. Calling
free(NULL) will not crash, but will not free the old memory.

> +                       ret = 1;
> +                       goto error;
> +               }
> +               e[j] = NULL;
> +               *errs = e;
> +       }
> + error:
> +       if (each_str)
> +               free(each_str);
> +       close(fd);
> +       return ret;
> +}
> +
> +/**
> + * tracefs_function_filter - write to set_ftrace_filter file to trace
> + * particular functions
> + * @instance: ftrace instance, can be NULL for top tracing instance
> + * @filters: An array of function names ending with a NULL pointer
> + * @module: Module to be traced
> + * @reset: set to true to reset the file before applying the filter
> + * @errs: A pointer to array of constant strings that will be allocated
> + * on negative return of this function, pointing to the filters that
> + * failed.May be NULL, in which case this field will be ignored.
> + *
> + * The @filters is an array of strings, where each string will be used
> + * to set a function or functions to be traced.
> + *
> + * If @reset is true, then all functions in the filter are cleared
> + * before adding functions from @filters. Otherwise, the functions set
> + * by @filters will be appended to the filter file
> + *
> + * returns -x on filter errors (where x is number of failed filter
> + * srtings) and if @errs is not NULL will be an allocated string array
> + * pointing to the strings in @filters that failed and must be freed
> + * with free().
> + *
> + * returns 1 on general errors not realted to setting the filter.
> + * @errs is not set even if supplied.
> + *
> + * return 0 on success and @errs is not set.
> + */
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
> +                           const char *module, bool reset, const char ***errs)
> +{
> +       char *ftrace_filter_path;
> +       int ret = 0;
> +
> +       if (!filters)
> +               return 1;
> +
> +       ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
> +       if (!ftrace_filter_path)
> +               return 1;
> +
> +       ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
> +       tracefs_put_tracing_file(ftrace_filter_path);
> +       return ret;
> +}
> --
> 2.7.4
>

Thanks for sending this version, Sameer!
I think we can merge it,  when you fix that realloc() error checking.
I consider this patch as a good foundation for the API, but we should
work on some optimizations on top of it, in separate patches. What
else should be added, when this patch is merged:
 1. A unit test of the API
 2. Man page of the API
 3. Optimizations: new kernels support writing indexes instead of
strings into the "set_ftrace_filter" file. This is faster, as there is
no string comparison in the kernel context. The function index can be
retrieved from "available_filter_functions" files - the first function
is with index 0, the next is 1 ... and so forth. So, the possible
optimization of the API is to check - if the kernel supports indexes,
use it, or fail back to the legacy logic with strings.

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
