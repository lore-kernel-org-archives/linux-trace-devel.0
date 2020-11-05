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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC52FC4741F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 498EC2151B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QjxIUmqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbgKEJeD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbgKEJeD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:03 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256A3C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 01:34:03 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ay21so814336edb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 01:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BWa4JDcxLzU18hSMI6GSG1LI0nr6mn2GZutBAz9fWd0=;
        b=QjxIUmqY4C4mrxqGgoj9SzQpEblTu8wO3+1piBr+IdsjnSvjy5LtcNn8W4hECBW8zY
         RWbRt9LD2hj3KgspBJV55pkPGRo/SGr18lcjPHSsBmuykPnbCYSNsKoxbv35JtBq4dV+
         qWkqtnQZsnubagFh5uGNE/T7PUndSEaW5Z+gjBAhvRYKjBxgjxR54XJHx2naeVy9TzHV
         wuGJtNGiCaesLD3+YqzGtTadRluMwtIbl02AMMe4oyYkyzX/vyjA2pyyARpf7bx3ZRlp
         gVJhYdEnNqCXRdC+9oKxa2Ca5M+dXlIa6rm5/0fLV2NbhHr50bNrdPQXpfFd4OkcumiN
         AEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BWa4JDcxLzU18hSMI6GSG1LI0nr6mn2GZutBAz9fWd0=;
        b=SNOkSa/vkqL1osCjaClhY9U1jFuNEibuwAQKHUvp2I2l3MtGJimszY2IQ5E0jjTNat
         LrAWs5mOgiZp0a7mRQ8tZ1O7iRsOFmhrOPC3xbVAMNNn8iKW0ayh9nlUcd16iUNx1Dmz
         3+MFj2C1bYbxVZQhpxYK6lcp9SMBvbFhxJktvlYXNVFin8pm6sr4M21ZkuvKTuwUPlJd
         oHUnwtAWdrjkdURz9+4s9tQWLkBXe4gKCJQBTEXW8Zicq1teaz8cBEXAYkZnlc3pnkHt
         5+UIVlO23HTaHdcxCdjm6e3FCbEVYFwINDERJ35irpUrUzCM7qoo/BgygeDcI5AAu70c
         qjpw==
X-Gm-Message-State: AOAM532KtWn3L9rUEgpLvwfBk/HSlSfMCLxQbCudTasO5bdu9VkTDRZ+
        iWmH27qE/Y9VE3UsDOA5YBkJHVxg9dMBcQS9
X-Google-Smtp-Source: ABdhPJz6LjprahkdDNVX/5SVA/cIlMVvS8rzwcKXdTQGijksKq+VLBID09Pow9xZ8C1GJCWlQaPxWg==
X-Received: by 2002:aa7:d1d8:: with SMTP id g24mr1649061edp.324.1604568841705;
        Thu, 05 Nov 2020 01:34:01 -0800 (PST)
Received: from localhost.localdomain ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 1sm586725ejt.107.2020.11.05.01.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:34:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/6] libtracefs: Change APIs to work with constant strings
Date:   Thu,  5 Nov 2020 11:33:50 +0200
Message-Id: <20201105093354.532742-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105093354.532742-1-tz.stoyanov@gmail.com>
References: <20201105093354.532742-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some tracefs library APIs retrieve trace instance parameters as srings.
As these strings are not meant to be changed by the API callers, set
them to be constant. These APIs are affected:
 tracefs_instance_get_name()
 tracefs_event_systems()
 tracefs_system_events()
 tracefs_tracers()
 tracefs_list_free()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      | 10 ++++----
 lib/tracefs/tracefs-events.c   | 47 ++++++++++++++--------------------
 lib/tracefs/tracefs-instance.c |  4 +--
 tracecmd/trace-record.c        |  2 +-
 utest/tracefs-utest.c          | 23 +++++++++--------
 5 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 8ee7ba6e..8d193853 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -24,7 +24,7 @@ struct tracefs_instance *tracefs_instance_alloc(const char *name);
 void tracefs_instance_free(struct tracefs_instance *instance);
 int tracefs_instance_create(struct tracefs_instance *instance);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
-char *tracefs_instance_get_name(struct tracefs_instance *instance);
+const char *tracefs_instance_get_name(struct tracefs_instance *instance);
 char *
 tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
@@ -37,9 +37,9 @@ bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
 
 /* events */
