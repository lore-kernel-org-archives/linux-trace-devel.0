Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319D3C433FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B2142171F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406945AbfHIN7K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 09:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHIN7K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 09:59:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69292214C6;
        Fri,  9 Aug 2019 13:59:09 +0000 (UTC)
Date:   Fri, 9 Aug 2019 09:59:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/7] trace-cmd: Move trace-output.c into the library
 code
Message-ID: <20190809095907.429e47b5@gandalf.local.home>
In-Reply-To: <CACqStocrJeq70HKFbb_epyQMV1xdtaJ2ywm77uf5ht22KAp0cw@mail.gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
        <20190711130307.25041-2-tz.stoyanov@gmail.com>
        <20190808193755.346da18f@gandalf.local.home>
        <CACqStocrJeq70HKFbb_epyQMV1xdtaJ2ywm77uf5ht22KAp0cw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 9 Aug 2019 13:22:29 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> > > +$(TC_VERSION): force | $(bdir)/include
> > > +     $(Q)$(call update_version.h)
> > > +  
> >
> > Hi Ceco,
> >
> > Why the addition of TC_VERISON here? It's not stated in the change log
> > to why this was copied over. I ever removed all references from
> > TC_VERSION and it still builds fine.
> >
> > -- Steve
> >  
> There is a dependency: trace-output.c includes version.h, which
> includes tc_version.h.
> When trace-output.c is moved to the lib/trace-cmd directory, it
> includes tc_version.h from
> lib/trace-cmd/include. It makes sense, otherwise the libtracecmd will
> depend on the trace-cmd
> application. That's why I duplicated that TC_VERISON logic in
> lib/trace-cmd/Makefile. It
> forces lib/trace-cmd/include/tc_version.h to be generated on every
> libtracecmd build.

Yeah, we can't have that.

> Now we have two auto generated files:
>     lib/trace-cmd/include/tc_version.h
>     tracecmd/include/tc_version.h
> 
> May be we should move tc_version.h to be generated in include/, so we
> can use the same file from
> both the application and the library ?

I looked at why we have version.h there, and it's to get
FILE_VERSION_STRING, which is only used in trace-output.c.

And this is created via the Makefile. Hmm, we may need to move all the
file version logic into lib/trace-event as the only files that should
ever care about this is trace-output.c and trace-input.c, which are
both in the lib/trace-event (not something trace-cmd should worry
about).

-- Steve


> 
> >  
> > >  $(bdir)/libtracecmd.a: $(OBJS)
> > >       $(Q)$(call do_build_static_lib)
> > >
> > > @@ -43,6 +49,8 @@ $(bdir)/trace-util.o: $(obj)/plugins/trace_plugin_dir
> > >  $(DEPS): $(bdir)/.%.d: %.c
> > >       $(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
> > >
> > > +$(DEPS): $(TC_VERSION)
> > > +
> > >  $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
> > >
> > >  dep_includes := $(wildcard $(DEPS))
> > > @@ -54,4 +62,5 @@ endif
> > >  clean:
> > >       $(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
> > >
> > > +force:
> > >  .PHONY: clean
> > > diff --git a/tracecmd/trace-output.c b/lib/trace-cmd/trace-output.c
> > > similarity index 100%
> > > rename from tracecmd/trace-output.c
> > > rename to lib/trace-cmd/trace-output.c
> > > diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> > > index bcd437a..6968f83 100644
> > > --- a/tracecmd/Makefile
> > > +++ b/tracecmd/Makefile
> > > @@ -29,7 +29,6 @@ TRACE_CMD_OBJS += trace-restore.o
> > >  TRACE_CMD_OBJS += trace-check-events.o
> > >  TRACE_CMD_OBJS += trace-show.o
> > >  TRACE_CMD_OBJS += trace-list.o
> > > -TRACE_CMD_OBJS += trace-output.o
> > >  TRACE_CMD_OBJS += trace-usage.o
> > >  TRACE_CMD_OBJS += trace-msg.o
> > >  
> >  
> 
> 

