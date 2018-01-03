Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeACRxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:41 -0500
Message-Id: <20180103175340.069022754@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 36/38] trace-cmd record: Allow instances to be recorded over the network
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0036-trace-cmd-record-Allow-instances-to-be-recorded-over.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Allow buffer instances to be used when recording to another machine.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-record.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index 5f7231b0fda2..e0dd5570a536 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -2629,10 +2629,6 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 	char *file;
 	int pid;
 
-	/* network for buffer instances not supported yet */
-	if (client_ports && instance->name)
-		return 0;
-
 	if (type != TRACE_TYPE_EXTRACT) {
 		signal(SIGUSR1, flush);
 
@@ -2651,8 +2647,18 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 	}
 
 	if (client_ports) {
+		char *path;
+
 		connect_port(cpu);
-		recorder = tracecmd_create_recorder_fd(client_ports[cpu], cpu, recorder_flags);
+		if (instance->name)
+			path = get_instance_dir(instance);
+		else
+			path = tracecmd_find_tracing_dir();
+		recorder = tracecmd_create_buffer_recorder_fd(client_ports[cpu],
+							      cpu, recorder_flags,
+							      path);
+		if (instance->name)
+			tracecmd_put_tracing_file(path);
 	} else {
 		file = get_temp_file(instance, cpu);
 		recorder = create_recorder_instance(instance, file, cpu, brass);
-- 
2.13.2
