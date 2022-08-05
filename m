Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140B2C25B08
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238191AbiHEPkt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiHEPkr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A92417AB6
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB1246148E
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BA1C43143;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRJ-008S4J-2s;
        Fri, 05 Aug 2022 11:40:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/9] trace-cmd library: Add and use new helper functions
Date:   Fri,  5 Aug 2022 11:40:31 -0400
Message-Id: <20220805154040.2014381-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the following functions to the libtracecmd library:

 tracecmd_set_private() - set private data to tracecmd_input handle
 tracecmd_get_private() - get private data from tracecmd_input handle
 tracecmd_iterate_events() - iterate all events for a single buffer in a
                          trace.dat file (can filter on CPUs)
 tracecmd_iterate_events_multi() - iterate all events from multiple buffers
                          in a trace.dat file. (Does not filter on CPUs).
 tracecmd_filter_add() - Add a filter to a tracecmd_input handle that will
                          filter the iterator funtions.
 tracecmd_filter_match() - Will test a record against a given filter to see
                         if it matches or not.

As change trace-cmd to use these functions instead of doing the same thing
internally.


Steven Rostedt (Google) (9):
  tracecmd: Use make variable instead of if statement for zlib test
  tracecmd library: Add tracecmd_iterate_events()
  tracecmd utest: Add test to test using the libraries to read
  tracecmd library: Add tracecmd_iterate_events_multi()
  trace-cmd library: Allow callers to save private data in
    tracecmd_input handlers
  trace-cmd report: Use tracecmd_iterate_events_multi()
  trace-cmd library: Add filtering logic for iterating events
  trace-cmd report: Make filter arguments match their files
  trace-cmd report: Use library tracecmd_filter_*() logic

 Makefile                                |   3 +
 include/trace-cmd/trace-cmd.h           |  29 ++
 lib/trace-cmd/Makefile                  |   7 +-
 lib/trace-cmd/include/trace-cmd-local.h |   5 +
 lib/trace-cmd/trace-filter.c            | 197 ++++++++++
 lib/trace-cmd/trace-input.c             | 197 ++++++++++
 tracecmd/Makefile                       |   6 +-
 tracecmd/trace-read.c                   | 466 ++++++++----------------
 utest/Makefile                          |   4 +-
 utest/tracecmd-utest.c                  |  53 ++-
 10 files changed, 650 insertions(+), 317 deletions(-)
 create mode 100644 lib/trace-cmd/trace-filter.c

-- 
2.35.1

