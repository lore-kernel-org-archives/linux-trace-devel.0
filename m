Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFE8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378017AbiDDPSD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378477AbiDDPRz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:17:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFDD393EA
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:15:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o10so2507030ple.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHX6hZgPPCZUv9omjmAit1au/mcHm4Vi1XyGAwcX4FI=;
        b=S8aqGPwevsey8ieUIoPGsRUXqkxYWZ/ETEFAipwWqV/6Dpg3NU11sCskX4Pos3+ZOt
         Oct/qyg8Mr584p75O/rRDMP8wWy8XL0sczES0VAeFkhaOIiK8YYMu4Ix9nm3blfB/dnt
         IbH7C8+GY+hFA7TNPGOVQxzE/jbT/Qw858diiUyw0blp89/0YdxevwjVe2VGlPS4z8+P
         YxxmjnEgEk/nsCeN2e0Ly6i++GJRAYChOUwvXx1IKgNAZUlcLGDByM9bSNK4UY6ttgSX
         ipFyd1HFmbk3GRriE3xbmTSpm2yl7mF0KijavXWTgVnTzlbHYSchra14Y10qR9ieyxMR
         OY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHX6hZgPPCZUv9omjmAit1au/mcHm4Vi1XyGAwcX4FI=;
        b=FqyoW/3LlKuAgCuErq348VZC5sIPtKvuXM3BrofHd+YaCZQYSCrf3IjJN3yiv7G9kE
         mUoY/bErfWHL7u/rH31tJCfR4uZxH+9Cr+JvM327Mfa0ChIRuaNr43cWTdCaJ9PNXEnV
         lQCzfKCNs56ZHjcX8JZWs02yaIgUkfk4cDNVUBD/DPHOZZTZZ3rJeur5lkKqh10AaEh4
         85vTH9tZCaxxJy3zbJ5ZuHg7Rsh1z/gQ1uTWYeiG1F5GsasltynXGZpq9wjitlpm2yFp
         /5OnCINURNi1DffTN5xIRPAonXCDeYep2/j8Q3v6KXEZw6LtPxYySf0zbQrVybW0LICB
         FEtQ==
X-Gm-Message-State: AOAM530+A5aeOGfjVdlRVdXKYFIrJpL3CWMqmfYHxGX/SeGZtTvbY79V
        JCCKKoipRpCakuG94JJk1lGKLurQaOCRK6u+jC8=
X-Google-Smtp-Source: ABdhPJznJ1uZWt2Q1981IuyfYYw8cERFIuI+Go7+BP/PeTorwmLwpFa4eDvIPqRxn0SMlWiUWWx11BfjWGbVh+oKTiI=
X-Received: by 2002:a17:90a:da02:b0:1bf:3919:f2a with SMTP id
 e2-20020a17090ada0200b001bf39190f2amr27095586pjv.208.1649085358519; Mon, 04
 Apr 2022 08:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
 <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
 <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
 <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
 <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
 <20220404103525.1ec0b246@gandalf.local.home> <CAPpZLN71si6G5=O=sM5suNp+NtXYz=0U+=3O2XCCWmqhp8M-Tg@mail.gmail.com>
 <20220404110424.78f14d9e@gandalf.local.home>
In-Reply-To: <20220404110424.78f14d9e@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 4 Apr 2022 18:15:42 +0300
Message-ID: <CAPpZLN6h5RaVdGoA9LfXn67bvdhfb4VZoipjiv1wJzCpdSTPPA@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 6:04 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 4 Apr 2022 17:48:24 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > On Mon, Apr 4, 2022 at 5:35 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Mon, 4 Apr 2022 16:48:11 +0300
> > > Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> > >
> > > > > > > Hi  Joel,
> > > > > > > That cache file is used for constructing the trace meta-data on the
> > > > > > > guest, before sending it to the host. Usually it is compressed, but it
> > > > > > > could be uncompressed in some cases (depending on the configuration) -
> > > > > > > and in that case it can grow up to a few megabytes. Using memfd is ok
> > > > > > > in most cases, but I'm wondering in the worst case - these few
> > > > > > > megabytes could be a problem, especially if the guest runs with a
> > > > > > > minimum amount of memory.
> > > > > > >
> > > > > >
> > > > > > Can you check that file size on your Android setup with that command,
> > > > > > it will force to not use compression on the guest trace file:
> > > > > >    trace-cmd <host trace options> -A <guest> <guest trace options>
> > > > > > --file-version 7 --compression none
> > > > >
> > > > > The file grows to 5.3MB with this. Is this really the common case
> > > > > though? If not, I would still prefer memfd tbh. Is that Ok with you?
> > >
> > > This is meta data right? Which means everything in here is in kernel memory
> > > anyway. kallsyms, events, etc. I do not believe that this will be an issue
> > > even uncompressed.
> > >
> > >
> > > > >
> > > >
> > > > There are two cases that could hit this:
> > > >  1. Using a " --compression none" flag on the guest file. We could
> > > > disable that flag and force trace file v7 always to use compression. I
> > > > cannot imagine a use case for uncompressed trace file, maybe only for
> > > > debug purposes ?
> > >
> > > Please no. I do have some machines that do not have zlib installed. I do
> > > not want to make it a requirement to have zlib for this use case. If we do
> > > not have memory, we could fall back to mktemp.
> >
> > Hi Steven,
> > I'm wondering how you run the latest trace-cmd on those machines ? As
> > these libraries are checked at compile time, this is a compile time
> > dependency - so the trace-cmd compiled with zlib support should not be
>
> It was compiled on the machine it ran on. I have to find which machine it
> was. I believe it was one of the gentoo or arch VMs that have very little
> installed. Bare minimum (you have to compile everything that is on it). But
> the trace-cmd I built did not have any compression support, which put it to
> --compression none by default. Without any compression libraries, it can
> still build.
>
> > able to run there ? That's why I think   " --compression none" could
> > be used only for debugging.
> > We could implement loading compression libraries dynamically to avoid
> > these compile time dependencyies, or add a compile flag to disable
> > compression support ?
>
> That is not needed. Do we really need to have compression always?
>

The current approach to use the best available compression algorithm
by default is good enough, but personally I prefer the logic with
dynamically loading of these libraries. That way we can use the same
binary, which will simplify the trace-cmd packaging. And the first PoC
implementation of compression support was that way :)

> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
