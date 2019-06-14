Return-Path: <SRS0=/4Dl=UN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253D0C31E44
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 04:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E27A720851
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jun 2019 04:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qh7SnnjT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfFNEkR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 00:40:17 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34832 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfFNEkR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 00:40:17 -0400
Received: by mail-ot1-f66.google.com with SMTP id j19so1450177otq.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jun 2019 21:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CKP9sog/AHjGlkOEG/j6sBYBxAYThrW/dC8B1hQCMSc=;
        b=Qh7SnnjTimxLN1hwBmwSWI5pmQZdNBVj03lVLoZecic2FO3oSmt/sC1qaZAW6SXnMf
         St/EjBoCsfVojoW02kJbjI7GXFOHf9H7bKZqXmweCZWMXqhPjedOm8Yhiwr78sYhE44M
         JndtOsj70vAhLQX96dWbhgFW/o+nnrJpsQ5EHOpk2QyL++QngKWSjxxn3sHkJfyxX1iL
         JxyiK4w2NtU3+WKsLG0SApmyk8rAcEzB7GdH/+xytIb5Pzgb7rChBvdhbEhwrmOy9TVz
         REO66cH+lcbIRG6u/Bfjsvh4FKfAJhrpeXcegvomDpv1AnNSO2okCRa0bhhUTrzOPVTG
         rxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CKP9sog/AHjGlkOEG/j6sBYBxAYThrW/dC8B1hQCMSc=;
        b=NeklGhefstJCOQ1DWRWYCsAMVHDXRlcn2hm78BFfNNycosXmLPwIOYhcovuRLCG42K
         9QrJRWfhWxbmASdJ7pRKeH9//c+cQZTg/jgrintflk64jNUfMF1m3FlEHJmP68lGThMB
         BebJmIrE0il6Gsr8jHGU6B70+aouDd3IJuVpvzMuUU6C2uwxlOuIAdre224GHbI2pUzf
         QvVUpMkonCyzoKycefKbv0tAGgzW9Sv8cW4VRpVuJ++ecNHY3nC4ME4xSLG8o0CSt7KZ
         0uoSm9o1QeUeq+I7G09KFQ1nUH+JdGemBGME77BAHYsxf5wFgUyBPvSJLWKApVAAK6F9
         P2Gg==
X-Gm-Message-State: APjAAAVwXbixNObHN7JtDd8IBPyZYOUGYXpkE8y0e/q4eUQU2ZZnbysr
        kudakPngCjyds4YNwd7wLywdxKIuCXvT1EhKgNfnYw==
X-Google-Smtp-Source: APXvYqxBSy+Ozfhh1WzmTQ3DlpSj/JtPbHSQ1YG0XcgoNoI8y1hcAGvKXoRSdehK6PCJE+iTjmAqueWPjxK/Sxt2/as=
X-Received: by 2002:a05:6830:1558:: with SMTP id l24mr11465154otp.352.1560487216540;
 Thu, 13 Jun 2019 21:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190612035902.16366-1-amikhak@wirelessfabric.com>
 <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com> <CAOY98NeuPDgnpiHZqepa1gBuSjaDuyOgySccBeuRwLj4XdVe+g@mail.gmail.com>
In-Reply-To: <CAOY98NeuPDgnpiHZqepa1gBuSjaDuyOgySccBeuRwLj4XdVe+g@mail.gmail.com>
From:   Alan Mikhak <alanmikhak@gmail.com>
Date:   Thu, 13 Jun 2019 21:40:03 -0700
Message-ID: <CAOY98Nd=HnFWMvB1DQkO4Dq6PX-LZ0VJQ6hsNk=Z52j-1OSuLA@mail.gmail.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 8:22 AM Alan Mikhak <alanmikhak@gmail.com> wrote:
>
> On Wed, Jun 12, 2019 at 12:34 AM Yordan Karadzhov <ykaradzhov@vmware.com>=
 wrote:
> > On 12.06.19 =D0=B3. 6:59 =D1=87., Alan Mikhak wrote:
> > > Fix compiler error at KsSession.cpp:457:30 on Raspberry Pi 3
> ::
> > I am really curious to know how does KernelShark look and feel on
> > Raspberry Pi. Would you shared with us your impressions.
> > Honestly, I will be surprised if everything works fine ;)
> >
>
> Hi Yordan,
>
> KernelShark launches on my Raspberry Pi 3 model B+, loads my trace
> file, renders the screen elements, and is responsive. I have enabled a
> swap file and GPU acceleration with extra memory for the GPU. From
> looking at the code, rendering may even work on the CPU without
> acceleration, but haven't tried it.
>
> The abort issue on libkshark-model.c:242 currently limits KernelShark
> on my Raspberry Pi 3 model B+:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D203869

Hi Yorday,

I installed trace-cmd and kernelshark on my Raspberry Pi 3 model B+
using the following command:

$ sudo apt install trace-cmd kernelshark

The version of kernelshark installed by 'apt install' runs smoothly on
my Raspberry Pi 3 model B+ and doesn't exhibit the abort issue I
reported here about the version I built from sources.

Regards,
Alan
