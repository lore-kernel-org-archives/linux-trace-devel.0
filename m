Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD632C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhLQFuu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60330 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhLQFut (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7AC5B8273D
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9448AC36AF0;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056V-AP;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 00/15] libtracefs: Updates to the Makefile
Date:   Fri, 17 Dec 2021 00:50:26 -0500
Message-Id: <20211217055041.19559-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>


While cleaning up the libtraceevent Makefile using the libtracefs Makefiles as
guide, I found various issues with the libtracefs Makefiles.

This cleans up those issues.

Changes since v1: https://lore.kernel.org/all/20211217004214.16074-1-rostedt@goodmis.org/

 - Updated .gitignore
 - Build into lib and not lib/tracefs
 - More clean ups of the samples directory
 - Fixed a few bugs

Steven Rostedt (VMware) (15):
  libtracefs: Update gitignore file
  libtracefs: Have make tags and TAGS honor O= build directory
  libtracefs: Fix stream example
  libtracefs: Fix samples Makefile
  libtracefs: Remove unused "bindir" from Makefile
  libtracefs: Remove unneeded blkflags from Makefile
  libtracefs: Add "DESCEND" output when descending into directories
    during build
  libtracefs: Have make clean output cleaner
  libtracefs: Quiet mv: cannot stat message for libtracefs.a
  libtracefs: Quiet "Nothing to be done for" messages
  libtracefs: Have sample build look cleaner
  libtracefs: Have samples build in separate directory from bin
  libtracefs: Build in the same directories as the source
  libtracefs: Add clean descend
  libtracefs: Remove build_prefix file on make clean

 .gitignore                          |  4 ++
 Documentation/.gitignore            |  1 +
 Documentation/libtracefs-stream.txt |  1 +
 Makefile                            | 85 +++++++++++++++--------------
 samples/Makefile                    | 36 ++++++------
 scripts/utils.mk                    | 54 +++++++++++++++++-
 src/Makefile                        |  7 +--
 utest/Makefile                      |  2 +-
 8 files changed, 124 insertions(+), 66 deletions(-)

-- 
2.33.0

