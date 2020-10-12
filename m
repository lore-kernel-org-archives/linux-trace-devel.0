Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ABDC433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 19:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C5A220BED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 19:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390896AbgJLTRh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 15:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730857AbgJLTRh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 15:17:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 216172074A;
        Mon, 12 Oct 2020 19:17:34 +0000 (UTC)
Date:   Mon, 12 Oct 2020 15:17:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tony Jones <tonyj@suse.de>
Cc:     Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        zsun@redhat.com, Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [ANNOUNCE] libtraceevent.git
Message-ID: <20201012151732.6e439886@gandalf.local.home>
In-Reply-To: <20201012184120.GN13697@suse.de>
References: <20201007130750.49349844@gandalf.local.home>
        <20201012101208.GF1099489@krava>
        <20201012111950.55a73588@gandalf.local.home>
        <20201012184120.GN13697@suse.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


[ Removing the powertop mailing list because it's rejecting everything ]

On Mon, 12 Oct 2020 11:41:20 -0700
Tony Jones <tonyj@suse.de> wrote:

> On Mon, Oct 12, 2020 at 11:19:50AM -0400, Steven Rostedt wrote:
> 
> > Once it's shown that it works for all the package maintainers, I will tag
> > it which should create the tarballs automatically on the above link.  
> 
> Hi.
> 
> It builds fine for me after manually creating the tarball from git.  
> Once there is an official versioned tarball I'll push it into
> openSUSE.
> 
> I presume some perf Makefile changes will be forthcoming to use it,
> rather than continuing to force build it out of TRACE_EVENT_DIR
> 

Zamir found this issue with the Documentation man pages:

Note, I'm not sure the proper way to fix this. I think this is the last
issue I need to resolve before making the tag.

-- Steve


On Thu, 8 Oct 2020 17:50:19 +0800
Zamir SUN <sztsian@gmail.com> wrote:

> Hi,
> 
> When I try to compiling the document of libtraceevent with the fix I 
> mentioned in [1] applied, make doc-install fails with errors like
> 
> "/usr/bin/install: cannot stat 'libtraceevent-record_parse.3': No such 
> file or directory"
> 
> Checking the compiled documents I see a lot of tep_*.3 generated, and 
> some libtraceevent_*.html. However no libtraceevent_*.3.
> 
> $ ls Documentation/*3 | head
> Documentation/libtraceevent.3
> Documentation/tep_alloc.3
> Documentation/tep_clear_flag.3
> Documentation/tep_cmdline_pid.3
> Documentation/tep_data_comm_from_pid.3
> Documentation/tep_data_flags.3
> Documentation/tep_data_pid.3
> Documentation/tep_data_pid_from_comm.3
> Documentation/tep_data_preempt_count.3
> Documentation/tep_data_type.3
> ls Documentation/*html | head
> Documentation/libtraceevent-commands.html
> Documentation/libtraceevent-cpus.html
> Documentation/libtraceevent-endian_read.html
> Documentation/libtraceevent-event_find.html
> Documentation/libtraceevent-event_get.html
> Documentation/libtraceevent-event_list.html
> Documentation/libtraceevent-event_print.html
> Documentation/libtraceevent-field_find.html
> Documentation/libtraceevent-field_get_val.html
> Documentation/libtraceevent-field_print.html
> 
> I also tried to port the Makefile from trace-cmd/Documentation to the 
> document dir, and it still only generates tep_*.3 files, so I feel this 
> is not the issue with the patch from [1].
> 
> As for my local environment, I have xmlto and asciidoc installed[2], but 
> not asciidoctor. I expect asciidoc could generate the documentations 
> like what it did in trace-cmd before.
> 
> Any idea if this is issue with my environment or it's something that 
> need to be implemented in the Makefile?
>  

Hi Zamir,

Thanks a lot for looking into this. I took your advice and reverted my
blind copy of the Makefiles, scripts and include headers, and instead
copied over their full history from the Linux kernel Tools directory.

You can see that update no (which now includes the utilities.mak as well).

Can you see if this patch fixes your current issue?

-- Steve

diff --git a/Documentation/Makefile b/Documentation/Makefile
index edb8623..3a981be 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -157,7 +157,7 @@ endif
 do-install-man: man
 	$(call QUIET_INSTALL, Documentation-man) \
 		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
-		$(INSTALL) -m 644 $(DOC_MAN3) $(DESTDIR)$(man3dir);
+		$(INSTALL) -m 644 $(OUTPUT)*.3 $(DESTDIR)$(man3dir);
 
 install-man: check-man-tools man do-install-man
 
