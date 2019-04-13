Return-Path: <SRS0=1j5l=SP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C46C10F14
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 02:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E54120850
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 02:59:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="RbVyPOZ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfDMC7i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 22:59:38 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:19673 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfDMC7i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 22:59:38 -0400
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x3D2xTiD004358;
        Sat, 13 Apr 2019 11:59:30 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x3D2xTiD004358
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1555124370;
        bh=Hozff6lorZMSkyN8e9FHdSjsJbtT6iJ1nOxxE5xlWNU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RbVyPOZ8HgzIDopUd9sYLQVKSzBBeVVoT0LsqetgB9Y1d/WolHno/wXtHwSqPt2ac
         6umRXqwgmEVnyAUI02FPKr2pGC+t0IB7idDtcmYaVh7qIubN7byOS7evyHjMkYCyuj
         6L758I/4KI6IUchnrO7iVNQ8L/Tqbpt5NBeUNJDq9NceeYKbi2j07JHR+wCddd1GSC
         r1/CAAKJa3mi+YRBwNDFxOhfjFoLbuC1aPkHz+ILxFZsyLqJNvINxgoBc7OkadtjIi
         vhOfM9ODCw1iccDJg9j5jlynAsPkDgNVRDSDE1/RegpDMTDkw+6SvIavLh+MbWoyw5
         Nnd7WLSMBgNRw==
X-Nifty-SrcIP: [209.85.217.42]
Received: by mail-vs1-f42.google.com with SMTP id s2so6661038vsi.5;
        Fri, 12 Apr 2019 19:59:30 -0700 (PDT)
X-Gm-Message-State: APjAAAUeepsFqhfw6LBw/q+KMQojvbFv8BrIJyF9QOuhIOd+G132NucG
        Sq5msyjWXsi2Wq62mgwxLEImJi5ACohN5RoXX/o=
X-Google-Smtp-Source: APXvYqzhkVvx2hxm3NiAGHos34eYrsaF/sG7QfCezyI1KyNkTR0cwwluGFx16PyjEKKG4oqn/D4ek50dZIz32A8jVyo=
X-Received: by 2002:a67:fbcc:: with SMTP id o12mr35478417vsr.60.1555124369020;
 Fri, 12 Apr 2019 19:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190408212855.233198-1-joel@joelfernandes.org>
 <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com>
 <20190412180014.GA175945@google.com> <CAK7LNAT83SijpivFJA8GS=bOsgfnV03fo+-QJFgO1SgmLBOiQw@mail.gmail.com>
 <CAKOZueuf8qM1O7c+m7zRHv1b6-YsZmWoTBfErBLY+yV1pyESmQ@mail.gmail.com>
In-Reply-To: <CAKOZueuf8qM1O7c+m7zRHv1b6-YsZmWoTBfErBLY+yV1pyESmQ@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 13 Apr 2019 11:58:53 +0900
X-Gmail-Original-Message-ID: <CAK7LNATW0EQ+uYqGgEbzp1pzajs2CBOWT937JOCNnepP3AAD1g@mail.gmail.com>
Message-ID: <CAK7LNATW0EQ+uYqGgEbzp1pzajs2CBOWT937JOCNnepP3AAD1g@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Provide in-kernel headers to make extending kernel easier
To:     Daniel Colascione <dancol@google.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Apr 13, 2019 at 10:53 AM Daniel Colascione <dancol@google.com> wrote:
>
> On Fri, Apr 12, 2019 at 6:49 PM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Sat, Apr 13, 2019 at 3:02 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > >
> > > > > +extern char kernel_headers_data;
> > > > > +extern char kernel_headers_data_end;
> > > > > +
> > > > > +static ssize_t
> > > > > +ikheaders_read_current(struct file *file, char __user *buf,
> > > >
> > > > Could you stretch this line ?
> > > > It will still fit in 80-cols.
> > > >
> > > > (This is a coding style error in kernel/configs.c)
> > >
> > > It takes 87 cols if I expand, so I'll leave it as is.
> > >
> >
> >
> > Sorry if what I said was unclear.
> >
> > Since I just did not a good reason to put
> > "static ssize_t" in the previous line,
> > I meant like follows:
> >
> >
> > [Before]
> > static ssize_t
> > ikheaders_read_current(struct file *file, char __user *buf,
> >                        size_t len, loff_t *offset)
> >
> >
> >
> > [After]
> > static ssize_t ikheaders_read_current(struct file *file, char __user *buf,
> >                                       size_t len, loff_t *offset)
> >
> >
> > (takes 74-cols.)
> >
> >
> > (I am sending this from Gmail, so I am not sure
> > how it will look like from you...)
> >
> >
> > Anyway, it is super-bikeshedding stuff.
> > It is OK as-is.
> >
>
> What about sorting the files for determinism?


Do you mean the order of files in the tar archive?
I think it is a good idea for reproducible build.



It looks like the tar command supports --sort=name option,
but I did not test it at all.



Perhaps, the sorting policy could be affected by locale.
We saw it for the 'find' command.
I am not sure about the tar command though.



commit f55f2328bb28a8517620518c5d124f5194673309
Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Date:   Fri Aug 17 14:03:19 2018 +0200

    kbuild: make sorting initramfs contents independent of locale








--
Best Regards
Masahiro Yamada
