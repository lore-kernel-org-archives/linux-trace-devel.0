Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983F3C63777
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A8DC21D7F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MwbEBLeB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgKZH1Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbgKZH1Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 02:27:25 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306BFC0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:25 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id d142so1120376wmd.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+jtNY7HmRGSvFStiremIW44o6N3bTVGpOPpA5RqFE0=;
        b=MwbEBLeBPSj8od3L0L6p4FuF72+omvpV0YPrtvAAbpjt4bK1kbkPqoXIlSnf0nS4Yp
         YQz/FZI+7PtqJaKjFnDVBbxv3jiZKiCoFrOst/xKeL7I8jv0Cy/u+dNBQDoU1FHr22HK
         mRYXw7rCI+ua19jyp/hsT/oieQksNfhpwaeJuA12frsfJmvr+uBuLXPRcGteRefzjRRL
         6PLremqZkIsM33jOjOhF7cjkXXiv0sHUTBWDOVvYU401FH2PhH4WDtv7YDamdp95v7s7
         22HvJDzRNZWyg2O7zGf1gA1P1mKRzNR+7FtVijCcL/8Z1yQ6o7VJtHvA5z8mYeaVDn9+
         FIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+jtNY7HmRGSvFStiremIW44o6N3bTVGpOPpA5RqFE0=;
        b=b+GYyd4eLvGRj7fLdP+mMnlR/2w7o6l84nh6a703k8nr1rNZp0rH0fk9TIqPnuun0a
         8GQ5YRJ5XvlakPCYMxfxGQzQhyvfuOsFtgOQw+5hDsCL4yuVK58gug7rBx5Z8MCCPkd/
         cWIRcIXSvNBbd0Ymx8sz3Q/J7nvvNT84cEE1c3K8D+WBtHkEQQFNePB+GXoPkO4cbx7d
         6oWBv8AettK/At1vK1ECNRrdka4mlZjivSHSCnqRgp+JGo5pTeESyDNN9NW8w27MjYR2
         ZTTFKB97mdMirV0pwe0vrYPZPdSgzsivxDpy7Jeqi0sb9eTkvwayg6ykisa569wR+TPD
         XVgA==
X-Gm-Message-State: AOAM530TtbCySIR9ORwN6iKGuJm7yFDlL2637p9ZQlXcZejgH1Wpu6YH
        IFZnLdBBATTv9vT4mnYesK6A0LBhMw88QGE7
X-Google-Smtp-Source: ABdhPJxIfg2rDdvh7Xr7nig8OtCBA7sdrv9tyhuE2YBF5EwwERN0XQAIsMTikgF41zHGBqGvj3d/jQ==
X-Received: by 2002:a1c:80c3:: with SMTP id b186mr1745400wmd.20.1606375643802;
        Wed, 25 Nov 2020 23:27:23 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n4sm7269659wmc.30.2020.11.25.23.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 23:27:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] libtracefs: Add unit tests
Date:   Thu, 26 Nov 2020 09:27:18 +0200
Message-Id: <20201126072719.906443-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201126072719.906443-1-tz.stoyanov@gmail.com>
References: <20201126072719.906443-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The CUnit test infrastructure is integrated in libtracefs.
 http://cunit.sourceforge.net/
The library and its headers must be installed on the machine, in order
to build the libtracefs unit tests. For Fedora, these packages must be installed:
   CUnit, CUnit-devel

A new directory is added:
 utest
containing unit tests implementation.

Added new target to the top Makefile:
  make test
which builds the unit test binary:
 utest/trace-utest

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 Makefile              |   3 +-
 utest/Makefile        |  42 +++
 utest/README          |  15 ++
 utest/trace-utest.c   |  83 ++++++
 utest/trace-utest.h   |  11 +
 utest/tracefs-utest.c | 588 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 741 insertions(+), 1 deletion(-)
 create mode 100644 utest/Makefile
 create mode 100644 utest/README
 create mode 100644 utest/trace-utest.c
 create mode 100644 utest/trace-utest.h
 create mode 100644 utest/tracefs-utest.c

