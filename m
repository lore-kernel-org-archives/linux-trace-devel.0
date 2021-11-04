Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CCEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99CE66121E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhKDRHS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:07:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54228 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbhKDRHR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 13:07:17 -0400
Received: from localhost.localdomain (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id C041620B9D58;
        Thu,  4 Nov 2021 10:04:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C041620B9D58
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636045478;
        bh=789jl+QGMQBpXWY5o38+tUwH8DHZM/HvbTsYAqssul4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRuI3gsyfIcqS46pSOKlXOsEGLm82br3b1Qa2LGs+KLz5Ru7hHvaqGC2DDMBGvWeg
         LdIENb8EgquvArxLQc4gvTsV2mLXBK3Z9mouVZpxpsyU58rqfOsVRv64rc141AqntE
         kUK2b083Hqp7tZfwTUCorsu44XD1FxPyptPtwIhM=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: [PATCH v4 07/10] user_events: Add self-test for dynamic_events integration
Date:   Thu,  4 Nov 2021 10:04:30 -0700
Message-Id: <20211104170433.2206-8-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211104170433.2206-1-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Tests matching deletes, creation of basic and complex types. Ensures
common patterns work correctly when interacting with dynamic_events
file.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 tools/testing/selftests/user_events/Makefile  |   2 +-
 .../testing/selftests/user_events/dyn_test.c  | 122 ++++++++++++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/user_events/dyn_test.c

diff --git a/tools/testing/selftests/user_events/Makefile b/tools/testing/selftests/user_events/Makefile
index d66c551a6fe3..e824b9c2cae7 100644
--- a/tools/testing/selftests/user_events/Makefile
+++ b/tools/testing/selftests/user_events/Makefile
@@ -2,7 +2,7 @@
 CFLAGS += -Wl,-no-as-needed -Wall -I../../../../usr/include
 LDLIBS += -lrt -lpthread -lm
 
-TEST_GEN_PROGS = ftrace_test
+TEST_GEN_PROGS = ftrace_test dyn_test
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/user_events/dyn_test.c b/tools/testing/selftests/user_events/dyn_test.c
new file mode 100644
index 000000000000..b06c1b79a6a2
--- /dev/null
+++ b/tools/testing/selftests/user_events/dyn_test.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * User Events Dyn Events Test Program
+ *
+ * Copyright (c) 2021 Beau Belgrave <beaub@linux.microsoft.com>
+ */
+
+#include <errno.h>
+#include <linux/user_events.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+const char *dyn_file = "/sys/kernel/debug/tracing/dynamic_events";
+const char *clear = "!u:__test_event";
+
+static int Append(const char *value)
+{
+	int fd = open(dyn_file, O_RDWR | O_APPEND);
+	int ret = write(fd, value, strlen(value));
+
+	close(fd);
+	return ret;
+}
+
+#define CLEAR() \
+do { \
+	int ret = Append(clear); \
+	if (ret == -1) \
+		ASSERT_EQ(ENOENT, errno); \
+} while (0)
+
+#define TEST_PARSE(x) \
+do { \
+	ASSERT_NE(-1, Append(x)); \
+	CLEAR(); \
+} while (0)
+
+#define TEST_NPARSE(x) ASSERT_EQ(-1, Append(x))
+
+FIXTURE(user) {
+};
+
+FIXTURE_SETUP(user) {
+	CLEAR();
+}
+
+FIXTURE_TEARDOWN(user) {
+	CLEAR();
+}
+
+TEST_F(user, basic_types) {
+	/* All should work */
+	TEST_PARSE("u:__test_event u64 a");
+	TEST_PARSE("u:__test_event u32 a");
+	TEST_PARSE("u:__test_event u16 a");
+	TEST_PARSE("u:__test_event u8 a");
+	TEST_PARSE("u:__test_event char a");
+	TEST_PARSE("u:__test_event unsigned char a");
+	TEST_PARSE("u:__test_event int a");
+	TEST_PARSE("u:__test_event unsigned int a");
+	TEST_PARSE("u:__test_event short a");
+	TEST_PARSE("u:__test_event unsigned short a");
+	TEST_PARSE("u:__test_event char[20] a");
+	TEST_PARSE("u:__test_event unsigned char[20] a");
+}
+
+TEST_F(user, loc_types) {
+	/* All should work */
+	TEST_PARSE("u:__test_event __data_loc char[] a");
+	TEST_PARSE("u:__test_event __data_loc unsigned char[] a");
+	TEST_PARSE("u:__test_event __rel_loc char[] a");
+	TEST_PARSE("u:__test_event __rel_loc unsigned char[] a");
+}
+
+TEST_F(user, size_types) {
+	/* Should work */
+	TEST_PARSE("u:__test_event struct custom a 20");
+	/* Size not specified on struct should fail */
+	TEST_NPARSE("u:__test_event struct custom a");
+	/* Size specified on non-struct should fail */
+	TEST_NPARSE("u:__test_event char a 20");
+}
+
+TEST_F(user, flags) {
+	/* Should work */
+	TEST_PARSE("u:__test_event:FLAG_BPF_ITER u32 a");
+	/* Forward compat */
+	TEST_PARSE("u:__test_event:FLAG_BPF_ITER,FLAG_FUTURE u32 a");
+}
+
+TEST_F(user, matching) {
+	/* Register */
+	ASSERT_NE(-1, Append("u:__test_event struct custom a 20"));
+	/* Should not match */
+	TEST_NPARSE("!u:__test_event struct custom b");
+	/* Should match */
+	TEST_PARSE("!u:__test_event struct custom a");
+	/* Multi field reg */
+	ASSERT_NE(-1, Append("u:__test_event u32 a; u32 b"));
+	/* Non matching cases */
+	TEST_NPARSE("!u:__test_event u32 a");
+	TEST_NPARSE("!u:__test_event u32 b");
+	TEST_NPARSE("!u:__test_event u32 a; u32 ");
+	TEST_NPARSE("!u:__test_event u32 a; u32 a");
+	/* Matching case */
+	TEST_PARSE("!u:__test_event u32 a; u32 b");
+	/* Register */
+	ASSERT_NE(-1, Append("u:__test_event u32 a; u32 b"));
+	/* Ensure trailing semi-colon case */
+	TEST_PARSE("!u:__test_event u32 a; u32 b;");
+}
+
+int main(int argc, char **argv)
+{
+	return test_harness_run(argc, argv);
+}
-- 
2.17.1

