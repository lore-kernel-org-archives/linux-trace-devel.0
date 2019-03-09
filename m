Return-Path: <SRS0=JYjC=RM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E731C4360F
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 11:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AE3120851
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 11:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfCILkQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 06:40:16 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:36321 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfCILkQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 06:40:16 -0500
Received: by mail-ua1-f66.google.com with SMTP id e15so78634uam.3;
        Sat, 09 Mar 2019 03:40:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dVOav3r8ivQH0z5VTvH/O/+o1u3rBLRnz5eRJq86oeY=;
        b=uLya21oOL6ns5S6LHVf/5u5O9a78LECd8hcl8oQAR+h86l7grh/IqbMdi/P205QleP
         94s+gFHZ4btMn4nXfvW7g5lXy1Q0w15H017vIuoocpD0+WMHyAsmLJPZ56f+N0m/vc7s
         VfAuCBe/28Hnw0mSFEu8atGRiSGzt97v6TcVgiUCO8+FuHXLZc6u2CkmKum6Jfjysctu
         jDwAnKmtftjwtKao+mOIIj8TAgPPpTKdw9qud3GHArCj3lxGpV9TGjoR/8OsWEz/Ezsy
         L7rbXQet74HMgt9e8HJvvoqt9nGSUUWzumEUk3rdIYOXGZNo9Ds/wRyka0chw0i18EzF
         wD3g==
X-Gm-Message-State: APjAAAU1YWLUVDoIPZ9nH0IO2c23gTHmufCv+JPh7YVvvBYJb6rPisdH
        gBvtJRzX5nRV1NYVEmRZieAwaQ7E731YXTC8HQs=
X-Google-Smtp-Source: APXvYqy2ByphqFvPWq7AXkUzWMmzRx5yrARF3HXjm6v+9oMKQJJ2P8yeEZZSdesTaL3h3LbyDXptgXSVO83ZDWlKhAA=
X-Received: by 2002:a9f:30dc:: with SMTP id k28mr12469986uab.75.1552131614391;
 Sat, 09 Mar 2019 03:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com> <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com> <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com>
In-Reply-To: <20190309071648.GE3882@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 9 Mar 2019 12:40:01 +0100
Message-ID: <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
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

Hi Greg,

On Sat, Mar 9, 2019 at 8:16 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 08, 2019 at 06:59:23PM +0100, Geert Uytterhoeven wrote:
> > On Fri, Mar 8, 2019 at 6:05 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Fri, Mar 08, 2019 at 05:42:32AM -0800, Joel Fernandes wrote:
> > > > On Fri, Mar 8, 2019, 3:53 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > > > It is just so much easier to use tar + xz at build time, and leave the
> > > > > > decompression task to the user. After decompression, the files will live on
> > > > > > the disk and the page-cache mechanism will free memory when/if the files fall
> > > > > > off the LRUs.
> > > > >
> > > > > I'm also considering how generic and extensible the solution is.
> > > > > What if people need other build artifacts in the future (e.g. signing key to
> > > > > load signed modules)?
> > > >
> > > > That sounds like it could be useful. I don't see any reason off the
> > > > top why that would not be possible to add to the list of archived
> > > > files in the future. The patch allows populating the list of files
> > > > from Kbuild using ikh_file_list variable.
> > >
> > > Um, no, you don't want the signing key in the kernel itself, as that
> > > totally defeats the purpose of the signing key :)
> >
> > In a loadable module?
> > He who has the module, can build and sign more modules.
>
> Again, that's pretty foolish.
>
> Signing keys should be kept secure, or better yet, just deleted entirely
> after creating and signing with them.  That's what I do for my kernels
> and I'm pretty sure that some distros also do this.  That way there's no
> chance that someone else can sign a module and have it loaded without
> detection, which is what signing is supposed to prevent from happening.

If you want that kind of security, there's no point in allowing to extend the
kernel by building more kernel modules after deployment.

The more I think about this (embedding a kernel headers archive in the
kernel or a kernel module), the more I feel this is a workaround for a distro
issue.
Files are distributed with the kernel image, e.g. loadable kernel modules,
so distributing more files is not a technical issue (and if it is, working
around that might be as simple as "mv kheaders.tar.xz kheaders.ko",
and letting module install take care of it ;-)
It makes sense to provide /proc/kconfig.gz, as this is unique
configuration info.  The kernel headers can easily by derived from this
config, and the kernel sources (which are GPL).

"Raw kernel headers also cannot be copied into the filesystem like they
 can be on other distros, due to licensing and other issues. There's no
 linux-headers package on Android."

What's the licensing issue? What's the (legal) difference between having
the headers on the file system, and having a kernel module including the
headers on the file system?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
