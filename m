Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbeACRxk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:40 -0500
Message-Id: <20180103175339.226570025@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 30/38] trace-cmd: Move protocol version into msg_handler
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0030-trace-cmd-Move-protocol-version-into-msg_handler.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In order to have trace-listen be able to perform the handshake with the
client before forking, the protocol version can not be global. Move it to
the msg_handler.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  3 ++-
 trace-listen.c |  8 +++-----
 trace-record.c | 27 ++++++++++++++++-----------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 30badbd47cc6..526634fd674b 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -314,8 +314,9 @@ enum tracecmd_msg_flags {
 
 /* for both client and server */
 struct tracecmd_msg_handle {
-	unsigned long		flags;
 	int			fd;
+	int			version;	/* Current protocol version */
+	unsigned long		flags;
 };
 
 struct tracecmd_msg_handle *
diff --git a/trace-listen.c b/trace-listen.c
index a1e35ef19761..93cae4c793fa 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -51,8 +51,6 @@ static FILE *logfp;
 
 static int backlog = 5;
 
-static int proto_ver;
-
 static int do_daemon;
 
 /* Used for signaling INT to finish */
@@ -436,7 +434,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
 		/* We're off! */
 		write(fd, "OK", 2);
 
-		proto_ver = V2_PROTOCOL;
+		msg_handle->version = V2_PROTOCOL;
 
 		/* read the CPU count, the page size, and options */
 		if (tracecmd_msg_initial_setting(msg_handle, cpus, pagesize) < 0)
@@ -585,7 +583,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 		start_port = udp_port + 1;
 	}
 
-	if (proto_ver == V2_PROTOCOL) {
+	if (msg_handle->version == V2_PROTOCOL) {
 		/* send set of port numbers to the client */
 		if (tracecmd_msg_send_port_array(msg_handle, cpus, port_array) < 0) {
 			plog("Failed sending port array\n");
@@ -700,7 +698,7 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	stop_msg_handle = msg_handle;
 
 	/* Now we are ready to start reading data from the client */
-	if (proto_ver == V2_PROTOCOL)
+	if (msg_handle->version == V2_PROTOCOL)
 		tracecmd_msg_collect_metadata(msg_handle, ofd);
 	else
 		collect_metadata_from_client(msg_handle, ofd);
diff --git a/trace-record.c b/trace-record.c
index 9512fd9853ad..90e344d5c0c8 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -112,7 +112,6 @@ static unsigned recorder_flags;
 /* Try a few times to get an accurate date */
 static int date2ts_tries = 5;
 
-static int proto_ver = V2_PROTOCOL;
 static struct func_list *graph_funcs;
 
 static int func_stack;
@@ -2791,7 +2790,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 
 	if (n < 0 || !buf[0]) {
 		/* the server uses the v1 protocol, so we'll use it */
-		proto_ver = V1_PROTOCOL;
+		msg_handle->version = V1_PROTOCOL;
 		plog("Use the v1 protocol\n");
 	} else {
 		if (memcmp(buf, "V2", n) != 0)
@@ -2811,7 +2810,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 
 static struct tracecmd_msg_handle *setup_network(void)
 {
-	struct tracecmd_msg_handle *msg_handle;
+	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
 	int sfd, s;
@@ -2858,16 +2857,22 @@ again:
 
 	freeaddrinfo(result);
 
-	msg_handle = tracecmd_msg_handle_alloc(sfd, TRACECMD_MSG_FL_CLIENT);
-	if (!msg_handle)
-		die("Failed to allocate message handle");
+	if (msg_handle) {
+		msg_handle->fd = sfd;
+	} else {
+		msg_handle = tracecmd_msg_handle_alloc(sfd, TRACECMD_MSG_FL_CLIENT);
+		if (!msg_handle)
+			die("Failed to allocate message handle");
+
+		msg_handle->version = V2_PROTOCOL;
+	}
 
 	if (use_tcp)
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 
-	if (proto_ver == V2_PROTOCOL) {
+	if (msg_handle->version == V2_PROTOCOL) {
 		check_protocol_version(msg_handle);
-		if (proto_ver == V1_PROTOCOL) {
+		if (msg_handle->version == V1_PROTOCOL) {
 			/* reconnect to the server for using the v1 protocol */
 			close(sfd);
 			goto again;
@@ -2875,7 +2880,7 @@ again:
 		communicate_with_listener_v2(msg_handle);
 	}
 
-	if (proto_ver == V1_PROTOCOL)
+	if (msg_handle->version == V1_PROTOCOL)
 		communicate_with_listener_v1(msg_handle);
 
 	return msg_handle;
@@ -2888,7 +2893,7 @@ static struct tracecmd_msg_handle *setup_connection(void)
 	msg_handle = setup_network();
 
 	/* Now create the handle through this socket */
-	if (proto_ver == V2_PROTOCOL) {
+	if (msg_handle->version == V2_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
 		tracecmd_msg_finish_sending_metadata(msg_handle);
 	} else
@@ -2901,7 +2906,7 @@ static struct tracecmd_msg_handle *setup_connection(void)
 
 static void finish_network(struct tracecmd_msg_handle *msg_handle)
 {
-	if (proto_ver == V2_PROTOCOL)
+	if (msg_handle->version == V2_PROTOCOL)
 		tracecmd_msg_send_close_msg(msg_handle);
 	tracecmd_msg_handle_close(msg_handle);
 	free(host);
-- 
2.13.2
