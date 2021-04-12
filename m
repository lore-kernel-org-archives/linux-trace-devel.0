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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F74C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B48906120A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhDLEYl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 00:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhDLEYl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 00:24:41 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65A0C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id m3so13374546edv.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4PXpAc5WkVB84h1ZR5tFupVeXA/cfUYY7F+aa6tzgbM=;
        b=Cxn30+o7laKruRu9ExoMZFteWFbGM9S0T4A5RZmgARdgHh6o89iW7L80JvWQw8nomN
         qXiSDq4xDjiE4VSuE0T5R07unEjmNwe7gCsV7bayc78swaNjo11DHKPilujd79rHlMNV
         jrbIUS1UK2jon8vrdIkW3FDW1r14Q/pTcNBnwfq0KolZ5oivRen8j9v26ZEFzoMGJeN1
         nkyUAEWzrPJ+yrhVq+ForSSkZKW373M/V/XTVOpjEOuLkJ/hhx2byit5SnjxFybU4Xf5
         UQ44F6HEBqSMc2SXTq6Q1JU0I8ltizwOCBQ0epuu4OvOppPj0++cvqYtGyeaW4MGOeP2
         G24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4PXpAc5WkVB84h1ZR5tFupVeXA/cfUYY7F+aa6tzgbM=;
        b=hch34SPWdTJ7iN26+xA7bcFMd9jTHIWtGI6Kdufrs67mECJMfKyC5yf0tkiHpAr3Ly
         PfLbuhyHlnATZ4nusU+guUk488ZMCqCgjb9Bjxf/5704CwTUJKBjIrTYQXKEWvvXURMg
         uJWL4jNlrQDFWiw/JweWCanCxBU0qVds8cujDlrhh80fT6LP4LbAmuBg9Aq7UCCjBBSV
         jxitedxHLPSo42GvPNTOeHCXx/rLBsn648CWr7yXzPAgTDocGXeaoMUBW5B4HJoxV5Hy
         lHouvQ0L2g/gZLQDPb8rSYzxFtg0JXwB5sC/EEXCTBioyTgXMhJJWpxwGTVu0LgvDBCs
         tTuA==
X-Gm-Message-State: AOAM530h2585T8Wh86Ha8XXYXwSe72oTC3VP2L9fe+Z+76PbI7abs1Px
        mVV51J3TFytfA7eQPLmOUAaMZ9rc+SH/qg==
X-Google-Smtp-Source: ABdhPJzHA5HDRHHc8i8QEtI/O/PUCNY2vUrJeaiXtQ+0isMepYhf1mY3hmE/Nlc98vN9KQjT/M3fDw==
X-Received: by 2002:a05:6402:3493:: with SMTP id v19mr28340701edc.355.1618201462632;
        Sun, 11 Apr 2021 21:24:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id bh14sm4926786ejb.104.2021.04.11.21.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 21:24:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] libtracefs: Fix trace options unit test
Date:   Mon, 12 Apr 2021 07:24:17 +0300
Message-Id: <20210412042419.3295237-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412042419.3295237-1-tz.stoyanov@gmail.com>
References: <20210412042419.3295237-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changes to tracefs library APIs were introduced by this patch set:
https://lore.kernel.org/linux-trace-devel/20210409180423.72497-1-y.karadz@gmail.com/
which make the option mask immutable and controlled by the library.
However, the unit test was not updated and fails.
Fixed the trace options unit test, to reflect the changes in the API.

Reported-by: Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1f48e6f..04b5e81 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -679,21 +679,11 @@ out:
 	return ret;
 }
 
-static bool check_options_mask_empty(struct tracefs_options_mask *mask)
-{
-	int i;
-
-	for (i = 1; i < TRACEFS_OPTION_MAX; i++) {
-		if (tracefs_option_mask_is_set(mask, i))
-			return false;
-	}
-	return true;
-}
-
 static void test_instance_tracing_options(struct tracefs_instance *instance)
 {
-	struct tracefs_options_mask *enabled;
-	struct tracefs_options_mask *all, *all_copy;
+	const struct tracefs_options_mask *enabled;
+	const struct tracefs_options_mask *all_copy;
+	const struct tracefs_options_mask *all;
 	enum tracefs_option_id i = 1;
 	char file[PATH_MAX];
 	const char *name;
@@ -743,11 +733,6 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 			CU_TEST(check_option(instance, i, true, 0));
 		}
 	}
-	CU_TEST(check_options_mask_empty(all));
-	CU_TEST(check_options_mask_empty(enabled));
-
-	free(all);
-	free(enabled);
 }
 
 static void test_tracing_options(void)
-- 
2.30.2

