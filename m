Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AA3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348442AbiDOBM6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348438AbiDOBM5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:12:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C0E4D277
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85AC1B82BEF
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBADC385AA;
        Fri, 15 Apr 2022 01:10:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfATg-003wEq-DX;
        Thu, 14 Apr 2022 21:10:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/5] trace-cmd listen: Replace bool use_tcp with enum type
Date:   Thu, 14 Apr 2022 21:10:20 -0400
Message-Id: <20220415011023.938663-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415011023.938663-1-rostedt@goodmis.org>
References: <20220415011023.938663-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To allow listen to use vsockets as a connection interface, using a
boolean "use_tcp" is not flexible enough, as now there are three kinds
of connections. In preparation for adding vsockets have trace-cmd listen
use an enum instead of a boolean.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  5 +++++
 tracecmd/trace-listen.c        | 27 +++++++++++++++------------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index ac864c70be11..d589dfa54edc 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -42,6 +42,11 @@ extern int show_status;
 
 int trace_set_verbose(char *level);
 
+enum port_type {
+	USE_UDP,
+	USE_TCP,
+};
+
 struct pid_record_data {
 	int			pid;
 	int			brass[2];
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index b2ab05bc3068..a5d4ec64f77c 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -138,7 +138,7 @@ static void remove_pid_file(void)
 }
 
 static int process_child(int sfd, const char *host, const char *port,
-			 int cpu, int page_size, int use_tcp)
+			 int cpu, int page_size, enum port_type type)
 {
 	struct sockaddr_storage peer_addr;
 	socklen_t peer_addr_len;
@@ -160,7 +160,7 @@ static int process_child(int sfd, const char *host, const char *port,
 	if (fd < 0)
 		pdie("creating %s", tempfile);
 
-	if (use_tcp) {
+	if (type == USE_TCP) {
 		if (listen(sfd, backlog) < 0)
 			pdie("listen");
 		peer_addr_len = sizeof(peer_addr);
@@ -184,7 +184,7 @@ static int process_child(int sfd, const char *host, const char *port,
 		if (!r)
 			break;
 		/* UDP requires that we get the full size in one go */
-		if (!use_tcp && r < page_size && !once) {
+		if (type == USE_UDP && r < page_size && !once) {
 			once = 1;
 			warning("read %d bytes, expected %d", r, page_size);
 		}
@@ -205,7 +205,7 @@ static int process_child(int sfd, const char *host, const char *port,
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
-static int bind_a_port(int start_port, int *sfd, int use_tcp)
+static int bind_a_port(int start_port, int *sfd, enum port_type type)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
@@ -218,7 +218,7 @@ static int bind_a_port(int start_port, int *sfd, int use_tcp)
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = use_tcp ? SOCK_STREAM : SOCK_DGRAM;
+	hints.ai_socktype = type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
 	hints.ai_flags = AI_PASSIVE;
 
 	s = getaddrinfo(NULL, buf, &hints, &result);
@@ -250,7 +250,7 @@ static int bind_a_port(int start_port, int *sfd, int use_tcp)
 }
 
 static void fork_reader(int sfd, const char *node, const char *port,
-			int *pid, int cpu, int pagesize, int use_tcp)
+			int *pid, int cpu, int pagesize, enum port_type type)
 {
 	int ret;
 
@@ -260,7 +260,7 @@ static void fork_reader(int sfd, const char *node, const char *port,
 		pdie("creating reader");
 
 	if (!*pid) {
-		ret = process_child(sfd, node, port, cpu, pagesize, use_tcp);
+		ret = process_child(sfd, node, port, cpu, pagesize, type);
 		if (ret < 0)
 			pdie("Problem with reader %d", ret);
 	}
@@ -269,7 +269,7 @@ static void fork_reader(int sfd, const char *node, const char *port,
 }
 
 static int open_port(const char *node, const char *port, int *pid,
-		     int cpu, int pagesize, int start_port, int use_tcp)
+		     int cpu, int pagesize, int start_port, enum port_type type)
 {
 	int sfd;
 	int num_port;
@@ -278,11 +278,11 @@ static int open_port(const char *node, const char *port, int *pid,
 	 * bind_a_port() currently does not return an error, but if that
 	 * changes in the future, we have a check for it now.
 	 */
-	num_port = bind_a_port(start_port, &sfd, use_tcp);
+	num_port = bind_a_port(start_port, &sfd, type);
 	if (num_port < 0)
 		return num_port;
 
-	fork_reader(sfd, node, port, pid, cpu, pagesize, use_tcp);
+	fork_reader(sfd, node, port, pid, cpu, pagesize, type);
 
 	return num_port;
 }
@@ -463,7 +463,7 @@ static void destroy_all_readers(int cpus, int *pid_array, const char *node,
 static int *create_all_readers(const char *node, const char *port,
 			       int pagesize, struct tracecmd_msg_handle *msg_handle)
 {
-	int use_tcp = msg_handle->flags & TRACECMD_MSG_FL_USE_TCP;
+	enum port_type port_type = USE_UDP;
 	char buf[BUFSIZ];
 	unsigned int *port_array;
 	int *pid_array;
@@ -476,6 +476,9 @@ static int *create_all_readers(const char *node, const char *port,
 	if (!pagesize)
 		return NULL;
 
+	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP)
+		port_type = USE_TCP;
+
 	port_array = malloc(sizeof(*port_array) * cpus);
 	if (!port_array)
 		return NULL;
@@ -493,7 +496,7 @@ static int *create_all_readers(const char *node, const char *port,
 	/* Now create a port for each CPU */
 	for (cpu = 0; cpu < cpus; cpu++) {
 		connect_port = open_port(node, port, &pid, cpu,
-					 pagesize, start_port, use_tcp);
+					 pagesize, start_port, port_type);
 		if (connect_port < 0)
 			goto out_free;
 		port_array[cpu] = connect_port;
-- 
2.35.1

