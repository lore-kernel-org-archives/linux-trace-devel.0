Return-Path: <SRS0=5V0s=3G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF72C33CB1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B565206E6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iiGYuhYI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbgAQNz5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:55:57 -0500
Received: from mail-lf1-f49.google.com ([209.85.167.49]:44479 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727580AbgAQNz5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 08:55:57 -0500
Received: by mail-lf1-f49.google.com with SMTP id v201so18390654lfa.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jan 2020 05:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VB49kJVd8Q9Gk0gcELo+Yv7q3l/GoBnq1uPhDRPAXm0=;
        b=iiGYuhYIUyarTFL/ElVdV1sPqOEdTaFMwuBNLjdoN96LTI6ZAfo0L4vRrzoZSyiekl
         2xqfVQnJseX2xVwM+6I9E0EvLsNicxUhyGSSH96MmlwBH+9XoxV+8XERbFuycXciZyBF
         S4a2FGwUfWDs8E28iGPExhiSY1QNMOaVsjZD+1+VeCrtLw3Hu5ypZz5Lo3QkQ7n7VExN
         2HPpbkGfjMslxgxkmT1SKo94ST6Uz3I8v7Ag0DXzOQvCu44iqa9XAqOX3l0+TiIAQGwM
         AFxBXLzh/mmriERurd7unp7PZlq2NAZvFYCih+w7WQ68LU3culVnyqfqQePWC6hoxY6J
         jNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VB49kJVd8Q9Gk0gcELo+Yv7q3l/GoBnq1uPhDRPAXm0=;
        b=nr2G7d6MtY/+h2LNg8a70A1FTErLcBgFALhyvfR5hBnZpbASPjjd0HQp8pbteZNaLd
         kflyvJ1/q5c9H8hgoofsqowYdsmuGZh2xS2QVYVDmyuJoKYIgceoYLtO4oN6e+3jQH4X
         GuHZVMepUsW/WoGaJd9ley/SuPKgnG+sAG7dN6lMCwkt9M1EmCcPkqBgir4f4tfUy8eP
         hdbafG6+XKiQBDHYf9AWjdpM33hqi30uuqd492NRcvlgQsCXToYe8Tncrb1pRN+nD2+u
         FAGpN80nVroaeYSiBREyzDH4aHYqs/p7mYstTFvyXhc6B+g+QsUw3PkiFG9YgogyhqiQ
         1BfA==
X-Gm-Message-State: APjAAAUG+hfOV8U62FXAl9pHn9V7Jmo3MLs5lGa8jhiiDdnmjfgsv6R3
        pWJjizUqD9B7xESPLth/51M=
X-Google-Smtp-Source: APXvYqx9z5MHtYV9U/xCSXU8sKqJW8W6Riz4Gy0SWhLAiUuYR/EwzK5hXBB3GzajnGiKG1xZNxt+/Q==
X-Received: by 2002:a19:4f46:: with SMTP id a6mr5473088lfk.143.1579269353453;
        Fri, 17 Jan 2020 05:55:53 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 21sm12422562ljv.19.2020.01.17.05.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:55:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 5/5] trace-cmd: Unit test for libtracefs
Date:   Fri, 17 Jan 2020 15:55:44 +0200
Message-Id: <20200117135544.598235-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117135544.598235-1-tz.stoyanov@gmail.com>
References: <20200117135544.598235-1-tz.stoyanov@gmail.com>
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
 lib/utest
containing unit tests implementation.

Added new target to trace-cmd top Makefile:
  make test
which builds the unit test binary:
 lib/utest/trace-utest

The goal of this patch is not to provide full unit test coverage of
libtracefs, but to be a POC for adding test infrastructure to trace-cmd.

The first API, covered be the test is:
  tracefs_iterate_raw_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                  |  13 +++-
 lib/utest/Makefile        |  43 +++++++++++++
 lib/utest/trace-utest.c   |  83 ++++++++++++++++++++++++
 lib/utest/trace-utest.h   |  11 ++++
 lib/utest/tracefs-utest.c | 132 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 280 insertions(+), 2 deletions(-)
 create mode 100644 lib/utest/Makefile
 create mode 100644 lib/utest/trace-utest.c
 create mode 100644 lib/utest/trace-utest.h
 create mode 100644 lib/utest/tracefs-utest.c

