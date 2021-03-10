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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B18C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 05:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C83E64FF6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 05:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCJF24 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 00:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhCJF2g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 00:28:36 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A95CC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Mar 2021 21:28:36 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gb6so931012pjb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Mar 2021 21:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N2vUlyDbY6nQ+DDuJd7PRUwDAV7HSg3Vyu5xKYIQcbU=;
        b=pO8+B/iKHCOvI33PgKecXyLwqiMw3NqvuKeASTUYAsFWk097G6dbxs1vFo94mu9mzi
         Mwoppob6BOycBuHKo/z4rqJJArVuX3eNsz5vjx1XEOFqMMjqtuTN9puzyit6TWIaYv2K
         jC8wevT0sKrdoK7tuDCHks9glKbhda/MnczsSL28cNYS90Kp2vU3xyjdxGq5CuNJLKDw
         WbVu7djIzCix1G5R5phdaWbHZX2GNVJ7ToErP2R53vTrybqq1ipILJXxxC2MqJYU6mbD
         A+45qAwxEq9IfQmG+sm6fNU/hQfHN0D5ZG1I93b6kqoalQnFwIU4Qn1dU5bhx+/uDwR/
         DqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N2vUlyDbY6nQ+DDuJd7PRUwDAV7HSg3Vyu5xKYIQcbU=;
        b=Pu+ptWDD+iG+sqgq8RFj8o74jGt0pSRppGQ/wNeuEr8ywaQWeRfoB7GxsaAf9lAm8E
         1An61Y2VgTCcPw7PnC5DmY868zuPSdoZ7dddkCqp8KuZYaexUIObLrb3Uvu2LaNsrVYw
         68/fWsXacZhrBVcvKhIvGSX8+jZy8QfMpvlNotrnfPUsFtN/j671Laxmm0EZoyxmMStt
         AXis00Id9P0fzmipQh1Keu/hEs7F9nKL8vg2opyPE/JwXGzqUpoR5pZFQ5bcLwkuOSfN
         NBCmd/44b25vSJI4q5EIGMAFB95f0n/ZsPHnO6dIfY9GqIbYQgyhbk4DKSxTzrNU10tH
         Hi+g==
X-Gm-Message-State: AOAM532vbQakMBW4AN4suK6bcYujYyNX8hf11Q6sfYpyTZ1fxVO3TFBR
        oeEptz8d8doxKmZyZlZCQPj6mfaDm5v2gY7j/GLRWuN/9yw5Ng==
X-Google-Smtp-Source: ABdhPJxwxZ227n1m7ilkmk56Nvg0zjuE6QKm48EfKt019Vrx0DMcfpCKWOHd+Vsv5gqsvVXG9OeN4gJT2yeKk5coOT8=
X-Received: by 2002:a17:90a:8505:: with SMTP id l5mr1735090pjn.100.1615354115900;
 Tue, 09 Mar 2021 21:28:35 -0800 (PST)
MIME-Version: 1.0
References: <1615393287-12344-1-git-send-email-sameeruddin.shaik8@gmail.com> <CAK7tX=aU41LzhjmDZHWUL2qLQ0M8hRJKfg7QcY9FYDpTHfUq3g@mail.gmail.com>
In-Reply-To: <CAK7tX=aU41LzhjmDZHWUL2qLQ0M8hRJKfg7QcY9FYDpTHfUq3g@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 10 Mar 2021 07:28:19 +0200
Message-ID: <CAPpZLN7xgt2jsUycoNksdXOtOXiCZP5ZTP3F5_KUw30qapo=rw@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 9, 2021 at 6:51 PM Sameeruddin Shaik
<sameeruddin.shaik8@gmail.com> wrote:
>
> This is my test code, I tried handling the triple pointers in the library,
> but when it comes to user program, at first "errs" has NULL at the
> end(checked it using the gdb), but when we try to dereference and
> print, gradually position holding NULL in "errs" is getting assinged
> to some other location, and i am getting the segmentation fault.
>
> >Since a triple pointer is difficult to manage in the code, you could have:
> >
> >        const char **e = NULL;
> >
> >
> >               if (errs) {
> >                        e = realloc(sizeof(*e), j + 1);
> >                        e[j++] = filters[i];
> >                }
> >
> >Then at the end:
> >
> >        if (errs)
> >                *errs = e;
>
> i didn't got the clear picture of what, the above code snippet is doing.
> particularly the below line
>
> >e = realloc(sizeof(*e), j + 1);
 It should be just
   e = realloc(e, (j + 1) * sizeof(char *));
we need to store one more pointer to char,
 On the first call, e is NULL and j is 0 and this behaves
 as a regular malloc:
   e = realloc(NULL, 1 * sizeof(char *));
on each subsequent call it allocates memory for
one additional pointer to char, at the end of the existing
array e.
Note that the allocated memory is not set to 0, it contains
random data.

