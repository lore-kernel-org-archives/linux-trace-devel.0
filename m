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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDD4C43462
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3E8610E5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhDHOAy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhDHOAx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 10:00:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD174C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 07:00:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 18so2568928edx.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 07:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aigXluwuEOx02rzW9nLCvHAuZ0s0Xv+OeSwDwSd0AaU=;
        b=G7nVOsHgz8s6XaOQIbdTXUXgsO6XQDtVw0Sv6Q6QwOmLoCH5074Qo8Y+PAvBVu8gHR
         d0D6fHGE4UDC+Pe+13sS0cT7Q45mTfpHQeRR0FDe+mJFdvYFJtUlduRlIqPSBLxWOPi+
         YrPUjQ6Thna7dmfzEKb0zxgSlMixrt2v98joQSvOWSTsO2+RBfZb8V5ZZzJmqzgjdQAO
         DW3AAka3sk3GYpKXp/Tb8lABzpEG2nJVf8eBpu/7eU0cJZK7af4W7vM1vIRYlEG4cXTV
         nMDa2J9pKRMEZ1jX/rfhFIYikOXdrY51EoaDGTNc1zkDJG1hdJNRzqwqWpE2awY0Mz8y
         WI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aigXluwuEOx02rzW9nLCvHAuZ0s0Xv+OeSwDwSd0AaU=;
        b=EPm5PCmc2Zwdz9m5dwmjvYi2wi0IoCFbeW0LJDKba8/d7D6V9xLkdZ107rFV/ca0ff
         IaNQyMbAFf1TA9ytHLC724uL0kXC2XtYbmpUr2m8Fu4G4owcuWDRmd2wZ5lf3EVOoR8Y
         13tl6TNqESSIwPGnie5X+WknlpFju9TpaqoJvkpua2/WLowEheoIW/iM/OB92abqNImK
         9IxL8alRXvjVWXWaRvBdmaIHvhzqxe2yNM04o2KJY8l5k4w5MEz+ocmLajp0MH/UFEFU
         piaw8dV7HwaG66TgpP5n2KbsByhKjS46JOjyM4+B5qqSbuaDQLDQL9t+twQ/hIQD73Yg
         /byA==
X-Gm-Message-State: AOAM532lVf9+xW1QtEoNHi3pg4fc8/SjD+gW/StICkjdwH2nRcu22arr
        fHj4nktxDFgRDFP2MslKB6w=
X-Google-Smtp-Source: ABdhPJz7JAej8eJv4FQctE+1cIrFh9YNeo7QHyMChZLprgTgr5t6xAyEx1QDRq1TzH8QFEWC6E8Xkg==
X-Received: by 2002:a50:f19d:: with SMTP id x29mr2343705edl.102.1617890439510;
        Thu, 08 Apr 2021 07:00:39 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id jt18sm8212150ejc.96.2021.04.08.07.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 07:00:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 5/5] libtracefs: Rename tracefs_option_is_set()
Date:   Thu,  8 Apr 2021 17:00:24 +0300
Message-Id: <20210408140024.13093-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210408140024.13093-1-y.karadz@gmail.com>
References: <20210408140024.13093-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The old name of the function is potentially confusing. Indeed
the function do not check anything about the option itself (is it
supported or is it enabled). The function only check if inside
the mask the bit that corresponds to a given option is set.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h     | 4 ++--
 src/tracefs-tools.c   | 4 ++--
 utest/tracefs-utest.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index ea9dbd0..daae419 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -132,8 +132,8 @@ enum tracefs_option_id {
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
 struct tracefs_options_mask;
-bool tracefs_option_is_set(const struct tracefs_options_mask *options,
-			   enum tracefs_option_id id);
+bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
+				enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index b6967db..126fc57 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -367,14 +367,14 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 }
 
 /**
- * tracefs_option_is_set - Check if given option is set in the bitmask
+ * tracefs_option_mask_is_set - Check if given option is set in the bitmask
  * @options: Options bitmask
  * @id: trace option id
  *
  * Returns true if an option with given id is set in the bitmask,
  * false if it is not set.
  */
-bool tracefs_option_is_set(const struct tracefs_options_mask *options,
+bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
 			   enum tracefs_option_id id)
 {
 	if (id > TRACEFS_OPTION_INVALID)
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index af28779..185ac2a 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -547,7 +547,7 @@ static bool check_options_mask_empty(struct tracefs_options_mask *mask)
 	int i;
 
 	for (i = 1; i < TRACEFS_OPTION_MAX; i++) {
-		if (tracefs_option_is_set(mask, i))
+		if (tracefs_option_mask_is_set(mask, i))
 			return false;
 	}
 	return true;
@@ -580,7 +580,7 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 		CU_TEST(strcmp(name, "unknown"));
 		snprintf(file, PATH_MAX, "options/%s", name);
 
-		if (tracefs_option_is_set(all, i)) {
+		if (tracefs_option_mask_is_set(all, i)) {
 			CU_TEST(check_option(instance, i, true, -1));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 		} else {
@@ -588,7 +588,7 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 			CU_TEST(!tracefs_option_is_supported(instance, i));
 		}
 
-		if (tracefs_option_is_set(enabled, i)) {
+		if (tracefs_option_mask_is_set(enabled, i)) {
 			CU_TEST(check_option(instance, i, true, 1));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 			CU_TEST(tracefs_option_is_enabled(instance, i));
@@ -596,7 +596,7 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 			CU_TEST(check_option(instance, i, true, 0));
 			CU_TEST(tracefs_option_enable(instance, i) == 0);
 			CU_TEST(check_option(instance, i, true, 1));
-		} else if (tracefs_option_is_set(all_copy, i)) {
+		} else if (tracefs_option_mask_is_set(all_copy, i)) {
 			CU_TEST(check_option(instance, i, true, 0));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 			CU_TEST(!tracefs_option_is_enabled(instance, i));
-- 
2.27.0

