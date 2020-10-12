Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558A7C433E7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 15:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF682087E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 15:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r/LrAE+t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389673AbgJLPch (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 11:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389340AbgJLPch (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 11:32:37 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372F1C0613D0;
        Mon, 12 Oct 2020 08:32:37 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n142so13696003ybf.7;
        Mon, 12 Oct 2020 08:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+589eEK9RUMo5k3gXC7QGOAGtF0NXhGUz1kajGcrv8=;
        b=r/LrAE+tyr+DmwidynsfG+yaFi4t/NaYYBfmS+rwflbEohjyVSBYGzZDGRgxT08+3o
         WG5r6/o3xlQJUCv2xJR4vIWUF1mlztRTibRv/DCesnLy2J70g5Cu/my1ld4K2cCGo7F7
         vx7k3liNNv+j1rXwM/FUI3ujLhuactXGgUEWkVYXU+Y7VvERuiiXjCcLJ8Ho9ssc+i1H
         Vvw30gjghafsvVOqCgu+QaS/w1znUZFRKrF9MKqL+oQFEqpYaworLamOFfjDTcSXt66L
         edScY2F+o7eki16tHTb6NmnVuvCINlCnkXQTdj7roj6UNpgi5g/JahjSA0jwhgYDmOC3
         uDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+589eEK9RUMo5k3gXC7QGOAGtF0NXhGUz1kajGcrv8=;
        b=rcykRq/HloEi2uvj6fuRoKJQieP5kkponqMYyqufK1UmaLtEnA3ELSBkCAkwg5Jmck
         sO5uscUY8m/LJqO6HHueMqcgMUWXJMPM64S3alV89w6zjbxdnJKe8Xhia+ewm7AjNYeC
         +ecbrnWEq43l0gaROcON+W9WefXVBEaOmEBsLxot2lV1ndoE8/re9VME8EXa++hFwf39
         T5Ep/q2nX/FBxh207vgQbX4EmHQS0tISVxX9dg/zyLslqMScVzYOjsg0dcARs1c52H4D
         ZafDrAbow6UeTD3sjkE/76pxeTIaOFWmUqq36Lb6uSvSs9IcWhVpWr1FmBjZNfEklmZ7
         iY/A==
X-Gm-Message-State: AOAM530RYDJ1jxcDPcRN8oGq3GVJ8KIPgNcZHIcnzsKuqV7Ydjz7xmwh
        IliybYro73CEiHuGTClCPzlOqUcBp7Vcoh0OUxc=
X-Google-Smtp-Source: ABdhPJw+hAxQlG+1/PVLLrv2BqdonAWAW01tSmViwJtPemblj5lheDDRXhRaGUKmAcnUwd2TawkgwHIKxMz06yWWGQI=
X-Received: by 2002:a25:7405:: with SMTP id p5mr34323868ybc.19.1602516756470;
 Mon, 12 Oct 2020 08:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201007130750.49349844@gandalf.local.home> <20201012101208.GF1099489@krava>
 <20201012111950.55a73588@gandalf.local.home>
In-Reply-To: <20201012111950.55a73588@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 12 Oct 2020 16:32:00 +0100
Message-ID: <CADVatmP1iZdiWWqs-ZujAeXiCvYYJpNvoPt3K+GFfL5a6vyJGA@mail.gmail.com>
Subject: Re: [ANNOUNCE] libtraceevent.git
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        zsun@redhat.com, Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>, powertop@lists.01.org,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 4:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 12 Oct 2020 12:12:08 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
>
> > On Wed, Oct 07, 2020 at 01:07:50PM -0400, Steven Rostedt wrote:
> > > I split out tools/lib/traceevent from the kernel tree using "git subtree",
> > > which recreates all the commits of a directory and makes that directory a
> > > stand alone. I then updated the Makefiles, and copied over some of the
> > > header files used to build the library. I pushed this up to:
> > >
> > >   https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
> > >
> > > My hope is that this will now be the source of all updates to the
> > > libtraceevent library that can be used as a stand alone package that both
> > > perf and tracecmd can use. I would also like powertop and rasdaemon to use
> > > this as well.
> >
> > hi,
> > I'm adding this as fedora package, is there a source arhive somewhere
> > in git.kernel.org for libtraceevent that spec could download?
> >
>
> Hi Jiri!
>
> Once it's shown that it works for all the package maintainers, I will tag
> it which should create the tarballs automatically on the above link. But I
> wanted to fix all the packaging bugs before doing so. I hope this doesn't
> make it into a catch-22. Where you can't package till there's a source
> tarball, but I can't make a source tarball until I know you can package
> it ;-)

For Debian I have raised https://bugs.debian.org/971976 but I will
package it locally today just to check there is no packaging bugs for
our packaging.


-- 
Regards
Sudip
