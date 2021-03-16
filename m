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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7524EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 11:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C00A65044
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 11:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhCPLzr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 07:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbhCPLzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 07:55:42 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFC8C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 04:55:38 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id v192so30236699oia.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 04:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z8dNsQ2Wanfs7pNpY14AY09PeZtVgs5SBUvqTO+aRPY=;
        b=vF/63GHN9/WqdhcqJZtp22rxJxXzAsAaLdzi2msDsfGxTCjdU0enHsRIg36a+BaZbU
         m0aXEGNX0vRnpdmm0mwlKxJAfjxvSsjaMykCXRrd2wrLvMCtEJiQ0clcqb2DikvZResx
         wI4fQgh3DQ4aIToGDxiNY2ykedHtDftesUF+/kDFnZHrWOE3CtH4N/wi/WFMgnpbQPtI
         1pR2BuN2O3EpurBuM3KrSp39ASlthKs4RNXzd551x4uQ4NVsd4+3G/2FkmHPjDUXA72N
         maiaDmtbYLSYHV26RQ6pz5oq0k+V7hGJBcv04CRpz51QowEXbG2j0uSE+7jgH5DiMg1L
         S3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z8dNsQ2Wanfs7pNpY14AY09PeZtVgs5SBUvqTO+aRPY=;
        b=jEz6W/KeWmPxIbPcnMh20zAhK0HOFgAI546j9SPnxVcFsq/vhmvvzx3o+ieem7Z4KM
         kAulkqvdynzy4S+tVt1PwfWqIAzf5OoNYfAcfLaY1CZyGDZcjEIMrKYFQaPVwbio3PlN
         F2u1MrMzgGZdK4rl8EvV/ye37DPvSkHLlGs8iqjzc4uAl12lTa2rES6tLKLZ5W7GsC0f
         KZdldN2yNlYWoi7vUge/6UfWJO/EDAR+L1BoISS6HTF2wJVM6S4wP4NDby27HLlyFjtb
         K7DixsI+EO2c0ds6XkZJm0JqkdRCdAJOAywL7t00TFv74xOri1C+RElCVfAYWTnrAPqE
         KN4w==
X-Gm-Message-State: AOAM532JaOzVAt2vS1nrADk8qd/2TnNisst/bg0NtpC3L7YJ/HSVYE4x
        VpX1ZezqT6ZyoVF5q3JX0NpdhhLRTto1DqqxLyuVeKsALOs=
X-Google-Smtp-Source: ABdhPJxnbkXrwdMVxIpGXdHQLo/N8F67u7JK9uidg53mwCuxvOZ5pFKGOaZscXrDNzJpwWc6XEt4Fw1OcOMCWWi5qbk=
X-Received: by 2002:aca:3456:: with SMTP id b83mr3180844oia.51.1615895738114;
 Tue, 16 Mar 2021 04:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <1615916693-15528-1-git-send-email-sameeruddin.shaik8@gmail.com> <CAPpZLN55AsuxsRM=CxSf3Tw+YcjONBd-eWz=0KsDJddnFJ-N6w@mail.gmail.com>
In-Reply-To: <CAPpZLN55AsuxsRM=CxSf3Tw+YcjONBd-eWz=0KsDJddnFJ-N6w@mail.gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Tue, 16 Mar 2021 17:25:26 +0530
Message-ID: <CAK7tX=ZvWM5aaCZsYwpDE1sp83qypT7wh46ziPQzpz6ffPbcFw@mail.gmail.com>
Subject: Re: [PATCH v1] libtracefs: An API to set the filtering of functions
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Tzvetomir,
Thanks for your review, I will address your comments in the next patch.
steve,
Do you have any other comments on this patch?
Thanks,
sameer.

