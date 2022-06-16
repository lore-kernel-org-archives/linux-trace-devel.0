Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45979CCA47A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jun 2022 15:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiFPPaO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377893AbiFPPaO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 11:30:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1A140A1D
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 08:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22ED8B82462
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 15:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629C7C3411C;
        Thu, 16 Jun 2022 15:30:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1rRf-002j53-81;
        Thu, 16 Jun 2022 11:30:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] trace-cmd utests: Remove libtracefs tests
Date:   Thu, 16 Jun 2022 11:29:58 -0400
Message-Id: <20220616153001.649858-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220616153001.649858-1-rostedt@goodmis.org>
References: <20220616153001.649858-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The unit tests in trace-cmd are all for libtracefs, and those tests are in
the libtracefs repo. There's no reason to keep them here. Instead remove
them all and start a template to add trace-cmd specific tests.

The initialization phase is just finding the in tree trace-cmd code.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile              |   2 +-
 utest/trace-utest.c   |  16 +-
 utest/trace-utest.h   |   4 +-
 utest/tracefs-utest.c | 613 ++----------------------------------------
 4 files changed, 41 insertions(+), 594 deletions(-)

diff --git a/Makefile b/Makefile
index 2f064c8d25f5..031d808517b6 100644
--- a/Makefile
+++ b/Makefile
@@ -442,7 +442,7 @@ gui: force
 	@echo "  Please use its new home at https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/"
 	@echo "***************************"
 
-test: force $(LIBTRACECMD_STATIC)
+test: force trace-cmd
 ifneq ($(CUNIT_INSTALLED),1)
 	$(error CUnit framework not installed, cannot build unit tests))
 endif
diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 58d4d4e461f8..802765a77673 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -13,9 +13,11 @@
 
 #include "trace-utest.h"
 
+const char *argv0;
+
 enum unit_tests {
 	RUN_NONE	= 0,
-	RUN_TRACEFS	= (1 << 0),
+	RUN_TRACECMD	= (1 << 0),
 	RUN_ALL		= 0xFFFF
 };
 
@@ -24,7 +26,7 @@ static void print_help(char **argv)
 	printf("Usage: %s [OPTIONS]\n", basename(argv[0]));
 	printf("\t-s, --silent\tPrint test summary\n");
 	printf("\t-r, --run test\tRun specific test:\n");
-	printf("\t\t  tracefs   run libtracefs tests\n");
+	printf("\t\t  trace-cmd   run trace-cmd tests\n");
 	printf("\t-h, --help\tPrint usage information\n");
 	exit(0);
 }
@@ -34,6 +36,8 @@ int main(int argc, char **argv)
 	CU_BasicRunMode verbose = CU_BRM_VERBOSE;
 	enum unit_tests tests = RUN_NONE;
 
