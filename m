Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D6AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 21:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379668AbiDDVaB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379519AbiDDRWG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 13:22:06 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8415C26116
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 10:20:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z7so12155987iom.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 10:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KFaJjvGsDDGJnz7oDA5LRlFD9zcU/izVh2jOfMotfqc=;
        b=OCcY+DGidATZLym93BotyUqzafp4SGlcQCA1ometVNzN7oAPEb9f5h81YMIEmnAD7i
         5YA/zEqokavCC0auC09y+dEenrPdY10DCUn/UST/0FsyPOA5gWlYr27dEV4UPb0HgLvR
         KnjPRPiMhX5nsQ6YBSlrIlVPeLR1hAkMyWW58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KFaJjvGsDDGJnz7oDA5LRlFD9zcU/izVh2jOfMotfqc=;
        b=xoVsfjvfQQh64ZAm5xTQQoeHZnYSmXQeGSgDdeQGf7v2h4UFa4d8oqScv1XowR8xp5
         XkOXEp+0wXU2szaB5JJ11Do4rW7t3YbPhxt8qtUWlejYwwsvABRykJjixcRPhiambj5v
         xIoS7eTaLsvKx23IWlVRDuimFxkRiNrAVUyYCpZHK9WE5SL+68bCWUCu5m1+uD8inO6C
         jZR40TnjBgIeZXIVNC11tZMjR0KyDabE0FahVrRhGQzFPWqS2HAoXM+lU2Gfi/3O9oDJ
         StIJmUCMRe5UXQ51PTVKSFrALFGy1dhKTNZ6eIne4kogYtSx7nUW+iB1y9Cusy24pxZ9
         hvag==
X-Gm-Message-State: AOAM533U3akl8pH3a6+m3Quu3zkEECuQ62k0K1if4F3nnAeqrXIs0lHg
        Sv/mYfvIeKGZuYUQWyML5pQe/2wDpQ+ynIXlD/VlmA==
X-Google-Smtp-Source: ABdhPJw5gumH84rSPEAODV3utNsgAFnNBRSiTIA1Qh8Iw0+p68oNN9I5PrK+HwY2Sw4m19/Y0wPhRIAvf9JUeEWdfDk=
X-Received: by 2002:a5d:94c2:0:b0:60b:bd34:bb6f with SMTP id
 y2-20020a5d94c2000000b0060bbd34bb6fmr608087ior.32.1649092808967; Mon, 04 Apr
 2022 10:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
 <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
 <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
 <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
 <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
 <20220404103525.1ec0b246@gandalf.local.home> <CAPpZLN71si6G5=O=sM5suNp+NtXYz=0U+=3O2XCCWmqhp8M-Tg@mail.gmail.com>
 <20220404110424.78f14d9e@gandalf.local.home> <CAPpZLN6h5RaVdGoA9LfXn67bvdhfb4VZoipjiv1wJzCpdSTPPA@mail.gmail.com>
 <20220404112758.3e32bd40@gandalf.local.home> <20220404113240.7c3368e5@gandalf.local.home>
 <CAEXW_YS+JsSPYu=8UoGZdwVMhF2cw9B9rODskFGfR4++dmDVVA@mail.gmail.com>
 <CAEXW_YR5bSNxa_+NfMXqCNj4MvUbV=RX2NaSTasXU4NhqDUcQQ@mail.gmail.com> <20220404114744.283d4746@gandalf.local.home>
In-Reply-To: <20220404114744.283d4746@gandalf.local.home>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Mon, 4 Apr 2022 13:20:00 -0400
Message-ID: <CAEXW_YQnJ+USoaqYW7oHAt6aFi3VJfVz3bV5=XRL8GqCGUCiqQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 11:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 4 Apr 2022 11:41:58 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
>
> > > Agreed, so should I send a patch next to do memfd unless
> > > not-compressed? Is there an easy way to do not-compressed?
> >
> > Sorry I meant "is there an easy way to detect, in this code path, that
> > we are running in not compressed mode" ? I guess I could just check
> > the argv but I haven't looked closely yet.
>
> From that function not yet. We could add a flag.
>
> I think we could just take this patch and then I could add a way to put
> back the mktemp in compression = none mode.
>
> I rather have it broken up into multiple patches anyway.

That sounds good to me, thanks.

 - Joel