>
> From man page i got
>
> void *realloc(void *ptr, size_t size);
>
> could you please brief me with an example?
>
> Subject: [PATCH] test: Test code
> diff --git a/test.c b/test.c
> index d38fc92..3e90711 100644
> --- a/test.c
> +++ b/test.c
> @@ -1,7 +1,39 @@
>  #include <tracefs.h>
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +
> +
> +
> +#define INST "dummy"
> +
> +const char *filters[] = {"kvm_pmu_reset", "kvm_pmu_init",
> "dir_item_err", "tzvetomir", "sameer", "steve", NULL};
>
>  int main()
>  {
> -    tracefs_tracing_dir();
> +    struct tracefs_instance *instance = NULL;
> +    const char ***errs;

For the user of the API, errs is just an array of strings,
regular double pointer. It is not allocated by the caller,
so it is important to be initialised with NULL;

 const char **errs = NULL;

> +    int ret;
> +    int fd;
> +    int n;
> +    int i = 0;
> +
> +    errs = malloc(sizeof(char *));

No need to allocate it here, as the size is not known -
it depends on the number of failed filters. The API
will do the job.

> +    printf("%s\n",tracefs_tracing_dir());
> +    instance = tracefs_instance_create(INST);
> +    ret = tracefs_function_filter(instance, filters, "kvm", 1, errs);

As the errs will be allocated by the API, you should pass the address
of it:
   ret = tracefs_function_filter(instance, filters, "kvm", 1, &errs);
That makes the pointer triple, and it is important to be initialised
with NULL.

If the caller is not interested of the errors, it could pass NULL:
   ret = tracefs_function_filter(instance, filters, "kvm", 1, NULL);

> +
> +    if(ret < -1)
> +        if (errs)
> +            while (errs[i])
> +                printf("%s\n", *errs[i++]);
Yes, that is exactly how it should be used, except
that additional "*":
if (ret < 0 && errs) {
    while (errs[i])
          printf("%s\n", errs[i++]);
}

> +
> +    getchar();
> +    tracefs_instance_destroy(instance);
> +    tracefs_instance_free(instance);
> +    free(errs);
>      return 0;
>  }
>
> On Tue, Mar 9, 2021 at 9:51 PM Sameeruddin shaik
> <sameeruddin.shaik8@gmail.com> wrote:
> >
> > This new API will write the function filters into the
> > set_ftrace_filter file.
> >
> > tracefs_function_filter()
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=210643
> >
> > Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> >
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index f3eec62..a2249d0 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
> >  int tracefs_trace_off(struct tracefs_instance *instance);
> >  int tracefs_trace_on_fd(int fd);
> >  int tracefs_trace_off_fd(int fd);
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
> >
> >  /**
> >   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> > diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > index e2dfc7b..4e168df 100644
> > --- a/src/tracefs-tools.c
> > +++ b/src/tracefs-tools.c
> > @@ -18,6 +18,7 @@
> >  #include "tracefs-local.h"
> >
> >  #define TRACE_CTRL     "tracing_on"
> > +#define TRACE_FILTER      "set_ftrace_filter"
> >
> >  static const char * const options_map[] = {
> >         "unknown",
> > @@ -387,3 +388,96 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
> >         if (options && id > TRACEFS_OPTION_INVALID)
> >                 options->mask &= ~(1ULL << (id - 1));
> >  }
> > +
> > +static int controlled_write(const char *filter_path, const char **filters, const char *module, bool reset, const char ***errs)
> > +{
> > +       int flags = reset ? O_TRUNC : O_APPEND;
> > +       int write_size;
> > +       char *each_str;
> > +       int ret = 0;
> > +       int j = 0;
> > +       int size;
> > +       int slen;
> > +       int fd;
> > +       int i;
> > +
> > +       fd = open(filter_path, O_WRONLY | flags);
> > +       if (fd < 0)
> > +               return 1;
> > +
> > +       for (i = 0; filters[i]; i++) {
> > +               slen = strlen(filters[i]);
> > +               if (!slen)
> > +                       continue;
> > +
> > +               if (module)
> > +                       /* Adding 5 extra bytes for ":mod:"*/
> > +                       slen += strlen(module) + 5;
> > +
> > +               /* Adding 2 extra byte for the space and '\0' at the end*/
> > +               slen += 2;
> > +               each_str = calloc(1, slen);
> > +               if (!each_str)
> > +                       return 1;
> > +               if (module)
> > +                       write_size = snprintf(each_str, slen, "%s:mod:%s ", filters[i], module);
> > +               else
> > +                       write_size = snprintf(each_str, slen, "%s ", filters[i]);
> > +
> > +               size = write(fd, each_str, write_size);
> > +               /* compare written bytes*/
> > +               if (size < write_size) {
> > +                       if (errs) {
> > +                               errs[j++] = &filters[i];
> > +                               ret -= 1;
> > +                       }
> > +               }
> > +               free(each_str);
> > +       }
> > +       errs[j] = NULL;
> > +       close(fd);
> > +       return ret;
> > +}
> > +
> > +/**
> > + * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
> > + * @instance: ftrace instance, can be NULL for top tracing instance
> > + * @filters: An array of function names ending with a NULL pointer
> > + * @module: Module to be traced
> > + * @reset: set to true to reset the file before applying the filter
> > + * @errs: A pointer to array of constant strings that will be allocated
> > + * on negative return of this function, pointing to the filters that failed.
> > + * May be NULL, in which case this field will be ignored.
> > + *
> > + * The @filters is an array of strings, where each string will be used to set
> > + * a function or functions to be traced.
> > + *
> > + * If @reset is true, then all functions in the filter are cleared before
> > + * adding functions from @filters. Otherwise, the functions set by @filters
> > + * will be appended to the filter file
> > + *
> > + * returns -x on filter errors (where x is number of failed filter srtings)
> > + * and if @errs is not NULL will be an allocated string array pointing to the
> > + * strings in @filters that failed and must be freed with free().
> > + *
> > + * returns 1 on general errors not realted to setting the filter.
> > + * @errs is not set even if supplied.
> > + *
> > + * return 0 on success and @errs is not set.
> > + */
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs)
> > +{
> > +       char *ftrace_filter_path;
> > +       int ret = 0;
> > +
> > +       if (!filters)
> > +               return 1;
> > +
> > +       ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
> > +       if (!ftrace_filter_path)
> > +               return 1;
> > +
> > +       ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
> > +       tracefs_put_tracing_file(ftrace_filter_path);
> > +       return ret;
> > +}
> > --
> > 2.7.4
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
