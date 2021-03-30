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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A5EC433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BB94619C8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhC3Oal (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhC3OaO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 10:30:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67953C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 07:30:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id w8so7838371pjf.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 07:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j+ELIir9qnPGBGOfKErGmMACLPMjLuQcq7lTTMcy710=;
        b=UCSBSzCYc8bd+1vVNIdaC8zaf1vwOQ+6xEMgPdf56xAYAqjxwDezb/1OpvyNOq6X13
         uBJGMYLyJgmKgKKNdoZfiz6ELomPyy4LyA5v4i0tfmbd0DG/khpm7LHf5su4lHQROcS5
         GBlfoXvPKCX7CJMCjSGQOk3e+eRefaIvWX5pdzcpFaDTMtzfNrww3u7sZVh/lgs8jve8
         YEB++C7nLZeY9qfkNFMzBXIw9SQ9HHkGRTshgRmj3FdwJ2ZIhRMqknjMl5GOiXtV+6OW
         r5oBGhBj0AQ7X2azJtQZag0qjr90zelj55xeM1F1q/BdCNOoJkZKqBOQrKEivygQSmeo
         I7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j+ELIir9qnPGBGOfKErGmMACLPMjLuQcq7lTTMcy710=;
        b=iQN08Fi40q7U3omHvHHZkAV6YZkxqcWeTB7VfOTOLCSrBZS7QC1umt27nRjf/89o9M
         YcGa55nDJxiVImgj+MJPLFS0RIrCTBnCI6V1fjQJkadNzEK2bltgri2dN4QamyzW3UAX
         98Oh/Mul5FwRyKikXEgsbF3y2iuz1tgR2+0487RKq3FAoUHfCKWTyvSAkcQsPLMQkOk9
         MBbcUcjIui6zV/JoX1lNsNqTYRRSOsc+gvhqAPk+l6lFU1JvdICDknFUC+AoMMsSceIp
         l/Fp70+wsU26JJGNQObJsIojgeSqSQftPRqxwIJqZ/gcv9hkD2L/BQ7vCYPaoLKz1It+
         RvcQ==
X-Gm-Message-State: AOAM533+NPIy8jd5p2Ph6Tca37GlY8EfpLcGM0C0bGKwHepYrOQ9/QmI
        3xm7btiamUTdjBgqz7XPpUaEIORs/Wkhws0APvkKjMvve4E=
X-Google-Smtp-Source: ABdhPJyocQR6kUYLTCRuXo1sX+MQAu72N91RAicTAPf67UjJdhG/RkH6Z2LnDnX435/SroXAwnkiwosk1pO9u1z2UnA=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr4708411pjb.2.1617114613953;
 Tue, 30 Mar 2021 07:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210330005123.151740983@goodmis.org> <20210330005249.118764252@goodmis.org>
In-Reply-To: <20210330005249.118764252@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 30 Mar 2021 17:29:57 +0300
Message-ID: <CAPpZLN57JrvSNTCGJTe7A9_x9Z4rSsH54jQu5C8wqodii=np4w@mail.gmail.com>
Subject: Re: [PATCH 13/13 v2] libtracefs: Add CONTINUE to tracefs_function_filter()
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
> Add the TRACEFS_FL_CONTINUE flag to the tracefs_function_filter() API that
> will allow it to return without closing the set_ftrace_filter file. When
> the set_ftrace_filter file is closed, all the changes to it take place,
> but not before hand. In the case that multiple modules need to be set in
> one activation, the tracefs_function_filter() would need to be called
> multiple times without closing the file descriptor.
>
> Note, the next call to tracefs_function_filter() after it was called with
> the CONTINUE flag set, the RESET flag is ignored, as the RESET flag only
> takes effect on opening the file. The next call to
> tracefs_function_filter() after it was called with the CONTINUE flag (on
> the same instance) does not reopen the file, and thus will not reset the
> file.

I think it is better to not maintain a state in the API context. Let's
make it simple and allow the user to take care of the calling order
and flags.
   If RESET is set - close the file (if it is opened already) and open
it with the TRUNC flag.
   If CONTINUE is set - do not close the file.
Also, allow calling the API with no filters and any combination of
flags, just to have resting and committing currently written filters.
For example:
 tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_RESET, NULL); //
