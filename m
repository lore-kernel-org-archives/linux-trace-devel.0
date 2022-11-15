Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEEBC43217
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 20:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238597AbiKOUxd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbiKOUxP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 15:53:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F4831362
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 12:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A25EF61987
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140A2C43470;
        Tue, 15 Nov 2022 20:53:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ov2wO-00ApFd-0U;
        Tue, 15 Nov 2022 15:53:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] trace-cmd: Add test for max size option of record
Date:   Tue, 15 Nov 2022 15:53:55 -0500
Message-Id: <20221115205355.2580214-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115205355.2580214-1-rostedt@goodmis.org>
References: <20221115205355.2580214-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a unit test to test the trace-cmd record -m X option.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 88d7217762d2..c72684ad53fc 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -308,6 +308,76 @@ static void test_trace_record_report(void)
 	CU_TEST(ret == 0);
 }
 
+static int read_stats(const char *out, const char *match, const char *cmd, ...)
+{
+	struct do_grep_it gdata;
+	FILE *fp;
+	va_list ap;
+	bool found = false;
+	char *buf = NULL;
+	char *p;
+	ssize_t n;
+	size_t l = 0;
+	int ofd;
+	int efd;
+	int pid;
+	int ret;
+	int val;
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
+			for (p = buf; isspace(*p); p++)
+				;
+			val = atoi(p);
+			found = true;
+			if (show_output)
+				printf("%s", buf);
+			CU_TEST(val < 10000000);
+		}
+	} while (n >= 0);
+
+	free(buf);
+ out:
+	ret = wait_for_exec(pid);
+	if (fp)
+		fclose(fp);
+	else {
+		perror("fp");
+	}
+	if (!found)
+		ret = -1;
+	close(ofd);
+	close(efd);
+	return ret > 0 ? 0 : ret;
+}
+
+static void test_trace_record_max(void)
+{
+	int ret;
+
+	ret = run_trace("record", TRACECMD_OUT, "-p", "function", "-m", "5000",
+			"sleep", "10", NULL);
+	CU_TEST(ret == 0);
+
+	ret = read_stats(TRACECMD_FILE, ".*bytes in size.*", "report", "--stat", NULL);
+	CU_TEST(ret == 0);
+}
+
 static void test_trace_convert6(void)
 {
 	struct stat st;
@@ -422,4 +492,6 @@ void test_tracecmd_lib(void)
 		    test_trace_convert6);
 	CU_add_test(suite, "Use libraries to read file",
 		    test_trace_library_read);
+	CU_add_test(suite, "Test max length",
+		    test_trace_record_max);
 }
-- 
2.35.1

