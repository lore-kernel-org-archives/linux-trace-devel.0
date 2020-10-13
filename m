Return-Path: <SRS0=fnsP=DU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D60C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 03:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38D720757
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 03:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnflr+Mh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgJMDG3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 23:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgJMDG3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 23:06:29 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72D5C0613D0;
        Mon, 12 Oct 2020 20:06:28 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id s21so3133104oij.0;
        Mon, 12 Oct 2020 20:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2p+UZtd3EFo8/sBOuNY7TWjfbIAZOEEXRJrM4P9L00I=;
        b=dnflr+MhAc4IsKrrDe8uf07n1jCKkqoVIaUu+CCuUhuyPutsEdyFKGItI/GMkbUnWX
         hxnWamWf0x1l3UZzFbrvTkyL++IS1R31dQAXlEPpeWgtUEsiCBdHPnssoX0Oz/wHMmFz
         yul80KmwgNkkbbijiRT4FvW/xwGU2LHaF3BfEJKyrjVx2kihZcNtSdbWJVTl5gOIVk4O
         7wcqXPaoGsYGnWbD677UYO9xHxHDZuO77jIJ6+gHENcwlFxy7FIhtILy1shQxrUGLV6H
         PcPP+PeLI4HiA05BxwFEw4lZfWo94yprafjbFGyOKeGp3nKL9jia1kxIv6jjfEx4gBEk
         0owQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2p+UZtd3EFo8/sBOuNY7TWjfbIAZOEEXRJrM4P9L00I=;
        b=sMwquhKdEmHJdiBF4E+HSJ6HjHn6fZymx4D0RsDTcO+ynMZy00HEu8ZC1E5QdNQ+C+
         iC+ET4hnr3kSJBaZ58lxCmwX4JvXVvGzS37Ibdxobtovm5+b2Yp+BDa/AqG5Ks8L8R44
         IDBkY1QuyCPiIt68vUu2gZ4to6VkCRf73Id1bqALyTDspykSyHbspdtIdPOoH3e2w4AW
         9BwtJUwcuBWh7jWkML7UxmKTzLGqnj4CvP3DUi44idmNikdSimM09Cw5Gtc/6+iBmPdy
         auxpI+/ETApbTIEzLUkYo/C8QVAmy6JbFQD7akxN4Og4udxuc+CT3ZorvbplH6jYG/oE
         jDbw==
X-Gm-Message-State: AOAM533sNxb5tYdwXdnZAzGkol8qBqjvlT/9EDOjjOYQ6OA+fBKhWaCk
        c1HzFA0VWRXMaEbE6vHgehC9zCecxbnimO5QNTo=
X-Google-Smtp-Source: ABdhPJwA5dtZbOQCV3Imj4/bG2XPznKdO3jYQlz3rJI9QP9b5307JktJzwpoUvVbNzimhjZ8OKojtCFFNqjguDjvAoc=
X-Received: by 2002:aca:1e09:: with SMTP id m9mr5325150oic.60.1602558388120;
 Mon, 12 Oct 2020 20:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <20201007130750.49349844@gandalf.local.home> <20201012101208.GF1099489@krava>
 <20201012111950.55a73588@gandalf.local.home> <20201012184120.GN13697@suse.de> <20201012151732.6e439886@gandalf.local.home>
In-Reply-To: <20201012151732.6e439886@gandalf.local.home>
From:   Zamir SUN <sztsian@gmail.com>
Date:   Tue, 13 Oct 2020 11:06:16 +0800
Message-ID: <CAHnb8o61XwvgkMnryaOv-=qCDf-o5OpezQAAk-44R+KgCc8Vcw@mail.gmail.com>
Subject: Re: [ANNOUNCE] libtraceevent.git
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tony Jones <tonyj@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Oct 13, 2020 at 3:17 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> [ Removing the powertop mailing list because it's rejecting everything ]
>
> On Mon, 12 Oct 2020 11:41:20 -0700
> Tony Jones <tonyj@suse.de> wrote:
>
> > On Mon, Oct 12, 2020 at 11:19:50AM -0400, Steven Rostedt wrote:
> >
> > > Once it's shown that it works for all the package maintainers, I will tag
> > > it which should create the tarballs automatically on the above link.
> >
> > Hi.
> >
> > It builds fine for me after manually creating the tarball from git.
> > Once there is an official versioned tarball I'll push it into
> > openSUSE.
> >
> > I presume some perf Makefile changes will be forthcoming to use it,
> > rather than continuing to force build it out of TRACE_EVENT_DIR
> >
>
> Zamir found this issue with the Documentation man pages:
>
> Note, I'm not sure the proper way to fix this. I think this is the last
> issue I need to resolve before making the tag.
>

If anyone interested in, the discussion of this document compiling is
in the thread "libtraceevent: make doc-install tries different file
names than generated".

With the patch Steve mentioned, I can package this in RPM already. And
it's pending review in Fedora now.
https://bugzilla.redhat.com/show_bug.cgi?id=1887470

So, for me, there is no more issue for Fedora packaging.

Thanks.
