Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B50DAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jul 2022 23:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbiGGXHb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbiGGXHa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 19:07:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FCB4D4FC
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 16:07:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E195F6252C
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 23:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BFBC3411E
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 23:07:28 +0000 (UTC)
Date:   Thu, 7 Jul 2022 19:07:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Move clock_context_init() out of pthreads
Message-ID: <20220707190726.3f1c6b4d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the clock_context_init() fails, it can cause the communications between
the host and guest to hang without any clue to why it happened. I spent
several hours debugging this.

There's no reason that the clock_context_init() needs to be called in the
pthread. Do that before creating the threads, and move the proto into the
tsync structure itself.

Now when it fails, more can be known at the time it happens.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/trace-tsync-local.h |  3 ++
 lib/trace-cmd/trace-timesync.c            | 36 ++++++++++-------------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 5bbc1db622c4..27baa593e6cf 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -8,6 +8,8 @@
 
 #include <stdbool.h>
 
+struct tsync_proto;
+
 struct tracecmd_time_sync {
 	pthread_t			thread;
 	bool				thread_running;
@@ -19,6 +21,7 @@ struct tracecmd_time_sync {
 	pthread_barrier_t		first_sync;
 	char				*clock_str;
 	struct tracecmd_msg_handle	*msg_handle;
+	struct tsync_proto		*proto;
 	void				*context;
 	int				guest_pid;
 	int				vcpu_count;
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 8d4e977f3a85..bc6430983a96 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -382,8 +382,7 @@ clock_synch_delete_instance(struct tracefs_instance *inst)
 	tracefs_instance_free(inst);
 }
 
-static int clock_context_init(struct tracecmd_time_sync *tsync,
-			      struct tsync_proto **proto, bool guest)
+static int clock_context_init(struct tracecmd_time_sync *tsync, bool guest)
 {
 	struct clock_sync_context *clock = NULL;
 	struct tsync_proto *protocol;
@@ -417,7 +416,7 @@ static int clock_context_init(struct tracecmd_time_sync *tsync,
 	if (protocol->clock_sync_init && protocol->clock_sync_init(tsync) < 0)
 		goto error;
 
-	*proto = protocol;
+	tsync->proto = protocol;
 
 	return 0;
 error:
@@ -539,9 +538,9 @@ static void restore_pin_to_cpu(cpu_set_t *mask)
 	CPU_FREE(mask);
 }
 
-static int tsync_send(struct tracecmd_time_sync *tsync,
-		      struct tsync_proto *proto, unsigned int cpu)
+static int tsync_send(struct tracecmd_time_sync *tsync, unsigned int cpu)
 {
+	struct tsync_proto *proto = tsync->proto;
 	cpu_set_t *old_set = NULL;
 	long long timestamp = 0;
 	long long scaling = 0;
@@ -561,16 +560,11 @@ static void tsync_with_host(struct tracecmd_time_sync *tsync)
 {
 	char protocol[TRACECMD_TSYNC_PNAME_LENGTH];
 	struct tsync_probe_request_msg probe;
-	struct tsync_proto *proto;
 	unsigned int command;
 	unsigned int size;
 	char *msg;
 	int ret;
 
-	clock_context_init(tsync, &proto, true);
-	if (!tsync->context)
-		return;
-
 	msg = (char *)&probe;
 	size = sizeof(probe);
 	while (true) {
@@ -582,7 +576,7 @@ static void tsync_with_host(struct tracecmd_time_sync *tsync)
 		if (ret || strncmp(protocol, TRACECMD_TSYNC_PROTO_NONE, TRACECMD_TSYNC_PNAME_LENGTH) ||
 		    command != TRACECMD_TIME_SYNC_CMD_PROBE)
 			break;
-		ret = tsync_send(tsync, proto, probe.cpu);
+		ret = tsync_send(tsync, probe.cpu);
 		if (ret)
 			break;
 	}
@@ -630,8 +624,9 @@ static int record_sync_sample(struct clock_sync_offsets *offsets, int array_step
 }
 
 static int tsync_get_sample(struct tracecmd_time_sync *tsync, unsigned int cpu,
-			    struct tsync_proto *proto, int array_step)
+			    int array_step)
 {
+	struct tsync_proto *proto = tsync->proto;
 	struct clock_sync_context *clock;
 	long long timestamp = 0;
 	long long scaling = 0;
@@ -672,19 +667,12 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 {
 	struct tsync_probe_request_msg probe;
 	int ts_array_size = CLOCK_TS_ARRAY;
-	struct tsync_proto *proto;
 	struct timespec timeout;
 	bool first = true;
 	bool end = false;
 	int ret;
 	int i;
 
-	clock_context_init(tsync, &proto, false);
-	if (!tsync->context) {
-		pthread_barrier_wait(&tsync->first_sync);
-		return -1;
-	}
-
 	if (tsync->loop_interval > 0 &&
 	    tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
 		ts_array_size = (CLOCK_TS_ARRAY * 1000) / tsync->loop_interval;
@@ -697,7 +685,7 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 							  TRACECMD_TSYNC_PROTO_NONE,
 							  TRACECMD_TIME_SYNC_CMD_PROBE,
 							  sizeof(probe), (char *)&probe);
-			ret = tsync_get_sample(tsync, i, proto, ts_array_size);
+			ret = tsync_get_sample(tsync, i, ts_array_size);
 			if (ret)
 				break;
 		}
@@ -793,6 +781,10 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
 
+	clock_context_init(tsync, false);
+	if (!tsync->context)
+		goto error;
+
 	ret = pthread_create(&tsync->thread, &attrib, tsync_host_thread, tsync);
 	if (ret)
 		goto error;
@@ -983,6 +975,10 @@ tracecmd_tsync_with_host(int fd, const char *proto, const char *clock,
 	tsync->vcpu_count = tracecmd_count_cpus();
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
 
+	clock_context_init(tsync, true);
+	if (!tsync->context)
+		goto error;
+
 	ret = pthread_create(&tsync->thread, &attrib, tsync_agent_thread, tsync);
 	if (ret) {
 		pthread_attr_destroy(&attrib);
-- 
2.35.1

