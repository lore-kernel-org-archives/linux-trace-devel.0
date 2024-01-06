Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AD817D2
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A8DC433C7;
	Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLyEY-00000001An5-0LeE;
	Fri, 05 Jan 2024 23:24:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd show: Add --hist and --trigger options
Date: Fri,  5 Jan 2024 23:22:27 -0500
Message-ID: <20240106042428.279706-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240106042428.279706-1-rostedt@goodmis.org>
References: <20240106042428.279706-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the option --hist [<system>:]<event> to show the histogram output of a
given event, and --trigger [<system>:]<event> to show the content of the
trigger file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-show.1.txt |  6 +++
 tracecmd/trace-show.c                        | 51 ++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-show.1.txt b/Documentation/trace-cmd/trace-cmd-show.1.txt
index f85c070b0598..6d397b842a21 100644
--- a/Documentation/trace-cmd/trace-cmd-show.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-show.1.txt
@@ -88,6 +88,12 @@ OPTIONS
 *--graph_notrace*::
      Show the functions that will not be graphed.
 
+*--hist* '[system:]event'::
+     Show the content of a histogram "hist" file for a given event
+
+*--trigger* '[system:]event'::
+     Show the content of the "trigger" file for a given event
+
 *--cpumask*::
      Show the mask of CPUs that tracing will trace.
 
diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index d91362e47c50..cf70d86ca61c 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -23,6 +23,8 @@ enum {
 	OPT_buffer_percent,
 	OPT_current_tracer,
 	OPT_tracing_on,
+	OPT_hist,
+	OPT_trigger,
 };
 
 void trace_show(int argc, char **argv)
@@ -31,6 +33,8 @@ void trace_show(int argc, char **argv)
 	const char *file = "trace";
 	const char *cpu = NULL;
 	struct buffer_instance *instance = &top_instance;
+	char *hist = NULL;
+	char *trigger = NULL;
 	char cpu_path[128];
 	char *path;
 	int snap = 0;
@@ -40,6 +44,8 @@ void trace_show(int argc, char **argv)
 	int stop = 0;
 	int c;
 	static struct option long_options[] = {
+		{"hist", required_argument, NULL, OPT_hist},
+		{"trigger", required_argument, NULL, OPT_trigger},
 		{"tracing_on", no_argument, NULL, OPT_tracing_on},
 		{"current_tracer", no_argument, NULL, OPT_current_tracer},
 		{"buffer_size", no_argument, NULL, OPT_buffer_size_kb},
@@ -90,6 +96,13 @@ void trace_show(int argc, char **argv)
 			if (snap)
 				die("Can not have -s and -p together");
 			break;
+		case OPT_hist:
+			hist = optarg;
+			break;
+		case OPT_trigger:
+			trigger = optarg;
+			break;
+
 		case OPT_tracing_on:
 			show_instance_file(instance, "tracing_on");
 			stop = 1;
@@ -149,6 +162,44 @@ void trace_show(int argc, char **argv)
 	else if (snap)
 		file = "snapshot";
 
+	if (hist || trigger) {
+		char **systems = NULL;
+		char *system = NULL;
+		char *event = hist ? hist : trigger;
+		char *file = hist ? "hist" : "trigger";
+		char *p;
+
+		if ((p = strstr(event, ":"))) {
+			system = event;
+			event = p + 1;
+			*p = '\0';
+		}
+
+		if (!system) {
+			systems = tracefs_event_systems(NULL);
+
+			for (int i = 0; systems && systems[i]; i++) {
+				system = systems[i];
+				if (tracefs_event_file_exists(instance->tracefs,
+							      system, event, file))
+					break;
+			}
+			if (!system)
+				die("Could not find system of event %s",
+				    event);
+		}
+
+		path = tracefs_event_file_read(instance->tracefs,
+					       system, event, file, NULL);
+		tracefs_list_free(systems);
+		if (!path)
+			die("Could not find hist for %s%s%s",
+			    system ? system : "", system ? ":":"", event);
+		printf("%s\n", path);
+		free(path);
+		exit(0);
+	}
+
 	if (cpu) {
 		char *endptr;
 		long val;
-- 
2.42.0

