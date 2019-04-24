Return-Path: <SRS0=a8si=S2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B06CC10F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Apr 2019 13:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01EBF21773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Apr 2019 13:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfDXNhE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:37:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbfDXNhE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 09:37:04 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2B4E930BCE5B;
        Wed, 24 Apr 2019 13:36:59 +0000 (UTC)
Received: from sandy.ghostprotocols.net (ovpn-112-22.phx2.redhat.com [10.3.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34E3D1001E71;
        Wed, 24 Apr 2019 13:36:56 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id 53E5C62CF; Wed, 24 Apr 2019 10:37:01 -0300 (BRT)
Date:   Wed, 24 Apr 2019 10:37:01 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent: Remove hardcoded install paths
 from pkg-config file
Message-ID: <20190424133701.GE4339@redhat.com>
References: <20190418211556.5a12adc3@oasis.local.home>
 <20190424084722.5b98212e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424084722.5b98212e@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 24 Apr 2019 13:37:04 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Wed, Apr 24, 2019 at 08:47:22AM -0400, Steven Rostedt escreveu:
> 
> Hi Arnaldo,
> 
> Just making sure this doesn't get lost in the noise ;-)
> 
> Can you pull this in?

Its already in my local repo, that I just pushed out, thanks!

- Arnaldo

 
> -- Steve
> 
> 
> On Thu, 18 Apr 2019 21:15:56 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > 
> > Install directories of header and library files are hardcoded in pkg-config
> > templete file. They must be configurable, the Makefile should set them on the
> > compilation / install stage.
> > 
> > Link: http://lkml.kernel.org/r/20190329144546.5819-1-tstoyanov@vmware.com
> > 
> > Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> >  tools/lib/traceevent/Makefile                  | 13 +++++++++----
> >  tools/lib/traceevent/libtraceevent.pc.template |  4 ++--
> >  2 files changed, 11 insertions(+), 6 deletions(-)
> > 
> > diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> > index 941761d9923d..34cf33a4f001 100644
> > --- a/tools/lib/traceevent/Makefile
> > +++ b/tools/lib/traceevent/Makefile
> > @@ -50,6 +50,9 @@ man_dir = $(prefix)/share/man
> >  man_dir_SQ = '$(subst ','\'',$(man_dir))'
> >  pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
> >  			--variable pc_path pkg-config | tr ":" " "))
> > +includedir_relative = traceevent
> > +includedir = $(prefix)/include/$(includedir_relative)
> > +includedir_SQ = '$(subst ','\'',$(includedir))'
> >  
> >  export man_dir man_dir_SQ INSTALL
> >  export DESTDIR DESTDIR_SQ
> > @@ -279,6 +282,8 @@ define do_install_pkgconfig_file
> >  		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
> >  		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
> >  		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
> > +		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
> > +		sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
> >  		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
> >  	else 									\
> >  		(echo Failed to locate pkg-config directory) 1>&2;		\
> > @@ -300,10 +305,10 @@ install_pkgconfig:
> >  
> >  install_headers:
> >  	$(call QUIET_INSTALL, headers) \
> > -		$(call do_install,event-parse.h,$(prefix)/include/traceevent,644); \
> > -		$(call do_install,event-utils.h,$(prefix)/include/traceevent,644); \
> > -		$(call do_install,trace-seq.h,$(prefix)/include/traceevent,644); \
> > -		$(call do_install,kbuffer.h,$(prefix)/include/traceevent,644)
> > +		$(call do_install,event-parse.h,$(DESTDIR)$(includedir_SQ),644); \
> > +		$(call do_install,event-utils.h,$(DESTDIR)$(includedir_SQ),644); \
> > +		$(call do_install,trace-seq.h,$(DESTDIR)$(includedir_SQ),644); \
> > +		$(call do_install,kbuffer.h,$(DESTDIR)$(includedir_SQ),644)
> >  
> >  install: install_lib
> >  
> > diff --git a/tools/lib/traceevent/libtraceevent.pc.template b/tools/lib/traceevent/libtraceevent.pc.template
> > index 42e4d6cb6b9e..86384fcd57f1 100644
> > --- a/tools/lib/traceevent/libtraceevent.pc.template
> > +++ b/tools/lib/traceevent/libtraceevent.pc.template
> > @@ -1,6 +1,6 @@
> >  prefix=INSTALL_PREFIX
> > -libdir=${prefix}/lib64
> > -includedir=${prefix}/include/traceevent
> > +libdir=LIB_DIR
> > +includedir=HEADER_DIR
> >  
> >  Name: libtraceevent
> >  URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
