Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C9FC433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0DAD22276
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbgJIOt4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgJIOt4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:49:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D6B22260;
        Fri,  9 Oct 2020 14:49:55 +0000 (UTC)
Date:   Fri, 9 Oct 2020 10:49:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zamir SUN <sztsian@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: libtraceevent: make doc-install tries different file names than
 generated
Message-ID: <20201009104954.0fd440b5@gandalf.local.home>
In-Reply-To: <7cdec98e-3184-4ddc-e78c-867a9650e636@gmail.com>
References: <7cdec98e-3184-4ddc-e78c-867a9650e636@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

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
 
