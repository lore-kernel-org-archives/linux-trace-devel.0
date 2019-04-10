Return-Path: <SRS0=mbrG=SM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF7DC10F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 15:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB720820
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 15:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="cKFn1n3j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733107AbfDJPQQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 11:16:16 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:53294 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733018AbfDJPQO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 11:16:14 -0400
Received: by mail-it1-f195.google.com with SMTP id y204so4010720itf.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Apr 2019 08:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXXoU6/FqhffNVx13TnuqZws2BBVOxxAPM7i3tEN7Gk=;
        b=cKFn1n3jYl3MDH5QBleg3GyZt9fGOMW0AOVk5V6g6+FahiMo/Yni6xpg1MBz2vDqwE
         jkLTyVfI/9w9tiSrfl7m+VqNrbiN/mOa2q2/xkEozcSzmbrwuYhOEyLbuaf6loxAKX6n
         2mNl5at8paa3YhadKIfZXAC+WI0PdMzHkELtW/4yxb6V5MY4jwm6H+iXsMS6FEiZ1l4z
         lvgE8LF8+Ggk7FGbOTPjJdFeIz6Zm4qQ6v2cVZhUFMkhZHDm3eVvrlpPyE+R+TpxIE7E
         0fIY3eh5s84Z0Yq4g1irQ2YBwCoWCY+v6e8DV0BFyoC4s6sBAyOuniNLQuKlXnfmyyQw
         dCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXXoU6/FqhffNVx13TnuqZws2BBVOxxAPM7i3tEN7Gk=;
        b=rNGl3bCwR5S/awlcP9n7Og5zFf7ktsHwY5wqhUZv2k+aQMZaqQexiDvVdasyBt2mUB
         qODm004xf3BTBkAKtk2u6BQ7URm4ZwRJvrDy1oRRTTtZRQ/9TVzAH1QwR2N5rYK+k5z5
         CiD0GvHbKaiz4tVVzxt823gVzARSAtMhY0nmgCoAZuB3uKtgCUp4oL/KmAiWTK+BQRBU
         pWrzL0UVbwbyr+IiAbHWTfo7MMkUuA0fuKd3NhnCXCcY+XEewv4iRq2sFYTXi1YdiiLi
         hN3cmHb7NU596qIxZpF6Vg7VINkhtrbSWdWpODo9mfwGRLJ/MS7C9HTcaH1uLh968P2+
         ySfQ==
X-Gm-Message-State: APjAAAVexdoAyV+e3VK+es4WB11+BfZicjO69AE5kPJ69MIVxICnIeO9
        3zj08flJSWz3oDL1ILHpiPKP/156syZ0myujUQDcHA==
X-Google-Smtp-Source: APXvYqxni5IADu3FF8FlZg+Ln4rHXEKRkaB44FhG/joIhG3TELx5Wv9r5dL3+NTYR01YmHFm91lgDHZM5+wOe8dfTck=
X-Received: by 2002:a24:2458:: with SMTP id f85mr2181063ita.83.1554909373652;
 Wed, 10 Apr 2019 08:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com> <79b6bdbc-890a-5a51-7fa1-aec57889046a@opersys.com>
In-Reply-To: <79b6bdbc-890a-5a51-7fa1-aec57889046a@opersys.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Wed, 10 Apr 2019 08:15:59 -0700
Message-ID: <CAOesGMgGFunOeMt93f57fPspdDSHp2twahhudEDhMvZ=VPJHaQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Karim Yaghmour <karim.yaghmour@opersys.com>
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

On Mon, Apr 8, 2019 at 1:52 PM Karim Yaghmour
<karim.yaghmour@opersys.com> wrote:
>
>
> Hi Olof,
>
> On 4/8/19 12:29 PM, Olof Johansson wrote:
> > Sorry to be late at the party with this kind of feedback, but I find
> > the whole ".tar.gz in procfs" to be an awkward solution, especially if
> > there's expected to be userspace tooling that depends on this
> > long-term.
> >
> > Wouldn't it be more convenient to provide it in a standardized format
> > such that you won't have to take an additional step, and always have
> > it in a known location?
> >
> > Something like:
> >
> >   - Pseudo-filesystem, that can just be mounted under
> > /sys/kernel/headers or something (similar to debugfs or
> > /proc/device-tree).
> >   - Exporting something like a squashfs image instead, allowing
> > loopback mounting of it (or by providing a pseudo-/dev entry for it),
> > again allowing direct export of the contents and avoiding the
> > extracted directory from being out of sync with currently running
> > kernel.
> >
> > Having to copy and extract the tarball is the most awkward step, IMHO.
> > I also find the waste of kernel memory for it to be an issue, but
> > given that it can be built as a module I guess that's the obvious
> > solution for those who care about memory consumption.
>
> One of the things I pointed out earlier in the thread is that
> /proc/config.gz has already set a precedent as to the interface for this
> sort of artifact. It's a plain compressed file and it's directly
> accessible from toplevel /proc. From a consistency perspective there's
> an idiomatic angle to some sort of "/proc/kheaders.gz".

I'm not arguing against providing the headers in some format, I think
that's a good idea.

On similarities, there are some but there are also substantial
differences in the use model.

For the config file, the main use cases are:

 - Checking to make sure that the running kernel has a particular set
of config options set or cleared.
 - Ease of cloning the config of a running kernel when building a new one.

The file format is just a plain text file, even if compressed. No real
internal structure to consider.

Both of the above uses are relatively rare (well, the first might be
done in some startup scripts, etc).

The kernel headers case is different. The file format is more complex
(tarball, which would also include the structure of said tarball). You
can't just zgrep to get some data out.

Also, the way the contents is used is different, in that it will be
needed by runtime tools that build and load eBPF programs. For the
build to always be known to be against the running headers, every
build would likely need to decompress and stage said tarball
independently and not rely on previous state. If that's needed, why
not just provide it once in the right format and avoid people building
userspace solutions in several different ways to do the same thing?

> In some offline discussions I was also told that squashfs (I'm no expert
> of it) required special user-space tools and had some security issues.

I'm unaware of what the security issues are, and there's indeed a
GPLv2 tool needed to construct the filesystem. The latter can be
solved, the former I don't know enough about to have an opinion.

Anyway, see my other reply just now -- CPIO + a filesystem view, and
providing said cpio archive in debugfs for those who want to copy it
off themselves might be something that fits everybody.


-Olof
