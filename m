Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF25C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 10:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357088AbhLBLC4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 06:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhLBLC4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 06:02:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3ACC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 02:59:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e3so114399315edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 02:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bMn8BWxwE2eepLvsJdf57VgUUJBl931i3YeVlJEYc9g=;
        b=nqCV8PGYybaCbdVMsZqEJ0p4BGKHmRt1aw9kDQG3+aQzt9PZDbfMi3vI+Dn1hOtoSr
         AoLMFlmYrdntP1tVAR/kq/2HspamjS6VAPCUKixLVrNIM702ufAZanqU7CyHSnvZFXtv
         zPiPDVQO+YccfjvV/Z/gClMYhIH9BKtGoPYVX8t0WffohX+IoI0mvEm8h8v1BE7aIdvj
         42GdtSettacYFjiS6Jdgopmy+TUuDQASncRjef5bNIC01HQICD7Nsr9ut1K6/WXEjQe/
         Jj8CiADiywUAM6ePK+qeZcAIIeWodc3UTXsKja+VMoAS2lAwXEHSz1IW6ofWwTJkNRdD
         ZhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bMn8BWxwE2eepLvsJdf57VgUUJBl931i3YeVlJEYc9g=;
        b=6G7dJzVyCRg8YT5mOtNEYLcjDaGsEja46d1/c+C1EDgupi2mwnV3Co+TQYdM1n5ODb
         NSdr98kuCC7X+dir1ktkrfjxPQYYGs6LxQa17MC7s59eRx9RWbVNJ4w/ibdVhVJzgbI5
         YNGnSgQVp/zIo12K7rAmtH8dnlC8ii2rDzo0GExS8MbdntAgsOVnmqoynK0Vv+UGZ+NY
         k3shJEGAl43B2VFKLr4L7EV2qz246eO5iI8C+V04TfBgH5vOEQaO7n1tRcQ1V1TlAQ9e
         UJIfUEvpvHakkqRPPZQKJinIZPCg1FjdkvX8V1m1tJoMi5XPphrShlMwAPNftMiyFtOY
         cQjA==
X-Gm-Message-State: AOAM5311zTv3zSUWwZwauHEo+Fw0BN3Tdjv44Lo3lZEWuzC/NDXu9m/d
        ikxELwSp162olIEOZS+bTNBhwFbqnwb6uw==
X-Google-Smtp-Source: ABdhPJznb9kswYfAPX0zB/chDyhm/2HaR98BvpPpo131rfddl+uVlxkqK+rx37TyBMeheyZdbFHaAA==
X-Received: by 2002:a05:6402:4413:: with SMTP id y19mr16850083eda.26.1638442772529;
        Thu, 02 Dec 2021 02:59:32 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e19sm1852930edu.47.2021.12.02.02.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 02:59:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/4] libtracefs: Unit test for tracefs_dynevent_get_event()
Date:   Thu,  2 Dec 2021 12:59:25 +0200
Message-Id: <20211202105926.32581-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202105926.32581-1-tz.stoyanov@gmail.com>
References: <20211202105926.32581-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit tests for dynamic events are extended to test the newly introduced
tracefs_dynevent_get_event() API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 60 +++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 3a01f38..e8d5c69 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -567,9 +567,10 @@ struct probe_test {
 
 static bool check_probes(struct probe_test *probes, int count,
 			 struct tracefs_dynevent **devents, bool in_system,
-			 struct tracefs_instance *instance)
+			 struct tracefs_instance *instance, struct tep_handle *tep)
 {
 	enum tracefs_dynevent_type type;
+	struct tep_event *tevent;
 	char *ename;
 	char *address;
 	char *event;
@@ -615,6 +616,17 @@ static bool check_probes(struct probe_test *probes, int count,
 				CU_TEST(ret != 0);
 			}
 
+			tevent =  tracefs_dynevent_get_event(tep, devents[i]);
+			if (in_system) {
+				CU_TEST(tevent != NULL);
+				if (tevent) {
+					CU_TEST(strcmp(tevent->name, event) == 0);
+					CU_TEST(strcmp(tevent->system, system) == 0);
+				}
+			} else {
+				CU_TEST(tevent == NULL);
+			}
+
 			found++;
 			break;
 		}
@@ -649,10 +661,14 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	struct tracefs_dynevent **dkretprobe;
 	struct tracefs_dynevent **dkprobe;
 	struct tracefs_dynevent **devents;
+	struct tep_handle *tep;
 	char *tmp;
 	int ret;
 	int i;
 
+	tep = tep_alloc();
+	CU_TEST(tep != NULL);
+
 	dkprobe = calloc(kprobe_count + 1, sizeof(*dkprobe));
 	dkretprobe = calloc(kretprobe_count + 1, sizeof(*dkretprobe));
 
@@ -676,7 +692,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 	dkprobe[i] = NULL;
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
-	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance, tep));
 
 	for (i = 0; i < kretprobe_count; i++) {
 		dkretprobe[i] = tracefs_kretprobe_alloc(kretests[i].system, kretests[i].event,
@@ -685,15 +701,15 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 	dkretprobe[i] = NULL;
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
-	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
 
 	for (i = 0; i < kprobe_count; i++) {
 		CU_TEST(tracefs_dynevent_create(dkprobe[i]) == 0);
 	}
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
 				    kprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -702,8 +718,8 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
 				    kprobe_count + kretprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -712,8 +728,8 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
 				    kprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -721,8 +737,8 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 		CU_TEST(tracefs_dynevent_destroy(dkprobe[i], false) == 0);
 	}
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
-	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -743,7 +759,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, kprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -754,19 +770,19 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE, kprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KRETPROBE, kretprobe_count);
-	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance));
+	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
 				    kprobe_count + kretprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -775,6 +791,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
 	free(dkretprobe);
 	free(dkprobe);
+	tep_free(tep);
 }
 
 static void test_kprobes(void)
@@ -793,11 +810,15 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
 	int count = sizeof(etests) / sizeof((etests)[0]);
 	struct tracefs_dynevent **deprobes;
 	struct tracefs_dynevent **devents;
+	struct tep_handle *tep;
 	char *tsys, *tevent;
 	char *tmp, *sav;
 	int ret;
 	int i;
 
+	tep = tep_alloc();
+	CU_TEST(tep != NULL);
+
 	deprobes = calloc(count + 1, sizeof(*deprobes));
 
 	/* Invalid parameters */
@@ -821,14 +842,14 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
 	deprobes[i] = NULL;
 
 	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, 0);
-	CU_TEST(check_probes(etests, count, deprobes, false, instance));
+	CU_TEST(check_probes(etests, count, deprobes, false, instance, tep));
 
 	for (i = 0; i < count; i++) {
 		CU_TEST(tracefs_dynevent_create(deprobes[i]) == 0);
 	}
 
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, count);
-	CU_TEST(check_probes(etests, count, devents, true, instance));
+	CU_TEST(check_probes(etests, count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -836,12 +857,13 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
 		CU_TEST(tracefs_dynevent_destroy(deprobes[i], false) == 0);
 	}
 	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, 0);
-	CU_TEST(check_probes(etests, count, deprobes, false, instance));
+	CU_TEST(check_probes(etests, count, deprobes, false, instance, tep));
 
 	for (i = 0; i < count; i++)
 		tracefs_dynevent_free(deprobes[i]);
 
 	free(deprobes);
+	tep_free(tep);
 }
 
 static void test_eprobes(void)
-- 
2.33.1