-void tracefs_list_free(char **list);
-char **tracefs_event_systems(const char *tracing_dir);
-char **tracefs_system_events(const char *tracing_dir, const char *system);
+void tracefs_list_free(const char **list);
+const char **tracefs_event_systems(const char *tracing_dir);
+const char **tracefs_system_events(const char *tracing_dir, const char *system);
 int tracefs_iterate_raw_events(struct tep_handle *tep,
 				struct tracefs_instance *instance,
 				int (*callback)(struct tep_event *,
@@ -47,7 +47,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 						int, void *),
 				void *callback_context);
 
-char **tracefs_tracers(const char *tracing_dir);
+const char **tracefs_tracers(const char *tracing_dir);
 
 struct tep_handle *tracefs_local_events(const char *tracing_dir);
 struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index 8e825f50..19f98058 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -227,7 +227,7 @@ static char *append_file(const char *dir, const char *name)
  *
  *@list pointer to a list of strings, the last one must be NULL
  */
-void tracefs_list_free(char **list)
+void tracefs_list_free(const char **list)
 {
 	int i;
 
@@ -235,7 +235,7 @@ void tracefs_list_free(char **list)
 		return;
 
 	for (i = 0; list[i]; i++)
-		free(list[i]);
+		free((char *)list[i]);
 
 	free(list);
 }
@@ -245,11 +245,11 @@ void tracefs_list_free(char **list)
  * @tracing_dir: directory holding the "events" directory
  *		 if NULL, top tracing directory is used
  *
- * Returns an allocated list of system names. Both the names and
- * the list must be freed with tracefs_list_free()
- * The list returned ends with a "NULL" pointer
+ *
+ * Returns an allocated list of system names, the last element
+ * is a NULL pointer. The list must be freed with tracefs_list_free()*
  */
-char **tracefs_event_systems(const char *tracing_dir)
+const char **tracefs_event_systems(const char *tracing_dir)
 {
 	struct dirent *dent;
 	char **systems = NULL;
@@ -311,7 +311,7 @@ char **tracefs_event_systems(const char *tracing_dir)
 
  out_free:
 	free(events_dir);
-	return systems;
+	return (const char **)systems;
 }
 
 /**
@@ -319,11 +319,10 @@ char **tracefs_event_systems(const char *tracing_dir)
  * @tracing_dir: directory holding the "events" directory
  * @system: the system to return the events for
  *
- * Returns an allocated list of event names. Both the names and
- * the list must be freed with tracefs_list_free()
- * The list returned ends with a "NULL" pointer
+ * Returns an allocated list of event names, the last element
+ * is a NULL pointer. The list must be freed with tracefs_list_free()
  */
-char **tracefs_system_events(const char *tracing_dir, const char *system)
+const char **tracefs_system_events(const char *tracing_dir, const char *system)
 {
 	struct dirent *dent;
 	char **events = NULL;
@@ -376,17 +375,17 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
  out_free:
 	free(system_dir);
 
-	return events;
+	return (const char **)events;
 }
 
 /**
  * tracefs_tracers - returns an array of available tracers
  * @tracing_dir: The directory that contains the tracing directory
  *
- * Returns an allocate list of plugins. The array ends with NULL
- * Both the plugin names and array must be freed with free()
+ * Returns an allocated list of trace plugin names, the last element
+ * is a NULL pointer. The list must be freed with tracefs_list_free()*
  */
-char **tracefs_tracers(const char *tracing_dir)
+const char **tracefs_tracers(const char *tracing_dir)
 {
 	char *available_tracers;
 	struct stat st;
@@ -438,14 +437,14 @@ char **tracefs_tracers(const char *tracing_dir)
  out_free:
 	free(available_tracers);
 
-	return plugins;
+	return (const char **)plugins;
 }
 
 static int load_events(struct tep_handle *tep,
 		       const char *tracing_dir, const char *system)
 {
+	const char **events = NULL;
 	int ret = 0, failure = 0;
-	char **events = NULL;
 	struct stat st;
 	int len = 0;
 	int i;
@@ -481,11 +480,7 @@ next_event:
 			failure = ret;
 	}
 
-	if (events) {
-		for (i = 0; events[i]; i++)
-			free(events[i]);
-		free(events);
-	}
+	tracefs_list_free(events);
 	return failure;
 }
 
