Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D967C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3669161205
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhKDLNg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhKDLNf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:35 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924AFC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:57 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d24so8043161wra.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WUUpo6I3rUc34USe68x66JvL2QCZkQT9VjsccufyFKM=;
        b=H5jKQ5JhqwVYIbJ7tVz5g0tTrauXSMCUz3ATjncNk0dORSYEQuoN1S0ikzPCy0fZLh
         qYtpKwoDdEzP1ELe7hg6izo0z24YDNX//n5aRHd0wlsrl7+U1dfMHMOKxgiT6L+lqAFq
         PRbM0j5NT04rsE5pukSirnD9+3kTn6Ka2/dsTErazepzjLmfH9YfqmQ1PxDXc4Udq4sL
         b7tC4D73BtiWs3pscC4QhbBreFNK7Z4A7loafx+5LOB2wb2JFSeDV4fynxd9hQpr4R9S
         eBAn/0EWCggYfh4tiX5f2yFNA/cwVte1CcX3QOejPcxSIvFFJC5CJZ1wTg5wqmB8Bpdr
         nTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WUUpo6I3rUc34USe68x66JvL2QCZkQT9VjsccufyFKM=;
        b=WSxYdLMXV6AdoiK0cZVvJZNWo6PPJvoODk8r312gahwIaaSJeE2XPe9ubP8ixKUDlT
         A9uTrHOLx2UljMCV+j/fqAfzOpComcnz/31cjQhV0sgxfASKZOs9sAhMTFoywB/b6EQy
         IjQuXEHZoUxdxedSFtMOvRZKo0oKzBIkL1PIxR9oQiB11o+SMn0vJNzTZrvZXHc4redg
         CZHL6G+RHjRYKiAjGCDrLWfy9KpIzt+rRAeom9BH0Z7xP7chvB4Dv/MvlupvEAkbvWrF
         EZ6oHuuturv3nPkfUwY20sePEweSYRFvhzI71sn7wd6doEzU/E2Er17/5ZmXNQx5VCag
         0CAQ==
X-Gm-Message-State: AOAM5339MkwAtCxgwl2Ldrp4E51z7zSaq81AaZjoANDSDGNyXffI/CiY
        wxhC7lKJ0xNkgqCdyATngPo=
X-Google-Smtp-Source: ABdhPJww0CokuK5MV+9XCPg+vyyNlfP1MBq7DuWD0sj2yzaGiHh7BfCrByMio4eVXUk0ecdO9thCog==
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr43163342wrj.84.1636024256140;
        Thu, 04 Nov 2021 04:10:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 06/10] libtracefs: Extend kprobes unit test
Date:   Thu,  4 Nov 2021 13:10:43 +0200
Message-Id: <20211104111047.302660-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
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
 utest/tracefs-utest.c | 412 +++++++++++++++++++++++++-----------------
 1 file changed, 242 insertions(+), 170 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 09bb8f2..c590c6b 100644
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
 
@@ -457,28 +441,262 @@ static void test_instance_file_read(struct tracefs_instance *inst, const char *f
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
+	for (i = 0; devents && devents[i]; i++) {
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
+static struct tracefs_dynevent **get_kprobes_check(enum tracefs_dynevent_type types, int count)
+{
+	struct tracefs_dynevent **devents;
+	int i;
+
+	devents = tracefs_dynevent_get_all(types, NULL);
+	if (count) {
+		CU_TEST(devents != NULL);
+		if (!devents)
+			return NULL;
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
+	char *tmp;
+	int ret;
+	int i;
+
+	/* Invalid parameters */
+	CU_TEST(tracefs_kprobe_alloc("test", NULL, NULL, "test") == NULL);
+	CU_TEST(tracefs_kretprobe_alloc("test", NULL, NULL, "test", 0) == NULL);
+	CU_TEST(tracefs_dynevent_create(NULL) != 0);
+	CU_TEST(tracefs_kprobe_info(NULL, &tmp, &tmp, &tmp, &tmp, &tmp) == TRACEFS_DYNEVENT_MAX);
+	CU_TEST(tracefs_kprobe_raw("test", "test", NULL, "test") != 0);
+	CU_TEST(tracefs_kretprobe_raw("test", "test", NULL, "test") != 0);
+
+	/* kprobes APIs */
+	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
+	CU_TEST(ret == 0);
+	get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		dkprobe[i] = tracefs_kprobe_alloc(ktests[i].system, ktests[i].event,
+						  ktests[i].address, ktests[i].format);
+		CU_TEST(dkprobe[i] != NULL);
+	}
+	dkprobe[i] = NULL;
+	get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, dkprobe, false));
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		dkretprobe[i] = tracefs_kretprobe_alloc(kretests[i].system, kretests[i].event,
+							kretests[i].address, kretests[i].format, 0);
+		CU_TEST(dkretprobe[i] != NULL);
+	}
+	dkretprobe[i] = NULL;
+	get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_create(dkprobe[i]) == 0);
+	}
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
+				    KPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_create(dkretprobe[i]) == 0);
+	}
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
+				    KPROBE_COUNT + KRETPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_destroy(dkretprobe[i], false) == 0);
+	}
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
+				    KPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		CU_TEST(tracefs_dynevent_destroy(dkprobe[i], false) == 0);
+	}
+	get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
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
+	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
+	CU_TEST(ret == 0);
+	get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		ret = tracefs_kprobe_raw(ktests[i].system, ktests[i].event,
+					 ktests[i].address, ktests[i].format);
+		CU_TEST(ret == 0);
+	}
+
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, KPROBE_COUNT);
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
+	devents = get_kprobes_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
+				    KPROBE_COUNT + KRETPROBE_COUNT);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
+	CU_TEST(ret == 0);
+	get_kprobes_check(0, 0);
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
@@ -541,153 +759,6 @@ static void test_instance_file(void)
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
 
@@ -1442,4 +1513,5 @@ void test_tracefs_lib(void)
 		    test_custom_trace_dir);
 	CU_add_test(suite, "ftrace marker",
 		    test_ftrace_marker);
+	CU_add_test(suite, "kprobes", test_kprobes);
 }
-- 
2.31.1

