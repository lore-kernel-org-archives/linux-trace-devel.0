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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E483C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E1D61A06
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhCXMLR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 08:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbhCXMLO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 08:11:14 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF11C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 05:11:13 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id h20so7817930plr.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 05:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RxVyRebVjJzsY21LRFTctfXvUTSDLj3KtkJ0nUVmEdg=;
        b=QtTVDfKg1E9BF+BHmEo/jZGEWupiAi7yaQxv6L0YZWv6U6RshVljCis9ADbk28TYcy
         ny5VEPC9E7DRP2DkAIXgZtn5Bcv8BXBqJQ07Ds6fzZwYMt2/+4NcFQo0b4Lpvnv6287n
         i7a/rwNmxWiWakY9Lt5fr9PGsij9OvvlAtTbsAfMSRBjPRajeKcLuYm3JSEbZERLZgcf
         pqfutoOobCNSko5fyhzdtV+qHpVITyIY//xWUnZZEub/QTRLvmQ9f0dU5v3FWauABbJn
         0vax81DfBtt6aP3Wsxq6l6wePNIgohlIaTQfEcuPWU6Mxv3jodOhrPyVyp2daIx2KRzJ
         nFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RxVyRebVjJzsY21LRFTctfXvUTSDLj3KtkJ0nUVmEdg=;
        b=Epd0q5uvgzYV687zeKQ8Smg60qsO2KoD3qy7MGMe3/k2909G/RB+SSphBpkyTrUCz8
         oQ1ymguH8DYAfZBiRJfESGjCjk/uYkbTNN3ogFxD06zNsEAHTheSaib3tJarzzafgCv/
         ea6fn/5r+ZNBkJrBFXdoZS+6y9XNLCTgKFY+/1dh3hWl/Bk59dkk4pwQPX/wznt9A+U8
         VokfWFrgCjdtwpam1XpDAtEH+saErqMRjJ+ZqevNCrSmQtoc3O7U1gFfZJUHzuUYfXUL
         kEpupfstuSiuBil5osc361ZxGr8SaxU6gh1HfTjizHCE+236dxgROlCkBXygicgVI1w4
         LMBg==
X-Gm-Message-State: AOAM531NMYjTD06BP04gZ4ycZjkbN9KrCH4MLjIYNf9jLmZdUKNWH+nq
        oxoqA2kcfAr7PRLjlL1t9cqJPWxqSpgMxK+GDeEN/QdccuZDKA==
X-Google-Smtp-Source: ABdhPJzGdjjle8DPaVS4BFi9RVhWdgH63wAvyblOuE+2JuMuWKtfO74cKcKxpDmcKwZHBY6cpYWL354/gv7Gvuhcvls=
X-Received: by 2002:a17:902:7b84:b029:e6:ec5a:3097 with SMTP id
 w4-20020a1709027b84b02900e6ec5a3097mr3197603pll.58.1616587872820; Wed, 24 Mar
 2021 05:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
 <20210322095945.259300-15-tz.stoyanov@gmail.com> <20210323214928.0c47e295@oasis.local.home>
In-Reply-To: <20210323214928.0c47e295@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Mar 2021 14:10:56 +0200
Message-ID: <CAPpZLN66C=MuwPqzE4VkTbjC3Z=XYHhkt-eWj2z4Y4fcDAra4A@mail.gmail.com>
Subject: Re: [PATCH v2 14/18] trace-cmd: Add a new flag to disable any
 timestamp corrections
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 3:49 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 22 Mar 2021 11:59:41 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > A new flag is added in the trace-cmd library for controlling events
> > timestamp corrections while reading a trace file. If the flag is set,
> > all timestamps are displayed as-is from the trace file.
> >    TRACECMD_FL_RAW_TS
> > The flag can be modified with these APIs:
> >   tracecmd_set_flag()
> >   tracecmd_clear_flag()
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
> >  lib/trace-cmd/trace-input.c                       | 12 ++++++++----
> >  2 files changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> > index c33d067a..fdca7494 100644
> > --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> > +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> > @@ -134,6 +134,7 @@ enum {
> >       TRACECMD_FL_IGNORE_DATE         = (1 << 0),
> >       TRACECMD_FL_BUFFER_INSTANCE     = (1 << 1),
> >       TRACECMD_FL_IN_USECS            = (1 << 2),
> > +     TRACECMD_FL_RAW_TS              = (1 << 3),
> >  };
> >
> >  struct tracecmd_ftrace {
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 5d03cd00..88007cde 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -1289,6 +1289,9 @@ static unsigned long long timestamp_calc(unsigned long long ts,
> >  {
> >       unsigned long long t = ts;
> >
> > +     /* do not modify raw timestamps */
> > +     if (handle->flags & TRACECMD_FL_RAW_TS)
> > +             return ts;
> >
> >       /* Guest trace file, sync with host timestamps */
> >       if (handle->host.sync_enable)
> > @@ -2604,7 +2607,8 @@ static int handle_options(struct tracecmd_input *handle)
> >                        * gtod. It is stored as ASCII with '0x'
> >                        * appended.
> >                        */
> > -                     if (handle->flags & TRACECMD_FL_IGNORE_DATE)
> > +                     if ((handle->flags & TRACECMD_FL_IGNORE_DATE) ||
> > +                         (handle->flags & TRACECMD_FL_RAW_TS))
> >                               break;
>
> These are flags, let's use them as such:
>
>                         if (handle->flags &
>                             (TRACECMD_FL_IGNORE_DATE | TRACECMD_FL_RAW_TS))
>                                 break;
>
> >                       offset = strtoll(buf, NULL, 0);
> >                       /* Convert from micro to nano */
> > @@ -2616,7 +2620,7 @@ static int handle_options(struct tracecmd_input *handle)
> >                        * Similar to date option, but just adds an
> >                        * offset to the timestamp.
> >                        */
> > -                     if (handle->flags & TRACECMD_FL_IGNORE_DATE)
> > +                     if (handle->flags & TRACECMD_FL_RAW_TS)
>
> Why do we not break here for IGNORE_DATE?
>
> >                               break;
> >                       offset = strtoll(buf, NULL, 0);
> >                       handle->ts_offset += offset;
> > @@ -2631,7 +2635,7 @@ static int handle_options(struct tracecmd_input *handle)
> >                        * long long array of size [count] of timestamp offsets.
> >                        * long long array of size [count] of timestamp scaling ratios.*
> >                        */
> > -                     if (size < 16 || handle->flags & TRACECMD_FL_IGNORE_DATE)
> > +                     if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
>
> And why did we change the code for IGNORE_DATE here too?

When we discuss the priorities of the various time sync options, I
understood that the "--nodate" should affect the "--date" option only.
For all other time sync options, the new flag should be used. That's
why I changed IGNORE_DATE to RAW_TS in these two places.

>
> -- Steve
>
> >                               break;
> >                       handle->host.peer_trace_id = tep_read_number(handle->pevent,
> >                                                                    buf, 8);
> > @@ -2710,7 +2714,7 @@ static int handle_options(struct tracecmd_input *handle)
> >                       trace_guest_load(handle, buf, size);
> >                       break;
> >               case TRACECMD_OPTION_TSC2NSEC:
> > -                     if (size < 16)
> > +                     if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
> >                               break;
> >                       handle->tsc_calc.mult = tep_read_number(handle->pevent,
> >                                                               buf, 4);
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
