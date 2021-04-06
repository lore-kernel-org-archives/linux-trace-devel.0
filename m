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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD214C43460
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDFE613B7
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238819AbhDFEUO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhDFEUO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 00:20:14 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51588C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 21:20:07 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f6so6564676wrv.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 21:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uIyNlIOtluNrnYmSi6DquZO21hCTzvwo0SUqb4QYjNg=;
        b=Pxhs6rfoYmf4/d76TesXxCEmBuXYowm0qPid1hgyk5Jg+tKcFg9XQrvZyHPQ26KY1d
         4KuYnlbZ3RpKtl2DPbSS1DdYZW8ABBrNgOzw4MVWL7YYk/Dj9SWRVWmxnCKoeN0MFtAt
         YSTI8Q0hCiks4JAdR0IyjKAYI+bEgcpDOBFVzo3/zKyQffrM/OmUZGmLvEAUlON/mRfQ
         bEvuWp2nHoz/UyyV90+S/llxXErfPRO7diiR7WO5PdEaBYqxwHzas+j1CsVhADO1kzc7
         6BGuRllw57A8UNuSOXxP+qtuaHsRGD1J/OpoT5MABugTNm8MgDdLodLY+eFA2LbTtgwI
         rqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uIyNlIOtluNrnYmSi6DquZO21hCTzvwo0SUqb4QYjNg=;
        b=ka1xaXJLYZnou3Y76xsFKSZDZ8TkwkZ2IeDaqQrZW+P8znS3oNxRm3AwukkBCjShG9
         9U8jk3q7G7nT8pwkb+59zHBRBS4ZsJFkZnnYmH84HQ7cfOOfg457kXKIFLEKKyZjy/WL
         kfdshqyVH4vf+ngMbICyVKRn2evFQJvvS8gDUcoozzKP0kZGnTjp1wOGMWsgBDyhMWW7
         zOOLtgY4TqIu+Fh3DdqAQAZT4S8faWoVVnUiUzJ8BD/WA40ulxlwMic+g7xAZjLRV1Iw
         O/Uc4HWln5nJTKyDx3gO6qGEKI0pjkISF4aUE6IDG6/LyzE1LxJoxJFMx0h7j41507CX
         phew==
X-Gm-Message-State: AOAM530q+EbCLSVzjhr10JDrFnoePFQe9Y5XaRYu8Z5BtcI50Ib4LRN/
        AnBmcId+uhYcQdiRtOR5gxg=
X-Google-Smtp-Source: ABdhPJxP9IxxueGurOomGFDqDcDRw8lwWUXk1qXsOAbCg3VoSgIw9Zn/S4EvlH60XUEQtv+LrSf5uA==
X-Received: by 2002:adf:f908:: with SMTP id b8mr31551643wrr.184.1617682806128;
        Mon, 05 Apr 2021 21:20:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j23sm1325337wmo.33.2021.04.05.21.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 21:20:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] libtracefs: Unit test for iterate over raw events in selected CPUs
Date:   Tue,  6 Apr 2021 07:20:00 +0300
Message-Id: <20210406042001.912544-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406042001.912544-1-tz.stoyanov@gmail.com>
References: <20210406042001.912544-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Enhanced the unit test of tracefs_iterate_raw_events() API to walk
through the selected CPUs only. Added some forgotten calls to CPU_FREE()
for freeing used CPU sets.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index fea4e1f..f9441af 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -49,8 +49,9 @@ static int test_callback(struct tep_event *event, struct tep_record *record,
 	CU_TEST(last_ts <= record->ts);
 	last_ts = record->ts;
 
-	if (cpu_test && *cpu_test >= 0 && *cpu_test != cpu)
-		return 0;
+	if (cpu_test && *cpu_test >= 0) {
+		CU_TEST(*cpu_test == cpu);
+	}
 	CU_TEST(cpu == record->cpu);
 
 	field = tep_find_field(event, "buf");
@@ -105,18 +106,30 @@ static void test_iter_write(struct tracefs_instance *instance)
 
 	sched_setaffinity(0, cpu_size, cpusave);
 	close(fd);
+	CPU_FREE(cpuset);
+	CPU_FREE(cpusave);
 }
 
 
 static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu)
 {
+	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	cpu_set_t *cpuset = NULL;
+	int cpu_size = 0;
 	int check = 0;
 	int ret;
 	int i;
 
+	if (cpu >= 0) {
+		cpuset = CPU_ALLOC(cpus);
+		cpu_size = CPU_ALLOC_SIZE(cpus);
+		CPU_ZERO_S(cpu_size, cpuset);
+		CPU_SET(cpu, cpuset);
+	}
 	test_found = 0;
+	last_ts = 0;
 	test_iter_write(instance);
-	ret = tracefs_iterate_raw_events(test_tep, instance, NULL, 0,
+	ret = tracefs_iterate_raw_events(test_tep, instance, cpuset, cpu_size,
 					 test_callback, &cpu);
 	CU_TEST(ret == 0);
 	if (cpu < 0) {
@@ -132,6 +145,9 @@ static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu)
 		}
 		CU_TEST(test_found == check);
 	}
+
+	if (cpuset)
+		CPU_FREE(cpuset);
 }
 
 static void test_instance_iter_raw_events(struct tracefs_instance *instance)
-- 
2.30.2

