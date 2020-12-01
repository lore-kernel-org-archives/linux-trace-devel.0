Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AD5C64E7A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 18:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A232208C3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 18:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392288AbgLAShh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 13:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392255AbgLAShh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 13:37:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A9E9208C3
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Dec 2020 18:36:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kkAWF-002SSv-MH
        for linux-trace-devel@vger.kernel.org; Tue, 01 Dec 2020 13:36:55 -0500
Message-ID: <20201201183604.562747692@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 13:36:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] trace-cmd: Some minor updates and a timestamp checker
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven Rostedt (VMware) (3):
      trace-cmd: Fix whitespace in usage message of trace-cmd report --ts-diff
      trace-cmd: Add reference to trace-cmd.org in README
      trace-cmd: Add --ts-check option to report

----
 Documentation/trace-cmd-report.1.txt |  4 ++++
 README                               |  3 +++
 tracecmd/trace-read.c                | 27 ++++++++++++++++++++++++++-
 tracecmd/trace-usage.c               |  3 ++-
 4 files changed, 35 insertions(+), 2 deletions(-)
