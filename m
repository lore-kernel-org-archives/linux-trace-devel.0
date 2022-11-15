Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0010BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 20:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiKOUxf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238529AbiKOUxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 15:53:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997253136D
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 12:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B781B81B62
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E32EC433B5;
        Tue, 15 Nov 2022 20:53:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ov2wO-00ApFX-0Q;
        Tue, 15 Nov 2022 15:53:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] trace-cmd utest: Separate out the grep and pipes
Date:   Tue, 15 Nov 2022 15:53:54 -0500
Message-Id: <20221115205355.2580214-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115205355.2580214-1-rostedt@goodmis.org>
References: <20221115205355.2580214-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To make the grep and pipe functions in the unit test more flexible,
separate them out and instead of passing in the arguments and using
va_list directly, pass in a void pointer and use as structure to pass in
the arguments. This will allow for extending the grep and pipe functions
to use different type of arguments as well as functionality.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 112 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 95 insertions(+), 17 deletions(-)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 2ec3f7118690..88d7217762d2 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -10,6 +10,7 @@
 #include <time.h>
 #include <dirent.h>
 #include <unistd.h>
+#include <ctype.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/types.h>
@@ -111,9 +112,9 @@ static int run_trace(const char *cmd, ...)
 	return ret;
 }
 
-static int pipe_it(int *ofd, int *efd, const char *cmd, va_list ap)
+static int pipe_it(int *ofd, int *efd, int (*func)(void *),
+		   void *data)
 {
-	char **argv;
 	int obrass[2];
 	int ebrass[2];
 	pid_t pid;
@@ -130,9 +131,6 @@ static int pipe_it(int *ofd, int *efd, const char *cmd, va_list ap)
 		goto fail;
 
 	if (!pid) {
-		argv = get_args(cmd, ap);
-		if (!argv)
-			exit(-1);
 
 		close(obrass[0]);
 		close(STDOUT_FILENO);
@@ -144,7 +142,7 @@ static int pipe_it(int *ofd, int *efd, const char *cmd, va_list ap)
 		if (dup2(obrass[1], STDERR_FILENO) < 0)
 			exit(-1);
 
-		ret = execvp(tracecmd_exec, argv);
+		ret = func(data);
 		exit(ret);
 	}
 
@@ -165,26 +163,52 @@ static int pipe_it(int *ofd, int *efd, const char *cmd, va_list ap)
 	return -1;
 }
 
-static int grep_it(const char *match, const char *cmd, ...)
+struct do_grep {
+	const char		*cmd;
+	va_list			*ap;
+};
+
+static int do_grep(void *data)
+{
+	struct do_grep *gdata = data;
+	char **argv;
+	int ret;
+
+	argv = get_args(gdata->cmd, *gdata->ap);
+	if (!argv)
+		exit(-1);
+
+	ret = execvp(tracecmd_exec, argv);
+	tracefs_list_free(argv);
+	return ret;
+}
+
+struct do_grep_it {
+	const char		*match;
+	const char		*cmd;
+	va_list			*ap;
+};
+
+static int do_grep_it(void *data)
 {
+	struct do_grep_it *dgdata = data;
+	struct do_grep gdata;
 	FILE *fp;
 	regex_t reg;
-	va_list ap;
 	char *buf = NULL;
 	ssize_t n;
 	size_t l = 0;
-	bool found = false;
 	int ofd;
 	int efd;
 	int pid;
 	int ret;
 
-	if (regcomp(&reg, match, REG_ICASE|REG_NOSUB))
+	if (regcomp(&reg, dgdata->match, REG_ICASE|REG_NOSUB))
 		return -1;
 
-	va_start(ap, cmd);
-	pid = pipe_it(&ofd, &efd, cmd, ap);
-	va_end(ap);
+	gdata.cmd = dgdata->cmd;
+	gdata.ap = dgdata->ap;
+	pid = pipe_it(&ofd, &efd, do_grep, &gdata);
 
 	if (pid < 0) {
 		regfree(&reg);
@@ -197,10 +221,65 @@ static int grep_it(const char *match, const char *cmd, ...)
 
 	do {
 		n = getline(&buf, &l, fp);
-		if (show_output && n > 0)
-			printf("%s", buf);
 		if (n > 0 && regexec(&reg, buf, 0, NULL, 0) == 0)
+			printf("%s", buf);
+	} while (n >= 0);
+
+	free(buf);
+ out:
+	ret = wait_for_exec(pid);
+	if (fp)
+		fclose(fp);
+	else
+		perror("fp");
+	close(ofd);
+	close(efd);
+	regfree(&reg);
+
+	return ret > 0 ? 0 : ret;
+}
+
+struct do_grep_match {
+	const char		*match;
+	const char		*cmd;
+	va_list			*ap;
+};
+
+static int grep_match(const char *match, const char *cmd, ...)
+{
+	struct do_grep_it gdata;
+	FILE *fp;
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
+	va_start(ap, cmd);
+	gdata.match = match;
+	gdata.cmd = cmd;
+	gdata.ap = &ap;
+	pid = pipe_it(&ofd, &efd, do_grep_it, &gdata);
+	va_end(ap);
+
+	if (pid < 0)
+		return -1;
+
+	fp = fdopen(ofd, "r");
+	if (!fp)
+		goto out;
+
+	do {
+		n = getline(&buf, &l, fp);
+		if (n > 0) {
+			if (show_output)
+				printf("%s", buf);
 			found = true;
+		}
 	} while (n >= 0);
 
 	free(buf);
@@ -215,7 +294,6 @@ static int grep_it(const char *match, const char *cmd, ...)
 		close(ofd);
 	}
 	close(efd);
-	regfree(&reg);
 
 	return found ? 0 : 1;
 }
@@ -240,7 +318,7 @@ static void test_trace_convert6(void)
 		ret = run_trace("record", TRACECMD_OUT, "-e", "sched", "sleep", "1", NULL);
 		CU_TEST(ret == 0);
 	}
-	ret = grep_it("[ \t]6[ \t]*\\[Version\\]", "dump", TRACECMD_IN2, NULL);
+	ret = grep_match("[ \t]6[ \t]*\\[Version\\]", "dump", TRACECMD_IN2, NULL);
 	CU_TEST(ret == 0);
 }
 
-- 
2.35.1

