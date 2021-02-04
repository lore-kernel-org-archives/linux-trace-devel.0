Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FF6C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 12:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50AC664F3F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 12:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhBDMcl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 07:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbhBDMcl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 07:32:41 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179B0C061573
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Feb 2021 04:32:01 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id c132so1995637pga.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Feb 2021 04:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QzfUU2emTPnO2gJ4deEdnxx462zssgx2pVuu/J8YNT4=;
        b=E/wZ9LLjq++1bB2Jw918n+jiIB2617Keuw9AqV9nJSn65mNzqLdp/wGR9iUHO5Fkg4
         WeWTbnat3EzHde4loTq8pNvNhvmo9dLBxxIR14PKjtObdTSX2kbF8U5UbJep0fiho5+y
         6lt8EffzGjh9KQ9+okY9NlcGNu+/AST9IuCB6uwjrXusx12SOmKzftd/dpy8YDegTk3A
         oX+4lbmV1oIGv1LmUB7zBWVpcZ+HZtJP2WIrkqD8t+PJusqZDcRZq13QrhNA7dA5R+9K
         9frbhLRWfp546ylLBUvbJk3/IsxYcOTWFTHYQqvU96+kxCPkOymGocZR8K93cE5GX6oh
         jSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QzfUU2emTPnO2gJ4deEdnxx462zssgx2pVuu/J8YNT4=;
        b=FiTToFqhFllvAKp1jAMDTZF05XKcEdhJAkgB8qUmzrSQGrEuHlhG4GRasY8Q0zZ8Qv
         lnIJKPbJQRYO1x0fBntxtyE52fhaNoI+aoHloH9cD4Jj1AxbRMsCp8gVIJoNS9rxImmK
         yd1RJxDrh8tmR+LwiQKJ82GiNVx5SeauahCCzCuq+XPmHhzcCufXGzhRl5zI+jWoNNrm
         XRNOtx12kxzSsJ/Mav6sQTbM+lGAgFku6HB5VaKPzow4CE2ah+158zoshSi5ovwIHrVC
         +OnxA97d7tZNgbNYKT+xUOkH4PsyNelEQb/UjxgluXrzX/9ouiEZfO5En3eLi9BIuj/+
         nNKw==
X-Gm-Message-State: AOAM533pGNorfvKSRhSyqAldb/eQ6sjfLi4LYJGjf0280QxkTGrXDKV4
        Qn6PPiB8ixqHQrGpcC9cX7qWQ73I0crfUYD/BzSH8Afiu8M=
X-Google-Smtp-Source: ABdhPJz38NdXrONJw9a5NP41Ayn20VieAzSgJKm+kA5ulkGKXS7miNCwghIuikNTUAd/29OL/UhWPhb1dqspTRaxzFs=
X-Received: by 2002:a63:6d5:: with SMTP id 204mr6204472pgg.44.1612441920653;
 Thu, 04 Feb 2021 04:32:00 -0800 (PST)
MIME-Version: 1.0
References: <20210201160339.506562-1-tz.stoyanov@gmail.com>
 <20210201160339.506562-2-tz.stoyanov@gmail.com> <20210203152013.21560b32@gandalf.local.home>
In-Reply-To: <20210203152013.21560b32@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 4 Feb 2021 14:31:44 +0200
Message-ID: <CAPpZLN5GK1mz=r_iu9PcLqz+_j_KffYf8e-y+KUzg6fHgCO8Eg@mail.gmail.com>
Subject: Re: [PATCH v27 1/5] trace-cmd: Add timestamp synchronization per vCPU
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Feb 3, 2021 at 10:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon,  1 Feb 2021 18:03:35 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > --- a/lib/trace-cmd/trace-timesync.c
> > +++ b/lib/trace-cmd/trace-timesync.c
> > @@ -22,6 +22,8 @@
> >  #include "event-utils.h"
> >  #include "trace-tsync-local.h"
> >
> > +typedef __be16 be16;
>
> I'm curious to why you added this, because I have a machine that doesn't
> define __be16. I'm guessing it comes from "#include <linux/limits.h>", was
> there a reason to use that?
>
I added it to be consistent with the other messages, defined in trace-msg.c -
for signed / unsigned 32bit and 64bit fields. The other reason is that I used
to define packet's structure in that way in my previous job - to be
clear exactly
how many bits are exchanged over the network.
I agree that that is useless here and will replace it with an unsigned short.

> I really don't see the difference between __be16 and unsigned short. I
> think it's mostly used for static parsers. Perhaps its best to use __u16,
> or "unsigned short" to make sure it compiles on older systems.
>
> -- Steve
>
>
> > +
> >  struct tsync_proto {
> >       struct tsync_proto *next;
> >       char proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
> > @@ -34,9 +36,13 @@ struct tsync_proto {
> >       int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
> >       int (*clock_sync_calc)(struct tracecmd_time_sync *clock_context,
> >                              long long *offset, long long *scaling,
> > -                            long long *timestamp);
> > +                            long long *timestamp, unsigned int cpu);
> >  };
> >
> > +struct tsync_probe_request_msg {
> > +     be16    cpu;
> > +} __packed;
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
