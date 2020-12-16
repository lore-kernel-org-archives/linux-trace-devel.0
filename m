Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4B8C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF4D23788
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgLPWBr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbgLPWBp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 17:01:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C1923788
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 22:01:04 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kper1-000wjD-RQ
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 17:01:03 -0500
Message-ID: <20201216220032.809666622@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 17:00:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] trace-cmd: Some fixes, and add make-trace-cmd.sh package building helper script
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven Rostedt (VMware) (3):
      trace-cmd: Move add_event_pid() out of #ifndef NO_PTRACE
      trace-cmd: Add #include <fcntl.h> to trace-cmd-private.h
      trace-cmd: Add a make-trace-cmd.sh script to simplify creating a trace-cmd package

----
 PACKAGING                                         | 30 ++++++++++++++++++++++
 lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
 make-trace-cmd.sh                                 | 31 +++++++++++++++++++++++
 tracecmd/trace-record.c                           | 12 ++++-----
 4 files changed, 68 insertions(+), 6 deletions(-)
 create mode 100644 PACKAGING
 create mode 100755 make-trace-cmd.sh
