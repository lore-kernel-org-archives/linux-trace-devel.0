Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E20C1B0F3B
	for <linux-trace-devel@vger.kernel.org>; Wed, 16 Oct 2024 09:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729070263; cv=none; b=Xeb3GRtD2QyXnbcWsQWU6LzUCgIg8a0/HYgeN2YataSle4Xknhm70SOaKmQMGSvlJp/RG0yOac/dxwc3W86gNAolaSRV3ZTdOXpKlPr+wk9xK7Qevkx9+pH7a2yTVjg4zoXpEmU2MZj5pJLAdI2QT8BlrUbO6Fe1YpWll02dnQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729070263; c=relaxed/simple;
	bh=IowBQVhzjIou2oiG5SKoK9FFpBXrJrr7r00GeqENfmg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lSRY9u/wEG/URVQKycUd7RHrks3cPknLSPYhrNzjyDLiCU8qlX0MrkpfLJbREfyb5f6ULXQMz08K4aD2k4lfq1dGMFBXqj++FRWl9Z5tCH1U7YSjAHVnJzNgxHBKSICu2/hZr9k33qDBPiHyja87UN7JflpxvXqF+l/Ws/F9mPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F382FEC;
	Wed, 16 Oct 2024 02:18:09 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F1C003F528;
	Wed, 16 Oct 2024 02:17:38 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2] trace-cmd utest: Add test cases for trace-cmd reset
Date: Wed, 16 Oct 2024 10:17:31 +0100
Message-Id: <20241016091731.102563-1-metin.kaya@arm.com>
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

Changes in v2:
- Fixup grep command to find matching uretprobe.
- Use tracefs_instance_file_write() / tracefs_instance_file_open()
  instead of open-coded implementation.
- Ensure no dynamic event left after "trace-cmd reset".

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
-- 
2.34.1

