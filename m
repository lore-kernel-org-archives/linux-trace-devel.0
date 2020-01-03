Return-Path: <SRS0=b4/L=2Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA0DC2D0C2
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 18:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1F8822522
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Jan 2020 18:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPPTYENc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgACSaA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 13:30:00 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39131 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgACSaA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 13:30:00 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so62130695oty.6;
        Fri, 03 Jan 2020 10:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hWRnOA5j7TseJvSe/ETtAVkvfSvMWabJgIKJTm5gz7k=;
        b=YPPTYENcRdLkPJ9LO9WVZTX/KWRCyTUs5+hcs0GC99dpcKhX79Ihgoe+DvyJW2QcLX
         58LTRYpZTadC8jj4xcDjIWzx4Tr5MnkKfcUlExf5xnwGmuv0Bu/8PRs7cQvD8bvrTbRg
         79obVjx/KLSkMxsbrCbHp6N/FOQ+BYIrxyOscRxLaE2nc2rxJLrgD+/2XauwIh9Dbycr
         U1p2iDlJW+tr9TLpFKAlyW4cGuMGK2Z2sQ3feK7aDgcpbyo6s07f6//8G0zAHGAHGdQ+
         BMKw/UEfH/e4djxR1Yq9uvO2/XMU/UHyeYI/18xX0bEWoGj8qjmlp/JmHBgrPZZYvobX
         bEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hWRnOA5j7TseJvSe/ETtAVkvfSvMWabJgIKJTm5gz7k=;
        b=U3qpymYpaPsoJ5U/beCmxlVRh4wowjSnmM84LvbimiuoMhtOpthZr2Swy84v1v1FvK
         M/FMoDd1AWkBqEXQrmLApNuVyNxovz2w/UQBmRtglLElm4o8f9vcXDAj1YhUfepYOe5U
         nr6VGqSlmNVXSjnMYZUgbTFyxumaAoLZ6XjuFoTd//l/vnUfT5wX34OL7E7QrI+XIbTF
         ej8xkV72ujjnl69HVt4Qm1vTQlGYz2q4tkzEfyCDAYotnE3dcvtYlOYzrwlWwjbCtBci
         AnbBnnJfDustZazSOwnsiDd07g8w73Tmc6O0faA2UN4/IuZ8Mzfkseb0JwmWd/gXIl8u
         oepQ==
X-Gm-Message-State: APjAAAXAsSaS+KP8IaJnjd/weejOD//kY2uGoDoA504aOzQe3SyvNrCB
        JmAxQ6Tg7mQdBPq6JM0OXN2M2uBZ6BSSfDqfYkdLuTnU
X-Google-Smtp-Source: APXvYqyfBRJaMpOt5wFUB98mnddWhdvb0BAS7MofWiaqwMMXNQ497wo1MzrJLJ+x6DZB4QCUsoECL1ufMuDJJE12N1I=
X-Received: by 2002:a9d:3f61:: with SMTP id m88mr81555508otc.56.1578076199332;
 Fri, 03 Jan 2020 10:29:59 -0800 (PST)
MIME-Version: 1.0
References: <20200102122004.216c85da@gandalf.local.home> <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home> <20200103133640.GD9715@krava>
In-Reply-To: <20200103133640.GD9715@krava>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 3 Jan 2020 18:29:23 +0000
Message-ID: <CADVatmO7xZL2ddQOKoB6OVLZ4SRevd=0Tr5rQ=go5J9qZvD9Rg@mail.gmail.com>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being in
 the Linux kernel source?
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jan 3, 2020 at 1:36 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jan 02, 2020 at 06:58:53PM -0500, Steven Rostedt wrote:
> > On Fri, 3 Jan 2020 00:49:50 +0100
> > Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > > > Should we move libtraceevent into a stand alone git repo (on
> > > > kernel.org), that can have tags and branches specifically for it? We
> > > > can keep a copy in the Linux source tree for perf to use till it
> > >
> > > so libbpf 'moved' for this reason to github repo,
> > > but keeping the kernel as the true/first source,
> > > and updating github repo when release is ready
> > >
> > > libbpf github repo is then source for fedora (and others)
> > > package
> >
> > Ah, so perhaps I should follow this? I could keep it a kernel.org repo
> > (as I rather have it there anyway).
>
> sounds good, and if it works out, we'll follow you with libperf :-)
>
> if you want to check on the libbpf:
>   https://github.com/libbpf/libbpf

fwiw, I have opened a bug report in Debian requesting to package
libbpf from the github repo.

-- 
Regards
Sudip
