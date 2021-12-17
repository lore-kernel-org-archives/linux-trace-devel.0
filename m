Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E817C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 00:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhLQAmS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 19:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhLQAmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 19:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B562DC06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 16:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34F3761F67
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44B0C36AE2;
        Fri, 17 Dec 2021 00:42:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my1KB-0004Cr-Nl;
        Thu, 16 Dec 2021 19:42:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/9] libtracefs: Updates to the Makefile
Date:   Thu, 16 Dec 2021 19:42:05 -0500
Message-Id: <20211217004214.16074-1-rostedt@goodmis.org>
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

Steven Rostedt (VMware) (9):
  libtracefs: Remove unused "bindir" from Makefile
  libtracefs: Remove unneeded blkflags from Makefile
  libtracefs: Fix sample intermediate build targets
  libtracefs: Add "DESCEND" output when descending into directories
    during build
  libtracefs: Have make clean output cleaner
  libtracefs: Quiet mv: cannot stat message for libtracefs.a
  libtracefs: Quiet "Nothing to be done for" messages
  libtracefs: Have sample build look cleaner
  libtracefs: Have make tags and TAGS honor O= build directory

 Makefile         | 66 ++++++++++++++++++++++++------------------------
 samples/Makefile | 15 ++++++-----
 scripts/utils.mk | 51 ++++++++++++++++++++++++++++++++++++-
 src/Makefile     |  4 ++-
 utest/Makefile   |  2 +-
 5 files changed, 95 insertions(+), 43 deletions(-)

-- 
2.33.0

