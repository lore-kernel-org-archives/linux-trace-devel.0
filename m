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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A91AC433E6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 12:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1FA64F23
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 12:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhCEMU5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 07:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhCEMUc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 07:20:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1A6C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 04:20:32 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bj7so1900892pjb.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Mar 2021 04:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YL1IdFNA8bc+tN5rN1UUItzOd963tYa4hv59vwmgJUU=;
        b=diVvvEWXvb+IK4u/iQaHKPdyBFK7bjy+3ODEBY2vNWqceBTbDnF//0SvYMAJa7koHv
         +6wk5XG2G71nkkvoCy48R8S/u28QXoVJdeNEQACtN3tNeT3xtvdOjo28//TYDXxFhYec
         Hj78WevahPWsTZcoGGUd4joHXfcKUzSlyGPFdHvqYLxXrYCt75NqNMFeIIWygMhJqRwh
         uB7cccv6f0QzyCixmSmvnW+3Z2zuKsLnKgx7Jj1JaItfmVibzBF6sV2IV8JCeFu5rshJ
         chU1c15fr2wP9C63bRmGtjQHJPHqQQT0ApJoLZ3BeUU2MxkZ6/53JuLN2jETWSW1O56Z
         DYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YL1IdFNA8bc+tN5rN1UUItzOd963tYa4hv59vwmgJUU=;
        b=VSZvB8n9KO/Hi58RLYvS9o3PJxGK6neKA67QjiDj8k31bRah7Qoy2wnut07IvIJVR9
         Rmk5awiuHkj10hyR0u+o2jxh4jfqnOf4yn23RWkEkEEKQiMSvdH5Zp/1/AknvKEfw84r
         61voWajI44zuf39OiYODthqa06kHpB3tJeU14MasomIAWF4hCEVgthCvrX0VB3Q4G4aJ
         aAqBBwBLz4fxYrNlNH71R82KQY5+JfnSdnFqhQvpphq3ycXnTyIMD82Kry71MY18xplG
         o4HZ20mpnjya/pyucAn9PmBPDORjGisexpQNxhxOjBFxkTBwz3LZNRpAgQjhAKrGej9X
         5V/Q==
X-Gm-Message-State: AOAM532zZKvrp2c0+T/Bm86uXo1sLiUt0kYSbp/SIWn1GoypCQEupVSL
        Or6ZsVmMUmdsxPA1M958VPTnAH3S4oRJN5uerlM=
X-Google-Smtp-Source: ABdhPJz2eFe5gH2wTGR9LJiNVGY0WCUHSz3BPr4ApmYTISKKLlrPIB+GVw4Dnwrn3TX7guA55ok65bm9d5r/TCXc87w=
X-Received: by 2002:a17:90a:8505:: with SMTP id l5mr9890459pjn.100.1614946832178;
 Fri, 05 Mar 2021 04:20:32 -0800 (PST)
MIME-Version: 1.0
References: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
In-Reply-To: <1615029625-9749-1-git-send-email-sameeruddin.shaik8@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 5 Mar 2021 14:20:15 +0200
Message-ID: <CAPpZLN6A+5pmCnOCJfg-eV1+1UR_MbwgvzhW-bd-ZZJ1F-dC=A@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Sameer,

On Fri, Mar 5, 2021 at 1:21 PM Sameeruddin shaik
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
> index f3eec62..2e5d3e3 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
>  int tracefs_trace_off(struct tracefs_instance *instance);
>  int tracefs_trace_on_fd(int fd);
>  int tracefs_trace_off_fd(int fd);
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char **errs);
>
>  /**
>   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index e2dfc7b..8311191 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -18,6 +18,7 @@
>  #include "tracefs-local.h"
>
>  #define TRACE_CTRL     "tracing_on"
> +#define TRACE_FILTER      "set_ftrace_filter"
>
>  static const char * const options_map[] = {
>         "unknown",
> @@ -387,3 +388,90 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
>         if (options && id > TRACEFS_OPTION_INVALID)
>                 options->mask &= ~(1ULL << (id - 1));
>  }
> +
> +static int controlled_write(const char *filter_path, const char **filters, const char *module, bool reset, const char **errs)
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
> +               return -1;

The error return code should be 1, or the caller of this internal
function should translate this "-1" to the error code according
to the API description.

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
> +                       return -1;

Same here.

> +               if (module)
> +                       write_size = snprintf(each_str, slen, "%s:mod:%s ", filters[i], module);
> +               else
> +                       write_size = snprintf(each_str, slen, "%s ", filters[i]);
> +
> +               size = write(fd, each_str, write_size);
> +               /* compare written bytes and also compare the written bytes with difference of added 5 bytes to string for ":mod:"*/
> +               if ((size < write_size) && (size < (write_size - 5))) {

The second comparison is not needed, the size must be equal to
write_size in case of success.

> +                       errs[j++] = filters[i];

The errs must be (re)allocated here, to hold additional pointer
to string. The user does not know in advance the number of
failed filters and it is not expected to provide an already
allocated array. So it should be a triple pointer.

It is OK to assign directly failed input string to the error array,
but this should be written in the API description, i.e. the user
should not free the strings from the @errs array as it is a subset
of the @filters array, or something like that. But note, the user
still must free the @errs itself.

> +                       ret -= 1;
> +               }
> +               free(each_str);
> +       }
> +       errs[j] = NULL;
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
> + * @errs: An Array of failed function names ending with a NULL pointer
> + *
> + * The @filters is an array of strings, where each string will be used to set
> + * a function or functions to be traced.
> + *
> + * If @reset is true, then all functions in the filter are cleared before
> + * adding functions from @filter. Otherwise, the functions set by @filter
> + * will be appended to the filter file
> + *
> + * The @errs is an array of strings, where each string is a failed function
> + * name
> + *
> + * returns -x (where x is number of failed filter srtings or it can be
> + * 1 for general errors), or 0 if there are no errors.
> + */
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char **errs)
> +{
> +       char *ftrace_filter_path;
> +       int ret = 0;

This should be initialised to the error return code, to ensure that
every "goto out" will return error.

> +
> +       if (!filters)
> +               return -1;

Should return 1, according to the API description.

> +
> +       ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
> +       if (!ftrace_filter_path)
> +               goto out;

"ret" is 0 here, so success will be returned, which is not the desired
behaviour.
"ftrace_filter_path" is NULL and the tracefs_put_tracing_file()
will be called with NULL, but this is OK, should not be a problem.

> +
> +       ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
> + out:
> +       tracefs_put_tracing_file(ftrace_filter_path);
> +       return ret;
> +}
> --
> 2.7.4
>

It is a good starting point, thanks for sending this patch Sameer!

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
