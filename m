Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E33C56201
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65194246CB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgKRVrC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 16:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgKRVrB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 16:47:01 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D03D8221EB;
        Wed, 18 Nov 2020 21:46:59 +0000 (UTC)
Date:   Wed, 18 Nov 2020 16:46:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4.1 5.2/8] libtracefs: Combine allocate and create APIs
 into one
Message-ID: <20201118164657.7c6197e8@oasis.local.home>
In-Reply-To: <20201118164416.4cf12941@oasis.local.home>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
        <20201117074557.180602-6-tz.stoyanov@gmail.com>
        <20201118164416.4cf12941@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Having two APIs for allocating and creating trace instance can be
confusing. The tracefs_instance_alloc() is removed and its logic is
moved to tracefs_instance_create() API. This single API first creates
the instance in the system (if it does not exist) and then allocates and
initializes tracefs_instance structure. Trace-cmd code and unit tests are
modified to use the new API.
A new API is introduced, to check if the tracefs instance is newly
created by the library or if it already exist.
  tracefs_instance_is_new()

Link: https://lore.kernel.org/linux-trace-devel/20201117074557.180602-6-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs/tracefs.h      |  4 +-
 lib/trace-cmd/trace-timesync.c |  3 +-
 lib/tracefs/tracefs-instance.c | 56 ++++++++++++++++++++-------
 tracecmd/include/trace-local.h |  4 +-
 tracecmd/trace-record.c        | 70 ++++++++++++++++------------------
 tracecmd/trace-show.c          |  2 +-
 tracecmd/trace-stat.c          |  2 +-
 utest/tracefs-utest.c          | 25 ++++++------
 8 files changed, 94 insertions(+), 72 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index ef806d3c..388d8f94 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -20,10 +20,10 @@ char *tracefs_find_tracing_dir(void);
 /* ftarce instances */
 struct tracefs_instance;
 
-struct tracefs_instance *tracefs_instance_alloc(const char *name);
 void tracefs_instance_free(struct tracefs_instance *instance);
-int tracefs_instance_create(struct tracefs_instance *instance);
+struct tracefs_instance *tracefs_instance_create(const char *name);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
+bool tracefs_instance_is_new(struct tracefs_instance *instance);
 const char *tracefs_instance_get_name(struct tracefs_instance *instance);
 char *
 tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 35a41394..7a6a7eb6 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -240,11 +240,10 @@ clock_synch_create_instance(const char *clock, unsigned int cid)
 
 	snprintf(inst_name, 256, "clock_synch-%d", cid);
 
-	instance = tracefs_instance_alloc(inst_name);
+	instance = tracefs_instance_create(inst_name);
 	if (!instance)
 		return NULL;
 
-	tracefs_instance_create(instance);
 	tracefs_instance_file_write(instance, "trace", "\0");
 	if (clock)
 		tracefs_instance_file_write(instance, "trace_clock", clock);
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 13ec4f5f..d7a29e7d 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -17,17 +17,19 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
+#define FLAG_INSTANCE_NEWLY_CREATED	(1 << 0)
 struct tracefs_instance {
-	char *name;
+	char	*name;
+	int	flags;
 };
 
 /**
- * tracefs_instance_alloc - allocate a new ftrace instance
+ * instance_alloc - allocate a new ftrace instance
  * @name: The name of the instance (instance will point to this)
  *
  * Returns a newly allocated instance, or NULL in case of an error.
  */
-struct tracefs_instance *tracefs_instance_alloc(const char *name)
+static struct tracefs_instance *instance_alloc(const char *name)
 {
 	struct tracefs_instance *instance;
 
@@ -45,7 +47,7 @@ struct tracefs_instance *tracefs_instance_alloc(const char *name)
 
 /**
  * tracefs_instance_free - Free an instance, previously allocated by
-			   tracefs_instance_alloc()
+			   tracefs_instance_create()
  * @instance: Pointer to the instance to be freed
  *
  */
@@ -76,30 +78,58 @@ out:
 	return rmode;
 }
 
+/**
+ * tracefs_instance_is_new - Check if the instance is newly created by the library
+ * @instance: Pointer to an ftrace instance
+ *
+ * Returns true, if the ftrace instance is newly created by the library or
+ * false otherwise.
+ */
+bool tracefs_instance_is_new(struct tracefs_instance *instance)
+{
+	if (instance && (instance->flags & FLAG_INSTANCE_NEWLY_CREATED))
+		return true;
+	return false;
+}
+
 /**
  * tracefs_instance_create - Create a new ftrace instance
- * @instance: Pointer to the instance to be created
+ * @name: Name of the instance to be created
  *
- * Returns 1 if the instance already exist, 0 if the instance
- * is created successful or -1 in case of an error
+ * Allocates and initializes a new instance structure. If the instance does not
+ * exist in the system, create it.
+ * Returns a pointer to a newly allocated instance, or NULL in case of an error.
+ * The returned instance must be freed by tracefs_instance_free().
  */
