Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43532C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Feb 2022 00:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiBYAKO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 19:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiBYAKO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 19:10:14 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6257D214F9F
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 16:09:43 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id v186so2733678ybg.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 16:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bbQ8BkgOmHTInzuoSkwt7mVrEcBESzl2udGWOVWd6bU=;
        b=gdbjYmsvHQWper9mCj0EEjSybjXK4MsehUWZtvtGsGMb5qDc/DA6JNSWfEQA0QLrSN
         SSs1cQDAVx7MWZTGwMhSDnUtB2sh569aZD0kz4u6jDeLcvQPpzO69PaWcmDGHUxE4YoG
         CDs73baMcJpotgsGH7DOSW07zFkDyMb1Tewaq6dwNU6rUuwpGaGvm1wKqQPQrW0L2ehr
         sjcB3L+VsrxB3894HJxpkeGkD/CkD2FhLI/WTR+g8f+7WId6hwMGdgF6jMaLO1aWadaA
         JCYa/TdVu7s6/5XkZTQMbgx+ExfNes0rHbIsMaHOHLLPy4K0jGBfbIzcf1tqSHxSQSTR
         2xyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bbQ8BkgOmHTInzuoSkwt7mVrEcBESzl2udGWOVWd6bU=;
        b=i16Z5dlXVn+ORA0Ew31m9ilVRwFJR1UUCY3Qd3hn9ikgCI0dHs1n2p8aQv4t2GXYuu
         qS5HUmF0H7Rfvjc2xbsOQw60KUIaVhKXZG7rDUQGstmSqgXRICiKZjSFOnr+QCEYhkOU
         BUBSYCfinRy24bTBcWmwE6DMNUY9CKWDdzRRTVeQFuZ+kchLpXv+7WfpWbwlnR81MsTh
         ES98eY0ThcpwrKQBpI4MLcw7HWvOlyFPIoqCl7SScUfbwD83Mpo4/5mxJF+xsbkFqRE5
         ycusTiLCjJX4sPHF1m3nnaViMipm4GP6+PNCpr3IcD2QkzFDOaCtNL3q7LiR2mZPUdLM
         OS1Q==
X-Gm-Message-State: AOAM531qqxrhgNlulFyvDJVhlWjUnYuaOzGchNgz2P6d09GmfODW5RKe
        WzRx1aaH/vcYbKRkb1AU81eE+Dfeiw+Z2aQiH+N0fw==
X-Google-Smtp-Source: ABdhPJyirRiFbIrLnCXsLiHsg5G9b2hoUTHO1khqXpk3w55d5nQ/q4RRJdUB4IMdROUz0A1Y5RQV1uvejsgIX3/86EA=
X-Received: by 2002:a25:d449:0:b0:619:c1f1:928b with SMTP id
 m70-20020a25d449000000b00619c1f1928bmr4747039ybf.19.1645747782384; Thu, 24
 Feb 2022 16:09:42 -0800 (PST)
MIME-Version: 1.0
References: <20220224234823.1190425-1-irogers@google.com> <20220224234823.1190425-3-irogers@google.com>
 <20220224185556.2771ad18@gandalf.local.home>
In-Reply-To: <20220224185556.2771ad18@gandalf.local.home>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 24 Feb 2022 16:09:29 -0800
Message-ID: <CAP-5=fUmB4QgHTBBsnKkuhh7KHF2us-ZGkn_UB4ymxUkmO3ebA@mail.gmail.com>
Subject: Re: [PATCH 3/3] libtracefs: Move initialization below a null test.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 24, 2022 at 3:56 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 24 Feb 2022 15:48:23 -0800
> Ian Rogers <irogers@google.com> wrote:
>
> > Computing the address from a NULL pointer results in undefined behavior
> > which things like undefined behavior sanitizer promote into real
> > failures.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  src/tracefs-dynevents.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> > index 61804b9..8fee474 100644
> > --- a/src/tracefs-dynevents.c
> > +++ b/src/tracefs-dynevents.c
> > @@ -724,13 +724,18 @@ tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
> >                     char **event, char **prefix, char **addr, char **format)
> >  {
> >       char **lv[] = { system, event, prefix, addr, format };
> > -     char **rv[] = { &dynevent->system, &dynevent->event, &dynevent->prefix,
> > -                     &dynevent->address, &dynevent->format };
> > +     char **rv[] = { NULL, NULL, NULL, NULL, NULL };
> >       int i;
>
> I don't really like the NULL initialization done like this.
>
> What about just adding a helper function. That is.
>
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index 61804b9d9d5e..48bb26a96c58 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -704,24 +704,9 @@ __hidden int dynevent_get_count(unsigned int types, const char *system)
>         return all;
>  }
>
> -/**
> - * tracefs_dynevent_info - return details of a dynamic event
> - * @dynevent: A dynamic event context, describing given dynamic event.
> - * @group: return, group in which the dynamic event is configured
> - * @event: return, name of the dynamic event
> - * @prefix: return, prefix string of the dynamic event
> - * @addr: return, the function and offset (or address) of the dynamic event
> - * @format: return, the format string of the dynamic event
> - *
> - * Returns the type of the dynamic event, or TRACEFS_DYNEVENT_UNKNOWN in case of an error.
> - * Any of the @group, @event, @prefix, @addr and @format parameters are optional.
> - * If a valid pointer is passed, in case of success - a string is allocated and returned.
> - * These strings must be freed with free().
> - */
> -
> -enum tracefs_dynevent_type
> -tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
> -                     char **event, char **prefix, char **addr, char **format)
> +static enum tracefs_dynevent_type
> +dynevent_info(struct tracefs_dynevent *dynevent, char **system,
> +             char **event, char **prefix, char **addr, char **format)
>  {
>         char **lv[] = { system, event, prefix, addr, format };
>         char **rv[] = { &dynevent->system, &dynevent->event, &dynevent->prefix,
> @@ -754,6 +739,30 @@ error:
>         return TRACEFS_DYNEVENT_UNKNOWN;
>  }
>
> +/**
> + * tracefs_dynevent_info - return details of a dynamic event
> + * @dynevent: A dynamic event context, describing given dynamic event.
> + * @group: return, group in which the dynamic event is configured
> + * @event: return, name of the dynamic event
> + * @prefix: return, prefix string of the dynamic event
> + * @addr: return, the function and offset (or address) of the dynamic event
> + * @format: return, the format string of the dynamic event
> + *
> + * Returns the type of the dynamic event, or TRACEFS_DYNEVENT_UNKNOWN in case of an error.
> + * Any of the @group, @event, @prefix, @addr and @format parameters are optional.
> + * If a valid pointer is passed, in case of success - a string is allocated and returned.
> + * These strings must be freed with free().
> + */
> +enum tracefs_dynevent_type
> +tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
> +                     char **event, char **prefix, char **addr, char **format)
> +{
> +       if (!dynevent)
> +               return TRACEFS_DYNEVENT_UNKNOWN;
> +
> +       return dynevent_info(dynevent, system, event, prefix, addr, format);
> +}
> +
>  /**
>   * tracefs_dynevent_get_event - return tep event representing the given dynamic event
>   * @tep: a handle to the trace event parser context that holds the events
>

LGTM. Thanks,

Ian

> -- Steve
