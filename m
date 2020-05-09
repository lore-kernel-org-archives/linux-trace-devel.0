Return-Path: <SRS0=NeNm=6X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E55C28CBC
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 18:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4910A2184D
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 18:31:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arXAo75k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgEISbP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 May 2020 14:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727950AbgEISbP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 May 2020 14:31:15 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF92C061A0C
        for <linux-trace-devel@vger.kernel.org>; Sat,  9 May 2020 11:31:15 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id o7so11545809oif.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 09 May 2020 11:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JAbzWlApKtOt3HzPnvlQqMYP0K65HkhhFtTQU5OEcWQ=;
        b=arXAo75kjrIRxr+aL6SJaPwFCqcp0UKQGitQgDGjGiKbHy39eHNqpYOQhjR7d41i0X
         RqG2oWFotlB/onpGMJthLt5umJJ62w5NV844cwrptWQfwIokL12Cr6DcfYKEoBdSjwZT
         PoX8Ixkp3GrbcQR5/rLzlDvuxUCweS6bgHN1aZSs9idSLsAZpxffdIstk16ENlmBi4At
         nZaYK3hww7h/MBOfO33ZXriWdrXosHuIlWLS21//pB6Wu3zsez6cvN3i4+LRYReVZ+2d
         IA90N7w+hK9Gv7BL5VRy7Ea0szkIyD5zpCVPA5zke2TX0XkSv9kZMxIHTVKQM/rMTXEh
         OF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JAbzWlApKtOt3HzPnvlQqMYP0K65HkhhFtTQU5OEcWQ=;
        b=alnqituw/tcw2bGY42DRqCnxL/PsCKBG897Op0Ws6P1CezDsn6GjnQWhMr71X6OW4k
         aR5vCW7QNO+KgNk8Ks8F1jECzvgR3Fk9dgrijGopLYBHSwbus+FLoyzEfGfpi8T7NkMr
         KbSvsK8CXf4+1zN5L8X32pExkRdVTIpcNIw4NJecPB3jatmpbfAiH99fZEt0QxTQPOI8
         c69wDpC/WLy/mCD4NuClbMT0cYveXkPQ4bDp33T33XIIefVmOic4ZZfQGs85BosvLDgn
         qNjcGX86KLRPYt926f62dij/XGOPNRvb+PUtPNaueZbCt2mFNtrxJFZTId7LxYgQVxDH
         Oh0g==
X-Gm-Message-State: AGi0Pub6hMwE0ZRJoUDxIYKR/bZFuHrn74zEX/o57Xk3WE9uxu/hVac1
        EZHHqfcqpDBPQzDxRBtGenCanvK2ANCSvVgTS8Iu03FjU9Y=
X-Google-Smtp-Source: APiQypJuDABU9XvUD6+snSXGim6n3EKG32OZiRoNHc11Gs7xMrTbFTXpVgltL4DWi28d054hg5NnGvfdFxzTog1U8kw=
X-Received: by 2002:aca:c4d3:: with SMTP id u202mr14749652oif.113.1589049074496;
 Sat, 09 May 2020 11:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
 <20200420154325.6072d96b@gandalf.local.home> <20200420155320.55d3c3f2@gandalf.local.home>
 <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
 <CADVatmMaEd3jaT0UoGi2C2Xx7dNSaGmiaVcAk89SPCRAjEfGwg@mail.gmail.com> <20200508101134.1f957f0b@gandalf.local.home>
In-Reply-To: <20200508101134.1f957f0b@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sat, 9 May 2020 19:30:38 +0100
Message-ID: <CADVatmN=Z0ASVXUBTyAu6F_TWoWiKiKsgm404rOx7Oh-a6LiQg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 8, 2020 at 3:11 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 8 May 2020 13:46:19 +0100
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> > On Mon, Apr 20, 2020 at 11:37 PM Sudip Mukherjee
> > <sudipm.mukherjee@gmail.com> wrote:
> > >
> > > On Mon, Apr 20, 2020 at 8:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > >
> > > > On Mon, 20 Apr 2020 15:43:25 -0400
> > > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > >
> > > > > On Fri, 17 Apr 2020 21:39:14 +0100
> > > > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > > > >
> > > > > > The build fails while building with gcc-10 with the error:
> > > > > > multiple definition of `common_type_field'
> > > > >
> > > <snip>
> > > >
> > > > OK, I'll take this patch, and may even enable a -fno-common to find other
> > > > cases of this without having to wait till my distro adds gcc 10 by default.
> >
> > A gentle ping.
> >
>
> Thanks for the reminder, I haven't forgotten about it, just had other
> things added on top of my "todo" list.
>
> I'll go apply this now.

Thanks. And now kernelshark fails. :(

/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsGLWidget.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsGLWidget.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsDualMarker.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsDualMarker.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsTraceGraph.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsTraceGraph.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsTraceViewer.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsTraceViewer.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsMainWindow.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsMainWindow.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsQuickContextMenu.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/moc_KsQuickContextMenu.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsUtils.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsUtils.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsModels.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsModels.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsSession.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsSession.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsGLWidget.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsGLWidget.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsSearchFSM.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsSearchFSM.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsDualMarker.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsDualMarker.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsWidgetsLib.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsWidgetsLib.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsTraceGraph.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsTraceGraph.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsTraceViewer.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsTraceViewer.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsMainWindow.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsMainWindow.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsCaptureDialog.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsCaptureDialog.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsQuickContextMenu.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsQuickContextMenu.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsAdvFilteringDialog.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:43:
multiple definition of `stringWidth';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:43:
first defined here
/usr/bin/ld: CMakeFiles/kshark-gui.dir/KsAdvFilteringDialog.cpp.o:/build/trace-cmd/kernel-shark/src/KsUtils.hpp:35:
multiple definition of `fontHeight';
CMakeFiles/kshark-gui.dir/moc_KsUtils.cpp.o:/build/trace-cmd/kernel-shark/build/src/../../src/KsUtils.hpp:35:
first defined here



-- 
Regards
Sudip
