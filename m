Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CE9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 21:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiDQVP5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 17:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiDQVP4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 17:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D32DF87
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 14:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8960D6097C
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 21:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCA3C385AA;
        Sun, 17 Apr 2022 21:13:17 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ngCCq-004P1Q-JY;
        Sun, 17 Apr 2022 17:13:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd agent: Have -N take a host name
Date:   Sun, 17 Apr 2022 17:13:14 -0400
Message-Id: <20220417211315.1049221-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417211315.1049221-1-rostedt@goodmis.org>
References: <20220417211315.1049221-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

For security reasons, it is not safe to let a trace-cmd agent connect to
*any* host. Have the -N option take a host name and only connect to that
host. It still gives full control to any process on that host, but at
least the agent is not fully open to *any* machine.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  7 ++++-
 tracecmd/trace-agent.c         | 34 +++++++++++++++------
 tracecmd/trace-listen.c        | 55 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c        | 13 ++++++--
 4 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index b3230529a45c..59771f586c37 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -122,7 +122,7 @@ void trace_convert(int argc, char **argv);
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv, bool use_fifos,
-		       unsigned long long trace_id);
+		       unsigned long long trace_id, const char *host);
 
 struct hook_list;
 
@@ -267,6 +267,7 @@ struct buffer_instance {
 
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
+	const char		*host;
 
 	struct pid_addr_maps	*pid_maps;
 
@@ -309,9 +310,13 @@ extern struct buffer_instance *first_instance;
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
+struct sockaddr_storage;
+
 int trace_net_make(int port, enum port_type type);
 int trace_net_search(int start_port, int *sfd, enum port_type type);
 int trace_net_print_connection(int fd);
+bool trace_net_cmp_connection(struct sockaddr_storage *addr, const char *name);
+bool trace_net_cmp_connection_fd(int fd, const char *name);
 
 struct buffer_instance *allocate_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 59cecae770a6..f0723a6601a4 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -62,7 +62,8 @@ static void make_net(int nr, int *fds, unsigned int *ports)
 	}
 }
 
-static void make_sockets(int nr, int *fds, unsigned int *ports, bool network)
+static void make_sockets(int nr, int *fds, unsigned int *ports,
+			 const char * network)
 {
 	if (network)
 		return make_net(nr, fds, ports);
@@ -109,7 +110,7 @@ static char *get_clock(int argc, char **argv)
 	return NULL;
 }
 
-static void trace_print_connection(int fd, bool network)
+static void trace_print_connection(int fd, const char *network)
 {
 	int ret;
 
@@ -121,7 +122,7 @@ static void trace_print_connection(int fd, bool network)
 		tracecmd_debug("Could not print connection fd:%d\n", fd);
 }
 
-static void agent_handle(int sd, int nr_cpus, int page_size, bool network)
+static void agent_handle(int sd, int nr_cpus, int page_size, const char *network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
 	struct tracecmd_time_sync *tsync = NULL;
@@ -203,7 +204,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size, bool network)
 		die("Failed to send trace response");
 
 	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
-			   use_fifos, trace_id);
+			   use_fifos, trace_id, network);
 
 	if (tsync) {
 		tracecmd_tsync_with_host_stop(tsync);
@@ -248,14 +249,23 @@ static pid_t do_fork()
 	return fork();
 }
 
