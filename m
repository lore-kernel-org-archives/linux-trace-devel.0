Return-Path: <SRS0=mbrG=SM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4629C10F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 16:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DCB3206DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 16:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="xdCYnUc2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfDJQfB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 12:35:01 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:54715 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfDJQfB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 12:35:01 -0400
Received: by mail-it1-f195.google.com with SMTP id a190so4489557ite.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Apr 2019 09:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8o2QjDqA2N9chLiZ8Y1fX+salfYIl3vwFvYlfLs0dVE=;
        b=xdCYnUc2zePyVpPO0iUqj4mmHMPpXmFZHP1ofWdaBvBU4wSzDNVaLNdvCcqtZrsWGW
         SWShMDp+HZuXIcnZHcCAvdP8bRkc+CsG2aVl1Q5KL8Xee20PSHlPDCeBMWcTnz5XJumu
         GaVBtP7MYCHMByWk5bY0Ht75i+QsxkGQENE7PsqkLiXt6Lsz0tl6O9LAEhw73ia3HbrZ
         DtPfx2Eh9yk2H+LBAnHO2hMAJn9AiTI4L+A+rP/E8NJItjRGCiAkqdoMTcO3DMCg2d5M
         MMaevzMSUF6LIc7Rv1Et8un/jEsWxOEInWY7gBLk+SFdQtMs3qMjUAIacl807d+d972v
         FLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8o2QjDqA2N9chLiZ8Y1fX+salfYIl3vwFvYlfLs0dVE=;
        b=P5yx0i+UxZPOFmiogtIMSKO9SbB1crZxxEBJRYbPLgQruy3zpYLCCZzFJJO7N5EDai
         +nNn2ZuSOxHwbNAgfVxZZny3eLX9jpA2d7WSzjk/rrSP/0qVwvwLfWhJrzICMfSneTiS
         AE5LBzh1vW5Gs9ZJwV0ipFpWHZc2FJI3Tb2cKdwrVJgyMxJUM0PdYj0Wml2+a+EhFNUW
         Mlbw17sYmI5TCo/0AtL5+TeQDPCodPjto4zky0tqPJxA2pB7zhn6iG56D1lXTFSk0Pzf
         Vf0BqasHQNa5mxyhXO/8oaNx9c11gNjiThg54FF9tqlfG59GxceG62UYztqtAb61MqI/
         VF2w==
X-Gm-Message-State: APjAAAWYdcmA1x4bbb11HFwJgHyiYXFvdsEr2zUAXaAqujOh0CXe6VX7
        T7YMy+Za/2IZW2a7G2yppt2Ihl6QTafodtyev0B0NNGtVf4=
X-Google-Smtp-Source: APXvYqwAKim+46C3OTYMYWY8bVMSAM5aw2sQDOITOC2qn+p2niv8EzicVkKbhVZTuGVNeyCt3i5S7242gVoQpy3JzKM=
X-Received: by 2002:a24:7c9:: with SMTP id f192mr4232680itf.97.1554914100370;
 Wed, 10 Apr 2019 09:35:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com> <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
In-Reply-To: <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Wed, 10 Apr 2019 09:34:49 -0700
Message-ID: <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Joel Fernandes <joelaf@google.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 10, 2019 at 8:51 AM Joel Fernandes <joelaf@google.com> wrote:
>
> On Wed, Apr 10, 2019 at 11:07 AM Olof Johansson <olof@lixom.net> wrote:
> [snip]
> > > > Wouldn't it be more convenient to provide it in a standardized format
> > > > such that you won't have to take an additional step, and always have
> > > > This is that form IMO.
> > >
> > > The location of the archive is fixed/known. If you are talking of the
> > > location where the user decompresses it to, then they a;ready know where they
> > > are decompressing to.
> >
> > The location _of_ the archive, sure. But the format of what is in the
> > tarball, how it is versioned, and how to manage it will have to be
> > done by every user.
> >
> > For any script that doesn't depend on some shared system state that
> > wants to, say, build a eBPF program and load it, it would need to
> > extract the tarball from scratch to make sure it is the current
> > correct version of it.
> >
> > If that's required by all users, why not just present the data in a
> > way that it can be used directly?
>
> That is the part that is unclear from your proposal. If we present a
> filesystem view, then I am assuming the data will have to be
> decompressed first into memory. That means you are proposing use of
> 30MB uncompressed memory. The whole archive has to be decompressed but
> the whole archive if compressed with XZ for a maximum compression
> ratio.

Only while the filesystem is mounted. So you would do something like:

 - Mount filesystem
 - Build and load
 - Unmount

The 30MB would only be used while the filesystem is mounted.

Compared to:
 - Extract tarball
 - Build and load
 - Remove file tree from filesystem

