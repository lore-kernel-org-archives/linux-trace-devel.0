Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6105C04A68
	for <linux-trace-devel@archiver.kernel.org>; Sat, 30 Jul 2022 04:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiG3EEz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 30 Jul 2022 00:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiG3EEy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 30 Jul 2022 00:04:54 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2314B0F5
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 21:04:53 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id b4so1245717uaw.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 21:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSJKCrj8nZMqhn3RaqJbdynnI8UqbPRqF0F2w1RjrE4=;
        b=HJFkRqWuM47bkQOqPFjYR1JAH+ehXK743ycO2fnpRRZIZmj0bGGw5fPoQf9So1Ql4b
         onQP5Io4fxOrsuFE2CuXKFVhJXVjgCXQFOgkcyYHrKr5R5yncbRxkM+GOnVjIXW06TAD
         sL7FFNK6MGecnSlG4S0giOzecgwGOjHtzoQDEHMLxcZH0WGkvwXtT05+sAhV8kAwnq5q
         DVZQYV5q3Kf2SH61I8lF5HoHmIuCEatgWCcL7pdSxn/kXjRe3knbXQDqJ4L4MsKQWITq
         009qhS89kXt15InWC0XsjE8t+ICI9ICA1vLmiie32sicUOM+c+uugKT4NddwWPpFFlpI
         Uo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSJKCrj8nZMqhn3RaqJbdynnI8UqbPRqF0F2w1RjrE4=;
        b=v3C2clIU/5Uv8ldvNh2XqJp1X/TIpSKF02POfvt0ydoY1g+gYGwzVr8nr1Ya35oMjU
         vO5S0AwgGXPDkkK8pfPwciOGvJ4+s9uBCZYlvp3hdWJ4IroD3FBy3U5oy8ztx/DVtwW9
         8cWc/B7WmzzuOAnVHF+LV8/1/i9pHX9EX3YSwqpyGmqpW2nGkPrarOw69LvnBOdE6o6G
         NP5E698moVLNouQ5+/6yKytyFVEOXB6gag2NZiRE8OGXT0u836DSIf8A4aj6/bzOJ4Ht
         kgEq1xF7YOkbDhVTPP/Rfqrquf30NIuUIcKN4R5vGRI5QdM3n8uTGF7tVZjVl6u8/jKs
         bDKg==
X-Gm-Message-State: ACgBeo3hbk/gIl+SLoAT+Lm0mZtbx/L0Am35V/jepE4Apsl9rqepV1s8
        nqSp98sQdRbrKVpk4ZAveTasMNIbxu6/EnTHkOjKokCQ
X-Google-Smtp-Source: AA6agR5XTRXX/EhO414n17mz8ZJggy+8KLmqZh6IVYC3TTDSPZ6gHULQK+76kTVF+GOchebXmwF8v4XHUj2PxQDGi/Q=
X-Received: by 2002:ab0:7c61:0:b0:384:e1e7:2ead with SMTP id
 h1-20020ab07c61000000b00384e1e72eadmr2648381uax.111.1659153892795; Fri, 29
 Jul 2022 21:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220729040116.175015-1-tz.stoyanov@gmail.com>
 <20220729165048.77f03fc7@rorschach.local.home> <CAK-6q+g2q4drxRC=5075Oy2Qh2C1pszF9fC1gRi0O90JJ49YPw@mail.gmail.com>
 <20220729205438.7c1932dd@rorschach.local.home> <CAK-6q+gEZLi0tGCrvbPavQuKESBBzYRNxsQMr=upY=6384ZhyQ@mail.gmail.com>
In-Reply-To: <CAK-6q+gEZLi0tGCrvbPavQuKESBBzYRNxsQMr=upY=6384ZhyQ@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Sat, 30 Jul 2022 07:04:36 +0300
Message-ID: <CAPpZLN5V2av1Y34p1bBxxuZzRNkKDx957rPtv96yyeOd+0yJqg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Do not use instance from trace context
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jul 30, 2022 at 4:00 AM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Jul 29, 2022 at 8:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri, 29 Jul 2022 17:48:08 -0400
> > Alexander Aring <aahringo@redhat.com> wrote:
> >
> > > >
> > > > Bah, I kept getting confused by when to use instance vs ctx->instance,
> > > > and I guess I messed this one up.
> > >
> > > I tested it and it seems to fix the problem..., so if it's not to late:
> > >
> > > Tested-by: Alexander Aring <aahringo@redhat.com>
> >
> > Not too late. I haven't downloaded the patch from patchwork yet (nor my
> > other patches).
> >
> > >
> > > I am not sure what I should expect from the PTP time synchronization
> > > over IP capable interfaces (it never worked for me) but I need to say
> > > it is significantly slower than kvm time synchronization with vsock
> > > and I am using only virtual interfaces. On the agents I get a couple
> > > of:
> >
> > Well, kvm time synchronization doesn't do much between the host and
> > guest. And I'm looking at making it do even less. That's because the
> > kvm synchronization is just "read the offset and shift of the guest
> > from the host and do the calculations via the reader (trace-cmd
> > report or kernelshark)". But the P2P is sending packets back and forth
> > between the host and guest and trying to figure out the round trip
> > latency.
> >
>
> okay. To be more specific it took about ~20 minutes until I saw the
> "Press Ctrl-C to stop recording..." message for 3 agents. Is that
> normal?

It doesn't seem normal, usually takes less than a minute when I tested
with 2 agents (VMs running on the same host). PTP works by exchanging
a lot of packets over the network between the host and the agent, so
it depends on the network and on the guest. Currently the PTP logic
works sequentially - one agent at a time. That could be optimized, the
agents can be processed in parallel. But definitely 20 minutes for 3
agents (~7min per agent) is not normal.

>
> - Alex
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