-static void agent_serve(unsigned int port, bool do_daemon, bool network)
+static void agent_serve(unsigned int port, bool do_daemon, const char *network)
 {
+	struct sockaddr_storage net_addr;
+	struct sockaddr *addr = NULL;
+	socklen_t *addr_len_p = NULL;
+	socklen_t addr_len = sizeof(net_addr);
 	int sd, cd, nr_cpus;
 	unsigned int cid;
 	pid_t pid;
 
 	signal(SIGCHLD, handle_sigchld);
 
+	if (network) {
+		addr = (struct sockaddr *)&net_addr;
+		addr_len_p = &addr_len;
+	}
+
 	nr_cpus = tracecmd_count_cpus();
 	page_size = getpagesize();
 
@@ -279,7 +289,7 @@ static void agent_serve(unsigned int port, bool do_daemon, bool network)
 		die("daemon");
 
 	for (;;) {
-		cd = accept(sd, NULL, NULL);
+		cd = accept(sd, addr, addr_len_p);
 		if (cd < 0) {
 			if (errno == EINTR)
 				continue;
@@ -288,6 +298,12 @@ static void agent_serve(unsigned int port, bool do_daemon, bool network)
 		if (tracecmd_get_debug())
 			trace_print_connection(cd, network);
 
+		if (network && !trace_net_cmp_connection(&net_addr, network)) {
+			dprint("Client does not match '%s'\n", network);
+			close(cd);
+			continue;
+		}
+
 		if (handler_pid)
 			goto busy;
 
@@ -314,7 +330,7 @@ void trace_agent(int argc, char **argv)
 {
 	bool do_daemon = false;
 	unsigned int port = TRACE_AGENT_DEFAULT_PORT;
-	bool network = false;
+	const char *network = NULL;
 
 	if (argc < 2)
 		usage(argv);
@@ -332,7 +348,7 @@ void trace_agent(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc-1, argv+1, "+hp:DN",
+		c = getopt_long(argc-1, argv+1, "+hp:DN:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -341,7 +357,7 @@ void trace_agent(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'N':
-			network = true;
+			network = optarg;
 			break;
 		case 'p':
 			port = atoi(optarg);
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index b7be761d032e..86d2b9e9deb2 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -756,6 +756,61 @@ static int do_fork(int cfd)
 	return 0;
 }
 
+bool trace_net_cmp_connection(struct sockaddr_storage *addr, const char *name)
+{
+	char host[NI_MAXHOST], nhost[NI_MAXHOST];
+	char service[NI_MAXSERV];
+	socklen_t addr_len = sizeof(*addr);
+	struct addrinfo *result, *rp;
+	struct addrinfo hints;
+	bool found = false;
+	int s;
+
+	if (getnameinfo((struct sockaddr *)addr, addr_len,
+			host, NI_MAXHOST,
+			service, NI_MAXSERV, NI_NUMERICSERV))
+		return -1;
+
+	if (strcmp(host, name) == 0)
+		return true;
+
+	/* Check other IPs that name could be for */
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+
+	/* Check other IPs that name could be for */
+	s = getaddrinfo(name, NULL, &hints, &result);
+	if (s != 0)
+		return false;
+
+	for (rp = result; rp != NULL; rp = rp->ai_next) {
+		if (getnameinfo(rp->ai_addr, rp->ai_addrlen,
+				nhost, NI_MAXHOST,
+				service, NI_MAXSERV, NI_NUMERICSERV))
+			continue;
+		if (strcmp(host, nhost) == 0) {
+			found = 1;
+			break;
+		}
+	}
+
+	freeaddrinfo(result);
+	return found;
+}
+
+bool trace_net_cmp_connection_fd(int fd, const char *name)
+{
+	struct sockaddr_storage addr;
+	socklen_t addr_len = sizeof(addr);
+
+	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
+		return false;
+
+	return trace_net_cmp_connection(&addr, name);
+};
+
 int trace_net_print_connection(int fd)
 {
 	char host[NI_MAXHOST], service[NI_MAXSERV];
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9c930920c89e..27c4e7ba6f3f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3426,8 +3426,16 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		if (is_agent(instance)) {
 			if (instance->use_fifos)
 				fd = instance->fds[cpu];
-			else
+			else {
+ again:
 				fd = do_accept(instance->fds[cpu]);
+				if (instance->host &&
+				    !trace_net_cmp_connection_fd(fd, instance->host)) {
+					dprint("Client does not match '%s' for cpu:%d\n",
+					       instance->host, cpu);
+					goto again;
+				}
+			}
 		} else {
 			fd = connect_port(host, instance->client_ports[cpu],
 					  instance->port_type);
@@ -7275,7 +7283,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv,
 		       bool use_fifos,
-		       unsigned long long trace_id)
+		       unsigned long long trace_id, const char *host)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -7304,6 +7312,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 	ctx.instance->use_fifos = use_fifos;
 	ctx.instance->flags |= BUFFER_FL_AGENT;
 	ctx.instance->msg_handle = msg_handle;
+	ctx.instance->host = host;
 	msg_handle->version = V3_PROTOCOL;
 	top_instance.trace_id = trace_id;
 	record_trace(argc, argv, &ctx);
-- 
2.35.1

