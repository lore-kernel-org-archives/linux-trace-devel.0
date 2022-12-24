Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB33CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 24 Dec 2022 17:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiLXR2Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 12:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLXR2Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 12:28:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D43959B
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 09:28:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E14F160302
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 17:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF75EC433D2;
        Sat, 24 Dec 2022 17:28:21 +0000 (UTC)
Date:   Sat, 24 Dec 2022 12:28:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221224122819.28b0876b@gandalf.local.home>
In-Reply-To: <20221224103650.qpz3hqlkgvkexq6h@carbon.lan>
References: <20221221170844.10977-1-dwagner@suse.de>
        <20221221170844.10977-3-dwagner@suse.de>
        <20221223000338.19bacc93@rorschach.local.home>
        <20221223073243.bjjstqyueyseluic@carbon.lan>
        <20221223120851.5c3ad824@gandalf.local.home>
        <20221224103650.qpz3hqlkgvkexq6h@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 24 Dec 2022 11:36:50 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> On Fri, Dec 23, 2022 at 12:08:51PM -0500, Steven Rostedt wrote:
> > On Fri, 23 Dec 2022 08:32:43 +0100
> > Daniel Wagner <dwagner@suse.de> wrote:
> >   
> > > > And since this holds libtracecmd, does it really need a dependency?    
> > > 
> > > IIRC, I saw that the CFLAGS from libtraceevent are used for the
> > > trace-cmd, but I might just miss something. If trace-cmd doesn't use
> > > libtraceevent or libtracefs directly than it should be possible to drop
> > > these direct dependencies.  
> > 
> > No, I believe that trace-cmd still uses libtracefs and libtraceevent
> > directly.  
> 
> I did try to build without listing the direct dependency, the build
> failed because the compiler didn't find the libraries header files. I
> think we need to leave them. Though with the current approach to trigger
> the static libtraceevent directly from trace-cmd we need it those anyway.

Just to clarify, I wasn't talking about the libtracefs/event libraries. I
was talking about the libtracecmd library that was listed as a dependency.
Why do we need to check the version of that, as we are going to be using
the one in the repo regardless?

Also, how do you install the libraries? When I do a

  ninja -C build install

it only installs the trace-cmd executable.

-- Steve
