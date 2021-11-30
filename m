Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1260C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 05:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhK3FEZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 00:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhK3FEY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 00:04:24 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1DAC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:05 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v1so81421371edx.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QkU2CUQvXYadtzeoRi/ympe8R5++k8f7Z+495DLdM0g=;
        b=CY2VhAdmdV2TBsAphzBFREN4i76Brim3TfmzKJ3EnJktYW04YpwNBOpcoFl16g1cpp
         1ic6by/ldkVXw8304jaA+9moyWfRZW50x8EQ02+l4MuAjuqLcioGAw+7bZByuW4ROBm+
         FVciPk0YvH8B6s4SHq7IgSdiEHNKxzS69u16/dPBXnNlVXhH6Aafjsvo3Wmq5UO2t3mq
         g/L3soDcvIcIn6HPDHtmaomCvb6lOobzyFXk6+bwlFt66cWbr/7xlvYjeCbdqUo/Uo8z
         s+g2Led3YCdEv37Gmuu8rb6xVhHztoigwH1IQVZXbDCM8aC7WydG3N9qV0r5iDt+ncU9
         gTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QkU2CUQvXYadtzeoRi/ympe8R5++k8f7Z+495DLdM0g=;
        b=BFJkjHNGjDAobMZx1Mhe8EZMTQyB9SH7vTkCtpttxAxjIr3SI/BwGkX97PdlwZoKtF
         C9nwcDhnWPcrDgs7QDWYHOH80DVWi2d09hkTJbe50J1RwTbQeBEMqk3LorhyCv5GlmGo
         nic61TKsaFv6MsrSCFJJPWxCHWThydPhM0uaZmrMxK8G6qI+WaRVhOt/YiFqQHogYH3V
         rJeukoZZc+LgQ2PO7oc8yF8TnJNnjMENtp/R7P3p8Uqtj09nCEIK/5gvR/OwwPgroKD6
         lFEFQ1wThFDqVyRQydKyQkqyTGbrdqFURDz2w+wygtN43yHw2OEs7J1cJiJbIFb6ZanS
         6bvw==
X-Gm-Message-State: AOAM531GUE2bKxNuaDDus+FaZMmpvFt77DoxRdujB2tQRsGzxP4gBTJc
        JsY4ejFpd42stynywIV/Qkm2aCovmlHMQg==
X-Google-Smtp-Source: ABdhPJwLxRCR/wUaTWJEE7ULyiw34B+ZHoGz0swVjP5eFeneBAGU10u1CIkfnwdlV2HmSLSRh3RCCg==
X-Received: by 2002:a17:907:2d12:: with SMTP id gs18mr63289531ejc.126.1638248464571;
        Mon, 29 Nov 2021 21:01:04 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w18sm10385849edx.55.2021.11.29.21.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 21:01:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] libtracefs: Unit test for tracefs_dynevent_get_event()
Date:   Tue, 30 Nov 2021 07:00:56 +0200
Message-Id: <20211130050057.336228-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130050057.336228-1-tz.stoyanov@gmail.com>
References: <20211130050057.336228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit tests for dynamic events are extended to test the newly introduced
tracefs_dynevent_get_event() API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-dynevents.txt |  5 ++-
 utest/tracefs-utest.c                  | 58 +++++++++++++++++---------
 2 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index 7de06be..bd18f5b 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -71,8 +71,9 @@ freed with free(3) if they are set.
 
 The *tracefs_dynevent_get_event*() function returns tep event, describing the given dynamic event.
 If the dynamic event is newly created and not yet loaded in the @tep, the dynamic event system is
-rescanned for any new events. The returned pointer to tep event is controlled by @tep and must not
-be freed.
+rescanned for any new events. If the dynamic event is deleted from the system, any subsequent calls
+to *tracefs_dynevent_get_event*() may return a tep event, as the deletion is not detected by the API.
+The returned pointer to tep event is controlled by @tep and must not be freed.
 
 RETURN VALUE
 ------------
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 3a01f38..c555b06 100644
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
@@ -615,6 +616,15 @@ static bool check_probes(struct probe_test *probes, int count,
 				CU_TEST(ret != 0);
 			}
 
+			if (in_system) {
+				tevent =  tracefs_dynevent_get_event(tep, devents[i]);
+				CU_TEST(tevent != NULL);
+				if (tevent) {
+					CU_TEST(strcmp(tevent->name, event) == 0);
+					CU_TEST(strcmp(tevent->system, system) == 0);
+				}
+			}
+
 			found++;
 			break;
 		}
@@ -649,10 +659,14 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
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
 
@@ -676,7 +690,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 	dkprobe[i] = NULL;
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
-	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance, tep));
 
 	for (i = 0; i < kretprobe_count; i++) {
 		dkretprobe[i] = tracefs_kretprobe_alloc(kretests[i].system, kretests[i].event,
@@ -685,15 +699,15 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
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
 
@@ -702,8 +716,8 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
 				    kprobe_count + kretprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -712,8 +726,8 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
 				    kprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -721,8 +735,8 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 		CU_TEST(tracefs_dynevent_destroy(dkprobe[i], false) == 0);
 	}
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
-	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance));
-	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -743,7 +757,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	}
 
 	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, kprobe_count);
-	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance));
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
@@ -754,19 +768,19 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
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
 
@@ -775,6 +789,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
 	free(dkretprobe);
 	free(dkprobe);
+	tep_free(tep);
 }
 
 static void test_kprobes(void)
@@ -793,11 +808,15 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
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
@@ -821,14 +840,14 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
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
 
@@ -836,12 +855,13 @@ static void test_eprobes_instance(struct tracefs_instance *instance)
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

