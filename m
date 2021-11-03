Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA33C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223EE6109F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhKCPrG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhKCPrF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:05 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB987C061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:28 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z200so2325507wmc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qQ0sZ2dDwBpprPA0s279wFEVczh2Thbc9T6dMutfR8M=;
        b=ct8/+5zgKeB9+z9LSTzqcgIQf0GV4Em4TVrdqvJ5gsT6t5bnK0tGLkMzFzTM0hCgCf
         /iYjJJKvoAtZYveCG3ocCwz6XaP3xX04YeQAJMWbfUPLS6u9tDofkHGjhPWwdfVE0CYR
         cS2F2PnPaJ9g74XSvDM23AEZGN5/N8JWFORaz3koeynnFPDMkGcz2OGOwK+SmnG+KbZ8
         scgeaq8jGSD1VpPg28Q9RLGJEgtvVE0v/BKr8vP1/JG8sT8F/29VW+nsun9EaXmkdYhI
         lHhUpWMX4y6y2FkwVkXLVwA8sDNAGbXwJmEpwBfe7gtx9l0naSRwUJ4eh065fvw/dmQ8
         7Skw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQ0sZ2dDwBpprPA0s279wFEVczh2Thbc9T6dMutfR8M=;
        b=422qsdz5ZlNpqaKfPoobz2GZErt6AyZpG8/5lCcINOo1UUhv+CmdaqOPExQQ6zYEUN
         VWhuRVvImUF5DhekQm+mlw2+XZRON9PL01I04Z5jqUmqbl59UW6S6Fyb3wMHJRv4PWh5
         k/ps5eIs+wNpnky+Gu3clpKHzqH+3ReS6FGxTiUiaLJrKqhTLbhKk7VSpsqIw29cFlz8
         FLR9kScCwVV1hlZBsDaj4wVf05hlfj7pXtk95W161HOfO+mREmJEaasv6BI+a6ekxqUf
         Ec5mnMoseuRImNqDJR1GxlFgvpebYU6UrPEH23bAuzLyjcnZ+eeaXNhtFFUOsLJZFNFQ
         7WCQ==
X-Gm-Message-State: AOAM530SZcwpY9cVLc69A6Th5ViYjrYHg/lrlBfyl1rlZXC50KqMUfaF
        9ePw6nil8uHnWzCu86hWBVw=
X-Google-Smtp-Source: ABdhPJxyzojTVzFdCaQNbLjrJ2svJUNx7SCvXTpWHXoP2jmeQUtR7PU18S+rOZVpZ1Yp7FFSwIwiDw==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr16582473wmh.86.1635954267220;
        Wed, 03 Nov 2021 08:44:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 07/11] libtracefs: Extend kprobes unit test
Date:   Wed,  3 Nov 2021 17:44:13 +0200
Message-Id: <20211103154417.246999-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As there are a lot of changes in the libtracefs kprobes APIs, the unit
test of that functionality should be updated. A new test section is
added, for testing the all kprobes APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 417 +++++++++++++++++++++++++-----------------
 1 file changed, 247 insertions(+), 170 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 09bb8f2..431ae15 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -28,22 +28,6 @@
 #define TRACE_ON	"tracing_on"
 #define TRACE_CLOCK	"trace_clock"
 
-#define KPROBE_EVENTS	"kprobe_events"
-
-#define KPROBE_1_NAME	"mkdir"
-#define KPROBE_1_GROUP	"kprobes"
-#define KPROBE_1_ADDR	"do_mkdirat"
-#define KPROBE_1_FMT	"path=+u0($arg2):ustring"
-
-#define KPROBE_2_NAME	"open"
-#define KPROBE_2_GROUP	"myprobe"
-#define KPROBE_2_ADDR	"do_sys_openat2"
-#define KPROBE_2_FMT	"file=+u0($arg2):ustring flags=+0($arg3):x64"
-
-#define KRETPROBE_NAME	"retopen"
-#define KRETPROBE_ADDR	"do_sys_openat2"
-#define KRETPROBE_FMT	"ret=$retval"
-
 #define SQL_1_EVENT	"wakeup_1"
 #define SQL_1_SQL	"select sched_switch.next_pid as woke_pid, sched_waking.common_pid as waking_pid from sched_waking join sched_switch on sched_switch.next_pid = sched_waking.pid"
 
