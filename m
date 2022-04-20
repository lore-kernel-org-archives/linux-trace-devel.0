Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4F7C4321E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiDTP3f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380259AbiDTP3c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:29:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CEF45AEA
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3394BCE1E7F
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 15:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA302C385A8;
        Wed, 20 Apr 2022 15:26:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nhCE2-0003RS-Iz;
        Wed, 20 Apr 2022 11:26:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 04/11] trace-cmd agent: Allow for ip connections from the agent
Date:   Wed, 20 Apr 2022 11:26:30 -0400
Message-Id: <20220420152637.13105-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420152637.13105-1-rostedt@goodmis.org>
References: <20220420152637.13105-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a -N option to trace-cmd agent to listen on a network socket that
can be used by trace-cmd record -A to connect with.

Link: https://lore.kernel.org/linux-trace-devel/20220417184538.1044417-5-rostedt@goodmis.org

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  6 +++
 tracecmd/trace-agent.c         | 89 ++++++++++++++++++++++++++--------
 tracecmd/trace-listen.c        | 58 ++++++++++++++--------
 3 files changed, 113 insertions(+), 40 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 5ffd29124859..77d531d5056a 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -306,6 +306,12 @@ extern struct buffer_instance *first_instance;
 #define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
 #define is_network(instance)	((instance)->flags & BUFFER_FL_NETWORK)
 
+#define START_PORT_SEARCH 1500
+#define MAX_PORT_SEARCH 6000
+
+int trace_net_make(int port, enum port_type type);
+int trace_net_search(int start_port, int *sfd, enum port_type type);
+
 struct buffer_instance *allocate_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
 void update_first_instance(struct buffer_instance *instance, int topt);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 719d7126ca67..cd201ad948ad 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -41,6 +41,32 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
 	}
 }
 
+static void make_net(int nr, int *fds, unsigned int *ports)
+{
+	int port;
+	int i, fd;
+	int start_port = START_PORT_SEARCH;
+
+	for (i = 0; i < nr; i++) {
+		port = trace_net_search(start_port, &fd, USE_TCP);
+		if (port < 0)
+			die("Failed to open socket");
+		if (listen(fd, 5) < 0)
+			die("Failed to listen on port %d\n", port);
+		fds[i] = fd;
+		ports[i] = port;
+		start_port = port + 1;
+	}
+}
+
+static void make_sockets(int nr, int *fds, unsigned int *ports, bool network)
+{
+	if (network)
+		return make_net(nr, fds, ports);
+	else
+		return make_vsocks(nr, fds, ports);
+}
+
 static int open_agent_fifos(int nr_cpus, int *fds)
 {
 	char path[PATH_MAX];
@@ -80,7 +106,7 @@ static char *get_clock(int argc, char **argv)
 	return NULL;
 }
 
