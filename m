Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E8BC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 06:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98052611CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 06:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhFVGny (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 02:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVGnx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 02:43:53 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFE0C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 23:41:37 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q192so9066605pfc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 23:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jh8MoleSBVb8Y+8JsqSvcaSGVFmXBeC8fm5tb90wk8c=;
        b=JcFzt84Wbs5/Rzt5oJhefgUfP7eFA7ulDNxZpVwfZ+LHegz04dEaPB6CtUrzUKfFOM
         8X3Gn1GwIYQmWaI3pjiHLlZyezgpK32y/XKm13hsy1T4YCrt7LpOlOyz6dFhuc1O5B/j
         lLix4/M7uSpC5ERK8K8gKPVbHDZ6fB4LBKmIKbJ7vTkHeNkOcoLQijFi0DFB7EdfOSTA
         Hl556QdD8cxLoyr2ar3Clo8tTuRL7WZiNuPqsehZgG4SmqFZ7jI5MXb5FCyLhtbPxydV
         E24HP9ARHJJw7kn7KX3Va848Xwx3Aio8AYCZW1bVj/LPMu6/LxECbdmTlYohsCWIzdAm
         Mbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jh8MoleSBVb8Y+8JsqSvcaSGVFmXBeC8fm5tb90wk8c=;
        b=j112tNyjv8bgCCR0njeIw4B3pXMPpRoBSJA4ua0gcCea1rMqOiTZ/JZugour7c/xz2
         BANPImh364dPtPdWipjSr6RwBmL4Y2Sr1hwOB4xAmI/drp/4zodGr5/WUZ1tlnxxGsnw
         f4M9vnV1e+7VkCdQIygGMaB01mylVaeSy+vHB1pxI/KDpQg512R94m9tf+0AwKdjU+GH
         aHLcfP2y0VKgpAUTvU5rnnzkPqQ9pQeAi1iMfvKILC06WpVfpjsyKIO2yUawFGHYlfU+
         QPnS8Wy4yjWTw70YLlv/+kK9h2uyv3Yr3S9hu4ixh5/AiwvQJx9ES7x/JR/rVXIa2q79
         HGNA==
X-Gm-Message-State: AOAM533bIwoh1F1QaUlTlmy8DIdjorXxU1Tklop4hMF1GdQatFaPzYns
        DYLjlDCT1lnQFQsMfYYPK1MQoeSQVKkrGCdER49FOQIuTbwdoQ==
X-Google-Smtp-Source: ABdhPJzTAdrOMDtaDv+R8z0/qqhPA9EcfXSZpcZeUU3klgNXVmZVS8TWm4gWLH9fhjnuRFg2fjxOuJxTWC+Wvpmkxj4=
X-Received: by 2002:a62:f20a:0:b029:300:43ed:198d with SMTP id
 m10-20020a62f20a0000b029030043ed198dmr2111771pfh.55.1624344097270; Mon, 21
 Jun 2021 23:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
 <20210610113426.257931-7-tz.stoyanov@gmail.com> <20210621212711.4f7469bc@oasis.local.home>
In-Reply-To: <20210621212711.4f7469bc@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Jun 2021 09:41:20 +0300
Message-ID: <CAPpZLN4ehDqxqeqSFraDCqb8BFF9LFynjcym-PzQJk=iBwAOBw@mail.gmail.com>
Subject: Re: [PATCH v5 06/40] trace-cmd: Add APIs for library initialization
 and free
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 4:27 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 10 Jun 2021 14:33:52 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The trace-cmd library has no APIs for initialization and free of the
> > whole library. Added these new APIs:
> >  tracecmd_lib_init()
> >  tracecmd_lib_free()
>
> This isn't a very use friendly API.
>
> The reason I see you added this was for zlib, which I don't think is
> necessary.

I was missing that API when I worked on the host-guest time synch
algorithms, to initialize the library time synchronization context. I
decided to introduce a new API, for initializing only that part of the
library - tracecmd_tsync_init(), as this functionality will not be
used commonly. Now with the compression changes, there is a need for
an API for initializing the library compression context. As this
functionality will be used in almost all use cases, I think it makes
sense to introduce this global tracecmd_lib_init() API, instead of
something like  tracecmd_lib_compression_init(). Personally I do not
like the approach to have init APIs for different parts of the
library, especially in case of widely used functionality. This will
complicate the usage and will force the users to know the library
internals. I would even suggest to remove the tracecmd_tsync_init()
API and to init time sync context in the tracecmd_lib_init().

>
> -- Steve
>
>
>
> > and call them in trace-cmd main function.
> >



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
