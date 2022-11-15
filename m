Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0DBC43217
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 04:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiKOEDn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiKOEDj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 23:03:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD60F5B6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:03:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0379F614FD
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EF9C433B5;
        Tue, 15 Nov 2022 04:03:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ounBK-00AIBu-0N;
        Mon, 14 Nov 2022 23:04:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/4] libtracefs: Add more iterator helpers
Date:   Mon, 14 Nov 2022 23:04:13 -0500
Message-Id: <20221115040417.2453172-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add follow event and missed events callback helper to make it simpler to follow
events using the tracefs_iterate_raw_events() function.

Also change tracefs_iterate_raw_events() to use the tracefs_cpu_buffered_read()
that will read via splice and is much more efficient than using single reads.

Changes since v1: https://lore.kernel.org/all/20221115034712.2447458-1-rostedt@goodmis.org/

 - Fixed up the documentation

Steven Rostedt (Google) (4):
  libtracefs: Use tracefs_cpu_read() for tracefs_iterate_raw_events()
  libtracefs: Split out iterator functions from man page
  libtracefs: Add tracefs_follow_event() API
  libtracefs: Add tracefs_follow_missed_events() API

 Documentation/libtracefs-events.txt   |  32 +--
 Documentation/libtracefs-iterator.txt | 229 ++++++++++++++++++++
 Documentation/libtracefs.txt          |  11 +
 include/tracefs-local.h               |  12 ++
 include/tracefs.h                     |  11 +
 src/tracefs-events.c                  | 292 +++++++++++++++++++++-----
 6 files changed, 502 insertions(+), 85 deletions(-)
 create mode 100644 Documentation/libtracefs-iterator.txt

-- 
2.35.1

