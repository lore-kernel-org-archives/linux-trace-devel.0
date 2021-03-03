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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F390C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E982964F1A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhCBXuD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbhCBBQ0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 20:16:26 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DBEC061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Mar 2021 17:15:44 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id f3so20228905oiw.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Mar 2021 17:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dTHUKGWS91VhJ72veb+6/qLNBvgkj+UOKhxhMmivZg0=;
        b=KIzKt76LNIJruaC6I9M1iLh9ODSCyMROni+QOST32AJz5/Y+fDwuHh2uA1QxKVuzzu
         nEThzt/wpeg1ETkFT0fUt91tV3AQYi3/R4RhV1O5HZ4mS4jP+gZX4iWx121q4W+CqGb4
         WZZn3F+t1AzIVaP/TVc6i0Y7HbnRkOzh/jLWVfxytLy5qYLo6w1Q0vUR6AGoMM2fVjrh
         cmQeZts/tPr40Ibnxx2HbnR3IXLugHGF2OxzsTcxr4BY50LWvc3yiJmpOBXdNwE2RXAw
         Ggi2qJVWSuFw5n6QFRcd6m7KWfNXH/5nJEeCmlAWgrPDIUtCrktnfOWy+HaJFKHiDEBH
         E6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dTHUKGWS91VhJ72veb+6/qLNBvgkj+UOKhxhMmivZg0=;
        b=NhVLgBSZjkt5vUf40jbEz/yiFlMfTO+9/XystlFiOfvajSmIB4vkHwdrJ/EX8V7+jl
         U58+dNnzc0819+FQBb8jYbhCwn5tZ6cBH/k2p14gsq1/yHJDq2cP4xY2qWguG/+P1vcD
         kRFuOzOx5+5B8KEjiMwRN7ql5+urJTFxEofXPBj/wiaEzN3OPNkEHHmI7fJey8mLyojv
         YpXXLGYgvvOYuocTHlL+UGbGZEzRlKUajX20mUQp2/vSmw42eNVUMK9+xULIbaxiKn3N
         uzEYwbFQk7oCkZvH6GUx7GlECrkdGk8Ivn97YOhNv2TOyf79UVcS0p/qrXYfTpJ8XIUm
         N+2w==
X-Gm-Message-State: AOAM532LfzwC+ZTPAudJamduwKdT5/gKzpk6dbnPaxerew3pARyzbJgJ
        lKdmqAxLpwsj65yjJYD5mVUyJzmhKOZ4km/38T3ujFsywfPoeA==
X-Google-Smtp-Source: ABdhPJwOtiKcEmYA82qLOjgxk8PlNd8xPlVbU8tmodY9TRgYkvYIqS0M80c8HKrLr1eL6vbUj6zIIUy3ztoy7GmfUJo=
X-Received: by 2002:aca:cf07:: with SMTP id f7mr1412905oig.154.1614647743668;
 Mon, 01 Mar 2021 17:15:43 -0800 (PST)
MIME-Version: 1.0
References: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com> <20210301131754.11f0be38@gandalf.local.home>
In-Reply-To: <20210301131754.11f0be38@gandalf.local.home>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Wed, 3 Mar 2021 06:46:26 +0530
Message-ID: <CAK7tX=b4qPFcC+uGHfbBT3v90+qhHuBoLF=HgqUMmD0b00PF6A@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

what if we store the indices of the failed filters in an integer array
and return them back?
let's return the number of bytes written, also we will calculate the
complete filters length and return it, if there is difference,
we will loop into the integer array and print the erroneous filters

Let's fix the number of parameters to this function:)
Thanks,
sameer.



