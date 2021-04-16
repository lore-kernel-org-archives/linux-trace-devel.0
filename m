Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AEBC43470
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A7916124B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhDPRYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:24:01 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:24135 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235935AbhDPRYB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 13:24:01 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 10:23:31 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id E64FE20454;
        Fri, 16 Apr 2021 10:23:35 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd stat: Add -o option to show options
Date:   Fri, 16 Apr 2021 13:23:31 -0400
Message-ID: <20210416172331.3870833-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416172331.3870833-1-rostedt@goodmis.org>
References: <20210416172331.3870833-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add "-o" to trace-cmd stat to list the options that are enabled or disable
(like it does with trace-cmd list). The difference with stat is that it
allows you to see the available options for an instance, where as
trace-cmd list does not.

 trace-cmd stat -B foo -o

Will list the options that are set for instance foo.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-stat.1.txt |  4 ++++
 tracecmd/include/trace-local.h               |  1 +
 tracecmd/trace-list.c                        | 18 +++++++++++-------
 tracecmd/trace-stat.c                        | 14 +++++++++++---
 tracecmd/trace-usage.c                       |  3 ++-
 5 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-stat.1.txt b/Documentation/trace-cmd/trace-cmd-stat.1.txt
index 1be9e609..fb800f91 100644
--- a/Documentation/trace-cmd/trace-cmd-stat.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stat.1.txt
@@ -55,6 +55,10 @@ OPTIONS
     If *-B* is also specified, show the status of the top level tracing directory
     as well as the instance(s).
 
+*-o*::
+    Display the all the options along with their values. If they start with "no", then
+    the option is disabled.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d504ea14..bd1602eb 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -294,6 +294,7 @@ void add_instance(struct buffer_instance *instance, int cpu_count);
 void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
+void show_options(const char *prefix, struct buffer_instance *buffer);
 
 struct trace_guest {
 	char *name;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 0ba49853..4615b322 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -255,14 +255,18 @@ static void show_tracers(void)
 	show_file("available_tracers");
 }
 
-static void show_options(void)
+void show_options(const char *prefix, struct buffer_instance *buffer)
 {
+	struct tracefs_instance *instance = buffer ? buffer->tracefs : NULL;
 	struct dirent *dent;
 	struct stat st;
 	char *path;
 	DIR *dir;
 
-	path = tracefs_get_tracing_file("options");
+	if (!prefix)
+		prefix = "";
+
+	path = tracefs_instance_get_file(instance, "options");
 	if (!path)
 		goto show_file;
 	if (stat(path, &st) < 0)
@@ -288,12 +292,12 @@ static void show_options(void)
 		ret = asprintf(&file, "options/%s", name);
 		if (ret < 0)
 			die("Failed to allocate file name");
-		ret = tracefs_instance_file_read_number(NULL, file, &val);
+		ret = tracefs_instance_file_read_number(instance, file, &val);
 		if (!ret) {
 			if (val)
-				printf("%s\n", name);
+				printf("%s%s\n", prefix, name);
 			else
-				printf("no%s\n", name);
+				printf("%sno%s\n", prefix, name);
 		}
 		free(file);
 	}
@@ -549,7 +553,7 @@ void trace_list(int argc, char **argv)
 		show_tracers();
 
 	if (options)
-		show_options();
+		show_options(NULL, NULL);
 
 	if (plug)
 		show_plugins();
@@ -575,7 +579,7 @@ void trace_list(int argc, char **argv)
 		printf("\ntracers:\n");
 		show_tracers();
 		printf("\noptions:\n");
-		show_options();
+		show_options(NULL, NULL);
 	}
 
 	return;
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index e640a9e5..d1003c38 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -835,7 +835,7 @@ static void report_traceon(struct buffer_instance *instance)
 	free(str);
 }
 
-static void stat_instance(struct buffer_instance *instance)
+static void stat_instance(struct buffer_instance *instance, bool opt)
 {
 	if (instance != &top_instance) {
 		if (instance != first_instance)
@@ -859,6 +859,10 @@ static void stat_instance(struct buffer_instance *instance)
 	report_file(instance, "set_event_pid", "", "Filtered event PIDs:\n");
 	report_file(instance, "set_ftrace_pid", "no pid",
 		    "Filtered function tracer PIDs:\n");
+	if (opt) {
+		printf("\nOptions:\n");
+		show_options("   ", instance);
+	}
 	report_traceon(instance);
 	report_file(instance, "error_log", "", "Error log:\n");
 	if (instance == &top_instance)
@@ -868,6 +872,7 @@ static void stat_instance(struct buffer_instance *instance)
 void trace_stat (int argc, char **argv)
 {
 	struct buffer_instance *instance = &top_instance;
+	bool opt = false;
 	int topt = 0;
 	int status;
 	int c;
@@ -875,7 +880,7 @@ void trace_stat (int argc, char **argv)
 	init_top_instance();
 
 	for (;;) {
-		c = getopt(argc-1, argv+1, "htB:");
+		c = getopt(argc-1, argv+1, "htoB:");
 		if (c == -1)
 			break;
 		switch (c) {
@@ -896,6 +901,9 @@ void trace_stat (int argc, char **argv)
 			topt = 1;
 			instance = &top_instance;
 			break;
+		case 'o':
+			opt = 1;
+			break;
 		default:
 			usage(argv);
 		}
@@ -904,7 +912,7 @@ void trace_stat (int argc, char **argv)
 	update_first_instance(instance, topt);
 
 	for_all_instances(instance) {
-		stat_instance(instance);
+		stat_instance(instance, opt);
 	}
 
 	if (tracecmd_stack_tracer_status(&status) >= 0) {
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 094c6397..3faa287b 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -258,9 +258,10 @@ static struct usage_help usage_help[] = {
 	{
 		"stat",
 		"show the status of the running tracing (ftrace) system",
-		" %s stat [-B buf][-t]"
+		" %s stat [-B buf][-t][-o]"
 		"          -B show the status of a instance buffer\n"
 		"          -t show the top level status along with buffer specified by -B\n"
+		"          -o list tracing options\n"
 	},
 	{
 		"split",
-- 
2.29.2

