Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545DDC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Oct 2022 18:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiJFS5u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 14:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiJFS5t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 14:57:49 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD37B56D4
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Oct 2022 11:57:48 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id 187so1987725iov.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Oct 2022 11:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4abBxmilnG9CHIPb2Jiwd4JKFd7dVVP/iLv1VG+66VQ=;
        b=yN/fz5EATtP0kAf/m1iFXSVC+zGihvBM9vd873ZhZ0y8meTbk84nCW6uajTDqM5Tm7
         JrRWXh263rJchC2LGAlB2ytgQIGAbj34ZF2UcAiy6NxD8TW/fEXfjqIfrRg8Z5KX7mOi
         guG4kQPdMy/sctUMcYTEfY9uYvyAtLKFgqPG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4abBxmilnG9CHIPb2Jiwd4JKFd7dVVP/iLv1VG+66VQ=;
        b=PWcMRNv8csTPz0wL+bzfhD+hvod7IglxFLyVOQdm5VA9/pRQVfmvA3fVDM0mgyGPqz
         sH51rIh7BMOK2VwU2hkf4u6Z1+J9bEohjl6CIZyb9ID7uaUnR1OqXi5+u0kq0uIoMtbx
         b/VxZ/vF3YRMp++VjtZhiiPDXDtpSKa22XYMsJnBDaPm2NTq66ZNtgTmaek1xQni01p4
         Nm1FUbGikGA7aiNGb2OuDvjM5FOr6GoI4Yq8wK6qrKxprvj3yUMhYF7yKZ10ANN8+xyT
         PD2ZeAwo2NO11AE21yJ0J04noiP/UjKQWpjCe3TzXP2/SbCMEq/+Cp50RQCYf1iLbT7H
         c++g==
X-Gm-Message-State: ACrzQf2NVDUW8I9ucY35/Z/1PXfRUVv45r/aXA1S/6afsYBudbimo84i
        7/u3XkJqEk/7cZhp7Nhl1KXmgUBaYd6ItELviXKV8bszHkA=
X-Google-Smtp-Source: AMsMyM6Qi3tAUZvgg6JaChg5NTyxVw13s+H2Ktru0xucyq5LwHGzsXZij24DzolOsjfjbFnXPSFxyFoedHPLG53UV6I=
X-Received: by 2002:a05:6638:2393:b0:363:6c5d:9584 with SMTP id
 q19-20020a056638239300b003636c5d9584mr605826jat.232.1665082667530; Thu, 06
 Oct 2022 11:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAEXW_YRUty_YEkUXwSP_v0NHb6tC_tCFavYNze5kBiAuMmKz9w@mail.gmail.com>
 <4e5cadcb-9e15-cc2a-db4d-8f749f654723@redhat.com>
In-Reply-To: <4e5cadcb-9e15-cc2a-db4d-8f749f654723@redhat.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 6 Oct 2022 14:57:35 -0400
Message-ID: <CAEXW_YQvdFFhWvLcy46UhjkCwv4cYQ23Z-Mk0v_RGD=+aWD53A@mail.gmail.com>
Subject: Re: Runtime verification for instances
To:     Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Oct 5, 2022 at 12:07 PM Daniel Bristot de Oliveira
<bristot@redhat.com> wrote:
>
> On 10/3/22 22:35, Joel Fernandes wrote:
> > Hi Daniel,
> > I was thinking about your RV for a recent problem.
> >
> > Basically, we want to check for state transitions on a per-RCU
> > callback basis. For example, we want to verify that for certain types
> > of RCU callback, there is no chance of a scheduler wake up happening
> > (provided such wake up happens for non-hardIRQ context).
>
> ack.
>
> >
> > This means every RCU callback in flight needs its own automaton which
> > is created when the callback is queued and destroyed when the callback
> > is executed.
>
> do you have a "structure callback?" or could attach some extra info into it?

Unfortunately no, we have rcu_head but the idea is to do this without
having to grow it.  In theory, you can do this with a hashtable
maintained by RV and use the callback function as key, with value
being automata.

> There cannot be a single global automaton. And we have to
> > make transitions for different automaton depending on their state.
> >
> > I bet you have already thought of something like this for tasks where
> > you need a per-task automaton instead of a global one for some use
> > case which requires tracking each task separately.
>
> Yep! we do have per task monitors (already).

Nice. This depends on growing task_struct though right?

> > We can implement this in RCU itself, however it will be ugly due to
> > CONFIG options. And also we cannot do it easily in production. On the
> > other hand, with RV, we could simply have RV watch the tracepoints and
> > verify them. It will be clean.
>
> So, I am not sure if I got the problem here. So, you are saying that it will
> be easier with RV. Right?
>
> If you need one monitor (automata) per task, we have support for it already.
> If we need "another type of object," we can add.

Yeah I was hoping that with RV, you could already allocate a new
automata dynamically or something for a new task/callback/whatever,
and then drive that automata using tracepoints. So RV can be a nice
place to do this kind of stuff, without adding debugging code to other
subsystems.

> > This is just 1 usecase (wakeup) , we also want to extend something
> > like this to more things, like making sure callbacks execute in a time
> > bounded fashion.
>
>
> I know verifying temporal properties doesn't directly
> > fall under RV,
>
> temporal or order or temporal of time? For temporal order yep we have it (I
> se an overload of this term here... haha). For time, we can add additional
> structure to transform them into logical events.

Yes, sorry I mean time. So time from when callback queued to when it
is invoked falls within a bounded time period.

But more urgently what we need is:

For a certain type of callback that is invoked, check if the callback
does a scheduler wake up. That is - doing a wake up when this type of
callback is called is a BAD state.

This can be done purely using tracepoints:
- We have to add a new tracepoint to call_rcu() for the new callback
type (the type being Lazy).
- We have to add a new tracepoint for when callback invocation ends
(for invocation start, we already have trace_rcu_invoke_callback).

Then hook up RV to all of these, and verify that no scheduler_wakeup
can happen during the invocation of a Lazy callback. But it has to be
done on a per-callback basis.

On the other hand, we can simplify it to a single automata by setting
a per-cpu state for whenever a Lazy callback is invoked. But the
problem is we have no idea that a callback is lazy when we are
invoking it.

Thanks.
