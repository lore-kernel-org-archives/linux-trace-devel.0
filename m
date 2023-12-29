Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5967517D1
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A4AC433CA;
	Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Ou-00000000I4j-2R42;
	Thu, 28 Dec 2023 22:19:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] trace-cmd show: Add option to read buffer_percent
Date: Thu, 28 Dec 2023 22:16:46 -0500
Message-ID: <20231229031907.69432-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231229031907.69432-1-rostedt@goodmis.org>
References: <20231229031907.69432-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add trace-cmd show --buffer_percent to show the value of the buffer_percent
file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-show.1.txt | 8 ++++++++
 tracecmd/trace-show.c                        | 6 ++++++
 tracecmd/trace-usage.c                       | 1 +
 3 files changed, 15 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-show.1.txt b/Documentation/trace-cmd/trace-cmd-show.1.txt
index ac40dacf7061..f85c070b0598 100644
--- a/Documentation/trace-cmd/trace-cmd-show.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-show.1.txt
@@ -65,6 +65,14 @@ OPTIONS
      The ring buffer is broken up into equal size sub-buffers were an event can only
      be as big as the sub-buffer data section (the size minus its meta data).
 
+*--buffer_percent*::
+    Show the percentage the buffer must be filled before a reader that is blocked
+    on the trace_pipe_raw file will be woken up.
+
+  0       : wake up immediately on any new data
+  1 - 99  : wake up on this percentage of the sub-buffers being full
+  100     : wake up after the buffer is full and the writer is on the last sub-buffer
+
 *--ftrace_filter*::
      Show what function filters are set.
 
diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index 17eb098952f7..d91362e47c50 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -20,6 +20,7 @@ enum {
 	OPT_buffer_subbuf_size_kb,
 	OPT_buffer_total_size_kb,
 	OPT_buffer_size_kb,
+	OPT_buffer_percent,
 	OPT_current_tracer,
 	OPT_tracing_on,
 };
@@ -44,6 +45,7 @@ void trace_show(int argc, char **argv)
 		{"buffer_size", no_argument, NULL, OPT_buffer_size_kb},
 		{"buffer_total_size", no_argument, NULL, OPT_buffer_total_size_kb},
 		{"buffer_subbuf_size", no_argument, NULL, OPT_buffer_subbuf_size_kb},
+		{"buffer_percent", no_argument, NULL, OPT_buffer_percent},
 		{"ftrace_filter", no_argument, NULL, OPT_ftrace_filter},
 		{"ftrace_notrace", no_argument, NULL, OPT_ftrace_notrace},
 		{"ftrace_pid", no_argument, NULL, OPT_ftrace_pid},
@@ -108,6 +110,10 @@ void trace_show(int argc, char **argv)
 			show_instance_file(instance, "buffer_subbuf_size_kb");
 			stop = 1;
 			break;
+		case OPT_buffer_percent:
+			show_instance_file(instance, "buffer_percent");
+			stop = 1;
+			break;
 		case OPT_ftrace_filter:
 			show_instance_file(instance, "set_ftrace_filter");
 			stop = 1;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 7dc9b1871398..3e5456d27e3d 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -181,6 +181,7 @@ static struct usage_help usage_help[] = {
 		"          --buffer_size (for buffer_size_kb)\n"
 		"          --buffer_total_size (for buffer_total_size_kb)\n"
 		"          --buffer_subbuf_size (for buffer_subbuf_size_kb)\n"
+		"          --buffer_percent (for buffer_percent)\n"
 		"          --ftrace_filter (for set_ftrace_filter)\n"
 		"          --ftrace_notrace (for set_ftrace_notrace)\n"
 		"          --ftrace_pid (for set_ftrace_pid)\n"
-- 
2.42.0

