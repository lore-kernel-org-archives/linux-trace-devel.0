Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE20C19425
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E95223D20
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgLJCa0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgLJCa0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:30:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EFA923C43
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 02:29:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knBiA-00047k-Q5
        for linux-trace-devel@vger.kernel.org; Wed, 09 Dec 2020 21:29:42 -0500
Message-ID: <20201210022906.112066412@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Dec 2020 21:29:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/9] trace-cmd: Clean ups and fixes for installing libraries
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven Rostedt (VMware) (6):
      trace-cmd: Fix whitespace in usage message of trace-cmd report --ts-diff
      trace-cmd: Add reference to trace-cmd.org in README
      trace-cmd: Add --ts-check option to report
      trace-cmd: Update .gitignore
      trace-cmd: Have "make test" use system libraries if present
      trace-cmd: Only install libtraceevent and libtracefs if not in system

Tzvetomir (VMware) Stoyanov (2):
      libtracefs: Extend tracefs_iterate_raw_events() to iterate per CPU
      libtracefs: Unit test for tracefs_iterate_raw_events() per CPU

Tzvetomir Stoyanov (VMware) (1):
      trace-cmd: Use system trace libraries, if available

----
 .gitignore                           | 10 ++--
 Documentation/trace-cmd-report.1.txt |  4 ++
 Makefile                             | 67 ++++++++++++++++++---------
 README                               |  3 ++
 include/tracefs/tracefs.h            |  2 +
 kernel-shark/.gitignore              | 22 +++++++++
 lib/traceevent/Makefile              |  2 +
 lib/tracefs/Makefile                 |  2 +
 lib/tracefs/tracefs-events.c         |  6 +++
 tracecmd/.gitignore                  |  1 +
 tracecmd/Makefile                    |  6 ++-
 tracecmd/trace-read.c                | 29 +++++++++++-
 tracecmd/trace-record.c              |  2 +-
 tracecmd/trace-usage.c               |  3 +-
 utest/Makefile                       |  4 +-
 utest/tracefs-utest.c                | 89 ++++++++++++++++++++++++++++--------
 16 files changed, 200 insertions(+), 52 deletions(-)
 create mode 100644 kernel-shark/.gitignore
 create mode 100644 tracecmd/.gitignore
