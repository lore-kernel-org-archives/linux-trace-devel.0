Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0282C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 12:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiAMMiF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 07:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiAMMiF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 07:38:05 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D657FC06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 04:38:04 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id h1so9532445pls.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 04:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7YtqA6evyNhXRvko37jh8HCS5yQMaLOzmI/j1PhR538=;
        b=PJpDYP5nlqJDDz8VRPuG/xxQTqatdKmIleOz12R3xIriHApTc7p1H7Gb1JJtK+NAKh
         f+AX74N0um9BXEXvTtwyy/0iHmkE2q9rjlRnDwbjP1AExCwo0mcfw7pvdz3VSiktk0TS
         Z+FIayG64VplbCifEc1fIGJVymP5adcprEKqXYlxodk9sn1DXNd1759rCX+NZ6YHD2Qk
         nW6tgcXJ2rYFKRqfXKEHAxRsztZrCwALGQhtvnAe5srVKwgKa5JAzs49v4mP8y7DMB7G
         O+pFUdnwsN1z/3bxOnmljFn3VJADRIpyQE27i8LhMudOb8ehZHgr/zSDR4T7BUFrS580
         XAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7YtqA6evyNhXRvko37jh8HCS5yQMaLOzmI/j1PhR538=;
        b=NTkH2dSG0aepJTnFCvG1zyiLg3oqv1ctKqZIFHMeW/I2co/qs3ezjlFUzEgBT7KLNY
         rx6Qd/Z0sbggA18gZkCM2XNjSZLTIVDfjU//klD9Yw1X28Ce0EozApP/teMIdRxtMXpd
         bFIPqa6GH3ap7k/3IpD7TciQINGKOxzzeyGqj3wnjkBEU9yRTr57dvfebSZujh/Czenx
         mMZ7F6EAb0p+HNn7AWSYAlQ0lNUnF133ALU75WtvrjU3cVjFvByZtZYUQCIkJjXdy8qe
         xNhJBBis+udD1Wk4Z2qRzh3/dkwiyh92G7b3FYZsfVt2MAD4ZLgsXrl7HyNfc+ej6HiI
         J8Sw==
X-Gm-Message-State: AOAM531uJ08Vxpxlsqr3hULGXOUvo1yyOejNySxnDgYekebOoqq8GGTz
        NCgl2QGsBfAfiDS30SX+XK5jaE+/HaqELBXdcLMNxwbP
X-Google-Smtp-Source: ABdhPJwgTH+P4MNJD38ECkuIsaBSSoNEYYdlS/D6ekOPUJIBDr3fjWGI9XgNW8YycdFeDjENtZzGd1ejqupOXXmyKfE=
X-Received: by 2002:a17:90a:8c0e:: with SMTP id a14mr14191867pjo.111.1642077484311;
 Thu, 13 Jan 2022 04:38:04 -0800 (PST)
MIME-Version: 1.0
References: <20220112163619.21762-1-y.karadz@gmail.com> <CAPpZLN7=q-DiOQWDmv5SdV7xyu9TCHHZNP_Cfq4Gdo2c2GMMPg@mail.gmail.com>
 <38d4a2a8-5110-2c19-be01-53a820726383@gmail.com>
In-Reply-To: <38d4a2a8-5110-2c19-be01-53a820726383@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 13 Jan 2022 14:37:48 +0200
Message-ID: <CAPpZLN7C7dBzzBuvtofz8zYh33utTzDC2x85MGPN2oGPvoksKA@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: New API for getting synthetic event
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 13, 2022 at 12:26 PM Yordan Karadzhov <y.karadz@gmail.com> wrot=
e:
>
>
>
> On 13.01.22 =D0=B3. 7:01 =D1=87., Tzvetomir Stoyanov wrote:
> >> +struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle =
pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
> > The arguments of the other functions in this man page are not
> > underlined, all should follow the same style. As in the other man
> > pages of the library all arguments are underlined, this should be the
> > default style.
> > This could be addressed in a follow up patch - applying the same style
> > of all tracefs man pages.
> >
>
> So, do I have to change something on this particular line?

This line is OK, I'll submit a patch to unify the other man pages. The
arguments should be underlined.

>
> Thanks!
> Yordan



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
