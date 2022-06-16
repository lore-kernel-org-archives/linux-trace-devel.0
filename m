Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9065FCCA47E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jun 2022 15:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377891AbiFPPaN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 11:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238245AbiFPPaN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 11:30:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBA32E9CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 08:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1CA4ACE25C5
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 15:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D16C3411A;
        Thu, 16 Jun 2022 15:30:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1rRf-002j59-9E;
        Thu, 16 Jun 2022 11:30:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] trace-cmd test: Add simple record/report test
Date:   Thu, 16 Jun 2022 11:30:00 -0400
Message-Id: <20220616153001.649858-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220616153001.649858-1-rostedt@goodmis.org>
References: <20220616153001.649858-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a simple test that does a trace-cmd record of schedule events and then
reads it with trace-cmd report. This also adds some infrastructure to make
it easy to run trace-cmd commands.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/trace-utest.c    |  7 +++-
 utest/trace-utest.h    |  3 ++
 utest/tracecmd-utest.c | 76 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 802765a77673..051a0285fcc5 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -14,6 +14,7 @@
 #include "trace-utest.h"
 
 const char *argv0;
+bool show_output;
 
 enum unit_tests {
 	RUN_NONE	= 0,
@@ -41,10 +42,11 @@ int main(int argc, char **argv)
 	for (;;) {
 		int c;
 		int index = 0;
-		const char *opts = "+hsr:";
+		const char *opts = "+hsr:v";
 		static struct option long_options[] = {
 			{"silent", no_argument, NULL, 's'},
 			{"run", required_argument, NULL, 'r'},
+			{"verbose", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, 'h'},
 			{NULL, 0, NULL, 0}
 		};
@@ -62,6 +64,9 @@ int main(int argc, char **argv)
 		case 's':
 			verbose = CU_BRM_SILENT;
 			break;
+		case 'v':
+			show_output = true;
+			break;
 		case 'h':
 		default:
 			print_help(argv);
diff --git a/utest/trace-utest.h b/utest/trace-utest.h
index a9e365f8dcb5..b57e6469f4db 100644
--- a/utest/trace-utest.h
+++ b/utest/trace-utest.h
@@ -6,7 +6,10 @@
 #ifndef _TRACE_UTEST_H_
 #define _TRACE_UTEST_H_
 
+#include <stdbool.h>
+
 extern const char *argv0;
+extern bool show_output;
 
 void test_tracecmd_lib(void);
 
diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index d85d9a21d20b..5e17f91c1720 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -5,27 +5,101 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
-#include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <time.h>
 #include <dirent.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <sys/types.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 
+#include <tracefs.h>
+
 #include "trace-utest.h"
 
 static char tracecmd_exec[PATH_MAX];
 
 #define TRACECMD_SUITE		"trace-cmd"
+#define TRACECMD_FILE		"__trace_test__.dat"
+#define TRACECMD_OUT		"-o", TRACECMD_FILE
+#define TRACECMD_IN		"-i", TRACECMD_FILE
+
+static void silent_output(void)
+{
+	close(STDOUT_FILENO);
+	open("/dev/null", O_WRONLY);
+	close(STDERR_FILENO);
+	open("/dev/null", O_WRONLY);
+}
+
+static int run_trace(const char *cmd, ...)
+{
+	const char *param;
+	va_list ap;
+	char **tmp;
+	char **argv;
+	int status;
+	int ret = -1;
+	pid_t pid;
+
+	argv = tracefs_list_add(NULL, tracecmd_exec);
+	if (!argv)
+		return -1;
+
+	tmp = tracefs_list_add(argv, cmd);
+	if (!tmp)
+		goto out;
+	argv = tmp;
+
+	va_start(ap, cmd);
+	for (param = va_arg(ap, const char *);
+	     param; param = va_arg(ap, const char *)) {
+		tmp = tracefs_list_add(argv, param);
+		if (!tmp)
+			goto out;
+		argv = tmp;
+	}
+	va_end(ap);
+
+	pid = fork();
+	if (pid < 0)
+		goto out;
+	if (!pid) {
+		if (!show_output)
+			silent_output();
+		ret = execvp(tracecmd_exec, argv);
+		exit (ret);
+	}
+
+	ret = waitpid(pid, &status, 0);
+	if (ret != pid) {
+		ret = -1;
+		goto out;
+	}
+
+	ret = WEXIT_STATUS(status);
+ out:
+	tracefs_list_free(argv);
+	return ret;
+}
 
 static void test_trace_record_report(void)
 {
+	int ret;
+
+	ret = run_trace("record", TRACECMD_OUT, "-e", "sched", "sleep", "1", NULL);
+	CU_TEST(ret == 0);
+	ret = run_trace("report", TRACECMD_IN, NULL);
+	CU_TEST(ret == 0);
 }
 
 static int test_suite_destroy(void)
 {
+	unlink(TRACECMD_FILE);
 	return 0;
 }
 
-- 
2.35.1

