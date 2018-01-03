Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbeACRxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:39 -0500
Message-Id: <20180103175337.977278626@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 22/38] trace-cmd: Pass cpu_count instead of having it as a global
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0022-trace-cmd-Pass-cpu_count-instead-of-having-it-as-a-g.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Pass in the cpu_count to the msg code from trace record instead of using a
global variable.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    | 2 +-
 trace-msg.c    | 9 ++++-----
 trace-msg.h    | 1 -
 trace-record.c | 3 ++-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 37177a6b6c3e..5a5b6bf88574 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -297,7 +297,7 @@ void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
 
 /* for clients */
-int tracecmd_msg_send_init_data(int fd);
+int tracecmd_msg_send_init_data(int fd, int total_cpus);
 int tracecmd_msg_metadata_send(int fd, const char *buf, int size);
 int tracecmd_msg_finish_sending_metadata(int fd);
 void tracecmd_msg_send_close_msg(void);
diff --git a/trace-msg.c b/trace-msg.c
index 0402a069ff21..9fefe22753d9 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -64,7 +64,6 @@ typedef __be32 be32;
 
 /* for both client and server */
 bool use_tcp;
-int cpu_count;
 
 /* for client */
 static int psfd;
@@ -162,7 +161,7 @@ enum msg_opt_command {
 	MSGOPT_USETCP = 1,
 };
 
-static int make_tinit(struct tracecmd_msg *msg)
+static int make_tinit(struct tracecmd_msg *msg, int total_cpus)
 {
 	struct tracecmd_msg_opt *opt;
 	int opt_num = 0;
@@ -179,7 +178,7 @@ static int make_tinit(struct tracecmd_msg *msg)
 		size += sizeof(*opt);
 	}
 
-	msg->tinit.cpus = htonl(cpu_count);
+	msg->tinit.cpus = htonl(total_cpus);
 	msg->tinit.page_size = htonl(page_size);
 	msg->tinit.opt_num = htonl(opt_num);
 
@@ -368,7 +367,7 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	return 0;
 }
 
-int tracecmd_msg_send_init_data(int fd)
+int tracecmd_msg_send_init_data(int fd, int total_cpus)
 {
 	struct tracecmd_msg send_msg;
 	struct tracecmd_msg recv_msg;
@@ -376,7 +375,7 @@ int tracecmd_msg_send_init_data(int fd)
 	int ret;
 
 	tracecmd_msg_init(MSG_TINIT, &send_msg);
-	ret = make_tinit(&send_msg);
+	ret = make_tinit(&send_msg, total_cpus);
 	if (ret < 0)
 		return ret;
 
diff --git a/trace-msg.h b/trace-msg.h
index feae24ff4fd6..fe72c9d76829 100644
--- a/trace-msg.h
+++ b/trace-msg.h
@@ -12,7 +12,6 @@
 
 /* for both client and server */
 extern bool use_tcp;
-extern int cpu_count;
 
 /* for client */
 extern unsigned int page_size;
diff --git a/trace-record.c b/trace-record.c
index 48640af8acac..396050bbaae7 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -79,6 +79,7 @@ static const char *output_file = "trace.dat";
 
 static int latency;
 static int sleep_time = 1000;
+static int cpu_count;
 static int recorder_threads;
 static struct pid_record_data *pids;
 static int buffers;
@@ -2755,7 +2756,7 @@ static void communicate_with_listener_v1(int fd)
 
 static void communicate_with_listener_v2(int fd)
 {
-	if (tracecmd_msg_send_init_data(fd) < 0)
+	if (tracecmd_msg_send_init_data(fd, cpu_count) < 0)
 		die("Cannot communicate with server");
 }
 
-- 
2.13.2
