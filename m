Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C733CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 04:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKOEIF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKOEID (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 23:08:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533D4FD1B
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:07:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 571FC614FD
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B993CC433C1;
        Tue, 15 Nov 2022 04:07:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ounFX-00AJ6f-2H;
        Mon, 14 Nov 2022 23:08:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/4] libtracefs: Add more iterator helpers
Date:   Mon, 14 Nov 2022 23:08:34 -0500
Message-Id: <20221115040838.2456632-1-rostedt@goodmis.org>
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

Changes since v2: https://lore.kernel.org/all/20221115040417.2453172-1-rostedt@goodmis.org/

 - Fixed up the documentation (again!)

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

