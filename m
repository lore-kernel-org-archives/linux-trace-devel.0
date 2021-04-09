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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB69C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53643610C8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhDISEz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhDISEy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:04:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AA7C061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 11:04:41 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g5so3331229ejx.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Apr 2021 11:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HKUHAOpNrUrKqASrdS1VZ77GIFGbq5QAtjB5KFl/0SU=;
        b=frxLGvcreTL+FsfBNaaL0l9zQcieFEDJoRjcmfc4HyBaQaavCyoRYx6AbQPc2xITLT
         yMMPxKpyk06VRJnR7vBPyWI42u85UY03O28aWYlpjgrV3ZuZDWQ8E66oA3WhkEM146XE
         f0PpptpoqwtWy691Xvd28CGXXx1g6N45iCkX/nZmufVhABF0WBz5hNEOxBbkb0jSG+pM
         RZv+z+gxOMUvcGNTp4J5vX4w0l2NRylB370Ob4Fg2bc4gT1DHjSencNOWYEJgez20Do/
         UQePP39OuXK9yB5lxzIH6iyZFa0JZQJpEqxj0HV7qhGcTglWKAw8rCdkBBGBGn/3Ki5V
         RTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKUHAOpNrUrKqASrdS1VZ77GIFGbq5QAtjB5KFl/0SU=;
        b=C0cd0l1TbpsMLV8uSLslAmoyf0KdPDGm3K0uES6frc76ayKl+MpRMtyO8UxoZofFOf
         osvihanrTqXbEhjAKTAbaVbsGgl3OQ6Z/0OSylB9gpPf+egMVWeuDI8xC8GGNND3bo0W
         L6T3Fuk7lMQ2m3uJHBmtmPEO8dgnCd36MRkM3c6Ep28ZUgArDObDQvS5EJr5wJnTenhD
         SiitGBThZJCgAGQwc34nHvUQ9SE6ZWwu83MjmsI3eR3cpDv3UHrRQ0j1la7p22mTjGFR
         0zbk/n5uDYuwnjXRFUqZrb1hqzc9JGvsdN6FFWyYy4ECHYSz7BgO1IauXCMT+tovi0Ee
         y0lA==
X-Gm-Message-State: AOAM531vTbK1gQQFPw8tyPbXnMcwwYDzjjGrGmhceAgqQgP5F9vSjaPU
        u/UHdnp5CzX18rq0j8d2oQM=
X-Google-Smtp-Source: ABdhPJy3NJtd091VX8nkqHNu6FOgjjk8miJzAb6tqkBVZ9yzYAqQZHysdNShoT4jM1idkUs7ZwjgWA==
X-Received: by 2002:a17:907:2bd9:: with SMTP id gv25mr17430240ejc.225.1617991480066;
        Fri, 09 Apr 2021 11:04:40 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id b14sm1865568edx.39.2021.04.09.11.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:04:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 2/5] libtracefs: Modify the arguments of tracefs_option_is_set()
Date:   Fri,  9 Apr 2021 21:04:20 +0300
Message-Id: <20210409180423.72497-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180423.72497-1-y.karadz@gmail.com>
References: <20210409180423.72497-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This function is supposed to take as argument a mask returned by
"tracefs_options_get_supported()" or "tracefs_options_get_enabled()",
hence this argument must be a pointer.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h     |  4 ++--
 src/tracefs-tools.c   |  5 +++--
 utest/tracefs-utest.c | 12 ++++++------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index d3db8b5..95016c8 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -136,8 +136,8 @@ struct tracefs_options_mask {
 };
 void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id);
 void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id);
-bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id);
-
+bool tracefs_option_is_set(struct tracefs_options_mask *options,
+			   enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index f409def..25c0cea 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -370,10 +370,11 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
  * Returns true if an option with given id is set in the bitmask,
  * false if it is not set.
  */
-bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id)
+bool tracefs_option_is_set(struct tracefs_options_mask *options,
+			   enum tracefs_option_id id)
 {
 	if (id > TRACEFS_OPTION_INVALID)
-		return options.mask & (1ULL << (id - 1));
+		return options->mask & (1ULL << (id - 1));
 	return false;
 }
 
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index ed2693b..9cb2a09 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -547,7 +547,7 @@ static bool check_options_mask_empty(struct tracefs_options_mask *mask)
 	int i;
 
 	for (i = 1; i < TRACEFS_OPTION_MAX; i++) {
-		if (tracefs_option_is_set(*mask, i))
+		if (tracefs_option_is_set(mask, i))
 			return false;
 	}
 	return true;
@@ -580,9 +580,9 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 		CU_TEST(strcmp(name, "unknown"));
 		snprintf(file, PATH_MAX, "options/%s", name);
 
-		if (tracefs_option_is_set(*all, i)) {
+		if (tracefs_option_is_set(all, i)) {
 			tracefs_option_clear(all, i);
-			CU_TEST(!tracefs_option_is_set(*all, i));
+			CU_TEST(!tracefs_option_is_set(all, i));
 			CU_TEST(check_option(instance, i, true, -1));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 		} else {
@@ -590,9 +590,9 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 			CU_TEST(!tracefs_option_is_supported(instance, i));
 		}
 
-		if (tracefs_option_is_set(*enabled, i)) {
+		if (tracefs_option_is_set(enabled, i)) {
 			tracefs_option_clear(enabled, i);
-			CU_TEST(!tracefs_option_is_set(*enabled, i));
+			CU_TEST(!tracefs_option_is_set(enabled, i));
 			CU_TEST(check_option(instance, i, true, 1));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 			CU_TEST(tracefs_option_is_enabled(instance, i));
@@ -600,7 +600,7 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 			CU_TEST(check_option(instance, i, true, 0));
 			CU_TEST(tracefs_option_enable(instance, i) == 0);
 			CU_TEST(check_option(instance, i, true, 1));
-		} else if (tracefs_option_is_set(*all_copy, i)) {
+		} else if (tracefs_option_is_set(all_copy, i)) {
 			CU_TEST(check_option(instance, i, true, 0));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 			CU_TEST(!tracefs_option_is_enabled(instance, i));
-- 
2.27.0

