Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CC11857
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B7BC433C9;
	Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Ou-00000000I4e-2JRT;
	Thu, 28 Dec 2023 22:19:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] trace-cmd show: Add --buffer-subbuf-size option
Date: Thu, 28 Dec 2023 22:16:45 -0500
Message-ID: <20231229031907.69432-3-rostedt@goodmis.org>
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

Add an option to trace-cmd show that displays the subbuffer size in
kilobytes.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-show.1.txt | 5 +++++
 tracecmd/trace-show.c                        | 6 ++++++
 tracecmd/trace-usage.c                       | 1 +
 3 files changed, 12 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-show.1.txt b/Documentation/trace-cmd/trace-cmd-show.1.txt
index ea2fda285e18..ac40dacf7061 100644
--- a/Documentation/trace-cmd/trace-cmd-show.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-show.1.txt
@@ -60,6 +60,11 @@ OPTIONS
 *--buffer_total_size*::
      Show the total size of all buffers.
 
+*--buffer_subbuf_size*::
+     Show the size in kilobytes of the sub-buffers of the ring buffer.
+     The ring buffer is broken up into equal size sub-buffers were an event can only
+     be as big as the sub-buffer data section (the size minus its meta data).
+
 *--ftrace_filter*::
      Show what function filters are set.
 
diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index 796c587c0cd0..17eb098952f7 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -17,6 +17,7 @@ enum {
 	OPT_ftrace_pid,
 	OPT_ftrace_notrace,
 	OPT_ftrace_filter,
+	OPT_buffer_subbuf_size_kb,
 	OPT_buffer_total_size_kb,
 	OPT_buffer_size_kb,
 	OPT_current_tracer,
@@ -42,6 +43,7 @@ void trace_show(int argc, char **argv)
 		{"current_tracer", no_argument, NULL, OPT_current_tracer},
 		{"buffer_size", no_argument, NULL, OPT_buffer_size_kb},
 		{"buffer_total_size", no_argument, NULL, OPT_buffer_total_size_kb},
+		{"buffer_subbuf_size", no_argument, NULL, OPT_buffer_subbuf_size_kb},
 		{"ftrace_filter", no_argument, NULL, OPT_ftrace_filter},
 		{"ftrace_notrace", no_argument, NULL, OPT_ftrace_notrace},
 		{"ftrace_pid", no_argument, NULL, OPT_ftrace_pid},
@@ -102,6 +104,10 @@ void trace_show(int argc, char **argv)
 			show_instance_file(instance, "buffer_total_size_kb");
 			stop = 1;
 			break;
+		case OPT_buffer_subbuf_size_kb:
+			show_instance_file(instance, "buffer_subbuf_size_kb");
+			stop = 1;
+			break;
 		case OPT_ftrace_filter:
 			show_instance_file(instance, "set_ftrace_filter");
 			stop = 1;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 37d576b009ac..7dc9b1871398 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -180,6 +180,7 @@ static struct usage_help usage_help[] = {
 		"          --current_tracer\n"
 		"          --buffer_size (for buffer_size_kb)\n"
 		"          --buffer_total_size (for buffer_total_size_kb)\n"
+		"          --buffer_subbuf_size (for buffer_subbuf_size_kb)\n"
 		"          --ftrace_filter (for set_ftrace_filter)\n"
 		"          --ftrace_notrace (for set_ftrace_notrace)\n"
 		"          --ftrace_pid (for set_ftrace_pid)\n"
-- 
2.42.0