-int tracefs_instance_create(struct tracefs_instance *instance)
+struct tracefs_instance *tracefs_instance_create(const char *name)
 {
+	struct tracefs_instance *inst = NULL;
 	struct stat st;
 	mode_t mode;
 	char *path;
 	int ret;
 
-	path = tracefs_instance_get_dir(instance);
+	inst = instance_alloc(name);
+	if (!inst)
+		return NULL;
+
+	path = tracefs_instance_get_dir(inst);
 	ret = stat(path, &st);
 	if (ret < 0) {
+		/* Cannot create the top instance, if it does not exist! */
+		if (!name)
+			goto error;
 		mode = get_trace_file_permissions("instances");
-		ret = mkdir(path, mode);
-	} else {
-		ret = 1;
+		if (mkdir(path, mode))
+			goto error;
+		inst->flags |= FLAG_INSTANCE_NEWLY_CREATED;
 	}
 	tracefs_put_tracing_file(path);
-	return ret;
+	return inst;
+
+error:
+	tracefs_instance_free(inst);
+	return NULL;
 }
 
 /**
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d148aa16..207aa68f 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -199,6 +199,7 @@ struct filter_pids {
 
 struct buffer_instance {
 	struct buffer_instance	*next;
+	char			*name;
 	struct tracefs_instance	*tracefs;
 	unsigned long long	trace_id;
 	char			*cpumask;
@@ -277,7 +278,7 @@ extern struct buffer_instance *first_instance;
 #define is_agent(instance)	((instance)->flags & BUFFER_FL_AGENT)
 #define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
 
-struct buffer_instance *create_instance(const char *name);
+struct buffer_instance *allocate_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
 void update_first_instance(struct buffer_instance *instance, int topt);
 
@@ -286,7 +287,6 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
 int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
 
 /* moved from trace-cmd.h */
-void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
 int tracecmd_add_event(const char *event_str, int stack);
 void tracecmd_enable_events(void);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8cd44dd0..908adb93 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -351,27 +351,37 @@ static void test_set_event_pid(struct buffer_instance *instance)
 }
 
 /**
- * create_instance - allocate a new buffer instance
+ * allocate_instance - allocate a new buffer instance,
+ *			it must exist in the ftrace system
  * @name: The name of the instance (instance will point to this)
  *
- * Returns a newly allocated instance. Note that @name will not be
- * copied, and the instance buffer will point to the string itself.
+ * Returns a newly allocated instance. In case of an error or if the
+ * instance does not exist in the ftrace system, NULL is returned.
  */
-struct buffer_instance *create_instance(const char *name)
+struct buffer_instance *allocate_instance(const char *name)
 {
 	struct buffer_instance *instance;
 
-	instance = malloc(sizeof(*instance));
+	instance = calloc(1, sizeof(*instance));
 	if (!instance)
 		return NULL;
-	memset(instance, 0, sizeof(*instance));
-	instance->tracefs = tracefs_instance_alloc(name);
-	if (!instance->tracefs) {
-		free(instance);
-		return NULL;
+	if (name)
+		instance->name = strdup(name);
+	if (tracefs_instance_exists(name)) {
+		instance->tracefs = tracefs_instance_create(name);
+		if (!instance->tracefs)
+			goto error;
 	}
 
 	return instance;
+
+error:
+	if (instance) {
+		free(instance->name);
+		tracefs_instance_free(instance->tracefs);
+		free(instance);
+	}
+	return NULL;
 }
 
 static int __add_all_instances(const char *tracing_dir)
@@ -418,7 +428,7 @@ static int __add_all_instances(const char *tracing_dir)
 		}
 		free(instance_path);
 
-		instance = create_instance(name);
+		instance = allocate_instance(name);
 		if (!instance)
 			die("Failed to create instance");
 		add_instance(instance, local_cpu_count);
@@ -5034,9 +5044,11 @@ static void make_instances(void)
 	for_each_instance(instance) {
 		if (is_guest(instance))
 			continue;
-		if (tracefs_instance_create(instance->tracefs) > 0) {
+		if (instance->name && !instance->tracefs) {
+			instance->tracefs = tracefs_instance_create(instance->name);
 			/* Don't delete instances that already exist */
-			instance->flags |= BUFFER_FL_KEEP;
+			if (instance->tracefs && !tracefs_instance_is_new(instance->tracefs))
+				instance->flags |= BUFFER_FL_KEEP;
 		}
 	}
 }
@@ -5057,25 +5069,6 @@ void tracecmd_remove_instances(void)
 	}
 }
 
