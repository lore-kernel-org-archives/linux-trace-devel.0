Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3987BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0580A61057
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhCaXHm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 19:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232271AbhCaXH3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B32361075
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 23:07:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRjvs-003g6c-FG
        for linux-trace-devel@vger.kernel.org; Wed, 31 Mar 2021 19:07:28 -0400
Message-ID: <20210331230728.350421194@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 31 Mar 2021 19:06:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Do not free tsync from thread
References: <20210331230610.035418770@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The freeing of an object should happen in the same context as where it is
created. The tsync object is created in the main thread and passed to the
guest and host handling threads. It should be closed and freed by the thread
that created it, especially since that thread accesses the tsync object
after creating the thread. Having the created thread free it would cause all
sorts of dangerous race conditions.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 24984fb17dab..ba877f701c85 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -535,6 +535,10 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 		tsync_context->sync_count = 0;
 		tsync_context->sync_size = 0;
 	}
+
+	if (tsync->msg_handle)
+		tracecmd_msg_handle_close(tsync->msg_handle);
+
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
 	pthread_barrier_destroy(&tsync->first_sync);
@@ -703,9 +707,6 @@ static void *tsync_host_thread(void *data)
 	struct tracecmd_time_sync *tsync = data;
 
 	tsync_with_guest(tsync);
-	tracecmd_msg_handle_close(tsync->msg_handle);
-	tsync->msg_handle = NULL;
-
 	pthread_exit(0);
 }
 
@@ -868,6 +869,7 @@ int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync)
 static void *tsync_agent_thread(void *data)
 {
 	struct tracecmd_time_sync *tsync = data;
+	long ret = 0;
 	int sd;
 
 	while (true) {
@@ -875,6 +877,7 @@ static void *tsync_agent_thread(void *data)
 		if (sd < 0) {
 			if (errno == EINTR)
 				continue;
+			ret = -1;
 			goto out;
 		}
 		break;
@@ -885,11 +888,7 @@ static void *tsync_agent_thread(void *data)
 	tsync_with_host(tsync);
 
 out:
-	tracecmd_msg_handle_close(tsync->msg_handle);
-	tracecmd_tsync_free(tsync);
-	close(sd);
-
-	pthread_exit(0);
+	pthread_exit((void *)ret);
 }
 
 /**
-- 
2.30.1


