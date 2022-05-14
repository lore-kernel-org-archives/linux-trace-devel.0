Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B482C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiENCze (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiENCzV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4283634A951
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9720961E3D
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C417AC341CA;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XN5-Lo;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 18/26] trace-cmd: Add agent proxy communications between record and agent
Date:   Fri, 13 May 2022 22:47:48 -0400
Message-Id: <20220514024756.1319681-19-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add:

  trace-cmd agent -P <cid>

to allow an agent to also act as a proxy server, where it can be run on a
host and connect with a guest. The <cid> is the guest's cid that it will
connect to (it will only connect to a specified guest).

Add:

  trace-cmd record --proxy ...

That acts the same as -A (for an agent) but will send the proxy connection
to the agent. It is expected to run on a privilege guest that the host is
aware of (as denoted by the <cid> in the -P option for the agent).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  2 ++
 tracecmd/trace-agent.c         | 56 ++++++++++++++++++++++++++++------
 tracecmd/trace-record.c        | 38 ++++++++++++++++++-----
 3 files changed, 78 insertions(+), 18 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 5febe9a60a54..92d005c7b12c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -190,6 +190,7 @@ enum buffer_instance_flags {
 	BUFFER_FL_HAS_CLOCK	= 1 << 4,
 	BUFFER_FL_TSC2NSEC	= 1 << 5,
 	BUFFER_FL_NETWORK	= 1 << 6,
+	BUFFER_FL_PROXY		= 1 << 7,
 };
 
 struct func_list {
@@ -305,6 +306,7 @@ extern struct buffer_instance *first_instance;
 
 #define is_agent(instance)	((instance)->flags & BUFFER_FL_AGENT)
 #define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
+#define is_proxy(instance)	((instance)->flags & BUFFER_FL_PROXY)
 #define is_network(instance)	((instance)->flags & BUFFER_FL_NETWORK)
 
 #define START_PORT_SEARCH 1500
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 920094702b6d..360079297b88 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -144,17 +144,22 @@ static int wait_for_connection(int fd)
 	return sd;
 }
 
-static void agent_handle(int sd, int nr_cpus, int page_size, const char *network)
+static void agent_handle(int sd, int nr_cpus, int page_size,
+			 int cid, int rcid, const char *network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
 	struct tracecmd_time_sync *tsync = NULL;
 	struct tracecmd_msg_handle *msg_handle;
 	const char *tsync_proto = NULL;
+	unsigned long long peer_trace_id;
 	unsigned long long trace_id;
+	unsigned long flags = rcid >= 0 ? TRACECMD_MSG_FL_PROXY : 0;
 	unsigned int remote_id;
 	unsigned int local_id;
 	unsigned int tsync_port = 0;
 	unsigned int *ports;
+	unsigned int client_cpus = 0;
+	unsigned int guests = 0;
 	char **argv = NULL;
 	int argc = 0;
 	bool use_fifos;
@@ -167,13 +172,20 @@ static void agent_handle(int sd, int nr_cpus, int page_size, const char *network
 	if (!fds || !ports)
 		die("Failed to allocate memory");
 
-	msg_handle = tracecmd_msg_handle_alloc(sd, 0);
+	msg_handle = tracecmd_msg_handle_alloc(sd, flags);
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
-	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
-					  &use_fifos, &trace_id,
-					  &tsync_protos);
+	if (rcid >= 0)
+		ret = tracecmd_msg_recv_trace_proxy(msg_handle, &argc, &argv,
+						    &use_fifos, &peer_trace_id,
+						    &tsync_protos,
+						    &client_cpus,
+						    &guests);
+	else
+		ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
+						  &use_fifos, &peer_trace_id,
+						  &tsync_protos);
 	if (ret < 0)
 		die("Failed to receive trace request");
 
@@ -270,14 +282,15 @@ static pid_t do_fork()
 	return fork();
 }
 
-static void agent_serve(unsigned int port, bool do_daemon, const char *network)
+static void agent_serve(unsigned int port, bool do_daemon, int proxy_id,
+			const char *network)
 {
 	struct sockaddr_storage net_addr;
 	struct sockaddr *addr = NULL;
 	socklen_t *addr_len_p = NULL;
 	socklen_t addr_len = sizeof(net_addr);
 	int sd, cd, nr_cpus;
-	unsigned int cid;
+	unsigned int cid = -1, rcid = -1;
 	pid_t pid;
 
 	signal(SIGCHLD, handle_sigchld);
@@ -316,6 +329,21 @@ static void agent_serve(unsigned int port, bool do_daemon, const char *network)
 				continue;
 			die("accept");
 		}
+		if (proxy_id >= 0) {
+			/* Only works with vsockets */
+			if (get_vsocket_params(cd, NULL, &rcid) < 0) {
+				dprint("Failed to find connected cid");
+				close(cd);
+				continue;
+			}
+			if (rcid != proxy_id) {
+				dprint("Cid %d does not match expected cid %d\n",
+				       rcid, proxy_id);
+				close(cd);
+				continue;
+			}
+		}
+
 		if (tracecmd_get_debug())
 			trace_print_connection(cd, network);
 
@@ -332,7 +360,7 @@ static void agent_serve(unsigned int port, bool do_daemon, const char *network)
 		if (pid == 0) {
 			close(sd);
 			signal(SIGCHLD, SIG_DFL);
-			agent_handle(cd, nr_cpus, page_size, network);
+			agent_handle(cd, nr_cpus, page_size, cid, rcid, network);
 		}
 		if (pid > 0)
 			handler_pid = pid;
