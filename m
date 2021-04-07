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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D956C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFCCD6139E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344553AbhDGDsj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348435AbhDGDsh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 23:48:37 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B22C061760
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 20:48:28 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b9so8436049wrs.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 20:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uIyNlIOtluNrnYmSi6DquZO21hCTzvwo0SUqb4QYjNg=;
        b=kVQuW3JK3tMZ108N8DyAeo7u9TkI9DupWeKv2PTCJkmHmBNym3IYif+F9a5i1QgATD
         PIwcvjOiMCQMzcEAlrAJZM0gyTT4HugZGuED01tvMjqaKHa9PAXzw1rVtGb3NWDRfXeA
         cfXzzDFVs2RVv0FHR3sdg7xTVNyb4dYSWLP5svnyI/+/HdvDb8qUKnHEXsb2Flmqvgj7
         dLYVCq2bz7Z3oaDP0mMWSzlQiRiKRLXQyPf3l+wy7c8Bp52aBKOzuQcU97A3kD11AVM9
         hrAgoOUuaZ/q7NbX0YCF9vTpERC8NeXrewUtMHEIWthuueCQM5B/QZvqcZ+2WzYxOXXy
         sqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uIyNlIOtluNrnYmSi6DquZO21hCTzvwo0SUqb4QYjNg=;
        b=BTgAgBrKa1fKvgG3vwXVCXVEbi8VOmxAghJQxL2wgLCUmhn5QrqdGNH/e/bOv62c/8
         pRyzZgbPTD7Vzv+cVEH3q1vdLs1nnH4maA0Ex8Pzc9f8nLyzFix8bTLM8e2cQZonsHIV
         EUD2wpLmqeEtz/jr5TD70PadVtEu8Cn41hiCKryCpJwtWutMkGnTgo+WqNWIDV3BE3Gx
         3kneje4qBNRFVY3Ce+uCTbuXCc+FqQO8+Fa2E7NS/Ps+YiYooooCHjkFOGRJz+R2D33N
         ZlYywCFxshJbMPPQtvNdVeWQ00dOWA2gWVgmTBpYeLsxsBGQPYfFhtfCWfgH12E2pgOX
         TAgg==
X-Gm-Message-State: AOAM530qvMZb6vzFP3R+6F/NENAgTYxeY3NzXxn81EaC5dVdUrHadVle
        sTrli+p576/Ba2t1OnhiW2+Z6dmxqRaSeA==
X-Google-Smtp-Source: ABdhPJx0WawKKtNaVoxZET9Obbd+ZPOtGD6Sff20W41Om4uYX4nV4m2xHopO4mFIBAk008hpzfJxiw==
X-Received: by 2002:a5d:654a:: with SMTP id z10mr1613595wrv.335.1617767307453;
        Tue, 06 Apr 2021 20:48:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l21sm5684973wmg.41.2021.04.06.20.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 20:48:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/4] libtracefs: Unit test for iterate over raw events in selected CPUs
Date:   Wed,  7 Apr 2021 06:48:21 +0300
Message-Id: <20210407034822.2373958-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407034822.2373958-1-tz.stoyanov@gmail.com>
References: <20210407034822.2373958-1-tz.stoyanov@gmail.com>
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

