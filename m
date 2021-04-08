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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C66C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 763E1611C2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhDHEZs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 00:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDHEZs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 00:25:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01821C061760
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 21:25:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id i4so447944pjk.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Apr 2021 21:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cU7Cf5AFEmNITpOS0tu3vdkROCq0COleNod9yaPuBy8=;
        b=ta5418ysJbyiSuc56k2mlco6Yc4ZtWdcgSnMu4L/84rYC/PrC+pqRpqEzYubp2LhJd
         4OcXpomF2Exnoa9ALjJXnE+NRZBVDk40wGnm81LLThApUTI1z5yJvDLSyQK9I5DjMWCj
         31I0XkNTQYiSaBuQH5+UQ0qeEZnfNgn/nsz1vC4DWvW2mxghMAzteFjh+z2ylbCbZxs/
         APMIuEArmjq0GyfS6o9VF+bIipRB+749CxGKX2W98SZNKSSQip0C8DGE5ZgrZohJN7F3
         +pvsGmsjwOIWqSQM0FkJpijX6VA64zUkYqQBWEwRswqEE6mczocccIq+2LCknI5dqdIC
         q33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cU7Cf5AFEmNITpOS0tu3vdkROCq0COleNod9yaPuBy8=;
        b=jhgpS6urNGLC3s/xjV+s1mAlSOYTdwT5+TlALFV+tepo37VlGHSA2gsaA3d3NRiA+A
         JhGPZlicvfpPQvyqSfIZSTdwori250IW7X66inDFgRBtPYv4YFzUnCE6qR7kikJP19U3
         elT3mEf/rNRHc7ATLAkeoPZzi2wvNUn9YdoYrpsB4c+xm7M2wSyub1ue5L7DchF3i5vd
         JV1R602KIpjufoPk+tx2L1N1xsaidq4+gcMCMFA0JJqeegEsssuEvQCyHiUhKs9Nnk+e
         UUurxKt8t5LIHtGOiJMWjABViZgCfqdGGLFCDqWXQvLsWjO/tmPSyqcMijz0P09cPgek
         zvDQ==
X-Gm-Message-State: AOAM531Ow++Bcj1MTPTPfmMppkzBON7bpiImupysSEHZ5OGIMKX915Rf
        TQ7N0jZD1wHdE8TBGiXxTW7RV1XH0LBf6MCKEQk=
X-Google-Smtp-Source: ABdhPJxEE7Uq+0BGCJqSP/3pr5QMFmxiLDUHxEJhkD9Yk2Loj7g5lTuBENoj5uTSTM1ptop0cBUmZ1PMCptqtDWt7F4=
X-Received: by 2002:a17:902:bd08:b029:e9:4227:427e with SMTP id
 p8-20020a170902bd08b02900e94227427emr5949368pls.58.1617855937370; Wed, 07 Apr
 2021 21:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210407202126.1870994-1-rostedt@goodmis.org> <20210407202126.1870994-3-rostedt@goodmis.org>
