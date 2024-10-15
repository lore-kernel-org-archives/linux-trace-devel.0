Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B141C07F2
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 14:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729001335; cv=none; b=NDiWhJ0tHs0u94cOPW46DdoJKLFkFfpHsfoNLpXzZAfU/R/XSySHFUVI5FuBqJdd41N3XfF73BOqgyDaDi0ovtav854MR7kBA5xl4XVwuQTDVOq/t51e6bgM+7yzGrDH4OaQOr5D9nH7q1TmBT13gG1X1V7ZA3i7sUfTZfG251g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729001335; c=relaxed/simple;
	bh=f7ISDvtZtntAUcupH7kRyombLA0sP/azUHCHzUtKXsA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bTJXGvs1I42aOna0DacnlQsr4ZW8kxPGYZJU9LdCrPihfohUheyMvMrEHS+Dr9eJdrIH8/kx8E/Vo4gWZ1/68fdoiqMtq7K8wvHX9kzk2sRMB6ZbyLC0Vx3F7alX2JfTMAh2dnFNRdNvPP1BcGNIvyQVhFe9zL+TjYN6eKdB8yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B287FEC;
	Tue, 15 Oct 2024 07:09:23 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 122873F71E;
	Tue, 15 Oct 2024 07:08:52 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH] trace-cmd utest: Add test cases for trace-cmd reset
Date: Tue, 15 Oct 2024 15:08:40 +0100
Message-Id: <20241015140840.4183007-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement test cases to confirm existing dynamic event types (kprobe,
kretprobe, uprobe, uretprobe and eprobe) are really preserved during
"trace-cmd reset".

Verify synthetic events by inserting a hook to
test_trace_sqlhist_hist().

While we are in the neighborhood, fix typo "ceated".

TODO: I'm unable to prevent uprobes/uretprobes from being destroyed
during reset.

Link: https://lore.kernel.org/linux-trace-devel/20241014175905.03bec85a@gandalf.local.home

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 utest/tracecmd-utest.c | 161 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 160 insertions(+), 1 deletion(-)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 164f5da1..b2f6b65b 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -352,6 +352,11 @@ static void test_trace_sqlhist_hist(void)
 	sleep(1);
 	ret = grep_match(SYNTH_EVENT ":", "show", NULL);
 	CU_TEST(ret == 0);
+	/* Ensure synthetic events remain untouched after "trace-cmd reset -k synth". */
+	ret = run_trace("reset", "-k", "synth", NULL);
+	CU_TEST(ret == 0);
+	ret = grep_match(SYNTH_EVENT, "stat", NULL);
+	CU_TEST(ret == 0);
 
 	tracefs_instance_reset(NULL);
 }
@@ -598,6 +603,159 @@ static void test_trace_library_read_back(void)
 	tracecmd_close(handle);
 }
 
