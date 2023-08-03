Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34D8C00528
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 22:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjHCWyh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 18:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjHCWyg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 18:54:36 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414DCAC
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Aug 2023 15:54:35 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-38c35975545so1175305b6e.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Aug 2023 15:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691103274; x=1691708074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vafMKoxveaGI3b5CsStxUzyDJFAHvZwNyXkCDX0QgnI=;
        b=IZtdekqjAsOqSo2wWLB3mXgJHx6xkmklyureede6kkaGZKqca2PWYgJUQCO8T9QXaL
         e9p87wcZzIDQVC55zlJtW7vvle82awKlvZ7AISLYLvbBmQpC+3OMsDnxkK67/bfjSTmo
         dvCYaniIx2gNtVMTYqxruLDEPGspoMrssvUoO6O7neDXpKzApj4ZNcnxFAAj3FnsmMUB
         s4NpeLVKzScy0Y0JXR4CX1NGq1sYAgG/5pPTwyHH/9+G0B3UPEvlDKw4uAO6ccXdvWMh
         3Yn+zx73EiPZMUxYZjZ780a8Al55QkxkiRS6KW0qNf4RTCbAMEo8OtnhuB1gtDd/Hl9V
         Qh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691103274; x=1691708074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vafMKoxveaGI3b5CsStxUzyDJFAHvZwNyXkCDX0QgnI=;
        b=B+EnwHPH+TTK+qPwxcm8Q7cbzhcgOddzlCsb8Qswh6A6DkduzSAKNgpBBJWaqMnDSr
         C/E58is21M6jDtysj9UCfV39pf8FlyE2P5LlHO1HHAv8nZFmR28E0l65ehmlbnPqT5wl
         pmvXjUm1Z6xruW/yAP/kVDwqnoA9sjdQWq2uTBVhQL87Pub/5VEOz5G2t3YHbYvrTS3l
         RyvvjUuCHn8mlJ3pJsVFpVbsUUg2L9sBMEdIvfymwptLNVuSMk/jaKxzCxjYr2Qsm544
         C2QJkTlOON33qMPjLtu6TSWYpkjLYgc4XHMFIngxhK553ozRZGDH/EeUOh1B5SIe9dP3
         B9YA==
X-Gm-Message-State: ABy/qLYpcyBMXQ/UgDRn04bi5jEvH2VPN4unrxwujDxtL2XGWGLn/QL2
        P9qf4FRwHR3GQU35/OE9q8vo2pP72R1Fvg==
X-Google-Smtp-Source: APBJJlFKPC+KNQ6x2VxuudoejrG36q7A4l5EkyN9Xn5yEke0tCPb8hCDTIGuoJ9qb7qvz9+0xlNuog==
X-Received: by 2002:a05:6808:1493:b0:3a7:4fa4:edfe with SMTP id e19-20020a056808149300b003a74fa4edfemr10494537oiw.54.1691103274172;
        Thu, 03 Aug 2023 15:54:34 -0700 (PDT)
Received: from 3xKetch.lan ([2601:600:a17f:b422::ffc])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090a4b4e00b00268b439a0cbsm351120pjl.23.2023.08.03.15.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 15:54:33 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2 5/5] histograms: Initial unit tests
Date:   Thu,  3 Aug 2023 18:54:03 -0400
Message-ID: <20230803225413.40697-6-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803225413.40697-1-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

Add unit tests for traceeval_init(), traceeval_release(), and
traceeval_compare() to check edge cases and ensure the interface is
functional.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-test.h |   1 -
 utest/.gitignore         |   1 +
 utest/Makefile           |  35 +++++++
 utest/eval-test.h        |  13 +++
 utest/eval-utest.c       |  28 +++++
 utest/traceeval-utest.c  | 217 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 294 insertions(+), 1 deletion(-)
 create mode 100644 utest/.gitignore
 create mode 100644 utest/Makefile
 create mode 100644 utest/eval-test.h
 create mode 100644 utest/eval-utest.c
 create mode 100644 utest/traceeval-utest.c

diff --git a/include/traceeval-test.h b/include/traceeval-test.h
index bb8092a..45cf13b 100644
--- a/include/traceeval-test.h
+++ b/include/traceeval-test.h
@@ -2,7 +2,6 @@
 /*
  * libtraceeval interface for unit testing.
  *
- * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
  * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
  */
 
