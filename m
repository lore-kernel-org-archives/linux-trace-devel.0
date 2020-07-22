Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E844C4345F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E191722D03
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbgGVBTB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbgGVBRy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 21:17:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B03E207BB;
        Wed, 22 Jul 2020 01:17:53 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jy3OK-005s7E-CW; Tue, 21 Jul 2020 21:17:52 -0400
Message-ID: <20200722011628.925541477@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 21 Jul 2020 21:16:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/23 v3] tools lib traceevent: Synchronizing trace-cmd with tools
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changes since v2:

The last 8 patches are added to address Namhyung's comments.

-- Steve



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

Tzvetomir Stoyanov (VMware) (14):
      tools lib traceevent: Add tep_load_plugins_hook() API
      tools lib traceevent: Add interface for options to plugins
      tools lib traceevent: Introduced new traceevent API, for adding new plugins directories.
      tools lib traceevent: Add support for more printk format specifiers
      tools lib traceevent: Optimize pretty_print() function
      tools lib traceevent: Move kernel_stack event handler to "function" plugin.
      tools lib traceevent: Document tep_load_plugins_hook()
      tools lib traceevent: Handle strdup() error in parse_option_name()
      tools lib traceevent: Fix typo in tep_plugin_add_option() description
      tools lib traceevent: Improve error handling of tep_plugin_add_option() API
      tools lib traceevent: Fixed broken indentation in parse_ip4_print_args()
      tools lib traceevent: Fixed type in PRINT_FMT_STING
      tools lib traceevent: Fixed description of tep_add_plugin_path() API
      tools lib traceevent: Handle possible strdup() error in tep_add_plugin_path() API

----
 .../Documentation/libtraceevent-plugins.txt        |   25 +-
 tools/lib/traceevent/event-parse-local.h           |   22 +-
 tools/lib/traceevent/event-parse.c                 | 1004 +++++++++++++++-----
 tools/lib/traceevent/event-parse.h                 |   34 +-
 tools/lib/traceevent/event-plugin.c                |  285 +++++-
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
 18 files changed, 1454 insertions(+), 421 deletions(-)
 create mode 100644 tools/lib/traceevent/plugins/plugin_futex.c
 create mode 100644 tools/lib/traceevent/plugins/plugin_tlb.c
