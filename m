Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AE0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 04:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiKOE4S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiKOE4Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 23:56:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E8AA1A0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 178C6B810F7
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739D5C433C1
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:56:09 +0000 (UTC)
Date:   Mon, 14 Nov 2022 23:56:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fixe tracefs_iterate_stop() when instance is
 used
Message-ID: <20221114235651.7c1b98d7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

There was a cut and paste error where tracefs_iterate_stop() was using the
instance->pipe_keep_going instead of the instance->iterate_keep_going and
it caused the tracefs_iterate_stop() to not stop the iterator on
instances.

Fixes: ffcc062c6352d ("libtracefs: Add tracefs_iterate_stop()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index e92663656688..daa81c07ecb5 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -418,7 +418,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 						int, void *),
 				void *callback_context)
 {
-	bool *keep_going = instance ? &instance->pipe_keep_going :
+	bool *keep_going = instance ? &instance->iterate_keep_going :
 				      &top_iterate_keep_going;
 	struct cpu_iterate *all_cpus;
 	int count = 0;
-- 
2.35.1