@@ -352,6 +380,7 @@ void trace_agent(int argc, char **argv)
 	bool do_daemon = false;
 	unsigned int port = TRACE_AGENT_DEFAULT_PORT;
 	const char *network = NULL;
+	int proxy_id = -1;
 
 	if (argc < 2)
 		usage(argv);
@@ -369,7 +398,7 @@ void trace_agent(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc-1, argv+1, "+hp:DN:",
+		c = getopt_long(argc-1, argv+1, "+hp:DN:P:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -382,10 +411,17 @@ void trace_agent(int argc, char **argv)
 			break;
 		case 'p':
 			port = atoi(optarg);
+			if (proxy_id >= 0)
+				die("-N cannot be used with -P");
 			break;
 		case 'D':
 			do_daemon = true;
 			break;
+		case 'P':
+			proxy_id = atoi(optarg);
+			if (network)
+				die("-P cannot be used with -N");
+			break;
 		case DO_DEBUG:
 			tracecmd_set_debug(true);
 			break;
@@ -401,5 +437,5 @@ void trace_agent(int argc, char **argv)
 	if (optind < argc-1)
 		usage(argv);
 
-	agent_serve(port, do_daemon, network);
+	agent_serve(port, do_daemon, proxy_id, network);
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bf85e7936b73..7ffea4c7c76c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3862,6 +3862,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
+	int siblings = 0;
 
 	if (!no_fifos) {
 		nr_fifos = open_guest_fifos(instance->name, &fds);
@@ -3892,11 +3893,19 @@ static void connect_to_agent(struct common_record_context *ctx,
 	if (instance->tsync_loop_interval >= 0)
 		tracecmd_tsync_proto_getall(&protos, instance->clock, role);
 
-	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
-					  instance->argv, use_fifos,
-					  top_instance.trace_id, protos);
+	if (is_proxy(instance))
+		ret = tracecmd_msg_send_trace_proxy(msg_handle, instance->argc,
+						    instance->argv, use_fifos,
+						    top_instance.trace_id, protos,
+						    tracecmd_count_cpus(),
+						    siblings);
+	else
+		ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
+						  instance->argv, use_fifos,
+						  top_instance.trace_id, protos);
 	if (ret < 0)
-		die("Failed to send trace request");
+		die("Failed to send trace %s",
+		    is_proxy(instance) ? "proxy" : "request");
 
 	if (protos) {
 		free(protos->names);
@@ -5623,6 +5632,7 @@ enum {
 	OPT_cmdlines_size	= 258,
 	OPT_poll		= 259,
 	OPT_name		= 260,
+	OPT_proxy		= 261
 };
 
 void trace_stop(int argc, char **argv)
@@ -6005,6 +6015,7 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int negative = 0;
+	bool is_proxy = false;
 	struct buffer_instance *instance, *del_list = NULL;
 	int do_children = 0;
 	int fpids_count = 0;
@@ -6045,6 +6056,7 @@ static void parse_record_options(int argc,
 			{"verbose", optional_argument, NULL, OPT_verbose},
 			{"compression", required_argument, NULL, OPT_compression},
 			{"file-version", required_argument, NULL, OPT_file_ver},
+			{"proxy", required_argument, NULL, OPT_proxy},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6060,7 +6072,8 @@ static void parse_record_options(int argc,
 		 * If the current instance is to record a guest, then save
 		 * all the arguments for this instance.
 		 */
-		if (c != 'B' && c != 'A' && c != OPT_name && is_guest(ctx->instance)) {
+		if (c != 'B' && (c != 'A' || is_proxy) && c != OPT_name &&
+		    is_guest(ctx->instance)) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
 			if (c == 'C')
 				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
@@ -6132,12 +6145,16 @@ static void parse_record_options(int argc,
 				die("Failed to allocate name");
 			break;
 
+		case OPT_proxy:
+			is_proxy = true;
+			/* fall through */
 		case 'A': {
 			char *name = NULL;
 			int cid = -1, port = -1;
 
 			if (!IS_RECORD(ctx))
-				die("-A is only allowed for record operations");
+				die("%s is only allowed for record operations",
+				    is_proxy ? "--proxy" : "-A");
 
 			name = parse_guest_name(optarg, &cid, &port, &result);
 			if (cid == -1 && !result)
@@ -6164,6 +6181,9 @@ static void parse_record_options(int argc,
 				ctx->instance->port_type = USE_TCP;
 			}
 
+			if (is_proxy)
+				ctx->instance->flags |= BUFFER_FL_PROXY;
+
 			ctx->instance->flags |= BUFFER_FL_GUEST;
 			ctx->instance->result = result;
 			ctx->instance->cid = cid;
@@ -6386,6 +6406,8 @@ static void parse_record_options(int argc,
 			ctx->instance->buffer_size = atoi(optarg);
 			break;
 		case 'B':
+			/* Turn off proxy for the next options */
+			is_proxy = false;
 			ctx->instance = allocate_instance(optarg);
 			if (!ctx->instance)
 				die("Failed to create instance");
@@ -7033,6 +7055,7 @@ void trace_record(int argc, char **argv)
  * @argv: The arguments to pass to the record session
  * @use_fifos: True if fifos are used instead of sockets.
  * @trace_id: The agent's trace_id
+ * @rcid: Remote cid if the agent is a proxy, negative otherwise.
  * @host: Set if this is an IP connection and not a vsocket one
  *
  * This is used to enable tracing via the record command just
@@ -7044,8 +7067,7 @@ void trace_record(int argc, char **argv)
  */
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv,
-		       bool use_fifos,
+		       int argc, char **argv, bool use_fifos,
 		       unsigned long long trace_id, const char *host)
 {
 	struct common_record_context ctx;
-- 
2.35.1

