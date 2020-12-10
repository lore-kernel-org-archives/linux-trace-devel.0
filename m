Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D090C4361B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3611C22D74
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 14:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403786AbgLJOnk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 09:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403782AbgLJOnc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 09:43:32 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D71122065E;
        Thu, 10 Dec 2020 14:42:51 +0000 (UTC)
Date:   Thu, 10 Dec 2020 09:42:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Runge <dave@sleepmap.de>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 00/27] Start KernelShark v2 transformation
Message-ID: <20201210094250.49674c33@gandalf.local.home>
In-Reply-To: <X9Hgwhhc5hbhLsFV@hmbx>
References: <20201209134203.428068-1-y.karadz@gmail.com>
        <20201209213822.74c90f15@oasis.local.home>
        <X9Hgwhhc5hbhLsFV@hmbx>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 10 Dec 2020 09:48:02 +0100
David Runge <dave@sleepmap.de> wrote:

> On 2020-12-09 21:38:22 (-0500), Steven Rostedt wrote:
> > On Wed,  9 Dec 2020 15:41:36 +0200
> > "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> > I just realized that the current repo doesn't build against the latest
> > libtracefs, because the library's location has moved.  I noticed that
> > the CMake files have it hard coded with:
> > 
> >  find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
> >  find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
> > 
> > Is there a way to make cmake use pkg-config?
> > 
> > 	pkg-config --cflags --libs libtracefs
> > 
> > Will give us the correct includes and libraries for building against
> > libtracefs if installed.
> > 
> > We'll want the same for libtraceevent and libtracecmd as well.  
> 
> find_package() [1] is usually used for package discovery in cmake-land.
> If the NAMES argument is provided it overrides any provided package
> name.
> In more complex cases (of the package) it is better to have the
> package ship with a find_<PACKAGE>.cmake file that will be automatically
> used by cmake if it is installed in the system locations.
> 
> To use pkg-config/pkgconf directly, it is possible to make use of
> the FindPkgConfig [2] module.
> 

Yeah, that FindPkgConfig module looks like what we need.

> Best,
> David
> 
> P.S.: Out of context: Why is the cmake minimum requirement so low? To
> make use of useful features in cmake it needs to be at least 3.4, better
> higher even.

Note, I've never used cmake before Yordan introduced it to KernelShark. This
question is better answered by Yordan.

-- Steve


> 
> [1] https://cmake.org/cmake/help/latest/command/find_package.html#command:find_package
> [2] https://cmake.org/cmake/help/latest/module/FindPkgConfig.html
> 

