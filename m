Return-Path: <SRS0=NeNm=6X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B9EC28CBC
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 19:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55117208E4
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 19:11:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aub4ajBG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEITLq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 May 2020 15:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727938AbgEITLp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 May 2020 15:11:45 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EE8C061A0C
        for <linux-trace-devel@vger.kernel.org>; Sat,  9 May 2020 12:11:45 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id i27so4281425ota.7
        for <linux-trace-devel@vger.kernel.org>; Sat, 09 May 2020 12:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tZHTttwA+pKsYMhbMpGGSexCCvUSurdAjmC53K0Mvr8=;
        b=aub4ajBGwUpbrm0vJs+rOmNB/4HG+eEzSkUK6yEcAvF8l2aNXumVrPm2WjwHTneJa9
         PxDLAcrgYfXhsd8DryV7fpaAJuRDt8p2v5+Dn3DIiuHbMojUhheBZu7ohFx3O/8QK5L1
         1s7IAUfFWUTszSiS07DzDJgDyNmdax5mVxveq8YJtDRoHuBIjA4ZlRTiaE23qimNslK9
         5xiFZI+y3IIX6SbjYviPaaq3YxBdmJAcpT8q+HAIt5fjbFCVc4SMVzP9f9U9pJcwDmG0
         yTacLqjHZbfA1CfooeyIam61azBSkXu3LjpHDKZA9+5ghwtYYtJdeDu0k8x/WEV08kA0
         +j7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tZHTttwA+pKsYMhbMpGGSexCCvUSurdAjmC53K0Mvr8=;
        b=J2Q8btoJOAMptpkB6F1yQU/H6s2StV4GBdN+1Cvnrv6OBoLmV2YJaca0+DG+xjBtnT
         IYmYd/MquMgr99vOMdg2EX9+EIRWjwk8cc7W+QFor1v4RPkd/CycsmtMssFJHO8++0dV
         AMy3i6t680idDAF2JQg4KyVL4BXOX9Nta6UtH2egRfdaOapuekdKI/D87ifY9u8VCdH6
         VLJa09UVZd2V0QIcIuqSDKg2aOsbD7SKSW3r4Val4JdShz1tVh85I72CCa7uo9gPASTM
         NZG0CW3jx8+70oJgX7XHUHgotbSmV5Bcv7jGIQ+Z7ugV91HqGgFC7l5rywVKn91QKsvI
         Czpg==
X-Gm-Message-State: AGi0PuYodGqr+JMQPb268Ig3iuuA24Lcpdfk/gbB91C1QHDRFld1r9be
        rlCiGf/if3K8XYG+wv2hc9HZq7SA/7UkrBXh4Z8=
X-Google-Smtp-Source: APiQypIek5ow9+FAbJgqeaKPKiGMN6XzLKnDOtfPOXXrhDRiLMdhsOmz7iEI1ie3KLlb780ubjzXYJf8g9/AxW/ROd0=
X-Received: by 2002:a9d:810:: with SMTP id 16mr6747524oty.56.1589051505218;
 Sat, 09 May 2020 12:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
 <20200420154325.6072d96b@gandalf.local.home> <20200420155320.55d3c3f2@gandalf.local.home>
 <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
 <CADVatmMaEd3jaT0UoGi2C2Xx7dNSaGmiaVcAk89SPCRAjEfGwg@mail.gmail.com>
 <20200508101134.1f957f0b@gandalf.local.home> <CADVatmN=Z0ASVXUBTyAu6F_TWoWiKiKsgm404rOx7Oh-a6LiQg@mail.gmail.com>
 <20200509144853.081f4a70@oasis.local.home>
In-Reply-To: <20200509144853.081f4a70@oasis.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sat, 9 May 2020 20:11:09 +0100
Message-ID: <CADVatmOs5vHf4Zj5z4fCRB7GP1PjXGcsWB-s08DfTb-2kw60cw@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, May 9, 2020 at 7:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 9 May 2020 19:30:38 +0100
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> >
> > > Thanks for the reminder, I haven't forgotten about it, just had other
> > > things added on top of my "todo" list.
> > >
> > > I'll go apply this now.
> >
> > Thanks. And now kernelshark fails. :(
> >
>
> Have you tried doing a make clean and building again? Sometimes the
> updates leave objects in place that need to be recompiled, but the
> dependencies may miss them.

The build will be done in a new chroot every time so there is no
chance of objects from a previous build. Just to make sure I did 'git
clone' in a new folder and tried to build again. And it=E2=80=99s the same
failure. Also did 'make clean' and built again with the same failure.


--=20
Regards
Sudip
