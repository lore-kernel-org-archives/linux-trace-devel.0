Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_24_48,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73B0C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 02:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3788610FC
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 02:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhDBCAv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 22:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhDBCAv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 22:00:51 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41F7C0613E6
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Apr 2021 19:00:50 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id j7so2934277qtx.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Apr 2021 19:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MmGCHfXsxnfSJwX63M9CDgyEIcicaoaGyErUExBMfcw=;
        b=nQFYr5y3J/44NQ6R7E3vNvxdaCwtulH//XfUlx7m0xyosprP4PXrEcI+k/vcCw6BZB
         x7ZxSCzLkb3vSHmROuxX/CUn6+BSUEXyJlM99b9SiRebbW5Y8StCnvV83lvmkXNt1py+
         MoFBRjm8lHWhTKLbN/p2jDczlrS5udlVlAjyS3N4xAETloaDHWXonCFZ3TikA7FnP8OH
         GNLvVsQppxbSFciFVwrOaV5W64H7ezwH+AvyE3px5xlSzCzYVOszt8IiG/VVPXhlyyMe
         wDJEJwPrqgeDpZJiGe1Gfg7TsgFtMn2ZdXW3C3XnzcwnWGgP47m23hvuNvUzr+lFC6EB
         W4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MmGCHfXsxnfSJwX63M9CDgyEIcicaoaGyErUExBMfcw=;
        b=MGMTXEeu+LtQReZJTnIBnxOnqo8fOOefqvsHLrYi+RS3WJjHMFZJdR1k4kpih+u601
         jcpuJc+s4xiQSEycCR/sqDI93+0o1knNsli/1PfOvIE3ikPfh0K1YqdJTHNKBEfW2NUJ
         1Ve71NLC/NkDDCPp4LyQQjjwJ/CT8cUGWhX+iPTTQA9PEH1vbPexEctHJiWYrZ3ZFzAA
         UhDg6hSXWR6FoFH4Y4Qi3HXZhzAXDmrwyMaCk5p+0uSGVJ4sHIzm2YCiiak+h09uzNb3
         eVbuHdaw2EPmvpcTqnN+pZmb1O77POoK1XTC2yMGyjZYU0iKdgIjXUafakaegkhsO0ro
         R25A==
X-Gm-Message-State: AOAM532SRs/mUiLjKz6gGVk3kbqlzS9gDk8YLrugTe0P4OBiGLN3ehOE
        PI34hDBioTtyVXtLZqkGFVlEbCObCYZ4LQ==
X-Google-Smtp-Source: ABdhPJwL5pkMGiMI26zKBnQXAnN8H8OsdmyzCfwOeNUQLGi1asyfkUbwvq0jr5VnekO/OTR0vn5CLA==
X-Received: by 2002:ac8:4b6d:: with SMTP id g13mr9802628qts.369.1617328849990;
        Thu, 01 Apr 2021 19:00:49 -0700 (PDT)
Received: from localhost.localdomain ([115.98.176.68])
        by smtp.gmail.com with ESMTPSA id d14sm6197935qkg.33.2021.04.01.19.00.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Apr 2021 19:00:49 -0700 (PDT)
From:   Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH] libtracefs: Unit test for the tracing filter API
Date:   Sat,  3 Apr 2021 07:31:00 +0530
Message-Id: <1617415260-19795-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracefs_function_filter();

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index ed2693b..09e564f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -11,6 +11,7 @@
 #include <time.h>
 #include <dirent.h>
 #include <ftw.h>
+#include <errno.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -1020,6 +1021,80 @@ static void test_custom_trace_dir(void)
 	free(dname);
 }
 
+static int test_instance_filter(struct tracefs_instance *instance,
+				const char **filters, const char *module,
+				int flags)
+{
+	int ret;
+	int i;
+
+	if (filters) {
+		for (i = 0; filters[i]; i++) {
+			ret = tracefs_function_filter(instance, filters[i],
+						      module, flags);
+			if (ret) {
+				if (errno == EINVAL)
+					printf("Filter %s did not match\n",
+					       filters[i]);
+				else
+					printf("Failed writing %s\n",
+					       filters[i]);
+			}
+		}
+	} else {
+		ret = tracefs_function_filter(instance, NULL, module, flags);
+	}
+	return ret;
+}
+
+static void test_tracefs_function_filter(void)
+{
+	const char *filter[] = {"run_init_process", "ufs*", "^ext4.*$", NULL};
+	const char *future_filter[] = {"write_dummy", "read_dummy", NULL};
+	const char *future_module = "dummy";
+	struct tracefs_instance *instance;
+	const char *module = "btrtl";
+	int ret;
+
+	instance = tracefs_instance_create(TEST_INSTANCE_NAME);
+	CU_TEST(instance != NULL);
+
+	ret = tracefs_function_filter(instance, NULL, NULL,
+				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
+	if (ret) {
+		printf("Failed to reset the filter\n");
+		if (ret < 0)
+			tracefs_function_filter(instance, NULL, NULL, 0);
+	}
+	/* Test string, kernel glob and regex for specific_instance*/
+	ret = test_instance_filter(instance, filter, NULL, TRACEFS_FL_CONTINUE);
+	CU_ASSERT(ret == 0);
+	/* Test Module only with no filters*/
+	ret = test_instance_filter(instance, NULL, module, TRACEFS_FL_CONTINUE);
+	CU_ASSERT(ret == 0);
+	ret = test_instance_filter(instance, future_filter, future_module,
+				   TRACEFS_FL_CONTINUE | TRACEFS_FL_FUTURE);
+	CU_ASSERT(ret == 0);
+	tracefs_function_filter(instance, NULL, NULL, 0);
+
+	ret = tracefs_function_filter(NULL, NULL, NULL,
+				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
+	if (ret) {
+		printf("Failed to reset the filter\n");
+		if (ret < 0)
+			tracefs_function_filter(instance, NULL, NULL, 0);
+	}
+	/* Test top instance*/
+	ret = test_instance_filter(NULL, filter, NULL, TRACEFS_FL_CONTINUE);
+	CU_ASSERT(ret == 0);
+	ret = test_instance_filter(NULL, NULL, module, TRACEFS_FL_CONTINUE);
+	CU_ASSERT(ret == 0);
+	ret = test_instance_filter(NULL, future_filter, future_module,
+				   TRACEFS_FL_CONTINUE | TRACEFS_FL_FUTURE);
+	CU_ASSERT(ret == 0);
+	tracefs_function_filter(NULL, NULL, NULL, 0);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -1075,4 +1150,6 @@ void test_tracefs_lib(void)
 		    test_tracing_options);
 	CU_add_test(suite, "custom system directory",
 		    test_custom_trace_dir);
+	CU_add_test(suite, "Set Filter API",
+		    test_tracefs_function_filter);
 }
-- 
2.7.4

