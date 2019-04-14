Return-Path: <SRS0=4wQP=SQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FCDC10F14
	for <linux-trace-devel@archiver.kernel.org>; Sun, 14 Apr 2019 19:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABD1F206B7
	for <linux-trace-devel@archiver.kernel.org>; Sun, 14 Apr 2019 19:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="WDfzNPNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfDNTir (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 15:38:47 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:53115 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfDNTir (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 15:38:47 -0400
Received: by mail-it1-f195.google.com with SMTP id x132so23774100itf.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Apr 2019 12:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QOWtsughs8v5wa64yJxww8mtNQrcGzXPVL4jTOgzC/c=;
        b=WDfzNPNq7XXUT+Vy97HPWh3UDNOGkcsiWIi4/1mGI47OsfGj/aBaJ0V5eP3WoLkFUm
         Okq47hXhs9TB71pWkv9Z3Uq1ogtTvwdoOPn/2In/Mo0ZHLwkDmqMiulDWXCxW9p9w3jK
         yNHQEgxW5nRBrKL3q02Dy1ki9B97+Po5aqDlcQuYRck+cKUYpA+XiKag5N/uTbiR6isX
         4elBNcmJSATa2N3hIifcyWnY7iCZyrxbO5mdH99IPwzy8V5YjYLjgdWyYyfIdItvu7Ac
         8rQbBKPtcGOcUzjRl1CiE+lIQBYppRfBgpHNLEQ6ykvJiFnYV3yCkiSPMXvZbYMZFYgz
         AHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QOWtsughs8v5wa64yJxww8mtNQrcGzXPVL4jTOgzC/c=;
        b=BtB7z9cHQ2jbKIw0krIQIE14lNnCPUbTZ4wMhDGSZu+DL4t+kSR5kB/KJA2Ji0xhos
         +5u4mNqKRQbRbTKobJBMZTs09mL6ub4A18yY5i+yTaoaJ2jZu4HKwCRWNNvQmGTfIccT
         kmsbdojdix+7ijbEthjNhNOLNs6ee+I0gFDAVIpvA3rvNQ/2auszTk23rdZUXiCl81f5
         xH0UqehRKgO/ZqCMdTRt/DeGpdYTpfBW1RDI1+rySKnGOS79iXVGwSPlSFG2jhyypmfY
         CQfWEDpmpQUvTreJwcb4FXdAWTLyi9pbESVOEs2qKr3gPVWr/D2vxwoRN3yUHqHERGFs
         negA==
X-Gm-Message-State: APjAAAVSrwzV6ZJcian8UF2kgHRBYOSoXnR0NWID7hV2CCmZIUfROLBj
        Ng4GA+17CfrLbFs9HKp+Enn+azr/qk3XUOyYtiVgiQ==
X-Google-Smtp-Source: APXvYqw1e1E6pqgqVUSjzULhu0+QVSb2v6ZJpDczRMWtqKRDHCkklZ/5N4hAkSSB8CVIDSZWj7xazJ3U9w1CNvAgGpY=
X-Received: by 2002:a02:c7c8:: with SMTP id s8mr48885831jao.13.1555270726209;
 Sun, 14 Apr 2019 12:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com> <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com> <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Sun, 14 Apr 2019 12:38:34 -0700
Message-ID: <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joel Fernandes <joelaf@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
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

On Wed, Apr 10, 2019 at 8:15 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Apr 10, 2019 at 09:34:49AM -0700, Olof Johansson wrote:
> > On Wed, Apr 10, 2019 at 8:51 AM Joel Fernandes <joelaf@google.com> wrote:
> > >
> > > On Wed, Apr 10, 2019 at 11:07 AM Olof Johansson <olof@lixom.net> wrote:
> > > [snip]
> > > > > > Wouldn't it be more convenient to provide it in a standardized format
> > > > > > such that you won't have to take an additional step, and always have
> > > > > > This is that form IMO.
> ...
> > Compared to:
> >  - Extract tarball
> >  - Build and load
> >  - Remove file tree from filesystem
>
> I think there are too many assumptions in this thread in regard to what
> is more convenient for user space.
> I think bcc should try to avoid extracting tarball into file system.
> For example libbcc can uncompress kheader.tar.xz into virtual file system
> of clang front-end. It's more or less std::map<string, string>
> with key=path, value=content of the file. Access to such in-memory
> 'files' is obviously faster than doing open/read syscalls.

I think performance is a red herring, especially since you have to
uncompress it on every compiler invocation. With this you'd need to
read/touch/write _all_ header files, not just the one your current
compiler invocation will use.

In the grand scheme of things, open/mmap syscalls wouldn't necessarily
be slower.

> bcc already uses this approach for some bcc internal 'files' that
> it passes to clang during compilation.
> All of /proc/kheaders.tar.xz files can be passed the same way
> without extracting them into real file system.

This is now a circular argument. Joel was stating that the plain text
headers took up too much memory, but now it's preferred to create such
filesystem in userspace memory on *every compiler invocation*?
That's... not better. And definitely worse if you want to compile in
parallel.


From my perspective, this is where we're at:

This patch seems to have been met with a lot of responses in the tone
of "this is not an appealing solution". Meanwhile, some of the
suggested alternative solutions have not worked out, and we are now at
a point where there's less interest in exploring alternatives and
arguments to merge as-is with only minor adjustments.

I understand the desire to solve this. It'd be really convenient to
have a way to runtime build against the same structure layouts that
the kernel was built with. But I haven't heard anyone say that they
*like* the solution proposed, and I haven't seen many of those
expressing concerns being converted to support it.

Usually what we do at times like this is that we say "Yeah, this is a
problem that should be solved, but this solution doesn't seem to be
the right one and we would need to maintain it forever as part of the
ABI. Let's wait until a better solution is found." With time,
sometimes a better solution becomes obvious, or circumstances change
enough to allow for some different approach, or someone has a new idea
from a different perspective that solves the same problem.

All of that being said, I don't have veto rights on code going into
the kernel, even if I think picking up this patch would be the wrong
thing to do.

I'd be a *lot* less hesitant if this went into debugfs or another
location than /proc, which is one of the most regression-sensitive
interfaces we have in the kernel.

> Joel, would be great if you can share corresponding bcc patch
> that takes advantage of /proc/kheaders


-Olof
