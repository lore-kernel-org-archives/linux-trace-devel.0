Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58564227BAF
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729195546; cv=none; b=aRe68yAAY99BSNYmNTzPQrvl6K5W+gLxt5fptyXjEWgGs0hs/fXVvBD1yzVDlkij54bCEKQzbqEvlBOYQADehcio9bSnDIyjNi2vuHrW1ydnlu9p/eSTmmXTL4y3xaiP99v2sNNRslyx6U389im2/BtzJpg62/m67F8kedphJHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729195546; c=relaxed/simple;
	bh=23HROOojmsVm7HvD6MPx9GzVRfwFWRS5ZFpf+J9zznE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhfHgISkO3gnHf+qKvkd0/LskhOXqvsJGY/75JNhzEuzBgM/t3O1tBf7i8a4HoTUxrYBHx4zd2lQ4lh9oOOw8e/+6zxxBaKV7lqecTEhanxP3A6+h22xVTOmejM/tqPhNJXgHX9BiTTIC7t7YF7DsSn23s0mjSbfJxgbWw0JV6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0493AC4CED6;
	Thu, 17 Oct 2024 20:05:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t1Wl8-00000003uh8-27eO;
	Thu, 17 Oct 2024 16:06:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs utest: Add test to check handling multiple dynamic events
Date: Thu, 17 Oct 2024 16:03:22 -0400
Message-ID: <20241017200609.932728-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241017200609.932728-1-rostedt@goodmis.org>
References: <20241017200609.932728-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a new "mutli probes" test that will create kprobes, kretprobes,
uprobes, uretprobes, eprobes and synthetic events and make sure that the
counters of those events are working properly.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 162 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 5bfd665b9990..742f4546bef0 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2574,6 +2574,167 @@ static void test_uprobes(void)
 	test_uprobes_instance(test_instance);
 }
 
