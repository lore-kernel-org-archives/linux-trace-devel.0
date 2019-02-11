Return-Path: <SRS0=h7mL=QS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17739C4151A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66EE217D9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfBKBVz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Feb 2019 20:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfBKBVz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Feb 2019 20:21:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14B592173C;
        Mon, 11 Feb 2019 01:21:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92-RC5)
        (envelope-from <rostedt@goodmis.org>)
        id 1gt0IE-0003x2-7c; Sun, 10 Feb 2019 20:21:54 -0500
Message-Id: <20190211012154.123854384@goodmis.org>
User-Agent: quilt/0.65
Date:   Sun, 10 Feb 2019 20:18:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/4] kernel-shark: Remove plugin_get_rec_wakeup_pid()
References: <20190211011807.714634783@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The function plugin_get_rec_wakeup_pid() is not used by anything. Remove
it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/plugins/sched_events.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index 0f5c08e3508d..0cfe5b5367e2 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -111,24 +111,6 @@ int plugin_get_next_pid(struct tep_record *record)
 	return ret ? : val;
 }
 
-/**
- * @brief Get the Process Id of the task being woke up.
- *
- * @param record: Input location for a sched_wakeup record.
- */
-int plugin_get_rec_wakeup_pid(struct tep_record *record)
-{
-	struct plugin_sched_context *plugin_ctx =
-		plugin_sched_context_handler;
-	unsigned long long val;
-	int ret;
-
-	ret = tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
-				    record->data, &val);
-
-	return ret ? : val;
-}
-
 static void plugin_register_command(struct kshark_context *kshark_ctx,
 				    struct tep_record *record,
 				    int pid)
-- 
2.20.1


