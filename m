Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751160AbeACRxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:41 -0500
Message-Id: <20180103175340.370782221@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 38/38] trace-cmd: Add network handle into buffer instance
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0038-trace-cmd-Add-network-handle-into-buffer-instance.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

To allow each instance to have its own network connection, move the
network_handle into the buffer instance structure.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-local.h  |  1 +
 trace-record.c | 11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/trace-local.h b/trace-local.h
index d45c66c31dca..ffdd726af0fc 100644
--- a/trace-local.h
+++ b/trace-local.h
@@ -196,6 +196,7 @@ struct buffer_instance {
 	struct tracecmd_input	*handle;
 
 	struct tracecmd_msg_handle *msg_handle;
+	struct tracecmd_output *network_handle;
 
 	int			flags;
 	int			tracing_on_init_val;
diff --git a/trace-record.c b/trace-record.c
index 814c7e112285..9479f5f8073c 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -89,7 +89,6 @@ static int clear_function_filters;
 static char *host;
 static int *client_ports;
 static int sfd;
-static struct tracecmd_output *network_handle;
 
 /* Max size to let a per cpu file get */
 static int max_kb;
@@ -2892,9 +2891,11 @@ again:
 	return msg_handle;
 }
 
-static struct tracecmd_msg_handle *setup_connection(void)
+static struct tracecmd_msg_handle *
+setup_connection(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle;
+	struct tracecmd_output *network_handle;
 
 	msg_handle = setup_network();
 
@@ -2906,6 +2907,8 @@ static struct tracecmd_msg_handle *setup_connection(void)
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
 							      listed_events);
 
+	instance->network_handle = network_handle;
+
 	/* OK, we are all set, let'r rip! */
 	return msg_handle;
 }
@@ -2940,7 +2943,7 @@ void start_threads(enum trace_type type, int global)
 		int x, pid;
 
 		if (host) {
-			instance->msg_handle = setup_connection();
+			instance->msg_handle = setup_connection(instance);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
 		}
@@ -4902,7 +4905,7 @@ static void finalize_record_trace(struct common_record_context *ctx)
 	}
 
 	if (host)
-		tracecmd_output_close(network_handle);
+		tracecmd_output_close(ctx->instance->network_handle);
 }
 
 /*
-- 
2.13.2
