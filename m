Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00FEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Jun 2022 10:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352027AbiFAK02 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344810AbiFAK0Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 06:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B4C6A06B
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Jun 2022 03:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE8BA611DD
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Jun 2022 10:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A73C385A5;
        Wed,  1 Jun 2022 10:26:22 +0000 (UTC)
Date:   Wed, 1 Jun 2022 06:26:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     hws@denx.de
Subject: [PATCH] libtracefs: Have labels in selections be synthetic fields
Message-ID: <20220601062619.2f601c8a@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The labels in the selection case are suppose to be the fields for the
created synthetic events. But for some reason they were ignored.

For example:

  sqlhist -n wakeup_lat 'select end.next_pid as pid, end.next_comm as comm, (end.TIMESTAMP - start.TIMESTAMP) as lat
   from sched_waking as start join sched_switch as end on start.pid = end.next_pid'

Produces the synthetic event of:

  echo 'wakeup_lat pid_t next_pid; char next_comm[16]; u64 lat;' >> /sys/kernel/tracing/synthetic_events

Where it should have used 'pid' instead of 'next_pid' and 'comm' instead
of 'next_comm'

Fixes: 25446407 ("libtracefs: Added new API tracefs_sql()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 9811362..8d71800 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -253,6 +253,7 @@ __hidden int add_selection(struct sqlhist_bison *sb, void *select,
 
 	switch (expr->type) {
 	case EXPR_FIELD:
+		expr->field.label = name;
 		break;
 	case EXPR_COMPARE:
 		expr->compare.name = name;
-- 
2.35.1

