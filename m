Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6AFC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 03:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77A961448
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 03:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhD2DfU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhD2DfT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 23:35:19 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC2C06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 20:34:31 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id j189so2448229pgd.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 20:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qO9xh4aImB1N7YWlf0hrL1UDntNU++eu/QvyS2oLOYY=;
        b=DDg09mlPSDLE3ezBdY+r5vYrv56dzZOJb1xG5PZgYN757pEwF72Jc0HuufM9jXhZr1
         ACaHvCzQjH9i2zLeApMO+qHwTiB13ODCOEM+Tre7irXVOFQnARnwuRT5MfIif45KmiK4
         dmGAJfX+cIMkSyPNYGTo2fdKbTPjCTDjRG6xlrWSl9FWWSvv4fy8E2uuMqjflJ2GsTPO
         USsZvMN0Oo6ALeGYsKFfc4rK15F0OXFc5kOHoRluY3WkfJv1WgReNRq/H+oNQCZUySRP
         uGPqd+RepUVUmC3n4wP9yVAJbqGBp+LgLFXqikNq9kGy7btNFMU/XLIzeJwf/W1zA6b0
         Xd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qO9xh4aImB1N7YWlf0hrL1UDntNU++eu/QvyS2oLOYY=;
        b=rFMZ0dLivtl21vb3Pbs1mO87p6AhrbRS0ieASEmcsMhEePxflN4kDCg2VDV29YUYCo
         18sdtXU0w9xfnHU3BZardOQrodxrxOKvdoq47rXxFSRDpi2BN50ZVW7GFcw+LpzL+NLZ
         6yv849rVHMzYTesqEQy1WiG7kVopbqXmYp33GS50cryrNQUA5JRukhhVsqIRYlwbMDpM
         EecXzn1nKxzQFPKZ6b8gbbPXxAeQMEJ2ksUJ3RtpOmcGzJkJjBTq0HrjeqdGMo/uLVWZ
         YMqyYpH/cnh7VHOX7ZZaFEUjIWl1GA1B7haV0i/ArWSoD9NzAlIWdLv64K6BtYlg/chD
         pV6w==
X-Gm-Message-State: AOAM533q+7k/c8a1TYPlRdqve/09Ta4+igBalpvpjqWHNeUbv2YY1tug
        gIoHLM+LmboosYUnPxukaSiOKZJ/MBhtdtjIzbKbC1L/64ZITA==
X-Google-Smtp-Source: ABdhPJwecJ+zUuIbiXuZdQBenAwugePo8BtAAeoISsMLWp9O6JP4KOEe90Xj/KbjJ/i+nisVCTrv9bqXwhLtoC0a0dw=
X-Received: by 2002:a63:540b:: with SMTP id i11mr13223557pgb.44.1619667270657;
 Wed, 28 Apr 2021 20:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
 <20210422071718.483383-7-tz.stoyanov@gmail.com> <20210428212618.41262613@oasis.local.home>
In-Reply-To: <20210428212618.41262613@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 29 Apr 2021 06:34:14 +0300
Message-ID: <CAPpZLN5dPvu6uJp4FMFCefeZdwtVXgNnCK4+rqOm6S46Xh-KFA@mail.gmail.com>
Subject: Re: [PATCH 6/6] trace-cmd record: Add new parameter --file-version
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 29, 2021 at 4:26 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 22 Apr 2021 10:17:18 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Added a new optional parameter to "trace-cmd record", can be used to
> > select the desired file version of the trace output file.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>
> Even with this last patch, I still get:
>
> trace-input.c: In function =E2=80=98tracecmd_get_file_version=E2=80=99:
> trace-input.c:4033:15: error: =E2=80=98struct tracecmd_input=E2=80=99 has=
 no member named =E2=80=98file_version=E2=80=99
>  4033 |  return handle->file_version;
>       |               ^~
> trace-input.c:4034:1: warning: control reaches end of non-void function [=
-Wreturn-type]
>  4034 | }
>
> So you must have added a change without somehow committing it :-/

The confusion is from another dependency - the "[PATCH 0/6] Bump trace
file version" patchset depends on "[PATCH v2] trace-cmd: Check if file
version is supported". I wrote that in the cover letter, but maybe
that patch should be part of the set as well. I'll send the v2 of the
"Bump trace file version" with this additional patch. Strange, I do
not see that patchset in patchwork, only in the mailing list.




>
> -- Steve



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
