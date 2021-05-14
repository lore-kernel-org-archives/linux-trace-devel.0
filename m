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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AE6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 02:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 260D36143E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 02:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhENCyb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 22:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhENCya (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 22:54:30 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65766C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 19:53:20 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so873580pjb.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 19:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VAORk2phwhkOG4gO0Av+6pNCX24baWf5A1UaRpgbi4=;
        b=ixZAkkmr/32PEGashxJJ/Yjbma/ra6nXCBlGzM/etJPoKCkP3qcuNkUgmzmkxnAjEh
         Bc7TR1A+LKzEkf8ujxh2g14pBadkZWGX3IxvHmHKNz1aiberT+vIjna4TKk9ImVkI+qW
         y+NAk0gdoWH26amqTA7mTH5nWSM0Vl9EJBbOFXFHFdw4KLOAo0s4DiU5ysdDcjvA8BEJ
         hUbG9eWvWnpy4PrMHlYmfpGal112B5/Y7vkva8j+jdkY/f46sEJNOSsvb/4Dy+zk4+yu
         YJMpVUhu6sxk0BCeRXciIjR1cnoIJ+JWQdKQb51Ju1aLoWOREiKiUcaNCgME1OoZdVdi
         lT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VAORk2phwhkOG4gO0Av+6pNCX24baWf5A1UaRpgbi4=;
        b=V3FcWTKOR+zVZmr/cOtylic/RQhJrZFhpc66OL1IxBfRFV9vB4FQ6QP3ujg8EncqmM
         MEmt1HuZFl5KX0M6EBsZelKZ9uDsi/XtiBeGPV0h7pEvPJ9ytK2wROc0USpeEsTO5e9A
         FZ8Thg0/fgfG2ZYMtiDRWgpN5l484ifwEEjyaOHLaNgb4CIXIpGSpaM5ZtWCtVPojScP
         3HKHHHL4iLyS0xWArq0C8UN/ocFVpONl1q/FT06QH8iliYSpnLEzruJskPAWplFYvdja
         ujqeyZfiFuBf5M5H64hsIoufkvkYzkIOPmSgMKerr/dJfRWwWQEnfSj+WIUyhJXTfFYa
         dhfw==
X-Gm-Message-State: AOAM531w6tmTfvK5KdxLg6qcT/k0sM9+DPly61x+7peOCtmGsastLDpo
        k33T3JcfTyfuhUS6M59xUvpiQOdd4ZyQlIOCCNs=
X-Google-Smtp-Source: ABdhPJykWBc84T5Gl0llq33HftYOSySwdYnGUmgF4Vo2YjiHsayMS3JQBS9h0pvf9ZhpD/nURlBrI5w25tMXjMGkE14=
X-Received: by 2002:a17:902:d491:b029:ee:5aa3:7d57 with SMTP id
 c17-20020a170902d491b02900ee5aa37d57mr43304816plg.26.1620960799900; Thu, 13
 May 2021 19:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
 <20210507095333.1080910-9-tz.stoyanov@gmail.com> <20210513173605.030af4cd@gandalf.local.home>
In-Reply-To: <20210513173605.030af4cd@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 14 May 2021 05:53:03 +0300
Message-ID: <CAPpZLN5v_oTqaVWyXmHK5s0xtLxtMAbDuqtedy72gxroS2tPFQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] trace-cmd: Add new function to set log level
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 14, 2021 at 12:36 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  7 May 2021 12:53:33 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Introduce a new trace-cmd internal function to set the application log
> > level.
> >  trace_set_verbose()
> > The log level can be set using string with log id or log name.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/include/trace-local.h |  2 ++
> >  tracecmd/trace-cmd.c           | 41 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 43 insertions(+)
> >
> > diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> > index b3997d00..8da07c83 100644
> > --- a/tracecmd/include/trace-local.h
> > +++ b/tracecmd/include/trace-local.h
> > @@ -39,6 +39,8 @@ void usage(char **argv);
> >  extern int silence_warnings;
> >  extern int show_status;
> >
> > +int trace_set_verbose(char *level);
> > +
> >  struct pid_record_data {
> >       int                     pid;
> >       int                     brass[2];
> > diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
> > index 60cd3ea1..4e4a73af 100644
> > --- a/tracecmd/trace-cmd.c
> > +++ b/tracecmd/trace-cmd.c
> > @@ -45,6 +45,47 @@ void *malloc_or_die(unsigned int size)
> >       return data;
> >  }
> >
> > +static struct trace_log_severity {
> > +     int             id;
> > +     const char      *name;
> > +} log_severtity[] = {
>
> Is there a reason for the extra 't' in severity?

It's a typo.

>
> > +     { .id = TEP_LOG_NONE, .name = "none" },
> > +     { .id = TEP_LOG_CRITICAL, .name = "crit" },
> > +     { .id = TEP_LOG_ERROR, .name = "err" },
> > +     { .id = TEP_LOG_WARNING, .name = "warn" },
> > +     { .id = TEP_LOG_INFO, .name = "info" },
> > +     { .id = TEP_LOG_DEBUG, .name = "debug" },
> > +     { .id = TEP_LOG_ALL, .name = "all" },
> > +};
> > +
> > +int trace_set_verbose(char *level)
> > +{
> > +     int id;
> > +
> > +     if (!level)
> > +             return -1;
> > +
> > +     if (isdigit(level[0])) {
> > +             id = atoi(level);
> > +             if (id >= TEP_LOG_NONE && id <= TEP_LOG_ALL) {
> > +                     tracecmd_set_loglevel(id);
> > +                     return 0;
> > +             }
> > +     } else {
> > +             int size = sizeof(log_severtity) / sizeof(log_severtity[0]);
>
> This can be shortened to:
>
>                 int size = ARRAY_SIZE(log_severity);
>
> Or at least we need to copy that macro to something that trace-cmd core has
> access to (see lib/trace-cmd/include/private/trace-cmd-private.h)
>
>
> > +             int i;
> > +
> > +             for (i = 0; i < size; i++) {
> > +                     if (strlen(level) >= strlen(log_severtity[i].name) &&
>
> Why the strlen test? It's OK to pass in "debugignorme"? What's the use case
> for this?
>
> Anyway, I applied the first two patches of this series.
>
> -- Steve
>
>
> > +                         !strncmp(level, log_severtity[i].name, strlen(log_severtity[i].name))) {
> > +                             tracecmd_set_loglevel(log_severtity[i].id);
> > +                             return 0;
> > +                     }
> > +             }
> > +     }
> > +
> > +     return -1;
> > +}
> >
> >  /**
> >   * struct command
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