+	argv0 = argv[0];
+
 	for (;;) {
 		int c;
 		int index = 0;
@@ -50,8 +54,8 @@ int main(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'r':
-			if (strcmp(optarg, "tracefs") == 0)
-				tests |= RUN_TRACEFS;
+			if (strcmp(optarg, "trace-cmd") == 0)
+				tests |= RUN_TRACECMD;
 			else
 				print_help(argv);
 			break;
@@ -73,8 +77,8 @@ int main(int argc, char **argv)
 		return -1;
 	}
 
-	if (tests & RUN_TRACEFS)
-		test_tracefs_lib();
+	if (tests & RUN_TRACECMD)
+		test_tracecmd_lib();
 
 	CU_basic_set_mode(verbose);
 	CU_basic_run_tests();
diff --git a/utest/trace-utest.h b/utest/trace-utest.h
index 917c0e786a70..a9e365f8dcb5 100644
--- a/utest/trace-utest.h
+++ b/utest/trace-utest.h
@@ -6,6 +6,8 @@
 #ifndef _TRACE_UTEST_H_
 #define _TRACE_UTEST_H_
 
-void test_tracefs_lib(void);
+extern const char *argv0;
+
+void test_tracecmd_lib(void);
 
 #endif /* _TRACE_UTEST_H_ */
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 9c9eee0632cc..d85d9a21d20b 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -14,617 +14,58 @@
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 
-#include "tracefs.h"
+#include "trace-utest.h"
 
-#define TRACEFS_SUITE		"trasefs library"
-#define TEST_INSTANCE_NAME	"cunit_test_iter"
-#define TEST_ARRAY_SIZE		500
+static char tracecmd_exec[PATH_MAX];
 
-static struct tracefs_instance *test_instance;
-static struct tep_handle *test_tep;
-struct test_sample {
-	int cpu;
-	int value;
-};
-static struct test_sample test_array[TEST_ARRAY_SIZE];
-static int test_found;
+#define TRACECMD_SUITE		"trace-cmd"
 
-static int test_callback(struct tep_event *event, struct tep_record *record,
-			  int cpu, void *context)
+static void test_trace_record_report(void)
 {
-	struct tep_format_field *field;
-	struct test_sample *sample;
-	int *cpu_test = (int *)context;
-	int i;
-
-	if (cpu_test && *cpu_test >= 0 && *cpu_test != cpu)
-		return 0;
-	field = tep_find_field(event, "buf");
-	if (field) {
-		sample = ((struct test_sample *)(record->data + field->offset));
-		for (i = 0; i < TEST_ARRAY_SIZE; i++) {
-			if (test_array[i].value == sample->value &&
-			    test_array[i].cpu == cpu) {
-				test_array[i].value = 0;
-				test_found++;
-				break;
-			}
-		}
-	}
-
-	return 0;
 }
 
-static void test_iter_write(void)
-{
-	int cpus = sysconf(_SC_NPROCESSORS_CONF);
-	cpu_set_t *cpuset, *cpusave;
-	int cpu_size;
-	char *path;
-	int i, fd;
-	int ret;
-	cpuset = CPU_ALLOC(cpus);
-	cpusave = CPU_ALLOC(cpus);
-	cpu_size = CPU_ALLOC_SIZE(cpus);
-	CPU_ZERO_S(cpu_size, cpuset);
-
-	sched_getaffinity(0, cpu_size, cpusave);
-
-	path = tracefs_instance_get_file(test_instance, "trace_marker");
-	CU_TEST(path != NULL);
-	fd = open(path, O_WRONLY);
-	tracefs_put_tracing_file(path);
-	CU_TEST(fd >= 0);
-
-	for (i = 0; i < TEST_ARRAY_SIZE; i++) {
-		test_array[i].cpu = rand() % cpus;
-		test_array[i].value = random();
-		if (!test_array[i].value)
-			test_array[i].value++;
-		CU_TEST(test_array[i].cpu < cpus);
-		CPU_ZERO_S(cpu_size, cpuset);
-		CPU_SET(test_array[i].cpu, cpuset);
-		sched_setaffinity(0, cpu_size, cpuset);
-		ret = write(fd, test_array + i, sizeof(struct test_sample));
-		CU_TEST(ret == sizeof(struct test_sample));
-	}
-
-	sched_setaffinity(0, cpu_size, cpusave);
-	close(fd);
-}
-
-
-static void iter_raw_events_on_cpu(int cpu)
-{
-	int check = 0;
-	int ret;
-	int i;
-
-	test_found = 0;
-	test_iter_write();
-	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, 0,
-					 test_callback, &cpu);
-	CU_TEST(ret == 0);
-	if (cpu < 0) {
-		CU_TEST(test_found == TEST_ARRAY_SIZE);
-	} else {
-		for (i = 0; i < TEST_ARRAY_SIZE; i++) {
-			if (test_array[i].cpu == cpu) {
-				check++;
-				CU_TEST(test_array[i].value == 0)
-			} else {
-				CU_TEST(test_array[i].value != 0)
-			}
-		}
-		CU_TEST(test_found == check);
-	}
-}
-
-static void test_iter_raw_events(void)
-{
-	int cpus = sysconf(_SC_NPROCESSORS_CONF);
-	int ret;
-	int i;
-
-	ret = tracefs_iterate_raw_events(NULL, test_instance, NULL, 0, test_callback, NULL);
-	CU_TEST(ret < 0);
-	ret = tracefs_iterate_raw_events(test_tep, NULL, NULL, 0, test_callback, NULL);
-	CU_TEST(ret == 0);
-	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, 0, NULL, NULL);
-	CU_TEST(ret < 0);
-
-	iter_raw_events_on_cpu(-1);
-	for (i = 0; i < cpus; i++)
-		iter_raw_events_on_cpu(i);
-}
-
-#define RAND_STR_SIZE 20
-#define RAND_ASCII "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
-static const char *get_rand_str()
-{
-	static char str[RAND_STR_SIZE];
-	static char sym[] = RAND_ASCII;
-	struct timespec clk;
-	int i;
-
-	clock_gettime(CLOCK_REALTIME, &clk);
-	srand(clk.tv_nsec);
-	for (i = 0; i < RAND_STR_SIZE; i++)
-		str[i] = sym[rand() % (sizeof(sym) - 1)];
-
-	str[RAND_STR_SIZE - 1] = 0;
-	return str;
-}
-
-static void test_trace_file(void)
-{
-	const char *tmp = get_rand_str();
-	const char *tdir;
-	struct stat st;
-	char *file;
-
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-	CU_TEST(stat(tdir, &st) == 0);
-	CU_TEST(S_ISDIR(st.st_mode));
-
-	file = tracefs_get_tracing_file(NULL);
-	CU_TEST(file == NULL);
-	file = tracefs_get_tracing_file(tmp);
-	CU_TEST(file != NULL);
-	CU_TEST(stat(file, &st) != 0);
-	tracefs_put_tracing_file(file);
-
-	file = tracefs_get_tracing_file("trace");
-	CU_TEST(file != NULL);
-	CU_TEST(stat(file, &st) == 0);
-	tracefs_put_tracing_file(file);
-}
-
-static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
-{
-	const char *tdir  = tracefs_tracing_dir();
-	char buf[BUFSIZ];
-	char *fpath;
-	char *file;
-	size_t fsize = 0;
-	int size = 0;
-	int fd;
-
-	if (inst) {
-		CU_TEST(asprintf(&fpath, "%s/instances/%s/%s",
-			tdir, tracefs_instance_get_name(inst), fname) > 0);
-	} else {
-		CU_TEST(asprintf(&fpath, "%s/%s", tdir, fname) > 0);
-	}
-
-	memset(buf, 0, BUFSIZ);
-	fd = open(fpath, O_RDONLY);
-	CU_TEST(fd >= 0);
-	fsize = read(fd, buf, BUFSIZ);
-	CU_TEST(fsize >= 0);
-	close(fd);
-	buf[BUFSIZ - 1] = 0;
-
-	file = tracefs_instance_file_read(inst, fname, &size);
-	CU_TEST(file != NULL);
-	CU_TEST(size == fsize);
-	CU_TEST(strcmp(file, buf) == 0);
-
-	free(fpath);
-	free(file);
-}
-
-#define ALL_TRACERS	"available_tracers"
-#define CUR_TRACER	"current_tracer"
-#define PER_CPU		"per_cpu"
-static void test_instance_file(void)
-{
-	struct tracefs_instance *instance = NULL;
-	struct tracefs_instance *second = NULL;
-	const char *name = get_rand_str();
-	const char *inst_name = NULL;
-	const char *tdir;
-	char *inst_file;
-	char *inst_dir;
-	struct stat st;
-	char *fname;
-	char *file1;
-	char *file2;
-	char *tracer;
-	int size;
-	int ret;
-
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-	CU_TEST(asprintf(&inst_dir, "%s/instances/%s", tdir, name) > 0);
-	CU_TEST(stat(inst_dir, &st) != 0);
-
-	CU_TEST(tracefs_instance_exists(name) == false);
-	instance = tracefs_instance_create(name);
-	CU_TEST(instance != NULL);
-	CU_TEST(tracefs_instance_is_new(instance));
-	second = tracefs_instance_create(name);
-	CU_TEST(second != NULL);
-	CU_TEST(!tracefs_instance_is_new(second));
-	tracefs_instance_free(second);
-	CU_TEST(tracefs_instance_exists(name) == true);
-	CU_TEST(stat(inst_dir, &st) == 0);
-	CU_TEST(S_ISDIR(st.st_mode));
-	inst_name = tracefs_instance_get_name(instance);
-	CU_TEST(inst_name != NULL);
-	CU_TEST(strcmp(inst_name, name) == 0);
-
-	fname = tracefs_instance_get_dir(NULL);
-	CU_TEST(fname != NULL);
-	CU_TEST(strcmp(fname, tdir) == 0);
-	free(fname);
-
-	fname = tracefs_instance_get_dir(instance);
-	CU_TEST(fname != NULL);
-	CU_TEST(strcmp(fname, inst_dir) == 0);
-	free(fname);
-
-	CU_TEST(asprintf(&fname, "%s/"ALL_TRACERS, tdir) > 0);
-	CU_TEST(fname != NULL);
-	inst_file = tracefs_instance_get_file(NULL, ALL_TRACERS);
-	CU_TEST(inst_file != NULL);
-	CU_TEST(strcmp(fname, inst_file) == 0);
-	tracefs_put_tracing_file(inst_file);
-	free(fname);
-
-	CU_TEST(asprintf(&fname, "%s/instances/%s/"ALL_TRACERS, tdir, name) > 0);
-	CU_TEST(fname != NULL);
-	CU_TEST(stat(fname, &st) == 0);
-	inst_file = tracefs_instance_get_file(instance, ALL_TRACERS);
-	CU_TEST(inst_file != NULL);
-	CU_TEST(strcmp(fname, inst_file) == 0);
-
-	test_instance_file_read(NULL, ALL_TRACERS);
-	test_instance_file_read(instance, ALL_TRACERS);
-
-	file1 = tracefs_instance_file_read(instance, ALL_TRACERS, NULL);
-	CU_TEST(file1 != NULL);
-	tracer = strtok(file1, " ");
-	CU_TEST(tracer != NULL);
-	ret = tracefs_instance_file_write(instance, CUR_TRACER, tracer);
-	CU_TEST(ret == strlen(tracer));
-	file2 = tracefs_instance_file_read(instance, CUR_TRACER, &size);
-	CU_TEST(file2 != NULL);
-	CU_TEST(size >= strlen(tracer));
-	CU_TEST(strncmp(file2, tracer, strlen(tracer)) == 0);
-	free(file1);
-	free(file2);
-
-	tracefs_put_tracing_file(inst_file);
-	free(fname);
-
-	CU_TEST(tracefs_file_exists(NULL, (char *)name) == false);
-	CU_TEST(tracefs_dir_exists(NULL, (char *)name) == false);
-	CU_TEST(tracefs_file_exists(instance, (char *)name) == false);
-	CU_TEST(tracefs_dir_exists(instance, (char *)name) == false);
-
-	CU_TEST(tracefs_file_exists(NULL, CUR_TRACER) == true);
-	CU_TEST(tracefs_dir_exists(NULL, CUR_TRACER) == false);
-	CU_TEST(tracefs_file_exists(instance, CUR_TRACER) == true);
-	CU_TEST(tracefs_dir_exists(instance, CUR_TRACER) == false);
-
-	CU_TEST(tracefs_file_exists(NULL, PER_CPU) == false);
-	CU_TEST(tracefs_dir_exists(NULL, PER_CPU) == true);
-	CU_TEST(tracefs_file_exists(instance, PER_CPU) == false);
-	CU_TEST(tracefs_dir_exists(instance, PER_CPU) == true);
-
-	CU_TEST(tracefs_instance_destroy(NULL) != 0);
-	CU_TEST(tracefs_instance_destroy(instance) == 0);
-	CU_TEST(tracefs_instance_destroy(instance) != 0);
-	tracefs_instance_free(instance);
-	CU_TEST(stat(inst_dir, &st) != 0);
-	free(inst_dir);
-}
-
-static void exclude_string(char **strings, char *name)
-{
-	int i;
-
-	for (i = 0; strings[i]; i++) {
-		if (strcmp(strings[i], name) == 0) {
-			free(strings[i]);
-			strings[i] = strdup("/");
-			return;
-		}
-	}
-}
-
-static void test_check_files(const char *fdir, char **files)
-{
-	struct dirent *dent;
-	DIR *dir;
-	int i;
-
-	dir = opendir(fdir);
-	CU_TEST(dir != NULL);
-
-	while ((dent = readdir(dir)))
-		exclude_string(files, dent->d_name);
-
-	closedir(dir);
-
-	for (i = 0; files[i]; i++)
-		CU_TEST(files[i][0] == '/');
-}
-
-static void test_system_event(void)
-{
-	const char *tdir;
-	char **systems;
-	char **events;
-	char *sdir = NULL;
-
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-
-	systems = tracefs_event_systems(tdir);
-	CU_TEST(systems != NULL);
-
-	events = tracefs_system_events(tdir, systems[0]);
-	CU_TEST(events != NULL);
-
-	asprintf(&sdir, "%s/events/%s", tdir, systems[0]);
-	CU_TEST(sdir != NULL);
-	test_check_files(sdir, events);
-	free(sdir);
-	sdir = NULL;
-
-	asprintf(&sdir, "%s/events", tdir);
-	CU_TEST(sdir != NULL);
-	test_check_files(sdir, systems);
-
-	tracefs_list_free(systems);
-	tracefs_list_free(events);
-
-	free(sdir);
-}
-
-static void test_tracers(void)
-{
-	const char *tdir;
-	char **tracers;
-	char *tfile;
-	char *tracer;
-	int i;
-
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-
-	tracers = tracefs_tracers(tdir);
-	CU_TEST(tracers != NULL);
-
-	tfile = tracefs_instance_file_read(NULL, ALL_TRACERS, NULL);
-
-	tracer = strtok(tfile, " ");
-	while (tracer) {
-		exclude_string(tracers, tracer);
-		tracer = strtok(NULL, " ");
-	}
-
-	for (i = 0; tracers[i]; i++)
-		CU_TEST(tracers[i][0] == '/');
-
-	tracefs_list_free(tracers);
-	free(tfile);
-}
-
-static void test_check_events(struct tep_handle *tep, char *system, bool exist)
-{
-	struct dirent *dent;
-	char file[PATH_MAX];
-	char buf[1024];
-	char *edir = NULL;
-	const char *tdir;
-	DIR *dir;
-	int fd;
-
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-
-	asprintf(&edir, "%s/events/%s", tdir, system);
-	dir = opendir(edir);
-	CU_TEST(dir != NULL);
-
-	while ((dent = readdir(dir))) {
-		if (dent->d_name[0] == '.')
-			continue;
-		sprintf(file, "%s/%s/id", edir, dent->d_name);
-		fd = open(file, O_RDONLY);
-		if (fd < 0)
-			continue;
-		CU_TEST(read(fd, buf, 1024) > 0);
-		if (exist) {
-			CU_TEST(tep_find_event(tep, atoi(buf)) != NULL);
-		} else {
-			CU_TEST(tep_find_event(tep, atoi(buf)) == NULL);
-		}
-
-		close(fd);
-	}
-
-	closedir(dir);
-	free(edir);
-
-}
-
-static void test_local_events(void)
-{
-	struct tep_handle *tep;
-	const char *tdir;
-	char **systems;
-	char *lsystems[3];
-	int i;
-
-	tdir  = tracefs_tracing_dir();
-	CU_TEST(tdir != NULL);
-
-	tep = tracefs_local_events(tdir);
-	CU_TEST(tep != NULL);
-
-	systems = tracefs_event_systems(tdir);
-	CU_TEST(systems != NULL);
-
-	for (i = 0; systems[i]; i++)
-		test_check_events(tep, systems[i], true);
-	tep_free(tep);
-
-	memset(lsystems, 0, sizeof(lsystems));
-	for (i = 0; systems[i]; i++) {
-		if (!lsystems[0])
-			lsystems[0] = systems[i];
-		else if (!lsystems[2])
-			lsystems[2] = systems[i];
-		else
-			break;
-	}
-
-	if (lsystems[0] && lsystems[2]) {
-		tep = tracefs_local_events_system(tdir,
-						  (const char * const *)lsystems);
-		CU_TEST(tep != NULL);
-		test_check_events(tep, lsystems[0], true);
-		test_check_events(tep, lsystems[2], false);
-	}
-	tep_free(tep);
-
-	tep = tep_alloc();
-	CU_TEST(tep != NULL);
-	CU_TEST(tracefs_fill_local_events(tdir, tep, NULL) == 0);
-	for (i = 0; systems[i]; i++)
-		test_check_events(tep, systems[i], true);
-
-	tep_free(tep);
-
-	tracefs_list_free(systems);
-}
-
-struct test_walk_instance {
-	struct tracefs_instance *instance;
-	bool found;
-};
-#define WALK_COUNT 10
-int test_instances_walk_cb(const char *name, void *data)
+static int test_suite_destroy(void)
 {
-	struct test_walk_instance *instances  = (struct test_walk_instance *)data;
-	int i;
-
-	CU_TEST(instances != NULL);
-	CU_TEST(name != NULL);
-
-	for (i = 0; i < WALK_COUNT; i++) {
-		if (!strcmp(name,
-			    tracefs_instance_get_name(instances[i].instance))) {
-			instances[i].found = true;
-			break;
-		}
-	}
-
 	return 0;
 }
 
