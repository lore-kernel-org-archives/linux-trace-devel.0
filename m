Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62904C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380231AbiDTP3f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiDTP3a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9913A45AE9
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EE18B81FE7
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 15:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC38FC385A4;
        Wed, 20 Apr 2022 15:26:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nhCE2-0003RJ-H9;
        Wed, 20 Apr 2022 11:26:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 01/11] trace-cmd record: Move port_type into instance
Date:   Wed, 20 Apr 2022 11:26:27 -0400
Message-Id: <20220420152637.13105-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420152637.13105-1-rostedt@goodmis.org>
References: <20220420152637.13105-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of one global method of communication, have the "port_type" be
part of the instance. This will allow for different instances to have
different connection types.

Link: https://lore.kernel.org/linux-trace-devel/20220417184538.1044417-2-rostedt@goodmis.org

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  3 ++-
 tracecmd/trace-record.c        | 41 ++++++++++++++++++----------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index aa1cb8d939bd..c75ebf7d7f17 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -43,7 +43,7 @@ extern int show_status;
 int trace_set_verbose(char *level);
 
 enum port_type {
-	USE_UDP,
+	USE_UDP			= 0,	/* Default setting */
 	USE_TCP,
 	USE_VSOCK
 };
@@ -285,6 +285,7 @@ struct buffer_instance {
 	int			*fds;
 	bool			use_fifos;
 
+	enum port_type		port_type;	/* Default to USE_UDP (zero) */
 	int			tsync_loop_interval;
 	struct tracecmd_time_sync *tsync;
 };
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 674ec2c3ba65..14ba4ac5dc9e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -90,8 +90,6 @@ static bool fork_process;
 /* Max size to let a per cpu file get */
 static int max_kb;
 
-static enum port_type port_type;
-
 static int do_ptrace;
 
 static int filter_task;
@@ -3119,7 +3117,7 @@ static void finish(int sig)
 	finished = 1;
 }
 
-static int connect_port(const char *host, unsigned int port)
+static int connect_port(const char *host, unsigned int port, enum port_type type)
 {
 	struct addrinfo hints;
 	struct addrinfo *results, *rp;
@@ -3128,17 +3126,17 @@ static int connect_port(const char *host, unsigned int port)
 
 	snprintf(buf, BUFSIZ, "%u", port);
 
-	if (port_type == USE_VSOCK)
+	if (type == USE_VSOCK)
 		return trace_vsock_open(atoi(host), port);
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = port_type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
+	hints.ai_socktype = type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
 
 	s = getaddrinfo(host, buf, &hints, &results);
 	if (s != 0)
 		die("connecting to %s server %s:%s",
-		    port_type == USE_TCP ? "TCP" : "UDP", host, buf);
+		    type == USE_TCP ? "TCP" : "UDP", host, buf);
 
 	for (rp = results; rp != NULL; rp = rp->ai_next) {
 		sfd = socket(rp->ai_family, rp->ai_socktype,
@@ -3152,7 +3150,7 @@ static int connect_port(const char *host, unsigned int port)
 
 	if (rp == NULL)
 		die("Can not connect to %s server %s:%s",
-		    port_type == USE_TCP ? "TCP" : "UDP", host, buf);
+		    type == USE_TCP ? "TCP" : "UDP", host, buf);
 
 	freeaddrinfo(results);
 
@@ -3359,7 +3357,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 			else
 				fd = do_accept(instance->fds[cpu]);
 		} else {
-			fd = connect_port(host, instance->client_ports[cpu]);
+			fd = connect_port(host, instance->client_ports[cpu],
+					  instance->port_type);
 		}
 		if (fd < 0)
 			die("Failed connecting to client");
@@ -3414,8 +3413,9 @@ static void check_first_msg_from_server(struct tracecmd_msg_handle *msg_handle)
 }
 
 static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
-					 unsigned int **client_ports)
+					 struct buffer_instance *instance)
 {
+	unsigned int *client_ports;
 	char buf[BUFSIZ];
 	ssize_t n;
 	int cpu, i;
@@ -3442,11 +3442,11 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
 	/* TODO, test for ipv4 */
 	if (page_size >= UDP_MAX_PACKET) {
 		warning("page size too big for UDP using TCP in live read");
-		port_type = USE_TCP;
+		instance->port_type = USE_TCP;
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 	}
 
-	if (port_type == USE_TCP) {
+	if (instance->port_type == USE_TCP) {
 		/* Send one option */
 		write(msg_handle->fd, "1", 2);
 		/* Size 4 */
@@ -3457,8 +3457,8 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
 		/* No options */
 		write(msg_handle->fd, "0", 2);
 
-	*client_ports = malloc(local_cpu_count * sizeof(*client_ports));
-	if (!*client_ports)
+	client_ports = malloc(local_cpu_count * sizeof(*client_ports));
+	if (!client_ports)
 		die("Failed to allocate client ports for %d cpus", local_cpu_count);
 
 	/*
@@ -3476,8 +3476,10 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
 		if (i == BUFSIZ)
 			die("read bad port number");
 		buf[i] = 0;
-		(*client_ports)[cpu] = atoi(buf);
+		client_ports[cpu] = atoi(buf);
 	}
+
+	instance->client_ports = client_ports;
 }
 
 static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle,
@@ -3609,10 +3611,11 @@ static int connect_ip(char *thost)
 static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
+	enum port_type type = instance->port_type;
 	int sfd;
 
 again:
-	switch (port_type) {
+	switch (type) {
 	case USE_VSOCK:
 		sfd = connect_vsock(host);
 		break;
@@ -3634,7 +3637,7 @@ again:
 		msg_handle->version = V3_PROTOCOL;
 	}
 
-	switch (port_type) {
+	switch (type) {
 	case USE_TCP:
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 		break;
@@ -3657,7 +3660,7 @@ again:
 	}
 
 	if (msg_handle->version == V1_PROTOCOL)
-		communicate_with_listener_v1(msg_handle, &instance->client_ports);
+		communicate_with_listener_v1(msg_handle, instance);
 
 	return msg_handle;
 }
@@ -6514,7 +6517,7 @@ static void parse_record_options(int argc,
 			if (ctx->output)
 				die("-V incompatible with -o");
 			host = optarg;
-			port_type = USE_VSOCK;
+			ctx->instance->port_type = USE_VSOCK;
 			break;
 		case 'm':
 			if (max_kb)
@@ -6532,7 +6535,7 @@ static void parse_record_options(int argc,
 			if (IS_EXTRACT(ctx))
 				ctx->topt = 1; /* Extract top instance also */
 			else
-				port_type = USE_TCP;
+				ctx->instance->port_type = USE_TCP;
 			break;
 		case 'b':
 			check_instance_die(ctx->instance, "-b");
-- 
2.35.1

