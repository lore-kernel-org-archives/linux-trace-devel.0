Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E330C00144
	for <linux-trace-devel@archiver.kernel.org>; Sat, 30 Jul 2022 01:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiG3BAQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3BAP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 21:00:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 475D913EA1
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 18:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659142812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cbNiLuTDKvGKBQFKpFyZVCYcANllBVxjDQq8YTyfHGw=;
        b=bjAD8+iF53sVcIVROBw7ww9bs7nAgOvUeW0TQswwxJxhOceUzZLJSL0qE6Vsp8r1ok3XJn
        jN2U/ADFyEQyte8DOMoEvdg3EuTVuzQhgAw7hYP5OhM0TafvRkiDGJQqANLnLrLgIdMtPS
        lJ0xOL25YBNbpdjUcbt6A4CFEmzVgVA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-vJpeSYmhNyeiFsskcNTkPw-1; Fri, 29 Jul 2022 21:00:10 -0400
X-MC-Unique: vJpeSYmhNyeiFsskcNTkPw-1
Received: by mail-qk1-f199.google.com with SMTP id x22-20020a05620a259600b006b552a69231so4739989qko.18
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 18:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cbNiLuTDKvGKBQFKpFyZVCYcANllBVxjDQq8YTyfHGw=;
        b=O4g7Yy8FWrsnDBOT2+6exn4mdg0sIS5U0HFQuFY3vyd27824CnuDfW+4japvlSvPUE
         Wg1GLLpMFRA3lzdj72pGMhL78YPwxWauS+Vf4IQmYtR3O5Eoe5SgHToxj2PPOLr+42Tn
         zEcIvIjGSmGU9tuFmaJrPggI6GSLffF3mcpnT/FD2SLFtuKNm1yXeO+rry2/LTgjaXaS
         fdsNFtSjey9ZkANjo5SuMQgrrMNeML6y0ggEcarVaMApG8aj/4nyrxe/shY9BvHwa3hg
         WNUM/p5PoEA1dHZu/ZUfpbnmnYkj1CyKmqbcCzxPnLmVhw1XOfRfOoULCo8wkg0BoPJ2
         42ew==
X-Gm-Message-State: AJIora+GsxJ2QyyFJudmZL1NE0jzHCI8FUO5Xnp/aIh0UfRFTBlbaRsc
        ayi2UOl4eVxXytt+ZBhtkaLwMy1DXD9HxctDJvU+XDlc5ziHupTpTfCpkKxfCfAriDYWXYKUPvc
        RnWIBeg321ha5UKAaEHxa11sFKiq7ttGY/0ABLN/zdCRtvWg=
X-Received: by 2002:a05:620a:4403:b0:6b5:e1ad:75a7 with SMTP id v3-20020a05620a440300b006b5e1ad75a7mr4767557qkp.177.1659142809405;
        Fri, 29 Jul 2022 18:00:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sY87+nZ4oN0U6RWHdfJdwlBdQ0Di0Rn/fyDU+HiHxNZZJ+aYmQb5HSWLiJfHWXlOLkP7gy8WT0hPsMXFWqK84=
X-Received: by 2002:a05:620a:4403:b0:6b5:e1ad:75a7 with SMTP id
 v3-20020a05620a440300b006b5e1ad75a7mr4767538qkp.177.1659142809196; Fri, 29
 Jul 2022 18:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220729040116.175015-1-tz.stoyanov@gmail.com>
 <20220729165048.77f03fc7@rorschach.local.home> <CAK-6q+g2q4drxRC=5075Oy2Qh2C1pszF9fC1gRi0O90JJ49YPw@mail.gmail.com>
 <20220729205438.7c1932dd@rorschach.local.home>
In-Reply-To: <20220729205438.7c1932dd@rorschach.local.home>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 29 Jul 2022 20:59:58 -0400
Message-ID: <CAK-6q+gEZLi0tGCrvbPavQuKESBBzYRNxsQMr=upY=6384ZhyQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Do not use instance from trace context
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Fri, Jul 29, 2022 at 8:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 29 Jul 2022 17:48:08 -0400
> Alexander Aring <aahringo@redhat.com> wrote:
>
> > >
> > > Bah, I kept getting confused by when to use instance vs ctx->instance,
> > > and I guess I messed this one up.
> >
> > I tested it and it seems to fix the problem..., so if it's not to late:
> >
> > Tested-by: Alexander Aring <aahringo@redhat.com>
>
> Not too late. I haven't downloaded the patch from patchwork yet (nor my
> other patches).
>
> >
> > I am not sure what I should expect from the PTP time synchronization
> > over IP capable interfaces (it never worked for me) but I need to say
> > it is significantly slower than kvm time synchronization with vsock
> > and I am using only virtual interfaces. On the agents I get a couple
> > of:
>
> Well, kvm time synchronization doesn't do much between the host and
> guest. And I'm looking at making it do even less. That's because the
> kvm synchronization is just "read the offset and shift of the guest
> from the host and do the calculations via the reader (trace-cmd
> report or kernelshark)". But the P2P is sending packets back and forth
> between the host and guest and trying to figure out the round trip
> latency.
>

okay. To be more specific it took about ~20 minutes until I saw the
"Press Ctrl-C to stop recording..." message for 3 agents. Is that
normal?

- Alex

