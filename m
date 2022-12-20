Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22D7C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 19:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLTThI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 14:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLTTgw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 14:36:52 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D472187
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 11:36:51 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id y25so20132323lfa.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 11:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WwaaO0kLHp/BqlRsywcVO2NSpBn2Y9NjDV36HXfqXVo=;
        b=VTytXaVCLjyBAmc6hkJ3dxG3m8NuGAOdIZD0JeLte2GxWrpf1hh312EybIfHOI5YDu
         i2PJ9JaRwCpSt6ztX83keQ9dlQqLCngAA7lvgpiFu+m7CASDDfKM0Z843VFomhCIKqxf
         /Q62RhjdFFbwLDW1WXprIFoCFi14wUy9g1OXE2+ljlgMvkz7kpTJM+3LUSC5BrRNwRwm
         jD4y556sQb2LfXGn9BWiLQ4UvNWZTMdpVJ3t76ehj6f4MJX4huOf7rdcP4X8liGYlbpw
         CIdlqRsY0TB0lyt/KbseIUs5R7p/LNI90RK6apslMUDAAQd6yuqxKRkIBZ34fuwiCOMB
         n77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WwaaO0kLHp/BqlRsywcVO2NSpBn2Y9NjDV36HXfqXVo=;
        b=GWDLIE5MsJSlFctalLc8AS/M6w+6LrC6HQ3SI38Wtl6U71YN4YfJM6u58mgRtg2wfC
         f+AxIh1n+1UNYwSaH0seKutccdr3jJrZcD2hIFXUoObeOovQwh37HUXVo4k8xDJCpABM
         OeEXvTZQixekwvKEgItOvK6FVdGkgT0JaSnPIWaVAgtVBH4A0JR2MFbEjWpExLHJMaVZ
         dAjHsbfe/wj/S5DxptteQV3swu2Lgrib9dP1iL8h/YfP2ZZBxXDHZAvOs8rlXo7qJa7c
         5YghmHQ3NZ0IO0vhlv6Rx6SsXUopmiBc5nCcghoHubJv3zp50gjui+2xSS4tzC2nIJgV
         GJOA==
X-Gm-Message-State: ANoB5pn+soIgiCtMQUWpVblNopdmm8z1l9OYKK6hc3hlzD77bwJ0ekrV
        xJMluL0vIopT3T+Avh98WXs172tIMOsEJin6vJUuXg==
X-Google-Smtp-Source: AA0mqf7nPxeo8ZY6I1b7KO+eyx9J7FUPwX86/UGt2pYH2zphMJWExFibO74SA5cyUHYIEeMJHl8JKyi6Uu8ysmPsw/Y=
X-Received: by 2002:ac2:41d6:0:b0:4b5:a9ce:d23 with SMTP id
 d22-20020ac241d6000000b004b5a9ce0d23mr4201601lfi.315.1671565009333; Tue, 20
 Dec 2022 11:36:49 -0800 (PST)
MIME-Version: 1.0
References: <20221219173414.032e2124@gandalf.local.home>
In-Reply-To: <20221219173414.032e2124@gandalf.local.home>
From:   Mike Frysinger <vapier@google.com>
Date:   Tue, 20 Dec 2022 14:36:11 -0500
Message-ID: <CAAbOScnLETawvZYhZnhVMP_rs6tYEty1-LcWGD9JcQX5tbQW5A@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: Have 32 bit compile with -D_FILE_OFFSET_BITS=64
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Dec 19, 2022 at 5:34 PM Steven Rostedt wrote:
> +# Make sure 32 bit on 64 bit doesn't have stat() bugs.

i don't know what you're trying to say with "32 bit on 64 bit".  you
mean a 32 bit binary (which ABI?) with a 64 bit kernel ?  or something
else ?

the problem is entirely with using 32 bit filesystem interfaces.
there are no other runtime requirements, either in the userland or
kernel land.  filesystems moved to 64 bit fields in a number of places
long ago regardless of the userland or kernel ABIs.

saying "32 bit" or "64 bit" is imprecise.  is x86_64's x32 & aarch64's
ilp32 ABI "32 bit" ?  or is it "64 bit" ?  what about Window's x64
(LLP64) ?
https://en.wikipedia.org/wiki/64-bit_computing#64-bit_data_models
https://unix.org/version2/whatsnew/lp64_wp.html

usually it's better to specify ABI names and/or specific types so
people know what you're trying to cater to.

> +ifeq ($(shell echo '' | $(CPP) -dM - | grep __SIZEOF_LONG__ | cut -d' ' -f3),4)
> +       CFLAGS += -D_FILE_OFFSET_BITS=64
> +endif

why do you need to sniff the size of long ?  -D_FILE_OFFSET_BITS=64
should work fine regardless of the target ABI.

especially because you're assuming sizeof(long) == sizeof(off_t) which
is not guaranteed anywhere.  on newer ABIs, like x32, sizeof(off_t) is
always 64-bit while sizeof(long) is 32-bit.  i don't know if there's a
sizeof(long) == 8 & sizeof(off_t) == 4 ABI, but i wouldn't be
surprised if it showed up.  mips o64 or something wonky.

afaik, the exact output of the preprocessor isn't specified by a
standard, and it has changed subtly in the past.  so i wouldn't rely
on it in general.  something like `echo __SIZEOF_LONG__ | $(CPP) -E -P
- | tail -n1` would be a lot more reliable -- you aren't sniffing
preprocessor internals, you're actually preprocessing something.

POSIX does provide (optional) defines to try and sniff off_t sizes too:
https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/unistd.h.html

but i think the takeaway is that this is all not worth the effort, and
defining _FILE_OFFSET_BITS=64 all the time is way easier.
-mike