+static void test_trace_reset_kprobe(void)
+{
+	int ret;
+	FILE *fp;
+
+	/* Create a simple kprobe for do_sys_open */
+	fp = fopen("/sys/kernel/tracing/kprobe_events", "w");
+	CU_TEST(fp != NULL);
+	fprintf(fp, "p do_sys_open");
+	fclose(fp);
+
+	/* Ensure the kprobe is listed in "trace-cmd stat" output. */
+	ret = grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat", NULL);
+	CU_TEST(ret == 0);
+
+	/* Issue "trace-cmd reset", but keep kprobes. */
+	ret = run_trace("reset", "-k", "kprobe", NULL);
+	CU_TEST(ret == 0);
+
+	/* Verify the kprobe's existence after reset. */
+	ret = grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat", NULL);
+	CU_TEST(ret == 0);
+}
+
+static void test_trace_reset_kretprobe(void)
+{
+	int ret;
+	FILE *fp;
+
+	/* Create a simple kretprobe for do_sys_open */
+	fp = fopen("/sys/kernel/tracing/kprobe_events", "w");
+	CU_TEST(fp != NULL);
+	fprintf(fp, "r do_sys_open");
+	fclose(fp);
+
+	/* Ensure the kretprobe is listed in "trace-cmd stat" output. */
+	ret = grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);
+	CU_TEST(ret == 0);
+
+	/* Issue "trace-cmd reset", but keep kretprobes. */
+	ret = run_trace("reset", "-k", "kretprobe", NULL);
+	CU_TEST(ret == 0);
+
+	/* Verify the kretprobe's existence after reset. */
+	ret = grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);
+	CU_TEST(ret == 0);
+}
+
+static void test_trace_reset_uprobe(void)
+{
+	int ret;
+	FILE *fp;
+
+	/* Create a simple uprobe for do_sys_open */
+	fp = fopen("/sys/kernel/tracing/uprobe_events", "w");
+	CU_TEST(fp != NULL);
+	fprintf(fp, "p /bin/bash:0x4245c0");
+	fclose(fp);
+
+	/* Ensure the uprobe is listed in "trace-cmd stat" output. */
+	ret = grep_match("p:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
+	CU_TEST(ret == 0);
+
+	/* Issue "trace-cmd reset", but keep uprobes. */
+	ret = run_trace("reset", "-k", "uprobe", NULL);
+	CU_TEST(ret == 0);
+
+	/* Verify the uprobe's existence after reset. */
+	ret = grep_match("p:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
+	CU_TEST(ret == 0);
+}
+
+static void test_trace_reset_uretprobe(void)
+{
+	int ret;
+	FILE *fp;
+
+	/* Create a simple uretprobe for do_sys_open */
+	fp = fopen("/sys/kernel/tracing/uprobe_events", "w");
+	CU_TEST(fp != NULL);
+	fprintf(fp, "r /bin/bash:0x4245c0");
+	fclose(fp);
+
+	/* Ensure the uretprobe is listed in "trace-cmd stat" output. */
+	ret = grep_match("r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
+	CU_TEST(ret == 0);
+
+	/* Issue "trace-cmd reset", but keep uretprobes. */
+	ret = run_trace("reset", "-k", "uretprobe", NULL);
+	CU_TEST(ret == 0);
+
+	/* Verify the uretprobe's existence after reset. */
+	ret = grep_match("r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
+	CU_TEST(ret == 0);
+}
+
+static void test_trace_reset_eprobe(void)
+{
+	int ret;
+	bool matched = false;
+	size_t l = 0;
+	ssize_t n;
+	char *buf = NULL;
+	struct tracefs_dynevent *deprobe;
+	FILE *fp;
+
+	deprobe = tracefs_eprobe_alloc(NULL, "sopen_in", "syscalls", "sys_enter_openat", NULL);
+	CU_TEST(deprobe != NULL);
+
+	ret = tracefs_dynevent_create(deprobe);
+	CU_TEST(ret == 0);
+
+	/* Issue "trace-cmd reset", but keep eprobes. */
+	ret = run_trace("reset", "-k", "eprobe", NULL);
+	CU_TEST(ret == 0);
+
+	/* Verify the eprobe's existence after reset. */
+	fp = fopen("/sys/kernel/tracing/dynamic_events", "r");
+	CU_TEST(fp != NULL);
+
+	while ((n = getline(&buf, &l, fp)) != -1) {
+		if (!strcmp(buf, "e:eprobes/sopen_in syscalls.sys_enter_openat\n")) {
+			matched = true;
+			break;
+		}
+	}
+	free(buf);
+
+	fclose(fp);
+
+	CU_TEST(matched == true);
+
+	ret = tracefs_dynevent_destroy(deprobe, false);
+	CU_TEST(ret == 0);
+
+	tracefs_dynevent_free(deprobe);
+}
+
+static void test_trace_reset(void)
+{
+	int ret;
+
+	test_trace_reset_kprobe();
+	test_trace_reset_kretprobe();
+	test_trace_reset_uprobe();
+	test_trace_reset_uretprobe();
+	test_trace_reset_eprobe();
+
+	/* Destroy all dynamic events. */
+	ret = run_trace("reset", NULL);
+	CU_TEST(ret == 0);
+}
+
 static int test_suite_destroy(void)
 {
 	unlink(TRACECMD_FILE);
@@ -639,7 +797,7 @@ void test_tracecmd_lib(void)
 
 	suite = CU_add_suite(TRACECMD_SUITE, test_suite_init, test_suite_destroy);
 	if (suite == NULL) {
-		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACECMD_SUITE);
+		fprintf(stderr, "Suite \"%s\" cannot be created\n", TRACECMD_SUITE);
 		return;
 	}
 	CU_add_test(suite, "Simple record and report",
@@ -656,4 +814,5 @@ void test_tracecmd_lib(void)
 		    test_trace_library_read_back);
 	CU_add_test(suite, "Test max length",
 		    test_trace_record_max);
+	CU_add_test(suite, "Simple reset", test_trace_reset);
 }
-- 
2.34.1

