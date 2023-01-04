Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B16C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjADRoT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjADRoS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:44:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C240513DCA
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:44:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59866616C3
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56232C433D2;
        Wed,  4 Jan 2023 17:44:16 +0000 (UTC)
Date:   Wed, 4 Jan 2023 12:44:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtracefs: Add initial support for meson
Message-ID: <20230104124414.727545d4@gandalf.local.home>
In-Reply-To: <20230104171939.huntmzkbpy5tvrjg@carbon.lan>
References: <20221228082927.3499-1-dwagner@suse.de>
        <20230104110916.4f652a96@gandalf.local.home>
        <20230104171939.huntmzkbpy5tvrjg@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 4 Jan 2023 18:19:39 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> On Wed, Jan 04, 2023 at 11:09:16AM -0500, Steven Rostedt wrote:
>  This also doesn't build the static library libtracefs.a.
> > 
> > We have environments that we need to build trace-cmd statically. As
> > trace-cmd depends on libtraceevent and libtracefs, that means both need a
> > static library as well.  
> 
> Configure the build with
> 
>   'meson setup .build --default-library=both'
> 
> Though, we could add libtraceevent and libracefs as subprojects to trace-cmd
> which avoids all the hassle to install libtraceevent and libtracefs
> independenly from trace-cmd. It also takes care of all the dependency
> setup. Basically with
> 
> 
>   'meson setup .build --wrap-mode=forcefallback'
> 
> in trace-cmd meson would download, setup and build libtraceevent and libtracefs
> within the trace-cmd build. This is makes the whole development process
> between these project way smoother. And if you would configure the build
> with

I'm not sure that would make it easier for me. I work on each separately.
And I don't always want them linked together, but sometimes I do! To
control what gets linked to trace-cmd, I use dynamic libraries, and only
install what I want to use there. That is, they really are three different
projects! I use libtracefs on several other tools, not just trace-cmd.

> 
>   'meson setup .build --wrap-mode=forcefallback --default-library=static'
> 
> would staticly link all subprojects into the trace-cmd binary.
> 
> I haven't added this part to the initial mesonizing of the projects. Keep
> things simple to begin with.

For the environment that we require a static build, that isn't really
needed. It would only make the initial setup easier, but that's a one time
deal. After that, everything is automated.

-- Steve
