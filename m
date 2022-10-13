Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD70C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Oct 2022 16:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJMQTq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Oct 2022 12:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJMQTo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Oct 2022 12:19:44 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB7D2641
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Oct 2022 09:19:43 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id d142so1754529iof.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Oct 2022 09:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lxrr7eC/LyToJSNNw20VLBongKPfOv+iobYu92J1PW8=;
        b=Wt1XFEdW+9s0py8Ox71qE187ZwrXnJC4A2aimsVnnKngdgHT/hq/dwNKRRfKm28pVv
         94Uh/VPpPaDV2WLi/RAhk1qQB1/A8vtW2fjqHS49yYNew4b154ptQ/7l6osHCrHDSKpa
         Kn/mDinWo8OFQZag8JyeYAlG31/iSXwSIZra0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lxrr7eC/LyToJSNNw20VLBongKPfOv+iobYu92J1PW8=;
        b=GVu7xt4hgBGZawNTnDGX1dJgXpbcY35bbsaDhRrUUc9DyFRj0b2+b1OuY6c7m4D3Tt
         lzxWRyOb5W0SVwdAbD4W0VFA/ZWzf3/XenyCQ16W4jWprO4Qmu3qUXJ0jLeHoERdSf+Q
         zciJ+wf2c/n45+zhzpxYUohJusS+CqqFn4wtms5j6g0SrdNZVJipwL2W4kcppR8GTk34
         ndYWYkKj8X7NVDohCcLFPFLt33idSE40ey3OE/SQZy9ZYzOK2/7sE4DRjZXcOxuEZ13G
         tKZugNjWgnEo9uml/hwJc07VuyA15w8BR5ECe5F20YNgbP/8/RVWYVlGEgpbB2lncXAq
         ixvA==
X-Gm-Message-State: ACrzQf1b+/AwDNU9jw9JAGTeuiBAbXPe7zozTbCtd13S26/53bK4IfJQ
        raDr0dE8kooFdbMumY6vR8913EBAf1m/rUdimlFoXA==
X-Google-Smtp-Source: AMsMyM7eg2HCw1b/EruyZUNHGGCOWJWHRftOAwMmw9oN+mr8pKxN1EZTzE///qx+yCu43sdx+8J+cZfpg1NI68goxe8=
X-Received: by 2002:a05:6638:40a2:b0:35a:bd14:1a31 with SMTP id
 m34-20020a05663840a200b0035abd141a31mr449431jam.107.1665677982641; Thu, 13
 Oct 2022 09:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAEXW_YRUty_YEkUXwSP_v0NHb6tC_tCFavYNze5kBiAuMmKz9w@mail.gmail.com>
 <4e5cadcb-9e15-cc2a-db4d-8f749f654723@redhat.com> <CAEXW_YQvdFFhWvLcy46UhjkCwv4cYQ23Z-Mk0v_RGD=+aWD53A@mail.gmail.com>
 <51ed39ae-92c9-bc41-4ad4-05e4568b74b6@redhat.com>
In-Reply-To: <51ed39ae-92c9-bc41-4ad4-05e4568b74b6@redhat.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 13 Oct 2022 12:19:31 -0400
Message-ID: <CAEXW_YRUxg=N9GhQWqHR4JdNn=fMP07-NU7tpxcJAqB+Zh17hg@mail.gmail.com>
Subject: Re: Runtime verification for instances
To:     Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Oct 11, 2022 at 1:01 PM Daniel Bristot de Oliveira
<bristot@redhat.com> wrote:
[...]
> >>> This means every RCU callback in flight needs its own automaton which
> >>> is created when the callback is queued and destroyed when the callback
> >>> is executed.
> >>
> >> do you have a "structure callback?" or could attach some extra info into it?
> >
> > Unfortunately no, we have rcu_head but the idea is to do this without
> > having to grow it.  In theory, you can do this with a hashtable
> > maintained by RV and use the callback function as key, with value
> > being automata.
>
> right, a global hash table? per-cpu? per task?

Yes, global hash table.

