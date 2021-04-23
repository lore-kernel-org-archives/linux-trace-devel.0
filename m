Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86565C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 11:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4227161422
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 11:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhDWLdt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhDWLdr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 07:33:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2CEF61404;
        Fri, 23 Apr 2021 11:33:10 +0000 (UTC)
Date:   Fri, 23 Apr 2021 07:33:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joelaf@google.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Instructions for clock sync for tracing host/guest
Message-ID: <20210423073309.240599e1@gandalf.local.home>
In-Reply-To: <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
        <CAJWu+op2bU+-z6W_+XB0v2g__oGXj8Be2WWDg36E9uaCjNp+HA@mail.gmail.com>
        <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
        <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
        <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
        <20210422153845.3e6e9304@gandalf.local.home>
        <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
        <20210422154830.52f3e4f5@gandalf.local.home>
        <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
        <20210422160313.2eee1f77@gandalf.local.home>
        <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
        <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
        <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
        <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
        <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,

FYI, VMware gave everyone the day off today, so don't expect any real
responses till next week.

On Fri, 23 Apr 2021 04:37:40 -0400
Joel Fernandes <joelaf@google.com> wrote:

> Apologies for the top post as I'm on Gmail mobile and only half awake at
> 4.30am.  I should check but can we just scrape the crosvm PIDs from the
> host trace itself ? The vCPU threads are in scheduler events in the host
> trace. Of course that wouldn't work if we don't have events. Let me know if
> that works for you or if I should find another way.
> 
> By the way if sync is supposed to fall back to the ptp algo, why did it not
> fallback for me?

If both guest and host support an algo, it will use the one that has the
best synchronization (like KVM). If the guest says it supports KVM and the
host says it supports KVM, then it will use it. The question now remains,
did one of them lie? ;-)

> 
> Other thoughts:
> - it would be cool if trace cmd agent was run by the host directly on the
> guest. That might eliminate a step. I can try to see if that's possible
> with crosvm but it's not super high priority.

Not sure what you mean by that.

> 
> Yes thanks for sending me any patches and happy to try.

Feel free to send us patches too! ;-)

Anyway, see you next week.

-- Steve
