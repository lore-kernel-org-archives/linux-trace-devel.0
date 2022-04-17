Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825D2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 01:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiDQBWk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 16 Apr 2022 21:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiDQBWi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 16 Apr 2022 21:22:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB462E698
        for <linux-trace-devel@vger.kernel.org>; Sat, 16 Apr 2022 18:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D121DB80A3B
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 01:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70089C385A8;
        Sun, 17 Apr 2022 01:20:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfta4-004Fih-8h;
        Sat, 16 Apr 2022 21:20:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 7/8] trace-cmd: Add print helpers to show connections
Date:   Sat, 16 Apr 2022 21:19:57 -0400
Message-Id: <20220417011958.1013591-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417011958.1013591-1-rostedt@goodmis.org>
References: <20220417011958.1013591-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add helper functions trace_net_print_connection() and
trace_vsock_print_connection() to print the host/port or cid/port that
has connected.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  6 ++++++
 tracecmd/trace-agent.c         | 14 ++++++++++++++
 tracecmd/trace-listen.c        | 22 ++++++++++++++++++++++
 tracecmd/trace-vsock.c         | 20 ++++++++++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index bde3bcd8ab2c..02839e37eb2d 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -311,6 +311,7 @@ extern struct buffer_instance *first_instance;
 
 int trace_net_make(int port, enum port_type type);
 int trace_net_search(int start_port, int *sfd, enum port_type type);
+int trace_net_print_connection(int fd);
 
 struct buffer_instance *allocate_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
@@ -366,6 +367,7 @@ int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid);
 int trace_vsock_get_port(int sd, unsigned int *port);
 bool trace_vsock_can_splice_read(void);
 int trace_vsock_local_cid(void);
+int trace_vsock_print_connection(int fd);
 #else
 static inline int trace_vsock_open(unsigned int cid, unsigned int port)
 {
@@ -404,6 +406,10 @@ static inline int trace_vsock_local_cid(void)
 {
 	return -ENOTSUP;
 }
+static inline int trace_vsock_print_connection(int fd)
+{
+	return -1;
+}
 #endif /* VSOCK */
 
 /* No longer in event-utils.h */
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 819ac016612f..59cecae770a6 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -109,6 +109,18 @@ static char *get_clock(int argc, char **argv)
 	return NULL;
 }
 
+static void trace_print_connection(int fd, bool network)
+{
+	int ret;
+
+	if (network)
+		ret = trace_net_print_connection(fd);
+	else
+		ret = trace_vsock_print_connection(fd);
+	if (ret < 0)
+		tracecmd_debug("Could not print connection fd:%d\n", fd);
+}
+
 static void agent_handle(int sd, int nr_cpus, int page_size, bool network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
@@ -273,6 +285,8 @@ static void agent_serve(unsigned int port, bool do_daemon, bool network)
 				continue;
 			die("accept");
 		}
+		if (tracecmd_get_debug())
+			trace_print_connection(cd, network);
 
 		if (handler_pid)
 			goto busy;
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 3b446acea972..b7be761d032e 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -756,6 +756,28 @@ static int do_fork(int cfd)
 	return 0;
 }
 
+int trace_net_print_connection(int fd)
+{
+	char host[NI_MAXHOST], service[NI_MAXSERV];
+	struct sockaddr_storage net_addr;
+	socklen_t addr_len;
+
+	addr_len = sizeof(net_addr);
+	if (getpeername(fd, (struct sockaddr *)&net_addr, &addr_len))
+		return -1;
+
+	if (getnameinfo((struct sockaddr *)&net_addr, addr_len,
+			host, NI_MAXHOST,
+			service, NI_MAXSERV, NI_NUMERICSERV))
+		return -1;
+
+	if (tracecmd_get_debug())
+		tracecmd_debug("Connected to %s:%s fd:%d\n", host, service, fd);
+	else
+		tracecmd_plog("Connected to %s:%s\n", host, service);
+	return 0;
+}
+
 static int do_connection(int cfd, struct sockaddr *addr,
 			  socklen_t addr_len)
 {
diff --git a/tracecmd/trace-vsock.c b/tracecmd/trace-vsock.c
index d18ecb45004e..39294e7a2a3c 100644
--- a/tracecmd/trace-vsock.c
+++ b/tracecmd/trace-vsock.c
@@ -94,6 +94,26 @@ int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
 	return 0;
 }
 
+int trace_vsock_print_connection(int fd)
+{
+	struct sockaddr_vm vm_addr;
+	socklen_t addr_len;
+	int cid, port;
+
+	addr_len = sizeof(vm_addr);
+	if (getpeername(fd, (struct sockaddr *)&vm_addr, &addr_len))
+		return -1;
+	if (vm_addr.svm_family != AF_VSOCK)
+		return -1;
+	cid = vm_addr.svm_cid;
+	port = vm_addr.svm_port;
+	if (tracecmd_get_debug())
+		tracecmd_debug("Connected to @%u:%u fd:%d\n", cid, port, fd);
+	else
+		tracecmd_plog("Connected to @%u:%u\n", cid, port);
+	return 0;
+}
+
 static int try_splice_read_vsock(void)
 {
 	int ret, sd, brass[2];
-- 
2.35.1