@@ -457,28 +441,267 @@ static void test_instance_file_read(struct tracefs_instance *inst, const char *f
 	free(file);
 }
 
+#define KPROBE_DEFAULT_GROUP "kprobes"
+struct kprobe_test {
+	enum tracefs_dynevent_type type;
+	char *prefix;
+	char *system;
+	char *event;
+	char *address;
+	char *format;
+};
+
+static bool check_kprobes(struct kprobe_test *kprobes, int count,
+			  struct tracefs_dynevent **devents, bool in_system)
+{
+
+	enum tracefs_dynevent_type ktype;
+	char *ename;
+	char *kaddress;
+	char *kevent;
+	char *ksystem;
+	char *kformat;
+	char *kprefix;
+	int found = 0;
+	int ret;
+	int i, j;
+
+	for (i = 0; devents[i]; i++) {
+		ktype = tracefs_kprobe_info(devents[i], &ksystem,
+					   &kevent, &kprefix, &kaddress, &kformat);
+		for (j = 0; j < count; j++) {
+			if (ktype != kprobes[j].type)
+				continue;
+			if (kprobes[j].event)
+				ename = kprobes[j].event;
+			else
+				ename = kprobes[j].address;
+			if (strcmp(ename, kevent))
+				continue;
+			if (kprobes[j].system) {
+				CU_TEST(strcmp(kprobes[j].system, ksystem) == 0);
+			} else {
+				CU_TEST(strcmp(KPROBE_DEFAULT_GROUP, ksystem) == 0);
+			}
+			CU_TEST(strcmp(kprobes[j].address, kaddress) == 0);
+			if (kprobes[j].format) {
+				CU_TEST(strcmp(kprobes[j].format, kformat) == 0);
+			}
+			if (kprobes[j].prefix) {
+				CU_TEST(strcmp(kprobes[j].prefix, kprefix) == 0);
+			}
+			ret = tracefs_event_enable(test_instance, ksystem, kevent);
+			if (in_system) {
+				CU_TEST(ret == 0);
+			} else {
+				CU_TEST(ret != 0);
+			}
+			ret = tracefs_event_disable(test_instance, ksystem, kevent);
+			if (in_system) {
+				CU_TEST(ret == 0);
+			} else {
+				CU_TEST(ret != 0);
+			}
+
+			found++;
+			break;
+		}
+		free(ksystem);
+		free(kevent);
+		free(kprefix);
+		free(kaddress);
+		free(kformat);
+	}
+
+	CU_TEST(found == count);
+	if (found != count)
+		return false;
+
+	return true;
+}
+
+static struct tracefs_dynevent **get_kprobes_check(enum tracefs_dynevent_type type, int count)
+{
+	struct tracefs_dynevent **devents;
+	int mask = 0;
+	int i;
+
+	if (TRACEFS_DYNEVENT_KPROBE == type || TRACEFS_DYNEVENT_MAX == type)
+		TRACEFS_BIT_SET(mask, TRACEFS_DYNEVENT_KPROBE);
+	if (TRACEFS_DYNEVENT_KRETPROBE == type || TRACEFS_DYNEVENT_MAX == type)
+		TRACEFS_BIT_SET(mask, TRACEFS_DYNEVENT_KRETPROBE);
+	devents = tracefs_dynevent_get_all(mask, NULL);
+	if (count) {
+		CU_TEST(devents != NULL);
+		i = 0;
+		while (devents[i])
+			i++;
+		CU_TEST(i == count);
+	} else {
+		CU_TEST(devents == NULL);
+	}
+
+	return devents;
+}
+
+#define KPROBE_COUNT	3
+#define KRETPROBE_COUNT	2
+static void test_kprobes(void)
+{
+	struct kprobe_test ktests[KPROBE_COUNT] = {
+		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "mkdir", "do_mkdirat", "path=+u0($arg2):ustring" },
+		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "close", "close_fd", NULL },
+		{ TRACEFS_DYNEVENT_KPROBE, "p", "ptest", "open2", "do_sys_openat2",
+				  "file=+u0($arg2):ustring flags=+0($arg3):x64" },
+	};
+	struct kprobe_test kretests[KRETPROBE_COUNT] = {
+		{ TRACEFS_DYNEVENT_KRETPROBE, NULL, NULL, "retopen", "do_sys_openat2", "ret=$retval" },
+		{ TRACEFS_DYNEVENT_KRETPROBE, NULL, NULL, NULL, "do_sys_open", "ret=$retval" },
+	};
+	struct tracefs_dynevent *dkretprobe[KRETPROBE_COUNT + 1];
+	struct tracefs_dynevent *dkprobe[KPROBE_COUNT + 1];
+	struct tracefs_dynevent **devents;
+	int all_mask = 0;
+	char *tmp;
+	int ret;
+	int i;
+
+	TRACEFS_BIT_SET(all_mask, TRACEFS_DYNEVENT_KPROBE);
+	TRACEFS_BIT_SET(all_mask, TRACEFS_DYNEVENT_KRETPROBE);
+
+	/* Invalid parameters */
+	CU_TEST(tracefs_kprobe_alloc("test", NULL, NULL, "test") == NULL);
+	CU_TEST(tracefs_kretprobe_alloc("test", NULL, NULL, "test", 0) == NULL);
+	CU_TEST(tracefs_dynevent_create(NULL) != 0);
+	CU_TEST(tracefs_kprobe_info(NULL, &tmp, &tmp, &tmp, &tmp, &tmp) == TRACEFS_DYNEVENT_MAX);
+	CU_TEST(tracefs_kprobe_raw("test", "test", NULL, "test") != 0);
+	CU_TEST(tracefs_kretprobe_raw("test", "test", NULL, "test") != 0);
+	CU_TEST(tracefs_kprobe_raw("test", "test", "test", NULL) != 0);
+	CU_TEST(tracefs_kretprobe_raw("test", "test", "test", NULL) != 0);
+
+	/* kprobes APIs */
+	ret = tracefs_dynevent_destroy_all(all_mask, true);
+	CU_TEST(ret == 0);
+	get_kprobes_check(TRACEFS_DYNEVENT_MAX, 0);
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		dkprobe[i] = tracefs_kprobe_alloc(ktests[i].system, ktests[i].event,
+						  ktests[i].address, ktests[i].format);
+		CU_TEST(dkprobe[i] != NULL);
+	}
+	dkprobe[i] = NULL;
+	get_kprobes_check(TRACEFS_DYNEVENT_MAX, 0);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, dkprobe, false));
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		dkretprobe[i] = tracefs_kretprobe_alloc(kretests[i].system, kretests[i].event,
+							kretests[i].address, kretests[i].format, 0);
+		CU_TEST(dkretprobe[i] != NULL);
+	}
+	dkretprobe[i] = NULL;
+	get_kprobes_check(TRACEFS_DYNEVENT_MAX, 0);
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_create(dkprobe[i]) == 0);
+	}
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_MAX, KPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_create(dkretprobe[i]) == 0);
+	}
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_MAX, KPROBE_COUNT + KRETPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_destroy(dkretprobe[i], false) == 0);
+	}
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_MAX, KPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_destroy(dkprobe[i], false) == 0);
+	}
+	get_kprobes_check(TRACEFS_DYNEVENT_MAX, 0);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, dkprobe, false));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KPROBE_COUNT; i++)
+		tracefs_dynevent_free(dkprobe[i]);
+	for (i = 0; i < KRETPROBE_COUNT; i++)
+		tracefs_dynevent_free(dkretprobe[i]);
+
+	/* kprobes raw APIs */
+	ret = tracefs_dynevent_destroy_all(all_mask, true);
+	CU_TEST(ret == 0);
+	get_kprobes_check(TRACEFS_DYNEVENT_MAX, 0);
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		ret = tracefs_kprobe_raw(ktests[i].system, ktests[i].event,
+					 ktests[i].address, ktests[i].format);
+		CU_TEST(ret == 0);
+	}
+
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KPROBE, KPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		ret = tracefs_kretprobe_raw(kretests[i].system, kretests[i].event,
+					    kretests[i].address, kretests[i].format);
+		CU_TEST(ret == 0);
+	}
+
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KPROBE, KPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KRETPROBE, KRETPROBE_COUNT);
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_MAX, KPROBE_COUNT + KRETPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	ret = tracefs_dynevent_destroy_all(all_mask, true);
+	CU_TEST(ret == 0);
+	get_kprobes_check(TRACEFS_DYNEVENT_MAX, 0);
+}
+
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
 	struct tracefs_instance *second = NULL;