In-Reply-To: <20210407202126.1870994-3-rostedt@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 8 Apr 2021 07:25:20 +0300
Message-ID: <CAPpZLN5Lmc6QegJrLLzXsbu-bDtAVovnSF+=NZpr8E53K-JLYQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] libtracefs: Add tracefs_function_notrace() API
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 8, 2021 at 1:02 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> Add the API of tracefs_function_notrace() that is identical to how
> tracefs_function_filter() works, but will work with the set_ftrace_notrace
> filter file.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  Documentation/libtracefs-function-filter.txt | 19 ++++++++---
>  include/tracefs-local.h                      |  1 +
>  include/tracefs.h                            |  3 ++
>  src/tracefs-instance.c                       |  1 +
>  src/tracefs-tools.c                          | 33 ++++++++++++++++++++
>  5 files changed, 53 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
> index ccf20e9..746be37 100644
> --- a/Documentation/libtracefs-function-filter.txt
> +++ b/Documentation/libtracefs-function-filter.txt
> @@ -4,6 +4,7 @@ libtracefs(3)
>  NAME
>  ----
>  tracefs_function_filter - Function to limit kernel functions that are traced
> +tracefs_function_notrace - Function to filter kernel functions that not to be traced
>
>  SYNOPSIS
>  --------
> @@ -12,15 +13,18 @@ SYNOPSIS
>  *#include <tracefs.h>*
>
>  int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
> +int *tracefs_function_notrace*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
>  --
>
>  DESCRIPTION
>  -----------
> -This function can be used to limit the Linux kernel functions that would be
> -traced by the function and function-graph tracers
> +*tracefs_function_filter* and *tracefs_function_notrace* can be used to limit the
> +Linux kernel functions that would be traced by the function and function-graph tracers.
> +The *tracefs_function_filter* defines a list of functions that can be traced.
> +The *tracefs_function_notrace* defines a list of functions that will not be traced.
> +If a function is in both lists, it will not be traced.
>
> -It will take an
> -_instance_ , that can be NULL for the top level tracing,
> +They take an _instance_ , that can be NULL for the top level tracing,
>  _filter_, a string that represents a filter that should
>  be applied to define what functions are to be traced,
>  _module_, to limit the filtering on a specific module (or NULL to filter on all functions),
> @@ -125,6 +129,13 @@ int main(int argc, char *argv[])
>                 /* Error creating new trace instance */
>         }
>
> +       /* Do not trace any function with the word "lock" in it */
> +       ret = tracefs_function_notrace(inst, "*lock*", NULL, TRACEFS_FL_RESET);
> +       if (ret) {
> +               printf("Failed to set the notrace filter\n");
> +               goto out;
> +       }
> +
>         /* First reset the filter */
>         ret = tracefs_function_filter(inst, NULL, NULL,
>                                       TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 73ec113..060de7e 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -19,6 +19,7 @@ struct tracefs_instance {
>         char    *name;
>         int     flags;
>         int     ftrace_filter_fd;
> +       int     ftrace_notrace_fd;
>  };
>
>  /* Can be overridden */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index befcc48..70b7ebe 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -160,4 +160,7 @@ enum {
>
>  int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
>                             const char *module, unsigned int flags);
> +int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
> +                            const char *module, unsigned int flags);
> +
>  #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index bf2fabf..9f45624 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -44,6 +44,7 @@ static struct tracefs_instance *instance_alloc(const char *trace_dir, const char
>         }
>
>         instance->ftrace_filter_fd = -1;
> +       instance->ftrace_notrace_fd = -1;

These descriptors should be closed in tracefs_instance_free(), as part
of the instance cleanup.

>
>         return instance;
>
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 21a9bd3..b41806b 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -21,10 +21,12 @@
>
>  #define TRACE_CTRL             "tracing_on"
>  #define TRACE_FILTER           "set_ftrace_filter"
> +#define TRACE_NOTRACE          "set_ftrace_notrace"
>  #define TRACE_FILTER_LIST      "available_filter_functions"
>
>  /* File descriptor for Top level set_ftrace_filter  */
>  static int ftrace_filter_fd = -1;
> +static int ftrace_notrace_fd = -1;
>  static pthread_mutex_t filter_lock = PTHREAD_MUTEX_INITIALIZER;

I'm wondering if we should free these global resources somehow. A
cleanup API for the whole library can be implemented  using
__attribute__((destructor)), or some other way ?

>
>  static const char * const options_map[] = {
> @@ -898,3 +900,34 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
>         tracefs_put_tracing_file(filter_path);
>         return ret;
>  }
> +
> +/**
> + * tracefs_function_notrace - filter the functions that are not to be traced
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + * @filter: The filter to filter what functions are not to be traced
> + * @module: Module to be traced or NULL if all functions are to be examined.
> + * @flags: flags on modifying the filter file
> + *
> + * See tracefs_function_filter, as this has the same functionality but
> + * for adding to the "notrace" filter.
> + */
> +int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
> +                            const char *module, unsigned int flags)
> +{
> +       char *filter_path;
> +       int *fd;
> +       int ret;
> +
> +       filter_path = tracefs_instance_get_file(instance, TRACE_NOTRACE);
> +       if (!filter_path)
> +               return -1;
> +
> +       if (instance)
> +               fd = &instance->ftrace_notrace_fd;
> +       else
> +               fd = &ftrace_notrace_fd;
> +
> +       ret = update_filter(filter_path, fd, instance, filter, module, flags);
> +       tracefs_put_tracing_file(filter_path);
> +       return ret;
> +}
> --
> 2.29.2
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
