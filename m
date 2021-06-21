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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C43EC49361
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 08:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD2C611B0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 08:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhFUIvo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 04:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFUIvn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 04:51:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B162C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 01:49:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id he7so27423352ejc.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Jun 2021 01:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qHXXJ1Qf86fLbiKRHZoZzaKglScrxnuzC3xQaVrbrxo=;
        b=FTfhxHutwP6mqiZ7P9cOc0GEjOGUz8GHIP9JU3dbbdCKYGjHx2hjKmmvt+nyyhEa1e
         a9/3LCvTAyKEuLUWT59ka/DkCFnRtowbOAB3RwsmYOebhkhx+DlfKN0uBjHsTZS/o5Tc
         Mymj4S0SB1Jkva9Hcq5ROhT4fkPv2O2lpygToSLHmt8UUoxP0xP+qaJW0LDcyZpnz5pe
         cOy4iuW4b6x45UZ59KdFFx7xmWatQ+u8gqdgKtqbP8Y7f8wwhuGsrwPPWwHZlDpOjuRU
         df2z3HKSvkGCOKJxJWtFk5QAY0Nj6kHIL8ivyJ3a4w9RDEEBOYxf6DdjAi2iC3GZJN8h
         dUfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qHXXJ1Qf86fLbiKRHZoZzaKglScrxnuzC3xQaVrbrxo=;
        b=SpvYVjHpFg/RylluYZBiOeey2wZkCBRwENpv4kTvOZdZbto3zkoTL3CEgVUpluAAP9
         ut27tBed19zg857rH7+6x6oJ14KvWp/dAJ9ZgGf0u/Fbwh/smO+ldWOtf1VQDzeDt2cW
         2DcFjev3foWqw3FYENHOyPivlOkrBtQIJqJ4QJ9BHOmGS5HFlCfFQjS87D2Qcv+lEgVH
         KUWAVCu1nJkDUbZxPjt8TYxfDulYg8ucVML0jEO2Yp57VjtSZsq1Pl5WfAEhXx0Wgi8D
         OGdGzXy96FU5ac53MDOeB6MsLcKvkrtDdSNZ9zOrZlcIhc+Lnnaz6UYnP6Rlrca3Hs9K
         nuKg==
X-Gm-Message-State: AOAM531f1zZz75n6/+ouUYVC0I7+EPF9SP1o7WcuSwIoPAIjoTiQ1O96
        UKomJzR3twPCQVwgf7bVV0A=
X-Google-Smtp-Source: ABdhPJwHZ7Nw94u9EGCd67PvVeSCJpxldII6g8kac0bnwbu5khX1rgQSof481WQTwZ5P9XtHZkN3Ag==
X-Received: by 2002:a17:906:17d8:: with SMTP id u24mr23749930eje.106.1624265368062;
        Mon, 21 Jun 2021 01:49:28 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id s11sm9608656edd.65.2021.06.21.01.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 01:49:27 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] libtracefs: Fix utest compilation
Date:   Mon, 21 Jun 2021 11:49:14 +0300
Message-Id: <20210621084914.336821-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210621084914.336821-1-y.karadz@gmail.com>
References: <20210621084914.336821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The typo in the name of the API was fixed in a previous patch,
but we need to update the unit tests accordingly.

Fixes: f415871 (libtracefs: Fix typo in function name)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 utest/tracefs-utest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 9186656..a982b1d 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -729,7 +729,7 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 	CU_TEST(!tracefs_option_is_supported(instance, TRACEFS_OPTION_INVALID));
 	CU_TEST(!tracefs_option_is_enabled(instance, TRACEFS_OPTION_INVALID));
 	CU_TEST(tracefs_option_enable(instance, TRACEFS_OPTION_INVALID) == -1);
-	CU_TEST(tracefs_option_diasble(instance, TRACEFS_OPTION_INVALID) == -1);
+	CU_TEST(tracefs_option_disable(instance, TRACEFS_OPTION_INVALID) == -1);
 	name = tracefs_option_name(TRACEFS_OPTION_INVALID);
 	CU_TEST(!strcmp(name, "unknown"));
 	/* Test all valid options */
@@ -751,7 +751,7 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 			CU_TEST(check_option(instance, i, true, 1));
 			CU_TEST(tracefs_option_is_supported(instance, i));
 			CU_TEST(tracefs_option_is_enabled(instance, i));
-			CU_TEST(tracefs_option_diasble(instance, i) == 0);
+			CU_TEST(tracefs_option_disable(instance, i) == 0);
 			CU_TEST(check_option(instance, i, true, 0));
 			CU_TEST(tracefs_option_enable(instance, i) == 0);
 			CU_TEST(check_option(instance, i, true, 1));
@@ -761,7 +761,7 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
 			CU_TEST(!tracefs_option_is_enabled(instance, i));
 			CU_TEST(tracefs_option_enable(instance, i) == 0);
 			CU_TEST(check_option(instance, i, true, 1));
-			CU_TEST(tracefs_option_diasble(instance, i) == 0);
+			CU_TEST(tracefs_option_disable(instance, i) == 0);
 			CU_TEST(check_option(instance, i, true, 0));
 		}
 	}
-- 
2.27.0

