Return-Path: <SRS0=mbrG=SM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822CAC10F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 17:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4196A20830
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 17:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MO4+mwhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbfDJRdz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 13:33:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35891 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbfDJRdz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 13:33:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so3873757qtn.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Apr 2019 10:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D8XYF/WmDU+gwn+Q7P19eXWc3tn+iqWuDkeaUKYl4Ug=;
        b=MO4+mwhGePW12bEHcUwJm1lNb90n8ytOEegD8khT0E6+mLEWxs8K/vLFF3p0IPD763
         6u/Vk8bbcaMw7l69d4D2ktAcf6RKQqgo5tNkv0U1a6jDpc5+S75blGOLYFVNYO6gxtle
         XUwdvyIPg2wD3oca2NFJc91dyAuAyXa59ANTmGcYElxvlTQ8JmH9GwP9XJIu+3Yb7Wjw
         Nccq4tAPmX3VnSWIE6OdxFn7lybqoDwT9PprYnVmhH4W7cyJBIGhffbg3WgY4C6qVweQ
         nuQAgEC42kCFygEPCwajNQCxo9AY7pvqgmZ8QPeajTxRW1BA4eENEjfIjqlSyjGyx0xV
         ZPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D8XYF/WmDU+gwn+Q7P19eXWc3tn+iqWuDkeaUKYl4Ug=;
        b=DYqW1NU+D4UYlbvPUuHrABHRK7SoGROypiMIz4SEmKydRNp2aVqfz8e2Zqzca8+wfE
         P1WYflxEHMKvqQsNz4n0NO/HR7eAqwrBiHg6sJ8ux8s7O6noGD+BI1ZbjKii9sb1VVXa
         HCzL+fFbdpDbXXHNKagqlhkmP7MH6zreH6tYKoeIQnl4voX/0Kp0l3U7JyBFjs3Mj28o
         9qGDvV7ug09beboQbJFe/rZV7vohA/SUNqHUXnnr3J+a1gbVLKvypE+YlZ3/wLFy5KV4
         ycHAc4yQpyiS83rjhkenZDh2vML/lMJDL6BKGpqRg9usnmoeNVwVsSkP8Wf64dHit11W
         +fGw==
X-Gm-Message-State: APjAAAXL17cSF4hfbcCwdLyfPZydCoPQYJB4S4oXWPTgoRt9Te97lOWv
        EbIlOJX3td3U/jGjpvVt+kp6LQJlPF7L+YXNlLimBg==
X-Google-Smtp-Source: APXvYqwbneZ0yGNXkb4GOd0SqQTKu40IpwEzOBoKy4ttpZplNVGWvmRQRcgpfmABFgWAwnuUd26pd9bUZRVBdZMinuE=
X-Received: by 2002:ac8:1a21:: with SMTP id v30mr37394609qtj.103.1554917633872;
 Wed, 10 Apr 2019 10:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com> <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com> <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
In-Reply-To: <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Wed, 10 Apr 2019 13:33:42 -0400
Message-ID: <CAJWu+oq1ob=sPvyFktSKZLdgz-0Ok+9b30F9M-eukFOQCa9WBw@mail.gmail.com>
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

On Wed, Apr 10, 2019 at 12:35 PM Olof Johansson <olof@lixom.net> wrote:
>
> On Wed, Apr 10, 2019 at 8:51 AM Joel Fernandes <joelaf@google.com> wrote:
> >
> > On Wed, Apr 10, 2019 at 11:07 AM Olof Johansson <olof@lixom.net> wrote:
> > [snip]
> > > > > Wouldn't it be more convenient to provide it in a standardized format
> > > > > such that you won't have to take an additional step, and always have
> > > > > This is that form IMO.
> > > >
> > > > The location of the archive is fixed/known. If you are talking of the
> > > > location where the user decompresses it to, then they a;ready know where they
> > > > are decompressing to.
> > >
> > > The location _of_ the archive, sure. But the format of what is in the
> > > tarball, how it is versioned, and how to manage it will have to be
> > > done by every user.
> > >
> > > For any script that doesn't depend on some shared system state that
> > > wants to, say, build a eBPF program and load it, it would need to
> > > extract the tarball from scratch to make sure it is the current
> > > correct version of it.
> > >
> > > If that's required by all users, why not just present the data in a
> > > way that it can be used directly?
> >
> > That is the part that is unclear from your proposal. If we present a
> > filesystem view, then I am assuming the data will have to be
> > decompressed first into memory. That means you are proposing use of
> > 30MB uncompressed memory. The whole archive has to be decompressed but
> > the whole archive if compressed with XZ for a maximum compression
> > ratio.
>
> Only while the filesystem is mounted. So you would do something like:
>
>  - Mount filesystem
>  - Build and load
>  - Unmount
>
> The 30MB would only be used while the filesystem is mounted.
>
> Compared to:
>  - Extract tarball
>  - Build and load
>  - Remove file tree from filesystem

I feel there is no benefit in this proposal and adds considerable
complexity to the kernel for no benefit. Only drawbacks - will likely
do much poorly on lower memory devices, addition of more complexity
and likely bugs, etc.

