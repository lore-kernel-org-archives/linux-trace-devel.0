Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD680C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1E0E6127A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhDZPEN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhDZPD7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 11:03:59 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5818EC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 08:03:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p17so3184711plf.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Apr 2021 08:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4VueA4/TuLsYgMJj91KZXQqxmg09Gc2ulT+Ds7Dwjc=;
        b=RKmql+wwxnejNZgL3qXuALWp4fMnOft8q6MXuYzw37Ot76y16t/Gn4P2jRZO/mrKuD
         hOwuZWX2EEHDHHSnDKygRrIaL1iRHhSChkqMAAdddcXFyWsCw5dZ9TBqeb2TLZGsOldH
         JkeFJlYMtz1JMztWMTSxgIoOY6d9HTdF2BgfLSXXaQGqFPN0sMjq7ghoc4ZcddZvTthx
         p0jNgSeqdzPkYUJ25A/MJiX7vL+3b/7UCG1TR8CjNh5LtZn5YRcozJKN2QM3JpX/WnDs
         N0hkh+BOi1sGJ8ZFLAq9+QFfOQpXzXP1RpJp2hsURKcnFEvTMTTrS0wYBgTJa+wSELAz
         P9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/4VueA4/TuLsYgMJj91KZXQqxmg09Gc2ulT+Ds7Dwjc=;
        b=Ze+1pyJeyv1DNfrYx0kiY2MAgAc4F6psYN3+8RiXg3wMTuZ6bRGjGLJIfkPek/Q8lc
         oh/Uz9hxQG4pxjdY71fFQjZd9ZvCcJC69CrjYpJJitmXC5jb1X1miRWfOJk+17mHHDaL
         Ya1pP8iu8EcnX5cYX5x/LWtit/5KuRE+a7aQ51gX9uHHxu1QdM67oTh5lmoyBmjHgNeh
         CshB2zk7ohAmMtI4F19ApmWHAYOWXb5lbK7A7dCdPPgZl+Uv04odejs19VYEgjNTXkFn
         tu0Lf2QY/9fqDrMjXn8jj3uFigArJaj71AA2TJEx3THbMhByYy6OlWiVv6HiLLpPwk1E
         1WOw==
X-Gm-Message-State: AOAM5330B+eDM5cVzBCUFeHAbwZLexv6wOsrAzJrcocZxfgQR2HeVv63
        YF5oJtA/HmAc3RKG3ch6cCrAMm3+h1XcxWt/Duc=
X-Google-Smtp-Source: ABdhPJwoASLguxn6iFFHiYVz1T6NbeDSd7AvTat0Y68sNC9wEbp5pCNWeotOymG1jBVcemnRNz4hJBM5pKPcxCMltcA=
X-Received: by 2002:a17:902:122:b029:e8:bde2:7f6c with SMTP id
 31-20020a1709020122b02900e8bde27f6cmr19388453plb.29.1619449394840; Mon, 26
 Apr 2021 08:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
 <20210422153845.3e6e9304@gandalf.local.home> <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
 <20210422154830.52f3e4f5@gandalf.local.home> <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
 <20210422160313.2eee1f77@gandalf.local.home> <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
 <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
 <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
 <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
 <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
 <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
 <20210426084408.581364d9@gandalf.local.home> <CAPpZLN48S2M33sBR8tV4e1Wr1tHKj9rN0gb52nh3cbX_KBbGbw@mail.gmail.com>
 <af1e4b468e606be535227ae7fe8a1a17d4c019fb.camel@suse.com> <20210426105111.288280bb@gandalf.local.home>
In-Reply-To: <20210426105111.288280bb@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Apr 2021 18:02:58 +0300
Message-ID: <CAPpZLN7q_nQg8A65P4w3OjoN8GiujpCnYwjBJVYbWyLBkb1OHQ@mail.gmail.com>
Subject: Re: Instructions for clock sync for tracing host/guest
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 5:51 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 26 Apr 2021 16:11:46 +0200
> Dario Faggioli <dfaggioli@suse.com> wrote:
>
> > I can't double check as I don't have a crossvm environment handy, but I
> > guess it looks the same, and the PID is the one of whatever task in
> > crossvm issues the KVM_CREATE_VM ioctl (and the fd returned by such
> > call).
> >
> > In QEMU, such process then creates one thread for each vCPU... Again, I
>
> I'm sure all implementations will do the same. Anything else would not make
> sense.
>
> > don't really know for sure, but I guess it would be similar in crossvm?
> >
> > If yes, AFAICT, kvm_entry events can tell us the PIDs of such threads.
> > So the challenge here is getting from the PID of a thread to the PID of
> > the process that created it.
>
> As I stated in the other thread, we can find the thread that is running the
> vCPU by following the wake ups. A vsock connection will trigger a series of
> events that will eventually wake up a task that does a kvm_entry. Then you
> know the thread.
>
> Here's another run:
>
>     vsock-client-160552 [001] 403952.847983: sched_wakeup:         vhost-128994:129046 [120] success=1 CPU:003
>
>     vhost-128994-129046 [003] 403952.848030: sched_wakeup:         CPU 0/KVM:129042 [120] success=1 CPU:006
>
>        CPU 0/KVM-129042 [006] 403952.848085: kvm_entry:            vcpu 0
>
>
> We see that our process (PID 160552) wakes up 129046 which then wakes up
> 129042, which does a kvm_entry for vcpu 0. Since process 160552 is
> communicating with the guest, we know that this series of events will wake
> up the guest we want to map the thread and the vCPU of the guest with.
>
> As it was thread 129042 that called kvm_entry, it's the thread that is
> mapped to vcpu 0 of the guest we are tracing.

For a complete mapping, some handshake logic should be implemented -
to force the guest to use all its CPUs, and to ensure we have the
mapping for each vCPU.
The other approach could be to look in /proc - the relation between
KVM thread 129042 and the VM process is there.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
