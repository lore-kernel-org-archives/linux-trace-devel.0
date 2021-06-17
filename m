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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CBEC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 09:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B3B613EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 09:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhFQJqp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 05:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhFQJqp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 05:46:45 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DEC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Jun 2021 02:44:38 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ji1so2655706ejc.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Jun 2021 02:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mtPYWcF651fawj28E768wqib/Tj2HEVR2ofyRvmCMIU=;
        b=fZAqAAG5WgNdj7B2Pi5PhfusZd7dvNgvndRDfaLAgjCF81NZGiufYFJIftB2grxwZh
         CVYsO8UuP80Zooqwna9LRj/uTW0NZpecdcrHJKmx3IuloD+n1p2lmVJNNTdWBGRaJoPn
         QgXcQZWiyf2lUL1e2c42zYW/+KNS+QYxWQ2aM3kFnBILZnMQO5hyzSPkyjve46R6PD9a
         8PVBOy2LG6JDaPrpjaJAyxlG37EsTKJahhs5BzAOydRBvwQBtmhsQq0qo7RJNVwkFp5/
         5LFMfL/0EEjCRS20wiLIbpJYLg3cgdo65kSJO9bRuSj4HOBuUv5GSefl2yYWC9GeT3dK
         nJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mtPYWcF651fawj28E768wqib/Tj2HEVR2ofyRvmCMIU=;
        b=ne30kIoxWrqg5u1adCAtcmkre9bfiWz3NsfwrOVxTEmkscWI+7UedhI3zdJ97ejlxm
         OgplMK4CFq8U9WUYw2PIdTEIgqC8Hr57NzN0EEHonU/QmWJJqqiU8D+mbTJJ7OMG7fM2
         ajMtHEoahbCQHBRehGa2nS+7IxlHGfoHrx/tlzI9+gVRUBRsdRLoBx1wi3xB15nikiok
         9WPiRMuftNKxRllZReTP91OUqYhPZ+ZVW9RpCU0RLWiaLSkMchMhTiPCwtMAdiVE/MWx
         oTRa/EWIa0XldgJO3FeqK97SiDwQOjOtqsWruM9zorHu+X758Q6GwLPghuVJ052wwRLA
         Pmdw==
X-Gm-Message-State: AOAM531aJrBn2pcssktI4CRWShsIct2a8+Nc2UjGdiLd/2LY5jn6L1ob
        LXjbG8Hy+ci9FGmzflni6JDQFPuyBV8xhQ==
X-Google-Smtp-Source: ABdhPJwU7ub9XYk1s2ZWEkjIAwVIrXswDvy/tKzgxDWVqnkE2GhxyVhJGqFBiSUXiMZSF9l8VPMhmw==
X-Received: by 2002:a17:906:d15a:: with SMTP id br26mr4362109ejb.232.1623923076683;
        Thu, 17 Jun 2021 02:44:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s18sm3434154ejh.12.2021.06.17.02.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 02:44:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Add memory test
Date:   Thu, 17 Jun 2021 12:44:34 +0300
Message-Id: <20210617094434.1367452-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New makefile target is added, which runs the library unit test on
valgrind, to check for memory allocation errors.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index d35ceef..e0f41d5 100644
--- a/Makefile
+++ b/Makefile
@@ -182,11 +182,28 @@ libtracefs.so: $(LIBTRACEFS_SHARED)
 
 libs: libtracefs.a libtracefs.so
 
+VALGRIND = $(shell which valgrind)
+UTEST_DIR = utest
+UTEST_BINARY = trace-utest
+
 test: force $(LIBTRACEFS_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
 	$(error CUnit framework not installed, cannot build unit tests))
 endif
-	$(Q)$(MAKE) -C $(src)/utest $@
+	$(Q)$(MAKE) -C $(src)/$(UTEST_DIR) $@
+
+test_mem: test
+ifeq (, $(VALGRIND))
+	$(error "No valgrind in $(PATH), cannot run memory test")
+endif
+ifneq ($(shell id -u), 0)
+	$(error "The unit test should be run as root, as it reuqires full access to tracefs")
+endif
+	CK_FORK=no LD_LIBRARY_PATH=$(bdir) $(VALGRIND) \
+		--show-leak-kinds=all --leak-resolution=high \
+		--leak-check=full --show-possibly-lost=yes \
+		--track-origins=yes -s \
+		$(src)/$(UTEST_DIR)/$(UTEST_BINARY)
 
 define find_tag_files
 	find . -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp' \
-- 
2.31.1

