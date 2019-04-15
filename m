Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CBBC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 14:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28B2B20880
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 14:05:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="NCEoz5IK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfDOOFe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:05:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46085 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbfDOOFe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 10:05:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id 9so8622840pfj.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 07:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0WDxr7x++wyxZBE+48i+O5ufisb7Dj38JxloaCZIM1g=;
        b=NCEoz5IKT8jCnPgqYIAWnJK8ysRkcxML7a53/BSGxcv4hkvYLWrjZ9Yscpy5OoTZmA
         UgA88NzFVWuBs/mro+fu0DELzgUH7DgwJ5zjtM7kJcbbLgKxwADikls2Zbhp3rfQYvmU
         FalL6hftLUMqTQUZXUZEJVGJILFdgUIyMhags=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0WDxr7x++wyxZBE+48i+O5ufisb7Dj38JxloaCZIM1g=;
        b=rYL88NXZo7yCJP37d5SVk03HZ3qCCKCWFDC5JN12FaHiIzrEFrCzRZ8Q+vVPE0fBum
         0CYgLGz1zH8c18KZg+/znJm0T9VDyj1YbKK5ahJmdKiqQJWVjxt2i0jFGBHtOp7Rd93A
         UvnZn860Dl5zD5LerHZq7Soy2ttw/HRYwTq4sRBuOGtuBFIPxK9uz7r28d4t41K58qla
         Mk3xIU6AgBKXQt0ANH/WH/5v/K07urDW8t4Wh7frRyeKfqPVSg6GSMqEcc+bOnpxXKe/
         vmqAy8gm6UqOGmws8e4S58OV5aseDt6VHKivGvRpSMNiKzzu7wwtwNkvFDJw1WV2xPGF
         u2Fw==
X-Gm-Message-State: APjAAAX9xjqcA1rv9bb/mK1JtHexTVIuyiUTXF6HTTcR57Hq5lpfOvCW
        3Z+6iL8YC5cowF4p4e0jCffsaQ==
X-Google-Smtp-Source: APXvYqyLhgQVBx81W0JcBdv3yAJYu5l22G1X1P7p/QGvIEXEqRq+ou1HUwmoW8xJZITy8HzRTkNEJg==
X-Received: by 2002:a63:5149:: with SMTP id r9mr67474876pgl.177.1555337133723;
        Mon, 15 Apr 2019 07:05:33 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id d69sm35046794pfg.24.2019.04.15.07.05.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Apr 2019 07:05:32 -0700 (PDT)
Date:   Mon, 15 Apr 2019 10:05:31 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Olof Johansson <olof@lixom.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190415140531.GB205801@google.com>
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com>
 <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Apr 14, 2019 at 12:38:34PM -0700, Olof Johansson wrote:
> On Wed, Apr 10, 2019 at 8:15 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Apr 10, 2019 at 09:34:49AM -0700, Olof Johansson wrote:
> > > On Wed, Apr 10, 2019 at 8:51 AM Joel Fernandes <joelaf@google.com> wrote:
> > > >
> > > > On Wed, Apr 10, 2019 at 11:07 AM Olof Johansson <olof@lixom.net> wrote:
> > > > [snip]
> > > > > > > Wouldn't it be more convenient to provide it in a standardized format
> > > > > > > such that you won't have to take an additional step, and always have
> > > > > > > This is that form IMO.
> > ...
> > > Compared to:
> > >  - Extract tarball
> > >  - Build and load
> > >  - Remove file tree from filesystem
> >
> > I think there are too many assumptions in this thread in regard to what
> > is more convenient for user space.
> > I think bcc should try to avoid extracting tarball into file system.
> > For example libbcc can uncompress kheader.tar.xz into virtual file system
> > of clang front-end. It's more or less std::map<string, string>
> > with key=path, value=content of the file. Access to such in-memory
> > 'files' is obviously faster than doing open/read syscalls.
> 
> I think performance is a red herring, especially since you have to
> uncompress it on every compiler invocation. With this you'd need to
> read/touch/write _all_ header files, not just the one your current
> compiler invocation will use.
> 
> In the grand scheme of things, open/mmap syscalls wouldn't necessarily
> be slower.

Agreed.

> > bcc already uses this approach for some bcc internal 'files' that
> > it passes to clang during compilation.
> > All of /proc/kheaders.tar.xz files can be passed the same way
> > without extracting them into real file system.
> 
> This is now a circular argument. Joel was stating that the plain text
> headers took up too much memory, but now it's preferred to create such
> filesystem in userspace memory on *every compiler invocation*?
> That's... not better. And definitely worse if you want to compile in
> parallel.

The BCC patch does not extract purely into memory, but uses temporary
directory: https://github.com/iovisor/bcc/pull/2312
I believe this is a good approach.

> From my perspective, this is where we're at:
> 
> This patch seems to have been met with a lot of responses in the tone
> of "this is not an appealing solution". Meanwhile, some of the
> suggested alternative solutions have not worked out, and we are now at
> a point where there's less interest in exploring alternatives and
> arguments to merge as-is with only minor adjustments.
> 
> I understand the desire to solve this. It'd be really convenient to
> have a way to runtime build against the same structure layouts that
> the kernel was built with. But I haven't heard anyone say that they

About structure layouts, I'm assuming you mean compiler generated debug info.
That does not work for eBPF tools as was mentioned previously in these threads:
https://lkml.org/lkml/2019/3/11/1358
https://lkml.org/lkml/2019/3/11/1363

> *like* the solution proposed, and I haven't seen many of those
> expressing concerns being converted to support it.

IMHO there has been good number of people on both sides of the argument. If
it were as strong of an opposition as you think, then I would have personally
not wanted this merged tbh. We do want a solution that is clean and works, and
I think this is a candidate.

[snip]
> I'd be a *lot* less hesitant if this went into debugfs or another
> location than /proc, which is one of the most regression-sensitive
> interfaces we have in the kernel.

The solution should be regression-sensitive imho, we don't want the tracing
tools to break, people use them. And their usability and robustness is
important which prompted these patches. For some time we have been hosting
downloadable headers for popular kernels (such as LTS versions) to workaround
this issue, but this both a maintenance issue and non-scalable, and not
robust (someone boots a custom kernel or we forget to update headers for a
future LTS release and the tools break).

thanks,

 - Joel

