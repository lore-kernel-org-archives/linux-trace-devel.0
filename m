Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7BEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiBWAan (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707FA55BE4
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16CE8612DA
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A65C340EB;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bG4-BF;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 00/11] libtracefs: Add man page checks and upate man pages
Date:   Tue, 22 Feb 2022 19:30:01 -0500
Message-Id: <20220223003012.1334741-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preperation to release libtracefs 1.3, the man pages need to be complete.

I sent a patch to add a check-manpage.sh which this series is based on:

   https://lore.kernel.org/all/20220222131816.0bfdb33e@gandalf.local.home/

This series fixes the man page issues that the script has found. It also
updates the script to check tracefs.h to see if there's any missing functions
that should be in the man pages.

This series fixes the missing functions from the man pages too.

Finally, to make sure that functions are not missed in the future, the script
is executed whenever "make doc" is performed.

Steven Rostedt (Google) (11):
  libtracefs: Update main man page for all functions
  libtracefs: Do not check libtracefs-options.txt man page
  libtracefs: Have check-manpages.sh check tracefs.h as well
  libtracefs: Add documentation for tracefs_instances()
  libtracefs: Hide tracefs_list_pop() and make it trace_list_pop()
  libtracefs: Add documentation for tracefs_list_add/size()
  libtracefs: Add documentation for tracefs_iterate_stop()
  libtracefs: Add documentation for tracefs_option_id()
  libtracefs: Add man pages for tracefs_event_file_*() functions
  libtracefs: Do not check for deprecated functions
  libtracefs: Run the check-manpages.sh on building of docs

 Documentation/libtracefs-events-file.txt      | 217 ++++++++++++++++++
 Documentation/libtracefs-events.txt           |   9 +-
 .../libtracefs-instances-affinity.txt         |   4 +-
 Documentation/libtracefs-instances-manage.txt |  14 +-
 Documentation/libtracefs-option-get.txt       |  11 +-
 Documentation/libtracefs-utils.txt            |  28 ++-
 Documentation/libtracefs.txt                  |  33 +++
 Makefile                                      |   5 +-
 check-manpages.sh                             |  22 ++
 include/tracefs-local.h                       |   1 +
 include/tracefs.h                             |   1 -
 src/tracefs-hist.c                            |  10 +-
 src/tracefs-utils.c                           |   6 +-
 13 files changed, 342 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/libtracefs-events-file.txt

-- 
2.34.1

