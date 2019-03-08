Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF17AC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE17720857
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfCHR7j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:59:39 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:33865 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfCHR7i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:59:38 -0500
Received: by mail-vs1-f67.google.com with SMTP id h7so7162794vsl.1;
        Fri, 08 Mar 2019 09:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bl23IqlXVLl4dYGtmdvkTWrze0qrDnnH2IRJyRYQ07A=;
        b=Ji01P01h5hyyxyyp6yKIIczbonBI9eBQP6wlkptiqGmBcxLypFENFRcj2+1Iytl9Eh
         ArKd03pQ0c6y8ZxzBOC4K9wH/QU+1SqLLSolDuHO4HbmNTSDoO4WQjrsgpvFL0E7keBI
         pCC8/KjX8QMgFXQ54kEKq5tT6/c1Cj3h4p/Wna6aXFYIpu5w+VbGWK430yi/E/cw3T5B
         h/21LpDK9OzbkPWLKAVbuOMA6bKhpWJ3Dbi7HwjQdId7Jho4QzwvOwVcHxNFsDkzMb35
         sWc7fohzrjtyQqgpBiM1e7J+jtizpb8ezUPLqv2XCiDrdro9wrviTixVrglvZqEQ3Frl
         STzw==
X-Gm-Message-State: APjAAAXH+knGDrkbvJ0zJypbzLTMEq32TgdTcB1hx1jHf+X1jAbYy8TL
        h52U9y2HpodlYOURJq+FjJGNvf7ZUJCjYOGBwz4=
X-Google-Smtp-Source: APXvYqxNU0D/qLTuYnHQcOn7djLmaMNaAdJtt5VLHICD1D64fK6fLPvqzV1httDPl0lGr28w+SEkOKlMXij+q9SlbI8=
X-Received: by 2002:a67:fc9a:: with SMTP id x26mr10580270vsp.166.1552067976545;
 Fri, 08 Mar 2019 09:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com> <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com> <20190308140251.GC25768@kroah.com>
In-Reply-To: <20190308140251.GC25768@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Mar 2019 18:59:23 +0100
Message-ID: <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
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

On Fri, Mar 8, 2019 at 6:05 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 08, 2019 at 05:42:32AM -0800, Joel Fernandes wrote:
> > On Fri, Mar 8, 2019, 3:53 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > It is just so much easier to use tar + xz at build time, and leave the
> > > > decompression task to the user. After decompression, the files will live on
> > > > the disk and the page-cache mechanism will free memory when/if the files fall
> > > > off the LRUs.
> > >
> > > I'm also considering how generic and extensible the solution is.
> > > What if people need other build artifacts in the future (e.g. signing key to
> > > load signed modules)?
> >
> > That sounds like it could be useful. I don't see any reason off the
> > top why that would not be possible to add to the list of archived
> > files in the future. The patch allows populating the list of files
> > from Kbuild using ikh_file_list variable.
>
> Um, no, you don't want the signing key in the kernel itself, as that
> totally defeats the purpose of the signing key :)

In a loadable module?
He who has the module, can build and sign more modules.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
