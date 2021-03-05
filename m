Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCF1C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 22:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BBF650AD
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 22:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCEWsM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:48:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhCEWrv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:47:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CAC46509E
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:47:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJEc-001zxK-5X
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:47:50 -0500
Message-ID: <20210305224719.784797597@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:47:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: Fixes for instance recording and reporting
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It appears that the valification code broke instances.

Steven Rostedt (VMware) (2):
      trace-cmd record: Allow tracecmd_write_cpu_data() be called multiple times
      trace-cmd report: Add last_timestamp array for instances

----
 lib/trace-cmd/trace-output.c |  4 +++-
 tracecmd/trace-read.c        | 12 ++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)
