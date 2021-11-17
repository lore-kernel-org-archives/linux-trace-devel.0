Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7823BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59ED561B49
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhKQRYD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 12:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhKQRYC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 12:24:02 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD76C061570
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 09:21:04 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id g28so2865088pgg.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 09:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pz3sHAZb/k/7ukv8Aqlfhd3XSU2TOFii898afI3TBQw=;
        b=hNydUx98VzAXvGXh+4hIvxoqTYvNOrv1R1n8AJgKUM12AvrF/P70z8G/fGil4CnX1k
         +RrfyhNwQA2lRMPeXjXNZ8aT/mdiUhNpptxpTvfpsHZGMDoWpLfLysm08OsfWgSOFjs/
         3beYL1DlmR0HrYZ4vZ/uA2fM4fw5nd//YeFt8ntZCraPRdW09AjoRF8j2wV+jMI3TjWJ
         sNqR4d0ztvMVH7J4OfQTL7Sae9/WfcUST5Q0++5+HvXh1r/86KJz09gK+AeDbUpueMMN
         L2QRNyr3Bpa8EZOmmQ7stegzPW8O0pimE+V4el4aqaX8z7/y7NjO9hUvSt1YOq6JRq4o
         FEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pz3sHAZb/k/7ukv8Aqlfhd3XSU2TOFii898afI3TBQw=;
        b=qUlxSADEBbP2xgjWsX4ka5JWNmJkyAqN9L1gPLH6JATACDjw9/wOrT07YoQBZlVyIg
         8Nq4yJF19XhpVXII4+NKbC1Oo20yfgfePxaVnKhff01nQtgxLXcLYF49rYc2TBBkXZEe
         5X3mzHDTimi8CDoIKYPfBmpSOeAb5De2Z6by/qyjKjR9yGmeRX8qVXYQnyG7as84VBpv
         NfB3TdB3da3MeBYur/Lx3CpiABdLuI9bYym0CTy3NKS8VLdgTbHZKZcTJaiTS+YXmXOY
         dbrEnSlJHoEQdAmVtIWJG1YmV0kwkaalzRo8AljD6n/jt67HbrqCXiWSXeqpjJX2TFLt
         GuHw==
X-Gm-Message-State: AOAM532G93CBtYZaA1vGNBWLJlyhoRewVDxoTEeR7GsOrNF91/7pI7rq
        NPz9y5ju/Vf7F6GPeU+b+hV5b571uqZeLgedGOsfWN+E1W871g==
X-Google-Smtp-Source: ABdhPJwjf3/C5kGLlGK5TQKB2pv5MmFHI6kDd1cWQsJMqnnxPs7NwTCog4+nK/uzkEOFZuBWYpV24by+cmLh4KBmRew=
X-Received: by 2002:a05:6a00:16d2:b029:300:200b:6572 with SMTP id
 l18-20020a056a0016d2b0290300200b6572mr49813447pfc.62.1637169663778; Wed, 17
 Nov 2021 09:21:03 -0800 (PST)
MIME-Version: 1.0
References: <20211117154101.38659-1-tz.stoyanov@gmail.com> <20211117121015.55f6e1f1@gandalf.local.home>
In-Reply-To: <20211117121015.55f6e1f1@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 17 Nov 2021 19:20:47 +0200
Message-ID: <CAPpZLN5cm0j2YXaxiBP5+qVWFK3Dgx+NtTdEWnc9+kDPNRe++g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Introduce configurable ring buffer page size
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 17, 2021 at 7:10 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 17 Nov 2021 17:40:58 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > From: "Tzvetomir Stoyanov (VMware)" <tstoyanov@vmware.com>
> >
> > Currently the size of one buffer page is global for all buffers and it
> > is hard coded to one system page. The patch set introduces configurable
> > ring buffer page size, per ring buffer. A new user space interface is
> > introduced, which allows to change the page size of the ftrace buffer, per
> > ftrace instance.
>
> A few of nits.
>
> 1. Even the cover letter should have a category ("tracing:").
> 2. The category is "tracing:" not "trace:"
> 3. These are kernel changes and should be sent to lkml and not
>    linux-trace-devel, as that mailing list is for tooling.
>

Thanks Steven,
I'll send the patch set to lkml when it is ready, it is still a work
in progress. I just noticed that I forgot to remove some leftovers
from my previous implementation in the third patch. It is still not
stable, as the kernel freezes in some cases.

> -- Steve
>
> >
> > Tzvetomir Stoyanov (VMware) (3):
> >   [RFC] trace: Page size per ring buffer
> >   [RFC] trace: Add interface for configuring trace ring buffer size
> >   [WiP] trace: Set new size of the ring buffer page
> >
> >  include/linux/ring_buffer.h |   5 +-
> >  kernel/trace/ring_buffer.c  | 251 +++++++++++++++++++++++++++---------
> >  kernel/trace/trace.c        |  47 +++++++
> >  kernel/trace/trace_events.c |  71 ++++++++--
> >  4 files changed, 304 insertions(+), 70 deletions(-)
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
