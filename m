Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7FEEB64D9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Jun 2023 17:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbjFORM1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbjFORM0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 13:12:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1DA1BF9
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 10:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C80A86258F
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 17:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A48C433C8
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 17:12:19 +0000 (UTC)
Date:   Thu, 15 Jun 2023 13:12:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Have tracecmd_iterate_events() start
 where it left off
Message-ID: <20230615131216.1fc36f0f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a callback to tracecmd_iterate_events() returns non-zero, it exits
the iteration. Allow a sequential call to tracecmd_iterate_events() to
start were it left off.

The iterator peeks at the data which needs to be cleared. But the peek
itself set the next read to be the next record. On a sequential iterator
call, it will not include the cached records that were left over from the
previous iterator call.

Make sure at the end of the iterator to reset the indexes so that the next
reads will be the recorders that were not processed by the iterator.

Also do the same for tracecmd_iterate_events_multi() and remove the stale
comment about not needing to free the records.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 51420c13c750..5279f581439d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2820,10 +2820,15 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 
 	/* Need to unlock and free the records */
 	for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+		int offset;
+
 		if (!records[cpu])
 			continue;
-		record = tracecmd_read_data(handle, cpu);
-		tracecmd_free_record(record);
+
+		offset = (int)(records[cpu]->offset & (handle->page_size - 1));
+		free_next(handle, cpu);
+		/* Reset the buffer to read the cached record again */
+		kbuffer_read_at_offset(handle->cpu_data[cpu].kbuf, offset, NULL);
 	}
 
 	free(records);
@@ -2917,20 +2922,20 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 	/* Unlock and free the records */
 	for (cpu = 0; cpu < all_cpus; cpu++) {
 		int local_cpu;
+		int offset;
 
 		if (!records[cpu].record)
 			continue;
 
 		handle = records[cpu].handle;
 		local_cpu = cpu - handle->start_cpu;
-		record = tracecmd_read_data(handle, local_cpu);
-		tracecmd_free_record(record);
+
+		offset = (int)(records[cpu].record->offset & (handle->page_size - 1));
+		free_next(handle, local_cpu);
+		/* Reset the buffer to read the cached record again */
+		kbuffer_read_at_offset(handle->cpu_data[cpu].kbuf, offset, NULL);
 	}
 
-	/*
-	 * The records array contains only records that were taken via
-	 * tracecmd_peek_data(), and do not need to be freed.
-	 */
 	free(records);
 
 	return ret;
-- 
2.39.2

