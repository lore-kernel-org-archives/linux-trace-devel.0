Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A2FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 999B760FE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhDZKkc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbhDZKka (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 06:40:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68312C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:39:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso5055369pjn.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hbcGm9yP/l1ceyv981q4r939OKrZfoq0KrbYO/xuRyo=;
        b=jLWSblEYAQJMytvYGxTHgNbo4TYweG1GlBSQI8eRi1C26qlxrjBRyuFctbyltPDcvn
         R2Syzl+cEbaZMC2UJEmW+E3HldBAoHuQNWpcjDZ8ZYKQt10aaGmrgqgBeVSzpkbbRlJ9
         0DNmBstnHpw1dbJNHMvU14g0XFN2ejO7m97qUgiOPvoAMQK2DSt2WpppJGikkMKhy1Th
         obd2Hx6s0KfKNporsRU+XwZLQ4rxMZN/GMN0pWXXroCdfgpIHWnkkajaMOmkOEUe4C6/
         O23WM4N4BdcWH/24JwfK3Zvzhl9ifNSppd54Q2gGbzsWd9DJbnOfnGOxLFnlY2UVPNkl
         bS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hbcGm9yP/l1ceyv981q4r939OKrZfoq0KrbYO/xuRyo=;
        b=FllWl+isG6wQ3y3n6J8f31NwLirkH1h5sIm+cTH1s/WYaMNr9aV9OEUoq4a7k4vYbz
         kIig8/95bO0MqlUE/7avTuvx7nLmdprbyEcdyTLaDRSWVx91ZbchkWkJ7lUkQd1rlT0o
         b6tqroSbibHnU9xdjgHo1fcO3ZY0MLHaAnnKREPRFoSI//Gf8c+r5Q9HyiLrCOEkRG7T
         hzKF6s2SzFPzT2zE6sFNmaCzYghNg/H33UfQqzgDX3YfI9U3uhvJq7Y4jeNcW0PswAEA
         UgScU/qrnuQ+h1yHOQ/Hq+zB5mVnE290SPeaVzFrhcEY8KzFYYiCACTKF5oKyTsqm1ik
         P9ig==
X-Gm-Message-State: AOAM531oZB505aTASAA0iflgLxqjOWemUg/jRBEXzGeMbIetfgxQmmzQ
        9T712euDEfDcEbX0gTWpipXKZfpvViWYVC9nFxuYe+MhVLk=
X-Google-Smtp-Source: ABdhPJz7hHQX8sp4s216uLlqZOmCaG1P99Qzo+ZuLAvVofkT59E8TbLvDHjxqh6LgoX2FtrkjcXdF/oY/Jq5PeZUhlM=
X-Received: by 2002:a17:902:ed42:b029:ec:a711:25c7 with SMTP id
 y2-20020a170902ed42b02900eca71125c7mr17538561plb.58.1619433589028; Mon, 26
 Apr 2021 03:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
 <CAPpZLN7=e+TL5WY7RKAo9Hm6AJGDygneqUWwoNnZexx+=KrxsQ@mail.gmail.com>
 <CAJWu+op2bU+-z6W_+XB0v2g__oGXj8Be2WWDg36E9uaCjNp+HA@mail.gmail.com>
 <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
 <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
 <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
 <20210422153845.3e6e9304@gandalf.local.home> <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
 <20210422154830.52f3e4f5@gandalf.local.home> <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
 <20210422160313.2eee1f77@gandalf.local.home> <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
 <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
 <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
 <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com> <20210425142935.52078301@rorschach.local.home>
In-Reply-To: <20210425142935.52078301@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Apr 2021 13:39:32 +0300
Message-ID: <CAPpZLN7hhypY6+s5R+JX1u2e9Typ-1O1yC9mDoEcRYKLHYGFNw@mail.gmail.com>
Subject: Re: Instructions for clock sync for tracing host/guest
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Apr 25, 2021 at 9:29 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 23 Apr 2021 11:16:50 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > Currently we collect that information from quemu, is there a way to
> > get it from crosvm ? If yes, a crosvm support can be implemented in
> > trace-cmd. But as I said, it is not mandatory to have it for the
> > trace, I can send you a patch next week addressing this gap in the
> > implementation.
>
> I think we should be able to get the above information during the KVM
> timesync logic. The host can enable KVM events (specifically
> kvm_entry), and that should give use the pids.
>
>  # trace-cmd record -e kvm_entry ssh guest taskset -c 0 ls \; taskset -c 1 cat /etc/passwd
>  # trace-cmd report
> [..]
>            <...>-129042 [004]1122452427093922: kvm_entry:            vcpu 0
>            <...>-129043 [005]1122452427148178: kvm_entry:            vcpu 1
>            <...>-129042 [004]1122452427150380: kvm_entry:            vcpu 0
>            <...>-129043 [005]1122452427201498: kvm_entry:            vcpu 1
>
> There, I see the guest vcpu 0 is controlled by the host thread with pid
> 129042 and vcpu 1 is controlled by host thread pid 129043.

It works only in case of one VM, if there are more than one - cannot
map kvm_entry event to specific VM.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
