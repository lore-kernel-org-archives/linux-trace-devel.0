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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3521C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 05:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 707A464FE7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 05:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCJF2z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 00:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhCJF23 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 00:28:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2E0C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Mar 2021 21:28:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id j14-20020a17090a588eb02900cefe2daa2cso1447016pji.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Mar 2021 21:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+6UeeNL/RmEvqGowCEnxHWBKW5zWiVqvt3tmTNACmd0=;
        b=kH8Qrwls3DgHUTsaiFoJxwqlFSbycG6q9UpGUCRS6PeZgaUYRuYEauiVPgD6Z8AqjD
         UvUcb6MasCEKh+u6W8CMXf1BClBwawYhEDgj6sLHabJE623WoVUubkBx4BZdhiuHxWga
         SxW2pQmC3Jx79a+lC+iTtG5eY6HHzwNbK9/ocaDw5PX+GkPHy/94bDx3nSR/g2EuCw51
         oXp7Cr+t2zUbhLo0pmsAkBHUTyMqglYZIFFrk5AMcjDL8W+rrdPv31wgi1rkTqymOA7R
         QIcK6Cqtv/O3eUyXpdS3g0Rl7CGrhq1xbmWHg9J7S+6urz40bTUfY8u63r8DU3IxIQT6
         Pcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+6UeeNL/RmEvqGowCEnxHWBKW5zWiVqvt3tmTNACmd0=;
        b=p9IA1WMrp58ULTRUV5nETjqaz1sbZaq1/QCIFfZNXrZ5wyEdDjFVoIOsGa8gwafElp
         QnHROa481XIrvnbwnDW9mh5ME6X9FjKvIOpVgvi1SPopElTYi4vLUe8OrtmUKpxdruWZ
         SPHqZTkIPpdOkPBFlJ10jiYdsYvcdRQ2xJqm+Zd3oYpom5P3Jg1Pbl1kN1WdbDKr/dm8
         Pu27BWTb1gS69AFRIIOtx8OdY8Eid4oRc9nDmsd7zUomqP5khiUBW7FRzPc5B4AW7+97
         qWt73smKrv51kuzbvMr+UpPuFXvU14rt3p0hiuiD5ZtuJoLavpYiXsg5gUXPKctnwaN9
         ownA==
X-Gm-Message-State: AOAM532nZfAgT9v2yJldZTUKNPd7UfRO7cnjpVE+rC+VbmINzgCdOBfO
        wPxbj9A6Mcwpn2QkRabgnAIyawD7iZCf15xl/FE=
X-Google-Smtp-Source: ABdhPJxrJD1SWZ4a5lVZR/5Q9/K5GPkUF8ZYyrqfnJS3NexGUHx64Bo5EDAvDwMFd2gWogMMNN0Ji41nBoIwEBEeU6E=
X-Received: by 2002:a17:902:bd8d:b029:e6:5398:609f with SMTP id
 q13-20020a170902bd8db02900e65398609fmr1489493pls.58.1615354108956; Tue, 09
 Mar 2021 21:28:28 -0800 (PST)
MIME-Version: 1.0
References: <1615393287-12344-1-git-send-email-sameeruddin.shaik8@gmail.com>
In-Reply-To: <1615393287-12344-1-git-send-email-sameeruddin.shaik8@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 10 Mar 2021 07:28:12 +0200
Message-ID: <CAPpZLN5kz=FKfT=+=X_zNjEG46+bQTy=h2kbUAnTCCoghp2Pyw@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Sameer,

On Tue, Mar 9, 2021 at 6:24 PM Sameeruddin shaik
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
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index f3eec62..a2249d0 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
>  int tracefs_trace_off(struct tracefs_instance *instance);
>  int tracefs_trace_on_fd(int fd);
>  int tracefs_trace_off_fd(int fd);
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);

I would break that in two lines, try to keep the lines up to 100
characters, when possible. It is very subjective to find the
balance between that 70-100 char limit and readable code.
There could be exceptions, but in this case I think it is better
to split it in two lines:

int tracefs_function_filter(struct tracefs_instance *instance, const
char **filters,
                                        const char *module, bool
reset, const char ***errs);

Note the second line - you should use tabs and spaces to align the  arguments
on the second line with the arguments on the first line. I cannot put
tabs in this
reply because of the strange limitations of my mail client, but in the
code - use
tabs (set to 8 spaces each) + spaces, if needed, to align it.

