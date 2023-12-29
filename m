Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961651C26
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E402C433CB;
	Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Ou-00000000I4n-2Y1s;
	Thu, 28 Dec 2023 22:19:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] trace-cmd stat: Use tracefs_instance_file_read()
Date: Thu, 28 Dec 2023 22:16:47 -0500
Message-ID: <20231229031907.69432-5-rostedt@goodmis.org>
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

Instead of open coding reading an instance file, use the libtracefs
library tracefs_instance_file_read().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 45 ++++++++-----------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 391a05ffcec9..9a6e22254b48 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -24,19 +24,6 @@ static inline int is_top_instance(struct buffer_instance *instance)
 	return instance == &top_instance;
 }
 
-static int get_instance_file_fd(struct buffer_instance *instance,
-				const char *file)
-{
-	char *path;
-	int fd;
-
-	path = tracefs_instance_get_file(instance->tracefs, file);
-	fd = open(path, O_RDONLY);
-	tracefs_put_tracing_file(path);
-
-	return fd;
-}
-
 char *strstrip(char *str)
 {
 	char *s;
@@ -108,22 +95,6 @@ char *get_file_content(const char *file)
 	return str;
 }
 
-static char *get_instance_file_content(struct buffer_instance *instance,
-				       const char *file)
-{
-	char *str = NULL;
-	int fd;
-
-	fd = get_instance_file_fd(instance, file);
-	if (fd < 0)
-		return NULL;
-
-	str = get_fd_content(fd, file);
-
-	close(fd);
-	return str;
-}
-
 static void report_file(struct buffer_instance *instance,
 			char *name, char *def_value, char *description)
 {
@@ -132,7 +103,7 @@ static void report_file(struct buffer_instance *instance,
 
 	if (!tracefs_file_exists(instance->tracefs, name))
 		return;
-	str = get_instance_file_content(instance, name);
+	str = tracefs_instance_file_read(instance->tracefs, name, NULL);
 	if (!str)
 		return;
 	cont = strstrip(str);
@@ -346,7 +317,7 @@ static void report_events(struct buffer_instance *instance)
 	enum event_process processed = PROCESSED_NONE;
 	enum event_process processed_part = PROCESSED_NONE;
 
-	str = get_instance_file_content(instance, "events/enable");
+	str = tracefs_instance_file_read(instance->tracefs, "events/enable", NULL);
 	if (!str)
 		return;
 
@@ -664,7 +635,7 @@ static void report_buffers(struct buffer_instance *instance)
 	char file[FILE_SIZE];
 	int cpu;
 
-	str = get_instance_file_content(instance, "buffer_size_kb");
+	str = tracefs_instance_file_read(instance->tracefs, "buffer_size_kb", NULL);
 	if (!str)
 		return;
 
@@ -684,7 +655,7 @@ static void report_buffers(struct buffer_instance *instance)
 	for (cpu = 0; ; cpu++) {
 
 		snprintf(file, FILE_SIZE, "per_cpu/cpu%d/buffer_size_kb", cpu);
-		str = get_instance_file_content(instance, file);
+		str = tracefs_instance_file_read(instance->tracefs, file, NULL);
 		if (!str)
 			break;
 
@@ -699,7 +670,7 @@ static void report_buffers(struct buffer_instance *instance)
  total:
 	free(str);
 
-	str = get_instance_file_content(instance, "buffer_total_size_kb");
+	str = tracefs_instance_file_read(instance->tracefs, "buffer_total_size_kb", NULL);
 	if (!str)
 		return;
 
@@ -733,7 +704,7 @@ static void report_cpumask(struct buffer_instance *instance)
 	int n;
 	int i;
 
-	str = get_instance_file_content(instance, "tracing_cpumask");
+	str = tracefs_instance_file_read(instance->tracefs, "tracing_cpumask", NULL);
 	if (!str)
 		return;
 
@@ -783,7 +754,7 @@ static void report_probes(struct buffer_instance *instance,
 	int newline;
 	int i;
 
-	str = get_instance_file_content(instance, file);
+	str = tracefs_instance_file_read(instance->tracefs, file, NULL);
 	if (!str)
 		return;
 
@@ -828,7 +799,7 @@ static void report_traceon(struct buffer_instance *instance)
 	char *str;
 	char *cont;
 
-	str = get_instance_file_content(instance, "tracing_on");
+	str = tracefs_instance_file_read(instance->tracefs, "tracing_on", NULL);
 	if (!str)
 		return;
 
-- 
2.42.0

