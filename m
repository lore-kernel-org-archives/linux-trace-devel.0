Return-Path: <SRS0=dLAM=ZC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E631EC43331
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 Nov 2019 00:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5EC208C3
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 Nov 2019 00:44:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klj75VtA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfKJAoU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 Nov 2019 19:44:20 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33301 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfKJAoU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 Nov 2019 19:44:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id a17so9362513wmb.0;
        Sat, 09 Nov 2019 16:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hxpVc6VloLtI21c23qGZC1El6cBTlpdM4jZz6yMTkmA=;
        b=klj75VtANyXUMxZErrb+Mrj6v8k+DtfwnCvpdajSa7kRe7jaiH6o6gMQsX9pS3gDy6
         i0HB/SHbrlpjZCS0bRAXKCLDoqcd+gXCTvS5zn/Ag1RkVgcfXjGlzRn8nI44Xw51J8HW
         dARN/2sPEW8/up0yAVe66llPjlu2f5I0XEnlr6zi738ichmXj/zgamVaCQAQ4xfK8spi
         1Uv8tBX4Kke00rVka2a9RHAfYDYuLtnXuhNn98UEYjyr3XpwDV/K/aW5CC6I9CUMyP+2
         5j0xp5iuYduQCTmUQ4hcVOOw6DvMTOnsVyzeIgs8e4PNs0qOpUlf9FSyBX5U/rQyQQJ4
         MWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hxpVc6VloLtI21c23qGZC1El6cBTlpdM4jZz6yMTkmA=;
        b=BbN2jxCsSdsyBCMqagtYl6x8vggGyD7wp0R9olvpej+CTRLeAnSkDgIo5KXD7cjduy
         NqxFacF+2dH0+l4nkT//Sh4BNwvZgIKKhFQSqv291V/2hUoVRYG5aYVck6tSoq1osDSo
         qYszmjrVzVe/j6xWja0E6uCoxtqiqFLbSDJMgIJF816Sc6rMq3SUs4z/e6I826y/P5xU
         eIun9VPiVePscnZ8I0fR8tD1sXZCIqmG1X7j3tHT9fS9iKxdp/F9e4WFPCL6C5cOlii3
         +n600T9rY1shEna942it5yeukNGiHXLytKODlTRI8T0GzhhBMdQelDo0CpUKIzEIWA1z
         VvEg==
X-Gm-Message-State: APjAAAU5qNn5rimAEswCb1+/HIGWBG0vOEdL9rvDkGbhD8MdsX5VeF6b
        lqP8S1Z56sM8OX683OpaR6bvfE4I
X-Google-Smtp-Source: APXvYqwCGkgs1w71x4U/Gfuc46BuGATIUbwMW2VpkWaVLv+PUFVhtG87xExa7Hyl1Tk7My+8JCmGcQ==
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr13941059wmh.20.1573346656935;
        Sat, 09 Nov 2019 16:44:16 -0800 (PST)
Received: from debian (host-78-144-219-162.as13285.net. [78.144.219.162])
        by smtp.gmail.com with ESMTPSA id l10sm18361739wrg.90.2019.11.09.16.44.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Nov 2019 16:44:15 -0800 (PST)
Date:   Sun, 10 Nov 2019 00:44:13 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent installing in wrong folder
Message-ID: <20191110004413.6pnyivofpjdvwj6b@debian>
References: <20191108161157.g5aadocnfvragqb2@debian>
 <20191108120548.4118879a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ldmoq22qh3rkwm2q"
Content-Disposition: inline
In-Reply-To: <20191108120548.4118879a@gandalf.local.home>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--ldmoq22qh3rkwm2q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 08, 2019 at 12:05:48PM -0500, Steven Rostedt wrote:
> 
> [ I also added linux-trace-devel, but it was good to Cc LKML too ]
> 
> On Fri, 8 Nov 2019 16:11:57 +0000
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> 
> > Hi Steve,
> > 
> > I tried to install libtraceevent. and I used the command:
> > "make DESTDIR=/home/sudip/test prefix=/usr install" from tool/lib/traceevent
> > 

<snip>

> > 
> > I am seeing two problems:
> > 1) It created another home/sudip/test folder inside /home/sudip/test and
> > the header files are installed in /home/sudip/test/home/sudip/test/usr/include folder.
> > They should have been in /home/sudip/test/usr/include.
> > 
> > 2) I used prefix=/usr but the 'pkgconfig' still went to /usr/local
> > 
> > Did I do something wrong?
> 
> No, but you showed that the installation part is poorly tested. I
> mostly tested just the code from trace-cmd, and even the installation
> paths from that repo. I should have tested the kernel repo as well, but
> failed to do this.
> 
> Thanks for reporting, I need to take a look, or if you want to have a go
> at it, that would be great too :-)

Attached is a patch for the wrong installation of header files.
For the pkgconfig, the problem is at:
pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG)                 \
                        --variable pc_path pkg-config | tr ":" " "))

This is checking 'pc_path' which is the search path used by pkg-config
and then its taking the first path from that list and using in pkgconfig_dir,
which can be wrong.
A reliable way to get the pkg-config location is if I use:

pkg=$(pkg-config --list-all | head -1 | cut -d ' ' -f 1)
pkg-config --variable=pcfiledir $pkg

But I will need to see how I can use this in a Makefile, will send this
patch later, or if you can find a better way before me that will be great.

--
Regards
Sudip

--ldmoq22qh3rkwm2q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-libtraceevent-fix-header-installation.patch"

From 1ff159997d1dd299bb0e612baeb573aac45eac03 Mon Sep 17 00:00:00 2001
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sat, 9 Nov 2019 23:33:54 +0000
Subject: [PATCH] libtraceevent: fix header installation

When we passed some location in DESTDIR, install_headers called
do_install with DESTDIR as part of the second argument. But do_install
is again using '$(DESTDIR_SQ)$2', so as a result the headers were
installed in a location $DESTDIR/$DESTDIR. In my testing I passed
DESTDIR=/home/sudip/test and the headers were installed in:
/home/sudip/test/home/sudip/test/usr/include/traceevent.
Lets remove DESTDIR from the second argument of do_install so that the
headers are installed in the correct location.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 tools/lib/traceevent/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 5315f3787f8d..cbb429f55062 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -232,10 +232,10 @@ install_pkgconfig:
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-		$(call do_install,event-parse.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,event-utils.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,trace-seq.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,kbuffer.h,$(DESTDIR)$(includedir_SQ),644)
+		$(call do_install,event-parse.h,$(includedir_SQ),644); \
+		$(call do_install,event-utils.h,$(includedir_SQ),644); \
+		$(call do_install,trace-seq.h,$(includedir_SQ),644); \
+		$(call do_install,kbuffer.h,$(includedir_SQ),644)
 
 install: install_lib
 
-- 
2.11.0


--ldmoq22qh3rkwm2q--
