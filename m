Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3332CC43334
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jun 2022 15:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377889AbiFPPaK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 11:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238245AbiFPPaK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 11:30:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F582DAAE
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 08:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D67BF61E62
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 15:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AE3C34114;
        Thu, 16 Jun 2022 15:30:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1rRf-002j50-7B;
        Thu, 16 Jun 2022 11:30:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] trace-cmd: Make unit tests for trace-cmd
Date:   Thu, 16 Jun 2022 11:29:57 -0400
Message-Id: <20220616153001.649858-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The current unit tests in the trace-cmd repo are really for libtracefs. As
libtracefs has moved to its own repo and has its own unit tests, the
trace-cmd tests here are redundant.

Remove the libtracefs unit tests and replace them with tests that are
specific for trace-cmd.

Currently there are only two tests added. A simple record and report, and a
test of converting from v7 to v6 file format. But this adds infrastructure
that should make it easier to add new tests.

Steven Rostedt (Google) (4):
  trace-cmd utests: Remove libtracefs tests
  trace-cmd utest: Rename tracefs-utest.c to tracecmd-utest.c
  trace-cmd test: Add simple record/report test
  trace-cmd test: Add test to check conversion from 7 to 6

 Makefile               |   2 +-
 utest/Makefile         |   2 +-
 utest/trace-utest.c    |  23 +-
 utest/trace-utest.h    |   7 +-
 utest/tracecmd-utest.c | 295 +++++++++++++++++++
 utest/tracefs-utest.c  | 630 -----------------------------------------
 6 files changed, 319 insertions(+), 640 deletions(-)
 create mode 100644 utest/tracecmd-utest.c
 delete mode 100644 utest/tracefs-utest.c

-- 
2.35.1