-static void test_instances_walk(void)
+static int test_suite_init(void)
 {
-	struct test_walk_instance instances[WALK_COUNT];
-	int i;
+	struct stat st;
+	const char *p;
 
-	memset(instances, 0, WALK_COUNT * sizeof(struct test_walk_instance));
-	for (i = 0; i < WALK_COUNT; i++) {
-		instances[i].instance = tracefs_instance_create(get_rand_str());
-		CU_TEST(instances[i].instance != NULL);
-	}
+	/* The test must be in the utest directory */
+	for (p = argv0 + strlen(argv0) - 1; p > argv0 && *p != '/'; p--)
+		;
 
-	CU_TEST(tracefs_instances_walk(test_instances_walk_cb, instances) == 0);
-	for (i = 0; i < WALK_COUNT; i++) {
-		CU_TEST(instances[i].found);
-		tracefs_instance_destroy(instances[i].instance);
-		instances[i].found = false;
-	}
+	if (*p == '/')
+		snprintf(tracecmd_exec, PATH_MAX, "%.*s/../tracecmd/trace-cmd",
+			 (int)(p - argv0), argv0);
+	else
+		strncpy(tracecmd_exec, "../tracecmd/trace-cmd", PATH_MAX);
 
-	CU_TEST(tracefs_instances_walk(test_instances_walk_cb, instances) == 0);
-	for (i = 0; i < WALK_COUNT; i++) {
-		CU_TEST(!instances[i].found);
-		tracefs_instance_free(instances[i].instance);
+	if (stat(tracecmd_exec, &st) < 0) {
+		fprintf(stderr, "In tree trace-cmd executable not found\n");
+		return 1;
 	}
-}
 
-static void current_clock_check(const char *clock)
-{
-	int size = 0;
-	char *clocks;
-	char *str;
-
-	clocks = tracefs_instance_file_read(test_instance, "trace_clock", &size);
-	CU_TEST(clocks != NULL);
-	CU_TEST(size > strlen(clock));
-	str = strstr(clocks, clock);
-	CU_TEST(str != NULL);
-	CU_TEST(str != clocks);
-	CU_TEST(*(str - 1) == '[');
-	CU_TEST(*(str + strlen(clock)) == ']');
-	free(clocks);
-}
-
-static void test_get_clock(void)
-{
-	const char *clock;
-
-	clock = tracefs_get_clock(test_instance);
-	CU_TEST(clock != NULL);
-	current_clock_check(clock);
-	free((char *)clock);
-}
-
-static int test_suite_destroy(void)
-{
-	tracefs_instance_destroy(test_instance);
-	tracefs_instance_free(test_instance);
-	tep_free(test_tep);
-	return 0;
-}
-
-static int test_suite_init(void)
-{
-	const char *systems[] = {"ftrace", NULL};
-
-	test_tep = tracefs_local_events_system(NULL, systems);
-	if (test_tep == NULL)
-		return 1;
-	test_instance = tracefs_instance_create(TEST_INSTANCE_NAME);
-	if (!test_instance)
+	if (!(st.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH))) {
+		fprintf(stderr, "In tree trace-cmd executable not executable\n");
 		return 1;
+	}
 
 	return 0;
 }
 