> >> There cannot be a single global automaton. And we have to
> >>> make transitions for different automaton depending on their state.
> >>>
> >>> I bet you have already thought of something like this for tasks where
> >>> you need a per-task automaton instead of a global one for some use
> >>> case which requires tracking each task separately.
> >>
> >> Yep! we do have per task monitors (already).
> >
> > Nice. This depends on growing task_struct though right?
>
> We have it there already. If we need a per-task "aux" data we can justify adding
> a pointer to a priv data. Note that I was already foreseeing this.
>
> For example I will likely use it to monitor sched deadline tasks (I need
> additional data to track the task from the monitor point of view).
>
> Note that this will be available for *any* monitor so, not something
> only for your use-case.

Yes, I was suggesting though that if you have a global hashtable, then
you do not need to grow data structures, you can map the "task_struct"
pointer to a data structure directly. I shared a patch [1] where I do
this and use tracepoints, I would like to convert this patch to RV.
Can you try converting it (or convert it to pseudocode first before
real code) ? You can see the trace point probes where I am checking
for the state. This is a great RV usecase :)

[1] https://lore.kernel.org/rcu/20221011180142.2742289-1-joel@joelfernandes.org/T/#m74a3a95ae288e79e5455001f6dd5510a591992df

> >>> We can implement this in RCU itself, however it will be ugly due to
> >>> CONFIG options. And also we cannot do it easily in production. On the
> >>> other hand, with RV, we could simply have RV watch the tracepoints and
> >>> verify them. It will be clean.
> >>
> >> So, I am not sure if I got the problem here. So, you are saying that it will
> >> be easier with RV. Right?
> >>
> >> If you need one monitor (automata) per task, we have support for it already.
> >> If we need "another type of object," we can add.
> >
> > Yeah I was hoping that with RV, you could already allocate a new
> > automata dynamically or something for a new task/callback/whatever,
> > and then drive that automata using tracepoints. So RV can be a nice
> > place to do this kind of stuff, without adding debugging code to other
> > subsystems.
>
> We can make a dynamic as well, as long as you can allocate memory in the point where
> you identify a new "instance," it would work.
>
> Monitors are pretty self-contained, they can do their magic.
>
> We can figure out a possible way.

Cool!

> >>> This is just 1 usecase (wakeup) , we also want to extend something
> >>> like this to more things, like making sure callbacks execute in a time
> >>> bounded fashion.
> >>
> >>
> >> I know verifying temporal properties doesn't directly
> >>> fall under RV,
> >>
> >> temporal or order or temporal of time? For temporal order yep we have it (I
> >> se an overload of this term here... haha). For time, we can add additional
> >> structure to transform them into logical events.
> >
> > Yes, sorry I mean time. So time from when callback queued to when it
> > is invoked falls within a bounded time period.
> >
> > But more urgently what we need is:
> >
> > For a certain type of callback that is invoked, check if the callback
> > does a scheduler wake up. That is - doing a wake up when this type of
> > callback is called is a BAD state.
> >
> > This can be done purely using tracepoints:
> > - We have to add a new tracepoint to call_rcu() for the new callback
> > type (the type being Lazy).
> > - We have to add a new tracepoint for when callback invocation ends
> > (for invocation start, we already have trace_rcu_invoke_callback).
> >
> > Then hook up RV to all of these, and verify that no scheduler_wakeup
> > can happen during the invocation of a Lazy callback. But it has to be
> > done on a per-callback basis.
>
> So, let me see if I understood:
>
> You have a Lazy callback, and you know it is lazy only at the call_rcu time.
>
> Then when you start running the callback:
>         no wakeup if it is of the type lazy
> until you finish the execution?
>
> > On the other hand, we can simplify it to a single automata by setting
> > a per-cpu state for whenever a Lazy callback is invoked. But the
> > problem is we have no idea that a callback is lazy when we are
> > invoking it.
>
> Wouldn't a global hash help for this?
>
> per-cpu monitor + a global structure that is feed at call_rcu time?

You can have multiple callbacks in flight, and others getting invoked.
So automata have to be per-callback AFAICS. The callback can be queued
and invoked on different CPUs, and there can be multiple such ones.

Thanks!
