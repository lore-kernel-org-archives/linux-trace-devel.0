Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989B7C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5937F23772
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbhAOFFP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731570AbhAOFFO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:05:14 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9CEC061793
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:19 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id t16so11488189ejf.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H1IH3ZQcz64kG7pDGKbHg5uc5lFAK3+6W/LDm17hCYw=;
        b=L8fm2lMl+4rh9UmpHg8OTM5L0/k0U5kwdAgzJeDAJiiBVDjBK8TRvXDQ6shR2n/poy
         roJhX90hesYCj9ABZEfN4k2CZ7/w5CvEunVjiBTH+q2XtfEzi1+6n+ur0EVwwwM9n6kL
         0zCXryeCkjIIz+8eqBp7Meu+CYDhnp5MdL/YZ/1gQkHDXx0xrFz7Ow2OMr7PIv7qgRXV
         1Ov5uT2TsI57MM2Vd10D4mZKOeVbivXxPEXkRHhEI4WdYOvB7p+0XPaR/RsQfyV/HiV3
         0IiKd3o8IEq2qG5InKCfq8VC3d7sUuA5aZLVC8nB0luPH7oujx8C3PDt6zr5ou6PcgNh
         5FHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H1IH3ZQcz64kG7pDGKbHg5uc5lFAK3+6W/LDm17hCYw=;
        b=WgcjZud1GiAPfl3vr4RmbE4c9svNwzqkzpNXlRU1v8KJVOAat+ITTBYTi8hSwwZ2Zg
         WGJf54kLv8glZwDe8oelfdLLMXx8pGBxLR/pPKgpw67lINluQeuhgNTlb6uzNvuyEQRY
         KD/BpVRUvFxz9FlXV1X1YvPLGcDhraJhRnjHlnFWm+946HVKp5caBvo5kUEeQOpHI6YY
         UAALEO4jnJDPRLVFisQ9k9FBo6HJO+Ja/vuSDKJ6+0F0i1JHFQySn32bCaa0m/dQsp0e
         pfj/9QgLM/FUthvVtWzF0s1ip+rrtx5sqjHZ7YJ5v8fNuVAItTm2zOo2atEj2bgD0K15
         IWWw==
X-Gm-Message-State: AOAM5330jp/CryGyd8aaL7dcdscGSeh6nG4ZRcpKwGlpw5ssQdoLUsZO
        EjCWbUUxY9rjEKmSXaJTYJQ=
X-Google-Smtp-Source: ABdhPJx1JxUtUPPFQzOdtKHaexh5MU3J2Onj/2Fx7D0ATZArCOihfN7/8xX/49YLGkgGYifNqHRMRA==
X-Received: by 2002:a17:906:4e53:: with SMTP id g19mr7441274ejw.454.1610687058450;
        Thu, 14 Jan 2021 21:04:18 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d4sm3055670edq.36.2021.01.14.21.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:04:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] libtracefs: Unit tests for working with non default tracing dir
Date:   Fri, 15 Jan 2021 07:04:10 +0200
Message-Id: <20210115050410.1194011-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
References: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All unit tests are modified to work with custom defined trace directory,
instead of default system one. A new tests are added which duplicate
part of the system trace directory and test various library APIs on
that copy.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 349 +++++++++++++++++++++++++++++++-----------
 1 file changed, 261 insertions(+), 88 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1ade5dd..a45a19a 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <time.h>
 #include <dirent.h>
+#include <ftw.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -18,8 +19,15 @@
 
 #define TRACEFS_SUITE		"trasefs library"
 #define TEST_INSTANCE_NAME	"cunit_test_iter"
+#define TEST_TRACE_DIR		"/tmp/trace_utest.XXXXXX"
 #define TEST_ARRAY_SIZE		500
 
