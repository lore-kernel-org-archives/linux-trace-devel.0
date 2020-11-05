Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB199C388F7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 784DD20825
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r0QmnFRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgKEJeG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgKEJeF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:05 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72865C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 01:34:05 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id oq3so1621055ejb.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 01:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C6PM9JcM4boc8txO9+EfScmDmzQM1c9iiLvoGe98NTk=;
        b=r0QmnFRgclypgHJj18bBdYhQHowrc36KPNMzJRF3tvq2ncV84XbCvd5NYFgiwfwVZ5
         hjpGUsrP/D2EgKUggib/+cC+AqFSSD8ITmzB9aeMbsOPGR0GrmwXikAbajXd4PZz+E0J
         RQdrsxG3CTzRBwYkLniR+Zfxc86WVq4kpXFRQMB13pMQ0PxOEhwcsMJCRv4QXL4Tz2jp
         HeeiZQZHh0L5JhUwcK8YkOGyahSnh0EDEEhAC6dKzzTR+5UcvfJ1VBunaRj1aKlByxZ9
         3vyMPYYKTIRhFNIeNDP35FrfISlkb3tU2begw5Jbs5BG/OtAkOIm1G45WgRRAGAb0n2M
         IPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C6PM9JcM4boc8txO9+EfScmDmzQM1c9iiLvoGe98NTk=;
        b=aX9zvVPA+ia2yn0XofRIM81NmXDIEQw3arB6LdBwRzr65QaBvVxDpWId80S1g8VcR3
         i8HZnP+7PNo0JL7DcneOjesi7txCin3mfe7jnifsNTzoEuxUzsJhJ4ZO65xfJxQhwZvX
         YFmaGgOoTpeY+EdYnrkrtg3wbK20surhWnrHlqlaSRpzVHC+t9fCONp8D5IWFw8bl/GX
         Hz2rEq6y7tOoAbsNbE5oIzoTdic6fBmaWth+pkqw8zue2cXbcty6QkAvWyVGIdSpm7H+
         TQLWbmYCJBS2dZ9z389oBIIVrLTEEBJ5tim3u6NdDGpLgQ+v4ghk4hjuLfOvbngW09nq
         UWjA==
X-Gm-Message-State: AOAM533QHt5WMbcV//RI+Fr2WgaJeVYZIWqHHsNsk7eK70yyaC5YrJR9
        pwjcbjO6wDd9drW5cQLtAzc=
X-Google-Smtp-Source: ABdhPJyrMewcqexnVA2KaEu8xoP198J9q8Gc1GHTbLPkcFnH878c1FVotdAWNER4KvoNUX2PYRx2yg==
X-Received: by 2002:a17:906:3fd3:: with SMTP id k19mr1514281ejj.434.1604568844129;
        Thu, 05 Nov 2020 01:34:04 -0800 (PST)
Received: from localhost.localdomain ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 1sm586725ejt.107.2020.11.05.01.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:34:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/6] libtracefs: Combine allocate and create APIs into one
Date:   Thu,  5 Nov 2020 11:33:52 +0200
Message-Id: <20201105093354.532742-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105093354.532742-1-tz.stoyanov@gmail.com>
References: <20201105093354.532742-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Having two APIs for allocating and creating trace instance can be
confusing. The tracefs_instance_alloc() is removed and its logic is
moved to tracefs_instance_create() API. This single API first creates
the instance in the system (if it does not exist) and then allocates and
initializes tracefs_instance structure. Trace-cmd code and unit tests are
modified to use the new API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  3 +-
 lib/trace-cmd/trace-timesync.c |  5 ++-
 lib/tracefs/tracefs-instance.c | 28 +++++++++++----
 tracecmd/include/trace-local.h |  4 +--
 tracecmd/trace-record.c        | 66 +++++++++++++++-------------------
 tracecmd/trace-show.c          |  2 +-
 tracecmd/trace-stat.c          |  2 +-
 utest/tracefs-utest.c          | 18 +++-------
 8 files changed, 62 insertions(+), 66 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index e5bf3df4..d9ede08c 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -20,9 +20,8 @@ char *tracefs_find_tracing_dir(void);
 /* ftarce instances */
 struct tracefs_instance;
 
-struct tracefs_instance *tracefs_instance_alloc(const char *name);
 void tracefs_instance_free(struct tracefs_instance *instance);