-static void agent_handle(int sd, int nr_cpus, int page_size)
+static void agent_handle(int sd, int nr_cpus, int page_size, bool network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
 	struct tracecmd_time_sync *tsync = NULL;
@@ -117,17 +143,31 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 		use_fifos = false;
 
 	if (!use_fifos)
-		make_vsocks(nr_cpus, fds, ports);
+		make_sockets(nr_cpus, fds, ports, network);
 	if (tsync_protos && tsync_protos->names) {
-		if (get_vsocket_params(msg_handle->fd, &local_id,
-				       &remote_id)) {
-			warning("Failed to get local and remote ids");
-			/* Just make something up */
-			remote_id = -1;
-			local_id = -2;
+		if (network) {
+			/* For now just use something */
+			remote_id = 2;
+			local_id = 1;
+			tsync_port = trace_net_search(START_PORT_SEARCH, &fd, USE_TCP);
+			if (listen(fd, 5) < 0)
+				die("Failed to listen on %d\n", tsync_port);
+		} else {
+			if (get_vsocket_params(msg_handle->fd, &local_id,
+					       &remote_id)) {
+				warning("Failed to get local and remote ids");
+				/* Just make something up */
+				remote_id = -1;
+				local_id = -2;
+			}
+			fd = trace_vsock_make_any();
+			if (fd >= 0 &&
+			    trace_vsock_get_port(fd, &tsync_port) < 0) {
+				close(fd);
+				fd = -1;
+			}
 		}
-		fd = trace_vsock_make_any();
-		if (fd >= 0 && trace_vsock_get_port(fd, &tsync_port) >= 0) {
+		if (fd >= 0) {
 			tsync = tracecmd_tsync_with_host(fd, tsync_protos,
 							 get_clock(argc, argv),
 							 remote_id, local_id);
@@ -193,7 +233,7 @@ static pid_t do_fork()
 	return fork();
 }
 
-static void agent_serve(unsigned int port, bool do_daemon)
+static void agent_serve(unsigned int port, bool do_daemon, bool network)
 {
 	int sd, cd, nr_cpus;
 	unsigned int cid;
@@ -204,14 +244,21 @@ static void agent_serve(unsigned int port, bool do_daemon)
 	nr_cpus = tracecmd_count_cpus();
 	page_size = getpagesize();
 
-	sd = trace_vsock_make(port);
+	if (network) {
+		sd = trace_net_make(port, USE_TCP);
+		if (listen(sd, 5) < 0)
+			die("Failed to listen on %d\n", port);
+	} else
+		sd = trace_vsock_make(port);
 	if (sd < 0)
-		die("Failed to open vsocket");
+		die("Failed to open socket");
 	tracecmd_tsync_init();
 
-	cid = trace_vsock_local_cid();
-	if (cid >= 0)
-		printf("listening on @%u:%u\n", cid, port);
+	if (!network) {
+		cid = trace_vsock_local_cid();
+		if (cid >= 0)
+			printf("listening on @%u:%u\n", cid, port);
+	}
 
 	if (do_daemon && daemon(1, 0))
 		die("daemon");
@@ -231,7 +278,7 @@ static void agent_serve(unsigned int port, bool do_daemon)
 		if (pid == 0) {
 			close(sd);
 			signal(SIGCHLD, SIG_DFL);
-			agent_handle(cd, nr_cpus, page_size);
+			agent_handle(cd, nr_cpus, page_size, network);
 		}
 		if (pid > 0)
 			handler_pid = pid;
@@ -250,6 +297,7 @@ void trace_agent(int argc, char **argv)
 {
 	bool do_daemon = false;
 	unsigned int port = TRACE_AGENT_DEFAULT_PORT;
+	bool network = false;
 
 	if (argc < 2)
 		usage(argv);
@@ -267,7 +315,7 @@ void trace_agent(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc-1, argv+1, "+hp:D",
+		c = getopt_long(argc-1, argv+1, "+hp:DN",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -275,6 +323,9 @@ void trace_agent(int argc, char **argv)
 		case 'h':
 			usage(argv);
 			break;
+		case 'N':
+			network = true;
+			break;
 		case 'p':
 			port = atoi(optarg);
 			break;
@@ -296,5 +347,5 @@ void trace_agent(int argc, char **argv)
 	if (optind < argc-1)
 		usage(argv);
 
-	agent_serve(port, do_daemon);
+	agent_serve(port, do_daemon, network);
 }
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 2338173fc8a6..8476fa51dadd 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -234,52 +234,68 @@ static int setup_vsock_port(int start_port, int *sfd)
 	return start_port;
 }
 
-#define START_PORT_SEARCH 1500
-#define MAX_PORT_SEARCH 6000
-
-static int bind_a_port(int start_port, int *sfd, enum port_type type)
+int trace_net_make(int port, enum port_type type)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
 	char buf[BUFSIZ];
+	int sd;
 	int s;
-	int num_port = start_port;
 
-	if (type == USE_VSOCK)
-		return setup_vsock_port(start_port, sfd);
- again:
-	snprintf(buf, BUFSIZ, "%d", num_port);
+	snprintf(buf, BUFSIZ, "%d", port);
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
 	hints.ai_flags = AI_PASSIVE;
 
+	switch (type) {
+	case USE_TCP:
+		hints.ai_socktype = SOCK_STREAM;
+		break;
+	case USE_UDP:
+		hints.ai_socktype = SOCK_DGRAM;
+		break;
+	default:
+		return -1;
+	}
+
 	s = getaddrinfo(NULL, buf, &hints, &result);
 	if (s != 0)
 		pdie("getaddrinfo: error opening socket");
 
 	for (rp = result; rp != NULL; rp = rp->ai_next) {
-		*sfd = socket(rp->ai_family, rp->ai_socktype,
-			      rp->ai_protocol);
-		if (*sfd < 0)
+		sd = socket(rp->ai_family, rp->ai_socktype,
+			    rp->ai_protocol);
+		if (sd < 0)
 			continue;
 
-		if (bind(*sfd, rp->ai_addr, rp->ai_addrlen) == 0)
+		if (bind(sd, rp->ai_addr, rp->ai_addrlen) == 0)
 			break;
 
-		close(*sfd);
+		close(sd);
 	}
+	freeaddrinfo(result);
+
+	if (rp == NULL)
+		return -1;
+
+	return sd;
+}
+
+int trace_net_search(int start_port, int *sfd, enum port_type type)
+{
+	int num_port = start_port;
 
-	if (rp == NULL) {
-		freeaddrinfo(result);
+	if (type == USE_VSOCK)
+		return setup_vsock_port(start_port, sfd);
+ again:
+	*sfd = trace_net_make(num_port, type);
+	if (*sfd < 0) {
 		if (++num_port > MAX_PORT_SEARCH)
 			pdie("No available ports to bind");
 		goto again;
 	}
 
-	freeaddrinfo(result);
-
 	return num_port;
 }
 
@@ -309,10 +325,10 @@ static int open_port(const char *node, const char *port, int *pid,
 	int num_port;
 
 	/*
-	 * bind_a_port() currently does not return an error, but if that
+	 * trace_net_search() currently does not return an error, but if that
 	 * changes in the future, we have a check for it now.
 	 */
-	num_port = bind_a_port(start_port, &sfd, type);
+	num_port = trace_net_search(start_port, &sfd, type);
 	if (num_port < 0)
 		return num_port;
 
-- 
2.35.1

