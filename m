Return-Path: <SRS0=gJTR=AT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6348EC433E1
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530462078C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgGHUaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 16:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgGHUaT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 16:30:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B182078C
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jul 2020 20:30:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jtGhs-004NMQ-Qt
        for linux-trace-devel@vger.kernel.org; Wed, 08 Jul 2020 16:30:16 -0400
Message-ID: <20200708202850.764168067@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 08 Jul 2020 16:28:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] trace-cmd: Triaging bugzillas and fixes
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This includes the two updates Tzvetomir did, as well as fixes for
bugzillas: 207069, 205953, and 204703

Steven Rostedt (VMware) (3):
      trace-cmd: Explicitly state what trace-cmd report -f does
      tools lib traceevent: Let function symbols be used in operations
      trace-cmd: Print raw hex for flags when trace-cmd report -R

Tzvetomir Stoyanov (VMware) (2):
      trace-cmd: Fix trace-cmd report -t to show full timestamp
      tools lib traceveent: Fix kbuffer_start_of_data() to return the first record

----
 Documentation/trace-cmd-report.1.txt |  4 ++-
 lib/traceevent/event-parse.c         | 49 +++++++++++++++++++++++++++-
 lib/traceevent/kbuffer-parse.c       |  7 +++-
 tracecmd/trace-read.c                | 63 ++++++++++++++++++++++++++----------
 tracecmd/trace-usage.c               |  2 +-
 5 files changed, 104 insertions(+), 21 deletions(-)