diff --git a/Makefile b/Makefile
index dc7deb1..b464401 100644
--- a/Makefile
+++ b/Makefile
@@ -125,7 +125,7 @@ LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so.$(TRACEFS_VERSION)
 TRACE_LIBS = -L$(LIBTRACEFS_DIR) -ltracefs
 
 export LIBS TRACE_LIBS
-export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
+export LIBTRACEFS_STATIC LIBTRACEFS_SHARED LIBTRACEFS_DIR
 
 export Q SILENT VERBOSE EXT
 
@@ -289,6 +289,7 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
+	$(MAKE) -C $(src)/utest clean
 	$(RM) $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
 	$(RM) $(PKG_CONFIG_FILE)
 
diff --git a/utest/Makefile b/utest/Makefile
new file mode 100644
index 0000000..a26d7a9
--- /dev/null
+++ b/utest/Makefile
@@ -0,0 +1,42 @@
+
+include $(src)/scripts/utils.mk
+
+bdir:=$(obj)/utest
+
+TARGETS = $(bdir)/trace-utest
+
+OBJS =
+OBJS += trace-utest.o
+OBJS += tracefs-utest.o
+
+LIBS += -lcunit				\
+	-ldl				\
+	-L$(LIBTRACEFS_DIR) -ltracefs
+
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
+
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(bdir)/trace-utest: $(OBJS)
+	$(Q)$(do_app_build)
+
+$(bdir)/%.o: %.c
+	$(Q)$(call do_fpic_compile)
+
+$(DEPS): $(bdir)/.%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
+
+dep_includes := $(wildcard $(DEPS))
+
+test: $(TARGETS)
+
+clean:
+	$(RM) $(TARGETS) $(bdir)/*.o $(bdir)/.*.d
diff --git a/utest/README b/utest/README
new file mode 100644
index 0000000..ed92042
--- /dev/null
+++ b/utest/README
@@ -0,0 +1,15 @@
+
+Unit tests for tracefs library. The tests use CUnit framework:
+ http://cunit.sourceforge.net/
+which must be pre installed on the system, before building the unit tests.
+The framework can be downloaded, compiled and installed manually, or
+using a precompiled distro package:
+
+ Fedora:
+	 CUnit
+	 CUnit-devel
+
+ Ubuntu and Debian:
+	libcunit1
+	libcunit1-doc
+	libcunit1-dev
diff --git a/utest/trace-utest.c b/utest/trace-utest.c
new file mode 100644
index 0000000..58d4d4e
--- /dev/null
+++ b/utest/trace-utest.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <stdlib.h>
+
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+
+#include "trace-utest.h"
+
+enum unit_tests {
+	RUN_NONE	= 0,
+	RUN_TRACEFS	= (1 << 0),
+	RUN_ALL		= 0xFFFF
+};
+
+static void print_help(char **argv)
+{
+	printf("Usage: %s [OPTIONS]\n", basename(argv[0]));
+	printf("\t-s, --silent\tPrint test summary\n");
+	printf("\t-r, --run test\tRun specific test:\n");
+	printf("\t\t  tracefs   run libtracefs tests\n");
+	printf("\t-h, --help\tPrint usage information\n");
+	exit(0);
+}
+
+int main(int argc, char **argv)
+{
+	CU_BasicRunMode verbose = CU_BRM_VERBOSE;
+	enum unit_tests tests = RUN_NONE;
+
+	for (;;) {
+		int c;
+		int index = 0;
+		const char *opts = "+hsr:";
+		static struct option long_options[] = {
+			{"silent", no_argument, NULL, 's'},
+			{"run", required_argument, NULL, 'r'},
+			{"help", no_argument, NULL, 'h'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long (argc, argv, opts, long_options, &index);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'r':
+			if (strcmp(optarg, "tracefs") == 0)
+				tests |= RUN_TRACEFS;
+			else
+				print_help(argv);
+			break;
+		case 's':
+			verbose = CU_BRM_SILENT;
+			break;
+		case 'h':
+		default:
+			print_help(argv);
+			break;
+		}
+	}
+
+	if (tests == RUN_NONE)
+		tests = RUN_ALL;
+
+	if (CU_initialize_registry() != CUE_SUCCESS) {
+		printf("Test registry cannot be initialized\n");
+		return -1;
+	}
+
+	if (tests & RUN_TRACEFS)
+		test_tracefs_lib();
+
+	CU_basic_set_mode(verbose);
+	CU_basic_run_tests();
+	CU_cleanup_registry();
+	return 0;
+}
diff --git a/utest/trace-utest.h b/utest/trace-utest.h
new file mode 100644
index 0000000..917c0e7
--- /dev/null
+++ b/utest/trace-utest.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#ifndef _TRACE_UTEST_H_
+#define _TRACE_UTEST_H_
+
+void test_tracefs_lib(void);
+
+#endif /* _TRACE_UTEST_H_ */
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
new file mode 100644
index 0000000..24ea0fc
--- /dev/null
+++ b/utest/tracefs-utest.c
@@ -0,0 +1,588 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <time.h>
+#include <dirent.h>
+
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+
+#include "tracefs.h"
+
+#define TRACEFS_SUITE		"trasefs library"
+#define TEST_INSTANCE_NAME	"cunit_test_iter"
+#define TEST_ARRAY_SIZE		50
+
+static struct tracefs_instance *test_instance;
+static struct tep_handle *test_tep;
+static int test_array[TEST_ARRAY_SIZE];
+static int test_found;
+
+static int test_callback(struct tep_event *event, struct tep_record *record,
+			  int cpu, void *context)
+{
+	struct tep_format_field *field;
+	int val, i;
+
+	field = tep_find_field(event, "buf");
+	if (field) {
+		val = *((int *)(record->data + field->offset));
+		for (i = 0; i < TEST_ARRAY_SIZE; i++) {
+			if (test_array[i] == val) {
+				test_array[i] = 0;
+				test_found++;
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static void test_iter_write(void)
+{
+	char *path;
+	int i, fd;
+	int ret;
+
+	path = tracefs_instance_get_file(test_instance, "trace_marker");
+	CU_TEST(path != NULL);
+	fd = open(path, O_WRONLY);
+	CU_TEST(fd >= 0);
+
+	for (i = 0; i < TEST_ARRAY_SIZE; i++) {
+		test_array[i] = random();
+		ret = write(fd, test_array + i, sizeof(int));
+		CU_TEST(ret == sizeof(int));
+	}
+
+	tracefs_put_tracing_file(path);
+	close(fd);
+}
+
+
+static void test_iter_raw_events(void)
+{
+	int ret;
+
+	ret = tracefs_iterate_raw_events(NULL, test_instance, test_callback, NULL);
+	CU_TEST(ret < 0);
+	ret = tracefs_iterate_raw_events(test_tep, NULL, test_callback, NULL);
+	CU_TEST(ret == 0);
+	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, NULL);
+	CU_TEST(ret < 0);
+
+	test_found = 0;
+	test_iter_write();
+	ret = tracefs_iterate_raw_events(test_tep, test_instance,
+					 test_callback, NULL);
+	CU_TEST(ret == 0);
+	CU_TEST(test_found == TEST_ARRAY_SIZE);
+}
+
+#define RAND_STR_SIZE 20
+#define RAND_ASCII "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
+static const char *get_rand_str(void)
+{
+	static char str[RAND_STR_SIZE];
+	static char sym[] = RAND_ASCII;
+	struct timespec clk;
+	int i;
+
+	clock_gettime(CLOCK_REALTIME, &clk);
+	srand(clk.tv_nsec);
+	for (i = 0; i < RAND_STR_SIZE; i++)
+		str[i] = sym[rand() % (sizeof(sym) - 1)];
+
+	str[RAND_STR_SIZE - 1] = 0;
+	return str;
+}
+
+static void test_trace_file(void)
+{
+	const char *tmp = get_rand_str();
+	const char *tdir;
+	struct stat st;
+	char *file;
+	char *dir;
+
+	dir = tracefs_find_tracing_dir();
+	CU_TEST(dir != NULL);
+	CU_TEST(stat(dir, &st) == 0);
+	CU_TEST(S_ISDIR(st.st_mode));
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+	CU_TEST(stat(tdir, &st) == 0);
+	CU_TEST(S_ISDIR(st.st_mode));
+
+	CU_TEST(strcmp(dir, tdir) == 0);
+	free(dir);
+
+	file = tracefs_get_tracing_file(NULL);
+	CU_TEST(file == NULL);
+	file = tracefs_get_tracing_file(tmp);
+	CU_TEST(file != NULL);
+	CU_TEST(stat(file, &st) != 0);
+	tracefs_put_tracing_file(file);
+
+	file = tracefs_get_tracing_file("trace");
+	CU_TEST(file != NULL);
+	CU_TEST(stat(file, &st) == 0);
+	tracefs_put_tracing_file(file);
+}
+
+static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
+{
+	const char *tdir  = tracefs_get_tracing_dir();
+	char buf[BUFSIZ];
+	char *fpath;
+	char *file;
+	size_t fsize = 0;
+	int size = 0;
+	int fd;
+
+	if (inst) {
+		CU_TEST(asprintf(&fpath, "%s/instances/%s/%s",
+			tdir, tracefs_instance_get_name(inst), fname) > 0);
+	} else {
+		CU_TEST(asprintf(&fpath, "%s/%s", tdir, fname) > 0);
+	}
+
+	memset(buf, 0, BUFSIZ);
+	fd = open(fpath, O_RDONLY);
+	CU_TEST(fd >= 0);
+	fsize = read(fd, buf, BUFSIZ);
+	CU_TEST(fsize >= 0);
+	close(fd);
+	buf[BUFSIZ - 1] = 0;
+
+	file = tracefs_instance_file_read(inst, fname, &size);
+	CU_TEST(file != NULL);
+	CU_TEST(size == fsize);
+	CU_TEST(strcmp(file, buf) == 0);
+
+	free(fpath);
+	free(file);
+}
+
+#define ALL_TRACERS	"available_tracers"
+#define CUR_TRACER	"current_tracer"
+#define PER_CPU		"per_cpu"
+static void test_instance_file(void)
+{
+	struct tracefs_instance *instance = NULL;
+	struct tracefs_instance *second = NULL;
+	const char *name = get_rand_str();
+	const char *inst_name = NULL;
+	const char *tdir;
+	char *inst_file;
+	char *inst_dir;
+	struct stat st;
+	char *fname;
+	char *file1;
+	char *file2;
+	char *tracer;
+	int size;
+	int ret;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+	CU_TEST(asprintf(&inst_dir, "%s/instances/%s", tdir, name) > 0);
+	CU_TEST(stat(inst_dir, &st) != 0);
+
+	CU_TEST(tracefs_instance_exists(name) == false);
+	instance = tracefs_instance_create(name);
+	CU_TEST(instance != NULL);
+	CU_TEST(tracefs_instance_is_new(instance));
+	second = tracefs_instance_create(name);
+	CU_TEST(second != NULL);
+	CU_TEST(!tracefs_instance_is_new(second));
+	tracefs_instance_free(second);
+	CU_TEST(tracefs_instance_exists(name) == true);
+	CU_TEST(stat(inst_dir, &st) == 0);
+	CU_TEST(S_ISDIR(st.st_mode));
+	inst_name = tracefs_instance_get_name(instance);
+	CU_TEST(inst_name != NULL);
+	CU_TEST(strcmp(inst_name, name) == 0);
+
+	fname = tracefs_instance_get_dir(NULL);
+	CU_TEST(fname != NULL);
+	CU_TEST(strcmp(fname, tdir) == 0);
+	free(fname);
+
+	fname = tracefs_instance_get_dir(instance);
+	CU_TEST(fname != NULL);
+	CU_TEST(strcmp(fname, inst_dir) == 0);
+	free(fname);
+
+	CU_TEST(asprintf(&fname, "%s/"ALL_TRACERS, tdir) > 0);
+	CU_TEST(fname != NULL);
+	inst_file = tracefs_instance_get_file(NULL, ALL_TRACERS);
+	CU_TEST(inst_file != NULL);
+	CU_TEST(strcmp(fname, inst_file) == 0);
+	tracefs_put_tracing_file(inst_file);
+	free(fname);
+
+	CU_TEST(asprintf(&fname, "%s/instances/%s/"ALL_TRACERS, tdir, name) > 0);
+	CU_TEST(fname != NULL);
+	CU_TEST(stat(fname, &st) == 0);
+	inst_file = tracefs_instance_get_file(instance, ALL_TRACERS);
+	CU_TEST(inst_file != NULL);
+	CU_TEST(strcmp(fname, inst_file) == 0);
+
+	test_instance_file_read(NULL, ALL_TRACERS);
+	test_instance_file_read(instance, ALL_TRACERS);
+
+	file1 = tracefs_instance_file_read(instance, ALL_TRACERS, NULL);
+	CU_TEST(file1 != NULL);
+	tracer = strtok(file1, " ");
+	CU_TEST(tracer != NULL);
+	ret = tracefs_instance_file_write(instance, CUR_TRACER, tracer);
+	CU_TEST(ret == strlen(tracer));
+	file2 = tracefs_instance_file_read(instance, CUR_TRACER, &size);
+	CU_TEST(file2 != NULL);
+	CU_TEST(size >= strlen(tracer));
+	CU_TEST(strncmp(file2, tracer, strlen(tracer)) == 0);
+	free(file1);
+	free(file2);
+
+	tracefs_put_tracing_file(inst_file);
+	free(fname);
+
+	CU_TEST(tracefs_file_exists(NULL, (char *)name) == false);
+	CU_TEST(tracefs_dir_exists(NULL, (char *)name) == false);
+	CU_TEST(tracefs_file_exists(instance, (char *)name) == false);
+	CU_TEST(tracefs_dir_exists(instance, (char *)name) == false);
+
+	CU_TEST(tracefs_file_exists(NULL, CUR_TRACER) == true);
+	CU_TEST(tracefs_dir_exists(NULL, CUR_TRACER) == false);
+	CU_TEST(tracefs_file_exists(instance, CUR_TRACER) == true);
+	CU_TEST(tracefs_dir_exists(instance, CUR_TRACER) == false);
+
+	CU_TEST(tracefs_file_exists(NULL, PER_CPU) == false);
+	CU_TEST(tracefs_dir_exists(NULL, PER_CPU) == true);
+	CU_TEST(tracefs_file_exists(instance, PER_CPU) == false);
+	CU_TEST(tracefs_dir_exists(instance, PER_CPU) == true);
+
+	CU_TEST(tracefs_instance_destroy(NULL) != 0);
+	CU_TEST(tracefs_instance_destroy(instance) == 0);
+	CU_TEST(tracefs_instance_destroy(instance) != 0);
+	tracefs_instance_free(instance);
+	CU_TEST(stat(inst_dir, &st) != 0);
+	free(inst_dir);
+}
+
+static void exclude_string(char **strings, char *name)
+{
+	int i;
+
+	for (i = 0; strings[i]; i++) {
+		if (strcmp(strings[i], name) == 0) {
+			free(strings[i]);
+			strings[i] = strdup("/");
+			return;
+		}
+	}
+}
+
+static void test_check_files(const char *fdir, char **files)
+{
+	struct dirent *dent;
+	DIR *dir;
+	int i;
+
+	dir = opendir(fdir);
+	CU_TEST(dir != NULL);
+
+	while ((dent = readdir(dir)))
+		exclude_string(files, dent->d_name);
+
+	closedir(dir);
+
+	for (i = 0; files[i]; i++)
+		CU_TEST(files[i][0] == '/');
+}
+
+static void test_system_event(void)
+{
+	const char *tdir;
+	char **systems;
+	char **events;
+	char *sdir = NULL;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	systems = tracefs_event_systems(tdir);
+	CU_TEST(systems != NULL);
+
+	events = tracefs_system_events(tdir, systems[0]);
+	CU_TEST(events != NULL);
+
+	asprintf(&sdir, "%s/events/%s", tdir, systems[0]);
+	CU_TEST(sdir != NULL);
+	test_check_files(sdir, events);
+	free(sdir);
+	sdir = NULL;
+
+	asprintf(&sdir, "%s/events", tdir);
+	CU_TEST(sdir != NULL);
+	test_check_files(sdir, systems);
+
+	tracefs_list_free(systems);
+	tracefs_list_free(events);
+
+	free(sdir);
+}
+
+static void test_tracers(void)
+{
+	const char *tdir;
+	char **tracers;
+	char *tfile;
+	char *tracer;
+	int i;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	tracers = tracefs_tracers(tdir);
+	CU_TEST(tracers != NULL);
+
+	tfile = tracefs_instance_file_read(NULL, ALL_TRACERS, NULL);
+
+	tracer = strtok(tfile, " ");
+	while (tracer) {
+		exclude_string(tracers, tracer);
+		tracer = strtok(NULL, " ");
+	}
+
+	for (i = 0; tracers[i]; i++)
+		CU_TEST(tracers[i][0] == '/');
+
+	tracefs_list_free(tracers);
+	free(tfile);
+}
+
+static void test_check_events(struct tep_handle *tep, char *system, bool exist)
+{
+	struct dirent *dent;
+	char file[PATH_MAX];
+	char buf[1024];
+	char *edir = NULL;
+	const char *tdir;
+	DIR *dir;
+	int fd;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	asprintf(&edir, "%s/events/%s", tdir, system);
+	dir = opendir(edir);
+	CU_TEST(dir != NULL);
+
+	while ((dent = readdir(dir))) {
+		if (dent->d_name[0] == '.')
+			continue;
+		sprintf(file, "%s/%s/id", edir, dent->d_name);
+		fd = open(file, O_RDONLY);
+		if (fd < 0)
+			continue;
+		CU_TEST(read(fd, buf, 1024) > 0);
+		if (exist) {
+			CU_TEST(tep_find_event(tep, atoi(buf)) != NULL);
+		} else {
+			CU_TEST(tep_find_event(tep, atoi(buf)) == NULL);
+		}
+
+		close(fd);
+	}
+
+	closedir(dir);
+	free(edir);
+
+}
+
+static void test_local_events(void)
+{
+	struct tep_handle *tep;
+	const char *tdir;
+	char **systems;
+	char *lsystems[3];
+	int i;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	tep = tracefs_local_events(tdir);
+	CU_TEST(tep != NULL);
+
+	systems = tracefs_event_systems(tdir);
+	CU_TEST(systems != NULL);
+
+	for (i = 0; systems[i]; i++)
+		test_check_events(tep, systems[i], true);
+	tep_free(tep);
+
+	memset(lsystems, 0, sizeof(lsystems));
+	for (i = 0; systems[i]; i++) {
+		if (!lsystems[0])
+			lsystems[0] = systems[i];
+		else if (!lsystems[2])
+			lsystems[2] = systems[i];
+		else
+			break;
+	}
+
+	if (lsystems[0] && lsystems[2]) {
+		tep = tracefs_local_events_system(tdir,
+						  (const char * const *)lsystems);
+		CU_TEST(tep != NULL);
+		test_check_events(tep, lsystems[0], true);
+		test_check_events(tep, lsystems[2], false);
+	}
+	tep_free(tep);
+
+	tep = tep_alloc();
+	CU_TEST(tep != NULL);
+	CU_TEST(tracefs_fill_local_events(tdir, tep, NULL) == 0);
+	for (i = 0; systems[i]; i++)
+		test_check_events(tep, systems[i], true);
+
+	tep_free(tep);
+
+	tracefs_list_free(systems);
+}
+
+struct test_walk_instance {
+	struct tracefs_instance *instance;
+	bool found;
+};
+#define WALK_COUNT 10
+int test_instances_walk_cb(const char *name, void *data)
+{
+	struct test_walk_instance *instances  = (struct test_walk_instance *)data;
+	int i;
+
+	CU_TEST(instances != NULL);
+	CU_TEST(name != NULL);
+
+	for (i = 0; i < WALK_COUNT; i++) {
+		if (!strcmp(name,
+			    tracefs_instance_get_name(instances[i].instance))) {
+			instances[i].found = true;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void test_instances_walk(void)
+{
+	struct test_walk_instance instances[WALK_COUNT];
+	int i;
+
+	memset(instances, 0, WALK_COUNT * sizeof(struct test_walk_instance));
+	for (i = 0; i < WALK_COUNT; i++) {
+		instances[i].instance = tracefs_instance_create(get_rand_str());
+		CU_TEST(instances[i].instance != NULL);
+	}
+
+	CU_TEST(tracefs_instances_walk(test_instances_walk_cb, instances) == 0);
+	for (i = 0; i < WALK_COUNT; i++) {
+		CU_TEST(instances[i].found);
+		tracefs_instance_destroy(instances[i].instance);
+		instances[i].found = false;
+	}
+
+	CU_TEST(tracefs_instances_walk(test_instances_walk_cb, instances) == 0);
+	for (i = 0; i < WALK_COUNT; i++) {
+		CU_TEST(!instances[i].found);
+		tracefs_instance_free(instances[i].instance);
+	}
+}
+
+static void current_clock_check(const char *clock)
+{
+	int size = 0;
+	char *clocks;
+	char *str;
+
+	clocks = tracefs_instance_file_read(test_instance, "trace_clock", &size);
+	CU_TEST(clocks != NULL);
+	CU_TEST(size > strlen(clock));
+	str = strstr(clocks, clock);
+	CU_TEST(str != NULL);
+	CU_TEST(str != clocks);
+	CU_TEST(*(str - 1) == '[');
+	CU_TEST(*(str + strlen(clock)) == ']');
+	free(clocks);
+}
+
+static void test_get_clock(void)
+{
+	const char *clock;
+
+	clock = tracefs_get_clock(test_instance);
+	CU_TEST(clock != NULL);
+	current_clock_check(clock);
+	free((char *)clock);
+}
+
+static int test_suite_destroy(void)
+{
+	tracefs_instance_destroy(test_instance);
+	tracefs_instance_free(test_instance);
+	tep_free(test_tep);
+	return 0;
+}
+
+static int test_suite_init(void)
+{
+	const char *systems[] = {"ftrace", NULL};
+
+	test_tep = tracefs_local_events_system(NULL, systems);
+	if (test_tep == NULL)
+		return 1;
+	test_instance = tracefs_instance_create(TEST_INSTANCE_NAME);
+	if (!test_instance)
+		return 1;
+
+	return 0;
+}
+
+void test_tracefs_lib(void)
+{
+	CU_pSuite suite = NULL;
+
+	suite = CU_add_suite(TRACEFS_SUITE, test_suite_init, test_suite_destroy);
+	if (suite == NULL) {
+		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
+		return;
+	}
+	CU_add_test(suite, "tracing file / directory APIs",
+		    test_trace_file);
+	CU_add_test(suite, "instance file / directory APIs",
+		    test_instance_file);
+	CU_add_test(suite, "systems and events APIs",
+		    test_system_event);
+	CU_add_test(suite, "tracefs_iterate_raw_events API",
+		    test_iter_raw_events);
+	CU_add_test(suite, "tracefs_tracers API",
+		    test_tracers);
+	CU_add_test(suite, "tracefs_local events API",
+		    test_local_events);
+	CU_add_test(suite, "tracefs_instances_walk API",
+		    test_instances_walk);
+	CU_add_test(suite, "tracefs_get_clock API",
+		    test_get_clock);
+}
-- 
2.28.0

