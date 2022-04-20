Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9E0C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380069AbiDTP3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380234AbiDTP33 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:29:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9897345AE8
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4695BB81FE6
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 15:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF32FC385AE;
        Wed, 20 Apr 2022 15:26:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nhCE2-0003RY-KE;
        Wed, 20 Apr 2022 11:26:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 06/11] trace-cmd: Add debug prints for network connections
Date:   Wed, 20 Apr 2022 11:26:32 -0400
Message-Id: <20220420152637.13105-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420152637.13105-1-rostedt@goodmis.org>
References: <20220420152637.13105-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To help debug the network agent and listener, add some debug prints that
are enabled when --debug option is used.

Link: https://lore.kernel.org/linux-trace-devel/20220417184538.1044417-7-rostedt@goodmis.org

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 2 ++
 tracecmd/trace-agent.c         | 3 +++
 tracecmd/trace-listen.c        | 4 ++++
 tracecmd/trace-record.c        | 9 +++++++++
 4 files changed, 18 insertions(+)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 14cf20c870cb..cc44af38e8ad 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -925,7 +925,9 @@ static void *tsync_agent_thread(void *data)
 	int sd;
 
 	while (true) {
+		tracecmd_debug("Listening on fd:%d\n", tsync->msg_handle->fd);
 		sd = accept(tsync->msg_handle->fd, NULL, NULL);
+		tracecmd_debug("Accepted fd:%d\n", sd);
 		if (sd < 0) {
 			if (errno == EINTR)
 				continue;
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index cd201ad948ad..819ac016612f 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -22,6 +22,8 @@
 #include "trace-local.h"
 #include "trace-msg.h"
 
+#define dprint(fmt, ...)	tracecmd_debug(fmt, ##__VA_ARGS__)
+
 static void make_vsocks(int nr, int *fds, unsigned int *ports)
 {
 	unsigned int port;
@@ -55,6 +57,7 @@ static void make_net(int nr, int *fds, unsigned int *ports)
 			die("Failed to listen on port %d\n", port);
 		fds[i] = fd;
 		ports[i] = port;
+		dprint("CPU[%d]: fd:%d port:%d\n", i, fd, port);
 		start_port = port + 1;
 	}
 }
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 8476fa51dadd..3b446acea972 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -26,6 +26,8 @@
 #include "trace-local.h"
 #include "trace-msg.h"
 
+#define dprint(fmt, ...)	tracecmd_debug(fmt, ##__VA_ARGS__)
+
 #define MAX_OPTION_SIZE 4096
 
 #define _VAR_DIR_Q(dir)		#dir
@@ -279,6 +281,8 @@ int trace_net_make(int port, enum port_type type)
 	if (rp == NULL)
 		return -1;
 
+	dprint("Create listen port: %d fd:%d\n", port, sd);
+
 	return sd;
 }
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index dfcf3d494053..9c930920c89e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -56,6 +56,8 @@
 #define FUNC_STACK_TRACE "func_stack_trace"
 #define TSC_CLOCK	"x86-tsc"
 
+#define dprint(fmt, ...)	tracecmd_debug(fmt, ##__VA_ARGS__)
+
 enum trace_type {
 	TRACE_TYPE_RECORD	= 1,
 	TRACE_TYPE_START	= (1 << 1),
@@ -3139,6 +3141,9 @@ static struct addrinfo *do_getaddrinfo(const char *host, unsigned int port,
 		return NULL;
 	}
 
+	dprint("Attached port %s: %d to results: %p\n",
+	       type == USE_TCP ? "TCP" : "UDP", port, results);
+
 	return results;
 }
 
@@ -3160,6 +3165,8 @@ static int connect_addr(struct addrinfo *results)
 	if (rp == NULL)
 		return -1;
 
+	dprint("connect results: %p with fd: %d\n", results, sfd);
+
 	return sfd;
 }
 
@@ -3193,7 +3200,9 @@ static int do_accept(int sd)
 	int cd;
 
 	for (;;) {
+		dprint("Wait on accept: %d\n", sd);
 		cd = accept(sd, NULL, NULL);
+		dprint("accepted: %d\n", cd);
 		if (cd < 0) {
 			if (errno == EINTR)
 				continue;
-- 
2.35.1