>
>  /**
>   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index e2dfc7b..4e168df 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -18,6 +18,7 @@
>  #include "tracefs-local.h"
>
>  #define TRACE_CTRL     "tracing_on"
> +#define TRACE_FILTER      "set_ftrace_filter"

Use tabs instead of spaces to align the string with the previous define.

>
>  static const char * const options_map[] = {
>         "unknown",
> @@ -387,3 +388,96 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
>         if (options && id > TRACEFS_OPTION_INVALID)
>                 options->mask &= ~(1ULL << (id - 1));
>  }
> +
> +static int controlled_write(const char *filter_path, const char **filters, const char *module, bool reset, const char ***errs)

I would split that in two lines, aligning the arguments on both lines - see
the comment above.

> +{
> +       int flags = reset ? O_TRUNC : O_APPEND;
> +       int write_size;
> +       char *each_str;
> +       int ret = 0;
> +       int j = 0;
> +       int size;
> +       int slen;
> +       int fd;
> +       int i;
> +
> +       fd = open(filter_path, O_WRONLY | flags);
> +       if (fd < 0)
> +               return 1;
> +
> +       for (i = 0; filters[i]; i++) {
> +               slen = strlen(filters[i]);
> +               if (!slen)
> +                       continue;
> +
> +               if (module)
> +                       /* Adding 5 extra bytes for ":mod:"*/
> +                       slen += strlen(module) + 5;
> +
> +               /* Adding 2 extra byte for the space and '\0' at the end*/
> +               slen += 2;
> +               each_str = calloc(1, slen);
> +               if (!each_str)
> +                       return 1;

This return will leak the opened fd. It is better to have a "goto error"
label and to clean all allocated resources in case of an error return.
I would suggest to initialize all resources that are allocated internally
with some default values (i.e. fd with -1, each_str with NULL) and
in this "error clean up logic" to free them, if they are allocated.

> +               if (module)
> +                       write_size = snprintf(each_str, slen, "%s:mod:%s ", filters[i], module);
> +               else
> +                       write_size = snprintf(each_str, slen, "%s ", filters[i]);

You could use asprintf() instead of snprintf(), it will take care of the string
allocation and size instead of you, and will simplify the code. But note
that asprintf() has different behaviour in case of an error, it will not set
each_str to NULL. Take this into account in your logic.

> +
> +               size = write(fd, each_str, write_size);
> +               /* compare written bytes*/
> +               if (size < write_size) {
> +                       if (errs) {
> +                               errs[j++] = &filters[i];

The errs must be reallocated here, I'll comment that on
your second email. Without realloc, it will cause a seg fault.

> +                               ret -= 1;
> +                       }
> +               }
> +               free(each_str);
> +       }
> +       errs[j] = NULL;

errs is an optional argument, it could be NULL - check it
before writing to it. Also, errs is a triple pointer:

if (errs)
    (*errs)[j] = NULL;

> +       close(fd);
> +       return ret;
> +}
> +
> +/**
> + * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
> + * @instance: ftrace instance, can be NULL for top tracing instance
> + * @filters: An array of function names ending with a NULL pointer
> + * @module: Module to be traced
> + * @reset: set to true to reset the file before applying the filter
> + * @errs: A pointer to array of constant strings that will be allocated
> + * on negative return of this function, pointing to the filters that failed.
> + * May be NULL, in which case this field will be ignored.
> + *
> + * The @filters is an array of strings, where each string will be used to set
> + * a function or functions to be traced.
> + *
> + * If @reset is true, then all functions in the filter are cleared before
> + * adding functions from @filters. Otherwise, the functions set by @filters
> + * will be appended to the filter file
> + *
> + * returns -x on filter errors (where x is number of failed filter srtings)
> + * and if @errs is not NULL will be an allocated string array pointing to the
> + * strings in @filters that failed and must be freed with free().
> + *
> + * returns 1 on general errors not realted to setting the filter.
> + * @errs is not set even if supplied.
> + *
> + * return 0 on success and @errs is not set.
> + */
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs)

This also should be splitted in two lines.

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

Thanks for sending the next version, Sameer!

One hint when sending the next versions of the same patch:
use the "-v" option of the "git format-patch" command, that helps
to track the patch history. Also, it is useful to write the changes of
each version of the patch. In case of a patch set - the version changes
should be in the cover letter. In your case, as it is a single patch and
there is no need of a cover letter - add the version changes before
sending the patch just after the "---" line, manually. That way this
will not be part of the patch description, but still will be part of the
patch.

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
