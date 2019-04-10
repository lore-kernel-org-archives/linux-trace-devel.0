Return-Path: <SRS0=mbrG=SM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4BFC10F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 15:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 215B32133D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 15:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kJtgUynG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbfDJPvE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 11:51:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46088 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfDJPvE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 11:51:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id z17so3368399qts.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Apr 2019 08:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I8SE0hQdgATafth9AsqVC7r1ns9guNMUwC2veAj2keA=;
        b=kJtgUynGAHE1JRUInC+YKxM3RWQ9GSYDP6Y3rVu6lzNNJpj74oZMigmJktVSwyHNjB
         nMn14W6udtj6pvGHZ52Ry+xWMSpuNWtB0/oxozJfRiX4m6fAkwZgIEhQuWZLtQfJPCgG
         4PE/JZr9FenVRSb3+B7dUX3YhsLlKUiP5fFAVrVYdhjq9LR38MN3InHEeXbxF2orffUn
         53zoCs2ELvlKxspkOwWV8etCU1BuIdVoo7790dV6Ey74nNFvgk5stpKRsm4aEDZ/bprF
         TQFam94sMoiN78g739ntjrH0zuBQqDtpoXJXV8IN3vVT19fwP7tORCAQ9fsqWwejJEOr
         gDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I8SE0hQdgATafth9AsqVC7r1ns9guNMUwC2veAj2keA=;
        b=CkbLnpLotHUrp2y/qKF2Eajqgq2drgZEmmUw/t4yI0o8vYRB+YXGc0g4Ml5NW0rl49
         r2D6ELACbHvQYK6BdgaSWleTOtRHpd8Gg+KoI7e5np1ig1o2fH1WGuItOuvPLkisfFFA
         /xvE4OPmZg1SXhpm/2+fzQPF+Zp3BjUqceF/T8UoUjfspdHIgeju23d8hAN+JGCbPQNa
         Mx2/dxiYvSQSVUJjGivwFo2Ghp/4MFFNRPUZrAjfJCsKcEg/k9FRxDiBIpJFYaOLvVXm
         DfZLXpnqxvdu18C8+hnY4fxhKmAH+mL+Jv0UucDGgl+yQIQnaMnzHwrmccLHI/+GqW+t
         lDVA==
X-Gm-Message-State: APjAAAV+F/qJUhwL6uzpTBJApSwuDbxD5f5lDRBblPzCLmWscq81jx3E
        pcc53hsqqtiY3mQwb728G2zXQ2s0haHMn1Kplr7P0w==
X-Google-Smtp-Source: APXvYqxrxnzD5OxUw/1vC9do17GmEXhvmxvbyYwJA01fgTqEyu4e+DlxDg1gE6Zi9BfO2FTohQPvkNGazJsv6DV/wO8=
X-Received: by 2002:a0c:b018:: with SMTP id k24mr35721367qvc.218.1554911462775;
 Wed, 10 Apr 2019 08:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com> <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
In-Reply-To: <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Wed, 10 Apr 2019 11:50:51 -0400
Message-ID: <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Olof Johansson <olof@lixom.net>
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

On Wed, Apr 10, 2019 at 11:07 AM Olof Johansson <olof@lixom.net> wrote:
[snip]
> > > Wouldn't it be more convenient to provide it in a standardized format
> > > such that you won't have to take an additional step, and always have
> > > This is that form IMO.
> >
> > The location of the archive is fixed/known. If you are talking of the
> > location where the user decompresses it to, then they a;ready know where they
> > are decompressing to.
>
> The location _of_ the archive, sure. But the format of what is in the
> tarball, how it is versioned, and how to manage it will have to be
> done by every user.
>
> For any script that doesn't depend on some shared system state that
> wants to, say, build a eBPF program and load it, it would need to
> extract the tarball from scratch to make sure it is the current
> correct version of it.
>
> If that's required by all users, why not just present the data in a
> way that it can be used directly?

