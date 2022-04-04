Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EA7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 14:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376505AbiDDONz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358161AbiDDONx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 10:13:53 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406CD3ED3E
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 07:11:57 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id b16so11399415ioz.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 07:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=akWlQ4MY7bwAPfW4bB2uj8lbgtxd1LsYEXJmtSkFR1Q=;
        b=UoKFDcSVZtBKKZOHPDLK3pr8INsevaz8ry5UE4QqeTSL140PhXBDJY6ryx0iVyMhS5
         61m/IFCGgq/3TyzeN/M4S9kiuI3wa5EuD7EnH88Ukcm9yugnFqmejWPrJ0snSi4t3mKz
         biDfWRpb7jvjya7izPFfVFFJMLcd179h4GbeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=akWlQ4MY7bwAPfW4bB2uj8lbgtxd1LsYEXJmtSkFR1Q=;
        b=Dw7bCYT3oxoRnpAjYSHiQ11KR7e3fNlVUrhGNVPVL3/jkk0KMjZ1OFrDr1kbIru3/8
         P5aF/D/NQHYN90IMzFAOTJniU3RgNXHcpcTOOSWftscqlFz7OFhvrC0nzJTsEO4yKztP
         zFg68zG/trdllekAomm9hYVxZJz9D4W3l2ggNZkLix5mf0p2VKNKReUol4rPyMSt+dcS
         nvJvPUdXQnFAV0dL2xjLfLGuiUIMzGXuUfOt8c/WMoRRo8jzgFBmZ2sQM37C2OeJn3vl
         eKmgjuPKmlVCXMtm2jQ/bBq1qxDf760Rv8LyaGQ9S33dAk/HM6PqfnLuDteGv8hmgdmP
         DcpQ==
X-Gm-Message-State: AOAM531B7ajhvuFvfCVIW36YA1sCNo6omhGEu5nWWIcr4EZmeSn8qfVi
        1wz9thqNsFr/jLMtzc0Z7NoZHTb7FKbdAo4JtCbMWA==
X-Google-Smtp-Source: ABdhPJxrZ6W01m5lYSSXroodBdEv4Nm8e2Z6ib09fXJXsuNsoWz7M47MRhTOLGauircuRrBLex8po/06/+2D0BGqoMk=
X-Received: by 2002:a6b:fb17:0:b0:649:b0dd:e381 with SMTP id
 h23-20020a6bfb17000000b00649b0dde381mr87900iog.95.1649081516640; Mon, 04 Apr
 2022 07:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
 <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
 <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
 <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com> <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
In-Reply-To: <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Mon, 4 Apr 2022 10:11:49 -0400
Message-ID: <CAEXW_YSosUGE5Xvs5=q7B0SsBv0ZcCzAiexiGzsGsZ+w5CFWPA@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

On Mon, Apr 4, 2022 at 9:48 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> w=
rote:
>
> On Mon, Apr 4, 2022 at 4:21 PM Joel Fernandes <joel@joelfernandes.org> wr=
ote:
[..]
> > > > >
> > > > > On Fri, Apr 01, 2022 at 07:06:29PM -0400, Steven Rostedt wrote:
> > > > > > On Fri, 1 Apr 2022 15:50:10 -0400
> > > > > > Joel Fernandes <joel@joelfernandes.org> wrote:
> > > > > >
> > > > > > > export TRACECMD_TEMPDIR=3D"/data"
> > > > > > >
> > > > > > > That=E2=80=99s fair. What about using memfd for this, do you =
feel that=E2=80=99s
> > > > > > > reasonable? I have not yet measured how big this file gets bu=
t if it=E2=80=99s
> > > > > > > small enough that might work too.
> > > > > >
> > > > > > Is this a separate question? That is, do you mean using the abo=
ve
> > > > > > environment variable *and* then use memfd?
> > > > > >
> > > > > > I believe that the cache is used for passing the compressed dat=
a from the
> > > > > > guest to the host. I don't think it will be more than one compr=
essed chunk.
> > > > > >
> > > > > > But Tzvetomir would know better.
> > > > >
> > > > > Hey Steve,
> > > > > No its the same question. Instead of temp file, I was proposing i=
n-memory
> > > > > file using memfd_create(2), that way no hassle as long as the fil=
e is not too
> > > > > huge.
> > > > >
> > > >
> > > > Hi  Joel,
> > > > That cache file is used for constructing the trace meta-data on the
> > > > guest, before sending it to the host. Usually it is compressed, but=
 it
> > > > could be uncompressed in some cases (depending on the configuration=
) -
> > > > and in that case it can grow up to a few megabytes. Using memfd is =
ok
> > > > in most cases, but I'm wondering in the worst case - these few
> > > > megabytes could be a problem, especially if the guest runs with a
> > > > minimum amount of memory.
> > > >
> > >
> > > Can you check that file size on your Android setup with that command,
> > > it will force to not use compression on the guest trace file:
> > >    trace-cmd <host trace options> -A <guest> <guest trace options>
> > > --file-version 7 --compression none
> >
> > The file grows to 5.3MB with this. Is this really the common case
> > though? If not, I would still prefer memfd tbh. Is that Ok with you?
> >
>
> There are two cases that could hit this:
>  1. Using a " --compression none" flag on the guest file. We could
> disable that flag and force trace file v7 always to use compression. I
> cannot imagine a use case for uncompressed trace file, maybe only for
> debug purposes ?
>  2. If, for some reason, there are no supported compression libraries
> on the guest. Trace-cmd supports libz and libzstd, I believe both are
> widely available. Theoretically it could be possible to have some
> minimalistic VM image without any of these libraries.
> What are the advantages of using memfd instead of temp file, is it
> only for performance ? Usually collecting trace metadata is not
> performance critical, as it is done before starting the trace.
> I think that the best solution is to use memfd in case the guest file
> is compressed and switch back to a temp file in case of a
> not-compressed file.

Thanks for the background. The only reason for my use of memfd is to
do away with absolute file paths and temp directories, while fixing
the problem and keeping the code simple.

Steve, any opinions on this?

Thanks,

Joel
