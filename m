Return-Path: <SRS0=jT/G=QQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8C3C282CB
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Feb 2019 00:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AF3920844
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Feb 2019 00:40:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V9RzXgcO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfBIAkW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 19:40:22 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36801 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfBIAkV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 19:40:21 -0500
Received: by mail-ot1-f67.google.com with SMTP id k98so8968885otk.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Feb 2019 16:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0w3Ukbs+RXQR7C9N95F48Zuxzzs5y+qN9AJE71LlehA=;
        b=V9RzXgcODcZdIhljMasYD7/kAPjEMdyucO1l6yTbIcevkoNPrxAEeDb9POCViuOTh5
         cWhtLsQCmr8FbZHRoy7J+a3HzOBVPOAMtTqIGA05SFiaMHj5UX90JZVsWVnMrI0tIvm9
         AElqeJm+39TJ+/oPIjEA6vnM56hn6QKjE8rQaENhlI0SDZAn4dVKZ3zwH1bwQ21Ne2nd
         seEeolqbd3TXkA753po4l+cXpims2IVooKWeEqPVxv8d/lUTcOwbRdz8i3YJ+pzCLXa2
         zO6JKm2qUZ8AkfyFzRFyeVzIhrvCp7HO5KAZE58lwUw5qcb07van8X+8QHydJnAV9XgI
         nlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0w3Ukbs+RXQR7C9N95F48Zuxzzs5y+qN9AJE71LlehA=;
        b=dnEyvxl92K5t7T8wxwreLPVvwIQzPOnxN/ZDu4G5yO1hd+xmDSCzFw7TmaUAWnFyBd
         f2tEq5awl1YgrTPSoHFrvyLgThs5pEToZhv2NQcFOnGXc2mjWTSTyCzHums1MFgdGD1K
         0tLyaDdB8DPRX5XipZc6EkjOvJNkLVrKoAiaQom9U+q8FtwIngSL82P+6+Q2Mfbt1dUH
         8DoqI23dA5cWIBaw1fQbYDy9yzt6avQmtFZhs86vKGx9HvsHr7IQD8z7P8yv/c+1SW8t
         dcZZG5tbE57XGGlmEPnzjtXGFszWb/XSMozYC7B2C2LJnKu/XWKktcmdfTIqW7WdTfoT
         VQFw==
X-Gm-Message-State: AHQUAubeWZA0k/HxPlBCpaX7o8zCgDE01dkWySTjaAf+iI2Ox3uJG/3r
        RbPonUGD778tRnh/9kbT9g9sVgihRvLl+q5T1VR4Qg==
X-Google-Smtp-Source: AHgI3IZ84Za4K9rvAjg0gu0mOFc8BJC6Qu9hsEOKfDL06SIIr9xF7+Z0i2QYx7pD57IZtneYPjhR3j/H+WKpVunXcds=
X-Received: by 2002:a9d:6398:: with SMTP id w24mr4926405otk.364.1549672819885;
 Fri, 08 Feb 2019 16:40:19 -0800 (PST)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-12-brendanhiggins@google.com> <841cf4ae-501b-05ae-5863-a51010709b67@ideasonboard.com>
 <CAFd5g47x-UNja72k-CWPmWz9+LTn8pF8Wj5Poq+2FJ93E=vymA@mail.gmail.com>
 <20181204204701.GT28501@garbanzo.do-not-panic.com> <f8722f4a-44c8-24c2-c433-5178f9f40b82@ideasonboard.com>
 <20181206153718.GD24603@bombadil.infradead.org> <20181211140926.7wzd5jh6klcfsfgz@pathway.suse.cz>
 <20181211094140.2a928fe7@gandalf.local.home> <34f9e9f3-6bca-f11f-097c-c6e0cb779b61@cambridgegreys.com>
In-Reply-To: <34f9e9f3-6bca-f11f-097c-c6e0cb779b61@cambridgegreys.com>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Fri, 8 Feb 2019 16:40:08 -0800
Message-ID: <CAFd5g46kQ=x0PA+04qSm4At23cNvYTUszPb-6eadJ9N04POFUQ@mail.gmail.com>
Subject: Re: [RFC v3 11/19] kunit: add Python libraries for handing KUnit
 config and kernel
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>, brakmo@fb.com,
        Knut Omang <knut.omang@oracle.com>, jeffm@suse.com,
        dri-devel@lists.freedesktop.org,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Rob Herring <robh@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-nvdimm@lists.01.org, mpe@ellerman.id.au,
        Eric Sandeen <sandeen@sandeen.net>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Matthew Wilcox <willy@infradead.org>,
        Felix Guo <felixguoxiuping@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Kent Overstreet <kent.overstreet@gmail.com>, jdike@addtoit.com,
        Tim.Bird@sony.com, linux-um@lists.infradead.org,
        Julia Lawall <julia.lawall@lip6.fr>, dan.j.williams@intel.com,
        kunit-dev@googlegroups.com, richard@nod.at,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kees Cook <keescook@google.com>, joe@perches.com,
        linux-fsdevel@vger.kernel.org, khilman@baylibre.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Dec 11, 2018 at 9:02 AM Anton Ivanov
<anton.ivanov@cambridgegreys.com> wrote:
>
>
> On 12/11/18 2:41 PM, Steven Rostedt wrote:
> > On Tue, 11 Dec 2018 15:09:26 +0100
> > Petr Mladek <pmladek@suse.com> wrote:
> >
> >>> We have liburcu already, which is good.  The main sticking points are:
> >>>
> >>>   - printk has started adding a lot of %pX enhancements which printf
> >>>     obviously doesn't know about.
> >> I wonder how big problem it is and if it is worth using another
> >> approach.
> > No, please do not change the %pX approach.
> >
> >> An alternative would be to replace them with helper functions
> >> the would produce the same string. The meaning would be easier
> >> to understand. But concatenating with the surrounding text
> >> would be less elegant. People might start using pr_cont()
> >> that is problematic (mixed lines).
> >>
> >> Also the %pX formats are mostly used to print context of some
> >> structures. Even the helper functions would need some maintenance
> >> to keep them compatible.
> >>
> >> BTW: The printk() feature has been introduced 10 years ago by
> >> the commit 4d8a743cdd2690c0bc8 ("vsprintf: add infrastructure
> >> support for extended '%p' specifiers").
> > trace-cmd and perf know about most of the %pX data and how to read it.
> > Perhaps we can extend the libtraceevent library to export a generic way
> > to read data from printk() output for other tools to use.
>
> Going back for a second to using UML for this. UML console at present is
> interrupt driven - it emulates serial IO using several different
> back-ends (file descriptors, xterm or actual tty/ptys). Epoll events on
> the host side are used to trigger the UML interrupts - both read and write.
>
> This works OK for normal use, but may result in all kinds of interesting
> false positives/false negatives when UML is used to run unit tests
> against a change which changes interrupt behavior.
>
> IMO it may be useful to consider some alternatives specifically for unit
> test coverage purposes where printk and/or the whole console output
> altogether bypass some of the IRQ driven semantics.

Whoops, sorry, didn't see your comment before I went on vacation.

I completely agree. It is also annoying when trying to test other
really low level parts of the kernel. I would really like to get KUnit
to the point where it does not have any dependencies on anything in
the kernel, but that is very challenging for many reasons. This
loosely relates to what Luis, myself, and others have talked about in
other threads about having a stricter notion of code dependencies in
the kernel. Thinking about it now, I suspect it might be easier to
limit KUnit's dependency on kernel infrastructure first; that could
kind of motivate the later work.
