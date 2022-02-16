Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC557C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 15:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiBPPoR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:44:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiBPPoQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 10:44:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2272944F0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 07:44:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso6847151pjg.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 07:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/T/9nJAy+shhWqp1d+3Li85ZQ6wg8YZTQ7x9Q8o2qlw=;
        b=ZArVqQmaHWZhzQhDhfBhFD4NVuspMPNYJFmbY3wjqqwqrVaF66pSeVan+d9aAdIyft
         BevG8FBOaRQonPeCxcuMXSRjrxWKltYS9Wy+GZoc4Q126YdUCZ7ZsoltcyfCl+djXqIp
         3gAkk9FI3wJKj/BdcEcArHUi+zSqC1baGrMF1rtFGl616pez20QOjBUx8W5Ur1A6Y5o7
         meVqRI0mcxdpFN/peN1wvYEg6oAPiG3Fjy73tSmasiGJbvCQy0q1OKpt3dHO8q/a+a7Y
         ph+KaBIS1xLxd920FkVsYir7lg4dS7b/8aLDsuiQm1jHSgRDO5t8zugwXBcjc1LTGZIq
         ZnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/T/9nJAy+shhWqp1d+3Li85ZQ6wg8YZTQ7x9Q8o2qlw=;
        b=fA5PjOEHK1iLCc4J9RnmnluYEOAzg+d5huLCvbjgBAIa0jIip+t3BA4agDNiBiy7Xr
         NZCG77Psm10BwEaUAEnuUsU6oAIU79kQW2zUl+c2rxGI3Q1fDFZqZnsn4Pd8oir1Prnf
         Eei+urTN73j1GSJEs5JZ5VHJWU0SJm2tpxRBeOcuusZX1km5k16CQ7DSOMZf+QsdeALb
         VypsXsPFirCxm9sdZBixvHN39EjwBFGuBJdfiVL/mhdpmWJajai6aV9b9LbeK70cLvBU
         wB5Pa7WEEMZeXuNNXrfybEPLadgci4Lo7oKuAWL8iQSRyQ5R1cfBAuocVjcGYEM/U32z
         qZVQ==
X-Gm-Message-State: AOAM532/R/h8lzDkl7GqneaSMN4jxeXufPNd7sfPVAijkoc3kbJlhVYk
        qbBMoh0JlrSeq8t3OJTaM+c8aebPyXhKNbYYkv0vrBJi
X-Google-Smtp-Source: ABdhPJzAnnbdE5ef147hYeuCvGLwaPPCjdsXuRIxM294G4XGi8w7QRdEwU0rvl+Gml0W9BJf3+r1hHCwMFflTNyfn7k=
X-Received: by 2002:a17:90a:b10a:b0:1bb:82a7:5d69 with SMTP id
 z10-20020a17090ab10a00b001bb82a75d69mr2421028pjq.111.1645026243106; Wed, 16
 Feb 2022 07:44:03 -0800 (PST)
MIME-Version: 1.0
References: <20211210115508.103569-1-tz.stoyanov@gmail.com>
In-Reply-To: <20211210115508.103569-1-tz.stoyanov@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 16 Feb 2022 17:43:46 +0200
Message-ID: <CAPpZLN7K+ouw+4p3eBAKObz-7Ao3+xD=vE4psWrhgYoK7jD_6Q@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd library: Do not record TSC frac bits if scaling
 is default
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

ping
Just to remind, this one is an important bugfix. It fixes host-guest
tracing with the latest kernels, where new KVM debug info is exposed
through the debugfs.

On Fri, Dec 10, 2021 at 1:55 PM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> Guest's TSC fraction bits have sens only if there is TSC scaling. In
> case of default value for TSC scaling, fraction bits should not be used
> in TSC guest clock calculation.
>
> Fixes: https://lore.kernel.org/linux-trace-devel/20211014150204.2485499-3-tz.stoyanov@gmail.com/
>         (trace-cmd library: Extend host-guest time sync with fraction bits)
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-timesync-kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
> index 8d531922..12a22d4c 100644
> --- a/lib/trace-cmd/trace-timesync-kvm.c
> +++ b/lib/trace-cmd/trace-timesync-kvm.c
> @@ -415,7 +415,7 @@ static int kvm_clock_host(struct tracecmd_time_sync *tsync,
>                         kvm_scaling = 1;
>         }
>
> -       if (kvm->vcpu_frac && kvm->vcpu_frac[cpu])
> +       if (kvm->vcpu_frac && kvm->vcpu_frac[cpu] && kvm_scaling != 1)
>                 ret = read_ll_from_file(kvm->vcpu_frac[cpu], &kvm_frac);
>         msg = (char *)&packet;
>         size = sizeof(packet);
> --
> 2.33.1
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
