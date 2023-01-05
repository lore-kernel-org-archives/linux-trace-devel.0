Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545E2C3DA7D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 13:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjAENyy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 08:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbjAENyW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 08:54:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E1860CFE
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 05:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A57C2B81AE6
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 13:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361BFC433D2;
        Thu,  5 Jan 2023 13:51:04 +0000 (UTC)
Date:   Thu, 5 Jan 2023 08:51:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtracefs: Add initial support for meson
Message-ID: <20230105085102.0a9c464b@gandalf.local.home>
In-Reply-To: <20230105071851.24okzoqun6ednbmr@carbon.lan>
References: <20221228082927.3499-1-dwagner@suse.de>
        <20230104110916.4f652a96@gandalf.local.home>
        <20230104171939.huntmzkbpy5tvrjg@carbon.lan>
        <20230104124414.727545d4@gandalf.local.home>
        <20230105071851.24okzoqun6ednbmr@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 5 Jan 2023 08:18:51 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> On Wed, Jan 04, 2023 at 12:44:14PM -0500, Steven Rostedt wrote:
> > On Wed, 4 Jan 2023 18:19:39 +0100
> > Daniel Wagner <dwagner@suse.de> wrote:
>  > setup. Basically with  
> > > 
> > > 
> > >   'meson setup .build --wrap-mode=forcefallback'
> > > 
> > > in trace-cmd meson would download, setup and build libtraceevent and libtracefs
> > > within the trace-cmd build. This is makes the whole development process
> > > between these project way smoother. And if you would configure the build
> > > with  
> > 
> > I'm not sure that would make it easier for me. I work on each separately.
> > And I don't always want them linked together, but sometimes I do!  
> 
> Meson doesn't force you here how you prefer you workflow. If you want to
> stick with your development steps all should be fine. I just recommend to give
> those subproject a try. IMO it makes things simpler, e.g. building all code in
> debug mode and being able to single step through is nice. And if you find a bug
> or want to change a line in the libraries, just change the line recompile the
> main project and that's all. No installing or fiddling with some $PATHs. All works
> out of the box.

I get that now with my current setup. I only install with debug options,
and use gdb in emacs. It walks through the library code, and will go into
different paths automatically. I only need to install the code I change
(sure, I need to go into that path to do so). But as I've been using
libtracefs and libtraceevent for other tooling, I really don't want it part
of the trace-cmd repo, or in the build path.

> 
> > For the environment that we require a static build, that isn't really
> > needed. It would only make the initial setup easier, but that's a one time
> > deal. After that, everything is automated.  
> 
> Before you spend too much time in writing scripts aroudn Meson, you should
> really have a look at subproject. You get the dependencies management for little
> costs.

The above mentioned static environment build is done via portage.

-- Steve