-void test_tracefs_lib(void)
+void test_tracecmd_lib(void)
 {
 	CU_pSuite suite = NULL;
 
-	suite = CU_add_suite(TRACEFS_SUITE, test_suite_init, test_suite_destroy);
+	suite = CU_add_suite(TRACECMD_SUITE, test_suite_init, test_suite_destroy);
 	if (suite == NULL) {
-		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
+		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACECMD_SUITE);
 		return;
 	}
-	CU_add_test(suite, "tracing file / directory APIs",
-		    test_trace_file);
-	CU_add_test(suite, "instance file / directory APIs",
-		    test_instance_file);
-	CU_add_test(suite, "systems and events APIs",
-		    test_system_event);
-	CU_add_test(suite, "tracefs_iterate_raw_events API",
-		    test_iter_raw_events);
-	CU_add_test(suite, "tracefs_tracers API",
-		    test_tracers);
-	CU_add_test(suite, "tracefs_local events API",
-		    test_local_events);
-	CU_add_test(suite, "tracefs_instances_walk API",
-		    test_instances_walk);
-	CU_add_test(suite, "tracefs_get_clock API",
-		    test_get_clock);
+	CU_add_test(suite, "Simple record and report",
+		    test_trace_record_report);
 }
-- 
2.35.1

