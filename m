Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E814C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Jun 2023 18:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238790AbjFFSwr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 14:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbjFFSwk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 14:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED13E42
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 11:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 380AC6123B
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 18:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652C6C433EF
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 18:52:34 +0000 (UTC)
Date:   Tue, 6 Jun 2023 14:52:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tracecmd library: Unlock records in
 tracecmd_iterate_events()
Message-ID: <20230606145231.77820ea6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracecmd_iterate_events() and tracecmd_iterate_events_multi() uses
tracecmd_peek_data() to look at the next record. But when this is done,
the record is "cached" and "locked" in the handle. Which means they can
not be freed.

At the end of the iterators, make sure to read the data to unlock them,
and then free them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3dd13ce45fef..ced016a221ca 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2818,8 +2818,13 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 		}
 	} while (next_cpu >= 0 && ret >= 0);
 
-	for (cpu = 0; cpu < handle->max_cpu; cpu++)
-		tracecmd_free_record(records[cpu]);
+	/* Need to unlock and free the records */
+	for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+		if (!records[cpu])
+			continue;
+		record = tracecmd_read_data(handle, cpu);
+		tracecmd_free_record(record);
+	}
 
 	free(records);
 
@@ -2909,6 +2914,19 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 
 	} while (next_cpu >= 0 && ret >= 0);
 
+	/* Unlock and free the records */
+	for (cpu = 0; cpu < all_cpus; cpu++) {
+		int local_cpu;
+
+		if (!records[cpu].record)
+			continue;
+
+		handle = records[cpu].handle;
+		local_cpu = cpu - handle->start_cpu;
+		record = tracecmd_read_data(handle, local_cpu);
+		tracecmd_free_record(record);
+	}
+
 	/*
 	 * The records array contains only records that were taken via
 	 * tracecmd_peek_data(), and do not need to be freed.
-- 
2.39.2

