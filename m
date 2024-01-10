Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03994F88A
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 23:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FB4C433C7;
	Wed, 10 Jan 2024 23:02:03 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNhbE-00000000Ut0-2hd0;
	Wed, 10 Jan 2024 18:03:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd record: Add --subbuf-size option
Date: Wed, 10 Jan 2024 18:00:28 -0500
Message-ID: <20240110230303.118668-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110230303.118668-1-rostedt@goodmis.org>
References: <20240110230303.118668-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add an option that will change the sub-buffer size if the kernel supports
it.

Also change the '-b' option that changes the buffer size to use the
libtracefs helper function: tracefs_instance_set_buffer_size().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-record.1.txt          | 15 +++++++
 tracecmd/include/trace-local.h                |  1 +
 tracecmd/trace-record.c                       | 44 ++++++++++++-------
 tracecmd/trace-usage.c                        |  1 +
 4 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index f46b2564c73a..7cb652bc3c0c 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -198,6 +198,21 @@ OPTIONS
     inside the kernel. Using "-b 10000" on a machine with 4 CPUs will make
     Ftrace have a total buffer size of 40 Megs.
 
+*--subbuf-size*::
+    The Linux kernel tracing ring buffer is broken up into sub-buffers.
+    These sub-buffers are typically the size of the architecture "page-size".
+    (4096 or x86). An event can only be as big as the data portion of a
+    sub-buffer, but in most cases that's not an issue. But the time the
+    writer takes to switch from one sub-buffer to the next has a bit more
+    overhead than adding events within the sub-buffer. By increasing its
+    size, it will allow bigger events (although that is seldom an issue)
+    but also speed up the tracing itself.
+
+    The downside of larger sub-buffers is that a "read" of the ring buffer
+    will pull the sub-buffer size out of the ring buffer and replace it
+    with a new sub-buffer. This may not have any real impact, but it may
+    change the behavior slightly. Or it may not!
+
 *-B* 'buffer-name'::
     If the kernel supports multiple buffers, this will add a buffer with
     the given name. If the buffer name already exists, that buffer is just
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 557b2eb0fb07..03738c518aa8 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -286,6 +286,7 @@ struct buffer_instance {
 	int			tracing_on_init_val;
 	int			tracing_on_fd;
 	int			buffer_size;
+	int			subbuf_size;
 	int			cpu_count;
 
 	int			proxy_fd;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3114a6646846..4646d8eb41f6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5099,10 +5099,7 @@ static char *get_date_to_ts(void)
 static void set_buffer_size_instance(struct buffer_instance *instance)
 {
 	int buffer_size = instance->buffer_size;
-	char buf[BUFSIZ];
-	char *path;
 	int ret;
-	int fd;
 
 	if (is_guest(instance))
 		return;
@@ -5113,29 +5110,38 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	if (buffer_size < 0)
 		die("buffer size must be positive");
 
-	snprintf(buf, BUFSIZ, "%d", buffer_size);
+	ret = tracefs_instance_set_buffer_size(instance->tracefs, buffer_size, -1);
+	if (ret < 0)
+		warning("Can't set buffer size");
+}
 
-	path = tracefs_instance_get_file(instance->tracefs, "buffer_size_kb");
-	fd = open(path, O_WRONLY);
-	if (fd < 0) {
-		warning("can't open %s", path);
-		goto out;
-	}
+static void set_subbuf_size_instance(struct buffer_instance *instance)
+{
+	int subbuf_size = instance->subbuf_size;
+	int ret;
+
+	if (is_guest(instance))
+		return;
+
+	if (!subbuf_size)
+		return;
+
+	if (subbuf_size < 0)
+		die("sub-buffer size must be positive");
 
-	ret = write(fd, buf, strlen(buf));
+	ret = tracefs_instance_set_subbuf_size(instance->tracefs, subbuf_size);
 	if (ret < 0)
-		warning("Can't write to %s", path);
-	close(fd);
- out:
-	tracefs_put_tracing_file(path);
+		warning("Can't set sub-buffer size");
 }
 
 void set_buffer_size(void)
 {
 	struct buffer_instance *instance;
 
-	for_all_instances(instance)
+	for_all_instances(instance) {
 		set_buffer_size_instance(instance);
+		set_subbuf_size_instance(instance);
+	}
 }
 
 static int
@@ -5916,6 +5922,7 @@ enum {
 	OPT_temp		= 262,
 	OPT_notimeout		= 264,
 	OPT_daemonize		= 265,
+	OPT_subbuf		= 266,
 };
 
 void trace_stop(int argc, char **argv)
@@ -6343,6 +6350,7 @@ static void parse_record_options(int argc,
 			{"file-version", required_argument, NULL, OPT_file_ver},
 			{"proxy", required_argument, NULL, OPT_proxy},
 			{"temp", required_argument, NULL, OPT_temp},
+			{"subbuf-size", required_argument, NULL, OPT_subbuf},
 			{"daemonize", no_argument, NULL, OPT_daemonize},
 			{NULL, 0, NULL, 0}
 		};
@@ -6829,6 +6837,10 @@ static void parse_record_options(int argc,
 				die("TSC to nanosecond is not supported");
 			ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
 			break;
+		case OPT_subbuf:
+			check_instance_die(ctx->instance, "--subbuf-size");
+			ctx->instance->subbuf_size = atoi(optarg);
+			break;
 		case OPT_poll:
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
 			recorder_flags |= TRACECMD_RECORD_POLL;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 61acce5f18d2..6944a2c7cf29 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -55,6 +55,7 @@ static struct usage_help usage_help[] = {
 		"          -G when profiling, set soft and hard irqs as global\n"
 		"          --quiet print no output to the screen\n"
 		"          --temp specify a directory to store the temp files used to create trace.dat\n"
+		"          --subbuf-size to specify the sub-buffer size in kilobytes\n"
 		"          --module filter module name\n"
 		"          --by-comm used with --profile, merge events for related comms\n"
 		"          --profile enable tracing options needed for report --profile\n"
-- 
2.43.0

