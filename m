Return-Path: <SRS0=1j5l=SP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57923C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 03:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 249BC20896
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 03:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="L7kNXcSQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfDMDKS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 23:10:18 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:23682 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfDMDKS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 23:10:18 -0400
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x3D3A6XG031464;
        Sat, 13 Apr 2019 12:10:06 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x3D3A6XG031464
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1555125007;
        bh=CLQ9mjeWaq68e20HbY29AnsgCf3DOiy8XcyUG1NuJVg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L7kNXcSQyKvcpYKCfzpZfPmaB1XaNjXRYsK2Sd/jogdhHcUXhh+HUDZaj33Fo82KW
         qtb17RUtSdLFEtuIw90g7FnS70xAkfb9JO84e1B/jwqJq3orXsmetj6F/TVDkMsnA4
         SKxtYJpAb5tO0C7aVxorpVXB6nriaP99Sjxta35E9aC/lExupgoKqHZnawCUOEzO0S
         rD2bXMBWAKllGo++6gNqA+AA37CWMu0F0A+g4YBowglnD+XB4nG3bpetsHmyM8nDVe
         CPherjz/7+CM/NkBw/QzHVB0AURnmNKdYwaaEuEIFtMTvBsOKq6tHnP7RaIayr2xs6
         Of5zdqFaJv3yg==
X-Nifty-SrcIP: [209.85.217.49]
Received: by mail-vs1-f49.google.com with SMTP id o10so6645626vsp.12;
        Fri, 12 Apr 2019 20:10:06 -0700 (PDT)
X-Gm-Message-State: APjAAAVwfvSXfHu0VybbEy1KjqbtEsTaaa8M6YVfJxM/OM3B/Cn7VNdQ
        +at5BnSPvXv4v1ydw8lHlB3nFXa8wUZmnKEy4M4=
X-Google-Smtp-Source: APXvYqyOljTK5aMrqJruQp+hZwfz73bg6a/j/lENicvO8aEOfvozZk5QqhCzKCs907HgTxMDwtDCXR7nGxlh7lVp43g=
X-Received: by 2002:a67:f714:: with SMTP id m20mr34822158vso.211.1555125005533;
 Fri, 12 Apr 2019 20:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190408212855.233198-1-joel@joelfernandes.org>
 <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com>
 <20190412180014.GA175945@google.com> <CAK7LNAT83SijpivFJA8GS=bOsgfnV03fo+-QJFgO1SgmLBOiQw@mail.gmail.com>
 <CAKOZueuf8qM1O7c+m7zRHv1b6-YsZmWoTBfErBLY+yV1pyESmQ@mail.gmail.com> <CAK7LNATW0EQ+uYqGgEbzp1pzajs2CBOWT937JOCNnepP3AAD1g@mail.gmail.com>
In-Reply-To: <CAK7LNATW0EQ+uYqGgEbzp1pzajs2CBOWT937JOCNnepP3AAD1g@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 13 Apr 2019 12:09:29 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS8LroP_N76ZS2OLZKaxSMA3UubdE1r7QzkqCt-TFmnWA@mail.gmail.com>
Message-ID: <CAK7LNAS8LroP_N76ZS2OLZKaxSMA3UubdE1r7QzkqCt-TFmnWA@mail.gmail.com>
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

On Sat, Apr 13, 2019 at 11:58 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Sat, Apr 13, 2019 at 10:53 AM Daniel Colascione <dancol@google.com> wrote:
> >
> > On Fri, Apr 12, 2019 at 6:49 PM Masahiro Yamada
> > <yamada.masahiro@socionext.com> wrote:
> > >
> > > On Sat, Apr 13, 2019 at 3:02 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> > > >
> > > > > > +extern char kernel_headers_data;
> > > > > > +extern char kernel_headers_data_end;
> > > > > > +
> > > > > > +static ssize_t
> > > > > > +ikheaders_read_current(struct file *file, char __user *buf,
> > > > >
> > > > > Could you stretch this line ?
> > > > > It will still fit in 80-cols.
> > > > >
> > > > > (This is a coding style error in kernel/configs.c)
> > > >
> > > > It takes 87 cols if I expand, so I'll leave it as is.
> > > >
> > >
> > >
> > > Sorry if what I said was unclear.
> > >
> > > Since I just did not a good reason to put
> > > "static ssize_t" in the previous line,
> > > I meant like follows:
> > >
> > >
> > > [Before]
> > > static ssize_t
> > > ikheaders_read_current(struct file *file, char __user *buf,
> > >                        size_t len, loff_t *offset)
> > >
> > >
> > >
> > > [After]
> > > static ssize_t ikheaders_read_current(struct file *file, char __user *buf,
> > >                                       size_t len, loff_t *offset)
> > >
> > >
> > > (takes 74-cols.)
> > >
> > >
> > > (I am sending this from Gmail, so I am not sure
> > > how it will look like from you...)
> > >
> > >
> > > Anyway, it is super-bikeshedding stuff.
> > > It is OK as-is.
> > >
> >
> > What about sorting the files for determinism?
>
>
> Do you mean the order of files in the tar archive?
> I think it is a good idea for reproducible build.
>
>
>
> It looks like the tar command supports --sort=name option,
> but I did not test it at all.
>
>
>
> Perhaps, the sorting policy could be affected by locale.
> We saw it for the 'find' command.


'sort' command is affected by locale.



> I am not sure about the tar command though.
>
>
>
> commit f55f2328bb28a8517620518c5d124f5194673309
> Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Date:   Fri Aug 17 14:03:19 2018 +0200
>
>     kbuild: make sorting initramfs contents independent of locale
>
>
>
>
>
>
>
>
> --
> Best Regards
> Masahiro Yamada



-- 
Best Regards
Masahiro Yamada