-int tracefs_instance_create(struct tracefs_instance *instance);
+int tracefs_instance_create(const char *name, struct tracefs_instance **instance);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
 const char *tracefs_instance_get_name(struct tracefs_instance *instance);
 char *
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 35a41394..c6ec01ec 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -235,16 +235,15 @@ static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
 static struct tracefs_instance *
 clock_synch_create_instance(const char *clock, unsigned int cid)
 {
-	struct tracefs_instance *instance;
+	struct tracefs_instance *instance = NULL;
 	char inst_name[256];
 
 	snprintf(inst_name, 256, "clock_synch-%d", cid);
 
-	instance = tracefs_instance_alloc(inst_name);
+	tracefs_instance_create(inst_name, &instance);
 	if (!instance)
 		return NULL;
 
-	tracefs_instance_create(instance);
 	tracefs_instance_file_write(instance, "trace", "\0");
 	if (clock)
 		tracefs_instance_file_write(instance, "trace_clock", clock);
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index c19dd3b4..8817a95b 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -22,12 +22,12 @@ struct tracefs_instance {
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
 
@@ -45,7 +45,7 @@ struct tracefs_instance *tracefs_instance_alloc(const char *name)
 
 /**
  * tracefs_instance_free - Free an instance, previously allocated by
-			   tracefs_instance_alloc()
+			   tracefs_instance_create()
  * @instance: Pointer to the instance to be freed
  *
  */
@@ -59,24 +59,38 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 
 /**
  * tracefs_instance_create - Create a new ftrace instance
- * @instance: Pointer to the instance to be created
+ * @name: Name of the instance to be created
+ * @instance: Return, pointer to a newly allocated instance
  *
  * Returns 1 if the instance already exist, 0 if the instance
- * is created successful or -1 in case of an error
+ * is created successful or -1 in case of an error.
+ * If 1 or 0 is returned, @instance points to anewly allocated instance
+ * which must be freed by tracefs_instance_free()
  */
-int tracefs_instance_create(struct tracefs_instance *instance)
+int tracefs_instance_create(const char *name, struct tracefs_instance **instance)
 {
+	struct tracefs_instance *inst;
 	struct stat st;
 	char *path;
 	int ret;
 
-	path = tracefs_instance_get_dir(instance);
+	inst = instance_alloc(name);
+	if (!inst)
+		return -1;
+
+	path = tracefs_instance_get_dir(inst);
 	ret = stat(path, &st);
 	if (ret < 0)
 		ret = mkdir(path, 0777);
 	else
 		ret = 1;
 	tracefs_put_tracing_file(path);
+
+	if (ret < 0)
+		tracefs_instance_free(inst);
+	else
+		*instance = inst;
+
 	return ret;
 }
 
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
index 8cd44dd0..6aee00a3 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -351,27 +351,36 @@ static void test_set_event_pid(struct buffer_instance *instance)
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
+		if (tracefs_instance_create(name, &instance->tracefs) < 0)
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
@@ -418,7 +427,7 @@ static int __add_all_instances(const char *tracing_dir)
 		}
 		free(instance_path);
 
-		instance = create_instance(name);
+		instance = allocate_instance(name);
 		if (!instance)
 			die("Failed to create instance");
 		add_instance(instance, local_cpu_count);
@@ -5034,7 +5043,8 @@ static void make_instances(void)
 	for_each_instance(instance) {
 		if (is_guest(instance))
 			continue;
-		if (tracefs_instance_create(instance->tracefs) > 0) {
+		if (instance->name && !instance->tracefs &&
+		    tracefs_instance_create(instance->name, &instance->tracefs) > 0) {
 			/* Don't delete instances that already exist */
 			instance->flags |= BUFFER_FL_KEEP;
 		}
@@ -5057,25 +5067,6 @@ void tracecmd_remove_instances(void)
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
@@ -5533,7 +5524,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 void init_top_instance(void)
 {
 	if (!top_instance.tracefs)
-		top_instance.tracefs = tracefs_instance_alloc(NULL);
+		tracefs_instance_create(NULL, &top_instance.tracefs);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
 	top_instance.trace_id = tracecmd_generate_traceid();
@@ -5580,7 +5571,7 @@ void trace_stop(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'B':
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			add_instance(instance, local_cpu_count);
@@ -5620,7 +5611,7 @@ void trace_restart(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'B':
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			add_instance(instance, local_cpu_count);
@@ -5678,7 +5669,7 @@ void trace_reset(int argc, char **argv)
 		}
 		case 'B':
 			last_specified_all = 0;
-			instance = create_instance(optarg);
+			instance = allocate_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
 			add_instance(instance, local_cpu_count);
@@ -5821,6 +5812,7 @@ static inline void remove_instances(struct buffer_instance *instances)
 	while (instances) {
 		del = instances;
 		instances = instances->next;
+		free(del->name);
 		tracefs_instance_destroy(del->tracefs);
 		tracefs_instance_free(del->tracefs);
 		free(del);
@@ -5978,7 +5970,7 @@ static void parse_record_options(int argc,
 					die("Failed to allocate guest name");
 			}
 
-			ctx->instance = create_instance(name);
+			ctx->instance = allocate_instance(name);
 			ctx->instance->flags |= BUFFER_FL_GUEST;
 			ctx->instance->cid = cid;
 			ctx->instance->port = port;
@@ -6173,7 +6165,7 @@ static void parse_record_options(int argc,
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
index 292bcab0..e11a0066 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -198,17 +198,13 @@ static void test_instance_file(void)
 	CU_TEST(stat(inst_dir, &st) != 0);
 
 	CU_TEST(tracefs_instance_exists(name) == false);
-	instance = tracefs_instance_alloc(name);
-	CU_TEST(instance != NULL);
-	CU_TEST(stat(inst_dir, &st) != 0);
-	inst_name = tracefs_instance_get_name(instance);
-	CU_TEST(inst_name != NULL);
-	CU_TEST(strcmp(inst_name, name) == 0);
-
-	CU_TEST(tracefs_instance_create(instance) == 0);
+	CU_TEST(tracefs_instance_create(name, &instance) == 0);
 	CU_TEST(tracefs_instance_exists(name) == true);
 	CU_TEST(stat(inst_dir, &st) == 0);
 	CU_TEST(S_ISDIR(st.st_mode));
+	inst_name = tracefs_instance_get_name(instance);
+	CU_TEST(inst_name != NULL);
+	CU_TEST(strcmp(inst_name, name) == 0);
 
 	fname = tracefs_instance_get_dir(NULL);
 	CU_TEST(fname != NULL);
@@ -476,11 +472,7 @@ static int test_suite_init(void)
 	if (test_tep == NULL)
 		return 1;
 
-	test_instance = tracefs_instance_alloc(TEST_INSTANCE_NAME);
-	if (test_instance == NULL)
-		return 1;
-
-	if (tracefs_instance_create(test_instance) < 0)
+	if (tracefs_instance_create(TEST_INSTANCE_NAME, &test_instance) < 0)
 		return 1;
 
 	return 0;
-- 
2.28.0