diff --git a/Makefile b/Makefile
index aa803ba..a67dd67 100644
--- a/Makefile
+++ b/Makefile
@@ -192,7 +192,7 @@ TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd		\
 	     -L$(LIBTRACEFS_DIR) -ltracefs
 
 export LIBS TRACE_LIBS
-export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
+export LIBTRACEEVENT_DIR LIBTRACECMD_DIR LIBTRACEFS_DIR
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
@@ -226,6 +226,9 @@ ifeq ($(VSOCK_DEFINED), 1)
 CFLAGS += -DVSOCK
 endif
 
+CUNIT_INSTALLED := $(shell if (echo -e "\#include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+export CUNIT_INSTALLED
+
 export CFLAGS
 export INCLUDES
 
@@ -307,7 +310,6 @@ $(LIBTRACEFS_STATIC): force
 $(LIBTRACEFS_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
 
-
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
 libtraceevent.a: $(LIBTRACEEVENT_STATIC)
 libtracecmd.a: $(LIBTRACECMD_STATIC)
@@ -317,6 +319,12 @@ libtracefs.so: $(LIBTRACEFS_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED) $(LIBTRACEFS_SHARED)
 
+test: force $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC) $(LIBTRACECMD_STATIC)
+ifneq ($(CUNIT_INSTALLED),1)
+	$(error CUnit framework not installed, cannot build unit tests))
+endif
+	$(Q)$(MAKE) -C $(src)/lib/utest $@
+
 plugins: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir $(obj)/lib/traceevent/plugins/trace_python_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
 
@@ -401,6 +409,7 @@ clean:
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/lib/tracefs clean
 	$(MAKE) -C $(src)/lib/traceevent/plugins clean
+	$(MAKE) -C $(src)/lib/utest clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
 	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
diff --git a/lib/utest/Makefile b/lib/utest/Makefile
new file mode 100644
index 0000000..577b07f
--- /dev/null
+++ b/lib/utest/Makefile
@@ -0,0 +1,43 @@
+
+include $(src)/scripts/utils.mk
+
+bdir:=$(obj)/lib/utest
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
+#$(bdir)/trace-utest: $(LIBUTEST)
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
diff --git a/lib/utest/trace-utest.c b/lib/utest/trace-utest.c
new file mode 100644
index 0000000..58d4d4e
--- /dev/null
+++ b/lib/utest/trace-utest.c
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
diff --git a/lib/utest/trace-utest.h b/lib/utest/trace-utest.h
new file mode 100644
index 0000000..917c0e7
--- /dev/null
+++ b/lib/utest/trace-utest.h
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
diff --git a/lib/utest/tracefs-utest.c b/lib/utest/tracefs-utest.c
new file mode 100644
index 0000000..97bb087
--- /dev/null
+++ b/lib/utest/tracefs-utest.c
@@ -0,0 +1,132 @@
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
+static void test_iter_read(void)
+{
+	int ret;
+
+	test_found = 0;
+	test_iter_write();
+	ret = tracefs_iterate_raw_events(test_tep, test_instance,
+					 test_callback, NULL);
+	CU_TEST(ret == 0);
+	CU_TEST(test_found == TEST_ARRAY_SIZE);
+}
+
+static void test_iter_in_params(void)
+{
+	int ret;
+
+	ret = tracefs_iterate_raw_events(NULL, test_instance, test_callback, NULL);
+	CU_TEST(ret < 0);
+	ret = tracefs_iterate_raw_events(test_tep, NULL, test_callback, NULL);
+	CU_TEST(ret == 0);
+	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, NULL);
+	CU_TEST(ret < 0);
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
+	CU_add_test(suite, "tracefs_iterate_raw_events: Wrong input parameters",
+		    test_iter_in_params);
+	CU_add_test(suite, "tracefs_iterate_raw_events: Regular operation",
+		    test_iter_read);
+}
-- 
2.24.1

