Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4336C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3BC2196E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390478AbfISVZn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389183AbfISVZn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 17:25:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54ED3218AF;
        Thu, 19 Sep 2019 21:25:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iB3vp-0008SF-FK; Thu, 19 Sep 2019 17:25:41 -0400
Message-Id: <20190919212335.400961206@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Sep 2019 17:23:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] tools/lib/traceevent: Man page updates and some file movement
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Arnaldo,

This is a series of man page updates to the libtraceevent code, as
well as a fix to one missing prototype and some movement of the location
of the plugins (to have the plugins in their own directory).

-- Steve




Tzvetomir Stoyanov (2):
      tools/lib/traceevent: Man pages for libtraceevent event print related API
      tools/lib/traceevent: Man pages for tep plugins APIs

Tzvetomir Stoyanov (VMware) (4):
      tools/lib/traceevent: Man pages fix, rename tep_ref_get() to tep_get_ref()
      tools/lib/traceevent: Man pages fix, changes in event printing APIs
      tools/lib/traceevent: Add tep_get_event() in event-parse.h
      tools/lib/traceevent: Move traceevent plugins in its own subdirectory

----
 tools/lib/traceevent/Build                         |  11 -
 .../Documentation/libtraceevent-event_print.txt    | 130 ++++++++++++
 .../Documentation/libtraceevent-handle.txt         |   8 +-
 .../Documentation/libtraceevent-plugins.txt        |  99 +++++++++
 .../lib/traceevent/Documentation/libtraceevent.txt |  15 +-
 tools/lib/traceevent/Makefile                      |  94 ++-------
 tools/lib/traceevent/event-parse.h                 |   2 +
 tools/lib/traceevent/plugins/Build                 |  10 +
 tools/lib/traceevent/plugins/Makefile              | 222 +++++++++++++++++++++
 .../lib/traceevent/{ => plugins}/plugin_cfg80211.c |   0
 .../lib/traceevent/{ => plugins}/plugin_function.c |   0
 .../lib/traceevent/{ => plugins}/plugin_hrtimer.c  |   0
 tools/lib/traceevent/{ => plugins}/plugin_jbd2.c   |   0
 tools/lib/traceevent/{ => plugins}/plugin_kmem.c   |   0
 tools/lib/traceevent/{ => plugins}/plugin_kvm.c    |   0
 .../lib/traceevent/{ => plugins}/plugin_mac80211.c |   0
 .../traceevent/{ => plugins}/plugin_sched_switch.c |   0
 tools/lib/traceevent/{ => plugins}/plugin_scsi.c   |   0
 tools/lib/traceevent/{ => plugins}/plugin_xen.c    |   0
 19 files changed, 485 insertions(+), 106 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
 create mode 100644 tools/lib/traceevent/plugins/Build
 create mode 100644 tools/lib/traceevent/plugins/Makefile
 rename tools/lib/traceevent/{ => plugins}/plugin_cfg80211.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_function.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_hrtimer.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_jbd2.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_kmem.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_kvm.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_mac80211.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_sched_switch.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_scsi.c (100%)
 rename tools/lib/traceevent/{ => plugins}/plugin_xen.c (100%)
