Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F15C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 04:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377120AbiDDEnh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 00:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiDDEng (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 00:43:36 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F86329A8
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 Apr 2022 21:41:41 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id z16so7889173pfh.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Apr 2022 21:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8PvKk5ghJ6tKIOitssSRP03giEIWEvCEKM+eRMgUlX8=;
        b=iVUngS6r6tVwxuNgWcfd1oQxyrJ8zdYHpr1acqDelQ70/7G3iTV3EyrO6PQqBEKd8a
         cNsQNGFGU2buRgrCcNGLcwXXwKrAc369ou7F1gMLGsr0gnA/lkg7Q4VOpQDkprQEztrO
         Kmd9HnFpfX6i5ph1Nly8pov0DvNtfY8CZ6y8npM7lZ+uNQZIZqkrWy1iXpbC8LEMZArC
         Q7CA6z0X7epHeMs7vISMnBMVuf7j8b8VTKcCcuA/V2GRCnrHlmBlfJJJlpvKLOeGSidZ
         pWPEh6lIpRDfwEWKQz3SqUXNWbCoaF5JJ0u5Zau6N9V0Fb5nrJ8Waw0UD8e0MoMspkfe
         +u8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8PvKk5ghJ6tKIOitssSRP03giEIWEvCEKM+eRMgUlX8=;
        b=1aclDca9xZ0Vbr2+EkPf+xLZhm82seX55cMW1b7+AgIUY+svMnlPD7ubFMT/l0yHyJ
         ra7esElRmyf4rbPafQuzM8NvCVBWkrUhXdWMAt1X6AjOfh5FYNyYZK2IO/Si7S/UZalK
         PIJljrR8MFjA7QiuZGeNvRLHQz8aD+zGWhvu67/++hNIouyg+Efvrj2GK3I5j4FA645q
         GAWz5Cy77TDmunewtLjdy3IvfKr3g8j5Hpb/l48AXPoUOnwDSB8RGbUh/0u10L8BvKW7
         cNBij/XuxaMImLegH+PsCL+E0xLnTm1m7rEv8W+xJapXvrGeF00h/mkU/4Cl5m6nievd
         bHHA==
X-Gm-Message-State: AOAM531/WhJJNv2i9EA/6FCsmZb2NH60bY9TGN5KAFgTf2agoN7mCf73
        MBJbAjHnE/PmenTV22eep9KwulsWkzJ4flhGitA=
X-Google-Smtp-Source: ABdhPJyr4VCggaLuwuvvAou/8PV1XluyjSR5fDjnIB4iHnWinL0a3dyGHlZqUqU3rBrzycnPj3eI0VQYefckBVv9HFw=
X-Received: by 2002:aa7:8617:0:b0:4fb:4fc:1ea8 with SMTP id
 p23-20020aa78617000000b004fb04fc1ea8mr50909141pfn.84.1649047300738; Sun, 03
 Apr 2022 21:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
In-Reply-To: <Ykm1jBpdD0+NjsTW@google.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 4 Apr 2022 07:41:24 +0300
Message-ID: <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
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

On Sun, Apr 3, 2022 at 5:56 PM Joel Fernandes <joel@joelfernandes.org> wrot=
e:
>
> On Fri, Apr 01, 2022 at 07:06:29PM -0400, Steven Rostedt wrote:
> > On Fri, 1 Apr 2022 15:50:10 -0400
> > Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > > export TRACECMD_TEMPDIR=3D"/data"
> > >
> > > That=E2=80=99s fair. What about using memfd for this, do you feel tha=
t=E2=80=99s
> > > reasonable? I have not yet measured how big this file gets but if it=
=E2=80=99s
> > > small enough that might work too.
> >
> > Is this a separate question? That is, do you mean using the above
> > environment variable *and* then use memfd?
> >
> > I believe that the cache is used for passing the compressed data from t=
he
> > guest to the host. I don't think it will be more than one compressed ch=
unk.
> >
> > But Tzvetomir would know better.
>
> Hey Steve,
> No its the same question. Instead of temp file, I was proposing in-memory
> file using memfd_create(2), that way no hassle as long as the file is not=
 too
> huge.
>

Hi  Joel,
That cache file is used for constructing the trace meta-data on the
guest, before sending it to the host. Usually it is compressed, but it
could be uncompressed in some cases (depending on the configuration) -
and in that case it can grow up to a few megabytes. Using memfd is ok
in most cases, but I'm wondering in the worst case - these few
megabytes could be a problem, especially if the guest runs with a
minimum amount of memory.

> Also looks like my patch is incomplete anyway, I need to change
> tracecmd_msg_handle_cache() as well.
>
> I'll try to write up a patch with memfd unless you guys disagree.
>
> Thanks,
>
> - Joel
>


--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
