Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CCDC43334
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jun 2022 15:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377896AbiFPPaN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 11:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377891AbiFPPaM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 11:30:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861022DAAE
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 08:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAFDD61E63
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 15:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0CEC341C0;
        Thu, 16 Jun 2022 15:30:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1rRf-002j5C-9o;
        Thu, 16 Jun 2022 11:30:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] trace-cmd test: Add test to check conversion from 7 to 6
Date:   Thu, 16 Jun 2022 11:30:01 -0400
Message-Id: <20220616153001.649858-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220616153001.649858-1-rostedt@goodmis.org>
References: <20220616153001.649858-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a unit test that tests the conversion of trace-cmd 7 to trace-cmd 6.
This also adds infrastructure to do a grep of the output of trace-cmd.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 202 +++++++++++++++++++++++++++++++++++------
 1 file changed, 176 insertions(+), 26 deletions(-)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 5e17f91c1720..7db5999e17f5 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -25,49 +25,79 @@ static char tracecmd_exec[PATH_MAX];
 
 #define TRACECMD_SUITE		"trace-cmd"
 #define TRACECMD_FILE		"__trace_test__.dat"
+#define TRACECMD_FILE2		"__trace_test__2.dat"
 #define TRACECMD_OUT		"-o", TRACECMD_FILE
+#define TRACECMD_OUT2		"-o", TRACECMD_FILE2
 #define TRACECMD_IN		"-i", TRACECMD_FILE
+#define TRACECMD_IN2		"-i", TRACECMD_FILE2
 
-static void silent_output(void)
-{
-	close(STDOUT_FILENO);
-	open("/dev/null", O_WRONLY);
-	close(STDERR_FILENO);
-	open("/dev/null", O_WRONLY);
-}
-
-static int run_trace(const char *cmd, ...)
+static char **get_args(const char *cmd, va_list ap)
 {
 	const char *param;
-	va_list ap;
-	char **tmp;
 	char **argv;
-	int status;
-	int ret = -1;
-	pid_t pid;
+	char **tmp;
 
 	argv = tracefs_list_add(NULL, tracecmd_exec);
 	if (!argv)
-		return -1;
+		return NULL;
 
 	tmp = tracefs_list_add(argv, cmd);
 	if (!tmp)
-		goto out;
+		goto fail;
 	argv = tmp;
 
-	va_start(ap, cmd);
 	for (param = va_arg(ap, const char *);
 	     param; param = va_arg(ap, const char *)) {
 		tmp = tracefs_list_add(argv, param);
 		if (!tmp)
-			goto out;
+			goto fail;
 		argv = tmp;
 	}
+
+	return argv;
+ fail:
+	tracefs_list_free(argv);
+	return NULL;
+}
+
+static void silent_output(void)
+{
+	close(STDOUT_FILENO);
+	open("/dev/null", O_WRONLY);
+	close(STDERR_FILENO);
+	open("/dev/null", O_WRONLY);
+}
+
+static int wait_for_exec(int pid)
+{
+	int status;
+	int ret;
+
+	ret = waitpid(pid, &status, 0);
+	if (ret != pid)
+		return -1;
+
+	return WEXITSTATUS(status) ? -1 : 0;
+}
+
+static int run_trace(const char *cmd, ...)
+{
+	char **argv;
+	va_list ap;
+	int ret = -1;
+	pid_t pid;
+
+	va_start(ap, cmd);
+	argv = get_args(cmd, ap);
 	va_end(ap);
 
+	if (!argv)
+		return -1;
+
 	pid = fork();
 	if (pid < 0)
 		goto out;
+
 	if (!pid) {
 		if (!show_output)
 			silent_output();
@@ -75,31 +105,149 @@ static int run_trace(const char *cmd, ...)
 		exit (ret);
 	}
 
-	ret = waitpid(pid, &status, 0);
-	if (ret != pid) {
-		ret = -1;
-		goto out;
-	}
-
-	ret = WEXIT_STATUS(status);
+	ret = wait_for_exec(pid);
  out:
 	tracefs_list_free(argv);
 	return ret;
 }
 