@@ -532,7 +527,7 @@ static int fill_local_events_system(const char *tracing_dir,
 				    const char * const *sys_names,
 				    int *parsing_failures)
 {
-	char **systems = NULL;
+	const char **systems = NULL;
 	int ret;
 	int i;
 
@@ -564,11 +559,7 @@ static int fill_local_events_system(const char *tracing_dir,
 	/* always succeed because parsing failures are not critical */
 	ret = 0;
 out:
-	if (systems) {
-		for (i = 0; systems[i]; i++)
-			free(systems[i]);
-		free(systems);
-	}
+	tracefs_list_free(systems);
 	return ret;
 }
 
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 50e88534..e9ec3401 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -169,7 +169,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
  * Returns the name of the given @instance.
  * The returned string must *not* be freed.
  */
-char *tracefs_instance_get_name(struct tracefs_instance *instance)
+const char *tracefs_instance_get_name(struct tracefs_instance *instance)
 {
 	if (instance)
 		return instance->name;
@@ -252,8 +252,8 @@ static bool check_file_exists(struct tracefs_instance *instance,
 			     char *name, bool dir)
 {
 	char file[PATH_MAX];
-	struct stat st;
 	char *path;
+	struct stat st;
 	int ret;
 
 	path = tracefs_instance_get_dir(instance);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 72a5c8c9..8cd44dd0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3861,7 +3861,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
-	char *name;
+	const char *name;
 
 	name = tracefs_instance_get_name(instance->tracefs);
 	if (!no_fifos) {
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1c146576..31a700ff 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -180,7 +180,7 @@ static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
 	const char *name = get_rand_str();
-	char *inst_name = NULL;
+	const char *inst_name = NULL;
 	const char *tdir;
 	char *inst_file;
 	char *inst_dir;
@@ -308,9 +308,9 @@ static void test_check_files(const char *fdir, char **files)
 
 static void test_system_event(void)
 {
+	const char **systems;
+	const char **events;
 	const char *tdir;
-	char **systems;
-	char **events;
 	char *sdir = NULL;
 
 	tdir  = tracefs_get_tracing_dir();
@@ -324,13 +324,13 @@ static void test_system_event(void)
 
 	asprintf(&sdir, "%s/events/%s", tdir, systems[0]);
 	CU_TEST(sdir != NULL);
-	test_check_files(sdir, events);
+	test_check_files(sdir, (char **)events);
 	free(sdir);
 	sdir = NULL;
 
 	asprintf(&sdir, "%s/events", tdir);
 	CU_TEST(sdir != NULL);
-	test_check_files(sdir, systems);
+	test_check_files(sdir, (char **)systems);
 
 	tracefs_list_free(systems);
 	tracefs_list_free(events);
@@ -340,8 +340,8 @@ static void test_system_event(void)
 
 static void test_tracers(void)
 {
+	const char **tracers;
 	const char *tdir;
-	char **tracers;
 	char *tfile;
 	char *tracer;
 	int i;
@@ -356,7 +356,7 @@ static void test_tracers(void)
 
 	tracer = strtok(tfile, " ");
 	while (tracer) {
-		exclude_string(tracers, tracer);
+		exclude_string((char **)tracers, tracer);
 		tracer = strtok(NULL, " ");
 	}
 
@@ -367,7 +367,8 @@ static void test_tracers(void)
 	free(tfile);
 }
 
-static void test_check_events(struct tep_handle *tep, char *system, bool exist)
+static void test_check_events(struct tep_handle *tep,
+			      const char *system, bool exist)
 {
 	struct dirent *dent;
 	char file[PATH_MAX];
@@ -409,8 +410,8 @@ static void test_check_events(struct tep_handle *tep, char *system, bool exist)
 static void test_local_events(void)
 {
 	struct tep_handle *tep;
+	const char **systems;
 	const char *tdir;
-	char **systems;
 	char *lsystems[3];
 	int i;
 
@@ -430,9 +431,9 @@ static void test_local_events(void)
 	memset(lsystems, 0, sizeof(lsystems));
 	for (i = 0; systems[i]; i++) {
 		if (!lsystems[0])
-			lsystems[0] = systems[i];
+			lsystems[0] = (char *)systems[i];
 		else if (!lsystems[2])
-			lsystems[2] = systems[i];
+			lsystems[2] = (char *)systems[i];
 		else
 			break;
 	}
-- 
2.28.0

