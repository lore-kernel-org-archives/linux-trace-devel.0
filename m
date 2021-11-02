Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A08CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 04:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4614560F36
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 04:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhKBEg2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 00:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhKBEg1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 00:36:27 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D36CC061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 21:33:53 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 75so19078606pga.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 21:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1r/J0ozStDdxR74HyCNtv4M6tLoxJ8YY5aepGrnfFto=;
        b=NhgSP04PggCtD2NSAEYE7FE0YZrWof5CR+CoMVZuiFXltIYF72itFyTEDovUj/x4DY
         hNhfTMTMm/QsYckUsLJ3Pe3uhy4XjNInKmPN0/Awk+XXhGjRJNOoUmE+NyoFDKp83sNx
         OmirkLMJS8FqqE0BJCPKK36jEsoyI+3Fcp4F799aKk5HL4Dvub4MZzk3E3nkDV/vMs37
         L2fxiNTomT/8VdVBK5WUTcH2TxxpYqNwutXUpTnPmy3fGUoNL1TFLp8XW1Rf+LeJiYb6
         z2mdgQFYyTij6P989I9/faAF0QPUEEQpxw3i6h3VbP3zeOjnA7QcRIZw2nc1Fwoqpi2T
         qZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1r/J0ozStDdxR74HyCNtv4M6tLoxJ8YY5aepGrnfFto=;
        b=eiuKUCxWR9ECxpuGaIuR+tQmtJarudsGZRhqH81apbqhsphh4kScEAgpcj7dGTW5k5
         rVN0kqIuSIOf450IVciMRILkaLOaBve7aB89fmH5zTtNiV9zGnnY82HrO4tR7bK1lSek
         Ec8KldYq7iuMlrmHSmNtUBkCGzDAl08YGo6VKtxNnhx74ieFpuBxRPqy11H726jtUL5U
         v64RMXKQR63nd0VnpQTCDPGtAHwbeCXbYwJpgpjttc5sF5fKgKEqReTDiW8lhsQwcchK
         TQR4Kt1EqkHhHEyfJnah548Ys0TCi9nG19lSSEHpCgZuWZunbSf0h8zi79v5DFXOsw1r
         /3mw==
X-Gm-Message-State: AOAM5328ahzS7c9874TN3MOfgz/xFn1VaF7r/Iu2XWl8kdB4Ldi/NmDE
        kvhhbqx5w3e8LEwqjpLAWU3/F/ahKgKCuXpLTOM=
X-Google-Smtp-Source: ABdhPJxGM3wActszPc1zYfNBhra0xgay49cLFtdynHoChEN4L8EbD1N0l2IuYOumNQgUOhUivS8kvhG10orZNI3P1nM=
X-Received: by 2002:a63:374f:: with SMTP id g15mr25923223pgn.193.1635827633027;
 Mon, 01 Nov 2021 21:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211101090904.81454-1-tz.stoyanov@gmail.com> <20211101090904.81454-2-tz.stoyanov@gmail.com>
 <6eb04d9b-54f5-77a6-1be8-adea54e710cf@gmail.com>
In-Reply-To: <6eb04d9b-54f5-77a6-1be8-adea54e710cf@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 2 Nov 2021 06:33:36 +0200
Message-ID: <CAPpZLN58N_B+WjoDHbSnD0xG-s6tOY49SdKFHNqohzPUVKybZw@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] libtracefs: Add new internal APIs for dynamic events
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 1, 2021 at 7:06 PM Yordan Karadzhov <y.karadz@gmail.com> wrote:
>
>
[ ... ]
> > +
> > +#define DYNEVENTS_EVENTS "dynamic_events"
> > +#define KPROBE_EVENTS "kprobe_events"
>
> A definition of KPROBE_EVENTS already exists in /utest/tracefs-utest.c and src/tracefs-kprobes.c
>
> Isn't better to move the whole group of definitions of filenames to include/tracefs-local.h?

The unit test should use only the official library API, defined in
tracefs.h. We could move these defines in the official API header, but
I think these should be internal to the library.

>
> Thanks!
> Yordan
>
[...]



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
