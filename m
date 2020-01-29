Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D9CC35240
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F2562071E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XCO0/6Nc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgA2Jyb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:31 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43283 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2Jyb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:31 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so17712353ljm.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4vr42sjJe0q/08Bn5iaslerHrDF2YI64KbYojm+T9wQ=;
        b=XCO0/6Nc3lb+cxaBSo/I1efx5Z+qfp6+5TfdUUg4/4zkDBkuwSQALMySsQpLGdNxDa
         AR2l1hTCO1QD5ZKiXCBQkYCIBJiEGIbU4MbO5OB6rkUExCrYK1CXq81HwvMmvVKUCfWd
         1NFe4NVxsZlZAeV9sEzWVJqoR80WLeKeMzTqr4OUs+8SJYSmDNzdrLGQ1KBiwJGTJDEk
         Zgb7c5BFUFOitqeR4JYCCiwiVuHBfUmnLfkkV9uIBIOVQ+LN0kdrDbGyi/oM7mXQUYt7
         +haXxPWUe5WjU08XBDuDJsrC5Sxo9n3+CXCi3mL9nOg/nv9owNbfrU4QvtDxw17cUXkb
         SeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4vr42sjJe0q/08Bn5iaslerHrDF2YI64KbYojm+T9wQ=;
        b=QhuM+6edCGnLqwlLGXUxseyMb8I7S1PoUieiCmPDjgKjdw+J4c5olR0rF3tr/uKNS3
         I5lb4WRIC4dbqeUySTIZi6yzRouPy+YCKIdvv/dsRfNQ9kPEVTyrNg1Orrde6EFm1u1b
         SvmZQkixt9yUGPRt9Yj6N+kzVlrjCEIytnxyPMU2yc63buwCLvP2IIjTAunHO1+I6Pic
         2tmm5ZOwWtxwzbobt9K5k+bo54IyzAJDnugQ+qC3fU/oSXnUmihjBGbJyvrWYiohfxJM
         ZlFCGLX87kv8DZOL1boYnWeiIm1YmjG8v2i/6RSmEbhOA6itgWixyRFFoNVru/9cPHCY
         golw==
X-Gm-Message-State: APjAAAUd2JgGZ8Qc3no3H7s50okO+V30nIfrYVA3dj7KD17FAtIfM3rQ
        Ty7YpUgUiPIuxnogwJbICiY=
X-Google-Smtp-Source: APXvYqwaOSOTMU1a4xZRhBOyG8WDf3b8aB2xdM2QI05P0LmF1OwAtztdTLyhLbqHmun2MgKEI239kA==
X-Received: by 2002:a2e:8105:: with SMTP id d5mr1910194ljg.25.1580291667981;
        Wed, 29 Jan 2020 01:54:27 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/9] trace-cmd: Unit test for libtracefs
Date:   Wed, 29 Jan 2020 11:54:16 +0200
Message-Id: <20200129095421.881786-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129095421.881786-1-tz.stoyanov@gmail.com>
References: <20200129095421.881786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CUnit test infrastructure is integrated in trace-cmd.
 http://cunit.sourceforge.net/
The library and its headers must be installed on the machine, in order
to build the trace-cmd unit tests. For Fedora, these packages must be installed:
   CUnit, CUnit-devel

A new directory is added:
 utest
containing unit tests implementation.

Added new target to trace-cmd top Makefile:
  make test
which builds the unit test binary:
 utest/trace-utest

The goal of this patch is not to provide full unit test coverage of
libtracefs, but to be a POC for adding test infrastructure to trace-cmd.

The first API, covered be the test is:
  tracefs_iterate_raw_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile              |  13 ++++-
 utest/Makefile        |  41 ++++++++++++++
 utest/README          |  15 +++++
 utest/trace-utest.c   |  83 ++++++++++++++++++++++++++++
 utest/trace-utest.h   |  11 ++++
 utest/tracefs-utest.c | 125 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 286 insertions(+), 2 deletions(-)
 create mode 100644 utest/Makefile
 create mode 100644 utest/README
 create mode 100644 utest/trace-utest.c
 create mode 100644 utest/trace-utest.h
 create mode 100644 utest/tracefs-utest.c

diff --git a/Makefile b/Makefile
index 477625f..ddf52ea 100644
--- a/Makefile
+++ b/Makefile
@@ -200,7 +200,7 @@ TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd		\
 	     -L$(LIBTRACEFS_DIR) -ltracefs
 
 export LIBS TRACE_LIBS
-export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
+export LIBTRACEEVENT_DIR LIBTRACECMD_DIR LIBTRACEFS_DIR
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
@@ -234,6 +234,9 @@ ifeq ($(VSOCK_DEFINED), 1)
 CFLAGS += -DVSOCK
 endif
 
+CUNIT_INSTALLED := $(shell if (echo -e "\#include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+export CUNIT_INSTALLED
+
 export CFLAGS
 export INCLUDES
 
@@ -319,7 +322,6 @@ $(LIBTRACEFS_STATIC): force
 $(LIBTRACEFS_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
 
-
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
 libtraceevent.a: $(LIBTRACEEVENT_STATIC)
 libtracecmd.a: $(LIBTRACECMD_STATIC)
@@ -329,6 +331,12 @@ libtracefs.so: $(LIBTRACEFS_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED) $(LIBTRACEFS_SHARED)
 
+test: force $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC) $(LIBTRACECMD_STATIC)
+ifneq ($(CUNIT_INSTALLED),1)
+	$(error CUnit framework not installed, cannot build unit tests))
+endif
+	$(Q)$(MAKE) -C $(src)/utest $@
+
 plugins_traceevent: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir \
 		   $(obj)/lib/traceevent/plugins/trace_python_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
@@ -430,6 +438,7 @@ clean:
 	$(MAKE) -C $(src)/lib/tracefs clean
 	$(MAKE) -C $(src)/lib/traceevent/plugins clean
 	$(MAKE) -C $(src)/lib/trace-cmd/plugins clean
+	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
 	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
diff --git a/utest/Makefile b/utest/Makefile
new file mode 100644
index 0000000..55aa46a
--- /dev/null
+++ b/utest/Makefile
@@ -0,0 +1,41 @@
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
+	-L$(LIBTRACEFS_DIR) -ltracefs	\
+	-L$(LIBTRACEEVENT_DIR) -ltraceevent
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
index 0000000..f93630d
--- /dev/null
+++ b/utest/README
@@ -0,0 +1,15 @@
+
+Unit tests for trace-cmd libraries. The tests use CUnit framework:
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
index 0000000..d3ba213
--- /dev/null
+++ b/utest/tracefs-utest.c
@@ -0,0 +1,125 @@
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
+
+	test_instance = tracefs_instance_alloc(TEST_INSTANCE_NAME);
+	if (test_instance == NULL)
+		return 1;
+
+	if (tracefs_instance_create(test_instance) < 0)
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
+	CU_add_test(suite, "tracefs_iterate_raw_events API",
+		    test_iter_raw_events);
+}
-- 
2.24.1

