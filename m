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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB5AC43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9DC16115C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhDISE5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhDISE5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:04:57 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2906C061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 11:04:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e7so7541191edu.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Apr 2021 11:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GVLlV2nAXvbGrvSDwkLlelxPxN7BE4Od/Uc6/YVFALQ=;
        b=Hb5/REmmS+2g5G2Z5AEPyAdcZ/L9QuI7mLDa9LCQwz8FNpIEc2s0bCPlrVlIBmt42m
         XCS/foXPfEXDpc0tsOCWiMRmdgiOP9N2OA5q2eXVTmHVTL+ybjCUfVus2jI2I7gr9QHG
         0ie5Wo6nkr7OSTsoausFbaGLFOKdqQ+pybXvRLA3dipTzE/jkucjHypX6PVut1zr5GOZ
         O4lI+zknZn57YkgVRbTS5r15sXqtYwaBj+tvovSfxoaQfqiju+zfkh9NT2wUk1c/Do/y
         UMG0IWBWkpbiMx2hZBz9/eFonq4XHkA8r9aPnC9FLjQwh4Bjq36ambE+3ZGwlDPfqhc5
         7WzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GVLlV2nAXvbGrvSDwkLlelxPxN7BE4Od/Uc6/YVFALQ=;
        b=VUjHFurGmtm04ndp17q9UAo1/rn7oG9a3xbzB73yQVAn3lO38YQFnlpnjapRo6OgLK
         ChW5RQEjSt8WzHDdQq9453RF7M5Zr3GE6C4KOfv2ag8x78VUE9dFaJ4tmNIKLgqU10av
         E16qATTkWCvXe9tjhgmx7TMnUNPXZQrPpdaxJYYGwJI+4MAg8IQkp2Damubs4T3Tv6cA
         Gn5YtDYYSKGewhyxW6M0ynPHIyr249QPkZJfHY6e3kLCXFVQblUSmFaFwT9h2Z7/j1TP
         aIVfHUriBb5+rdPNRkDmVZPI5bDezHrQ40YW7JcNllGmiDkEzsOnLpt5HIPUOo71g8+o
         VXfw==
X-Gm-Message-State: AOAM531FHnkHm/CNG+gQ9fmOiFBfIr7s7na/fGFAqVAsWhy2fLKerLXb
        b0AAgyBXECHnpY0sdAfrYO8=
X-Google-Smtp-Source: ABdhPJxdyHysBLUIYaCn/CS2Jzwv2BFUML4ddSfv701s6gO0Bc0Y36Huy23io/IzExR2HZp5H52xbQ==
X-Received: by 2002:a05:6402:142:: with SMTP id s2mr18742264edu.2.1617991482725;
        Fri, 09 Apr 2021 11:04:42 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id b14sm1865568edx.39.2021.04.09.11.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:04:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 5/5] libtracefs: Rename tracefs_option_is_set()
Date:   Fri,  9 Apr 2021 21:04:23 +0300
Message-Id: <20210409180423.72497-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180423.72497-1-y.karadz@gmail.com>
References: <20210409180423.72497-1-y.karadz@gmail.com>
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
 Documentation/libtracefs-option-bits.txt | 10 +++++-----
 include/tracefs.h                        |  4 ++--
 src/tracefs-tools.c                      |  4 ++--
 utest/tracefs-utest.c                    |  8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/libtracefs-option-bits.txt b/Documentation/libtracefs-option-bits.txt
index d713a5e..10e832e 100644
--- a/Documentation/libtracefs-option-bits.txt
+++ b/Documentation/libtracefs-option-bits.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_option_set, tracefs_option_clear, tracefs_option_is_set -
+tracefs_option_set, tracefs_option_clear, tracefs_option_mask_is_set -
 Set, clear, check option in a bitmask.
 
 SYNOPSIS
@@ -14,7 +14,7 @@ SYNOPSIS
 
 void *tracefs_option_set*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
 void *tracefs_option_clear*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
-bool *tracefs_option_is_set*(struct tracefs_options_mask _options_, enum tracefs_option_id _id_);
+bool *tracefs_option_mask_is_set*(struct tracefs_options_mask _options_, enum tracefs_option_id _id_);
 --
 
 DESCRIPTION
@@ -27,12 +27,12 @@ _options_ bitmask.
 The _tracefs_option_clear()_ function clears the bit, corresponding to the option with _id_ in the
 _options_ bitmask.
 
-The _tracefs_option_is_set()_ function checks if the bit, corresponding to the option with _id_ is
+The _tracefs_option_mask_is_set()_ function checks if the bit, corresponding to the option with _id_ is
 set in the _options_ bitmask.
 
 RETURN VALUE
 ------------
-The _tracefs_option_is_set()_ function returns true if the bit is set, false otherwise.
+The _tracefs_option_mask_is_set()_ function returns true if the bit is set, false otherwise.
 
 EXAMPLE
 -------
@@ -45,7 +45,7 @@ memset(&options, 0, sizeof(options));
 ...
 tracefs_option_set(&options, TRACEFS_OPTION_EVENT_FORK | TRACEFS_OPTION_FUNCTION_FORK);
 ...
-if (tracefs_option_is_set(options, TRACEFS_OPTION_EVENT_FORK))
+if (tracefs_option_mask_is_set(options, TRACEFS_OPTION_EVENT_FORK))
 	tracefs_option_clear(&options, TRACEFS_OPTION_EVENT_FORK);
 ...
 --
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
index f539323..15ad3b6 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -359,14 +359,14 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
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

