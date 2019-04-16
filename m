Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71684C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 16:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C1362087C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 16:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="fG2iQSaa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfDPQr3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:47:29 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:34323 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbfDPQr2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 12:47:28 -0400
Received: by mail-it1-f194.google.com with SMTP id z17so3148662itc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Apr 2019 09:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UNeYJRA6DqdqQQDusaGwYqXolUas5X2/Vxw7bBLr77M=;
        b=fG2iQSaaswqIND/hiD0tQYjK/CoCissJABBrVNVJ4Lhz6IrQ1bnJ2I4a3fMEv0oX0d
         lh1qzJeS9En6IRf/uggR/nP0q8aykjDDyc4Q8QMub7Qar0bwa8BdmY2z2lAmZn1oUM9r
         +mrJb/fmluySDm5QrL7LKjyuID+zn7mQ9mCSK9KjmY1OLmypba0kufZSkRnsyZCL1Mrc
         8MX9JjHZ+bY3leIxKQy4o94JjtyzZysFbL9KS8TjnXyAeHWyewW6++4s8hL1j5mTsGVZ
         HLoQlmaSmPHOehwuw4x5MsSABF1D4OPr3ViA/1jrBxe5Z4GykW+qmLLao0Uvr69dGEem
         gpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UNeYJRA6DqdqQQDusaGwYqXolUas5X2/Vxw7bBLr77M=;
        b=mJ+wdKclbBe+iO1hMJpwybBMt5XnhQ8ReyqcSCXmr446nrat+EI/PhSeG/SmuK9eOT
         XSQUDpvhZYT0Z2kDCgYuaOdLI3fW1B4kbB4APwofna5c8GF/GJrJvKRTq+IYxWu2p1iw
         MQ8smFGlw5J9Kam3ImXE4On7hNWH4gV3sb2pkxGB+8WNohXUYlfLPmtsyRLlYhTKBiuf
         JiqkXenSNxcU9o52pVTINCBOb1Fc+TGPov6ubEiVhRB1ir6kskgc+BFmHkBMWiUGUups
         RGkKUTxI/VCwTeACVsv8ShuXozs/VwG4d/6jNRbrHahARkW07bSa0e3bIGTnGomJ9pRT
         px9g==
X-Gm-Message-State: APjAAAXi5fcbbZg1GbnThLm834gLtpAfOcBfxSk4cX5TvyjUzgEoz7QU
        5/vcgGiqxJ9BOQeTCjBNA/kKnHhq+jCVckW23DyAkQ==
X-Google-Smtp-Source: APXvYqwFUZ5eDHZPk/N8L9f/9OI8M6K3Y4t0h7t0AXKVOwqiHPmHZC1Jx6bk24cZRzHgKiz63xdvn1Z/m7ueVAyW4u8=
X-Received: by 2002:a24:7c9:: with SMTP id f192mr31475988itf.97.1555433247471;
 Tue, 16 Apr 2019 09:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190408203601.GF133872@google.com> <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
 <20190415104109.64d914f3@gandalf.local.home> <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
 <20190416083306.5646a687@gandalf.local.home> <20190416124939.GB6027@kroah.com>
 <20190416130440.GA7944@localhost> <f8b15e31-1aab-ab2c-d44d-47325faab67d@opersys.com>
In-Reply-To: <f8b15e31-1aab-ab2c-d44d-47325faab67d@opersys.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Tue, 16 Apr 2019 09:47:16 -0700
Message-ID: <CAOesGMj=BKcfa4A321y43m0qTaeQeM1M8btQmGCVM1idc9_5GA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Karim Yaghmour <karim.yaghmour@opersys.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 6:32 AM Karim Yaghmour
<karim.yaghmour@opersys.com> wrote:
>
>
> On 4/16/19 9:04 AM, Joel Fernandes wrote:
> > On Tue, Apr 16, 2019 at 02:49:39PM +0200, Greg Kroah-Hartman wrote:
> >> On Tue, Apr 16, 2019 at 08:33:06AM -0400, Steven Rostedt wrote:
> >>> On Mon, 15 Apr 2019 22:50:10 -0500
> >>> Kees Cook <keescook@chromium.org> wrote:
> >>>
> >>>> On Mon, Apr 15, 2019 at 9:41 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >>>>> I agree with this assessment. We shouldn't use config.gz as precedence
> >>>>> for this solution. config.gz should have been in debugfs to begin with,
> >>>>> but I don't believe debugfs was around when config.gz was introduced.
> >>>>> (Don't have time to look into the history of the two).
> >>>>
> >>>> I don't agree with this: /proc/config.gz is used by a lot of tools
> >>>> that do sanity-check of running systems. This isn't _debugging_...
> >>>> it's verifying correct kernel builds. It's a fancy version of checking
> >>>> /proc/version.
> >>>>
> >>>
> >>> Then we should perhaps make a new file system call tarballs ;-)
> >>>
> >>>   /sys/kernel/tarballs/
> >>>
> >>> and place everything there. That way it removes it from /proc (which is
> >>> the worse place for that) and also makes it something other than debug.
> >>> That's what I did for tracefs.
> >>
> >> As horrible as that suggestion is, it does kind of make sense :)
> >>
> >> We can't put this in debugfs as that's only for debugging and systems
> >> should never have that mounted for normal operations (users want to
> >> build ebpf programs), and /proc really should be for processes but that
> >> horse is long left the barn.
> >>
> >> But, I'm willing to consider putting this either in a system-fs-like
> >> filesystem, or just in sysfs itself, we do have /sys/kernel/ to play
> >> around in if the main objection is that we should not be cluttering up
> >> /proc with stuff like this.
> >>
> >
> > I am ok with the suggestion of /sys/kernel for the archive. That also seems
> > to fit well with the idea that the headers are kernel related and probably
> > belong here more strictly speaking, than /proc.
>
> This makes sense. And if it alleviates concerns regarding extending
> /proc ABIs then might as well switch to this.
>
> Olof, what do you think of this?

In practice we've been more lenient with changes to /sys over time, so
I think this might be a reasonable compromise.

I still think that a filesystem view is the cleanest way to do this,
but I won't push back from this going in. It does solve a real
problem, and if we want a different format later we can revisit it
then.


-Olof
