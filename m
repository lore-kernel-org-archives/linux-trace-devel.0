Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC988C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C46CF610E8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhDFEUQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhDFEUP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 00:20:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDC1C061574
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 21:20:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j18so12649217wra.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 21:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jKf1WZ85dsSSiPEXRaAsFO5Kg/MZ0gSQmPkou2CkCVk=;
        b=d3i9Fd3Lxa82Iq5vUAFLu7HSp7DGq7G1AwzGnjpbmlrieVowLQVRWn9/RM+J4/9/VY
         cKBVFbKr4WNzq/0KPfAcMolJ+Nge22oRfzw1UvZU5pHLXY0G9+1obpEA6x+PwjyMzulz
         P014d8uRU4703LR3Nf+ZMqGtUb2fAijL9Wgf5AYhIhY3puHtUcEJrmGV96AjxSFhdX0o
         /upcv2hXzw/gTBZkiFZ4ZuGPNCOa/gSX+3KfO3R4QcNArtKiyDie4AlN4m5z0TFyQ14X
         mk6d7CdZQ7WaPjCCg7z9vn7agRCFoY0YURvzL2IJf0+RorqoKKtMwvEaCFVbdUJfo8GO
         gBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jKf1WZ85dsSSiPEXRaAsFO5Kg/MZ0gSQmPkou2CkCVk=;
        b=EA6gy74SzRLtQZl6vMah0QyNby5JLSXxFZ/mAbYgvBwDieFAiJ0Ss4NCqZ87b5xx7y
         +jdWRsrZnsczkOupBLIGDeYr6dcrTecvjJ1FpCHRCM2c1JiCr9ypd3b3PBEd3r9NHpXn
         En0RNtPBjlruFewDu+by+27C4MS9cX3MPgVIBKFRpcK8rFSuFuwou8JoLZkXkfeuQpd3
         Gku6p7CoFI4a0TjiX2KWqs/K8dl83o/OxLC2JGq6iuCueyoQSIOOLsSBx04NKB16hfRZ
         zXgG/GTT8Fxf5iKotAXA8y4wR6PjasuTQovutGP0iwt71+L1ckEYcO0mzC3BsFVPYZsZ
         G5lA==
X-Gm-Message-State: AOAM530OLY9zc0ilMono+oWbQppUE26K1rUwyxDVpWIgZXYKuBbbyJ2w
        a28rQjoS1u5zJTcM07AS7dw=
X-Google-Smtp-Source: ABdhPJw4IVAfpWK5y12wcdF7vlbKzkQagGExRNpf5WAKiqLJUx+Gffg1bxS2k/hzfceiA2DoN9QQwg==
X-Received: by 2002:a05:6000:2a7:: with SMTP id l7mr32234225wry.30.1617682805245;
        Mon, 05 Apr 2021 21:20:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j23sm1325337wmo.33.2021.04.05.21.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 21:20:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] libtracefs: Unit test for iterate over raw events in sorted order
Date:   Tue,  6 Apr 2021 07:19:59 +0300
Message-Id: <20210406042001.912544-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406042001.912544-1-tz.stoyanov@gmail.com>
References: <20210406042001.912544-1-tz.stoyanov@gmail.com>
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