+#define ALL_TRACERS	"available_tracers"
+#define CUR_TRACER	"current_tracer"
+#define PER_CPU		"per_cpu"
+#define TRACE_ON	"tracing_on"
+#define TRACE_CLOCK	"trace_clock"
+
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
 struct test_sample {
@@ -55,7 +63,7 @@ static int test_callback(struct tep_event *event, struct tep_record *record,
 	return 0;
 }
 
-static void test_iter_write(void)
+static void test_iter_write(struct tracefs_instance *instance)
 {
 	int cpus = sysconf(_SC_NPROCESSORS_CONF);
 	cpu_set_t *cpuset, *cpusave;
@@ -70,7 +78,7 @@ static void test_iter_write(void)
 
 	sched_getaffinity(0, cpu_size, cpusave);
 
-	path = tracefs_instance_get_file(test_instance, "trace_marker");
+	path = tracefs_instance_get_file(instance, "trace_marker");
 	CU_TEST(path != NULL);
 	fd = open(path, O_WRONLY);
 	tracefs_put_tracing_file(path);
@@ -94,15 +102,15 @@ static void test_iter_write(void)
 }
 
 
-static void iter_raw_events_on_cpu(int cpu)
+static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu)
 {
 	int check = 0;
 	int ret;
 	int i;
 
 	test_found = 0;
-	test_iter_write();
-	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, 0,
+	test_iter_write(instance);
+	ret = tracefs_iterate_raw_events(test_tep, instance, NULL, 0,
 					 test_callback, &cpu);
 	CU_TEST(ret == 0);
 	if (cpu < 0) {
@@ -120,22 +128,27 @@ static void iter_raw_events_on_cpu(int cpu)
 	}
 }
 
-static void test_iter_raw_events(void)
+static void test_instance_iter_raw_events(struct tracefs_instance *instance)
 {
 	int cpus = sysconf(_SC_NPROCESSORS_CONF);
 	int ret;
 	int i;
 
-	ret = tracefs_iterate_raw_events(NULL, test_instance, NULL, 0, test_callback, NULL);
+	ret = tracefs_iterate_raw_events(NULL, instance, NULL, 0, test_callback, NULL);
 	CU_TEST(ret < 0);
 	ret = tracefs_iterate_raw_events(test_tep, NULL, NULL, 0, test_callback, NULL);
 	CU_TEST(ret == 0);
-	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, 0, NULL, NULL);
+	ret = tracefs_iterate_raw_events(test_tep, instance, NULL, 0, NULL, NULL);
 	CU_TEST(ret < 0);
 
-	iter_raw_events_on_cpu(-1);
+	iter_raw_events_on_cpu(instance, -1);
 	for (i = 0; i < cpus; i++)
-		iter_raw_events_on_cpu(i);
+		iter_raw_events_on_cpu(instance, i);
+}
+
+static void test_iter_raw_events(void)
+{
+	test_instance_iter_raw_events(test_instance);
 }
 
 #define RAND_STR_SIZE 20
@@ -215,10 +228,6 @@ static void test_instance_file_read(struct tracefs_instance *inst, const char *f
 	free(file);
 }
 
-#define ALL_TRACERS	"available_tracers"
-#define CUR_TRACER	"current_tracer"
-#define PER_CPU		"per_cpu"
-#define TRACE_ON	"tracing_on"
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -323,7 +332,7 @@ static void test_instance_file(void)
 	free(inst_dir);
 }
 
-static bool check_fd_name(int fd, char *name)
+static bool check_fd_name(int fd, const char *dir, const char *name)
 {
 	char link[PATH_MAX + 1];
 	char path[PATH_MAX + 1];
@@ -344,6 +353,10 @@ static bool check_fd_name(int fd, char *name)
 	if (ret > PATH_MAX || ret < 0)
 		return false;
 	path[ret] = 0;
+	ret = strncmp(dir, path, strlen(dir));
+	CU_TEST(ret == 0);
+	if (ret)
+		return false;
 	file = basename(path);
 	CU_TEST(file != NULL);
 	if (!file)
@@ -389,23 +402,26 @@ static bool check_fd_mode(int fd, int mode)
 	return true;
 }
 
