Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B3AC05027
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Feb 2023 20:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBAUZa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Feb 2023 15:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBAUZ3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Feb 2023 15:25:29 -0500
Received: from fulda116.server4you.de (mister-muffin.de [144.76.155.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 802E412F2F
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Feb 2023 12:25:27 -0800 (PST)
Received: from localhost (win7217.informatik.uni-wuerzburg.de [132.187.9.217])
        by mister-muffin.de (Postfix) with ESMTPSA id 4D8B5B8;
        Wed,  1 Feb 2023 21:25:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mister-muffin.de;
        s=mail; t=1675283126;
        bh=ckzGxYWBc+MddIX+k790YpnV+5i9wTDT09Gi6awwB+A=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=pi71F8aXuxCuHGIxX3RRKYQcXugI0votHUDLZ/1kePgVpiNQb2my33fj+hJ8VLHXz
         5xqaLGsBh4C7HF2LJYkaWGkH6fZOTq+8qlOWB8FvHGN/oQNLey9P8roI2wggZqv5cx
         0BSCrmt7TJ3EzTyaFcRxa+qV72AHgTsF3YOEqiSw=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230201143144.37b258c2@gandalf.local.home>
References: <20230120070809.6169-1-josch@mister-muffin.de> <20230201143144.37b258c2@gandalf.local.home>
Subject: Re: [PATCH] rtla: Fix cross building
From:   Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
Cc:     linux-trace-devel@vger.kernel.org
To:     Steven Rostedt <rostedt@goodmis.org>
Date:   Wed, 01 Feb 2023 21:25:25 +0100
Message-ID: <167528312574.2091069.14376812810556043323@localhost>
User-Agent: alot/0.10
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

Quoting Steven Rostedt (2023-02-01 20:31:44)
> On Fri, 20 Jan 2023 08:08:09 +0100
> Johannes Schauer Marin Rodrigues <josch@mister-muffin.de> wrote:
>=20
> > For a successful cross-build, the host-architecture version of
> > pkg-config must be used or otherwise host architecture headers of
> > libtracefs and libtraceevent will not be found.
> >=20
> > Signed-off-by: Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
> > ---
> >  tools/tracing/rtla/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
> > index 22e28b76f800..26ebd46ec29c 100644
> > --- a/tools/tracing/rtla/Makefile
> > +++ b/tools/tracing/rtla/Makefile
> > @@ -18,7 +18,7 @@ endef
> >  $(call allow-override,CC,$(CROSS_COMPILE)gcc)
> >  $(call allow-override,AR,$(CROSS_COMPILE)ar)
> >  $(call allow-override,STRIP,$(CROSS_COMPILE)strip)
> > -$(call allow-override,PKG_CONFIG,pkg-config)
> > +$(call allow-override,PKG_CONFIG,$(CROSS_COMPILE)pkg-config)
> >  $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
> >  $(call allow-override,LDCONFIG,ldconfig)
> > =20
>=20
> I don't usually have pkg-config as part of my cross build path. I have ju=
st
> overridden it to use different commands, by defining the variable of
> PKG_CONFIG, but I have not had any issues. But my compiler path never
> included pkg-config.

I found this problem when cross-compiling the linux Debian package. You can
find a build log (on amd64 for arm64) of how this fails on our Debian
crossbuild QA service:

https://crossqa.debian.net/build/linux_6.1.7-1_arm64_20230122165920.log

At the very bottom of that log you can see the following error message:

********************************************
** NOTICE: Failed build dependencies
**
** Required Libraries:
**   libtraceevent version 1.5 or higher
**   libtracefs version 1.3 or higher
**
** Consider installing the latest libtracefs from your
** distribution, e.g., 'dnf install libtraceevent-devel libtracefs-devel' o=
n Fedora,
** or from source:
**
**  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/=20
**  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/=20
**
********************************************

This error goes away after applying my patch. You can see that the both
libraries do get installed for arm64 at the top of the log. But they are not
found because the wrong pkg-config is used.

Thanks!

cheers, josch
