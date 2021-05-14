Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5372C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD2086145D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhENNj7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhENNj6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:39:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAB8C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 06:38:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1640597pjv.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 06:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0VELCQIMTUguW4Jw6P38PRZiN5IxtrPFK7lqdxVuz9g=;
        b=PYNMLVBB2kOABa1kMXx9GAA8YbNEj2wfey/Z3LtWrKUxq+09yuZBk5Tzw/WVChE1DI
         R5L1MFacFu8FWFRoQynA8O7Ir7Iz1Y4/eN8WTEGMjREtva0bF65L+sHJ7IrRemhXxsOp
         RVMCumZtqPtVq1Qpznq46OB4f2PHN+g0BQ88g6R2+wyarsde/wl31v1smzb9aAy6FkIR
         JC5oSEtgiRJ5nsa7ZVm4zivE4T1X+nzTMCHJK3m3kHrghr9MrhAr+upZolC9DwAMurEC
         f0CiMqrE+OuN9njvnKSUdnoHws+IGjsNrIRP/brFmjUXAjpL1MkZneYk2SlWuQIw9wdm
         dEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0VELCQIMTUguW4Jw6P38PRZiN5IxtrPFK7lqdxVuz9g=;
        b=Ga7ArfgX7deY2Kk5zAFXAa0M6tz1yGHaK40pCvGYY5B+I9aKM9EHsZ7lQM2UBwOJag
         xtg+XZZUacEiasPQJL52rSMwC0DinqWDdumrng5WwnPQIqPwbJ6h4GDxHIVDVC8m35w7
         4idl0oyRY8738ZAjkvzQsS+8fQE86e5CAPziLNPRtLa4KeiYC3Bn+SxDF2+ui3Lpea2g
         WyIgGOSjgMLmZ9kYDu35YN2QU9QJ96cJ8+7MXK582WzfZ3cQ9h6LKMz69Eqx5cOa+z++
         n8mIheIuV3T1nKbVVjux1Ic5DRq8ilnAErDxgUuf+O401iPPfUsCDZ9nqJLI2Y1FIJv1
         QO7Q==
X-Gm-Message-State: AOAM530gLzHgB/1Vi8s0X1+sOjYDtQgpazW4AHgy3Byklml1XSvEObYR
        Z+HozJjSuCC4JkQapdTTPyb0FwJ/DUtaWacBViTBI2Zh18adTw==
X-Google-Smtp-Source: ABdhPJy/54bDVHGhoAuaqg96BLeD2oMPL20jtI9C/F6gWLhvbgp9j2dW7Zsk6IraJMLYRmBfSV4iEZb6FNry+Tyo2mc=
X-Received: by 2002:a17:90a:db02:: with SMTP id g2mr5923059pjv.2.1620999526006;
 Fri, 14 May 2021 06:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210513204315.1206204-1-rostedt@goodmis.org> <20210513204315.1206204-3-rostedt@goodmis.org>
 <CAPpZLN6p2UgghB16=eqpacica6XEOLuCqTds+SdhFbZkPUZ0Hw@mail.gmail.com> <20210514091205.6b269474@gandalf.local.home>
In-Reply-To: <20210514091205.6b269474@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 14 May 2021 16:38:29 +0300
Message-ID: <CAPpZLN6cBt6aqL1QP9KxC1e8DqB8DWTVeT=5weF6guOvmdM7vQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] trace-cmd: Trace timesync to find pids that map vCPUs
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 14, 2021, 16:12 Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 14 May 2021 07:10:51 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > @@ -3250,10 +3282,18 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
> > >         } else if (is_digits(gname))
> > >                 *cid = atoi(gname);
> > >
> > > -       read_qemu_guests();
> > > +       if (*cid < 0)
> > > +               read_qemu_guests();
> > > +
> > > +       if (*cid < 0)
> > > +               return NULL;
> >
> > This check is not needed. If cid is not part of the string, let
> > read_qemu_guests() to try discover the VMs, instead of returning NULL.
>
> I'm confused. That's basically what the above does.
>
>         *cid = -1;
>
>         if (<cid is in name>) {
>                 *cid = look_for_cid_via_tracing();
>         }
>
>         if (*cid < -1)
>                 read_qemu_guests();
>
> That is, if the cid isn't part of the name, then it will call
> read_qemu_guests().
>
> The second check is in case the read_qemu_guests() fails to find the cid
> either.
>
> What am I missing?

cid is not updated between both checks, it always fails - even though
read_qemu_guests() may succeed to find the VM with that name.

>
> -- Steve
