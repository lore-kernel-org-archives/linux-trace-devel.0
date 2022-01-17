Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A99BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 09:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiAQJEC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 04:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbiAQJEB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 04:04:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143CDC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 01:04:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n8so7376179plc.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 01:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OoKrTZ5S5yK/u299fxAlHdn40CysO+t8nBJMMf3FjfA=;
        b=SyJtEIwMeUCBLYWexipuC+qiGHVcFHztfApfON9UU0L7/wrz9uAKCu/BNCnnpNYspD
         Xo1Qm+HlglG3kvww0DXskoK0Znh23t58bfi0bCnJb7uktcAalaoKrMtnXTwQRdGpQXZP
         +kh6zDZ8XFX5698DHnKYT8pmUUcuuwAH75DHc0iKuM/jOrhe6lCNF8KQGor44G21mOBo
         eb9Vk7OyA4J2zaqajyIj5fMuhh4+uPce70y/5lRs5A+XfZIpCm4vIEbeph1k1GJrdRSw
         Ivpm8M5mrm24nolZvxM8hzRbbchWtu1X49ACzJI9mqAt1VyvUce6n4gieZdmLmFBbYNF
         dVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OoKrTZ5S5yK/u299fxAlHdn40CysO+t8nBJMMf3FjfA=;
        b=0GkNppc8f/3Ic6eFh50+N59MWDjvvHIgFgGShwIT0l88L0rLAz4BoUXg4WelwvWaUk
         qr4BX62rO2PQzxH3z13J3+1rNJnM5npKT172T0+TQbswvxYzcPHyQSP0DIEITkfhdLyu
         fHPPSB2yGEeJr7V5+d0ATSF6zQjVdo7CZu+1kuue22TMMBV39TNhczzTG4FNVvivCTEN
         bDiwmPTGtq1EcVmvvC/AHq4+r3hBFdyBQjbb7G+gjF9lRxjsUlu42KI0VEZFeTEfHwRm
         6RAe9lVLsbyh5Ds2fH+C2dJkl4cYgbMP4usbcJqxNWGFL19Xn8+6nPdKFWKx0BAAdTAN
         rVGA==
X-Gm-Message-State: AOAM531QY6n32qLKWBzPclycEHB68fgTZFCI4tcbFWSdhljaTG5nHO0b
        aebq4lW3dCgg9znDKGUpqcm0kBZZV3c7GqXTKJ+JLs21
X-Google-Smtp-Source: ABdhPJzQjlREj3Hp5YNkfTPqFMp5L1WEpwwjdenyS3CThjcZ7evyt0Xs5+CYBKcPI3AaKA7y8PLZkOoVVdGUynspxU8=
X-Received: by 2002:a17:90a:8c0e:: with SMTP id a14mr33124172pjo.111.1642410240585;
 Mon, 17 Jan 2022 01:04:00 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20220115112119.222fa765@gandalf.local.home>
In-Reply-To: <20220115112119.222fa765@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 11:03:44 +0200
Message-ID: <CAPpZLN4Ou_4MHMn4fMcjhnB9ponO2q4ev8_nzY0_VqSGPe_g9A@mail.gmail.com>
Subject: Re: [PATCH v7 00/25] Trace file version 7 - sections
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 15, 2022 at 6:21 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 10 Dec 2021 12:54:23 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Introduce the next version of the trace-cmd trace file - 7. Major changes
> > since version 6 is more flexible extendable structure of the file, based on
> > independent sections.
> >
> > v7 changes:
> >  - Rebased on top of the latest master.
> >  - Introduced new metadata strings section.
> >  - Use 8 bytes for section size.
>
> I finished my review of this series. Looks good!
>
> I'm hoping that v8 will be the final one.
>
> Thanks Tzvetomir,
>
> -- Steve

Thanks Steven!
I'll submit the next version this week.

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
