Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B60C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 01:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiDQBWl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 16 Apr 2022 21:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiDQBWk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 16 Apr 2022 21:22:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA2B25595
        for <linux-trace-devel@vger.kernel.org>; Sat, 16 Apr 2022 18:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61057B80A7C
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 01:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7C2C385AC;
        Sun, 17 Apr 2022 01:20:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfta4-004FiV-5R;
        Sat, 16 Apr 2022 21:20:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/8] trace-cmd record: Allow for ip connections to agents
Date:   Sat, 16 Apr 2022 21:19:53 -0400
Message-Id: <20220417011958.1013591-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417011958.1013591-1-rostedt@goodmis.org>
References: <20220417011958.1013591-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have the -A option to trace-cmd record accept IP addresses (v4 or v6)
or host names that can connect to agents that are not running on guests
(or maybe they are!) but are running on other machines connecting to the
network.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |   3 +
 tracecmd/trace-record.c        | 216 +++++++++++++++++++++++----------
 2 files changed, 152 insertions(+), 67 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a253b4c6432a..5c3fcfccec30 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -189,6 +189,7 @@ enum buffer_instance_flags {
 	BUFFER_FL_AGENT		= 1 << 3,
 	BUFFER_FL_HAS_CLOCK	= 1 << 4,
 	BUFFER_FL_TSC2NSEC	= 1 << 5,
+	BUFFER_FL_NETWORK	= 1 << 6,
 };
 
 struct func_list {
@@ -280,6 +281,7 @@ struct buffer_instance {
 	int			argc;
 	char			**argv;
 
+	struct addrinfo		*result;
 	unsigned int		cid;
 	unsigned int		port;
 	int			*fds;
@@ -302,6 +304,7 @@ extern struct buffer_instance *first_instance;
 
 #define is_agent(instance)	((instance)->flags & BUFFER_FL_AGENT)
 #define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
+#define is_network(instance)	((instance)->flags & BUFFER_FL_NETWORK)
 
 struct buffer_instance *allocate_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ba4738b7c845..085944296934 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -83,6 +83,8 @@ static bool no_fifos;
 
 static char *host;
 
+static const char *gai_err;
+
 static bool quiet;
 
 static bool fork_process;
@@ -3117,26 +3119,33 @@ static void finish(int sig)
 	finished = 1;
 }
 
-static int connect_port(const char *host, unsigned int port, enum port_type type)
+static struct addrinfo *do_getaddrinfo(const char *host, unsigned int port,
+				       enum port_type type)
 {
+	struct addrinfo *results;
 	struct addrinfo hints;
-	struct addrinfo *results, *rp;
-	int s, sfd;
 	char buf[BUFSIZ];
+	int s;
 
 	snprintf(buf, BUFSIZ, "%u", port);
 
-	if (type == USE_VSOCK)
-		return trace_vsock_open(atoi(host), port);
-
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
 
 	s = getaddrinfo(host, buf, &hints, &results);
-	if (s != 0)
-		die("connecting to %s server %s:%s",
-		    type == USE_TCP ? "TCP" : "UDP", host, buf);
+	if (s != 0) {
+		gai_err = gai_strerror(s);
+		return NULL;
+	}
+
+	return results;
+}
+
+static int connect_addr(struct addrinfo *results)
+{
+	struct addrinfo *rp;
+	int sfd = -1;
 
 	for (rp = results; rp != NULL; rp = rp->ai_next) {
 		sfd = socket(rp->ai_family, rp->ai_socktype,
@@ -3149,11 +3158,33 @@ static int connect_port(const char *host, unsigned int port, enum port_type type
 	}
 
 	if (rp == NULL)
-		die("Can not connect to %s server %s:%s",
-		    type == USE_TCP ? "TCP" : "UDP", host, buf);
+		return -1;
+
+	return sfd;
+}
+
+static int connect_port(const char *host, unsigned int port, enum port_type type)
+{
+	struct addrinfo *results;
+	int sfd;
+
+	if (type == USE_VSOCK)
+		return trace_vsock_open(atoi(host), port);
+
+	results = do_getaddrinfo(host, port, type);
+
+	if (!results)
+		die("connecting to %s server %s:%u",
+		    type == USE_TCP ? "TCP" : "UDP", host, port);
+
+	sfd = connect_addr(results);
 
 	freeaddrinfo(results);
 
+	if (sfd < 0)
+		die("Can not connect to %s server %s:%u",
+		    type == USE_TCP ? "TCP" : "UDP", host, port);
+
 	return sfd;
 }
 
@@ -3207,14 +3238,22 @@ static void find_tasks(struct trace_guest *guest)
 	closedir(dir);
 }
 
-static char *parse_guest_name(char *gname, int *cid, int *port)
+static char *parse_guest_name(char *gname, int *cid, int *port,
+			      struct addrinfo **res)
 {
-	struct trace_guest *guest;
+	struct trace_guest *guest = NULL;
+	struct addrinfo *result;
+	char *ip = NULL;
 	char *p;
 
+	*res = NULL;
+
 	*port = -1;
-	p = strrchr(gname, ':');
-	if (p) {
+	for (p = gname + strlen(gname); p > gname; p--) {
+		if (*p == ':')
+			break;
+	}
+	if (p > gname) {
 		*p = '\0';
 		*port = atoi(p + 1);
 	}
@@ -3224,13 +3263,19 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
 	if (p) {
 		*p = '\0';
 		*cid = atoi(p + 1);
-	} else if (is_digits(gname))
+	} else if (is_digits(gname)) {
 		*cid = atoi(gname);
+	} else {
+		/* Check if this is an IP address */
+		if (strstr(gname, ":") || strstr(gname, "."))
+			ip = gname;
+	}
 
-	if (*cid < 0)
+	if (!ip && *cid < 0)
 		read_qemu_guests();
 
-	guest = trace_get_guest(*cid, gname);
+	if (!ip)
+		guest = trace_get_guest(*cid, gname);
 	if (guest) {
 		*cid = guest->cid;
 		/* Mapping not found, search for them */
@@ -3239,6 +3284,13 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
 		return guest->name;
 	}
 
+	/* Test to see if this is an internet address */
+	result = do_getaddrinfo(gname, *port, USE_TCP);
+	if (!result)
+		return NULL;
+
+	*res = result;
+
 	return gname;
 }
 
@@ -3280,6 +3332,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 			 int *brass)
 {
 	struct tracecmd_recorder *record;
+	struct addrinfo *result;
 	char *path;
 
 	if (is_guest(instance)) {
@@ -3288,7 +3341,17 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
 		if (instance->use_fifos)
 			fd = instance->fds[cpu];
-		else
+		else if (is_network(instance)) {
+			result = do_getaddrinfo(instance->name,
+						instance->client_ports[cpu],
+						instance->port_type);
+			if (!result)
+				die("Failed to connect to %s port %d\n",
+				    instance->name,
+				    instance->client_ports[cpu]);
+			fd = connect_addr(result);
+			freeaddrinfo(result);
+		} else
 			fd = trace_vsock_open(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
@@ -3560,10 +3623,9 @@ static int connect_vsock(char *vhost)
 
 static int connect_ip(char *host)
 {
-	struct addrinfo hints;
-	struct addrinfo *result, *rp;
+	struct addrinfo *result;
 	char *thost = NULL;
-	int sfd, s;
+	int sfd;
 	char *server;
 	char *port;
 	char *p;
@@ -3582,31 +3644,18 @@ static int connect_ip(char *host)
 		port = strtok_r(NULL, ":", &p);
 	}
 
-	memset(&hints, 0, sizeof(hints));
-	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = SOCK_STREAM;
-
-	s = getaddrinfo(server, port, &hints, &result);
-	if (s != 0)
-		die("getaddrinfo: %s", gai_strerror(s));
+	result = do_getaddrinfo(server, atoi(port), USE_TCP);
+	if (!result)
+		die("getaddrinfo: %s", gai_err);
 
-	for (rp = result; rp != NULL; rp = rp->ai_next) {
-		sfd = socket(rp->ai_family, rp->ai_socktype,
-			     rp->ai_protocol);
-		if (sfd == -1)
-			continue;
-
-		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
-			break;
-		close(sfd);
-	}
-
-	if (!rp)
-		die("Can not connect to %s:%s", server, port);
+	sfd = connect_addr(result);
 
 	freeaddrinfo(result);
 	free(thost);
 
+	if (sfd < 0)
+		die("Can not connect to %s:%s", server, port);
+
 	return sfd;
 }
 
@@ -3962,20 +4011,26 @@ static int host_tsync(struct common_record_context *ctx,
 	if (!proto)
 		return -1;
 
-	guest = trace_get_guest(instance->cid, NULL);
-	if (guest == NULL)
-		return -1;
+	if (is_network(instance)) {
+		fd = connect_port(instance->name, tsync_port,
+				  instance->port_type);
+	} else {
+		guest = trace_get_guest(instance->cid, NULL);
+		if (guest == NULL)
+			return -1;
 
-	guest_pid = guest->pid;
-	start_mapping_vcpus(guest);
+		guest_pid = guest->pid;
+		start_mapping_vcpus(guest);
+		fd = trace_vsock_open(instance->cid, tsync_port);
+	}
 
-	fd = trace_vsock_open(instance->cid, tsync_port);
 	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
 						    instance->tsync_loop_interval,
 						    fd, guest_pid,
 						    instance->cpu_count,
 						    proto, ctx->clock);
-	stop_mapping_vcpus(instance, guest);
+	if (!is_network(instance))
+		stop_mapping_vcpus(instance, guest);
 
 	if (!instance->tsync)
 		return -1;
@@ -3989,6 +4044,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 	struct tracecmd_tsync_protos *protos = NULL;
 	int sd, ret, nr_fifos, nr_cpus, page_size;
 	struct tracecmd_msg_handle *msg_handle;
+	enum tracecmd_time_sync_role role;
 	char *tsync_protos_reply = NULL;
 	unsigned int tsync_port = 0;
 	unsigned int *ports;
@@ -4000,10 +4056,19 @@ static void connect_to_agent(struct common_record_context *ctx,
 		use_fifos = nr_fifos > 0;
 	}
 
-	sd = trace_vsock_open(instance->cid, instance->port);
-	if (sd < 0)
-		die("Failed to connect to vsocket @%u:%u",
-		    instance->cid, instance->port);
+	if (ctx->instance->result) {
+		role = TRACECMD_TIME_SYNC_ROLE_CLIENT;
+		sd = connect_addr(ctx->instance->result);
+		if (sd < 0)
+			die("Failed to connect to host %s:%u",
+			    instance->name, instance->port);
+	} else {
+		role = TRACECMD_TIME_SYNC_ROLE_HOST;
+		sd = trace_vsock_open(instance->cid, instance->port);
+		if (sd < 0)
+			die("Failed to connect to vsocket @%u:%u",
+			    instance->cid, instance->port);
+	}
 
 	msg_handle = tracecmd_msg_handle_alloc(sd, 0);
 	if (!msg_handle)
@@ -4013,8 +4078,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 		instance->clock = tracefs_get_clock(NULL);
 
 	if (instance->tsync_loop_interval >= 0)
-		tracecmd_tsync_proto_getall(&protos, instance->clock,
-					    TRACECMD_TIME_SYNC_ROLE_HOST);
+		tracecmd_tsync_proto_getall(&protos, instance->clock, role);
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
 					  instance->argv, use_fifos,
@@ -4221,16 +4285,23 @@ static void append_buffer(struct tracecmd_output *handle,
 static void
 add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
-	struct trace_guest *guest = trace_get_guest(instance->cid, NULL);
+	struct trace_guest *guest;
+	const char *name;
 	char *buf, *p;
 	int size;
 	int pid;
 	int i;
 
-	if (!guest)
-		return;
+	if (is_network(instance)) {
+		name = instance->name;
+	} else {
+		guest = trace_get_guest(instance->cid, NULL);
+		if (!guest)
+			return;
+		name = guest->name;
+	}
 
-	size = strlen(guest->name) + 1;
+	size = strlen(name) + 1;
 	size += sizeof(long long);	/* trace_id */
 	size += sizeof(int);		/* cpu count */
 	size += instance->cpu_count * 2 * sizeof(int);	/* cpu,pid pair */
@@ -4239,8 +4310,8 @@ add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
 	if (!buf)
 		return;
 	p = buf;
-	strcpy(p, guest->name);
-	p += strlen(guest->name) + 1;
+	strcpy(p, name);
+	p += strlen(name) + 1;
 
 	memcpy(p, &instance->trace_id, sizeof(long long));
 	p += sizeof(long long);
@@ -4248,10 +4319,11 @@ add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
 	memcpy(p, &instance->cpu_count, sizeof(int));
 	p += sizeof(int);
 	for (i = 0; i < instance->cpu_count; i++) {
-		if (i < guest->cpu_max)
-			pid = guest->cpu_pid[i];
-		else
-			pid = -1;
+		pid = -1;
+		if (!is_network(instance)) {
+			if (i < guest->cpu_max)
+				pid = guest->cpu_pid[i];
+		}
 		memcpy(p, &i, sizeof(int));
 		p += sizeof(int);
 		memcpy(p, &pid, sizeof(int));
@@ -6167,6 +6239,7 @@ static void parse_record_options(int argc,
 	const char *option;
 	struct event_list *event = NULL;
 	struct event_list *last_event = NULL;
+	struct addrinfo *result;
 	char *pids;
 	char *pid;
 	char *sav;
@@ -6306,8 +6379,8 @@ static void parse_record_options(int argc,
 			if (!IS_RECORD(ctx))
 				die("-A is only allowed for record operations");
 
-			name = parse_guest_name(optarg, &cid, &port);
-			if (cid == -1)
+			name = parse_guest_name(optarg, &cid, &port, &result);
+			if (cid == -1 && !result)
 				die("guest %s not found", optarg);
 			if (port == -1)
 				port = TRACE_AGENT_DEFAULT_PORT;
@@ -6323,7 +6396,16 @@ static void parse_record_options(int argc,
 				die("Failed to allocate guest name");
 
 			ctx->instance = allocate_instance(name);
+			if (!ctx->instance)
+				die("Failed to allocate instance");
+
+			if (result) {
+				ctx->instance->flags |= BUFFER_FL_NETWORK;
+				ctx->instance->port_type = USE_TCP;
+			}
+
 			ctx->instance->flags |= BUFFER_FL_GUEST;
+			ctx->instance->result = result;
 			ctx->instance->cid = cid;
 			ctx->instance->port = port;
 			ctx->instance->name = name;
-- 
2.35.1

