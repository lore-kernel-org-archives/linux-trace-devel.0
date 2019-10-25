Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC0FC47E49
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7041F21D71
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404663AbfJYGxZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 02:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393044AbfJYGxY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 02:53:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E0820867
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2019 06:53:24 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iNtTP-0004tw-Dm
        for linux-trace-devel@vger.kernel.org; Fri, 25 Oct 2019 02:53:23 -0400
Message-Id: <20191025065243.627023108@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 25 Oct 2019 02:52:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: Fixes for reading older trace-cmd trace.dat files
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Fix two bugs that caused reading an trace.dat file created
by an older trace-cmd not to print properly.

Steven Rostedt (VMware) (2):
      libtraceevent: Remove extra '\n' in print_event_time()
      trace-cmd: Use usecs unless specified not to

----
 lib/trace-cmd/trace-input.c  | 12 ++++++++----
 lib/traceevent/event-parse.c |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)
