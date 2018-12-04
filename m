Return-Path: <SRS0=S9Jt=ON=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44882 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbeLDKXe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Dec 2018 05:23:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id z5so15308884wrt.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Dec 2018 02:23:32 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/3] trace-cmd: Prepare for protocol bump to version 3
Date: Tue,  4 Dec 2018 12:23:18 +0200
Message-Id: <20181204102320.31609-2-kaslevs@vmware.com>
In-Reply-To: <20181204102320.31609-1-kaslevs@vmware.com>
References: <20181204102320.31609-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch does the necessary renames to bump protocol to version 3.

No changes in behavior are introduced.
---
 include/trace-cmd/trace-cmd.h |  6 +++---
 tracecmd/include/trace-msg.h  |  6 +++---
 tracecmd/trace-listen.c       | 16 ++++++++--------
 tracecmd/trace-msg.c          |  8 ++++----
 tracecmd/trace-output.c       |  2 +-
 tracecmd/trace-record.c       | 24 ++++++++++++------------
 6 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 684ddb7..7cce592 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -316,16 +316,16 @@ void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle);
 /* for clients */
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 				int **client_ports);
-int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
+int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
-int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 				 int *ports);
-int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
+int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd);
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
diff --git a/tracecmd/include/trace-msg.h b/tracecmd/include/trace-msg.h
index bfd065c..722548a 100644
--- a/tracecmd/include/trace-msg.h
+++ b/tracecmd/include/trace-msg.h
@@ -4,11 +4,11 @@
 #include <stdbool.h>
 
 #define UDP_MAX_PACKET	(65536 - 20)
-#define V2_MAGIC	"677768\0"
-#define V2_CPU		"-1V2"
+#define V3_MAGIC	"677768\0"
+#define V3_CPU		"-1V2"
 
 #define V1_PROTOCOL	1
-#define V2_PROTOCOL	2
+#define V3_PROTOCOL	2
 
 extern unsigned int page_size;
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 5727c0e..a13b83b 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -366,7 +366,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 
 	/* Is the client using the new protocol? */
 	if (cpus == -1) {
-		if (memcmp(buf, V2_CPU, n) != 0) {
+		if (memcmp(buf, V3_CPU, n) != 0) {
 			/* If it did not send a version, then bail */
 			if (memcmp(buf, "-1V", 3)) {
 				plog("Unknown string %s\n", buf);
@@ -391,18 +391,18 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 			goto try_again;
 		}
 
-		/* Let the client know we use v2 protocol */
+		/* Let the client know we use v3 protocol */
 		write(fd, "V2", 3);
 
 		/* read the rest of dummy data */
-		n = read(fd, buf, sizeof(V2_MAGIC));
-		if (memcmp(buf, V2_MAGIC, n) != 0)
+		n = read(fd, buf, sizeof(V3_MAGIC));
+		if (memcmp(buf, V3_MAGIC, n) != 0)
 			goto out;
 
 		/* We're off! */
 		write(fd, "OK", 2);
 
-		msg_handle->version = V2_PROTOCOL;
+		msg_handle->version = V3_PROTOCOL;
 
 		/* read the CPU count, the page size, and options */
 		if ((pagesize = tracecmd_msg_initial_setting(msg_handle)) < 0)
@@ -557,7 +557,7 @@ static int *create_all_readers(const char *node, const char *port,
 		start_port = udp_port + 1;
 	}
 
-	if (msg_handle->version == V2_PROTOCOL) {
+	if (msg_handle->version == V3_PROTOCOL) {
 		/* send set of port numbers to the client */
 		if (tracecmd_msg_send_port_array(msg_handle, port_array) < 0) {
 			plog("Failed sending port array\n");
@@ -674,8 +674,8 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	stop_msg_handle = msg_handle;
 
 	/* Now we are ready to start reading data from the client */
-	if (msg_handle->version == V2_PROTOCOL)
-		tracecmd_msg_collect_metadata(msg_handle, ofd);
+	if (msg_handle->version == V3_PROTOCOL)
+		tracecmd_msg_collect_data(msg_handle, ofd);
 	else
 		collect_metadata_from_client(msg_handle, ofd);
 
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 8e1226b..b496935 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -599,8 +599,8 @@ void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 	tracecmd_msg_send(msg_handle->fd, &msg);
 }
 
-int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
-			       const char *buf, int size)
+int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
+			   const char *buf, int size)
 {
 	struct tracecmd_msg msg;
 	int fd = msg_handle->fd;
@@ -638,7 +638,7 @@ int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
 	return ret;
 }
 
-int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle)
+int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg msg;
 	int ret;
@@ -650,7 +650,7 @@ int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle)
 	return 0;
 }
 
