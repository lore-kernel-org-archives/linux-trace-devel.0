Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0262C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 15:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbiANPA2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 10:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiANPA2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 10:00:28 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C698C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 07:00:28 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id a7so10741490plh.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 07:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IfDlAc9L2yF01CxNXZA+/pSB75vJYRDxQtUtZvg2+ao=;
        b=XVty+djjWt5kmX0hNfvOvhL97hFYkPy4BUoXwHQmQi5w44V8TBaJqtKhZAthSWaj0i
         h2bY1kCEvfLrfcfg65V9q2vdsUlGx0Rc6inqrDKogNknbjooumnw24GP+aVItb9AVT03
         xebasvfzNpzGWGQ1rqBwbbE+VnXBG30X6laSg2e/5Io0W7xPOcQz8NG/z2oVXNXXdx4X
         BPiC2Mm3ECwBs54b6wrdfDwNs42oKcNHtVi5iW3h1z/CQsI52/fLkqzsl7Am+rkIdvq1
         rbrzPTHYLJKMgyYlQNhLkW51BTxINbErSDyKLXreqtdutAXFAETk0D5j0Aqhs46nYIw4
         n5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IfDlAc9L2yF01CxNXZA+/pSB75vJYRDxQtUtZvg2+ao=;
        b=EmBmmXiObQZtuBK3BeZPVjp9NcdibMk6I88yVqj5wpvWbOwcOYLWQp+RwkUrMzDYx+
         eG9DeOdgeZl5+++TyQRLVUt3T7Yo7JTiHiNrHb2u3ECdeq9kgwuYzvSvXowMElvROtXP
         jnRGzyebzm6FTW4DREIzIBQRuRkdC4MqlnGirMpSztHxfS2x3gBZ6paRpB6b8o9alWD9
         OZIrsE4jt+kbVMLbqzqNLuDok2PsURv/JZYBGJmQhc7dsEWM5ACKGsBEsVQxGpFj/f/Y
         2cRtYJiwZLDR+0Nl4g80mcmZjbg6M0egjce2T9+SHwC+PEN8HvshO/Lz1260NvgqiGGc
         vvHg==
X-Gm-Message-State: AOAM532OQL7sOr4R+dduVjYCVB+tMUmKiiSPK9/4wPn9QUV3q02DX6Z2
        FvLAwj7s8voYhVf91XdPzOiNnehNNQphmsVMfG+qgd5G0Sc=
X-Google-Smtp-Source: ABdhPJxVgxC8RhOo1HwcNbdVBtJhrAmdN/ESvTQcjG8hEPT6n0kUrvdsqUrW4NpCDpGHHOXiW+GyxIR0hPaqmJcmn+Y=
X-Received: by 2002:a17:902:d50d:b0:14a:4ed2:2a18 with SMTP id
 b13-20020a170902d50d00b0014a4ed22a18mr9868084plg.44.1642172427479; Fri, 14
 Jan 2022 07:00:27 -0800 (PST)
MIME-Version: 1.0
References: <20220113170059.82747-1-y.karadz@gmail.com> <CAPpZLN4ik3=Wp6W7auSUEE0t83SneWG+1njw5tHq_tp=xmOhEw@mail.gmail.com>
 <bfd749a9-3c82-74e6-a4c4-a1dfd5f7f66d@gmail.com>
In-Reply-To: <bfd749a9-3c82-74e6-a4c4-a1dfd5f7f66d@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 14 Jan 2022 17:00:11 +0200
Message-ID: <CAPpZLN5R9G-y0au6-g1VkyMN1j0dDU39V04fwbLwEND9XAU4iQ@mail.gmail.com>
Subject: Re: [PATCH v2] libtracefs: New API for getting synthetic event
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jan 14, 2022 at 4:58 PM Yordan Karadzhov <y.karadz@gmail.com> wrote=
:
>
>
>
> On 14.01.22 =D0=B3. 12:12 =D1=87., Tzvetomir Stoyanov wrote:
> > On Fri, Jan 14, 2022 at 10:17 AM Yordan Karadzhov (VMware)
> > <y.karadz@gmail.com> wrote:
> >>
> >> A new API is proposed, to get tep event descriptor for given synthetic
> >> event:
> >>
> >> tracefs_synth_get_event ()
> >>
> >> The API implementation gets derived from the implementation of the
> >> existing API  tracefs_dynevent_get_event(). It can detect any newly
> >> created or removed synthetic events.
> >>
> >> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> >> ---
> >>   Documentation/libtracefs-synth2.txt | 13 +++++++++++--
> >>   include/tracefs-local.h             |  2 ++
> >>   include/tracefs.h                   |  2 ++
> >>   src/tracefs-dynevents.c             | 17 +----------------
> >>   src/tracefs-events.c                | 21 +++++++++++++++++++++
> >>   src/tracefs-hist.c                  | 18 ++++++++++++++++++
> >>   6 files changed, 55 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtr=
acefs-synth2.txt
> >> index 8056ab8..444318c 100644
> >> --- a/Documentation/libtracefs-synth2.txt
> >> +++ b/Documentation/libtracefs-synth2.txt
> >> @@ -6,7 +6,8 @@ NAME
> >>   tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd,=
 tracefs_synth_complete,
> >>   tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_sna=
pshot,
> >>   tracefs_synth_get_name, tracefs_synth_raw_fmt, tracefs_synth_show_ev=
ent,
> >> -tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation=
 of synthetic events
> >> +tracefs_synth_show_start_hist, tracefs_synth_show_end_hist, tracefs_s=
ynth_get_event
> >
> > The new API should be added also in Documentation/libtracefs.txt, the
> > main man page with all APIs. Forgot to mention that in the previous
> > review.
> >
>
> Hmm, I see absolutely no tracefs_synth_*() APIs in Documentation/libtrace=
fs.txt.
> Maybe this can be fixed in a separate patch.
>

Yes, the whole synth_* section is missing, so I submitted a patch to
update that list. We can add tracefs_synth_get_event() later, when it
is accepted.

> thanks,
> Yordan
>
>
>
> > [ ...  ]
> >
> >



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
