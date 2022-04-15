Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DA9C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243703AbiDOBC5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348326AbiDOBCi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:02:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3DC27CCC
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25FF5B82BEF
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA437C385A1;
        Fri, 15 Apr 2022 01:00:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfAJk-003w8a-OO;
        Thu, 14 Apr 2022 21:00:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/8] trace-cmd library: Remove vsocket dependency on P2P protocol
Date:   Thu, 14 Apr 2022 21:00:02 -0400
Message-Id: <20220415010007.938408-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415010007.938408-1-rostedt@goodmis.org>
References: <20220415010007.938408-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The P2P protocol can work with network connections as well. To allow
network agents, remove the dependency on cid ids, and just call them
local and remote ids.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/trace-tsync-local.h |  6 +++---
 lib/trace-cmd/trace-timesync-ptp.c        | 24 +++++++++++------------
 lib/trace-cmd/trace-timesync.c            |  6 +++---
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index d0f82f5d0916..4340dfaf80ca 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -49,9 +49,9 @@ struct clock_sync_context {
 							 * calculated offsets per CPU
 							 */
 
-	/* Identifiers of local and remote time sync peers: cid and port */
-	unsigned int			local_cid;
-	unsigned int			remote_cid;
+	/* Identifiers of local and remote time sync peers */
+	unsigned int			local_id;
+	unsigned int			remote_id;
 };
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index 4f7805627259..0e23ff83869a 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -100,8 +100,8 @@ struct ptp_markers_context {
 };
 
 struct ptp_marker_buf {
-	int local_cid;
-	int remote_cid;
+	int local_id;
+	int remote_id;
 	int count;
 	int packet_id;
 } __packed;
@@ -163,7 +163,7 @@ static int ptp_clock_sync_init(struct tracecmd_time_sync *tsync)
 		char buff[256];
 		int res_fd;
 
-		sprintf(buff, "res-cid%d.txt", clock_context->remote_cid);
+		sprintf(buff, "res-id%d.txt", clock_context->remote_id);
 
 		res_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
 		if (res_fd > 0)
@@ -247,8 +247,8 @@ static int ptp_marker_find(struct tep_event *event, struct tep_record *record,
 		return 0;
 	if (record->size >= (ctx->ptp->id->offset + sizeof(struct ptp_marker))) {
 		marker = (struct ptp_marker *)(record->data + ctx->ptp->id->offset);
-		if (marker->data.local_cid == ctx->clock->local_cid &&
-		    marker->data.remote_cid == ctx->clock->remote_cid &&
+		if (marker->data.local_id == ctx->clock->local_id &&
+		    marker->data.remote_id == ctx->clock->remote_id &&
 		    marker->series_id == ctx->ptp->series_id &&
 		    marker->data.count)
 			ptp_probe_store(ctx, marker, record->ts);
@@ -460,8 +460,8 @@ static int ptp_clock_client(struct tracecmd_time_sync *tsync,
 	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
 					  PTP_SYNC_PKT_START, sizeof(start),
 					  (char *)&start);
-	marker.data.local_cid = clock_context->local_cid;
-	marker.data.remote_cid = clock_context->remote_cid;
+	marker.data.local_id = clock_context->local_id;
+	marker.data.remote_id = clock_context->remote_id;
 	marker.series_id = ntohl(start.series_id);
 	marker.data.packet_id = 'r';
 	ptp->series_id = marker.series_id;
@@ -566,8 +566,8 @@ static int ptp_clock_server(struct tracecmd_time_sync *tsync,
 	tracefs_instance_file_write(clock_context->instance, "trace", "\0");
 
 	ptp->series_id++;
-	marker.data.local_cid = clock_context->local_cid;
-	marker.data.remote_cid = clock_context->remote_cid;
+	marker.data.local_id = clock_context->local_id;
+	marker.data.remote_id = clock_context->remote_id;
 	marker.series_id = ptp->series_id;
 	msg = (char *)&msg_ret;
 	size = sizeof(msg_ret);
@@ -627,7 +627,7 @@ static int ptp_clock_server(struct tracecmd_time_sync *tsync,
 		char buff[256];
 		int res_fd;
 
-		sprintf(buff, "res-cid%d.txt", clock_context->remote_cid);
+		sprintf(buff, "res-id%d.txt", clock_context->remote_id);
 
 		res_fd = open(buff, O_WRONLY|O_APPEND, 0644);
 		if (res_fd > 0) {
@@ -681,8 +681,8 @@ static int ptp_clock_sync_calc(struct tracecmd_time_sync *tsync,
 		ptp = (struct ptp_clock_sync *)clock_context->proto_data;
 		if (ptp->debug_fd > 0)
 			close(ptp->debug_fd);
-		sprintf(buff, "s-cid%d_%d.txt",
-				clock_context->remote_cid, ptp->series_id+1);
+		sprintf(buff, "s-id%d_%d.txt",
+				clock_context->remote_id, ptp->series_id+1);
 		ptp->debug_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
 	}
 #endif
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 514d333e57a7..594f660e2a40 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -498,12 +498,12 @@ static int clock_context_init(struct tracecmd_time_sync *tsync,
 	clock->is_guest = guest;
 	clock->is_server = clock->is_guest;
 
-	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_cid,
-			       &clock->remote_cid))
+	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_id,
+			       &clock->remote_id))
 		goto error;
 
 	clock->instance = clock_synch_create_instance(tsync->clock_str,
-						      clock->remote_cid);
+						      clock->remote_id);
 	if (!clock->instance)
 		goto error;
 
-- 
2.35.1

