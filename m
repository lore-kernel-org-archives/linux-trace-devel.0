Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46A8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B58E610CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhJ1MLw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhJ1MLw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E575C061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r4so23323648edi.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WTq5qOpvUu2XG/2+rj8uij1oz6f3NYw8QIxfVbATNUc=;
        b=nuENlEwwcNLIz9//6NysaHnM3TiaXK5y9PF7DodjMCah51b1ZhYHYfkn4TG0uM/D9X
         WhQYHJOlBt5yiubwQuGrWvn+JEGJUPmQX7gjaxxOvLV3c8XETIgRrqtBRywgF7BBGwup
         0T+0DLc9E+9qe674RFEqpRGEfQOOnDeYOFyKCOru6vw73AE6ZDqhS4zbJr3s7ImOj5Bt
         Hw3QNuEgcCDzTWaeY3GghMCaZhPtihYen5Zr45RrSN6S9GMC3uSKC2/HUvm8J7V9r0kf
         59xJfrBnZeQQd0se2lM2TF0axB1tA2xIlyoCJ4Sk/7diA/XLJV2/uVN2yEoOHl7Bz8pb
         /ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WTq5qOpvUu2XG/2+rj8uij1oz6f3NYw8QIxfVbATNUc=;
        b=HHSz8NULqAerFqUmdONRZJQzjvXmy68jmAN2d3juEy93tzSl70QYjMpsuuzrjGxxiD
         Y/k3EUAjs/7uAIxGxT8eIHi94nWTSgZy3+k41XnWdDx93LQUSyBL2UhI3SGa61ysyW6S
         VJBzVxZqcKym3Z+ScgYniPzwJQD7kU93RozzUthdrSTt6D2A1K2LuVqLxTCgM+woxzIg
         MNPjZwR28yCaGW3c6sF9Pz3JMdbx0ftZ01O6zHVL8IZnxGQVPyZbEdRFzTX2oDyy2sKO
         z6JJmvDsi71/CqgK9cClsfr/pGbyfD83HzPmXQe5l27SKx7rSuqsKH/H38VBv82Izp4f
         /OsA==
X-Gm-Message-State: AOAM533yoMLQv45wwuRECn3T0tJLixJLrxc5LpRaYBormwG0acjJxeJP
        baFx0VIV0jQ2O8zh7lz6UBc=
X-Google-Smtp-Source: ABdhPJz9IXGumcCfxf7xQ/wJGH9fj9kk1mUMVxU/fmENf0Yuk5dofD8mo2l74kCNd1No/774mLNb+g==
X-Received: by 2002:a17:907:ea5:: with SMTP id ho37mr4865160ejc.355.1635422958219;
        Thu, 28 Oct 2021 05:09:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/12] libtracefs: Extend kprobes unit test
Date:   Thu, 28 Oct 2021 15:09:03 +0300
Message-Id: <20211028120907.101847-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
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
 utest/tracefs-utest.c | 414 +++++++++++++++++++++++++-----------------
 1 file changed, 244 insertions(+), 170 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 7c1a84e..0a17b82 100644
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
 
@@ -457,28 +441,264 @@ static void test_instance_file_read(struct tracefs_instance *inst, const char *f
 	free(file);
 }
 
