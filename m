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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DD5C11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 14:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AD9E6144B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 14:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhF3OVz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 10:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbhF3OVy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 10:21:54 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED60C061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 07:19:25 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o33-20020a05600c5121b02901e360c98c08so4542684wms.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 07:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWBcVTgMCF2mvMjJbRmp9h3BfaZjXxsQKVdFZZ8Idr0=;
        b=VEBiHC020aVeDZqdZpv+pFfDQZNb8duQQeR88zkee6PTjivB5atSwYssMr0xdAuPGR
         Yh70eTGG5tTpUX0qPmjuXiZITYJLHfWfIB3W7d6UcnI4s3F409czeBXFhDRCEIUz/Tm8
         yeSqAmte9EDfUdNlFS0RR8zLBZRfzBEqna0N2M/HV5rwl8LlXEenPAi6eZOcaK2WEs5Z
         i5w19QmXxRl7zFV4ndQPw+XXRec6kKbW817FBFpqP2jqlzfDAsfy9DO6Ql8tXrETsZgo
         bZ6/ahCfagLmCcbP1sWmPAnK8zoAgARQkkX9EPX4/SC4iqCchqcXFEtmetgVKyqCL5iv
         WrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWBcVTgMCF2mvMjJbRmp9h3BfaZjXxsQKVdFZZ8Idr0=;
        b=Umfo5++Is5IJID+9bmdBtL+9NHWILMP7UH+8IRrXRm4XmgRSXb6uB3VEFQa4TOPrxe
         6MxPYM2pcl22JI4w6rolXRfM83X3bC3r0600okgZKuMGD1bLNFyftgVbr4E7niQBVCUL
         nr5QEzLgrcXrgN4W0G7hcdk5EZXYqPfc8QVHgKrGeVS+IxiSEigvm08RgHOyHYtGvNUd
         KcW+VhehnCdSgyCwu6VWhBDk/oMZ2Mmp3cWT7kxTJYvGiFP34GhTtlKSzrj1MLnRz9SD
         3b7aInR4SPGU7A/XPfMQw9vY+oBySU/a68SJ0swZp3bh4Mq6coAWgc9gkG1UVtJVmL/X
         r9KA==
X-Gm-Message-State: AOAM533Vz+eWL8Qi2+3V3xNaNabp4NRIVcyQlE5GPzS41nGoKz1sErl4
        Pg9GtK/rr1MtLRSDe8rS58I=
X-Google-Smtp-Source: ABdhPJx4Hjtrboiy7X18SKMpGDWcVPbDFzDBQ9zvhcYFCu4l9E+62tUAPY3aeMmlMAVOxVwypap0lQ==
X-Received: by 2002:a05:600c:2301:: with SMTP id 1mr4924004wmo.132.1625062764453;
        Wed, 30 Jun 2021 07:19:24 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id r12sm22935958wrn.2.2021.06.30.07.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 07:19:24 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtraceevent: Fix bug in tep_print_event()
Date:   Wed, 30 Jun 2021 17:19:13 +0300
Message-Id: <20210630141913.20675-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We must handle the case when the "tep_event" object is not found.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index de28b3b..d3f1bba 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6418,17 +6418,21 @@ void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
 		     struct tep_record *record, const char *fmt, ...)
 {
 	struct print_event_type type;
-	char *format = strdup(fmt);
-	char *current = format;
-	char *str = format;
+	char *format, *current, *str;
 	int offset;
 	va_list args;
 	struct tep_event *event;
 
+	event = tep_find_event_by_record(tep, record);
+	if (!event) {
+		trace_seq_printf(s, "[UNKNOWN EVENT]");
+		return;
+	}
+
+	str = current = format = strdup(fmt);
 	if (!format)
 		return;
 
-	event = tep_find_event_by_record(tep, record);
 	va_start(args, fmt);
 	while (*current) {
 		current = strchr(str, '%');
-- 
2.27.0

