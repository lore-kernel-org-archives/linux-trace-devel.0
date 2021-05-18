Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA99C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 16:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 368FF61042
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 16:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343971AbhEQQcp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 12:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343991AbhEQQc2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 12:32:28 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA698C06135E
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 08:18:55 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id h202so8993900ybg.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tj4ARXUXbsgnmo3QHTyvxcw2ysijf6o9wYnTfETdTw8=;
        b=oXqChIs9LtQSXIrdqOTbDu0Vt2IX8kbo7sPIvfiKxI6IBm3l35XNGLFiWPLoyI3UKK
         hDH8mV3eubRjopao3bnltKfzfVqlYMN7sc37k9kI/hqotrJ5208j38DsnbUymKQO8dbW
         YSt5KscGUAU9OfWo4+ITZLKNoSaxBQcUJpEztxmck8D1e5CbJhKGL2fQo/ch0MXfXvS3
         NYjK3FS1mgDnNfsXvUETj8+rK2DUQBFqqv6Vwqku1emKo+ggYLPriN2zjNdcZlI8oORP
         T+Cf37+5bX0t8R+LGJ2CXWXyamSlGc/rXonB+GWEzvo1lc5CAjTMtiwRsRpHyaordG8f
         PrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tj4ARXUXbsgnmo3QHTyvxcw2ysijf6o9wYnTfETdTw8=;
        b=Tztb9Y3T6MmzxGhtxLFN6laXv+Nk83IUbsKvDSFHAanbNgVyTBqAM793L5fYELKnFR
         6K1j5SkWO52R1NtolkJ+Q3ZLv+Qe6GrpIBkmfrgJa4JP3aevOF8RSQdbZyn7jiMwNU3u
         5CbsIaVIBYJH93D1rcZSniJzDtiOnIrCWunys+tyurQUpbQrQMnu0sbclEmKH+XP8bQT
         kjdutbOyHRhI2y593pkXMRApqilgVYGf8MehecEhwOkVDZkmTTG4+EN7UM5BON7ee3ZI
         syVyhxlAVREdQC/qZGtiGEU9dPjMigNAHZomxvkrSd0u5Z1CBdo8M5ndRDqyviNcZDlo
         V0Kw==
X-Gm-Message-State: AOAM531IF8A5JdCbQqiRZuhEhMdlPgYqzP00Dm8T29ZOVd5mN79uPDcY
        RQM34utecGKS39KwXt4xAECVUMsmT8A5XPMH9n2G5bx0
X-Google-Smtp-Source: ABdhPJwI/Pt4l4MRNzBYIMi67AKb5mnZUNYO/NaG1rysP/WZ2xMI61ixbbBjIDu2QtT1a1k4b3mxJXzSRLdI1iPKJkI=
X-Received: by 2002:a25:83c3:: with SMTP id v3mr455170ybm.54.1621264735019;
 Mon, 17 May 2021 08:18:55 -0700 (PDT)
