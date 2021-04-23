Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B001C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 15:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321CE613E1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 15:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhDWPua (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Apr 2021 11:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhDWPua (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 11:50:30 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CFBC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Apr 2021 08:49:53 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id u8so36632739qtq.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Apr 2021 08:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eeu8xMGkdnS5HMwLj7trKy/RiVMahP7x1qhJLmXfrkE=;
        b=gGnivacxU9bYFNLSoVNiwDhslkTDUXNGWaZmgrJYicbXsmgycvMU7jUu3ZrjwVPsct
         pHuy2oeJSA6Fnj9ZQVeyAk4vdHx/bMpE4kPl4R//UF2nScaZ6DYYKMCzE+HkmbABSALX
         D+eRImw0TAZgaGtJ/DwOZoygCtEqSnIAJBUIcsxzK1vTPix+GWmAqEHfr4qqO8vNwSlZ
         KS+SyQhAZkojh7CpRCixujHRvPX24Stba4H77HuiN1XIhQX5VSjUQfrLB5Xz9wD4OdAU
         SIiJWpvowz6V2FCiuAE3xVeCk7oHkIdV+5m5BapAY6L6sASfuPypZKtuT8maNdaa2jdY
         zNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eeu8xMGkdnS5HMwLj7trKy/RiVMahP7x1qhJLmXfrkE=;
        b=LbWis7mB2QpWscoaDnVEleza6tqBH6Iw0AYWDzstiodxnGhkQwASuvh9aV24VfVw3M
         JUCVe6gQ3TPGhp+NpcrixB/cgNxiMatvyPBgLOs8tdDQffvedpahKgUdvJ4R3qkczPiw
         kLNoGjjQ/LiEbBiesM8c7LyJlTRYR/4p+vPPhFOUe6MJHpPHth/2TE/tIflkxIKJFAOt
         mpBrhhVEY0cax77OY/v/7OH8Bg0T4SpqWVh6o35zr8uKXuRm20DD73GUtTNsuZTRkWh1
         N57/Xa2zgyVCLtIE1KpWm2weTqTiWyAGRd0QDRGvMIph7E5eLZY3j9UzvoqwE6zZwVtT
         xxLQ==
X-Gm-Message-State: AOAM531X5kRqq/TDi+8kY9PL3QZZChFV+mgIf5dUlgoybxY2B+CSlBQ9
        n1qDQtLULA31c4tac1Dza+0ybd0zbO/sSVsY5F4mdg==
X-Google-Smtp-Source: ABdhPJzN6diwL1uiaHNXB755M2hR/E8WFK02dS3YR2XPBxByHtOBTMSklV9X0UYXorzf0/hXpTkjdgdFdJ17YUkof2k=
X-Received: by 2002:ac8:7766:: with SMTP id h6mr4466057qtu.258.1619192992858;
 Fri, 23 Apr 2021 08:49:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
 <CAJWu+op2bU+-z6W_+XB0v2g__oGXj8Be2WWDg36E9uaCjNp+HA@mail.gmail.com>
 <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
 <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
 <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
 <20210422153845.3e6e9304@gandalf.local.home> <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
 <20210422154830.52f3e4f5@gandalf.local.home> <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
 <20210422160313.2eee1f77@gandalf.local.home> <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
 <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
 <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
 <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
 <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com> <20210423073309.240599e1@gandalf.local.home>
In-Reply-To: <20210423073309.240599e1@gandalf.local.home>
From:   Joel Fernandes <joelaf@google.com>
Date:   Fri, 23 Apr 2021 11:49:41 -0400
Message-ID: <CAJWu+oo530LmZ6S4eEodQXW=j2uRf7ccwEL55XUYzxUHqBo_Mg@mail.gmail.com>
Subject: Re: Instructions for clock sync for tracing host/guest
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 23, 2021 at 7:33 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Hi Joel,
>
> FYI, VMware gave everyone the day off today, so don't expect any real
> responses till next week.

Got it.

> On Fri, 23 Apr 2021 04:37:40 -0400
> Joel Fernandes <joelaf@google.com> wrote:
>
> > Apologies for the top post as I'm on Gmail mobile and only half awake at
> > 4.30am.  I should check but can we just scrape the crosvm PIDs from the
> > host trace itself ? The vCPU threads are in scheduler events in the host
> > trace. Of course that wouldn't work if we don't have events. Let me know if
> > that works for you or if I should find another way.
> >
> > By the way if sync is supposed to fall back to the ptp algo, why did it not
> > fallback for me?
>
> If both guest and host support an algo, it will use the one that has the
> best synchronization (like KVM). If the guest says it supports KVM and the
> host says it supports KVM, then it will use it. The question now remains,
> did one of them lie? ;-)

Good question, will try to debug and see what each said.

> > Other thoughts:
> > - it would be cool if trace cmd agent was run by the host directly on the
> > guest. That might eliminate a step. I can try to see if that's possible
> > with crosvm but it's not super high priority.
>
> Not sure what you mean by that.

I meant that currently, doing "trace-cmd agent" in the guest is an
extra step. I'd rather the "trace-cmd record" on the host spawn the
agent within the guest somehow, thus eliminating that extra step.

> > Yes thanks for sending me any patches and happy to try.
>
> Feel free to send us patches too! ;-)

Yes, certainly. My first attempt was to see if I could hit the ground
running with my VM problems, if trace-cmd was in sufficient shape.
Looks like trace-cmd is almost there and happy to help with the best
of my ability to write any patches.

> Anyway, see you next week.

You too, thanks,
-Joel

>
> -- Steve
