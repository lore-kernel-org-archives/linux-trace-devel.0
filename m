Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751059AbeACRxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:39 -0500
Message-Id: <20180103175337.830519811@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 21/38] trace-cmd: Pass cpu count and port array to make_rinit()
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0021-trace-cmd-Pass-cpu-count-and-port-array-to-make_rini.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of having a global variable for the port arrays, pass it to
make_rinit() directly. Then we can remove the static port array variable.

Also pass cpu_count, as that will help in removing cpu_count as a global as
well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-msg.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index ab64f3f28f5e..0402a069ff21 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -72,7 +72,6 @@ unsigned int page_size;
 int *client_ports;
 
 /* for server */
-static int *port_array;
 bool done;
 
 struct tracecmd_msg_opt {
@@ -189,26 +188,26 @@ static int make_tinit(struct tracecmd_msg *msg)
 	return 0;
 }
 
-static int make_rinit(struct tracecmd_msg *msg)
+static int make_rinit(struct tracecmd_msg *msg, int total_cpus, int *ports)
 {
 	int size = MIN_RINIT_SIZE;
 	be32 *ptr;
 	be32 port;
 	int i;
 
-	msg->rinit.cpus = htonl(cpu_count);
+	msg->rinit.cpus = htonl(total_cpus);
 
-	msg->port_array = malloc(sizeof(*port_array) * cpu_count);
+	msg->port_array = malloc(sizeof(*ports) * total_cpus);
 	if (!msg->port_array)
 		return -ENOMEM;
 
-	size += sizeof(*port_array) * cpu_count;
+	size += sizeof(*ports) * total_cpus;
 
 	ptr = msg->port_array;
 
-	for (i = 0; i < cpu_count; i++) {
+	for (i = 0; i < total_cpus; i++) {
 		/* + rrqports->cpus or rrqports->port_array[i] */
-		port = htonl(port_array[i]);
+		port = htonl(ports[i]);
 		*ptr = port;
 		ptr++;
 	}
@@ -501,11 +500,8 @@ int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
 	struct tracecmd_msg msg;
 	int ret;
 
-	cpu_count = total_cpus;
-	port_array = ports;
-
 	tracecmd_msg_init(MSG_RINIT, &msg);
-	ret = make_rinit(&msg);
+	ret = make_rinit(&msg, total_cpus, ports);
 	if (ret < 0)
 		return ret;
 
-- 
2.13.2
