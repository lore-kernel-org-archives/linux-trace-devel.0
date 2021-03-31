Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB38C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FBF61077
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhCaXHn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 19:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhCaXH3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3389561073
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 23:07:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRjvs-003g50-0Y
        for linux-trace-devel@vger.kernel.org; Wed, 31 Mar 2021 19:07:28 -0400
Message-ID: <20210331230610.035418770@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 31 Mar 2021 19:06:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] trace-cmd: Fix the memory mangement of trace-cmd agent.
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When testing out the time sync logic, the agent crashed due to
various memory management issues.

Steven Rostedt (VMware) (3):
      trace-cmd agent: Clean up tsync_agent_thread() and tsync_host_thread()
      trace-cmd: Have tracecmd_tsync_free() free even with no context
      trace-cmd: Do not free tsync from thread

----
 lib/trace-cmd/trace-timesync.c | 49 +++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 25 deletions(-)