On Mon, Mar 1, 2021 at 11:47 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue,  2 Mar 2021 22:45:10 +0530
> Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
>
> > This new API will write the function filters into the
> > set_ftrace_filter file, it will write only string as of now, it can't
> > handle kernel glob or regular expressions.
>
> The limitation of no glob or regular expressions is fine. We can add that
> in future patches.
>
> >
> > tracefs_function_filter()
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=210643
> >
> > Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> >
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index f3eec62..b5259f9 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
> >  int tracefs_trace_off(struct tracefs_instance *instance);
> >  int tracefs_trace_on_fd(int fd);
> >  int tracefs_trace_off_fd(int fd);
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char * const *filters, const char *module, bool reset);
> >
> >  /**
> >   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> > diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > index e2dfc7b..b8d8c99 100644
> > --- a/src/tracefs-tools.c
> > +++ b/src/tracefs-tools.c
> > @@ -18,6 +18,7 @@
> >  #include "tracefs-local.h"
> >
> >  #define TRACE_CTRL   "tracing_on"
> > +#define TRACE_FILTER      "set_ftrace_filter"
> >
> >  static const char * const options_map[] = {
> >       "unknown",
> > @@ -387,3 +388,85 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
> >       if (options && id > TRACEFS_OPTION_INVALID)
> >               options->mask &= ~(1ULL << (id - 1));
> >  }
> > +
> > +static int controlled_write(const char *filter_path, const char * const *filters, const char *module, bool reset)
> > +{
> > +     int write_size;
> > +     char *each_str;
> > +     int size = 0;
> > +     int slen;
> > +     int fd;
> > +     int i;
> > +
> > +
>
> Only need one empty line between declaration and code.
>
> > +     if (!filters)
> > +             return -1;
> > +     if (reset)
> > +             fd = open(filter_path, O_WRONLY | O_TRUNC);
> > +     else
> > +             fd = open(filter_path, O_WRONLY | O_APPEND);
>
> It's usually more robust to have a system call parameter set by an if
> statement and only call the system call once.
>
>         int flags;
>
>         flags = reset ? O_TRUNC : O_APPEND;
>
> Although O_APPEND isn't really needed here (zero would work), but it's fine
> to have.
>
>         fd = open(filter_path, O_WRONLY | flags);
>
>
> > +     if (fd < 0)
> > +             return -1;
>
> I would add a blank line between the check and for loop, to space out the
> logic a bit better.
>
>         fd = open(filter_path, O_WRONLY | flags);
>         if (fd < 0)
>                 return -1;
>
>         for (i = 0; filters[i]; i++)
>
> No space between setting the fd and checking it. It gives a visual on how
> code is related.
>
> > +     for (i = 0; filters[i] != NULL ; i++) {
>
> No need for the " != NULL"
>
>
> > +             slen = 0;
> > +             slen = strlen(*(filters + i));
>
> No need for slen = 0 as you set it immediately afterward, also, it is more
> appropriate to use:
>
>                 slen = strlen(filters[i]);
>
>
> > +             if (slen < 0)
>
> The above can't happen, strlen always returns a positive integer (or zero).
> Now checking for zero would make sense.
>
>                 if (!slen)
> > +                     continue;
>
>
> > +
> > +             if (module)
> > +                     slen += strlen(module) + 5;
>
> What's the "+ 5" for? Should be commented.
>
> > +             /* Adding 2 extra byte for the space and '\0' at the end*/
> > +             slen += 2;
> > +             each_str = calloc(1, slen);
> > +             if (!each_str)
> > +                     return -1;
> > +             if (module)
> > +                     write_size = snprintf(each_str, slen, "%s:mod:%s ", *(filters + i), module);
> > +             else
> > +                     write_size = snprintf(each_str, slen, "%s ", *(filters + i));
> > +             if (write_size < (slen - 1)) {
>
> This should never happen. If it does, then there's something wrong with
> this code, not the input.
>
>
> > +                     free(each_str);
> > +                     continue;
> > +             }
> > +             size += write(fd, each_str, write_size);
>
> Need to check errors here, and we need a way to report that an error
> happened for a string. Perhaps the API also needs to have an error message
> pointer that is passed in? Or a bitmask that lets the user know which
> filter failed?
>
> Tzvetomir, have any ideas on how to report back to the caller which filter
> failed? Could just send back an array of strings of the filters that failed.
>
>         int tracefs_function_filter(struct tracefs_instance *instance,
>                                     const char * const * filters,
>                                     const char * module, bool reset,
>                                     const char * const ** errs);
>
> Where if errs points to a pointer, that pointer gets updated with an array.
>
>         const char **filters = { "func1", "func2", func3" };
>         const char **errs;
>         ret;
>
>         ret = tracefs_function_filter(NULL, filters, NULL, &errs);
>
> If "func1" and "func3" fail, then ret is < 0 (-2 for number of failures?)
> and errs would be:
>
>         errs = { &filter[0], &filters[2], NULL };
>
>         and the users would need to free it as well.
>
>         free(errs);
>
> if ret is zero, then errs would not be touched, and the caller does not
> need to do anything with it.
>
> Note, if the user doesn't care about errors, errs could be NULL, in which
> case the calling function would obviously not set it.
>
>
>
> > +             free(each_str);
> > +     }
> > +     close(fd);
> > +     return size;
> > +}
> > +
> > +/**
> > + * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
> > + * @instance: ftrace instance, can be NULL for top tracing instance
> > + * @filter: An array of function names ending with a NULL pointer
> > + * @module: Module Name to be traced
> > + * @reset: set to true to reset the file before applying the filter
> > + *
> > + * The @filter is an array of strings, where each string will be use to set
> > + * a function or functions to be traced.
> > + *
> > + * If @reset is true, then all functions in the filter are cleared before
> > + * adding functions from @filter. Otherwise, the functions set by @filter
> > + * will be appended to the filter
> > + *
> > + * Returns the number of bytes written into the filter file or -1 if
> > + * there is any error in writing to filter file
> > + */
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char * const *filters, const char *module, bool reset)
> > +{
> > +     char *ftrace_filter_path;
> > +     int ret;
> > +
> > +     if (!filters)
> > +             return -1;
>
> You can add a empty line here.
>
> > +     ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
> > +
> > +     if (!ftrace_filter_path)
> > +             goto gracefully_free;
>
> It should just be "goto out".
>
> > +
> > +     ret = controlled_write(ftrace_filter_path, filters, module, reset);
> > +
> > + gracefully_free:
> > +     tracefs_put_tracing_file(ftrace_filter_path);
> > +     return ret;
>
> Note, you need to initialize ret to -1, otherwise it is undefined if you
> do the "goto out".
>
> -- Steve
>
> > +}
>
