Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC776C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jul 2022 14:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiGLORs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 10:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbiGLORa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 10:17:30 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CADF97D68
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jul 2022 07:17:30 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-10c0119dd16so10470334fac.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jul 2022 07:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/e3Zc6nON2eMWN7FGBf8WgIC9nuzZImCJRay+QGgpc4=;
        b=ErEFhuXJ2vDvnylsjWE7lb/94Gm5dnv2kFTHUXhEcpetXhD7Gw8dH5brydJVyuUZbV
         l5jtvqyFhozMvGNmu6llB8spuyFAep3i7o1k/fm495VYcvCS1Yqt4R0DsKfc9GWrZOGN
         kCwkCELKa0oLxFNvBoMu1/iI0ITkK72TlSDVZEli3M42+oP1kcAUSaN8koEAkoycwtgm
         9ZaZXMUloLI2ch3QEwNYpgW3HEnECnnQQQMI4PqB2dyAKwI59/lA3nOfvAvTIwDayJwp
         tNo3iNj5JsfHkpgR+VI1aFRGqgBtsLmBbbdL+N6Avjhw7LvCMKkwpsk4cuRI+KmlgJtA
         dwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/e3Zc6nON2eMWN7FGBf8WgIC9nuzZImCJRay+QGgpc4=;
        b=Y9MkMdkVRueL2F8Ugj4kvv065zF7zJ/X7gIqZsi5AqrSHyGnwsuUcwYS7q/h2PKytf
         L4bNUkXU6bhpisSkTJnFCmpKa5xsJgMqAZp5XxLNVOJsEGjtygH80yTm5x7REeeUyp4x
         V3L1vX3spLHRjo/5dJvbYSqGJ6Cdn7p8VLVxZWLeYxDiL7/4U8Y/WFT0dW6NnORKYz0F
         Xq2AIK+272J2J7fCR/+werchuqATi7U7zOpIq1JumeMDY3UlstYC7yKhI6cBUO+mNSHp
         eI3Wnw3XOgLqXqDjf352eh8tmgTyEaEbcn/G2tNhZEpIBxBiWf6AbsTTQox4GOW0T9lU
         SBDA==
X-Gm-Message-State: AJIora/M1rhX/LJh6eK2XownpKwUCS8UlP6dN86hQe/vhcoM0V4ty4qD
        PXg5qCXtuJxq8Bx49oa3tKrcZZmkyLbYHa0Bi1BzHk5itCw=
X-Google-Smtp-Source: AGRyM1vPatDYXH5A/VjWo5PWOFdm2Yyq58+IAdQv8bwQDR5vFUaubY9dSYuADWTINtFIDv1ozxDHf+uHmwKlBEwPWbc=
X-Received: by 2002:a05:6870:461b:b0:e9:a015:36a6 with SMTP id
 z27-20020a056870461b00b000e9a01536a6mr1812037oao.185.1657635449133; Tue, 12
 Jul 2022 07:17:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220504010242.1388192-1-vineethrp@google.com> <20220711151655.5a4f4cc0@gandalf.local.home>
In-Reply-To: <20220711151655.5a4f4cc0@gandalf.local.home>
From:   Vineeth Pillai <vineethrp@google.com>
Date:   Tue, 12 Jul 2022 10:17:17 -0400
Message-ID: <CA+HDTgTUDhvywfNvzbFbiOTnAifPSZksu_9RnCeFvWb3Hzd61w@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: rework of the pid detection of vcpus
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Mon, Jul 11, 2022 at 3:16 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> If you haven't noticed I have patches that are a workaround that fixes this
> issue if the conditions are "right". (I Cc'd you) [1]
I was on vacation and just combing through the mails :-). I shall have a look
at the patch soon..

>
> The work around is to not depend on the number in debugfs/kvm/vcpuX to
> match the CPU of the guest, but instead to match the ordering of the CPUs
> of the guest. It also requires that the guest's CPUs are consecutive and
> non sparse. That is, if you have vcpu0, vcpu1, vcpu8 and vcpu9 on the
> host, then the guest needs to have CPU 0-3 with the mapping of:
>
>  vcpu0 -> CPU 0
>  vcpu1 -> CPU 1
>  vcpu8 -> CPU 2
>  vcpu9 -> CPU 3
>
> and then it works. Of course if this is not true, then it breaks again and
> will require some more communication between the host and the guest.
This makes sense.

I vaguely remember seeing non-increasing patterns in some server machines,
but that's really rare I guess. When the debugfs changes for exposing pid are
widely available, we can have that also as an option.

Thanks for the patches. I shall have a look at the patches soon.

~Vineeth
