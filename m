Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E029DC4167D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241577AbhLPVkC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241636AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883FAC06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 13:40:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24754B82651
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB222C36AE2;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dT-Rv;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 05/10] libtraceevent: Add unit test framework for library commands
Date:   Thu, 16 Dec 2021 16:39:51 -0500
Message-Id: <20211216213956.13934-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the frame work to start adding CUnit test framework. This also adds
one test to test dynamic strings, but more should be added.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                 |   5 ++
 utest/Makefile           |  38 +++++++++++++
 utest/README             |  17 ++++++
 utest/trace-utest.c      |  86 +++++++++++++++++++++++++++++
 utest/trace-utest.h      |  14 +++++
 utest/traceevent-utest.c | 114 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 274 insertions(+)
 create mode 100644 utest/Makefile
 create mode 100644 utest/README
 create mode 100644 utest/trace-utest.c
 create mode 100644 utest/trace-utest.h
 create mode 100644 utest/traceevent-utest.c

diff --git a/Makefile b/Makefile
index 965eb56a8ea0..b26b0d5804ce 100644
--- a/Makefile
+++ b/Makefile
@@ -248,6 +248,11 @@ define update_dir
    fi);
 endef
 
+UTEST_DIR = utest
+
+test:	force $(LIBTRACEEVENT_STATIC)
+	$(Q)$(call descend,$(UTEST_DIR),test)
+
 VIM_TAGS = $(obj)/tags
 EMACS_TAGS = $(obj)/TAGS
 
diff --git a/utest/Makefile b/utest/Makefile
new file mode 100644
index 000000000000..160bdb434653
--- /dev/null
+++ b/utest/Makefile
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+include $(src)/scripts/utils.mk
+
+TARGETS = $(bdir)/trace-utest
+
+OBJS =
+OBJS += trace-utest.o
+OBJS += traceevent-utest.o
+
+LIBS += -lcunit				\
+	-ldl				\
+	$(LIBTRACEEVENT_STATIC)
+
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(bdir)/trace-utest: $(OBJS) $(LIBTRACEEVENT_STATIC)
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
+	$(Q)$(call do_clean,$(TARGETS) $(bdir)/*.o $(bdir)/.*.d)
diff --git a/utest/README b/utest/README
new file mode 100644
index 000000000000..87d6bd9b82dc
--- /dev/null
+++ b/utest/README
@@ -0,0 +1,17 @@
+
+Unit tests for libtraceevent library. The tests use CUnit framework:
+
+ http://cunit.sourceforge.net/
+
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
index 000000000000..1403c861e741
--- /dev/null
+++ b/utest/trace-utest.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ * Modified from libtracefs to libtraceevent:
+ *   Copyright (C) 2021, VMware, Steven Rostedt <rostedt@goodmis.org>
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
+	RUN_TRACEEVENT	= (1 << 0),
+	RUN_ALL		= 0xFFFF
+};
+
+static void print_help(char **argv)
+{
+	printf("Usage: %s [OPTIONS]\n", basename(argv[0]));
+	printf("\t-s, --silent\tPrint test summary\n");
+	printf("\t-r, --run test\tRun specific test:\n");
+	printf("\t\t  traceevent   run libtraceevent tests\n");
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
+			if (strcmp(optarg, "traceevent") == 0)
+				tests |= RUN_TRACEEVENT;
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
+	if (tests & RUN_TRACEEVENT)
+		test_traceevent_lib();
+
+	CU_basic_set_mode(verbose);
+	CU_basic_run_tests();
+	CU_cleanup_registry();
+	return 0;
+}
diff --git a/utest/trace-utest.h b/utest/trace-utest.h
new file mode 100644
index 000000000000..2aa3455e7696
--- /dev/null
+++ b/utest/trace-utest.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ * Modified from libtracefs to libtraceevent:
+ *   Copyright (C) 2021, VMware, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#ifndef _TRACE_UTEST_H_
+#define _TRACE_UTEST_H_
+
+void test_traceevent_lib(void);
+
+#endif /* _TRACE_UTEST_H_ */
diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
new file mode 100644
index 000000000000..2910b95d01e6
--- /dev/null
+++ b/utest/traceevent-utest.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ * Modified from libtracefs to libtraceevent:
+ *   Copyright (C) 2021, VMware, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <time.h>
+#include <dirent.h>
+#include <ftw.h>
+
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+
+#include "event-parse.h"
+#include "trace-seq.h"
+
+#define TRACEEVENT_SUITE	"traceevent library"
+
+#define DYN_STR_EVENT_SYSTEM		"irq"
+#define DYN_STR_FIELD			"name"
+#define DYN_STRING			"hello"
+static const char dyn_str_event[] =
+	"name: irq_handler_entry\n"
+	"ID: 1\n"
+	"format:\n"
+	"\tfield:unsigned short common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
+	"\tfield:unsigned char common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
+	"\tfield:unsigned char common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
+	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
+	"\n"
+        "\tfield:int irq;\toffset:8;\tsize:4;\tsigned:1;\n"
+        "\tfield:__data_loc char[] name;\toffset:12;\tsize:4;\tsigned:1;\n"
+	"\n"
+	"print fmt: \"irq=%d handler=%s\", REC->irq, __get_str(name)\n";
+
+static char dyn_str_data[] = {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* common type */		1, 0x00,
+#else
+	/* common type */		0x00, 1
+#endif
+	/* common flags */		0x00,
+	/* common_preempt_count */	0x00,
+	/* common_pid */		0x00, 0x00, 0x00, 0x00,
+	/* irq */			0x00, 0x00, 0x00, 0x00,
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	/* name : offset */		16, 0x00,
+	/* name : length */		6, 0x00,
+#else
+	/* name : length */		0x00, 6,
+	/* name : offset */		0x00, 16,
+#endif
+	/* name */			'h', 'e', 'l', 'l', 'o', '\0',
+	/* padding */			0x00, 0x00
+};
+static void *dyn_str_event_data = (void *)dyn_str_data;
+
+static struct tep_handle *test_tep;
+static struct trace_seq *test_seq;
+static struct trace_seq seq_storage;
+
+static void test_parse_dyn_str_event(void)
+{
+	struct tep_format_field *field;
+	struct tep_event *event;
+
+	CU_TEST(tep_parse_format(test_tep, &event,
+				 dyn_str_event, strlen(dyn_str_event),
+				DYN_STR_EVENT_SYSTEM) == TEP_ERRNO__SUCCESS);
+
+	field = tep_find_any_field(event, DYN_STR_FIELD);
+	CU_TEST(field != NULL);
+	trace_seq_reset(test_seq);
+	tep_print_field(test_seq, dyn_str_event_data, field);
+	CU_TEST(strcmp(test_seq->buffer, DYN_STRING) == 0);
+}
+
+static int test_suite_destroy(void)
+{
+	tep_free(test_tep);
+	trace_seq_destroy(test_seq);
+	return 0;
+}
+
+static int test_suite_init(void)
+{
+	test_seq = &seq_storage;
+	trace_seq_init(test_seq);
+	test_tep = tep_alloc();
+	if (!test_tep)
+		return 1;
+	return 0;
+}
+
+void test_traceevent_lib(void)
+{
+	CU_pSuite suite = NULL;
+
+	suite = CU_add_suite(TRACEEVENT_SUITE, test_suite_init, test_suite_destroy);
+	if (suite == NULL) {
+		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEEVENT_SUITE);
+		return;
+	}
+	CU_add_test(suite, "parse dynamic string event",
+		    test_parse_dyn_str_event);
+}
-- 
2.33.0

