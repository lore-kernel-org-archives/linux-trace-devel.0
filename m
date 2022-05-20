Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A6FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 May 2022 00:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbiETAne (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 May 2022 20:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbiETAne (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 May 2022 20:43:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7DD1312AC
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 May 2022 17:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7C84B827DA
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 May 2022 00:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C001C385AA
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 May 2022 00:43:30 +0000 (UTC)
Date:   Thu, 19 May 2022 20:43:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd time-sync: Pass role to
 tracecmd_tsync_get_proto()
Message-ID: <20220519204328.534a1f30@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the agent is a proxy server (host), then it should not pick the kvm
protocol if it can not find the kvm offset and multiplier. If it does, it
will fail the sync on the agent side which locks up the recorder side
which will still run.

This also shows how fragile the tsync code is but that is another project
to have fixed.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Based on top of:
   https://lore.kernel.org/all/20220514024756.1319681-1-rostedt@goodmis.org/

 lib/trace-cmd/include/private/trace-cmd-private.h | 2 +-
 lib/trace-cmd/trace-timesync.c                    | 5 ++---
 tracecmd/trace-agent.c                            | 6 ++++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 5606e132cba1..d73a51914c42 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -530,7 +530,7 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
 			       int *count, long long **ts,
 			       long long **offsets, long long **scalings, long long **frac);
 const char *tracecmd_tsync_get_proto(const struct tracecmd_tsync_protos *protos,
-			 const char *clock);
+			 const char *clock, enum tracecmd_time_sync_role role);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index e192a74a1974..8d4e977f3a85 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -250,10 +250,9 @@ tsync_proto_select(const struct tracecmd_tsync_protos *protos,
  */
 __hidden const char *
 tracecmd_tsync_get_proto(const struct tracecmd_tsync_protos *protos,
-			 const char *clock)
+			 const char *clock, enum tracecmd_time_sync_role role)
 {
-	return tsync_proto_select(protos, clock,
-				  TRACECMD_TIME_SYNC_ROLE_GUEST);
+	return tsync_proto_select(protos, clock, role);
 }
 
 /**
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index ea41ad540701..23483295ed5a 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -157,6 +157,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
 	unsigned long long peer_trace_id;
 	unsigned long long trace_id;
 	unsigned long flags = rcid >= 0 ? TRACECMD_MSG_FL_PROXY : 0;
+	enum tracecmd_time_sync_role tsync_role = TRACECMD_TIME_SYNC_ROLE_GUEST;
 	unsigned int remote_id;
 	unsigned int local_id;
 	unsigned int tsync_port = 0;
@@ -180,6 +181,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
 		die("Failed to allocate message handle");
 
 	if (rcid >= 0) {
+		tsync_role = TRACECMD_TIME_SYNC_ROLE_HOST;
 		ret = tracecmd_msg_recv_trace_proxy(msg_handle, &argc, &argv,
 						    &use_fifos, &peer_trace_id,
 						    &tsync_protos,
@@ -197,8 +199,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
 	if (ret < 0)
 		die("Failed to receive trace request");
 
-	tsync_proto = tracecmd_tsync_get_proto(tsync_protos,
-					       get_clock(argc, argv));
+	tsync_proto = tracecmd_tsync_get_proto(tsync_protos, get_clock(argc, argv),
+					       tsync_role);
 
 	if (use_fifos && open_agent_fifos(nr_cpus, fds))
 		use_fifos = false;
-- 
2.35.1

