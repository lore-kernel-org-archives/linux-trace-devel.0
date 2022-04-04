Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C572DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiDDPnQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378665AbiDDPm6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:42:58 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0942A3DA43
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:41:03 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 125so11711136iov.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 08:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m6xo7kMJ1YpRn0O+BGeR6xYNqTNSe2baHEZO7VBvm7A=;
        b=o0mn3Pc7hegSCzjxTWBX/f1Y3C02KK8tCLeaPlNnUct0Tb2RBRqyc/6VnQcs6FI/T9
         XAX7XNbsurvDkjW6cc+0Lx7RkW4t+3zUFx0vqatPTaA8iFV7fpMnJ+PlE45IxOnYbUHQ
         8uotmLmQOqaSw8a6rh4uUGWkVchInl5Ef7JAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m6xo7kMJ1YpRn0O+BGeR6xYNqTNSe2baHEZO7VBvm7A=;
        b=i+h6TFpfyqXB8HZDll3BiayMr3Sa/QHPkHsBGOobwAdDLRBfth1sSG9e0UJ5TzNH6Y
         86z/nn8GXtOIvHF/z3RaI3upghP2UleEpmxige+rXsV2FsKbCDyev9LIw1+JMKTMT/qO
         xhuyaSoDC/oIgBeCLsArzfEd9P9uXGNiQLUbpgRk21h/2g8PQV0j0q8sTCHfjhb+HDYE
         sD9JfbKLwFNM58Y5wRgrIB0cYk4e4Tpjb3yo2Rccak0ivukdY9NxYLWO+1IHQczpoCuQ
         AehVQNMh+luWcB4kEQbs+QsxaUDZaulLzOkbmTy+X5gpzLUdQH8frpYq4Y3RrY7HGl8G
         c45Q==
X-Gm-Message-State: AOAM530uEawpEnM7CV9UWZ/Rmbopult/56ExfYZ89ThlXurZM+/PYeek
        vz5O8H/im65KCnqFfLTMfASm23rn862pGCT3xEzQhQ==
X-Google-Smtp-Source: ABdhPJw0SEpfgNmkTFOByWXEkGXOMWDkmpJeBDY3t2/+PjRCKUuOxF02OC9Owogz/WB46NW4J1WxzJ5mIwIX7rR98M8=
X-Received: by 2002:a05:6638:3798:b0:321:4bf4:6899 with SMTP id
 w24-20020a056638379800b003214bf46899mr72406jal.257.1649086862432; Mon, 04 Apr
 2022 08:41:02 -0700 (PDT)
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
In-Reply-To: <20220404113240.7c3368e5@gandalf.local.home>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Mon, 4 Apr 2022 11:40:55 -0400
Message-ID: <CAEXW_YS+JsSPYu=8UoGZdwVMhF2cw9B9rODskFGfR4++dmDVVA@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 11:32 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 4 Apr 2022 11:27:58 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > Sure, if you compile it yourself, it may not be supported (which is what I
> > hit), but at least we guarantee that it will be supported across machines
> > using the same distro if we make it compile time dependent.
>
> Not to mention, I have use cases where trace-cmd needs to be installed in
> an environment with no dynamic libraries (nor using dlopen). Everything
> will be built statically. trace-cmd report will not be used, but trace-cmd
> agent will be.
>
> Remember, trace-cmd is to be embedded friendly.

Agreed, so should I send a patch next to do memfd unless
not-compressed? Is there an easy way to do not-compressed? Feel free
to rewrite my patch as well if doing this is trivial, I'm actually OOO
today for jury duty.

Thanks,

- Joel