On Tue, Mar 16, 2021 at 5:07 PM Tzvetomir Stoyanov
<tz.stoyanov@gmail.com> wrote:
>
> Hi Sameer,
> I think we are almost there, I have a few comments on the error
> handling, that should be addressed before merging the patch.
>
> On Mon, Mar 15, 2021 at 7:49 PM Sameeruddin shaik
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
> > ---
> > changed snprintf to asprintf for string formation
> > handled the lines over 80 characters
> >
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index f3eec62..c1f07b0 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -145,5 +145,6 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
> >  int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
> >  int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
> >  const char *tracefs_option_name(enum tracefs_option_id id);
> > -
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
> > +                           const char *module, bool reset, const char ***errs);
> >  #endif /* _TRACE_FS_H */
> > diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > index e2dfc7b..6b33321 100644
> > --- a/src/tracefs-tools.c
> > +++ b/src/tracefs-tools.c
> > @@ -18,6 +18,7 @@
> >  #include "tracefs-local.h"
> >
> >  #define TRACE_CTRL     "tracing_on"
> > +#define TRACE_FILTER   "set_ftrace_filter"
> >
> >  static const char * const options_map[] = {
> >         "unknown",
> > @@ -387,3 +388,93 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
> >         if (options && id > TRACEFS_OPTION_INVALID)
> >                 options->mask &= ~(1ULL << (id - 1));
> >  }
> > +
> > +static int controlled_write(const char *filter_path, const char **filters,
> > +                           const char *module, bool reset, const char ***errs)
> > +{
> > +       int flags = reset ? O_TRUNC : O_APPEND;
> > +       const char **e = NULL;
> > +       char *each_str = NULL;
> > +       int write_size = 0;
> > +       int size = 0;
> > +       int fd = -1;
> > +       int ret = 0;
> > +       int j = 0;
> > +       int i;
> > +
> > +       fd = open(filter_path, O_WRONLY | flags);
> > +       if (fd < 0)
> > +               return 1;
> > +
> > +       for (i = 0; filters[i]; i++) {
> > +               if (module)
> > +                       write_size = asprintf(&each_str, "%s:mod:%s ", filters[i], module);
> > +               else
> > +                       write_size = asprintf(&each_str, "%s ", filters[i]);
> > +               if (write_size < 0)
> > +                       continue;
>
> I think we can consider asprintf() failure as a major problem. There
> are two options - break the loop or goto error label.
>
> > +               size = write(fd, each_str, write_size);
> > +               /* compare written bytes*/
> > +               if (size < write_size) {
> > +                       if (errs) {
> > +                               e = realloc(e, (j + 1) * (sizeof(char *)));
>
> The realloc return value must be checked. In case of an error - break
> the loop or goto error label.
>
> > +                               e[j++] = filters[i];
> > +                               ret -= 1;
> > +                       }
> > +               }
> > +               free(each_str);
>
> Set each_str to NULL after the free, This will help with proper
> resources cleanup, in case of an error.
>
> > +       }
>
> If you choose the option to break the loop in case of an error, check
> here if filters[i] is not NULL, i.e. if the loop exit with an error.
> If there was an error - clean up all internally allocated resources
> (fd, e, each_str) and return error.
> The other option is to add "error" or "out" label at the end of the
> function where to do this resource cleanups.
>
> > +       if (errs) {
> > +               e = realloc(e, (j + 1) * (sizeof(char *)));
>
> Check that realloc return value too.
>
> > +               e[j] = NULL;
> > +               *errs = e;
> > +       }
> > +       close(fd);
>
> Note: in case of an internal error exit, free e and each_str, if they
> were allocated, and do not modify err.
>
> > +       return ret;
> > +}
> > +
> > +/**
> > + * tracefs_function_filter - write to set_ftrace_filter file to trace
> > + * particular functions
> > + * @instance: ftrace instance, can be NULL for top tracing instance
> > + * @filters: An array of function names ending with a NULL pointer
> > + * @module: Module to be traced
> > + * @reset: set to true to reset the file before applying the filter
> > + * @errs: A pointer to array of constant strings that will be allocated
> > + * on negative return of this function, pointing to the filters that
> > + * failed.May be NULL, in which case this field will be ignored.
> > + *
> > + * The @filters is an array of strings, where each string will be used
> > + * to set a function or functions to be traced.
> > + *
> > + * If @reset is true, then all functions in the filter are cleared
> > + * before adding functions from @filters. Otherwise, the functions set
> > + * by @filters will be appended to the filter file
> > + *
> > + * returns -x on filter errors (where x is number of failed filter
> > + * srtings) and if @errs is not NULL will be an allocated string array
> > + * pointing to the strings in @filters that failed and must be freed
> > + * with free().
> > + *
> > + * returns 1 on general errors not realted to setting the filter.
> > + * @errs is not set even if supplied.
> > + *
> > + * return 0 on success and @errs is not set.
> Note: in case of an error exit, free e and each_str, if they were allocated
> > + */
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
> > +                           const char *module, bool reset, const char ***errs)
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
>
> Thanks, Sameer!
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
