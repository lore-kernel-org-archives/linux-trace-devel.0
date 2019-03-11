Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D703EC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB4C5206BA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbfCKIDS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:03:18 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:35503 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfCKIDR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 04:03:17 -0400
Received: by mail-ua1-f65.google.com with SMTP id f88so1208133uaf.2;
        Mon, 11 Mar 2019 01:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6fNWk8OeLylMGSr/QhDqtEO909ML1200u00RLEvDQg=;
        b=dGJ1GuPvyaUf/KXRaBqaHkCG4XzQJ9ryh1TMq84b1p36CyGHSM5D/zF6lNXx0myoO0
         cZ8jqaAJx1mX7o19nJJwfqeRtGJGPc9Yr9tqwqNwXKvNlIWPj3dGvnNyNyz3tFrRI/Pm
         QsMIDjCJmhJhm1HVBfuhTwjwTsAypvuTpbYXU0kbfUQcSZWeKhJOrq39Jevq2iRhznbD
         rQKV7mrPhhX4Lu9ZTOi35EyxhJWnp5QdCLg/0xOmV8li023XxhZmY/z61tyVYYVChs4O
         tj/tM82JpJtp+4UPrhdz76mYK2WMkBDnts5ODcxtr1y3BNPnLfZi+ZXkSGbV9C7MojH9
         eSug==
X-Gm-Message-State: APjAAAUo/sDEbq4DUvW71291M4bLbjfZyj2keI+ltFttwhf5pFJn52BG
        wAQEn/p4p1yQey3+z+5gvwQxA6qB908ngJ12jzU=
X-Google-Smtp-Source: APXvYqymnFJLYtNM4TZgNy/XAYJpok8piQkqvaozL02DJJP4x/2cpgLT/kq4Wahp84dwf73icG+1eVSu5WnntTWHzk8=
X-Received: by 2002:ab0:7191:: with SMTP id l17mr14739251uao.28.1552291396132;
 Mon, 11 Mar 2019 01:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com> <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com> <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com> <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
 <20190309121141.GA30173@kroah.com> <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
 <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com> <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
In-Reply-To: <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 11 Mar 2019 09:03:04 +0100
Message-ID: <CAMuHMdVw=b_oS70F1LhXV0b9fn_p6OuCo2RDUQC=49PdJVW7xA@mail.gmail.com>
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

On Sat, Mar 9, 2019 at 10:44 PM Karim Yaghmour
<karim.yaghmour@opersys.com> wrote:
> On 3/9/19 2:26 PM, Geert Uytterhoeven wrote:
> > So how does this work, with kernel images and kernel modules supplied
> > by separate parties, not "bound" by the same kernel headers/API, as they
> > can be replaced separately?
>
> The thing with Android is that there isn't a "one size fits all". Google
> provides guidance, policies and at least one example implementation
> through the Pixel lines.
>
> Each vendor however is allowed a great degree of latitude with regards
> to what they decide to do. Personally, if I was advising a team working
> on an Android device where Joel's patch was available as part of their
> kernel I would just recommend that they build it in -- i.e. not as a
> module. Hence, there would be no module chasing game.

OK, that makes sense, if kernel and modules are separate.
So kernel size increase due to including the headers does matter.

> With regards to Google's guidelines for manufacturers, though, Google
> states that CONFIG_MODVERSIONS needs to be enabled, see here:
> https://source.android.com/devices/architecture/kernel/modular-kernels
> FWIW, that doesn't mean that modules are actually used. Devices don't
> necessarily have to be using modules.

Personally, I had mixed experiences with CONFIG_MODVERSIONS.
But that was a looong time ago, before Android.
Things may have improved.

> > Isn't the need for kernel headers for user-space tools something different,
> > as this is limited to the uapi versions, which are less (almost not) subject
> > to change, compared to the kernel headers needed for compiling kernel
> > modules?
>
> Sorry, I should've been clearer. I'm including eBPF/BCC into the
> "user-space tools" here. That was in fact my prime motivation in
> encouraging Joel at the last LPC to look at this. I've been integrating
> the teaching of eBPF into my AOSP debugging and performance analysis
> class (see CC courseware here:
> http://www.opersys.com/training/android-debug-and-performance), and it
> was pretty messy trying to show people how to benefit from such tools
> under Android. Joel's present set of patches would obviate this problem.

OK.

Now about the actual solution: what is your opinion on embedding e.g.
a squashfs image in the kernel instead, which would be a more generic
solution, not adding more ABI to /proc?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