+static void test_multi_probes_instance(struct tracefs_instance *instance)
+{
+	struct probe_test tests[] = {
+		{ TRACEFS_DYNEVENT_UPROBE, "p", "utest", "utest_u", NULL, "arg1=$stack2" },
+		{ TRACEFS_DYNEVENT_URETPROBE, "r", "utest", "utest_r", NULL, "arg1=$retval" },
+		{ TRACEFS_DYNEVENT_EPROBE, "e", NULL, "sopen_in", "syscalls.sys_enter_openat",
+					   "file=+0($filename):ustring" },
+		{ TRACEFS_DYNEVENT_EPROBE, "e", "etest", "sopen_out", "syscalls.sys_exit_openat",
+					   "res=$ret:u64" },
+		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "mkdir", "do_mkdirat", "path=+u0($arg2):ustring" },
+		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "close", "close_fd", NULL },
+		{ TRACEFS_DYNEVENT_KPROBE, "p", "ptest", "open2", "do_sys_openat2",
+				  "file=+u0($arg2):ustring flags=+0($arg3):x64" },
+		{ TRACEFS_DYNEVENT_KRETPROBE, NULL, NULL, "retopen", "do_sys_openat2", "ret=$retval" },
+		{ TRACEFS_DYNEVENT_KRETPROBE, NULL, NULL, NULL, "do_sys_open", "ret=$retval" },
+	};
+	struct test_synth sevents[] = {
+		{"synth_1", "sched", "sched_waking", "sched", "sched_switch", "pid", "next_pid", "pid_match"},
+		{"synth_2", "syscalls", "sys_enter_openat2", "syscalls", "sys_exit_openat2", "__syscall_nr", "__syscall_nr", "nr_match"},
+	};
+	int sevents_count = sizeof(sevents) / sizeof((sevents)[0]);
+	int count = sizeof(tests) / sizeof((tests)[0]);
+	struct tracefs_dynevent **probes;
+	struct tracefs_synth **synth;
+	struct tep_handle *tep;
+	char self[PATH_MAX] = { 0 };
+	char *target = NULL;
+	char *tsys, *tevent;
+	char *tmp, *sav;
+	/* The below matches the tests and sevents arrays */
+	const int uprobes_cnt = 1;
+	const int uretprobes_cnt = 1;
+	const int eprobes_cnt = 2;
+	const int kprobes_cnt = 3;
+	const int kretprobes_cnt = 2;
+	int ret;
+	int i;
+
+	synth = calloc(sevents_count + 1, sizeof(*synth));
+
+	tep = tracefs_local_events(NULL);
+	CU_TEST(tep != NULL);
+
+	destroy_dynevents(TRACEFS_DYNEVENT_ALL);
+
+	for (i = 0; i < sevents_count; i++) {
+		synth[i] = tracefs_synth_alloc(tep,  sevents[i].name,
+					       sevents[i].start_system, sevents[i].start_event,
+					       sevents[i].end_system, sevents[i].end_event,
+					       sevents[i].start_match_field, sevents[i].end_match_field,
+					       sevents[i].match_name);
+		CU_TEST(synth[i] != NULL);
+	}
+
+	probes = calloc(count + 1, sizeof(*probes));
+	CU_TEST(probes != NULL);
+	CU_TEST(readlink("/proc/self/exe", self, sizeof(self)) > 0);
+	CU_TEST(asprintf(&target, "%s:0x%0*llx", self, (int)(sizeof(void *) * 2), FOFFSET) > 0);
+
+	for (i = 0; i < count; i++) {
+		switch (tests[i].type) {
+		case TRACEFS_DYNEVENT_UPROBE:
+			tests[i].address = target;
+			probes[i] = tracefs_uprobe_alloc(tests[i].system, tests[i].event,
+							   self, FOFFSET, tests[i].format);
+			break;
+		case TRACEFS_DYNEVENT_URETPROBE:
+			tests[i].address = target;
+			probes[i] = tracefs_uretprobe_alloc(tests[i].system, tests[i].event,
+							      self, FOFFSET, tests[i].format);
+			break;
+		case TRACEFS_DYNEVENT_KPROBE:
+			probes[i] = tracefs_kprobe_alloc(tests[i].system, tests[i].event,
+						  tests[i].address, tests[i].format);
+			break;
+		case TRACEFS_DYNEVENT_KRETPROBE:
+			probes[i] = tracefs_kretprobe_alloc(tests[i].system, tests[i].event,
+							    tests[i].address, tests[i].format, 0);
+			break;
+		case TRACEFS_DYNEVENT_EPROBE:
+			tmp = strdup(tests[i].address);
+			tsys = strtok_r(tmp, "./", &sav);
+			tevent = strtok_r(NULL, "", &sav);
+			probes[i] = tracefs_eprobe_alloc(tests[i].system, tests[i].event,
+							   tsys, tevent, tests[i].format);
+			free(tmp);
+			break;
+		default:
+			CU_TEST(0);
+			break;
+		}
+
+		CU_TEST(probes[i] != NULL);
+	}
+	probes[i] = NULL;
+
+	get_dynevents_check(TRACEFS_DYNEVENT_ALL, 0);
+	CU_TEST(check_probes(tests, count, probes, false, instance, tep));
+
+	for (i = 0; i < count; i++) {
+		CU_TEST(tracefs_dynevent_create(probes[i]) == 0);
+	}
+
+	get_dynevents_check(TRACEFS_DYNEVENT_ALL, count);
+
+	for (i = 0; i < sevents_count; i++) {
+		CU_TEST(tracefs_synth_create(synth[i]) == 0);
+	}
+
+	get_dynevents_check(TRACEFS_DYNEVENT_ALL, count + sevents_count);
+
+	CU_TEST(check_probes(tests, count, probes, true, instance, tep));
+
+	get_dynevents_check(TRACEFS_DYNEVENT_UPROBE, uprobes_cnt);
+	get_dynevents_check(TRACEFS_DYNEVENT_URETPROBE, uretprobes_cnt);
+	get_dynevents_check(TRACEFS_DYNEVENT_UPROBE |
+			    TRACEFS_DYNEVENT_URETPROBE, uprobes_cnt + uretprobes_cnt);
+
+	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE, kprobes_cnt);
+	get_dynevents_check(TRACEFS_DYNEVENT_KRETPROBE, kretprobes_cnt);
+	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE |
+			    TRACEFS_DYNEVENT_KRETPROBE, kprobes_cnt + kretprobes_cnt);
+
+	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, eprobes_cnt);
+
+	get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, sevents_count);
+
+	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE | TRACEFS_DYNEVENT_SYNTH,
+			    eprobes_cnt + sevents_count);
+
+
+	for (i = 0; i < count; i++) {
+		CU_TEST(tracefs_dynevent_destroy(probes[i], false) == 0);
+	}
+
+	get_dynevents_check(TRACEFS_DYNEVENT_ALL, sevents_count);
+
+	for (i = 0; i < sevents_count; i++) {
+		ret = tracefs_synth_destroy(synth[i]);
+		CU_TEST(ret == 0);
+	}
+
+	get_dynevents_check(TRACEFS_DYNEVENT_ALL, 0);
+
+	for (i = 0; i < count; i++)
+		tracefs_dynevent_free(probes[i]);
+
+	for (i = 0; i < sevents_count; i++)
+		tracefs_synth_free(synth[i]);
+
+	free(synth);
+	free(probes);
+	free(target);
+	tep_free(tep);
+}
+
+static void test_multi_probes(void)
+{
+	test_multi_probes_instance(test_instance);
+}
+
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -3693,4 +3854,5 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "synthetic events", test_synthetic);
 	CU_add_test(suite, "eprobes", test_eprobes);
 	CU_add_test(suite, "uprobes", test_uprobes);
+	CU_add_test(suite, "multi probe test", test_multi_probes);
 }
-- 
2.45.2