> > > > > Having to copy and extract the tarball is the most awkward step, IMHO.
> > > > > I also find the waste of kernel memory for it to be an issue, but
> > > > > given that it can be built as a module I guess that's the obvious
> > > > > solution for those who care about memory consumption.
> > > >
> > > > Yes. We discussed in previous threads that for users who really want the
> > > > archive to be completely uncompressed and in-memory, can just load the
> > > > module, decompress into tmpfs, and unload the module. That is an extra step,
> > > > yes.
> > >
> > > Most users will need to decompress it every time they use it anyway,
> > > especially if there's no versioned prefix in the tarball that they can
> > > use to key to a previously decompressed version with the exact same
> > > kernel version and config.
> > >
> > > So, if you need to do that anyway, wouldn't it be easier if you just
> > > mounted a FS to get to it. If you're on a system where you can't use
> > > it in-place for resource reasons, you can copy it off and unmount it.
> > > No extra tools needed in userspace then at run/use time.
> > >
> > > Said filesystem could be populated by a compressed cpio archive since
> > > we already have code in the kernel to do this for initramfs, and could
> > > do so at mount time -- and at unmount time it'd be freed up.
> >
> > But still, decompressing to the filesystem in a scratch area may be
> > better than decompressing to RAM, for some users who have lesser RAM.
> > This patchset does not enforce a certain way of doing things and
> > leaves it to the user.
>
> There are lots of things where we provide suitable ways of doing
> things to the user instead of making them come up with their own
> handling of things. devtmpfs is a perfect example of this -- doing
> things in userspace was perfectly possible but still a hassle in many
> cases, and having the kernel do it for you when it already has the
> data makes sense.
>
> I'd expect many users to still want to do this to tmpfs. Also, I
> expect whatever userspace tools and programs that will consume this
> data is likely to consume similar or more memory while running anyway.
> So mounting + copying + unmounting on the heavily constrained systems
> shouldn't be raising the high water mark on memory consumption.

With this patch, a user can decompress the archive into their own
tmpfs instance if they want to. This was also mentioned on previous
threads. I don't see your point at all.

> > > If you absolutely need to export a file to userspace with the archive,
> > > my suggestion is to do it through debugfs. That way the format isn't
> > > in a /proc ABI that can't be changed in the future (debugfs isn't
> > > required to be stable in the same way). This way we can change the
> > > format carried in the kernel over time without changing the official
> > > way we present the data to userspace (via a filesystem view).
> > >
> > > As far as format goes; there's clear precedent on cpio being used and
> > > supported; we already have build time requirements on the userspace
> > > tools with some options. Using tar would actually be a new dependency
> > > even if it is a common tool to have installed. With a self-populating
> > > FS, there's no new tool requirements on the runtime side either.
> >
> > debugfs is going away for Android and is controversial in the fact
> > that its functionality isn't guaranteed to be there (debugfs breakages
> > aren't necessarily bugs AFAIK). So this isn't an option.
>
> The argument that this needs to go into /proc because Android is
> removing debugfs isn't a very strong one.
>
> And "debugfs breakages aren't bugs" is exactly why I'm suggesting to
> do the non-supported export of the archive that way instead.

BPF tools are shipped on production systems. They should not break,
that you want put them into debugfs to make them more likely to break
does not make any sense.

> > > > We had close to 2-3 months of discussions now with various folks up until v5.
> > > > I am about to post v6 which is in line with Masahiro Yamada's expecations. In
> > > > that I will be dropping module building artifacts due to his module building
> > > > concerns and only include the headers.
> > >
> > > I've found some of the old discussion and read up on it. I think it
> > > was pretty quick at dismissing ideas for more robust implementations
> > > ("it needs squashfs-tools"), and had some narrow viewpoints (exporting
> > > a tarball is the least amount of kernel change, while adding
> > > complexity at the system/usage side).
> >
> > Honestly, that's kind of unfair to be quoting just a few points like
> > that. If I remember there were 100s of emails and many good view
> > points were brought up by many people. We have done the diligence in
> > the discussions of this over a period of time.
>
> That wasn't captured with the patch submission, and having people go
> find 100s of emails to figure out why your seemingly lacking solution
> is the best one available is not how you motivate getting your code
> into the kernel.

I can summarize it better in the commit message. That's fine with me.

> > Greg KH and other maintainers are also supportive of it as can be seen
> > in other threads.
>
> I've found support for the desire to provide headers. If there's so
> much support for this solution, the number of Acks to the patch should
> have been higher.

There was at least one Ack on a prior revision, one Reviewed-by, and
at least 4 Tested-by(s). I dropped the tags since I changed the patch
a bit recently although the user interface and the idea is
fundamentally the same. Also Masahiro Yamada is happy with the quality
of the v6 patch, I privately chatted him. He mentioned he will likely
give his Acked-by tag.

> > We can consider an alternate proposal if it is
> > better, but I don't see any better one proposed at the moment.
>
> Really?

What do you mean? I meant better, as in, a proposal that works and
makes sense. Is simple, bug-free and solves the problem we are trying
to solve.

> > - cpio uncompressed to memory equally sucks because it consumes all
> > the memory uncompressed instead of reclaimable pages
>
> Only while mounted.

Still a disadvantage.

> > - decompressing into tmpfs will suck for Android because we don't use
> > disk-based swap and we run into the same cpio issue above. We use ZRAM
> > for compressed swap.
>
> See comments above about high water marks for memory consumption
> likely not moving much.
>
> > - debugfs is a non-option for Android
>
> Not my problem.

Really? Android runs on billions of devices. That is arrogant /
ignorant to say Android's requirements of moving away from debugfs are
not your problem.

> > The filesystem view sounds using mount/unmount like a pony to me, but
> > it does not meet the requirements above. Let me know if I am missing
> > something.
>
> What requirements?

I think you know this already - we don't want 30MB of active RAM being
used, that does not make much sense. debugfs doesn't work because
tools that need this will need to work even on production systems.
That you want debugfs because it is more susceptible to ABI breakage
doesn't make much sense. Not having all of the deal breakers above are
requirements.

thanks!

 - Joel

>
>
> -Olof
>
> --
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
