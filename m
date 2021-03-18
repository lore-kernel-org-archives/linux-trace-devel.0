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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED2CC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 17:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6730464EF2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 17:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCRRWw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 13:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhCRRWn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 13:22:43 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDF2C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Mar 2021 10:22:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e14so1639071plj.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Mar 2021 10:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YpYp4i0fCFWxwg0DKngp4cAngxq1SJti8wiqBKnLD4A=;
        b=thYPFGJNPy8Jtg1CI2bm8JPahwKgYa6DGzxw103/+ajgUB65UvJ8280nsFG8k0d3ng
         CztFEYJIwVvtNDHjawx2RroRHE1f5Xr59dXCTlY23sjh6hRXP1fXaxuPEPyc+vLyXJIZ
         nmA0LDiuwkZjMXqziJuKuqxE6IY9AJgSphhnnLxWayzHyi7oYDthLarfWOgwm3vNKibZ
         LlFX4rQH2Ld46GqN7cUWjKP3f0uAqmu2Gr8uI2OsykJAqrWU3RRI2uwntqSXukPJbS4D
         8JSdn2SKDcnBCeZwAtRUiHJmIDC9W/Yf+68m/fi4VGZIfnB2HGX2VPMjpI4Fkn/ymtUh
         EEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YpYp4i0fCFWxwg0DKngp4cAngxq1SJti8wiqBKnLD4A=;
        b=UEUATjbDyrS5feRW5zR1ChWiUABD/Jnxkfm73jOqVVCp1W/HrE3OcPDFOYdIMj1cqc
         P7De1Di6b1TN7aQsXMEqY6sZoZFFvbJ1CO2tjd9GuThual2/tyPQTKKa1FnbGh4mcYXk
         +hMrbq8WospEVZEaAW/GP/4j8En+apuECIvL38w2EYqBJjP0kERpSYvuJX2brnN+BxQd
         kgCfCUbJ50Kpdip3R4VWOHgF0sDErZ4VtJgEy4D2fUAmZ9/Cq7UZ+x9vzBNhazguNlPn
         lH7AhMvDwFJuEs1VXWWH6GKli1Q52mBmmjWtGXa+QLRhseiM40k9h3F4shtpaabURpT9
         lMzQ==
X-Gm-Message-State: AOAM532E0NPyhhGUyFSKsWZeC7htMlYbkAFpzxVQ7WXWsP222HQeh2lY
        ss+jkV1pkEJvVGLVHdMX1PdfHOU3hsikfkiWMjleGHa+tGk=
X-Google-Smtp-Source: ABdhPJzVGnYKD2GGd25BtiYW/NjEelhSvwgrqBRfa7BVvBQS4JrW3a716Rx+9lu2d6XW5CUVz6weu1f6aVZ0buR3r3E=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr5561659pjb.2.1616088162962;
 Thu, 18 Mar 2021 10:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <1616171938-18914-1-git-send-email-sameeruddin.shaik8@gmail.com>
In-Reply-To: <1616171938-18914-1-git-send-email-sameeruddin.shaik8@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Mar 2021 19:22:26 +0200
Message-ID: <CAPpZLN5SSxa2ZwnE1G3iuk2uuvm0JaP_N92esJKqL=zSDwCruQ@mail.gmail.com>
Subject: Re: [PATCH v3] libtracefs: An API to set the filtering of functions
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 18, 2021 at 6:38 PM Sameeruddin shaik
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
> Addressed the realloc comments
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
> index e2dfc7b..4f8bcdc 100644
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
> @@ -387,3 +388,113 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
>         if (options && id > TRACEFS_OPTION_INVALID)
>                 options->mask &= ~(1ULL << (id - 1));
>  }
> +
> +static int controlled_write(const char *filter_path, const char **filters,
> +                           const char *module, bool reset, const char ***errs)
> +{
> +       int flags = reset ? O_TRUNC : O_APPEND;
> +       const char **temp = NULL;
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
> +                               temp = realloc(e, (j + 1) * (sizeof(char *)));
> +                               if (!temp) {
> +                                       free(e);
> +                                       ret = 1;
> +                                       goto error;
> +                               } else
> +                                       e = temp;
> +
> +                               e[j++] = filters[i];
> +                               ret -= 1;
> +                       }
> +               }
> +               free(each_str);
> +               each_str = NULL;
> +       }
> +       if (errs) {
> +               temp = realloc(e, (j + 1) * (sizeof(char *)));
> +               if (!temp) {
> +                       free(e);
> +                       ret = 1;
> +                       goto error;
> +               } else
> +                       e = temp;
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

Looks good to me.
Thanks Sameer!
Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