-static void test_instance_file_fd(void)
+static void test_instance_file_fd(struct tracefs_instance *instance)
 {
 	const char *name = get_rand_str();
+	const char *tdir = tracefs_instance_get_trace_dir(instance);
 	long long res = -1;
 	char rd[2];
 	int fd;
 
-	fd = tracefs_instance_file_open(test_instance, name, -1);
+	CU_TEST(tdir != NULL);
+	fd = tracefs_instance_file_open(instance, name, -1);
 	CU_TEST(fd == -1);
-	fd = tracefs_instance_file_open(test_instance, TRACE_ON, O_RDONLY);
+	fd = tracefs_instance_file_open(instance, TRACE_ON, O_RDONLY);
 	CU_TEST(fd >= 0);
-	CU_TEST(check_fd_name(fd, TRACE_ON));
+
+	CU_TEST(check_fd_name(fd, tdir, TRACE_ON));
 	CU_TEST(check_fd_mode(fd, O_RDONLY));
 
-	CU_TEST(tracefs_instance_file_read_number(test_instance, "available_tracer", &res) != 0);
-	CU_TEST(tracefs_instance_file_read_number(test_instance, name, &res) != 0);
-	CU_TEST(tracefs_instance_file_read_number(test_instance, TRACE_ON, &res) == 0);
+	CU_TEST(tracefs_instance_file_read_number(instance, ALL_TRACERS, &res) != 0);
+	CU_TEST(tracefs_instance_file_read_number(instance, name, &res) != 0);
+	CU_TEST(tracefs_instance_file_read_number(instance, TRACE_ON, &res) == 0);
 	CU_TEST((res == 0 || res == 1));
 	CU_TEST(read(fd, &rd, 1) == 1);
 	rd[1] = 0;
@@ -414,45 +430,57 @@ static void test_instance_file_fd(void)
 	close(fd);
 }
 
