Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6020C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Apr 2022 17:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiDFRsQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240086AbiDFRsD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Apr 2022 13:48:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8B12560FE
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Apr 2022 08:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB7E4B821EC
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Apr 2022 15:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDB3C385A1
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Apr 2022 15:56:40 +0000 (UTC)
Date:   Wed, 6 Apr 2022 11:56:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library; Do not free pthread items from agent
Message-ID: <20220406115638.44303e6a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The agent creates a tsync to synchronize with the host as well as the host
synchronizing with the guest. The host uses pthread synchronization items
(mutex, cond and barrier) to synchronize its tracing threads as it needs
to retrieve the data that is produced from them.

While debugging the agent, the forked connection would always fail with a
SIGFPE, Arithmetic exception. This was caused by calling
pthread_barrier_destroy() against a barrier that never was initialized.

Since the pthread_mutex, pthread_cond, and pthread_barriers are only
initialized by the host, skip the freeing of them (which both the host and
guest call the same function to free: tracecmd_tsync_free()), if the
guest_id is zero.

Fixes: 3c2d7f97245f1 ("trace-cmd: Wait for first time sync before the trace")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index f8ec15a3fdbc..beaa87d1a065 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -583,9 +583,13 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	if (tsync->msg_handle)
 		tracecmd_msg_handle_close(tsync->msg_handle);
 
-	pthread_mutex_destroy(&tsync->lock);
-	pthread_cond_destroy(&tsync->cond);
-	pthread_barrier_destroy(&tsync->first_sync);
+	/* These are only created from the host */
+	if (tsync->guest_pid) {
+		pthread_mutex_destroy(&tsync->lock);
+		pthread_cond_destroy(&tsync->cond);
+		pthread_barrier_destroy(&tsync->first_sync);
+	}
+
 	free(tsync->clock_str);
 	free(tsync->proto_name);
 	free(tsync);
-- 
2.35.1

