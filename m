Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F363CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 05:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiKJFdi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 00:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiKJFde (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 00:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC105FE6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 21:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 565E061D84
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 05:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E353C433C1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 05:33:28 +0000 (UTC)
Date:   Thu, 10 Nov 2022 00:33:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd Library: Update record after callback in
 iterators
Message-ID: <20221110003325.007663c7@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function graph plugin will look at the next event and may even
increment it if it is a leaf function. The current iterators update the
next record before the callback. This leaves them vulnerable to
corruption if the callback updates to the next record like function
graph plugin does.

Peek at the next record after the callback to ensure that the next
record is the one that will be used for the next iterator.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index aa54e7fa..594eb74a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2810,11 +2810,11 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 		if (next_cpu >= 0) {
 			/* Need to call read_data to increment to the next record */
 			record = tracecmd_read_data(handle, next_cpu);
-			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
 
 			ret = call_callbacks(handle, record, next_cpu,
 					     callback, callback_data);
 
+			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
 			tracecmd_free_record(record);
 		}
 	} while (next_cpu >= 0 && ret >= 0);
@@ -2900,12 +2900,12 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 			cpu = next_cpu - handle->start_cpu;
 			/* Need to call read_data to increment to the next record */
 			record = tracecmd_read_data(handle, cpu);
-			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
 
 			ret = call_callbacks(handle, record, next_cpu,
 					     callback, callback_data);
 
 			tracecmd_free_record(record);
+			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
 		}
 
 	} while (next_cpu >= 0 && ret >= 0);
-- 
2.35.1

