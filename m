Return-Path: <SRS0=JYjC=RM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB61C10F0D
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 19:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B1F2207E0
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 19:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfCIT0x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 14:26:53 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:41716 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfCIT0w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 14:26:52 -0500
Received: by mail-ua1-f67.google.com with SMTP id j7so299008uak.8;
        Sat, 09 Mar 2019 11:26:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AAqB6aPEulBxFa6L4PnE5pJMgPtYdJeULQPU7Hg+bCE=;
        b=IarylnUPsCvRU+8D6QxRdiXVNQJUWGoq2cX9bIG79UooFVl7rHcQ2DIBbHMyu2EUDs
         vQiGm/UeZJpeo4ItQwxEXZViSFAVHuqGrd5b9d9QS+lgIQ7FjD9lGf0Lr0H9AAiZmWi9
         dd7NK+IiGLu+Jad8mkWl1I/Icg9LclMHAAnP9iCpMglePSdIHDNrH4Ui/X8PGLEjhyKp
         kwyHd2ZADGhp5DQqW7h3vOyUGrUlcWmBc+9keBejiPVDX2HBykqji3/Z1cViyVNpgcMF
         /PBv1fxX908avv1jDfQ5DDtQirwJDeAiIVX48QwA92ARQE5QfUYQGvDVRwqGTCK6MlrX
         Cl2g==
X-Gm-Message-State: APjAAAW0AVBjkj7Cmxz6MhrTPZN78YZXwfmqcmOqU3ndySiaW7AtFFWk
        p9GTS1CJv2/BQhNkfS5gXaKQ33TyhJoZ7hF+UlA=
X-Google-Smtp-Source: APXvYqwU/Ucwx+j8RglXLCLe/TmaoXH0K2Ul79JfEk6r2JqwW0sM4n/T2J0RWur3a6W/8tu1kLKRzl/CFHS+5uErXwE=
X-Received: by 2002:a9f:2f0b:: with SMTP id x11mr12348794uaj.78.1552159611142;
 Sat, 09 Mar 2019 11:26:51 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com> <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com> <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com> <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
 <20190309121141.GA30173@kroah.com> <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
In-Reply-To: <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 9 Mar 2019 20:26:39 +0100
Message-ID: <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Karim Yaghmour <karim.yaghmour@opersys.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
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

Hi Karim,

Thanks for the explanation!

On Sat, Mar 9, 2019 at 5:52 PM Karim Yaghmour
<karim.yaghmour@opersys.com> wrote:
> On 3/9/19 7:11 AM, Greg KH wrote:
> > There is no licensing issue, see my follow-up comment about that.
> >
> > It's all in ease-of-use here.  You want to build a trace function
> > against a running kernel, and now you have the header files for that
> > specific kernel right there in the kernel itself to build against.  It
> > doesn't get easier than that.
>
> Agreed.
>
> It seems that opinions in this thread are split along two conceptions of
> a "Linux system". On one side there's that of the conventional "Linux
> distro" where the entity generating the distro has full control over the
> entire process and the parts thereof. On the other side there's the
> world that has evolved out of the multi-party ecosystem that Android
> fostered. In the later, there isn't a single party that controls all
> aspects of the "distro". Instead, there are a multitude of parties
> contributing to creating a fully-functional Linux-based system.
>
> In the latter ecosystem, the kernel and the filesystems (*plural*) used
> with it do not necessarily come from the same place, are maintained by
> the same parties or even required to be in lock-step. For all I know,
> the filesystem images are coming from one party and the kernel is at one
> point from one party and at another point can be substituted, possibly
> for testing purposes, without userspace images ever changing. No
> licensing issues at all involved, either with regards to the headers or
> the distribution of the kernel itself, which, in as far as I've seen
> when speaking of known industry players (those that matter here), are
> always ultimately available in source from somewhere.
>
> Instead the issue is that I want to be able to give user-space access to
> the headers that were used to build the kernel that they're running
> over, regardless of where this kernel came from. And since I have to
> assume that those two parts (kernel vs. user-space) are coming from
> separate parties and can be arbitrarily replaced, there needs to be some
> form of "contract" between them. The kernel's ABI already provides quite
> a bit of that and, as Joel pointed out, Google can enforce a few more
> things, such as default kernel configs, to "make things work". But one
> option that doesn't exist in the world Android evolves in is to somehow
> ensure that the filesystem images somehow have kernel-specific
> tool-required artifacts for every possible kernel they may run against.
> That's just not possible.
>
> That's especially true in the case of modern-day Android where the final
> system is made of at least half a dozen filesystem images with each
> image possibly coming from a different party. The /vendor partition
> (with the hardware enablement), for example, could be coming from the
> device vendor while the /system partition (with the Android framework),
> for example, could be coming straight from Google in the form of
> "Generic System Image" -- an image meant to run as-is on any
> Treble-compliant system. /system might have the tools for eBPF, but
> /vendor might have modules, while still the "boot" partition might have
> the kernel. There's no reason I can't replace the boot partition
> *without* changing /vendor. And there's no reason I can't replace
> /vendor *without* replacing the boot partition. And all other
> combinations with all other images.

So how does this work, with kernel images and kernel modules supplied
by separate parties, not "bound" by the same kernel headers/API, as they
can be replaced separately?

> That, in my view, is a big part of the problem Joel's patch solves: in a
> system whose functionality requires multiple *independent* parties to
> work together, I can still get the necessary kernel headers for
> user-space tools to properly operate regardless of which part of the
> system id being substituted or replaced.

Isn't the need for kernel headers for user-space tools something different,
as this is limited to the uapi versions, which are less (almost not) subject
to change, compared to the kernel headers needed for compiling kernel
modules?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
