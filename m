Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26953C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC88B64DE8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBRDuk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 22:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBRDuj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 22:50:39 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA56C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:49:59 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x136so391238pfc.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qeq/v9uWl5MQLZ3XaQglcfyGSEReVTB5FCKN3OEKFKo=;
        b=rvy93ciqfwos+cccuKHuL7TbYGn1IOaUIEbTVRXBekq3y6cgJQRO0xWG2sZu17RSdm
         X6d3zmEvPa2GeYoFOMTF2ECY/8MqNzY5iX7bCnuj0PFWe11ekVM64yafDb7iWh4+uGoV
         fSRIpXgCxc4efvQLz7Rvmf9zOsUECaiR2S0aze+up54htD8SpWqnJMop0wTdR9aEY84F
         oE06SAxpFfKSosuh0UnDarQZjrXAJNZMtuxDBI9uZPyBmlmiF8uD4RFL0I6bPui0yNTr
         +y1Wju8Fa0BzDhhNFz0Tu4CvpMvdLMuDimW6xxumyFoJ4y8te4gf9X301pATFPJCP3ZH
         ULYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qeq/v9uWl5MQLZ3XaQglcfyGSEReVTB5FCKN3OEKFKo=;
        b=qVJ9cCEjCMYoCZNWFs859FSsj8Ha07r+zVCuzvpyfrU2kVKFuEdQyVqhEeiWfKs0z5
         U+Ew+bSjQfcIE0nYcb0S1tLLRqHIHdVFHR7PHcV8669e0EYnHRddB2jVgDEVxYgUH0mn
         U/4K41Va87ma5mCrC2XDQpVgi1Ri17txh9m2tv5o7xl4fguLLA8Iu6DimAu6mSi5brwF
         XmoU/f0w/qltMQjAXK/Kncnk1MQ6kyln4muXUnHtI4WfrnEx7lUx7cmiXsu3lQdJak2I
         Hai1WuofG4T4KcYLzx+7VYJq0a0xXYWVNdUyWpundcxsrWVr/hnPWlghuKhCFu+6ClqB
         HZRg==
X-Gm-Message-State: AOAM531FmKkTLIYQNjyvs4n77RuAyiWRkdgayZrehyYXm4H5DmEzik0b
        mXmZGn1dVqrLoooEReoS1faTmPJwn+xJnzvLuySujXIWC5g4yg==
X-Google-Smtp-Source: ABdhPJxaZsPZ1S8Q3psCBddfUC+wVqrv3ejdQKl7mYpSd5ww65bwP633tL+0N+flw8Rk7YO4GKImlS3oUYY7i1Y2P9E=
X-Received: by 2002:a62:6346:0:b029:1db:a562:be79 with SMTP id
 x67-20020a6263460000b02901dba562be79mr2383712pfb.81.1613620198708; Wed, 17
 Feb 2021 19:49:58 -0800 (PST)
MIME-Version: 1.0
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
 <20210217042341.1675546-2-tz.stoyanov@gmail.com> <20210217110045.71771e87@gandalf.local.home>
 <CAPpZLN4EoCES6CHo8uoyOoFr9nopOkQZKVF5voFPCYM4pnzyhg@mail.gmail.com> <20210217132749.70281f99@gandalf.local.home>
In-Reply-To: <20210217132749.70281f99@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Feb 2021 05:49:41 +0200
Message-ID: <CAPpZLN7L4Yg4ePE-dWQ+WHf6h_8gShcYBEBSGrxDrvV32DOv9w@mail.gmail.com>
Subject: Re: [PATCH 1/2] trace-cmd: Add validation for reading and writing
 trace.dat files
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Feb 17, 2021 at 8:27 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 17 Feb 2021 18:33:32 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> > >
> > > Why did you use bits, and not just a number?
> > >
>
> >
> > I use these flags to track what is in the file, not just a state. The
> > state is the most significant bit which is set,
> > but that way there is information for all passed states. I use the
> > same logic when reading the file, to verify if
> > all required information is in the file.
>
> Of course if this is done via states, entering one state assumes that all
> previous states have been entered (and thus must be set). For cases of
> FLYRECORD and LATENCY, those two would diverge in states (basically like
> branches in a tree), but still maintain that being in any given state,
> stores the information that all previous states have been hit.
>
> Or do you know of a situation where that is not the case?

This works for the current structure of trace.dat file, we can have
these assumptions
and use state instead of a bitmask. But in the future, if we decide to
add optional
sections in the file, or more complex branches - assumptions could not
be valid and
state should be changed to something more flexible.
As this is not part of any external API, I'm OK to change bitmask to
state. This easily
can be redesigned in the future, if needed.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
