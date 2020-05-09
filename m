Return-Path: <SRS0=NeNm=6X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37369C47255
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 23:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 070F121582
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 23:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5CUJHcq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgEIX2f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 May 2020 19:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725927AbgEIX2f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 May 2020 19:28:35 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4E7C061A0C
        for <linux-trace-devel@vger.kernel.org>; Sat,  9 May 2020 16:28:35 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id v6so1171239oou.4
        for <linux-trace-devel@vger.kernel.org>; Sat, 09 May 2020 16:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UFJJ7jmaA7IkWkmQCgTxB0EhEcitYbK1w4fbY9ps+RI=;
        b=G5CUJHcqU9R3kVmJMhNrdRJodbxUYRsMynSqptQcdYHnFv4lJLZ7GPWMD/7PqZlRHk
         yFykw63uDweExVju3+d1x11yt19l/E/83/LVVcBhtBcBB322mYHj76t0Qs/qBmSUQkMp
         WIcKUhBxmhF4zAKQXJ29tFAsNDQTrh+XmZ3zWcX0kemw0AYosgwheQ1ZVvuL1NwHPKIT
         vtNwOLqTJVmKbSrOQirenrWMPFf1cg/B7tHnDR5R/cU4FdLMkxZjzmR38jGmAWxEkyjK
         FkGTWMLE+N47NR7Zjs1T/6WtnO+7Jihm4hqTJ6TuNAYG40HC/k3j5Zmx7j99ZYygI9t5
         sP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UFJJ7jmaA7IkWkmQCgTxB0EhEcitYbK1w4fbY9ps+RI=;
        b=dWQSRTRr5UicGdhE+LcHgenDPdixzeKU7p57jlVMtzCMDZQceAlX5/BWhWYI1KaA/R
         V6Xi/MaYg75CIN+7Rc4f7u1Eas56duVc3b5/ptCq7xo42lpnbpYPwnt7LwnVkNrOYyx5
         bJNFKwUxZj6wYQ8sMAZL/SNfnlgvaiGUgSeN1ND3OCEmbtrZbCCQGqPg2YibUgqSPX5G
         2YxxM1FCPCx09bJ16I5xzoMzCGzokSdTJqamYot/zK33Yy3m65a+qHp0datwH5Rgf7/h
         3r4wszfzVhZ+9L7fotrtrE1oh4gGEg9lo6mMwPfo6rcD6eEhIXQry+Q2Eob7qkRUAw/P
         fXaw==
X-Gm-Message-State: AGi0PuZWzpasE8Hyr1CoaSd666p/qyILModqcaOnBygxK8rWoX14i3Zg
        cOzIgMxGWzQkZZNq81aXI+K1PSHRDXjsrN/2mRWoUGfg
X-Google-Smtp-Source: APiQypINw/TwwWrjsH9GWl7xM1VteK/SZCWiexQGItGIkIQ/buR19jL2WGWMsqKR3tXiSOWEXaO5P4C+3Mg+SX538hg=
X-Received: by 2002:a4a:d02b:: with SMTP id w11mr3201207oor.87.1589066914500;
 Sat, 09 May 2020 16:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
 <20200420154325.6072d96b@gandalf.local.home> <20200420155320.55d3c3f2@gandalf.local.home>
 <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
 <CADVatmMaEd3jaT0UoGi2C2Xx7dNSaGmiaVcAk89SPCRAjEfGwg@mail.gmail.com>
 <20200508101134.1f957f0b@gandalf.local.home> <CADVatmN=Z0ASVXUBTyAu6F_TWoWiKiKsgm404rOx7Oh-a6LiQg@mail.gmail.com>
 <20200509144853.081f4a70@oasis.local.home> <CADVatmOs5vHf4Zj5z4fCRB7GP1PjXGcsWB-s08DfTb-2kw60cw@mail.gmail.com>
 <20200509171237.65f3b851@oasis.local.home>
In-Reply-To: <20200509171237.65f3b851@oasis.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sun, 10 May 2020 00:27:58 +0100
Message-ID: <CADVatmNAjS2W7wWEeWD---dxkjW84GEArC7Yt-DO=-gtbXJt5Q@mail.gmail.com>
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

On Sat, May 9, 2020 at 10:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 9 May 2020 20:11:09 +0100
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> > On Sat, May 9, 2020 at 7:48 PM Steven Rostedt <rostedt@goodmis.org> wro=
te:
> > >
> > > On Sat, 9 May 2020 19:30:38 +0100
> > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > > >
> > > > > Thanks for the reminder, I haven't forgotten about it, just had o=
ther
> > > > > things added on top of my "todo" list.
> > > > >
> > > > > I'll go apply this now.
> > > >
> > > > Thanks. And now kernelshark fails. :(
> > > >
> > >
> > > Have you tried doing a make clean and building again? Sometimes the
> > > updates leave objects in place that need to be recompiled, but the
> > > dependencies may miss them.
> >
> > The build will be done in a new chroot every time so there is no
> > chance of objects from a previous build. Just to make sure I did 'git
> > clone' in a new folder and tried to build again. And it=E2=80=99s the s=
ame
> > failure. Also did 'make clean' and built again with the same failure.
> >
> >
>
> Hmm, I wonder if something like this fixes it?

Yes, it does. :)


--=20
Regards
Sudip
