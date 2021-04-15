Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE28C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F346137D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhDOMNt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDOMNs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 08:13:48 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A4FC06175F
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:25 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id v6so35227678ejo.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBbh6sDrJSeW7ta6BZDPWAj+z1sWBTzbJs5rZJ8nB8o=;
        b=kd9EDVp8ugZJ6oyIXfnexpih4KXpt2XWSl8fqpdJvWTetNscXjBiDVLy3zUNL9RSPa
         3ybo2e/cTVFjzaCbHn/cuYr2hazmjCWTLNn+0qVz0Jb8qt22kVnTJHttLhkWP1TeGKGW
         kYgpS2Z49EiK+2ycxa0pcs6/QfBFe8FQ8NHjQenIZQfYWoneek61h8vswamAmKr4DyLp
         V4JyRaBr1Ze9dRy4JSz+NM5bfuPVKqc6DXkCB9w9iti+qP6VeRZInFX5/+sme6FnMxCf
         8Y7mhVmsBEwMZ87tDO5ltHGhe5w3Ha4UCK0Tfmj7SVP27G00T32ETPFPQr1SHqAA53mp
         ZjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBbh6sDrJSeW7ta6BZDPWAj+z1sWBTzbJs5rZJ8nB8o=;
        b=mApNnoZLowP4QifZwnz07I3WtNk/VT0+2AQP6IOMYV7Tj9MpSsRzsNm78aPVkO67Wi
         MLYwwcCOnhVV1FXXVh3YEqcNrySYuCCbSlmo7Gla4cnXQu791h7bssuX+3Y4VbC2DhqH
         Hym/vfyIuTm1NfmsnxbHY6LD1AH0VvxuUN1RR2ItCQk+FGgj97gXiDxvo1YLddL9uxFB
         L6TaB+7uAfImD863PDnLhb5sB4LbDsCFg4Gah4i96eX+5CPDpdILe09nUHFmsezw7tKH
         wzbYh8DUxqbtb/twPyfWlwerGUqmBQFhs0AooBg5Ch/SEA0EVNq0LB5faIV/X2R57Pim
         FGAw==
X-Gm-Message-State: AOAM533Yxf1vOZ+Dha5r5EnQL6fzCGndg2YwOpHqmIi4BdspzKsfzKQo
        vcas+TSZdZDaQ7VA3m/e6ss6xpRSUos=
X-Google-Smtp-Source: ABdhPJyY0jiah5bY+fe/XNOS08HIp/CdlJNbOC8h0eHTUGvWjf1USSEHzTtWSvrekaErr5k+Gg1Zzg==
X-Received: by 2002:a17:906:804b:: with SMTP id x11mr3199479ejw.388.1618488804441;
        Thu, 15 Apr 2021 05:13:24 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.55])
        by smtp.gmail.com with ESMTPSA id o20sm2364863eds.65.2021.04.15.05.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:13:24 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] libtracefs: Add tests for the new methods for writing
Date:   Thu, 15 Apr 2021 15:13:10 +0300
Message-Id: <20210415121311.59787-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415121311.59787-1-y.karadz@gmail.com>
References: <20210415121311.59787-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add testing for "int tracefs_instance_file_append()" and
"int tracefs_instance_file_clear()".
The test case performs registration and deregistration of kprobes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 utest/tracefs-utest.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index d675c16..edb3a3d 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -28,6 +28,11 @@
 #define TRACE_ON	"tracing_on"
 #define TRACE_CLOCK	"trace_clock"
 
+#define KPROB_EVTS	"kprobe_events"
+#define KPROBE_1	"p:mkdir do_mkdirat path=+u0($arg2):ustring"
+#define KPROBE_1_RM	"-:mkdir"
+#define KPROBE_2	"p:open do_sys_openat2 file=+u0($arg2):ustring flags=+0($arg3):x64"
+
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
 struct test_sample {
@@ -375,6 +380,7 @@ static void test_instance_file(void)
 	char *inst_file;
 	char *inst_dir;
 	struct stat st;
+	char *kprobes;
 	char *fname;
 	char *file1;
 	char *file2;
@@ -443,6 +449,32 @@ static void test_instance_file(void)
 	free(file1);
 	free(file2);
 
+	ret = tracefs_instance_file_write(NULL, KPROB_EVTS, KPROBE_1);
+	CU_TEST(ret == strlen(KPROBE_1));
+	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
+	CU_TEST(kprobes != NULL);
+	CU_TEST(strstr(kprobes, KPROBE_1 + 2) != NULL);
+	free(kprobes);
+
+	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_2);
+	CU_TEST(ret == strlen(KPROBE_2));
+	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
+	CU_TEST(kprobes != NULL);
+	CU_TEST(strstr(kprobes, KPROBE_2 + 2) != NULL);
+	free(kprobes);
+
+	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_1_RM);
+	CU_TEST(ret == strlen(KPROBE_1_RM));
+	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
+	CU_TEST(kprobes != NULL);
+	CU_TEST(strstr(kprobes, KPROBE_1 + 2) == NULL);
+	free(kprobes);
+
+	ret = tracefs_instance_file_clear(NULL, KPROB_EVTS);
+	CU_TEST(ret == 0);
+	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
+	CU_TEST(kprobes == NULL);
+
 	tracefs_put_tracing_file(inst_file);
 	free(fname);
 
-- 
2.25.1