+#define KPROBE_DEFAULT_GROUP "kprobes"
+struct kprobe_test {
+	enum tracefs_kprobe_type type;
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
+	enum tracefs_kprobe_type ktype;
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
+			CU_TEST(strcmp(kprobes[j].format, kformat) == 0);
+			if (kprobes[j].prefix)
+				CU_TEST(strcmp(kprobes[j].prefix, kprefix) == 0);
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
+#define KPROBE_COUNT	2
+#define KRETPROBE_COUNT	2
+static void test_kprobes(void)
+{
+	char *tmp;
+
+	struct kprobe_test ktests[KPROBE_COUNT] = {
+		{ TRACEFS_KPROBE, "p:", NULL, "mkdir", "do_mkdirat", "path=+u0($arg2):ustring" },
+		{ TRACEFS_KPROBE, "p:", "ptest", "open", "do_sys_openat2",
+				  "file=+u0($arg2):ustring flags=+0($arg3):x64" },
+	};
+	struct kprobe_test kretests[KRETPROBE_COUNT] = {
+		{ TRACEFS_KRETPROBE, NULL, NULL, "retopen", "do_sys_openat2", "ret=$retval" },
+		{ TRACEFS_KRETPROBE, NULL, NULL, NULL, "do_sys_open", "ret=$retval" },
+	};
+	struct tracefs_dynevent *dkretprobe[KRETPROBE_COUNT + 1];
+	struct tracefs_dynevent *dkprobe[KPROBE_COUNT + 1];
+	struct tracefs_dynevent **devents;
+	int ret;
+	int i;
+
+	/* Invalid parameters */
+	CU_TEST(tracefs_kprobe_alloc("test", NULL, NULL, "test") == NULL);
+	CU_TEST(tracefs_kretprobe_alloc("test", NULL, NULL, "test", 0) == NULL);
+	CU_TEST(tracefs_kprobe_alloc("test", NULL, "test", NULL) == NULL);
+	CU_TEST(tracefs_kretprobe_alloc("test", NULL, "test", NULL, 0) == NULL);
+	CU_TEST(tracefs_kprobe_create(NULL) != 0);
+	CU_TEST(tracefs_kprobe_info(NULL, &tmp, &tmp, &tmp, &tmp, &tmp) == TRACEFS_ALL_KPROBES);
+	CU_TEST(tracefs_kprobe_raw("test", "test", NULL, "test") != 0);
+	CU_TEST(tracefs_kretprobe_raw("test", "test", NULL, "test") != 0);
+	CU_TEST(tracefs_kprobe_raw("test", "test", "test", NULL) != 0);
+	CU_TEST(tracefs_kretprobe_raw("test", "test", "test", NULL) != 0);
+
+	/* kprobes APIs */
+	ret = tracefs_kprobe_destroy(NULL, true);
+	CU_TEST(ret == 0);
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == 0);
+	CU_TEST(devents == NULL);
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		dkprobe[i] = tracefs_kprobe_alloc(ktests[i].system, ktests[i].event,
+						  ktests[i].address, ktests[i].format);
+		CU_TEST(dkprobe[i] != NULL);
+	}
+	dkprobe[i] = NULL;
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == 0);
+	CU_TEST(devents == NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, dkprobe, false));
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		dkretprobe[i] = tracefs_kretprobe_alloc(kretests[i].system, kretests[i].event,
+							kretests[i].address, kretests[i].format, 0);
+		CU_TEST(dkretprobe[i] != NULL);
+	}
+	dkretprobe[i] = NULL;
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == 0);
+	CU_TEST(devents == NULL);
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		CU_TEST(tracefs_kprobe_create(dkprobe[i]) == 0);
+	}
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == KPROBE_COUNT);
+	CU_TEST(devents != NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		CU_TEST(tracefs_kprobe_create(dkretprobe[i]) == 0);
+	}
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == (KPROBE_COUNT + KRETPROBE_COUNT));
+	CU_TEST(devents != NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		CU_TEST(tracefs_kprobe_destroy(dkretprobe[i], false) == 0);
+	}
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == KPROBE_COUNT);
+	CU_TEST(devents != NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		CU_TEST(tracefs_kprobe_destroy(dkprobe[i], false) == 0);
+	}
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == 0);
+	CU_TEST(devents == NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, dkprobe, false));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, dkretprobe, false));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	for (i = 0; i < KPROBE_COUNT; i++)
+		tracefs_kprobe_free(dkprobe[i]);
+	for (i = 0; i < KRETPROBE_COUNT; i++)
+		tracefs_kprobe_free(dkretprobe[i]);
+
+	/* kprobes raw APIs */
+	ret = tracefs_kprobe_destroy(NULL, true);
+	CU_TEST(ret == 0);
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == 0);
+	CU_TEST(devents == NULL);
+
+	for (i = 0; i < KPROBE_COUNT; i++) {
+		ret = tracefs_kprobe_raw(ktests[i].system, ktests[i].event,
+					 ktests[i].address, ktests[i].format);
+		CU_TEST(ret == 0);
+	}
+
+	ret = tracefs_kprobes_get(TRACEFS_KPROBE, &devents);
+	CU_TEST(ret == KPROBE_COUNT);
+	CU_TEST(devents != NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	for (i = 0; i < KRETPROBE_COUNT; i++) {
+		ret = tracefs_kretprobe_raw(kretests[i].system, kretests[i].event,
+					    kretests[i].address, kretests[i].format);
+		CU_TEST(ret == 0);
+	}
+
+	ret = tracefs_kprobes_get(TRACEFS_KPROBE, &devents);
+	CU_TEST(ret == KPROBE_COUNT);
+	CU_TEST(devents != NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	ret = tracefs_kprobes_get(TRACEFS_KRETPROBE, &devents);
+	CU_TEST(ret == KRETPROBE_COUNT);
+	CU_TEST(devents != NULL);
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == (KPROBE_COUNT + KRETPROBE_COUNT));
+	CU_TEST(devents != NULL);
+	CU_TEST(check_kprobes(ktests, KPROBE_COUNT, devents, true));
+	CU_TEST(check_kprobes(kretests, KRETPROBE_COUNT, devents, true));
+	tracefs_dynevent_list_free(&devents);
+	devents = NULL;
+
+	ret = tracefs_kprobe_destroy(NULL, true);
+	CU_TEST(ret == 0);
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &devents);
+	CU_TEST(ret == 0);
+	CU_TEST(devents == NULL);
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
@@ -541,153 +761,6 @@ static void test_instance_file(void)
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
-	kprobes = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
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
-	kprobes = tracefs_kprobes_get(TRACEFS_KPROBE);
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
-	kprobes = tracefs_kprobes_get(TRACEFS_KRETPROBE);
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
-	kprobes = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
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
-	kprobes = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
-	CU_TEST(kprobes != NULL);
-
-	CU_TEST(kprobes[0] == NULL);
-	tracefs_list_free(kprobes);
-
 	tracefs_put_tracing_file(inst_file);
 	free(fname);
 
@@ -1442,4 +1515,5 @@ void test_tracefs_lib(void)
 		    test_custom_trace_dir);
 	CU_add_test(suite, "ftrace marker",
 		    test_ftrace_marker);
+	CU_add_test(suite, "kprobes", test_kprobes);
 }
-- 
2.31.1