> > > > Having to copy and extract the tarball is the most awkward step, IMHO.
> > > > I also find the waste of kernel memory for it to be an issue, but
> > > > given that it can be built as a module I guess that's the obvious
> > > > solution for those who care about memory consumption.
> > >
> > > Yes. We discussed in previous threads that for users who really want the
> > > archive to be completely uncompressed and in-memory, can just load the
> > > module, decompress into tmpfs, and unload the module. That is an extra step,
> > > yes.
> >
> > Most users will need to decompress it every time they use it anyway,
> > especially if there's no versioned prefix in the tarball that they can
> > use to key to a previously decompressed version with the exact same
> > kernel version and config.
> >
> > So, if you need to do that anyway, wouldn't it be easier if you just
> > mounted a FS to get to it. If you're on a system where you can't use
> > it in-place for resource reasons, you can copy it off and unmount it.
> > No extra tools needed in userspace then at run/use time.
> >
> > Said filesystem could be populated by a compressed cpio archive since
> > we already have code in the kernel to do this for initramfs, and could
> > do so at mount time -- and at unmount time it'd be freed up.
>
> But still, decompressing to the filesystem in a scratch area may be
> better than decompressing to RAM, for some users who have lesser RAM.
> This patchset does not enforce a certain way of doing things and
> leaves it to the user.

There are lots of things where we provide suitable ways of doing
things to the user instead of making them come up with their own
handling of things. devtmpfs is a perfect example of this -- doing
things in userspace was perfectly possible but still a hassle in many
cases, and having the kernel do it for you when it already has the
data makes sense.

I'd expect many users to still want to do this to tmpfs. Also, I
expect whatever userspace tools and programs that will consume this
data is likely to consume similar or more memory while running anyway.
So mounting + copying + unmounting on the heavily constrained systems
shouldn't be raising the high water mark on memory consumption.

> > If you absolutely need to export a file to userspace with the archive,
> > my suggestion is to do it through debugfs. That way the format isn't
> > in a /proc ABI that can't be changed in the future (debugfs isn't
> > required to be stable in the same way). This way we can change the
> > format carried in the kernel over time without changing the official
> > way we present the data to userspace (via a filesystem view).
> >
> > As far as format goes; there's clear precedent on cpio being used and
> > supported; we already have build time requirements on the userspace
> > tools with some options. Using tar would actually be a new dependency
> > even if it is a common tool to have installed. With a self-populating
> > FS, there's no new tool requirements on the runtime side either.
>
> debugfs is going away for Android and is controversial in the fact
> that its functionality isn't guaranteed to be there (debugfs breakages
> aren't necessarily bugs AFAIK). So this isn't an option.

The argument that this needs to go into /proc because Android is
removing debugfs isn't a very strong one.

And "debugfs breakages aren't bugs" is exactly why I'm suggesting to
do the non-supported export of the archive that way instead.

> > > We had close to 2-3 months of discussions now with various folks up until v5.
> > > I am about to post v6 which is in line with Masahiro Yamada's expecations. In
> > > that I will be dropping module building artifacts due to his module building
> > > concerns and only include the headers.
> >
> > I've found some of the old discussion and read up on it. I think it
> > was pretty quick at dismissing ideas for more robust implementations
> > ("it needs squashfs-tools"), and had some narrow viewpoints (exporting
> > a tarball is the least amount of kernel change, while adding
> > complexity at the system/usage side).
>
> Honestly, that's kind of unfair to be quoting just a few points like
> that. If I remember there were 100s of emails and many good view
> points were brought up by many people. We have done the diligence in
> the discussions of this over a period of time.

That wasn't captured with the patch submission, and having people go
find 100s of emails to figure out why your seemingly lacking solution
is the best one available is not how you motivate getting your code
into the kernel.

> > I'd also like to clarify: I'm not opposed to the general idea of
> > providing the needed headers with the kernel somehow. I just think
> > it's worth spending effort making sure an interface for it that we'll
> > need to live with forever is appropriately thought through and not
> > rushed in, especially since we're likely to get substantial
> > infrastructure on top of it quickly (eBPF and friends in particular).
>
> We have spent the time :) This seems like the best solution of all.

That should be documented.

> Greg KH and other maintainers are also supportive of it as can be seen
> in other threads.

I've found support for the desire to provide headers. If there's so
much support for this solution, the number of Acks to the patch should
have been higher.

> We can consider an alternate proposal if it is
> better, but I don't see any better one proposed at the moment.

Really?

> - squashfs-tools requirement on the build really sucks

Nah, this is a minor detail.

> - cpio uncompressed to memory equally sucks because it consumes all
> the memory uncompressed instead of reclaimable pages

Only while mounted.

> - decompressing into tmpfs will suck for Android because we don't use
> disk-based swap and we run into the same cpio issue above. We use ZRAM
> for compressed swap.

See comments above about high water marks for memory consumption
likely not moving much.

> - debugfs is a non-option for Android

Not my problem.

> The tar+xz is trivially created without depending on squashfs-tools.

It adds a new dependency on tar.

> And xz provides the maximum compression ratio in our experiments.

Sure.

> Decompression time is a non-issue since trace tools are using it.

Sure.

> The filesystem view sounds using mount/unmount like a pony to me, but
> it does not meet the requirements above. Let me know if I am missing
> something.

What requirements?


-Olof
