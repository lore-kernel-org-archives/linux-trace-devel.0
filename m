Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80EFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 05:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354934AbiDDFE7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 01:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbiDDFE6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 01:04:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777C33981E
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 Apr 2022 22:03:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id kw18so1467082pjb.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Apr 2022 22:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uadmUWbCiwbzFteuS4SWtHIclHIVZx6mZaLYokgNu9A=;
        b=L34CD3nzCTiVz6KYZJxBakPp0MR5K8tGYDbcDtudkYdbF2diEiChtzXkNs8WErOW2J
         2NpI5CYOFDeOnwmiUg+6LICZ+HlorG2d4vbVUYDNc3jsROU6aS6MrbiYGKCeY4pFc0yu
         vnoP7n7MawJeDt8igMy5kFEZI7yIiFHLVsR6FhOsrH4hQvASt8/7T/AaYIkt6/bcWbgO
         +hbs+/8sIjrkMhF7Uw2F+LFvjPPKa/X+jk5kpLzO8JqX/d+2XPCNWfjYqJFLXYaYLUa+
         Hvp7XM1j1Jc76USMbSFIuq+seTR+PIg+eZNJ7V/6hFmuqH0K9xh6pc49rtQt89CvRkzx
         LrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uadmUWbCiwbzFteuS4SWtHIclHIVZx6mZaLYokgNu9A=;
        b=L1GncejAu72sFvYaXAEAKIBLSWjhAieiGXn5MDVd1HCi3397r/wjZtqn/Mqhytqsv5
         OQSepU8ezBN+YbW4mE0u0/GsqRrO4vLpoFrqb97FbAEQsa2ut6Ot2VILCch+o8F9MJjP
         hAlPcEAYdYSkHCXmDfqiFmB7U2KpAurJXmKNs5rXiwG1OFK4wY2AFgBxsydvArdYb8jS
         JRpCIP+BiKieL4fRoxW7QoB6V+cyLYk0+BXZfWuYuI65snRXhxmU5OBLSc59tsZAFs43
         3YzYklA4Hz1TCFi7bvdp9J94bKb3HoS5zJBpKXwggyw8q67hP5rREh4vbY5z1KaqUDK4
         1ZHA==
X-Gm-Message-State: AOAM531FHcu8HNGHZIcIbWHl7yRBKvbMn7x6HHkU5pPNehTZC9iA9nXl
        WDiHnrmGf9PCFB7CEoWKtbEfH+nIW9NISXjjyxDioxwYO2A=
X-Google-Smtp-Source: ABdhPJwRZbm+I1Fvmy1gbFaKblzH1Scp9bUb0HrzXqc11hTGh6ceXzda0PNMn4gCxlkl84ULv+kO+wxY5P6PZjPNe7U=
X-Received: by 2002:a17:90b:4b4f:b0:1c7:d415:5b79 with SMTP id
 mi15-20020a17090b4b4f00b001c7d4155b79mr24521577pjb.96.1649048582883; Sun, 03
 Apr 2022 22:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com> <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
In-Reply-To: <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 4 Apr 2022 08:02:46 +0300
Message-ID: <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, vineethrp@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 7:41 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> w=
rote:
>
> On Sun, Apr 3, 2022 at 5:56 PM Joel Fernandes <joel@joelfernandes.org> wr=
ote:
> >
> > On Fri, Apr 01, 2022 at 07:06:29PM -0400, Steven Rostedt wrote:
> > > On Fri, 1 Apr 2022 15:50:10 -0400
> > > Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> > > > export TRACECMD_TEMPDIR=3D"/data"
> > > >
> > > > That=E2=80=99s fair. What about using memfd for this, do you feel t=
hat=E2=80=99s
> > > > reasonable? I have not yet measured how big this file gets but if i=
t=E2=80=99s
> > > > small enough that might work too.
> > >
> > > Is this a separate question? That is, do you mean using the above
> > > environment variable *and* then use memfd?
> > >
> > > I believe that the cache is used for passing the compressed data from=
 the
> > > guest to the host. I don't think it will be more than one compressed =
chunk.
> > >
> > > But Tzvetomir would know better.
> >
> > Hey Steve,
> > No its the same question. Instead of temp file, I was proposing in-memo=
ry
> > file using memfd_create(2), that way no hassle as long as the file is n=
ot too
> > huge.
> >
>
> Hi  Joel,
> That cache file is used for constructing the trace meta-data on the
> guest, before sending it to the host. Usually it is compressed, but it
> could be uncompressed in some cases (depending on the configuration) -
> and in that case it can grow up to a few megabytes. Using memfd is ok
> in most cases, but I'm wondering in the worst case - these few
> megabytes could be a problem, especially if the guest runs with a
> minimum amount of memory.
>

Can you check that file size on your Android setup with that command,
it will force to not use compression on the guest trace file:
   trace-cmd <host trace options> -A <guest> <guest trace options>
--file-version 7 --compression none

Thanks!

> > Also looks like my patch is incomplete anyway, I need to change
> > tracecmd_msg_handle_cache() as well.
> >
> > I'll try to write up a patch with memfd unless you guys disagree.
> >
> > Thanks,
> >
> > - Joel
> >
>
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
