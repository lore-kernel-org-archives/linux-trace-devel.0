Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504AFC63797
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Feb 2023 20:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjBAUzc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Feb 2023 15:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBAUyz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Feb 2023 15:54:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC3266EF8
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Feb 2023 12:54:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C05B822B6
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Feb 2023 20:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E634C433D2;
        Wed,  1 Feb 2023 20:54:20 +0000 (UTC)
Date:   Wed, 1 Feb 2023 15:54:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] rtla: Fix cross building
Message-ID: <20230201155418.440399a3@gandalf.local.home>
In-Reply-To: <167528312574.2091069.14376812810556043323@localhost>
References: <20230120070809.6169-1-josch@mister-muffin.de>
        <20230201143144.37b258c2@gandalf.local.home>
        <167528312574.2091069.14376812810556043323@localhost>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 01 Feb 2023 21:25:25 +0100
Johannes Schauer Marin Rodrigues <josch@mister-muffin.de> wrote:

> Hi,
> 
> Quoting Steven Rostedt (2023-02-01 20:31:44)
> > On Fri, 20 Jan 2023 08:08:09 +0100
> > Johannes Schauer Marin Rodrigues <josch@mister-muffin.de> wrote:
> >   
> > > For a successful cross-build, the host-architecture version of
> > > pkg-config must be used or otherwise host architecture headers of
> > > libtracefs and libtraceevent will not be found.
> > > 
> > > Signed-off-by: Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
> > > ---
> > >  tools/tracing/rtla/Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
> > > index 22e28b76f800..26ebd46ec29c 100644
> > > --- a/tools/tracing/rtla/Makefile
> > > +++ b/tools/tracing/rtla/Makefile
> > > @@ -18,7 +18,7 @@ endef
> > >  $(call allow-override,CC,$(CROSS_COMPILE)gcc)
> > >  $(call allow-override,AR,$(CROSS_COMPILE)ar)
> > >  $(call allow-override,STRIP,$(CROSS_COMPILE)strip)
> > > -$(call allow-override,PKG_CONFIG,pkg-config)
> > > +$(call allow-override,PKG_CONFIG,$(CROSS_COMPILE)pkg-config)
> > >  $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
> > >  $(call allow-override,LDCONFIG,ldconfig)
> > >    
> > 
> > I don't usually have pkg-config as part of my cross build path. I have just
> > overridden it to use different commands, by defining the variable of
> > PKG_CONFIG, but I have not had any issues. But my compiler path never
> > included pkg-config.  
> 
> I found this problem when cross-compiling the linux Debian package. You can
> find a build log (on amd64 for arm64) of how this fails on our Debian
> crossbuild QA service:
> 
> https://crossqa.debian.net/build/linux_6.1.7-1_arm64_20230122165920.log
> 
> At the very bottom of that log you can see the following error message:
> 
> ********************************************
> ** NOTICE: Failed build dependencies
> **
> ** Required Libraries:
> **   libtraceevent version 1.5 or higher
> **   libtracefs version 1.3 or higher
> **
> ** Consider installing the latest libtracefs from your
> ** distribution, e.g., 'dnf install libtraceevent-devel libtracefs-devel' on Fedora,
> ** or from source:
> **
> **  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/ 
> **  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/ 
> **
> ********************************************
> 
> This error goes away after applying my patch. You can see that the both
> libraries do get installed for arm64 at the top of the log. But they are not
> found because the wrong pkg-config is used.
>

So it works for your Debian environment, but my fear is this change may
break other environments.

As I believe all you need to do is set the pkg-config environment
variables, and it will work with the normal path pkg-config.

With this change, that method will break if $(CROSS_COMPILE)pkg-config does
not exist.

I just installed linux-libc-dev-arm64-cross and I don't see pkg-config in
it. What package has that? And doing some searches, I see that those that
have $(CROSS_COMPILE)pkg-config was just adding a wrapper around the host
pkg-config that sets the proper pkg-config environment variables.

As I said, this may work for your environment, but it is likely to break
others.

Just add "PKG_CONFIG=${CROSS_COMPILE}pkg-config" before the "make" command,
and it should build properly.

-- Steve
