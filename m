Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9177C6379D
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Nov 2020 01:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D41024137
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Nov 2020 01:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgKUBDS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 20:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgKUBDS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 20:03:18 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068AE20729;
        Sat, 21 Nov 2020 01:03:15 +0000 (UTC)
Date:   Fri, 20 Nov 2020 20:03:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Linux-trace Users <linux-trace-users@vger.kernel.org>
Cc:     Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>, powertop@lists.01.org,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Subject: [ANNOUNCE] libtracefs.git
Message-ID: <20201120200314.21efabe5@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I split out the libtracefs code from trace-cmd.git using "git subtree",
which recreates all the commits of a directory and makes that directory
a stand alone. I then updated the Makefiles, and copied over some of
the header files used to build the library. I pushed this up to:

  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

What libtracefs.so will be use for, is to allow programs to have an API
to access the tracefs directory. Right now, it has a very limited set
of functions that do the bare minimum, for example, to print all sched
events:

	const char *tracefs_dir;
	char **sched_events;
	char *event;
	int i;

	tracefs_dir = tracefs_get_tracing_dir();

	sched_events = tracefs_system_events(tracefs_dir, "sched");
	if (!sched_events)
		return -1;
	for (i = 0; sched_events[i]; i++)
		printf("sched event: %s\n", sched_events[i]);

	tracefs_list_free(sched_events);

We plan on adding man pages for all the functions, as well as expand
the functionality. For example (TBD):

	char **funcs;

	funcs = tracefs_available_filter_functions(tracefs_dir, ".*lock.*");

Which would return a list of all functions that have "lock" in its name
that can be traced by the function tracer.

Same for setting and getting the ftrace filter, enabling disable
events, and even setting filters and histograms. The version of this
library is at 0.1.0 as we are working on it. It is currently at the
stage that kernelshark can use it. Once libtracecmd is ready, then
kernelshark will become its own repo as well.

The repo is still a little rough around the edges, and needs some
loving for making sure the library is installed properly, but it is now
out there for people to have a look, and better yet, send patches! :-)

Note: From now on, updates to libtraceevent and libtracefs will now be
made in their corresponding git repos on kernel.org, and no longer
fixed in trace-cmd or the kernel proper (with some exceptions). After a
couple of years, when these are packaged in all major repos, I tend to
remove the code from these other locations.

-- Steve
