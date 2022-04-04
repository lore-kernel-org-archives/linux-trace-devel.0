Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36D9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378635AbiDDPoC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378362AbiDDPoC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:44:02 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644CF3DA43
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:42:06 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r2so11709875iod.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 08:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8x/Jx+n8mvWrs2guKciDDLNTxbBsjkChYDyRyQaOJ9k=;
        b=MCv4FpMtTxgZTztBfoyDq/z2qQGID9RasL97HYX/nDFg3BiD9ebu+SOrsnQ4g4uVMk
         aCrt7xrqhCsryVF+Pid1/UTeR4XgTbSmFukZDhxOLQpnqpnnKLqcsvZTiBqIDMYIzATY
         FT0na83Sh1BTdnwcWDjAosJhETnxhXWjWoNJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8x/Jx+n8mvWrs2guKciDDLNTxbBsjkChYDyRyQaOJ9k=;
        b=VsXuleRBXdkreqlw7YfU6VzmlkqLOJBHgqRZPDQk2oN5wfL1EH/yLBRrhfPrYj6wo5
         oRjnzeP2RS3dR3gr8OLkH36y0GMEuoyXsd57ai1k7IdamrnSroQjguIrm8ARcnoO3gB9
         PZrx0iOFDn4swHvZd7fRndGqNsuWUQo5IXUkWbk+nQZOWPliwmB5Q68DouYZDTBFeLLx
         7LOoAZZzKvnBlpqR2tVIwdyZOaD6w33rJIu2npB75pyOR7TFRUzW2ThK9ZsdzHUm50ul
         +I1/iZdKkTttOU1sYhnBR7Y9eme9w49gWxy/9HA7M96W6ADH/xm09laJdTNAEuvV54zM
         u9eg==
X-Gm-Message-State: AOAM530Jvv8AFOTTAjT/8Sl2iH8GDhBx3Ez/jtisTXBCaMeQXYjX25gY
        pHZJyHGWYp+mfkvrwjuZDGofEF53oXjIR1Bicht5Y6C7H8c=
X-Google-Smtp-Source: ABdhPJyiSTSdYt7aUHoeVzWPFzJig5swR47+Ounqw1H3T/TKMdxIv6jdnaQJtPMDUE/qjfBYZp9avqu9/lHyPOk8a4U=
X-Received: by 2002:a05:6638:1249:b0:321:2e10:c276 with SMTP id
 o9-20020a056638124900b003212e10c276mr97867jas.304.1649086925837; Mon, 04 Apr
 2022 08:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
 <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
 <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
 <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
 <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
 <20220404103525.1ec0b246@gandalf.local.home> <CAPpZLN71si6G5=O=sM5suNp+NtXYz=0U+=3O2XCCWmqhp8M-Tg@mail.gmail.com>
 <20220404110424.78f14d9e@gandalf.local.home> <CAPpZLN6h5RaVdGoA9LfXn67bvdhfb4VZoipjiv1wJzCpdSTPPA@mail.gmail.com>
 <20220404112758.3e32bd40@gandalf.local.home> <20220404113240.7c3368e5@gandalf.local.home>
 <CAEXW_YS+JsSPYu=8UoGZdwVMhF2cw9B9rODskFGfR4++dmDVVA@mail.gmail.com>
In-Reply-To: <CAEXW_YS+JsSPYu=8UoGZdwVMhF2cw9B9rODskFGfR4++dmDVVA@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Mon, 4 Apr 2022 11:41:58 -0400
Message-ID: <CAEXW_YR5bSNxa_+NfMXqCNj4MvUbV=RX2NaSTasXU4NhqDUcQQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 11:40 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Mon, Apr 4, 2022 at 11:32 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon, 4 Apr 2022 11:27:58 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > > Sure, if you compile it yourself, it may not be supported (which is what I
> > > hit), but at least we guarantee that it will be supported across machines
> > > using the same distro if we make it compile time dependent.
> >
> > Not to mention, I have use cases where trace-cmd needs to be installed in
> > an environment with no dynamic libraries (nor using dlopen). Everything
> > will be built statically. trace-cmd report will not be used, but trace-cmd
> > agent will be.
> >
> > Remember, trace-cmd is to be embedded friendly.
>
> Agreed, so should I send a patch next to do memfd unless
> not-compressed? Is there an easy way to do not-compressed?

Sorry I meant "is there an easy way to detect, in this code path, that
we are running in not compressed mode" ? I guess I could just check
the argv but I haven't looked closely yet.

Thanks,

 - Joel
