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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CBCC433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 253FC619C8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhC3OaJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhC3O3x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 10:29:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874C3C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 07:29:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f17so6258924plr.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 07:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bXKssKVpDYXYJUc8mkQxaKG2QF5HhMtKKkxaDQm9VnQ=;
        b=bMGveVykKjhgiGOuhm+rR5NbJZ6tG3/GNvY/b0wRpPR4yTsdCuG1MzQyDdysy1p80g
         TVoHkWOcLWrJEw1BYCoyLNhBQcw9parGqTuzbK/XA4VxTW7UpCIwELpzZfFaPdhVAXEy
         W7LjPJpcsgeAKCUKNpE2thMYnfTYcKBUcouZaVYr71sUj/LPqYAxZijBld3jzEIDNKFo
         Wt+edgr6ufYxukIuEx+HXULJgZXqxemmYc9eog1OhNMUNo97gAXyLIqIa4d8Dy5utMWo
         evIPdbof91SIHrUrfrrGMbdwv38pwvQcT3xMWyMlQOUhXidC6zJEfzCgEAVk8KbvBjUe
         tuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bXKssKVpDYXYJUc8mkQxaKG2QF5HhMtKKkxaDQm9VnQ=;
        b=AIa4mRNh99RBai89WjBDGa9aplH0S4j8/kafusfOjYXoyH0UXc2Ttbod2IQB775/Gw
         nrSK1s9yBO2EiutjYm8fyR5eH37c56Ym6V6BTruBPe6vYRFb3mr2SFL+7xD6ou7imegv
         xmiyc5+2BQIdPeo2hpMVUOaYciKQX82BaUsds5fiD880egi5wt7iE/Tp9xU89h+PDilS
         Q9JWUBlxE6BlSiAIp9qt4qpzUNylN6NfQU/mv8sSjJRqiFQlwms1Znl+7D5XSJIsyoT7
         ikXudVKI0WYh+D//uYeK/7XJfWrb4Lcnj6AOlLBCV8/ZQ5BON5sxxMVBi4J/8hQtzF8U
         q2FQ==
X-Gm-Message-State: AOAM531XuFY7eTH9X8l6cJqZ7BCzdiYlMWxnA8wgEAX0q7Cc3ekt+7kJ
        DhL3nneW/izTyacqWw0SCbxNvzHlJ3Kuzv5UryeTws6pG/o=
X-Google-Smtp-Source: ABdhPJy2gB3Ci4hvrhDzrltt2Q3j4sE9DvAHMbDuifOx+DL01Jd4Wi3qXU+omZjwNdTYUjd+nm5+WGC3RsRkFUnc954=
X-Received: by 2002:a17:902:7b84:b029:e6:ec5a:3097 with SMTP id
 w4-20020a1709027b84b02900e6ec5a3097mr33178666pll.58.1617114593012; Tue, 30
 Mar 2021 07:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210330005123.151740983@goodmis.org> <20210330005248.694899644@goodmis.org>
