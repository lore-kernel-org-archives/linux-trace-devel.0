Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3805DC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 18:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B52A208FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 18:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgGBS5F (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgGBS5F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 14:57:05 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2E121532;
        Thu,  2 Jul 2020 18:57:04 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jr4ON-004B9e-JJ; Thu, 02 Jul 2020 14:57:03 -0400
Message-ID: <20200702185344.913492689@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 02 Jul 2020 14:53:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 00/15] tools lib traceevent: Patches from the trace-cmd repo
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Arnaldo,

I was missing a few patches, here's take two. I also changed some of the
patches to state that they are coming from trace-cmd.git.

-- Steve

We noticed that the libtraceevent in trace-cmd.git is a bit out of sync with
what is in the kernel. These patches can help bring it by in sync again.


Jan Kiszka (2):
      tools lib traceevent: Add more SVM exit reasons
      tools lib traceevent: Fix reporting of unknown SVM exit reasons

Julia Cartwright (1):
      tools lib traceevent: Add plugin for decoding syscalls/sys_enter_futex

Steven Rostedt (Red Hat) (2):
      tools lib traceevent: Add API to read time information from kbuffer
      tools lib traceevent: Add plugin for tlb_flush

Steven Rostedt (VMware) (3):
      tools lib traceevent: Add offset option for function plugin
      tools lib traceevent: Add builtin handler for trace_marker_raw
      tools lib traceevent: Change to SPDX License format

Tom Zanussi (1):
      tools lib traceevent: Add proper KBUFFER_TYPE_TIME_STAMP handling

Tzvetomir Stoyanov (VMware) (6):
      tools lib traceevent: Add tep_load_plugins_hook() API
      tools lib traceevent: Add interface for options to plugins
      tools lib traceevent: Introduced new traceevent API, for adding new plugins directories.
      tools lib traceevent: Add support for more printk format specifiers
      tools lib traceevent: Optimize pretty_print() function
      tools lib traceevent: Move kernel_stack event handler to "function" plugin.

----
 tools/lib/traceevent/event-parse-local.h           |   22 +-
 tools/lib/traceevent/event-parse.c                 | 1004 +++++++++++++++-----
 tools/lib/traceevent/event-parse.h                 |   34 +-
 tools/lib/traceevent/event-plugin.c                |  261 ++++-
 tools/lib/traceevent/kbuffer-parse.c               |   43 +-
 tools/lib/traceevent/kbuffer.h                     |   19 +-
 tools/lib/traceevent/plugins/Build                 |    2 +
 tools/lib/traceevent/plugins/Makefile              |    2 +
 tools/lib/traceevent/plugins/plugin_function.c     |  123 ++-
 tools/lib/traceevent/plugins/plugin_futex.c        |  123 +++
 tools/lib/traceevent/plugins/plugin_hrtimer.c      |   17 +-
 tools/lib/traceevent/plugins/plugin_jbd2.c         |   17 +-
 tools/lib/traceevent/plugins/plugin_kmem.c         |   17 +-
 tools/lib/traceevent/plugins/plugin_kvm.c          |   42 +-
 tools/lib/traceevent/plugins/plugin_mac80211.c     |   17 +-
 tools/lib/traceevent/plugins/plugin_sched_switch.c |   17 +-
 tools/lib/traceevent/plugins/plugin_tlb.c          |   66 ++
 17 files changed, 1406 insertions(+), 420 deletions(-)
 create mode 100644 tools/lib/traceevent/plugins/plugin_futex.c
 create mode 100644 tools/lib/traceevent/plugins/plugin_tlb.c