-static void test_tracing_onoff(void)
+static void test_file_fd(void)
 {
+	test_instance_file_fd(test_instance);
+}
+
+static void test_instance_tracing_onoff(struct tracefs_instance *instance)
+{
+	const char *tdir = tracefs_instance_get_trace_dir(instance);
 	long long res = -1;
 	int fd;
 
-	fd = tracefs_trace_on_get_fd(test_instance);
+	CU_TEST(tdir != NULL);
+	fd = tracefs_trace_on_get_fd(instance);
 	CU_TEST(fd >= 0);
-	CU_TEST(check_fd_name(fd, TRACE_ON));
+	CU_TEST(check_fd_name(fd, tdir, TRACE_ON));
 	CU_TEST(check_fd_mode(fd, O_RDWR));
-	CU_TEST(tracefs_instance_file_read_number(test_instance, TRACE_ON, &res) == 0);
+	CU_TEST(tracefs_instance_file_read_number(instance, TRACE_ON, &res) == 0);
 	if (res == 1) {
-		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
-		CU_TEST(tracefs_trace_off(test_instance) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
-		CU_TEST(tracefs_trace_on(test_instance) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+		CU_TEST(tracefs_trace_is_on(instance) == 1);
+		CU_TEST(tracefs_trace_off(instance) == 0);
+		CU_TEST(tracefs_trace_is_on(instance) == 0);
+		CU_TEST(tracefs_trace_on(instance) == 0);
+		CU_TEST(tracefs_trace_is_on(instance) == 1);
 
 		CU_TEST(tracefs_trace_off_fd(fd) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_is_on(instance) == 0);
 		CU_TEST(tracefs_trace_on_fd(fd) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+		CU_TEST(tracefs_trace_is_on(instance) == 1);
 	} else {
-		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
-		CU_TEST(tracefs_trace_on(test_instance) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
-		CU_TEST(tracefs_trace_off(test_instance) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_is_on(instance) == 0);
+		CU_TEST(tracefs_trace_on(instance) == 0);
+		CU_TEST(tracefs_trace_is_on(instance) == 1);
+		CU_TEST(tracefs_trace_off(instance) == 0);
+		CU_TEST(tracefs_trace_is_on(instance) == 0);
 
 		CU_TEST(tracefs_trace_on_fd(fd) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 1);
+		CU_TEST(tracefs_trace_is_on(instance) == 1);
 		CU_TEST(tracefs_trace_off_fd(fd) == 0);
-		CU_TEST(tracefs_trace_is_on(test_instance) == 0);
+		CU_TEST(tracefs_trace_is_on(instance) == 0);
 	}
 
 	if (fd >= 0)
 		close(fd);
 }
 
-static bool check_option(long long id, bool exist, int enabled)
+static void test_tracing_onoff(void)
+{
+	test_instance_tracing_onoff(test_instance);
+}
+
+static bool check_option(struct tracefs_instance *instance, long long id, bool exist, int enabled)
 {
 	const char *name = tracefs_option_string(id);
 	char file[PATH_MAX];
@@ -466,12 +494,12 @@ static bool check_option(long long id, bool exist, int enabled)
 	int rstat;
 
 	CU_TEST(name != NULL);
-	supported = tracefs_option_is_supported(test_instance, id);
+	supported = tracefs_option_is_supported(instance, id);
 	CU_TEST(supported == exist);
 	if (supported != exist)
 		goto out;
 	snprintf(file, PATH_MAX, "options/%s", name);
-	path = tracefs_instance_get_file(test_instance, file);
+	path = tracefs_instance_get_file(instance, file);
 	CU_TEST(path != NULL);
 	rstat = stat(path, &st);
 	if (exist) {
@@ -499,7 +527,7 @@ static bool check_option(long long id, bool exist, int enabled)
 		int val = enabled ? '1' : '0';
 
 		r = read(fd, buf, 10);
-		CU_TEST(r == 2);
+		CU_TEST(r >= 1);
 		CU_TEST(buf[0] == val);
 		if (buf[0] != val)
 			goto out;
@@ -513,7 +541,7 @@ out:
 	return ret;
 }
 
-static void test_tracing_options(void)
+static void test_instance_tracing_options(struct tracefs_instance *instance)
 {
 	unsigned long long options_enabled = 0;
 	unsigned long long options_all = 0;
@@ -521,15 +549,15 @@ static void test_tracing_options(void)
 	char file[PATH_MAX];
 	const char *name;
 
-	options_all = tracefs_options_get_supported(test_instance);
-	options_enabled = tracefs_options_get_enabled(test_instance);
+	options_all = tracefs_options_get_supported(instance);
+	options_enabled = tracefs_options_get_enabled(instance);
 	CU_TEST(options_all > 0);
 
 	/* Invalid parameters test */
-	CU_TEST(!tracefs_option_is_supported(test_instance, TRACEFS_OPTION_INVALID << 1));
-	CU_TEST(!tracefs_option_is_enabled(test_instance, TRACEFS_OPTION_INVALID << 1));
-	CU_TEST(tracefs_options_set(test_instance, TRACEFS_OPTION_INVALID << 1) == -1);
-	CU_TEST(tracefs_options_clear(test_instance, TRACEFS_OPTION_INVALID << 1) == -1);
+	CU_TEST(!tracefs_option_is_supported(instance, TRACEFS_OPTION_INVALID << 1));
+	CU_TEST(!tracefs_option_is_enabled(instance, TRACEFS_OPTION_INVALID << 1));
+	CU_TEST(tracefs_options_set(instance, TRACEFS_OPTION_INVALID << 1) == -1);
+	CU_TEST(tracefs_options_clear(instance, TRACEFS_OPTION_INVALID << 1) == -1);
 	name = tracefs_option_string(TRACEFS_OPTION_INVALID << 1);
 	CU_TEST(!strcmp(name, "unknown"));
 
@@ -542,37 +570,41 @@ static void test_tracing_options(void)
 
 		if (options_all & i) {
 			options_all &= ~i;
-			CU_TEST(check_option(i, true, -1));
-			CU_TEST(tracefs_option_is_supported(test_instance, i));
+			CU_TEST(check_option(instance, i, true, -1));
+			CU_TEST(tracefs_option_is_supported(instance, i));
 		} else {
-			CU_TEST(check_option(i, false, -1));
-			CU_TEST(!tracefs_option_is_supported(test_instance, i));
+			CU_TEST(check_option(instance, i, false, -1));
+			CU_TEST(!tracefs_option_is_supported(instance, i));
 		}
 
 		if (options_enabled & i) {
 			options_enabled &= ~i;
-			CU_TEST(check_option(i, true, 1));
-			CU_TEST(tracefs_option_is_supported(test_instance, i));
-			CU_TEST(tracefs_option_is_enabled(test_instance, i));
-			CU_TEST(tracefs_options_clear(test_instance, i) == 0);
-			CU_TEST(check_option(i, true, 0));
-			CU_TEST(tracefs_options_set(test_instance, i) == 0);
-			CU_TEST(check_option(i, true, 1));
+			CU_TEST(check_option(instance, i, true, 1));
+			CU_TEST(tracefs_option_is_supported(instance, i));
+			CU_TEST(tracefs_option_is_enabled(instance, i));
+			CU_TEST(tracefs_options_clear(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 0));
+			CU_TEST(tracefs_options_set(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 1));
 		} else if (options_all & i) {
-			CU_TEST(check_option(i, true, 0));
-			CU_TEST(tracefs_option_is_supported(test_instance, i));
-			CU_TEST(!tracefs_option_is_enabled(test_instance, i));
-			CU_TEST(tracefs_options_set(test_instance, i) == 0);
-			CU_TEST(check_option(i, true, 1));
-			CU_TEST(tracefs_options_clear(test_instance, i) == 0);
-			CU_TEST(check_option(i, true, 0));
+			CU_TEST(check_option(instance, i, true, 0));
+			CU_TEST(tracefs_option_is_supported(instance, i));
+			CU_TEST(!tracefs_option_is_enabled(instance, i));
+			CU_TEST(tracefs_options_set(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 1));
+			CU_TEST(tracefs_options_clear(instance, i) == 0);
+			CU_TEST(check_option(instance, i, true, 0));
 		}
 		i <<= 1;
 	} while (i < TRACEFS_OPTION_INVALID);
 
 	CU_TEST(options_all == 0);
 	CU_TEST(options_enabled == 0);
+}
 
+static void test_tracing_options(void)
+{
+	test_instance_tracing_options(test_instance);
 }
 
 static void exclude_string(char **strings, char *name)
@@ -606,16 +638,13 @@ static void test_check_files(const char *fdir, char **files)
 		CU_TEST(files[i][0] == '/');
 }
 
-static void test_system_event(void)
+static void system_event(const char *tdir)
 {
-	const char *tdir;
+
 	char **systems;
 	char **events;
 	char *sdir = NULL;
 
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-
 	systems = tracefs_event_systems(tdir);
 	CU_TEST(systems != NULL);
 
@@ -638,7 +667,16 @@ static void test_system_event(void)
 	free(sdir);
 }
 
-static void test_tracers(void)
+static void test_system_event(void)
+{
+	const char *tdir;
+
+	tdir  = tracefs_tracing_dir();
+	CU_TEST(tdir != NULL);
+	system_event(tdir);
+}
+
+static void test_instance_tracers(struct tracefs_instance *instance)
 {
 	const char *tdir;
 	char **tracers;
@@ -646,7 +684,7 @@ static void test_tracers(void)
 	char *tracer;
 	int i;
 
-	tdir  = tracefs_tracing_dir();
+	tdir  = tracefs_instance_get_trace_dir(instance);
 	CU_TEST(tdir != NULL);
 
 	tracers = tracefs_tracers(tdir);
@@ -667,6 +705,11 @@ static void test_tracers(void)
 	free(tfile);
 }
 
+static void test_tracers(void)
+{
+	test_instance_tracers(test_instance);
+}
+
 static void test_check_events(struct tep_handle *tep, char *system, bool exist)
 {
 	struct dirent *dent;
@@ -706,17 +749,13 @@ static void test_check_events(struct tep_handle *tep, char *system, bool exist)
 
 }
 
-static void test_local_events(void)
+static void local_events(const char *tdir)
 {
 	struct tep_handle *tep;
-	const char *tdir;
 	char **systems;
 	char *lsystems[3];
 	int i;
 
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-
 	tep = tracefs_local_events(tdir);
 	CU_TEST(tep != NULL);
 
@@ -757,6 +796,15 @@ static void test_local_events(void)
 	tracefs_list_free(systems);
 }
 
+static void test_local_events(void)
+{
+	const char *tdir;
+
+	tdir  = tracefs_tracing_dir();
+	CU_TEST(tdir != NULL);
+	local_events(tdir);
+}
+
 struct test_walk_instance {
 	struct tracefs_instance *instance;
 	bool found;
@@ -806,13 +854,13 @@ static void test_instances_walk(void)
 	}
 }
 
-static void current_clock_check(const char *clock)
+static void current_clock_check(struct tracefs_instance *instance, const char *clock)
 {
 	int size = 0;
 	char *clocks;
 	char *str;
 
-	clocks = tracefs_instance_file_read(test_instance, "trace_clock", &size);
+	clocks = tracefs_instance_file_read(instance, TRACE_CLOCK, &size);
 	CU_TEST(clocks != NULL);
 	CU_TEST(size > strlen(clock));
 	str = strstr(clocks, clock);
@@ -823,16 +871,140 @@ static void current_clock_check(const char *clock)
 	free(clocks);
 }
 
-static void test_get_clock(void)
+static void test_instance_get_clock(struct tracefs_instance *instance)
 {
 	const char *clock;
 
-	clock = tracefs_get_clock(test_instance);
+	clock = tracefs_get_clock(instance);
 	CU_TEST(clock != NULL);
-	current_clock_check(clock);
+	current_clock_check(instance, clock);
 	free((char *)clock);
 }
 
+static void test_get_clock(void)
+{
+	test_instance_get_clock(test_instance);
+}
+
+static void copy_trace_file(const char *from, char *to)
+{
+	int fd_from = -1;
+	int fd_to = -1;
+	char buf[512];
+	int ret;
+
+	fd_from = open(from, O_RDONLY);
+	if (fd_from < 0)
+		goto out;
+	fd_to = open(to, O_WRONLY | O_TRUNC | O_CREAT);
+	if (fd_to < 0)
+		goto out;
+
+	while ((ret = read(fd_from, buf, 512)) > 0) {
+		if (write(fd_to, buf, ret) == -1)
+			break;
+	}
+
+out:
+	if (fd_to >= 0)
+		close(fd_to);
+	if (fd_from >= 0)
+		close(fd_from);
+}
+
+static int trace_dir_base;
+static char *trace_tmp_dir;
+static int copy_trace_walk(const char *fpath, const struct stat *sb,
+			   int typeflag, struct FTW *ftwbuf)
+{
+	char path[PATH_MAX];
+
+	sprintf(path, "%s%s", trace_tmp_dir, fpath + trace_dir_base);
+
+	switch (typeflag) {
+	case FTW_D:
+		mkdir(path, 0750);
+		break;
+	case FTW_F:
+		copy_trace_file(fpath, path);
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static void dup_trace_dir(char *to, char *dir)
+{
+	const char *trace_dir = tracefs_tracing_dir();
+	char file_from[PATH_MAX];
+	char file_to[PATH_MAX];
+
+	sprintf(file_from, "%s/%s", trace_dir, dir);
+	sprintf(file_to, "%s/%s", to, dir);
+	trace_tmp_dir = file_to;
+	trace_dir_base = strlen(file_from);
+	nftw(file_from, copy_trace_walk, 20, 0);
+}
+
+static void dup_trace_file(char *to, char *file)
+{
+	const char *trace_dir = tracefs_tracing_dir();
+	char file_from[PATH_MAX];
+	char file_to[PATH_MAX];
+
+	sprintf(file_from, "%s/%s", trace_dir, file);
+	sprintf(file_to, "%s/%s", to, file);
+	copy_trace_file(file_from, file_to);
+}
+
+static char *copy_trace_dir(void)
+{
+	char template[] = TEST_TRACE_DIR;
+	char *dname = mkdtemp(template);
+
+	dup_trace_dir(dname, "events");
+	dup_trace_dir(dname, "options");
+	dup_trace_file(dname, TRACE_ON);
+	dup_trace_file(dname, CUR_TRACER);
+	dup_trace_file(dname, TRACE_CLOCK);
+	dup_trace_file(dname, ALL_TRACERS);
+
+	return strdup(dname);
+}
+
+static int del_trace_walk(const char *fpath, const struct stat *sb,
+			  int typeflag, struct FTW *ftwbuf)
+{
+	remove(fpath);
+	return 0;
+}
+
+void del_trace_dir(char *dir)
+{
+	nftw(dir, del_trace_walk, 20, FTW_DEPTH);
+}
+
+static void test_custom_trace_dir(void)
+{
+	struct tracefs_instance *instance;
+	char *dname = copy_trace_dir();
+
+	instance = tracefs_instance_get(dname, NULL);
+	CU_TEST(instance != NULL);
+
+	system_event(dname);
+	local_events(dname);
+	test_instance_tracing_options(instance);
+	test_instance_get_clock(instance);
+	test_instance_file_fd(instance);
+	test_instance_tracers(instance);
+
+	tracefs_instance_free(instance);
+	del_trace_dir(dname);
+	free(dname);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -867,7 +1039,7 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "tracing file / directory APIs",
 		    test_trace_file);
 	CU_add_test(suite, "instance file / directory APIs",
-		    test_instance_file_fd);
+		    test_file_fd);
 	CU_add_test(suite, "instance file descriptor",
 		    test_instance_file);
 	CU_add_test(suite, "systems and events APIs",
@@ -886,5 +1058,6 @@ void test_tracefs_lib(void)
 		    test_tracing_onoff);
 	CU_add_test(suite, "tracing options",
 		    test_tracing_options);
-
+	CU_add_test(suite, "custom system directory",
+		    test_custom_trace_dir);
 }
-- 
2.29.2