Close the file (if it is opened already), open it with the TRUNC flag
and close it.
 tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_CONTINUE, NULL);
//  Open the file with APPEND (if it is not opened already) and do not
close it.
 tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_RESET |
TRACEFS_FL_CONTINUE, NULL);  // Close the file (if it is opened
already), open it with the TRUNC flag and do not close it.


>
> If the file is opened, calling tracefs_function_filter() with no filters
> and the continue flag not set, will simply close the set_ftrace_filter
> file.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  Documentation/libtracefs-function-filter.txt | 32 +++++++++++++---
>  include/tracefs-local.h                      |  1 +
>  include/tracefs.h                            |  2 +
>  src/tracefs-instance.c                       |  2 +
>  src/tracefs-tools.c                          | 39 ++++++++++++++++----
>  5 files changed, 64 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
> index 5b55a72727c8..1ac8a06961bf 100644
> --- a/Documentation/libtracefs-function-filter.txt
> +++ b/Documentation/libtracefs-function-filter.txt
> @@ -52,7 +52,20 @@ The _flags_ parameter may have the following set, or be zero.
>  If _flags_ contains *TRACEFS_FL_RESET*, then it will clear the filters that
>  are currently set before applying the list of filters from _filters_. Otherwise,
>  the list of filters from _filters_ will be added to the current set of filters
> -already enabled.
> +already enabled. This flag is ignored if a previous call to
> +tracefs_function_filter() had the same _instance_ and the
> +*TRACEFS_FL_CONTINUE* flag was set.
> +
> +*TRACEFS_FL_CONTINUE* :
> +If _flags_ contains *TRACEFS_FL_CONTINUE*, then the filters will not take
> +effect after a successful call to tracefs_function_filter(). This allows for
> +multiple calls to tracefs_function_filter() to update the filter function.
> +It can be called multiple times and add more filters. A call without this
> +flag set will commit the changes before returning (if the filters passed in
> +successfully matched). A tracefs_function_filter() call after one that had
> +the *TRACEFS_FL_CONTINUE* flag set for the same instance will ignore the
> +*TRACEFS_FL_RESET* flag, as the reset flag is only applicable for the first
> +filters to be added before committing.
>
>  RETURN VALUE
>  ------------
> @@ -70,13 +83,13 @@ EXAMPLE
>
>  #define INST "dummy"
>
> -const char *filters[] = { "run_init_process", "try_to_run_init_process", "dummy1", NULL };
> +static const char *filters[] = { "run_init_process", "try_to_run_init_process", "dummy1", NULL };
> +static const char *all[] = { "*", NULL };
>
>  int main(int argc, char *argv[])
>  {
>         struct tracefs_instance *inst = tracefs_instance_create(INST);
>         const char **errs = NULL;
> -       int flags = TRACEFS_FL_RESET;
>         int ret;
>         int i = 0;
>
> @@ -84,15 +97,24 @@ int main(int argc, char *argv[])
>                 /* Error creating new trace instance */
>         }
>
> -       ret = tracefs_function_filter(inst, filters, NULL, flags, &errs);
> +       ret = tracefs_function_filter(inst, filters, NULL,
> +                                     TRACEFS_FL_RESET | TRACEF_FL_CONTINUE,
> +                                     &errs);
>
>         if (ret < 0 && errs) {
>                 while (errs[i])
>                         printf("%s\n", errs[i++]);
>         }
> +       free(errs);
> +
> +       ret = tracefs_function_filter(inst, all, "ext4", 0, &errs);
> +       if (ret < 0) {
> +               printf("Failed to set filters for ext4\n");
> +               /* Force the function to commit previous filters */
> +               tracefs_function_filter(inst, NULL, NULL, 0, &errs);
> +       }
>
>         tracefs_instance_destroy(inst);
> -       free(errs);
>         return 0;
>  }
>  --
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 9c18218cd916..73ec113fdb20 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -18,6 +18,7 @@ struct tracefs_instance {
>         char    *trace_dir;
>         char    *name;
>         int     flags;
> +       int     ftrace_filter_fd;
>  };
>
>  /* Can be overridden */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 5193d46f41f5..f4775e938f69 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -148,9 +148,11 @@ const char *tracefs_option_name(enum tracefs_option_id id);
>
>  /*
>   * RESET       - Reset on opening filter file (O_TRUNC)
> + * CONTINUE    - Do not close filter file on return.
>   */
>  enum {
>         TRACEFS_FL_RESET        = (1 << 0),
> +       TRACEFS_FL_CONTINUE     = (1 << 1),
>  };
>
>  int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index a02c839f2079..bf2fabf111ea 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -43,6 +43,8 @@ static struct tracefs_instance *instance_alloc(const char *trace_dir, const char
>                         goto error;
>         }
>
> +       instance->ftrace_filter_fd = -1;
> +
>         return instance;
>
>  error:
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 7e191e207867..862db5caa20e 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -23,6 +23,8 @@
>  #define TRACE_FILTER           "set_ftrace_filter"
>  #define TRACE_FILTER_LIST      "available_filter_functions"
>
> +/* File descriptor for Top level set_ftrace_filter  */
> +static int ftrace_filter_fd = -1;
>  static pthread_mutex_t filter_lock = PTHREAD_MUTEX_INITIALIZER;
>
>  static const char * const options_map[] = {
> @@ -851,6 +853,12 @@ static int write_func_list(int fd, struct func_list *list)
>   *          before applying the @filters. This flag is ignored
>   *          if this function is called again when the previous
>   *          call had TRACEFS_FL_CONTINUE set.
> + *   TRACEFS_FL_CONTINUE - will keep the filter file open on return.
> + *          The filter is updated on closing of the filter file.
> + *          With this flag set, the file is not closed, and more filters
> + *          may be added before they take effect. The last call of this
> + *          function must be called without this flag for the filter
> + *          to take effect.
>   *
>   * returns -x on filter errors (where x is number of failed filter
>   * srtings) and if @errs is not NULL will be an allocated string array
> @@ -869,13 +877,26 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
>         struct func_list *func_list = NULL;
>         char *ftrace_filter_path;
>         bool reset = flags & TRACEFS_FL_RESET;
> +       bool cont = flags & TRACEFS_FL_CONTINUE;
>         int open_flags;
>         int ret = 1;
> -       int fd;
> +       int *fd;
>
>         pthread_mutex_lock(&filter_lock);
> -       if (!filters)
> +       if (instance)
> +               fd = &instance->ftrace_filter_fd;
> +       else
> +               fd = &ftrace_filter_fd;
> +
> +       if (!filters) {
> +               /* OK to call without filters if this is closing the opened file */
> +               if (!cont && *fd >= 0) {
> +                       ret = 0;
> +                       close(*fd);
> +                       *fd = -1;
> +               }
>                 goto out;
> +       }
>
>         func_filters = make_func_filters(filters);
>         if (!func_filters)
> @@ -896,16 +917,20 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
>
>         open_flags = reset ? O_TRUNC : O_APPEND;
>
> -       fd = open(ftrace_filter_path, O_WRONLY | open_flags);
> +       if (*fd < 0)
> +               *fd = open(ftrace_filter_path, O_WRONLY | open_flags);
>         tracefs_put_tracing_file(ftrace_filter_path);
> -       if (fd < 0)
> +       if (*fd < 0)
>                 goto out_free;
>
> -       ret = write_func_list(fd, func_list);
> +       ret = write_func_list(*fd, func_list);
>         if (ret > 0)
> -               ret = controlled_write(fd, func_filters, module, errs);
> +               ret = controlled_write(*fd, func_filters, module, errs);
>
> -       close(fd);
> +       if (!cont) {
> +               close(*fd);
> +               *fd = -1;
> +       }
>
>   out_free:
>         free_func_list(func_list);
> --
> 2.30.1
>
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
