Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2E1C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63255206DA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:55:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMZWMJ2W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbfLLRzi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:55:38 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:34131 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730216AbfLLRzi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 12:55:38 -0500
Received: by mail-ua1-f65.google.com with SMTP id w20so1281407uap.1;
        Thu, 12 Dec 2019 09:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2PL1W7x5Z3JdqFnpKW9K3ZxcFoDhA0Dzv5FYcB/mlfs=;
        b=IMZWMJ2WHAJekhPfCyWSQK4lxPzoM08gtrG2KYsM+54rJnsOqa/+Euz080SWf1FnrH
         ioO/Derd8qxIuD2s5on0yfU7m/h5rdRtTybgXpFgJmAniEzPm2S6EPVcHrlQyXoJccIT
         eiFkjzYsv8V3Fl+n6mqbmcGkevMjZiQyG5WjFc91RdZr6EG8w3TJNxugsGQ9ORjRPG98
         RAkRReQfsOGsNr4DNQnEhktFBEZoMWz4ec+gtR9FGLhIrc71xk1FPI056R+DKC+4gsdA
         eE5z7jWiAf0OYMgI9Tu2rzWCgW8lfICZIv3NlcUPyIwCcaW6WqGAbhbb2cJSt+gGkiDa
         WDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2PL1W7x5Z3JdqFnpKW9K3ZxcFoDhA0Dzv5FYcB/mlfs=;
        b=XpRWStxhPs/ldaFAYvnB+pe9jfywBKIbSJig5178gjUFn7pnLSIqzGkgi9fDs6kGjO
         Y6peu4YvKozeU6vCVia7ZuCtWTl4jxP6NZccuP/RerhAN49G3vCt5BO+AVrjBAlKYr3H
         1ryTEJgLhzvZgJdzCxPNHTpyrvTXhs36A36q280oGpJuJ4s0AkTUdJapENUO9Tif/loO
         bf2egkHtXlqn4CSAZ40O7ZLm9B4bEHBn6zJFykkTDBuvptxwDoeUpA3a/O3LH6treyNQ
         EhVh3kolm0QTl2lZxePoYPlfd0IdJtpAdAoaBlz+6Af3vXz7QVf8qetn72BN4lrwIwDJ
         Py7A==
X-Gm-Message-State: APjAAAVToQMQLs4Ei05m7uq3R95QMA4GaO66718otStfEXRHOVRlqUv3
        mTA84vj434fPhM20VSocwnYxdPfT
X-Google-Smtp-Source: APXvYqwa5i+J2tmfe5HC8wshUSotezwbNelSP43N7xrarKSYMAwJcVY4/+7AsM+XiNaKNca8UyX79g==
X-Received: by 2002:ab0:6418:: with SMTP id x24mr9636621uao.40.1576173336768;
        Thu, 12 Dec 2019 09:55:36 -0800 (PST)
Received: from quaco.ghostprotocols.net ([177.195.210.207])
        by smtp.gmail.com with ESMTPSA id u16sm4094734vkl.21.2019.12.12.09.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 09:55:36 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id E12FF40352; Thu, 12 Dec 2019 14:55:31 -0300 (-03)
Date:   Thu, 12 Dec 2019 14:55:31 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        arnaldo.melo@gmail.com, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: allow custom libdir path
Message-ID: <20191212175531.GG13965@kernel.org>
References: <20191207111440.6574-1-sudipm.mukherjee@gmail.com>
 <20191212111900.3f46e033@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212111900.3f46e033@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Dec 12, 2019 at 11:19:00AM -0500, Steven Rostedt escreveu:
> 
> Arnaldo,
> 
> Can you pull this patch in?
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Sure, applied.

- Arnaldo
 
> -- Steve
> 
> 
> On Sat,  7 Dec 2019 11:14:40 +0000
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> 
> > When I use prefix=/usr and try to install libtraceevent in my laptop it
> > tries to install in /usr/lib64. I am not having any folder as /usr/lib64
> > and also the debian policy doesnot allow installing in /usr/lib64. It
> > should be in /usr/lib/x86_64-linux-gnu/.
> > 
> > Quote: No package for a 64 bit architecture may install files in
> > 	/usr/lib64/ or in a subdirectory of it.
> > ref: https://www.debian.org/doc/debian-policy/ch-opersys.html
> > 
> > Make it more flexible by allowing to mention libdir_relative while
> > installing so that distros can mention the path according to their policy
> > or use the default one.
> > 
> > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > ---
> > 
> > Hi Steve,
> > 
> > And yet another one (hopefully the final one for now). I know I missed
> > the merge window, but your Ack should be ok.
> > 
> >  tools/lib/traceevent/Makefile         | 5 +++--
> >  tools/lib/traceevent/plugins/Makefile | 5 +++--
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> > index c5a03356a999..7e2450ddd7e1 100644
> > --- a/tools/lib/traceevent/Makefile
> > +++ b/tools/lib/traceevent/Makefile
> > @@ -39,11 +39,12 @@ DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
> >  
> >  LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
> >  ifeq ($(LP64), 1)
> > -  libdir_relative = lib64
> > +  libdir_relative_temp = lib64
> >  else
> > -  libdir_relative = lib
> > +  libdir_relative_temp = lib
> >  endif
> >  
> > +libdir_relative ?= $(libdir_relative_temp)
> >  prefix ?= /usr/local
> >  libdir = $(prefix)/$(libdir_relative)
> >  man_dir = $(prefix)/share/man
> > diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
> > index f440989fa55e..edb046151305 100644
> > --- a/tools/lib/traceevent/plugins/Makefile
> > +++ b/tools/lib/traceevent/plugins/Makefile
> > @@ -32,11 +32,12 @@ DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
> >  
> >  LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
> >  ifeq ($(LP64), 1)
> > -  libdir_relative = lib64
> > +  libdir_relative_tmp = lib64
> >  else
> > -  libdir_relative = lib
> > +  libdir_relative_tmp = lib
> >  endif
> >  
> > +libdir_relative ?= $(libdir_relative_tmp)
> >  prefix ?= /usr/local
> >  libdir = $(prefix)/$(libdir_relative)
> >  

-- 

- Arnaldo