-	enum tracefs_kprobe_type type;
 	const char *name = get_rand_str();
 	const char *inst_name = NULL;
 	const char *tdir;
 	char *inst_file;
 	char *inst_dir;
 	struct stat st;
-	char **kprobes;
-	char *kformat;
-	char *ktype;
-	char *kaddr;
-	char *fname;
 	char *file1;
 	char *file2;
 	char *tracer;
+	char *fname;
 	int size;
 	int ret;
-	int i;
 
 	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
@@ -541,153 +764,6 @@ static void test_instance_file(void)
 	free(file1);
 	free(file2);
 
-	ret = tracefs_kprobe_clear_all(true);
-	CU_TEST(ret == 0);
-	ret = tracefs_kprobe_raw(NULL, KPROBE_1_NAME, KPROBE_1_ADDR, KPROBE_1_FMT);
-	CU_TEST(ret == 0);
-	ret = tracefs_kprobe_raw(KPROBE_2_GROUP, KPROBE_2_NAME, KPROBE_2_ADDR,
-				 KPROBE_2_FMT);
-	CU_TEST(ret == 0);
-
-	ret = tracefs_kretprobe_raw(KPROBE_2_GROUP, KRETPROBE_NAME, KRETPROBE_ADDR,
-				 KRETPROBE_FMT);
-	CU_TEST(ret == 0);
-
-	type = tracefs_kprobe_info(KPROBE_1_GROUP, KPROBE_1_NAME, &ktype,
-				   &kaddr, &kformat);
-	CU_TEST(type == TRACEFS_KPROBE);
-	CU_TEST(ktype && *ktype == 'p');
-	CU_TEST(kaddr && !strcmp(kaddr, KPROBE_1_ADDR));
-	CU_TEST(kformat && !strcmp(kformat, KPROBE_1_FMT));
-	free(ktype);
-	free(kaddr);
-	free(kformat);
-
-	type = tracefs_kprobe_info(KPROBE_2_GROUP, KPROBE_2_NAME, &ktype,
-				   &kaddr, &kformat);
-	CU_TEST(type == TRACEFS_KPROBE);
-	CU_TEST(ktype && *ktype == 'p');
-	CU_TEST(kaddr && !strcmp(kaddr, KPROBE_2_ADDR));
-	CU_TEST(kformat && !strcmp(kformat, KPROBE_2_FMT));
-	free(ktype);
-	free(kaddr);
-	free(kformat);
-
-	type = tracefs_kprobe_info(KPROBE_2_GROUP, KRETPROBE_NAME, &ktype,
-				   &kaddr, &kformat);
-	CU_TEST(type == TRACEFS_KRETPROBE);
-	CU_TEST(ktype && *ktype == 'r');
-	CU_TEST(kaddr && !strcmp(kaddr, KRETPROBE_ADDR));
-	CU_TEST(kformat && !strcmp(kformat, KRETPROBE_FMT));
-	free(ktype);
-	free(kaddr);
-	free(kformat);
-
-	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
-	CU_TEST(kprobes != NULL);
-
-	for (i = 0; kprobes[i]; i++) {
-		char *system = strtok(kprobes[i], "/");
-		char *event = strtok(NULL, "");
-		bool found = false;
-		if (!strcmp(system, KPROBE_1_GROUP)) {
-			CU_TEST(!strcmp(event, KPROBE_1_NAME));
-			found = true;
-		} else if (!strcmp(system, KPROBE_2_GROUP)) {
-			switch (tracefs_kprobe_info(system, event, NULL, NULL, NULL)) {
-			case TRACEFS_KPROBE:
-				CU_TEST(!strcmp(event, KPROBE_2_NAME));
-				found = true;
-				break;
-			case TRACEFS_KRETPROBE:
-				CU_TEST(!strcmp(event, KRETPROBE_NAME));
-				found = true;
-				break;
-			default:
-				break;
-			}
-		}
-		CU_TEST(found);
-	}
-	tracefs_list_free(kprobes);
-	CU_TEST(i == 3);
-
-	kprobes = tracefs_get_kprobes(TRACEFS_KPROBE);
-	CU_TEST(kprobes != NULL);
-
-	for (i = 0; kprobes[i]; i++) {
-		char *system = strtok(kprobes[i], "/");
-		char *event = strtok(NULL, "");
-		bool found = false;
-		if (!strcmp(system, KPROBE_1_GROUP)) {
-			CU_TEST(!strcmp(event, KPROBE_1_NAME));
-			found = true;
-		} else if (!strcmp(system, KPROBE_2_GROUP)) {
-			CU_TEST(!strcmp(event, KPROBE_2_NAME));
-			found = true;
-		}
-		CU_TEST(found);
-	}
-	tracefs_list_free(kprobes);
-	CU_TEST(i == 2);
-
-	kprobes = tracefs_get_kprobes(TRACEFS_KRETPROBE);
-	CU_TEST(kprobes != NULL);
-
-	for (i = 0; kprobes[i]; i++) {
-		char *system = strtok(kprobes[i], "/");
-		char *event = strtok(NULL, "");
-		bool found = false;
-		if (!strcmp(system, KPROBE_2_GROUP)) {
-			CU_TEST(!strcmp(event, KRETPROBE_NAME));
-			found = true;
-		}
-		CU_TEST(found);
-	}
-	tracefs_list_free(kprobes);
-	CU_TEST(i == 1);
-
-	ret = tracefs_event_enable(instance, KPROBE_1_GROUP, KPROBE_1_NAME);
-	CU_TEST(ret == 0);
-	ret = tracefs_event_enable(instance, KPROBE_2_GROUP, KPROBE_2_NAME);
-	CU_TEST(ret == 0);
-	ret = tracefs_event_enable(instance, KPROBE_2_GROUP, KRETPROBE_NAME);
-	CU_TEST(ret == 0);
-
-	ret = tracefs_kprobe_clear_all(false);
-	CU_TEST(ret < 0);
-
-	ret = tracefs_kprobe_clear_probe(KPROBE_2_GROUP, NULL, false);
-	CU_TEST(ret < 0);
-
-	ret = tracefs_kprobe_clear_probe(KPROBE_2_GROUP, NULL, true);
-	CU_TEST(ret == 0);
-
-	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
-	CU_TEST(kprobes != NULL);
-
-	for (i = 0; kprobes[i]; i++) {
-		char *system = strtok(kprobes[i], "/");
-		char *event = strtok(NULL, "");
-		bool found = false;
-		if (!strcmp(system, KPROBE_1_GROUP)) {
-			CU_TEST(!strcmp(event, KPROBE_1_NAME));
-			found = true;
-		}
-		CU_TEST(found);
-	}
-	tracefs_list_free(kprobes);
-	CU_TEST(i == 1);
-
-	ret = tracefs_kprobe_clear_all(true);
-	CU_TEST(ret == 0);
-
-	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
-	CU_TEST(kprobes != NULL);
-
-	CU_TEST(kprobes[0] == NULL);
-	tracefs_list_free(kprobes);
-
 	tracefs_put_tracing_file(inst_file);
 	free(fname);
 
@@ -1442,4 +1518,5 @@ void test_tracefs_lib(void)
 		    test_custom_trace_dir);
 	CU_add_test(suite, "ftrace marker",
 		    test_ftrace_marker);
+	CU_add_test(suite, "kprobes", test_kprobes);
 }
-- 
2.31.1

