Return-Path: <SRS0=7UrD=DV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22022C433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 10:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A859721527
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 10:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uy+2Lvwr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgJNKJ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 06:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgJNKJ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 06:09:27 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F127AC061755;
        Wed, 14 Oct 2020 03:09:25 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id f140so781409ybg.3;
        Wed, 14 Oct 2020 03:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eX2L8AGuVZLL8p032i0z56kyEgMszaBhE7duOrFCdUk=;
        b=uy+2LvwrTG+RJWS4SWBdJb28YaFnaiQT76biXVW3X/AaQqCUy2IvVClj6CL4LgXi7x
         KUPzAuJewkx3hxKBJh656nVDGAmsdDXrK0U4ZRVhyb/Fc9UWUpkSpqD1PlorBlPTaqtm
         jt691Wg/BJ8TV82ZTtu1po//ViDws5EzYweOmL4QJLw+qv2+1OFu984oiGcYULSIga/x
         Q6Bfk73qEBl8Xl21sIFgZG80lJDEf4ndTxTngGVG+cyW213pX8IvE83vylJEYkvckITi
         QbrL8SWG+CVpIrNjC5//bhuRuzqPipZRysyYxnGB7INXVLzMv1sIKgpBh5RsMsNdoiZM
         dPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eX2L8AGuVZLL8p032i0z56kyEgMszaBhE7duOrFCdUk=;
        b=VTS+CRdARoEAamr2ObIwGJsjrFSmRJgSZx20Hp8TlPuwAXMWzvkiTMUEKhfwAbeVUs
         gUTq4X/PnZwdN1S0HnHWDPkMhJVyA0lEGYfIPoLILAADsLB7S4y4/GCxbGesg67AOlLy
         OGWxvEYGOBUH3bH9qDU/j7bjY4P77sXu8jNQ3+LHAHebzO6UXceplaM23cgiHFbjo3I5
         Ck4QhAtn6kiipevZiq6MF7+Mr/aL5YGywm/8jf0ke7G6ec/KTOwfMr3cbOxk1yVBkNal
         v64HaVRmtk4VQzRlhWIBiM3QCvdrMbQQAepjRpnOTFCclwlChGcRJXewynoOBNSatwsZ
         mgBw==
X-Gm-Message-State: AOAM532/5UZJ/Aq1zZRPdo3xnlFlNAyjFrfy7WQo+dm/9gvO7rYSfZkt
        2jnTGehJV17Z1sQTj3pghJgYyYqc8mQrZCWFcw4=
X-Google-Smtp-Source: ABdhPJwfnAHnLdGIb0oL/dRxOVNPRn1XqUb56BGyMVes6Nm1zO7vwRho3l2g2H39hrCGs012mRt/JdHxMG+7MugsrHo=
X-Received: by 2002:a25:2fc3:: with SMTP id v186mr5731532ybv.448.1602670164672;
 Wed, 14 Oct 2020 03:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201007130750.49349844@gandalf.local.home> <20201012101208.GF1099489@krava>
 <20201012111950.55a73588@gandalf.local.home> <20201012184120.GN13697@suse.de>
 <20201012151732.6e439886@gandalf.local.home> <CAHnb8o61XwvgkMnryaOv-=qCDf-o5OpezQAAk-44R+KgCc8Vcw@mail.gmail.com>
 <20201013090228.78256290@gandalf.local.home>
In-Reply-To: <20201013090228.78256290@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 14 Oct 2020 11:08:48 +0100
Message-ID: <CADVatmM2hsbZ64Zr=5KES-iPyoxicmm+zkvxTZMq49eWQ390yw@mail.gmail.com>
Subject: Re: [ANNOUNCE] libtraceevent.git
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Zamir SUN <sztsian@gmail.com>, Tony Jones <tonyj@suse.de>,
        Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Tue, Oct 13, 2020 at 2:02 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 13 Oct 2020 11:06:16 +0800
> Zamir SUN <sztsian@gmail.com> wrote:
>
> > On Tue, Oct 13, 2020 at 3:17 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
<snip>
> > So, for me, there is no more issue for Fedora packaging.
> >
>
> So should I just add that one patch and tag it?

Just a thought, if you see
https://repology.org/project/linux-tools/versions then you will notice
that libtracevent has been packaged by the distros with a version of
v5.x+, and I will have the same problem for Debian also. Do you think
it makes sense to start  with a version of v6.x when you tag it? If
that is not possible then we will have to use epoch like we did for
libbpf.


-- 
Regards
Sudip
