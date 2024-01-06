Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92751FD9
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 04:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D32C433C7
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 04:57:21 +0000 (UTC)
Date: Fri, 5 Jan 2024 23:57:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix tracefs_instance_reset to clear synthetic
 events
Message-ID: <20240105235720.6f0bb664@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

tracefs_instance_reset() was not clearing synthetic events as there's an
order that is needed in clearing out the triggers.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index b94630a324a1..0ee0225e0222 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1481,9 +1481,12 @@ void tracefs_instance_reset(struct tracefs_instance *instance)
 	int has_trigger = -1;
 	char **systems;
 	struct stat st;
+	char **file_list = NULL;
+	int list_size = 0;
 	char **events;
 	char *file;
 	int i, j;
+	int ret;
 
 	tracefs_trace_off(instance);
 	disable_func_stack_trace_instance(instance);
@@ -1514,8 +1517,15 @@ void tracefs_instance_reset(struct tracefs_instance *instance)
 					else
 						has_trigger = 1;
 				}
-				if (has_trigger)
-					clear_trigger(file);
+				if (has_trigger) {
+					ret = clear_trigger(file);
+					if (ret) {
+						char **list;
+						list = tracefs_list_add(file_list, file);
+						if (list)
+							file_list = list;
+					}
+				}
 				tracefs_put_tracing_file(file);
 			}
 			tracefs_list_free(events);
@@ -1523,6 +1533,25 @@ void tracefs_instance_reset(struct tracefs_instance *instance)
 		tracefs_list_free(systems);
 	}
 
+	while (file_list && list_size != tracefs_list_size(file_list)) {
+		char **list = file_list;
+
+		list_size = tracefs_list_size(file_list);
+		file_list = NULL;
+		for (i = 0; list[i]; i++) {
+			ret = clear_trigger(file);
+			if (ret) {
+				char **tlist;
+				tlist = tracefs_list_add(file_list, list[i]);
+				if (tlist)
+					file_list = tlist;
+			}
+		}
+		tracefs_list_free(list);
+	}
+	tracefs_list_free(file_list);
+
+	tracefs_instance_file_write(instance, "synthetic_events", " ");
 	tracefs_instance_file_write(instance, "error_log", " ");
 	tracefs_instance_file_write(instance, "trace_clock", "local");
 	tracefs_instance_file_write(instance, "set_event_pid", "");
-- 
2.42.0