In-Reply-To: <20210330005248.694899644@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 30 Mar 2021 17:29:35 +0300
Message-ID: <CAPpZLN764QK2eZy=D+w8BqC_BDAiYpas53Ef4w5ySBECHkZiFA@mail.gmail.com>
Subject: Re: [PATCH 10/13 v2] libtracefs: Pass in reset via flags to tracefs_function_filter()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 30, 2021 at 3:54 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> Instead of having a separate boolean to tell tracefs_function_filter() to
> reset the file upon opening, make it a flag instead. This way other
> booleans can be passed into the function without having to extend the
> parameters.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  Documentation/libtracefs-function-filter.txt | 26 ++++++++++++++------
>  include/tracefs.h                            | 10 +++++++-
>  src/tracefs-tools.c                          | 19 ++++++++------
>  3 files changed, 38 insertions(+), 17 deletions(-)
>
> diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
> index 88aa3b923d54..5b55a72727c8 100644
> --- a/Documentation/libtracefs-function-filter.txt
> +++ b/Documentation/libtracefs-function-filter.txt
> @@ -11,7 +11,7 @@ SYNOPSIS
>  --
>  *#include <tracefs.h>*
>
> -int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]pass:[*]_filters_, const char pass:[*]_module_, bool _reset_, const char pass:[*]pass:[*]pass:[*]_errs_);
> +int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]pass:[*]_filters_, const char pass:[*]_module_, int _flags_, const char pass:[*]pass:[*]pass:[*]_errs_);
>  --
>
>  DESCRIPTION
> @@ -25,18 +25,17 @@ _filters_, which is an array of the strings that represent a list of filters tha
>  be applied to define what functions are to be traced and The array must end
>  with a NULL pointer.
>  _module_ , name of the module to be traced (or NULL for all functions),
> -_reset_ if set will clear the current set of filters and then apply the
> -filter list, otherwise the list of filters are added to the current set of
> -filters,
> +_flags_ which holds control knobs on how the filters will be handled (see *FLAGS*)
> +section below,
>  _errs_, is a pointer to an array of strings, which will be allocated if
>  any of filters fail to match any available function, If _errs_ is NULL, it will
>  be ignored.
>
>  A filter in the array of _filters_ may be either a straight match of a
> -function, a glob or regex(3). a glob is where '*' matches zero or more
> +function, a glob or regex(3). a glob is where 'pass:[*]' matches zero or more
>  characters, '?' will match zero or one character, and '.' only matches a
>  period. If the filter is determined to be a regex (where it contains
> -anything other than alpha numeric characters, or '.', '*', '?') the filter
> +anything other than alpha numeric characters, or '.', 'pass:[*]', '?') the filter
>  will be processed as a regex(3) following the rules of regex(3), and '.' is
>  not a period, but will match any one character. To force a regular
>  expression, either prefix the filter with a '^' or append it with a '$' as
> @@ -44,6 +43,17 @@ all filters will act as complete matches of functions anyway.
>
>  returns 0  on success, 1 or -x (where x is an integer) on error.
>
> +FLAGS
> +-----
> +
> +The _flags_ parameter may have the following set, or be zero.
> +
> +*TRACEFS_FL_RESET* :
> +If _flags_ contains *TRACEFS_FL_RESET*, then it will clear the filters that
> +are currently set before applying the list of filters from _filters_. Otherwise,
> +the list of filters from _filters_ will be added to the current set of filters
> +already enabled.
> +
>  RETURN VALUE
>  ------------
>  return 0 on success, if there is error, it will return 1 for general errors or
> @@ -66,7 +76,7 @@ int main(int argc, char *argv[])
>  {
>         struct tracefs_instance *inst = tracefs_instance_create(INST);
>         const char **errs = NULL;
> -       bool reset = 1;
> +       int flags = TRACEFS_FL_RESET;
>         int ret;
>         int i = 0;
>
> @@ -74,7 +84,7 @@ int main(int argc, char *argv[])
>                 /* Error creating new trace instance */
>         }
>
> -       ret = tracefs_function_filter(inst, filters, NULL, reset, &errs);
> +       ret = tracefs_function_filter(inst, filters, NULL, flags, &errs);
>
>         if (ret < 0 && errs) {
>                 while (errs[i])
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 9477fdb14c5a..5193d46f41f5 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -145,6 +145,14 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
>  int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
>  int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
>  const char *tracefs_option_name(enum tracefs_option_id id);
> +
> +/*
> + * RESET       - Reset on opening filter file (O_TRUNC)
> + */
> +enum {
> +       TRACEFS_FL_RESET        = (1 << 0),
> +};
> +
>  int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
> -                           const char *module, bool reset, const char ***errs);
> +                           const char *module, unsigned int flags, const char ***errs);
>  #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 8f2130948fe0..6d03b4856a63 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -835,7 +835,7 @@ static int write_func_list(int fd, struct func_list *list)
>   * @instance: ftrace instance, can be NULL for top tracing instance
>   * @filters: An array of function names ending with a NULL pointer
>   * @module: Module to be traced
> - * @reset: set to true to reset the file before applying the filter
> + * @flags: flags on modifying the filter file
>   * @errs: A pointer to array of constant strings that will be allocated
>   * on negative return of this function, pointing to the filters that
>   * failed.May be NULL, in which case this field will be ignored.
> @@ -843,9 +843,11 @@ static int write_func_list(int fd, struct func_list *list)
>   * The @filters is an array of strings, where each string will be used
>   * to set a function or functions to be traced.
>   *
> - * If @reset is true, then all functions in the filter are cleared
> - * before adding functions from @filters. Otherwise, the functions set
> - * by @filters will be appended to the filter file
> + * @flags:
> + *   TRACEFS_FL_RESET - will clear the functions in the filter file
> + *          before applying the @filters. This flag is ignored
> + *          if this function is called again when the previous
> + *          call had TRACEFS_FL_CONTINUE set.
>   *
>   * returns -x on filter errors (where x is number of failed filter
>   * srtings) and if @errs is not NULL will be an allocated string array
> @@ -858,12 +860,13 @@ static int write_func_list(int fd, struct func_list *list)
>   * return 0 on success and @errs is not set.
>   */
>  int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
> -                           const char *module, bool reset, const char ***errs)
> +                           const char *module, unsigned int flags, const char ***errs)
>  {
>         struct func_filter *func_filters;
>         struct func_list *func_list = NULL;
>         char *ftrace_filter_path;
> -       int flags;
> +       bool reset = flags & TRACEFS_FL_RESET;
> +       int open_flags;
>         int ret;
>         int fd;
>
> @@ -887,9 +890,9 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
>         if (!ftrace_filter_path)
>                 goto out_free;
>
> -       flags = reset ? O_TRUNC : O_APPEND;
> +       open_flags = reset ? O_TRUNC : O_APPEND;
>
> -       fd = open(ftrace_filter_path, O_WRONLY | flags);
> +       fd = open(ftrace_filter_path, O_WRONLY | open_flags);
>         tracefs_put_tracing_file(ftrace_filter_path);
>         if (fd < 0)
>                 goto out_free;
> --
> 2.30.1
>
>

It will be useful to allow calling the API with RESET flag set and no
filters, just to reset the current filters without adding new:
   tracefs_function_filter(NULL, NULL, NULL,TRACEFS_FL_RESET, NULL);
could be a valid call to reset filters in the top trace instance.



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
