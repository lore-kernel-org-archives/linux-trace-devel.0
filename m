Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974C2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 00:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiKJAnP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKJAnO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 19:43:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32AE1A074
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 16:43:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C96861D2D
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 00:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46E7C433D7;
        Thu, 10 Nov 2022 00:43:12 +0000 (UTC)
Date:   Wed, 9 Nov 2022 19:43:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Bergin <peter@berginkonsult.se>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: make it possible to set libdir and
 mandir from outside
Message-ID: <20221109194310.19a76ee2@rorschach.local.home>
In-Reply-To: <ed05620a-7ce2-cd8b-320f-9a07019758d2@berginkonsult.se>
References: <20221031212140.170601-1-peter@berginkonsult.se>
        <ed05620a-7ce2-cd8b-320f-9a07019758d2@berginkonsult.se>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 1 Nov 2022 12:15:21 +0100
Peter Bergin <peter@berginkonsult.se> wrote:

> On 2022-10-31 22:21, Peter Bergin wrote:
> > When building in build frameworks such as openembedded it is desired
> > to use the defintion of libdir and mandir from the build framework.
> >
> > Signed-off-by: Peter Bergin <peter@berginkonsult.se>
> > ---
> >   Makefile | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index fab8f7e..e974117 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -46,8 +46,8 @@ endif
> >   
> >   libdir_relative ?= $(libdir_relative_temp)
> >   prefix ?= /usr/local
> > -libdir = $(prefix)/$(libdir_relative)
> > -man_dir = $(prefix)/share/man
> > +libdir ?= $(prefix)/$(libdir_relative)
> > +man_dir ?= $(prefix)/share/man
> >   man_dir_SQ = '$(subst ','\'',$(man_dir))'
> >   pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
> >   			--variable pc_path pkg-config | tr ":" " "))  
> 
> This patch has been superseded by a v2 patch because I did a mistake and 
> wrote the wrong prefix. Reference to new patch: 
> https://lore.kernel.org/linux-trace-devel/20221101111143.191772-1-peter@berginkonsult.se/

This one applies to libtraceevent,  I think you meant to reply to:

  https://lore.kernel.org/all/20221031212110.170564-1-peter@berginkonsult.se/

-- Steve
