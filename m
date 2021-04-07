Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39AAC43461
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF876139E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbhDGDsi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344553AbhDGDsh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 23:48:37 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95790C06175F
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 20:48:27 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id a12so6547240wrq.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 20:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jKf1WZ85dsSSiPEXRaAsFO5Kg/MZ0gSQmPkou2CkCVk=;
        b=EhI27iOK9eQv80Q7+v0l3nbFVhRBU433M+xAoZr1blngEvkqNvZIK8sIqSB3R/ia42
         gRG2RTltcaNuuROQTlT9WWI5fE3CcX94QIE5/qbn/XX2+i+GChUHJX55aY8DP8TmbDzf
         5VJznAnaetVET0WMqVvNJloVyiZyeH1XP7lY4aqs4gZJliI8J74nssXLWhoEGu6UyzZh
         L9CiHpA2ZqbL1s6eARYIEZi0zPys/iiHq8vWwVEmbf3ITH5S1DUnSmB72cOQS/fUTNfR
         ssCycitq3ORRkuBOjUnhGW0QtchnzdAmbaplzud3Vj05ADx8Z4ObwaIC1AqWd5Fbe2XT
         yxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jKf1WZ85dsSSiPEXRaAsFO5Kg/MZ0gSQmPkou2CkCVk=;
        b=Ot/QJdqFbACOM/AB3uFtrd/hQThkZisikYynZmlCADrPkQVhNXMGYKu6KPzqcQP/H2
         uHLd9le7vJ1CjOPR36/cPOZ+Y3w51yojGGRRBO/ueZi5o90DQgTK8tGrZug5OTJiKygB
         5ucUa2273I3O58xv7TubXyJ+UR4le1gCtt+4CdwVdmi0ZPTQdBRTQo5KPYp72J21Ex0b
         5GDBSlTHgtDydUwkphg4mKjIoFJELIxKhzrgHjo/VR62defBrNzFn7aqn8QiE+hU3Kf8
         Lc3WJKsVcL53yhdCOsOwxVknTyZWxyOfkTi8OiK4bzzrAnoI7tGCJPbwA2xmjAL1CfqJ
         uMxQ==
X-Gm-Message-State: AOAM530sM9MuwvL5Ll4yV8MlwJFCFiEXP7eNlphS4N/o5VTFLiOtaPAs
        ogspxbLfEg+Slj3vfvx9qn8J3O1/kDFDMA==
X-Google-Smtp-Source: ABdhPJzexohgslTNN3G8nqjdGW2yZBkDBOvsqXU42e6W6Yb3fe0qanhcNQnji8hjL0Noux2H3p7/ug==
X-Received: by 2002:adf:8292:: with SMTP id 18mr1628750wrc.160.1617767306358;
        Tue, 06 Apr 2021 20:48:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l21sm5684973wmg.41.2021.04.06.20.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 20:48:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] libtracefs: Unit test for iterate over raw events in sorted order
Date:   Wed,  7 Apr 2021 06:48:20 +0300
Message-Id: <20210407034822.2373958-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407034822.2373958-1-tz.stoyanov@gmail.com>
References: <20210407034822.2373958-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Enhanced the unit test of tracefs_iterate_raw_events() API to check if
events are iterated in sorted order: latest first. Added a check for the
correct CPU number in the record, passed to the callback.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index ed2693b..fea4e1f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -20,7 +20,7 @@
 #define TRACEFS_SUITE		"trasefs library"
 #define TEST_INSTANCE_NAME	"cunit_test_iter"
 #define TEST_TRACE_DIR		"/tmp/trace_utest.XXXXXX"
-#define TEST_ARRAY_SIZE		500
+#define TEST_ARRAY_SIZE		5000
 
 #define ALL_TRACERS	"available_tracers"
 #define CUR_TRACER	"current_tracer"
@@ -36,6 +36,7 @@ struct test_sample {
 };
 static struct test_sample test_array[TEST_ARRAY_SIZE];
 static int test_found;
+static unsigned long long last_ts;
 
 static int test_callback(struct tep_event *event, struct tep_record *record,
 			  int cpu, void *context)
@@ -45,8 +46,13 @@ static int test_callback(struct tep_event *event, struct tep_record *record,
 	int *cpu_test = (int *)context;
 	int i;
 
+	CU_TEST(last_ts <= record->ts);
+	last_ts = record->ts;
+
 	if (cpu_test && *cpu_test >= 0 && *cpu_test != cpu)
 		return 0;
+	CU_TEST(cpu == record->cpu);
+
 	field = tep_find_field(event, "buf");
 	if (field) {
 		sample = ((struct test_sample *)(record->data + field->offset));
@@ -136,6 +142,7 @@ static void test_instance_iter_raw_events(struct tracefs_instance *instance)
 
 	ret = tracefs_iterate_raw_events(NULL, instance, NULL, 0, test_callback, NULL);
 	CU_TEST(ret < 0);
+	last_ts = 0;
 	ret = tracefs_iterate_raw_events(test_tep, NULL, NULL, 0, test_callback, NULL);
 	CU_TEST(ret == 0);
 	ret = tracefs_iterate_raw_events(test_tep, instance, NULL, 0, NULL, NULL);
-- 
2.30.2