-/**
- * tracecmd_create_top_instance - create a top named instance
- * @name: name of the instance to use.
- *
- * This is a library function for tools that want to do their tracing inside of
- * an instance.  All it does is create an instance and set it as a top instance,
- * you don't want to call this more than once, and you want to call
- * tracecmd_remove_instances to undo your work.
- */
-void tracecmd_create_top_instance(char *name)
-{
-	struct buffer_instance *instance;
-
-	instance = create_instance(name);
-	add_instance(instance, local_cpu_count);
-	update_first_instance(instance, 0);
-	make_instances();
-}
-
 static void check_plugin(const char *plugin)
 {
 	char *buf;
@@ -5533,7 +5526,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 void init_top_instance(void)
 {
 	if (!top_instance.tracefs)
-		top_instance.tracefs = tracefs_instance_alloc(NULL);
+		top_instance.tracefs = tracefs_instance_create(NULL);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
 	top_instance.trace_id = tracecmd_generate_traceid();
@@ -5580,7 +5573,7 @@ void trace_stop(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'B':
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			add_instance(instance, local_cpu_count);
@@ -5620,7 +5613,7 @@ void trace_restart(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'B':
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			add_instance(instance, local_cpu_count);
@@ -5678,7 +5671,7 @@ void trace_reset(int argc, char **argv)
 		}
 		case 'B':
 			last_specified_all = 0;
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			add_instance(instance, local_cpu_count);
@@ -5821,6 +5814,7 @@ static inline void remove_instances(struct buffer_instance *instances)
 	while (instances) {
 		del = instances;
 		instances = instances->next;
+		free(del->name);
 		tracefs_instance_destroy(del->tracefs);
 		tracefs_instance_free(del->tracefs);
 		free(del);
@@ -5978,7 +5972,7 @@ static void parse_record_options(int argc,
 					die("Failed to allocate guest name");
 			}
 
-			ctx->instance = create_instance(name);
+			ctx->instance = allocate_instance(name);
 			ctx->instance->flags |= BUFFER_FL_GUEST;
 			ctx->instance->cid = cid;
 			ctx->instance->port = port;
@@ -6173,7 +6167,7 @@ static void parse_record_options(int argc,
 			ctx->instance->buffer_size = atoi(optarg);
 			break;
 		case 'B':
-			ctx->instance = create_instance(optarg);
+			ctx->instance = allocate_instance(optarg);
 			if (!ctx->instance)
 				die("Failed to create instance");
 			ctx->instance->delete = negative;
diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index a6f21027..eb328527 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -64,7 +64,7 @@ void trace_show(int argc, char **argv)
 			if (buffer)
 				die("Can only show one buffer at a time");
 			buffer = optarg;
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			break;
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 260d0c37..5f79ff8a 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -926,7 +926,7 @@ void trace_stat (int argc, char **argv)
 			usage(argv);
 			break;
 		case 'B':
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			add_instance(instance, tracecmd_count_cpus());
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 2febdb88..31031661 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -179,6 +179,7 @@ static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
+	struct tracefs_instance *second = NULL;
 	const char *name = get_rand_str();
 	const char *inst_name = NULL;
 	const char *tdir;
@@ -198,17 +199,19 @@ static void test_instance_file(void)
 	CU_TEST(stat(inst_dir, &st) != 0);
 
 	CU_TEST(tracefs_instance_exists(name) == false);
-	instance = tracefs_instance_alloc(name);
+	instance = tracefs_instance_create(name);
 	CU_TEST(instance != NULL);
-	CU_TEST(stat(inst_dir, &st) != 0);
-	inst_name = tracefs_instance_get_name(instance);
-	CU_TEST(inst_name != NULL);
-	CU_TEST(strcmp(inst_name, name) == 0);
-
-	CU_TEST(tracefs_instance_create(instance) == 0);
+	CU_TEST(tracefs_instance_is_new(instance));
+	second = tracefs_instance_create(name);
+	CU_TEST(second != NULL);
+	CU_TEST(!tracefs_instance_is_new(second));
+	tracefs_instance_free(second);
 	CU_TEST(tracefs_instance_exists(name) == true);
 	CU_TEST(stat(inst_dir, &st) == 0);
 	CU_TEST(S_ISDIR(st.st_mode));
+	inst_name = tracefs_instance_get_name(instance);
+	CU_TEST(inst_name != NULL);
+	CU_TEST(strcmp(inst_name, name) == 0);
 
 	fname = tracefs_instance_get_dir(NULL);
 	CU_TEST(fname != NULL);
@@ -474,12 +477,8 @@ static int test_suite_init(void)
 	test_tep = tracefs_local_events_system(NULL, systems);
 	if (test_tep == NULL)
 		return 1;
-
-	test_instance = tracefs_instance_alloc(TEST_INSTANCE_NAME);
-	if (test_instance == NULL)
-		return 1;
-
-	if (tracefs_instance_create(test_instance) < 0)
+	test_instance = tracefs_instance_create(TEST_INSTANCE_NAME);
+	if (!test_instance)
 		return 1;
 
 	return 0;
-- 
2.25.4

