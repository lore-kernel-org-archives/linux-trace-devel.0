Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127B1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 14:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378288AbiDDOvX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378270AbiDDOuk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 10:50:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626CA13F5C
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 07:48:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so9249680pjk.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sg+sWSZjN9V+bIyJ2yT3AgzxLInNRQsa4qfMfuTKVFk=;
        b=ALfL/QjZ6nRFL1CzEQ4N1omLEKIkotjdN5lyzuU4EuFQd6YzZqoev/dAKJBKkGPEt8
         emWKiMpnteFZ9rvfry1K3EBOtOlrkYLxvd9qLUnpM88FQgU8AWrbkPhaAFppKRbUb2vY
         MTQa4KkaULW0yFhl6Zv7w9w2cIGNyj9ObmaucqZF0SXYrYA8QbiZ94HE73E5fcl43pfY
         SJim1a2v3xpI3sWqm77XGtwOQu7etCUPofC19b8EPK9gL4sy4hYbXQH+lJ4Sg4k3YEaw
         H3w1fEjvdKyq/NrpiBlRNHzDuCUYhwrXl1tfkoADz+jnFPwak2ikrPoMB0T+dIzab4AV
         eNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sg+sWSZjN9V+bIyJ2yT3AgzxLInNRQsa4qfMfuTKVFk=;
        b=egJE6QDBwB5ngLUbdFwIjRb1qkzSJfzztazB4Ssip9WtKitl/2p/fv5GUKXbpvfc4e
         jG5Hd9BjQCzdbO9KgJZE0625ho/PLXNTfWD8uQEQsF4F8YI/yyfdmjgszW0Nu1Oql8D6
         0z8OEX2glRFJBOKmUjGRJkn96UiGXogJrejTEJqaerkLop2a97XwzuIweylCQtly4H+E
         IcqpsWq1KvF/zoyElOKHGxFlWl65Ivzmi64F0wbz6f+em0w/r0PCSJ2Y7SnTgDyjFgzX
         sExIO0b4WG3z7aW2l6C3pGI/qhXOEs8wmUGzJUuFfwLCsDCKDeOn2FzWcjW1nLhrN9Di
         wOTg==
X-Gm-Message-State: AOAM532IEFjRBnv4UdNEurOwvcNXz5yjc0B2b6oC8t+3LxBwblbxAMkp
        /fyiMyktLvCQjzp88F1h06Qab0JVGXeSSt+mCJk=
X-Google-Smtp-Source: ABdhPJwCh8DiF7jGUWOQINXCaGKe2nfEAxRZ5zAVDtJ3zsvJnylbtlqIRNNs8y4WnSfuUcsX+tE4GzFlcV+hZQqJcaU=
X-Received: by 2002:a17:903:20c:b0:154:b58:d424 with SMTP id
 r12-20020a170903020c00b001540b58d424mr8048plh.45.1649083720874; Mon, 04 Apr
 2022 07:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
 <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
 <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
 <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
 <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com> <20220404103525.1ec0b246@gandalf.local.home>
In-Reply-To: <20220404103525.1ec0b246@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 4 Apr 2022 17:48:24 +0300
Message-ID: <CAPpZLN71si6G5=O=sM5suNp+NtXYz=0U+=3O2XCCWmqhp8M-Tg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 5:35 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 4 Apr 2022 16:48:11 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > > > Hi  Joel,
> > > > > That cache file is used for constructing the trace meta-data on the
> > > > > guest, before sending it to the host. Usually it is compressed, but it
> > > > > could be uncompressed in some cases (depending on the configuration) -
> > > > > and in that case it can grow up to a few megabytes. Using memfd is ok
> > > > > in most cases, but I'm wondering in the worst case - these few
> > > > > megabytes could be a problem, especially if the guest runs with a
> > > > > minimum amount of memory.
> > > > >
> > > >
> > > > Can you check that file size on your Android setup with that command,
> > > > it will force to not use compression on the guest trace file:
> > > >    trace-cmd <host trace options> -A <guest> <guest trace options>
> > > > --file-version 7 --compression none
> > >
> > > The file grows to 5.3MB with this. Is this really the common case
> > > though? If not, I would still prefer memfd tbh. Is that Ok with you?
>
> This is meta data right? Which means everything in here is in kernel memory
> anyway. kallsyms, events, etc. I do not believe that this will be an issue
> even uncompressed.
>
>
> > >
> >
> > There are two cases that could hit this:
> >  1. Using a " --compression none" flag on the guest file. We could
> > disable that flag and force trace file v7 always to use compression. I
> > cannot imagine a use case for uncompressed trace file, maybe only for
> > debug purposes ?
>
> Please no. I do have some machines that do not have zlib installed. I do
> not want to make it a requirement to have zlib for this use case. If we do
> not have memory, we could fall back to mktemp.

Hi Steven,
I'm wondering how you run the latest trace-cmd on those machines ? As
these libraries are checked at compile time, this is a compile time
dependency - so the trace-cmd compiled with zlib support should not be
able to run there ? That's why I think   " --compression none" could
be used only for debugging.
We could implement loading compression libraries dynamically to avoid
these compile time dependencyies, or add a compile flag to disable
compression support ?

>
> >  2. If, for some reason, there are no supported compression libraries
> > on the guest. Trace-cmd supports libz and libzstd, I believe both are
> > widely available. Theoretically it could be possible to have some
> > minimalistic VM image without any of these libraries.
>
> Not theoretical ;-)
>
> > What are the advantages of using memfd instead of temp file, is it
> > only for performance ? Usually collecting trace metadata is not
> > performance critical, as it is done before starting the trace.
> > I think that the best solution is to use memfd in case the guest file
> > is compressed and switch back to a temp file in case of a
> > not-compressed file.
>
> Yeah, we could use memfd if compressed and temp if not. Luckily, this isn't
> something exposed across the API so we should be able to experiment with
> various implementations, and if people complain about one (like Joel did
> for Android), we can try something else.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
