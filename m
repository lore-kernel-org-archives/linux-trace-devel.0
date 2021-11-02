Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69061C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 04:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4881560F0F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 04:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhKBFBo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 01:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhKBFBo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 01:01:44 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E2CC061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 21:59:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s24so14163611plp.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 21:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxTm2+V2It9hBxYx5V0LuwYG/ujzb+k3pZXTG6vfDo8=;
        b=HLZa49p+0lU0FPfSrpM1ODIy/6txsNQKAiYh2OTx6mzrro37M17eS6PRXeC5ZTsT6v
         Ay9lIJCZ+yK2lxjAitsjwrB5F5C4Fs/R8CVxE3NlpIDuCmYBwZmYMSFFQhcSHH15u9O/
         byN/coBsNsFgssf08lsf9DUQCS7aGLbMPnU1UzozvCPxovEce5cWA352n4tdR+SybTbn
         xPT7BT9FQKKXE1xS0YzHlJkx8J5HCTOLinUvNwWkbnY5IKNqp5SRo8V3ANPwMpeJcw81
         MzBYGr+ed11JqcpNr3Rha9Zpv7Egd7VzCCjbR/7naCrBYMbemqMDyBETBEfoOkmgjONB
         MYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxTm2+V2It9hBxYx5V0LuwYG/ujzb+k3pZXTG6vfDo8=;
        b=wkmDFrf+Fb/j2a9VLgloEEMqh2K+4Y+4/hWISEzLINH7ZylIKAIpJ0u+fItguvIcsB
         jHUzgx8YlPZwxbRM+Q81qbWQ3bTTOI82XpR8yHeLoSvICyvdc2HfCAPzKU0B28OZczpf
         ygmvW9be+kivFZiY9lztOifaTDsfeBlTqZ/i+zUAwQ5D7o3fPt0naK/qbPbD6luaBzBn
         3kfcQRzvwX1px6v+9/BqJLsNrkbjvSbn9ky2mJxcNvffMCAMe6H8hNN0AqEmJk4iaEG/
         eRnN5idrGLnt91XHrzjP036dUw9lZdXxscDjvNEVgAh1CSwWXesOckdXus9/kkxsD0QM
         2tzw==
X-Gm-Message-State: AOAM532emiMPezRubLW0tPtqZIDfLd+VLiJYY+LuxZKIYyld2JTrqcLy
        NZs/ZxOZhwNp8t4I9vka7yVgvzqXeARkO+DKCd4=
X-Google-Smtp-Source: ABdhPJzy+HNiPQx8PocJvEYLIqw+UVkm+67LcMcZSylCudsFTWGT0aymJTJitXh13jtvEimvlhr+JtT0T9pRbUID370=
X-Received: by 2002:a17:90a:5917:: with SMTP id k23mr3959392pji.111.1635829149297;
 Mon, 01 Nov 2021 21:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211101090904.81454-1-tz.stoyanov@gmail.com> <20211101090904.81454-4-tz.stoyanov@gmail.com>
 <78703fa1-f811-a50c-6b5d-db68f6dbf21c@gmail.com>
In-Reply-To: <78703fa1-f811-a50c-6b5d-db68f6dbf21c@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 2 Nov 2021 06:58:53 +0200
Message-ID: <CAPpZLN4iJvmz-_EZV0TY6cGTSDDf=6V7DVPEEUAOaMjsGyaoUA@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] libtracefs: New kprobes APIs
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 1, 2021 at 7:22 PM Yordan Karadzhov <y.karadz@gmail.com> wrote:
>
>
[ ... ]
> > +/**
> > + * tracefs_kprobe_create - Create a kprobe or kretprobe in the system
> > + * @kprobe: Pointer to a kprobe context, describing the probe
> > + *
> > + * Return 0 on success, or -1 on error.
> > + */
> > +int tracefs_kprobe_create(struct tracefs_dynevent *kprobe)
> > +{
> > +     return dynevent_create(kprobe);
> > +}
> > +
>
> hmm, what will happen if if you have a code like this:
>
>
> struct tracefs_dynevent *synth = tracefs_synth_alloc(...)
>
> int ret = tracefs_kprobe_create(synth);
>
>
> Are you just giving several additional fake names to the same function ('dynevent_create()')?
>
>

Yes, that will work. All dynamic events - kprobes, uprobes, eprobes
and synthetic events have almost the same configuration logic, which
is handled by these dynevent_... internal APIs. That makes the code
more consistent and reusable.
I see three possible approaches to handle that:
 1. Create structures like that:
      struct tracefs_kprobe {
         struct tracefs_dynevent dynevent;
      };
   and use only that type in krpobe specific APIs:
     int tracefs_kprobe_create(struct tracefs_kprobe *kprobe)
     {
         return dynevent_create(&kprobe->dynevent);
     }

2. Expose the dynevent_... APIs directly:
    struct tracefs_dynevent *synth =
tracefs_dynevent_alloc(TRACE_DYNEVENT_SYNTH, ...);
    struct tracefs_dynevent *kprobe =
tracefs_dynevent_alloc(TRACE_DYNEVENT_KPROBE, ...);

    ret = tracefs_dynevent_create(synth);
    ret = tracefs_dynevent_create(kprobe);

 The problem here is that there are some small differences between
dynamic events - some parameters are mandatory for one event and
optional for another. That can be handled in the
tracefs_dynevent_alloc() API, but could be confusing for the library
users.

3. Mixed between 1) and 2), the current approach.

The first one adds a lot of overhead, a different set of APIs for each
type of dynamic event - but maybe it is more clear for the library
users. The second is straightforward for implementation, less APIs -
but that could be confusing for the users.

> > +/**
> > + * tracefs_kprobe_free - Free a kprobe context
> > + * @kprobe: Pointer to a kprobe context
> > + *
> > + * The kprobe/kretprobe, described by this context, is not
> > + * removed from the system by this API. It only frees the memory.
> > + */
> > +void tracefs_kprobe_free(struct tracefs_dynevent *kprobe)
> > +{
> > +     dynevent_free(kprobe);
> > +}
> > +
>
> The same argument applys here.
>
> Thanks!
> Yordan
>

Thanks for the review!

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
