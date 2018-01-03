Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbeACRxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:39 -0500
Message-Id: <20180103175338.118040575@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 23/38] trace-cmd: Pass in client_ports instead of using a global variable
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0023-trace-cmd-Pass-in-client_ports-instead-of-using-a-gl.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of using a globla variable for passing around client_ports, just
pass it to the trace-msg code via a parameter.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  2 +-
 trace-msg.c    | 12 ++++++++----
 trace-msg.h    |  1 -
 trace-record.c |  3 ++-
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 5a5b6bf88574..635b5a58dfe9 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -297,7 +297,7 @@ void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
 
 /* for clients */
-int tracecmd_msg_send_init_data(int fd, int total_cpus);
+int tracecmd_msg_send_init_data(int fd, int total_cpus, int **client_ports);
 int tracecmd_msg_metadata_send(int fd, const char *buf, int size);
 int tracecmd_msg_finish_sending_metadata(int fd);
 void tracecmd_msg_send_close_msg(void);
diff --git a/trace-msg.c b/trace-msg.c
index 9fefe22753d9..4c564eb28f31 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -68,7 +68,6 @@ bool use_tcp;
 /* for client */
 static int psfd;
 unsigned int page_size;
-int *client_ports;
 
 /* for server */
 bool done;
@@ -367,13 +366,16 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	return 0;
 }
 
-int tracecmd_msg_send_init_data(int fd, int total_cpus)
+int tracecmd_msg_send_init_data(int fd, int total_cpus, int **client_ports)
 {
 	struct tracecmd_msg send_msg;
 	struct tracecmd_msg recv_msg;
+	int *ports;
 	int i, cpus;
 	int ret;
 
+	*client_ports = NULL;
+
 	tracecmd_msg_init(MSG_TINIT, &send_msg);
 	ret = make_tinit(&send_msg, total_cpus);
 	if (ret < 0)
@@ -391,9 +393,11 @@ int tracecmd_msg_send_init_data(int fd, int total_cpus)
 		return -EINVAL;
 
 	cpus = ntohl(recv_msg.rinit.cpus);
-	client_ports = malloc_or_die(sizeof(int) * cpus);
+	ports = malloc_or_die(sizeof(int) * cpus);
 	for (i = 0; i < cpus; i++)
-		client_ports[i] = ntohl(recv_msg.port_array[i]);
+		ports[i] = ntohl(recv_msg.port_array[i]);
+
+	*client_ports = ports;
 
 	return 0;
 }
diff --git a/trace-msg.h b/trace-msg.h
index fe72c9d76829..7f6a146aeb10 100644
--- a/trace-msg.h
+++ b/trace-msg.h
@@ -15,7 +15,6 @@ extern bool use_tcp;
 
 /* for client */
 extern unsigned int page_size;
-extern int *client_ports;
 
 /* for server */
 extern bool done;
diff --git a/trace-record.c b/trace-record.c
index 396050bbaae7..6b8bb89e4e0d 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -88,6 +88,7 @@ static int buffers;
 static int clear_function_filters;
 
 static char *host;
+static int *client_ports;
 static int sfd;
 static struct tracecmd_output *network_handle;
 
@@ -2756,7 +2757,7 @@ static void communicate_with_listener_v1(int fd)
 
 static void communicate_with_listener_v2(int fd)
 {
-	if (tracecmd_msg_send_init_data(fd, cpu_count) < 0)
+	if (tracecmd_msg_send_init_data(fd, cpu_count, &client_ports) < 0)
 		die("Cannot communicate with server");
 }
 
-- 
2.13.2