+static int pipe_it(int *ofd, int *efd, const char *cmd, va_list ap)
+{
+	char **argv;
+	int obrass[2];
+	int ebrass[2];
+	pid_t pid;
+	int ret;
+
+	if (pipe(obrass) < 0)
+		return -1;
+
+	if (pipe(ebrass) < 0)
+		goto fail_out;
+
+	pid = fork();
+	if (pid < 0)
+		goto fail;
+
+	if (!pid) {
+		argv = get_args(cmd, ap);
+		if (!argv)
+			exit(-1);
+
+		close(obrass[0]);
+		close(STDOUT_FILENO);
+		if (dup2(obrass[1], STDOUT_FILENO) < 0)
+			exit(-1);
+
+		close(ebrass[0]);
+		close(STDERR_FILENO);
+		if (dup2(obrass[1], STDERR_FILENO) < 0)
+			exit(-1);
+
+		ret = execvp(tracecmd_exec, argv);
+		exit(ret);
+	}
+
+	close(obrass[1]);
+	close(ebrass[1]);
+
+	*ofd = obrass[0];
+	*efd = ebrass[0];
+
+	return pid;
+
+ fail:
+	close(ebrass[0]);
+	close(ebrass[1]);
+ fail_out:
+	close(obrass[0]);
+	close(obrass[1]);
+	return -1;
+}
+
+static int grep_it(const char *match, const char *cmd, ...)
+{
+	FILE *fp;
+	regex_t reg;
+	va_list ap;
+	char *buf = NULL;
+	ssize_t n;
+	size_t l = 0;
+	bool found = false;
+	int ofd;
+	int efd;
+	int pid;
+	int ret;
+
+	if (regcomp(&reg, match, REG_ICASE|REG_NOSUB))
+		return -1;
+
+	va_start(ap, cmd);
+	pid = pipe_it(&ofd, &efd, cmd, ap);
+	va_end(ap);
+
+	if (pid < 0) {
+		regfree(&reg);
+		return -1;
+	}
+
+	fp = fdopen(ofd, "r");
+	if (!fp)
+		goto out;
+
+	do {
+		n = getline(&buf, &l, fp);
+		if (show_output && n > 0)
+			printf("%s", buf);
+		if (n > 0 && regexec(&reg, buf, 0, NULL, 0) == 0)
+			found = true;
+	} while (n >= 0);
+
+	free(buf);
+ out:
+	ret = wait_for_exec(pid);
+	if (ret)
+		n = 1;
+	if (fp)
+		fclose(fp);
+	else {
+		perror("fp");
+		close(ofd);
+	}
+	close(efd);
+	regfree(&reg);
+
+	return found ? 0 : 1;
+}
+
 static void test_trace_record_report(void)
 {
 	int ret;
 
 	ret = run_trace("record", TRACECMD_OUT, "-e", "sched", "sleep", "1", NULL);
 	CU_TEST(ret == 0);
-	ret = run_trace("report", TRACECMD_IN, NULL);
+	ret = run_trace("convert", "--file-version", "6", TRACECMD_IN, TRACECMD_OUT2, NULL);
+	CU_TEST(ret == 0);
+}
+
+static void test_trace_convert6(void)
+{
+	struct stat st;
+	int ret;
+
+	/* If the trace data is already created, just use it, otherwise make it again */
+	if (stat(TRACECMD_FILE, &st) < 0) {
+		ret = run_trace("record", TRACECMD_OUT, "-e", "sched", "sleep", "1", NULL);
+		CU_TEST(ret == 0);
+	}
+	ret = grep_it("[ \t]6[ \t]*\\[Version\\]", "dump", TRACECMD_IN2, NULL);
 	CU_TEST(ret == 0);
 }
 
 static int test_suite_destroy(void)
 {
 	unlink(TRACECMD_FILE);
+	unlink(TRACECMD_FILE2);
 	return 0;
 }
 
@@ -142,4 +290,6 @@ void test_tracecmd_lib(void)
 	}
 	CU_add_test(suite, "Simple record and report",
 		    test_trace_record_report);
+	CU_add_test(suite, "Test convert from v7 to v6",
+		    test_trace_convert6);
 }
-- 
2.35.1

