Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F2619883C
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Oct 2024 09:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730366378; cv=none; b=SQNVsBOxDqs32ZwUeBBcJfmkfOoxmeKLyam5aj+/avgqdeBvd+ZwWQLopa6hZpH7n52o5spfpPOzKt3ip7M7zGLikp0T6JVCek5iH9SOpS7sSQ6+5Gzo4Tg7zgIv1LpplFjhsWA3JstLdbpob9iTdAUg7qznroljs7CfQPwvLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730366378; c=relaxed/simple;
	bh=gA8urw/EBPulH1iT/V3uwkBAZlwA9lUjSvnzZcBVYW0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fFcmJVDYUw7uoN9YsTDvrDRuDRKXMW8QeJSjD12qTL1i80SeuxoFE9UzzpcTUnLe0VQqQq4yks6C5rPW2vfS38k2Muk+G0RFatuyjGUewNYg0Y2rarEZFGfsVfSktQndnUw2jIB0KMmEVdHMk0+3/kMXFz3Q67YlbrMydRnLOI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 554641063;
	Thu, 31 Oct 2024 02:19:57 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 155233F66E;
	Thu, 31 Oct 2024 02:19:26 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2 RESEND] trace-cmd utest: Add test cases for trace-cmd reset
Date: Thu, 31 Oct 2024 09:19:16 +0000
Message-Id: <20241031091916.774102-1-metin.kaya@arm.com>
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

Link: https://lore.kernel.org/linux-trace-devel/20241014175905.03bec85a@gandalf.local.home

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 utest/tracecmd-utest.c | 153 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 152 insertions(+), 1 deletion(-)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 164f5da1..c18fb2ea 100644
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
@@ -598,6 +603,151 @@ static void test_trace_library_read_back(void)
 	tracecmd_close(handle);
 }
 
+static void test_trace_reset_kprobe(void)
+{
+	int ret;
+
+	/* Create a simple kprobe for do_sys_open */
+	ret = tracefs_instance_file_write(NULL, "kprobe_events", "p do_sys_open");
+	CU_TEST(ret > 0);
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
+
+	/* Create a simple kretprobe for do_sys_open */
+	ret = tracefs_instance_file_write(NULL, "kprobe_events", "r do_sys_open");
+	CU_TEST(ret > 0);
+
+	/* Ensure the kretprobe is listed in "trace-cmd stat" output. */
+	ret = grep_match("r[0-9]*:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);
+	CU_TEST(ret == 0);
+
+	/* Issue "trace-cmd reset", but keep kretprobes. */
+	ret = run_trace("reset", "-k", "kretprobe", NULL);
+	CU_TEST(ret == 0);
+
+	/* Verify the kretprobe's existence after reset. */
+	ret = grep_match("r[0-9]*:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);
+	CU_TEST(ret == 0);
+}
+
+static void test_trace_reset_uprobe(void)
+{
+	int ret;
+
+	/* Create a simple uprobe for do_sys_open */
+	ret = tracefs_instance_file_write(NULL, "uprobe_events", "p /bin/bash:0x4245c0");
+	CU_TEST(ret > 0);
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
+
+	/* Create a simple uretprobe for do_sys_open */
+	ret = tracefs_instance_file_write(NULL, "uprobe_events", "r /bin/bash:0x4245c0");
+	CU_TEST(ret > 0);
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
+	int fd;
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
+	CU_TEST(tracefs_dynevent_create(deprobe) == 0);
+
+	/* Issue "trace-cmd reset", but keep eprobes. */
+	CU_TEST(run_trace("reset", "-k", "eprobe", NULL) == 0);
+
+	/* Verify the eprobe's existence after reset. */
+	fd = tracefs_instance_file_open(NULL, "dynamic_events", O_RDONLY);
+	CU_TEST(fd != -1);
+	fp = fdopen(fd, "r");
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
+	CU_TEST(tracefs_dynevent_destroy(deprobe, false) == 0);
+
+	tracefs_dynevent_free(deprobe);
+}
+
+static void test_trace_reset(void)
+{
+	char *str;
+
+	test_trace_reset_kprobe();
+	test_trace_reset_kretprobe();
+	test_trace_reset_uprobe();
+	test_trace_reset_uretprobe();
+	test_trace_reset_eprobe();
+
+	/* Destroy all dynamic events. */
+	CU_TEST(run_trace("reset", NULL) == 0);
+
+	/* Paranoia check since "trace-cmd reset" may tell porkies. */
+	str = tracefs_instance_file_read(NULL, "dynamic_events", NULL);
+	CU_TEST(str == NULL);
+	if (str)
+		free(str);
+}
+
 static int test_suite_destroy(void)
 {
 	unlink(TRACECMD_FILE);
@@ -639,7 +789,7 @@ void test_tracecmd_lib(void)
 
 	suite = CU_add_suite(TRACECMD_SUITE, test_suite_init, test_suite_destroy);
 	if (suite == NULL) {
-		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACECMD_SUITE);
+		fprintf(stderr, "Suite \"%s\" cannot be created\n", TRACECMD_SUITE);
 		return;
 	}
 	CU_add_test(suite, "Simple record and report",
@@ -656,4 +806,5 @@ void test_tracecmd_lib(void)
 		    test_trace_library_read_back);
 	CU_add_test(suite, "Test max length",
 		    test_trace_record_max);
+	CU_add_test(suite, "Simple reset", test_trace_reset);
 }

base-commit: bbea061f69dab3a55dc5c077bf89a02f8f08cb6a
prerequisite-patch-id: 1184262dc42e059d8a66c7526f36a4a674979e5b
-- 
2.34.1

