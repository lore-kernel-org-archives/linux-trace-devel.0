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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B651FC43461
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 897CD610E5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDHOAv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhDHOAu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 10:00:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F45C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 07:00:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e7so2537179edu.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 07:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HKUHAOpNrUrKqASrdS1VZ77GIFGbq5QAtjB5KFl/0SU=;
        b=FnP0kXHBvdBTYJyh0R81FRToIAcdjYgmCu6DsUGsAAHdLmvfgcb7FUd2WeSZWbonYm
         2sk8w/g5iB1uZnCvu4uFNG7v0LDlE3y10aabdZcBDso8MCybYAj8e4VEghyrvj0aTL+5
         nYLKIRv/5ltRFwYL9hcufzE0sM1koaZhEkgW2QqNrXDJ/KrX7qx0HnZ0tfXckFf0UO4t
         l1qEFRI25T6b68p2PJKgFEWobxD6Mjtj9keLtD4H+JerafGs41Z8hr5MGnjBcH16l/WM
         wpOpW7YIvPWqEdxw1aQ4kVW86jw7UPtGrYE4GQb8dIckvSChXeHOhVRDNEbeVdP5VAgF
         egTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKUHAOpNrUrKqASrdS1VZ77GIFGbq5QAtjB5KFl/0SU=;
        b=hlX4X/XHPQ6tteVy0j2ow2YQy+HMxq/7aI9plcXhMqqS9BvdyaKSsYEXJOLA6ygJVI
         SIjZmlT44iAahLhq3ZEjWgWAVP+6x/0VVau9v6n6Zpyv+juaX182LvzSzMo5zrZ93mlD
         z52nmnQSulMhsMU2zgLl0+hTeu2+95z81iMWKV50K1c8izdJkU+wpdyGIhI3PlliUgNN
         /W3mAs3aDeS3DOrU87VcAPQMn1h/vPk6/FuqBkq+abcGXMCzPJnu1r3wHazyCaYqRoyz
         s/4rFkMBoE+NaiDaEkXGXrEYG0k0ZHscik+DBM2lqNS8Y+2eu8N9L9qjOrCTxnxLkGba
         SZbA==
X-Gm-Message-State: AOAM533b2ZCpJLC7xznQlD/fpPp9E/DPSJGYUzwbUCjdbeB4j+yvITE3
        fhQGgZTdQbIOvCBGWa69KaCM/rf6Ounlvw==
X-Google-Smtp-Source: ABdhPJxPKIKKNAF7ZwC1h33JiotteEQFqJ4d3E0MJK+T4X8m/gEoI8ORjwMtY5EpcRFoawV5QYf88A==
X-Received: by 2002:a05:6402:2786:: with SMTP id b6mr11656217ede.310.1617890437144;
        Thu, 08 Apr 2021 07:00:37 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id jt18sm8212150ejc.96.2021.04.08.07.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 07:00:36 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 2/5] libtracefs: Modify the arguments of tracefs_option_is_set()
Date:   Thu,  8 Apr 2021 17:00:21 +0300
Message-Id: <20210408140024.13093-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210408140024.13093-1-y.karadz@gmail.com>
References: <20210408140024.13093-1-y.karadz@gmail.com>
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