That is the part that is unclear from your proposal. If we present a
filesystem view, then I am assuming the data will have to be
decompressed first into memory. That means you are proposing use of
30MB uncompressed memory. The whole archive has to be decompressed but
the whole archive if compressed with XZ for a maximum compression
ratio.

> > > Having to copy and extract the tarball is the most awkward step, IMHO.
> > > I also find the waste of kernel memory for it to be an issue, but
> > > given that it can be built as a module I guess that's the obvious
> > > solution for those who care about memory consumption.
> >
> > Yes. We discussed in previous threads that for users who really want the
> > archive to be completely uncompressed and in-memory, can just load the
> > module, decompress into tmpfs, and unload the module. That is an extra step,
> > yes.
>
> Most users will need to decompress it every time they use it anyway,
> especially if there's no versioned prefix in the tarball that they can
> use to key to a previously decompressed version with the exact same
> kernel version and config.
>
> So, if you need to do that anyway, wouldn't it be easier if you just
> mounted a FS to get to it. If you're on a system where you can't use
> it in-place for resource reasons, you can copy it off and unmount it.
> No extra tools needed in userspace then at run/use time.
>
> Said filesystem could be populated by a compressed cpio archive since
> we already have code in the kernel to do this for initramfs, and could
> do so at mount time -- and at unmount time it'd be freed up.

But still, decompressing to the filesystem in a scratch area may be
better than decompressing to RAM, for some users who have lesser RAM.
This patchset does not enforce a certain way of doing things and
leaves it to the user.

> If you absolutely need to export a file to userspace with the archive,
> my suggestion is to do it through debugfs. That way the format isn't
> in a /proc ABI that can't be changed in the future (debugfs isn't
> required to be stable in the same way). This way we can change the
> format carried in the kernel over time without changing the official
> way we present the data to userspace (via a filesystem view).
>
> As far as format goes; there's clear precedent on cpio being used and
> supported; we already have build time requirements on the userspace
> tools with some options. Using tar would actually be a new dependency
> even if it is a common tool to have installed. With a self-populating
> FS, there's no new tool requirements on the runtime side either.

debugfs is going away for Android and is controversial in the fact
that its functionality isn't guaranteed to be there (debugfs breakages
aren't necessarily bugs AFAIK). So this isn't an option.

> > We had close to 2-3 months of discussions now with various folks up until v5.
> > I am about to post v6 which is in line with Masahiro Yamada's expecations. In
> > that I will be dropping module building artifacts due to his module building
> > concerns and only include the headers.
>
> I've found some of the old discussion and read up on it. I think it
> was pretty quick at dismissing ideas for more robust implementations
> ("it needs squashfs-tools"), and had some narrow viewpoints (exporting
> a tarball is the least amount of kernel change, while adding
> complexity at the system/usage side).

Honestly, that's kind of unfair to be quoting just a few points like
that. If I remember there were 100s of emails and many good view
points were brought up by many people. We have done the diligence in
the discussions of this over a period of time.

> I'd also like to clarify: I'm not opposed to the general idea of
> providing the needed headers with the kernel somehow. I just think
> it's worth spending effort making sure an interface for it that we'll
> need to live with forever is appropriately thought through and not
> rushed in, especially since we're likely to get substantial
> infrastructure on top of it quickly (eBPF and friends in particular).

We have spent the time :) This seems like the best solution of all.
Greg KH and other maintainers are also supportive of it as can be seen
in other threads. We can consider an alternate proposal if it is
better, but I don't see any better one proposed at the moment.

- squashfs-tools requirement on the build really sucks
- cpio uncompressed to memory equally sucks because it consumes all
the memory uncompressed instead of reclaimable pages
- decompressing into tmpfs will suck for Android because we don't use
disk-based swap and we run into the same cpio issue above. We use ZRAM
for compressed swap.
- debugfs is a non-option for Android

The tar+xz is trivially created without depending on squashfs-tools.
And xz provides the maximum compression ratio in our experiments.
Decompression time is a non-issue since trace tools are using it.

The filesystem view sounds using mount/unmount like a pony to me, but
it does not meet the requirements above. Let me know if I am missing
something.

thanks,
 - Joel
