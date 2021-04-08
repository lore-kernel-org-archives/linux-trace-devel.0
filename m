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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18ADC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D10610E5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhDHOAy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhDHOAx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 10:00:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CD0C061761
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 07:00:42 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x4so2576492edd.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 07:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pKDm3+GxFvpE0BU6yXTHppPxiKAz97coAfSJVQVLE4c=;
        b=c+gKFpkNI5K7ZyjLyU4F6ZTJ08GXh8ulRVK/iqiJmNfX5DNr3HSh6XPK6f42BNusl/
         W4kksHDLNrjYeH4D6qa4ESMm03tl7W6myXbRr44bMQg1/+dbhaRrgR/VI7RsBcRfs2o2
         kzmbt4Dx9xvqDH4IN5397UQvirR8F1z4kGeKsNfBxOlhLNlowbvl7cx1wvU8KrUOd60y
         Qzd3cVpwdpnn6NsSTXBzMBV8goA0AJng1AXWiVJu9WsQyE3aPfoP63e3PGBkNEEQinzu
         8jqFD2m4sZV1kJkwDBdMsiHdLbTWnOXKTLbACf44UFCDsBIq3h+A6on1Bgje1p1By5II
         +fJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pKDm3+GxFvpE0BU6yXTHppPxiKAz97coAfSJVQVLE4c=;
        b=jF8mJOsKH24R/aF3RTjLoy/6T9GwIRBKlvEOFpRgAYhnBLqkaYdsjZgso0HC4XmWAM
         ey5zQUoAAUAdi68WhM1ghgUaPNYjWdGbGgAmL1OU1Jvs22n72WzetCc4EMipbD7CB6wn
         2H0/4jXVYp7NNG2C2etu2HeNDTLUCnL9bT613kY9miliTOela9YRg9z0bX5mv3tdStG0
         9LDluQViHusrfw4LiOBa3bKxh4h2HItBP5g4K1a/OdMFAHiV9CMGY+N3NiJE4GcvN8Rp
         4jSGDvOGoFKJ0AwPgpSy2X5YP3jPR86cGuEUUn/aw+oxMr7fRd/xOXDvzl3XNdxMiEPM
         Aa2g==
X-Gm-Message-State: AOAM532LmanKJjXWWudktDUFV+jrZhrgUb4v2Qi/NMDFbi91fRHLIRov
        pKUHyp8JgINvk/FtOYY65ek=
X-Google-Smtp-Source: ABdhPJyln0c4WjWADTBi69D6wx5dQ63nc2+2SHPPK48qg9GnIrS3fLcirKehC1ewNtztTDaENM4uiw==
X-Received: by 2002:a05:6402:520b:: with SMTP id s11mr11778901edd.212.1617890437937;
        Thu, 08 Apr 2021 07:00:37 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id jt18sm8212150ejc.96.2021.04.08.07.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 07:00:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 3/5] libtracefs: Encapsulate "struct tracefs_options_mask"
Date:   Thu,  8 Apr 2021 17:00:22 +0300
Message-Id: <20210408140024.13093-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210408140024.13093-1-y.karadz@gmail.com>
References: <20210408140024.13093-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The definition of the mask gets hidden from the user. This way we will
be able to modify this definition in the future, without breaking the
API. Such a modification will be compulsory, if too many new tracing
options are added in the future. Note that encapsulating the mask
definition, requires two API methods to be eliminated, however those
methods have no particular use-cases for the moment.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs-local.h |  4 ++++
 include/tracefs.h       |  6 +-----
 src/tracefs-tools.c     | 26 ++------------------------
 utest/tracefs-utest.c   |  4 ----
 4 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 6865611..076b013 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -14,6 +14,10 @@
 #define BUILD_BUG_ON(cond)			\
 	do { if (!(1/!(cond))) { } } while (0)
 
+struct tracefs_options_mask {
+	unsigned long long	mask;
+};
+
 struct tracefs_instance {
 	char			*trace_dir;
 	char			*name;
diff --git a/include/tracefs.h b/include/tracefs.h
index 95016c8..e1fbef6 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -131,11 +131,7 @@ enum tracefs_option_id {
 };
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
-struct tracefs_options_mask {
-	unsigned long long	mask;
-};
-void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id);
-void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id);
+struct tracefs_options_mask;
 bool tracefs_option_is_set(struct tracefs_options_mask *options,
 			   enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 25c0cea..fc9644a 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -239,8 +239,8 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
 				continue;
 		}
 		id = tracefs_option_id(dent->d_name);
-		if (id != TRACEFS_OPTION_INVALID)
-			tracefs_option_set(bitmask, id);
+		if (id > TRACEFS_OPTION_INVALID)
+			bitmask->mask |= (1ULL << (id - 1));
 	}
 	closedir(dir);
 	tracefs_put_tracing_file(dname);
@@ -378,28 +378,6 @@ bool tracefs_option_is_set(struct tracefs_options_mask *options,
 	return false;
 }
 
-/**
- * tracefs_option_set - Set option in options bitmask
- * @options: Pointer to a bitmask with options
- * @id: trace option id
- */
-void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id)
-{
-	if (options && id > TRACEFS_OPTION_INVALID)
-		options->mask |= (1ULL << (id - 1));
-}
-
-/**
- * tracefs_option_clear - Clear option from options bitmask
- * @options: Pointer to a bitmask with options
- * @id: trace option id
- */
-void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id)
-{
-	if (options && id > TRACEFS_OPTION_INVALID)
-		options->mask &= ~(1ULL << (id - 1));
-}
-
 struct func_list {
 	struct func_list	*next;
 	unsigned int		start;
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 9cb2a09..af28779 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -581,8 +581,6 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 		snprintf(file, PATH_MAX, "options/%s", name);
 
 		if (tracefs_option_is_set(all, i)) {
-			tracefs_option_clear(all, i);
-			CU_TEST(!tracefs_option_is_set(all, i));
 			CU_TEST(check_option(instance, i, true, -1));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 		} else {
@@ -591,8 +589,6 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 		}
 
 		if (tracefs_option_is_set(enabled, i)) {
-			tracefs_option_clear(enabled, i);
-			CU_TEST(!tracefs_option_is_set(enabled, i));
 			CU_TEST(check_option(instance, i, true, 1));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 			CU_TEST(tracefs_option_is_enabled(instance, i));
-- 
2.27.0

