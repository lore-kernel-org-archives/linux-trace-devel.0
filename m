Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA5FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348395AbiDOBM5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348389AbiDOBMz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:12:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9773B550
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A55AB82BF5
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8D0C385A5;
        Fri, 15 Apr 2022 01:10:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfATg-003wEn-Cl;
        Thu, 14 Apr 2022 21:10:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/5] trace-cmd listen: Remove UDP from function names
Date:   Thu, 14 Apr 2022 21:10:19 -0400
Message-Id: <20220415011023.938663-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415011023.938663-1-rostedt@goodmis.org>
References: <20220415011023.938663-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Several functions have "udp" in their name when they also handle TCP. As
we are going to also add vsocket connections, it makes even less sense
to have these names with "udp". Make the names of the functions (and
some variables) more generic.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-listen.c | 42 ++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 874ecd61d98a..b2ab05bc3068 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -137,8 +137,8 @@ static void remove_pid_file(void)
 	unlink(buf);
 }
 
-static int process_udp_child(int sfd, const char *host, const char *port,
-			     int cpu, int page_size, int use_tcp)
+static int process_child(int sfd, const char *host, const char *port,
+			 int cpu, int page_size, int use_tcp)
 {
 	struct sockaddr_storage peer_addr;
 	socklen_t peer_addr_len;
@@ -205,7 +205,7 @@ static int process_udp_child(int sfd, const char *host, const char *port,
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
-static int udp_bind_a_port(int start_port, int *sfd, int use_tcp)
+static int bind_a_port(int start_port, int *sfd, int use_tcp)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
@@ -223,7 +223,7 @@ static int udp_bind_a_port(int start_port, int *sfd, int use_tcp)
 
 	s = getaddrinfo(NULL, buf, &hints, &result);
 	if (s != 0)
-		pdie("getaddrinfo: error opening udp socket");
+		pdie("getaddrinfo: error opening socket");
 
 	for (rp = result; rp != NULL; rp = rp->ai_next) {
 		*sfd = socket(rp->ai_family, rp->ai_socktype,
@@ -249,40 +249,40 @@ static int udp_bind_a_port(int start_port, int *sfd, int use_tcp)
 	return num_port;
 }
 
-static void fork_udp_reader(int sfd, const char *node, const char *port,
-			    int *pid, int cpu, int pagesize, int use_tcp)
+static void fork_reader(int sfd, const char *node, const char *port,
+			int *pid, int cpu, int pagesize, int use_tcp)
 {
 	int ret;
 
 	*pid = fork();
 
 	if (*pid < 0)
-		pdie("creating udp reader");
+		pdie("creating reader");
 
 	if (!*pid) {
-		ret = process_udp_child(sfd, node, port, cpu, pagesize, use_tcp);
+		ret = process_child(sfd, node, port, cpu, pagesize, use_tcp);
 		if (ret < 0)
-			pdie("Problem with udp reader %d", ret);
+			pdie("Problem with reader %d", ret);
 	}
 
 	close(sfd);
 }
 
-static int open_udp(const char *node, const char *port, int *pid,
-		    int cpu, int pagesize, int start_port, int use_tcp)
+static int open_port(const char *node, const char *port, int *pid,
+		     int cpu, int pagesize, int start_port, int use_tcp)
 {
 	int sfd;
 	int num_port;
 
 	/*
-	 * udp_bind_a_port() currently does not return an error, but if that
+	 * bind_a_port() currently does not return an error, but if that
 	 * changes in the future, we have a check for it now.
 	 */
-	num_port = udp_bind_a_port(start_port, &sfd, use_tcp);
+	num_port = bind_a_port(start_port, &sfd, use_tcp);
 	if (num_port < 0)
 		return num_port;
 
-	fork_udp_reader(sfd, node, port, pid, cpu, pagesize, use_tcp);
+	fork_reader(sfd, node, port, pid, cpu, pagesize, use_tcp);
 
 	return num_port;
 }
@@ -468,7 +468,7 @@ static int *create_all_readers(const char *node, const char *port,
 	unsigned int *port_array;
 	int *pid_array;
 	unsigned int start_port;
-	unsigned int udp_port;
+	unsigned int connect_port;
 	int cpus = msg_handle->cpu_count;
 	int cpu;
 	int pid;
@@ -490,19 +490,19 @@ static int *create_all_readers(const char *node, const char *port,
 
 	start_port = START_PORT_SEARCH;
 
-	/* Now create a UDP port for each CPU */
+	/* Now create a port for each CPU */
 	for (cpu = 0; cpu < cpus; cpu++) {
-		udp_port = open_udp(node, port, &pid, cpu,
-				    pagesize, start_port, use_tcp);
-		if (udp_port < 0)
+		connect_port = open_port(node, port, &pid, cpu,
+					 pagesize, start_port, use_tcp);
+		if (connect_port < 0)
 			goto out_free;
-		port_array[cpu] = udp_port;
+		port_array[cpu] = connect_port;
 		pid_array[cpu] = pid;
 		/*
 		 * Due to some bugging finding ports,
 		 * force search after last port
 		 */
-		start_port = udp_port + 1;
+		start_port = connect_port + 1;
 	}
 
 	if (msg_handle->version == V3_PROTOCOL) {
-- 
2.35.1

