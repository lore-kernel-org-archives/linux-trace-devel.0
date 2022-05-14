Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04CDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiENCze (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E5534A72F
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34E1461DF7
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95CFC341D1;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XNX-QM;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 25/26] trace-cmd: Have the guest structure hold guest trace_id
Date:   Fri, 13 May 2022 22:47:55 -0400
Message-Id: <20220514024756.1319681-26-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have the guest structure hold the guest's trace_id and also use the guest
structure for the CPU counts in mapping the guest CPUs to pids. For the
agent proxy, the instance will be of the host and not the guest, so it
makes more sense to use the guest structure instead.

Also clean up the trace_add_guest_info() call where the network uses the
instance, and the cpus use the max cpus.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-agent.c         | 10 ++++++++--
 tracecmd/trace-vm.c            | 30 +++++++++++++++++++++---------
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 295be5dda7b5..a86d22ca9ad8 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -335,6 +335,7 @@ void show_options(const char *prefix, struct buffer_instance *buffer);
 struct trace_guest {
 	struct tracefs_instance *instance;
 	char *name;
+	unsigned long long trace_id;
 	int cid;
 	int pid;
 	int cpu_max;
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 4430cb5506ff..3098a1ea2b8b 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -153,6 +153,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
 	struct tracecmd_time_sync *tsync = NULL;
 	struct tracecmd_msg_handle *msg_handle;
 	const char *tsync_proto = NULL;
+	struct trace_guest *guest;
 	unsigned long long peer_trace_id;
 	unsigned long long trace_id;
 	unsigned long flags = rcid >= 0 ? TRACECMD_MSG_FL_PROXY : 0;
@@ -178,16 +179,21 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
-	if (rcid >= 0)
+	if (rcid >= 0) {
 		ret = tracecmd_msg_recv_trace_proxy(msg_handle, &argc, &argv,
 						    &use_fifos, &peer_trace_id,
 						    &tsync_protos,
 						    &client_cpus,
 						    &guests);
-	else
+		/* Update the guests peer_trace_id */
+		guest = trace_get_guest(rcid, NULL);
+		if (guest)
+			guest->trace_id = peer_trace_id;
+	} else {
 		ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
 						  &use_fifos, &peer_trace_id,
 						  &tsync_protos);
+	}
 	if (ret < 0)
 		die("Failed to receive trace request");
 
diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 84f28824e3c5..09bd60259258 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -434,26 +434,39 @@ int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
 void
 trace_add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
+	unsigned long long trace_id;
 	struct trace_guest *guest;
 	const char *name;
 	char *buf, *p;
+	int cpus;
 	int size;
 	int pid;
 	int i;
 
 	if (is_network(instance)) {
 		name = instance->name;
+		cpus = instance->cpu_count;
+		trace_id = instance->trace_id;
 	} else {
 		guest = trace_get_guest(instance->cid, NULL);
 		if (!guest)
 			return;
+		cpus = guest->cpu_max;
 		name = guest->name;
+		/*
+		 * If this is a proxy, the trace_id of the guest is
+		 * in the guest descriptor (added in trace_tsync_as_host().
+		 */
+		if (guest->trace_id)
+			trace_id = guest->trace_id;
+		else
+			trace_id = instance->trace_id;
 	}
 
 	size = strlen(name) + 1;
 	size += sizeof(long long);	/* trace_id */
 	size += sizeof(int);		/* cpu count */
-	size += instance->cpu_count * 2 * sizeof(int);	/* cpu,pid pair */
+	size += cpus * 2 * sizeof(int);	/* cpu,pid pair */
 
 	buf = calloc(1, size);
 	if (!buf)
@@ -462,17 +475,16 @@ trace_add_guest_info(struct tracecmd_output *handle, struct buffer_instance *ins
 	strcpy(p, name);
 	p += strlen(name) + 1;
 
-	memcpy(p, &instance->trace_id, sizeof(long long));
+	memcpy(p, &trace_id, sizeof(long long));
 	p += sizeof(long long);
 
-	memcpy(p, &instance->cpu_count, sizeof(int));
+	memcpy(p, &cpus, sizeof(int));
 	p += sizeof(int);
-	for (i = 0; i < instance->cpu_count; i++) {
-		pid = -1;
-		if (!is_network(instance)) {
-			if (i < guest->cpu_max)
-				pid = guest->cpu_pid[i];
-		}
+	for (i = 0; i < cpus; i++) {
+		if (is_network(instance))
+			pid = -1;
+		else
+			pid = guest->cpu_pid[i];
 		memcpy(p, &i, sizeof(int));
 		p += sizeof(int);
 		memcpy(p, &pid, sizeof(int));
-- 
2.35.1