MIME-Version: 1.0
References: <1621243446-7402-1-git-send-email-sameeross1994@gmail.com> <20210517090504.431fe8fd@gandalf.local.home>
In-Reply-To: <20210517090504.431fe8fd@gandalf.local.home>
From:   sameeruddin shaik <sameeross1994@gmail.com>
Date:   Tue, 18 May 2021 20:48:35 +0530
Message-ID: <CAN_HWU=M-4zpL0eat2AWAPDsgxBjLJptaicNgXQ=rgWhNhjNWQ@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: Add support for setting tracers
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, May 17, 2021 at 6:35 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> Hi Sameer,
>
> Remember, when submitting a new patch, you should always use -v2 (or
> whatever the next version is). That way it's obvious that this is a new
> version of the patch.
>
> On Mon, 17 May 2021 14:54:06 +0530
> Sameeruddin shaik <sameeross1994@gmail.com> wrote:
>
> > tracefs_set_tracer - set the tracer
> > tracefs_stop_tracer - clear the tracer
>
> Actually, let's change the names to be:
>
>         tracefs_tracer_set()
>         tracefs_tracer_clear()
>
> The "tracefs_tracer_" keeps all the functions related to tracers stating
> with the same text.
>
> "stop" is misleading, because you are not really stopping the tracer, and
> "stop" does not match with "set". "clear" better term, and you even used
> that in your description of the trace above.
>
>
> >
> > Signed-off-by: Sameeruddin shaik <sameeross1994@gmail.com>
> >
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index 55ee867..0270a9e 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -173,4 +173,23 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
> >  int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
> >                            const char *module, unsigned int flags);
> >
> > +enum tracefs_tracers {
> > +     TRACEFS_TRACER_NOP = 0,
> > +     TRACEFS_TRACER_FUNCTION,
> > +     TRACEFS_TRACER_FUNCTION_GRAPH,
> > +     TRACEFS_TRACER_IRQSOFF,
> > +     TRACEFS_TRACER_PREEMPTOFF,
> > +     TRACEFS_TRACER_PREEMPTIRQSOFF,
> > +     TRACEFS_TRACER_WAKEUP,
> > +     TRACEFS_TRACER_WAKEUP_RT,
> > +     TRACEFS_TRACER_WAKEUP_DL,
> > +     TRACEFS_TRACER_MMIOTRACE,
> > +     TRACEFS_TRACER_HWLAT,
> > +     TRACEFS_TRACER_BRANCH,
> > +     TRACEFS_TRACER_BLOCK,
> > +};
> > +
> > +int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer);
> > +
> > +int tracefs_stop_tracer(struct tracefs_instance *instance);
> >  #endif /* _TRACE_FS_H */
> > diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > index 6ef17f6..d772f93 100644
> > --- a/src/tracefs-tools.c
> > +++ b/src/tracefs-tools.c
> > @@ -25,6 +25,30 @@ __hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
> >  #define TRACE_FILTER         "set_ftrace_filter"
> >  #define TRACE_NOTRACE                "set_ftrace_notrace"
> >  #define TRACE_FILTER_LIST    "available_filter_functions"
> > +#define CUR_TRACER           "current_tracer"
> > +
> > +#define TRACERS \
> > +     C(NOP,                  "nop"),                 \
> > +     C(FUNCTION,             "function"),            \
> > +     C(FUNCTION_GRAPH,       "function_graph"),      \
> > +     C(IRQSOFF,              "irqsoff"),             \
> > +     C(PREEMPTOFF,           "preemptoff"),          \
> > +     C(PREEMPTIRQSOFF,       "preemptirqsoff"),      \
> > +     C(WAKEUP,               "wakeup"),              \
> > +     C(WAKEUP_RT,            "wakeup_rt"),   \
> > +     C(WAKEUP_DL,            "wakeup_dl"),           \
> > +     C(MMIOTRACE,            "mmiotrace"),           \
> > +     C(HWLAT,                "hwlat"),               \
> > +     C(BRANCH,               "branch"),              \
> > +     C(BLOCK,                "block")
> > +
> > +#undef C
> > +#define C(a, b) b
> > +const char *tracers[] = { TRACERS };
> > +
> > +#undef C
> > +#define C(a, b) TRACEFS_TRACER_##a
> > +const int tracer_enums[] = { TRACERS };
> >
> >  /* File descriptor for Top level set_ftrace_filter  */
> >  static int ftrace_filter_fd = -1;
> > @@ -910,3 +934,68 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
> >       tracefs_put_tracing_file(filter_path);
> >       return ret;
> >  }
> > +
> > +int write_tracer(int fd, const char *tracer)
> > +{
> > +     int ret;
> > +
> > +     ret = write(fd, tracer, strlen(tracer));
> > +     if (ret < strlen(tracer))
> > +             return -1;
> > +     return ret;
> > +}
> > +
> > +/**
> > + * tracefs_set_tracer - function to set the tracer
> > + * @instance: ftrace instance, can be NULL for top tracing instance
> > + * @tracer: Tracer that has to be set, which can be integer from 0 - 13
> > + * or enum value
> > + */
> > +
> > +int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer)
> > +{
> > +     char *tracer_path = NULL;
> > +     const char *t = NULL;
> > +     int ret = -1;
> > +     int fd = -1;
> > +     int i;
> > +
> > +     tracer_path = tracefs_instance_get_file(instance, CUR_TRACER);
> > +     if (!tracer_path)
> > +             return -1;
> > +
> > +     fd = open(tracer_path, O_WRONLY);
> > +     if (fd < 0) {
> > +             errno = -ENOENT;
> > +             goto out;
> > +     }
> > +
> > +     if (tracer < 0 || tracer > ARRAY_SIZE(tracers)) {
> > +             errno = -ENODEV;
> > +             goto out;
> > +     }
>
> Space needed here, as well as a comment.
>
> > +     if (tracer == tracer_enums[tracer])
> > +             t = tracers[tracer];
> > +     else {
> > +             for (i = 0; i < ARRAY_SIZE(tracer_enums); i++) {
> > +                     if (tracer == tracer_enums[i]) {
> > +                             t = tracers[i];
> > +                             break;
> > +                     }
> > +             }
> > +     }
> > +     if (!t) {
> > +             errno = -EINVAL;
> > +             goto out;
> > +     }
> > +     ret = write_tracer(fd, t);
> > + out:
> > +     tracefs_put_tracing_file(tracer_path);
> > +     close(fd);
> > +     return ret;
>
> BTW, when a reviewer of your code gives a code example of a better
> implementation, you should express that in your change log. I usually use:
>
>  Suggested-by: ...
>
> So you should have:
>
>  Suggested-by: Steven Rostedt <rostedt@goodmis.org>
>
> as the above is pretty much exact copy of the code snippet I posted.
okay steve,
since i don't know, about this suggested-by, i haven't included. otherwise
i could have done.

Thanks,
sameer