-int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd)
+int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 {
 	struct tracecmd_msg msg;
 	u32 t, n, cmd;
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 99493e6..78a8fe6 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -74,7 +74,7 @@ static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
 	if (handle->msg_handle)
-		return tracecmd_msg_metadata_send(handle->msg_handle, data, size);
+		return tracecmd_msg_data_send(handle->msg_handle, data, size);
 
 	return __do_write_check(handle->fd, data, size);
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 038b231..b755648 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2747,7 +2747,7 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
-static void communicate_with_listener_v2(struct tracecmd_msg_handle *msg_handle)
+static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle)
 {
 	if (tracecmd_msg_send_init_data(msg_handle, &client_ports) < 0)
 		die("Cannot communicate with server");
@@ -2764,8 +2764,8 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	/*
 	 * Write the protocol version, the magic number, and the dummy
 	 * option(0) (in ASCII). The client understands whether the client
-	 * uses the v2 protocol or not by checking a reply message from the
-	 * server. If the message is "V2", the server uses v2 protocol. On the
+	 * uses the v3 protocol or not by checking a reply message from the
+	 * server. If the message is "V3", the server uses v3 protocol. On the
 	 * other hands, if the message is just number strings, the server
 	 * returned port numbers. So, in that time, the client understands the
 	 * server uses the v1 protocol. However, the old server tells the
@@ -2773,7 +2773,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	 * So, we add the dummy number (the magic number and 0 option) to the
 	 * first client message.
 	 */
-	write(fd, V2_CPU, sizeof(V2_CPU));
+	write(fd, V3_CPU, sizeof(V3_CPU));
 
 	buf[0] = 0;
 
@@ -2787,8 +2787,8 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	} else {
 		if (memcmp(buf, "V2", n) != 0)
 			die("Cannot handle the protocol %s", buf);
-		/* OK, let's use v2 protocol */
-		write(fd, V2_MAGIC, sizeof(V2_MAGIC));
+		/* OK, let's use v3 protocol */
+		write(fd, V3_MAGIC, sizeof(V3_MAGIC));
 
 		n = read(fd, buf, BUFSIZ - 1);
 		if (n != 2 || memcmp(buf, "OK", 2) != 0) {
@@ -2857,20 +2857,20 @@ again:
 			die("Failed to allocate message handle");
 
 		msg_handle->cpu_count = local_cpu_count;
-		msg_handle->version = V2_PROTOCOL;
+		msg_handle->version = V3_PROTOCOL;
 	}
 
 	if (use_tcp)
 		msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
 
-	if (msg_handle->version == V2_PROTOCOL) {
+	if (msg_handle->version == V3_PROTOCOL) {
 		check_protocol_version(msg_handle);
 		if (msg_handle->version == V1_PROTOCOL) {
 			/* reconnect to the server for using the v1 protocol */
 			close(sfd);
 			goto again;
 		}
-		communicate_with_listener_v2(msg_handle);
+		communicate_with_listener_v3(msg_handle);
 	}
 
 	if (msg_handle->version == V1_PROTOCOL)
@@ -2888,9 +2888,9 @@ setup_connection(struct buffer_instance *instance)
 	msg_handle = setup_network();
 
 	/* Now create the handle through this socket */
-	if (msg_handle->version == V2_PROTOCOL) {
+	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
-		tracecmd_msg_finish_sending_metadata(msg_handle);
+		tracecmd_msg_finish_sending_data(msg_handle);
 	} else
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
 							      listed_events);
@@ -2903,7 +2903,7 @@ setup_connection(struct buffer_instance *instance)
 
 static void finish_network(struct tracecmd_msg_handle *msg_handle)
 {
-	if (msg_handle->version == V2_PROTOCOL)
+	if (msg_handle->version == V3_PROTOCOL)
 		tracecmd_msg_send_close_msg(msg_handle);
 	tracecmd_msg_handle_close(msg_handle);
 	free(host);
-- 
2.19.1