diff --git a/utest/.gitignore b/utest/.gitignore
new file mode 100644
index 0000000..ca0ac10
--- /dev/null
+++ b/utest/.gitignore
@@ -0,0 +1 @@
+eval-utest
diff --git a/utest/Makefile b/utest/Makefile
new file mode 100644
index 0000000..955f91e
--- /dev/null
+++ b/utest/Makefile
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: MIT
+
+include $(src)/scripts/utils.mk
+
+bdir := $(obj)/utest
+eval_lib := $(obj)/lib/libtraceeval.a
+
+TARGETS = $(bdir)/eval-utest
+
+OBJS := eval-utest.o
+OBJS += traceeval-utest.o
+
+LIBS += -lcunit				\
+	-ldl				\
+	$(eval_lib)
+
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(OBJS): | $(bdir)
+
+$(bdir)/eval-utest: $(OBJS) $(eval_lib)
+	$(Q)$(do_app_build)
+
+$(bdir)/%.o: %.c
+	$(Q)$(call do_fpic_compile)
+
+-include .*.d
+
+test: $(TARGETS)
+
+clean:
+	$(Q)$(call do_clean,$(TARGETS) $(bdir)/*.o $(bdir)/.*.d)
diff --git a/utest/eval-test.h b/utest/eval-test.h
new file mode 100644
index 0000000..f6e594e
--- /dev/null
+++ b/utest/eval-test.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * libtraceeval cunit interface.
+ *
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ */
+
+#ifndef _EVAL_UTEST_H_
+#define _EVAL_UTEST_H_
+
+void test_traceeval_lib(void);
+
+#endif /* _EVAL_UTEST_H_ */
diff --git a/utest/eval-utest.c b/utest/eval-utest.c
new file mode 100644
index 0000000..94d04c6
--- /dev/null
+++ b/utest/eval-utest.c
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * libtraceeval cunit handler.
+ *
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+
+#include "eval-test.h"
+
+int main(int argc, char **argv)
+{
+	if (CU_initialize_registry() != CUE_SUCCESS) {
+		printf("Test registry cannot be initialized\n");
+		return EXIT_FAILURE;
+	}
+
+	test_traceeval_lib();
+
+	CU_basic_set_mode(CU_BRM_VERBOSE);
+	CU_basic_run_tests();
+	CU_cleanup_registry();
+	return EXIT_SUCCESS;
+}
diff --git a/utest/traceeval-utest.c b/utest/traceeval-utest.c
new file mode 100644
index 0000000..de23821
--- /dev/null
+++ b/utest/traceeval-utest.c
@@ -0,0 +1,217 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ */
+
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+#include <stdbool.h>
+#include <string.h>
+#include <stdio.h>
+
+#include <traceeval-hist.h>
+#include <traceeval-test.h>
+
+#define TRACEEVAL_SUITE		"traceeval library"
+#define TRACEEVAL_SUCCESS	0
+#define TRACEEVAL_FAILURE	-1
+#define TRACEEVAL_NOT_SAME	1
+
+/*
+ * Test traceeval_init(), traceeval_release(), and traceeval_compare() with
+ * NULL values.
+ */
+static void test_eval_null(void)
+{
+	/* set up */
+	const struct traceeval_type test_data[] =  {
+		{
+			.type = TRACEEVAL_TYPE_NUMBER,
+			.name = "test null"
+		},
+		{
+			.type = TRACEEVAL_TYPE_NONE,
+			.name = NULL
+		}
+	};
+
+	/* test init */
+	struct traceeval *result_null = traceeval_init(NULL, NULL);
+	struct traceeval *result_key = traceeval_init(test_data, NULL);
+	struct traceeval *result_val = traceeval_init(NULL, test_data);
+
+	/* analyze init */
+	CU_ASSERT(!result_null);
+	CU_ASSERT(result_key != NULL);
+	CU_ASSERT(!result_val);
+
+	/* release */
+	traceeval_release(NULL);
+	traceeval_release(result_key);
+}
+
+/*
+ * Use provided data to test traceeval_init(), traceeval_compare(), and
+ * traceeval_release().
+ */
+static void test_eval_base(const struct traceeval_type *keys1,
+		const struct traceeval_type *vals1,
+		const struct traceeval_type *keys2,
+		const struct traceeval_type *vals2,
+		bool init_not_null1, bool init_not_null2,
+		int compare_result)
+{
+	struct traceeval *init1;
+	struct traceeval *init2;
+	int result;
+
+	/* test init */
+	init1 = traceeval_init(keys1, vals1);
+	init2 = traceeval_init(keys2, vals2);
+
+	result = init1 != NULL;
+	if (init_not_null1) {
+		CU_ASSERT(result);
+	} else {
+		CU_ASSERT(!result);
+	}
+
+	result = init2 != NULL;
+	if (init_not_null2) {
+		CU_ASSERT(result);
+	} else {
+		CU_ASSERT(!result);
+	}
+
+	/* test compare */
+	result = traceeval_compare(init1, init2);
+
+	/* analyze compare */
+	CU_ASSERT(result == compare_result);
+
+	/* release */
+	traceeval_release(init1);
+	traceeval_release(init2);
+}
+
+/*
+ * Test traceeval_init(), traceeval_release(), and traceeval_compare() with
+ * TRACEEVAL_TYPE_NONE.
+ */
+static void test_eval_none(void)
+{
+	/* set up */
+	const struct traceeval_type test_data_none[] =  {
+		{
+			.type = TRACEEVAL_TYPE_NONE,
+			.name = "test none"
+		}
+	};
+	const struct traceeval_type test_data_some[] =  {
+		{
+			.type = TRACEEVAL_TYPE_NUMBER,
+			.name = "test none (some)"
+		},
+		{
+			.type = TRACEEVAL_TYPE_NONE,
+			.name = NULL
+		}
+	};
+
+	test_eval_base(test_data_some, test_data_none, test_data_some,
+			test_data_none, true, true, TRACEEVAL_SUCCESS);
+	test_eval_base(test_data_none, test_data_none, test_data_some,
+			test_data_none, false, true, TRACEEVAL_FAILURE);
+	test_eval_base(test_data_none, test_data_none, test_data_none,
+			test_data_none, false, false, TRACEEVAL_FAILURE);
+}
+
+/*
+ * Test traceeval_init() and traceeval_release() with equivalent values.
+ */
+static void test_eval_same(void)
+{
+	/* set up */
+	const struct traceeval_type test_data[] =  {
+		{
+			.type = TRACEEVAL_TYPE_NUMBER,
+			.name = "test data"
+		},
+		{
+			.type = TRACEEVAL_TYPE_NONE,
+			.name = NULL
+		}
+	};
+
+	test_eval_base(test_data, test_data, test_data, test_data, true, true,
+			TRACEEVAL_SUCCESS);
+}
+
+/*
+ * Test traceeval_init() and traceeval_release() with non-equivalent values.
+ */
+static void test_eval_not_same(void)
+{
+	const struct traceeval_type test_data1[] =  {
+		{
+			.type = TRACEEVAL_TYPE_NUMBER,
+			.name = "test data 1"
+		},
+		{
+			.type = TRACEEVAL_TYPE_NONE,
+			.name = NULL
+		}
+	};
+	const struct traceeval_type test_data2[] =  {
+		{
+			.type = TRACEEVAL_TYPE_NUMBER,
+			.name = "test data 2"
+		},
+		{
+			.type = TRACEEVAL_TYPE_NONE,
+			.name = NULL
+		}
+	};
+
+	/* type 1 key diff */
+	test_eval_base(test_data2, test_data1, test_data1, test_data1, true,
+			true, TRACEEVAL_NOT_SAME);
+	/* type 1 data diff */
+	test_eval_base(test_data1, test_data2, test_data1, test_data1, true,
+			true, TRACEEVAL_NOT_SAME);
+	/* type 2 key diff */
+	test_eval_base(test_data1, test_data1, test_data2, test_data1, true,
+			true, TRACEEVAL_NOT_SAME);
+	/* type 2 data diff */
+	test_eval_base(test_data1, test_data1, test_data1, test_data2, true,
+			true, TRACEEVAL_NOT_SAME);
+}
+
+/*
+ * Tests the traceeval_init() and traceeval_release() functions.
+ */
+static void test_eval(void)
+{
+	test_eval_null();
+	test_eval_none();
+	test_eval_same();
+	test_eval_not_same();
+}
+
+/*
+ * Register tests with CUnit.
+ */
+void test_traceeval_lib(void)
+{
+	CU_pSuite suite = NULL;
+
+	/* set up suite */
+	suite = CU_add_suite(TRACEEVAL_SUITE, NULL, NULL);
+	if (suite == NULL) {
+		fprintf(stderr, "Suite %s cannot be created\n", TRACEEVAL_SUITE);
+		return;
+	}
+
+	/* add tests to suite */
+	CU_add_test(suite, "Test traceeval alloc and release", test_eval);
+}
-- 
2.41.0

