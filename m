Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281CAC2BBC7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 01:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E122076D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 01:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403848AbgDNBqN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgDNBqM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 21:46:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D8B2075E
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 01:46:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jOAeR-004H3W-3o
        for linux-trace-devel@vger.kernel.org; Mon, 13 Apr 2020 21:46:11 -0400
Message-Id: <20200414014403.968063641@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 13 Apr 2020 21:44:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: Some more minor updates
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These are minor changes and instead of having Tzvetomir resend the patches
with the updates, I just made the changes.

First patch is to change the grammar of the function names that have
"file_exist" and "dir_exist" to "file_exists" and "dir_exists" respectively,
as they sound better for a native English speaker.

The second is just a micro-optimization of the return code of
check_file_exists().

Steven Rostedt (VMware) (2):
      trace-cmd: Use "exists" instead of "exist"
      trace-cmd: Optimize check_file_exists()

----
 include/tracefs/tracefs.h      |  4 ++--
 lib/tracefs/tracefs-instance.c | 21 ++++++++-------------
 tracecmd/trace-record.c        |  2 +-
 utest/tracefs-utest.c          | 28 ++++++++++++++--------------
 4 files changed, 25 insertions(+), 30 deletions(-)
