Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23690C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 14:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D9260F44
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 14:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241308AbhIWOIb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 10:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241304AbhIWOIb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 10:08:31 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AD9C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 07:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=Content-Transfer-Encoding:Message-Id:Date:
        Subject:Cc:To:From:Content-Type:Reply-To:Content-ID:Content-Description:
        In-Reply-To:References; bh=hyNT8hVWFIKKdYgIRHK1mKW8+5FBpxBt9s7j/OKPqA0=; b=ma
        MBUiDVb79ohyvVhgXdC/wKT5iVTBaCOeVjAktZc3DBt881aodc+v4aZbUlxT9iCqBfNQySZldyIow
        9nCyzOev0090LsPIRFTZnWJ3L0MVOUTRFYrNtLvjsyQhQDsIZFX3nWsgBgpzRHTWVx/6EQg9Kms+j
        f6KZu9Z2QjM3NNhoL1JNoSemYT55j7ybskiLzz7O+usQN9AwDUVjnF6Ovi8v8znu9ybZdWZAmMKUS
        VtBRBcmkBhKfkKQgovjqDDbqgRxDL1ITrGDVqYmABqH6CDm6uLv1+GlGpCw0JHVlWNwZVH5otce67
        OcXwn6K2BKb4s+7zYMgvLLgmWkPDcZug==;
Received: from [81.174.171.191] (helo=donbot.metanate.com)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1mTPNH-0006Z3-D1; Thu, 23 Sep 2021 15:06:55 +0100
From:   John Keeping <john@metanate.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH] kernel-shark: Handle traces with sched_wakeup but not sched_waking
Date:   Thu, 23 Sep 2021 15:06:43 +0100
Message-Id: <20210923140643.3975473-1-john@metanate.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If sched_wakeup or sched_wakeup_new is avaiable but sched_waking is not,
then define_wakeup_event() returns true even though waking_event_ptr is
null.

Change find_wakeup_event() to avoid overwriting the output parameter on
error so that the define_wakeup_event() returns true iff
*waking_event_ptr is non-null.

Signed-off-by: John Keeping <john@metanate.com>
---
 src/libkshark-tepdata.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 865ca82..9740ed9 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1868,9 +1868,14 @@ int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
 static bool find_wakeup_event(struct tep_handle *tep, const char *wakeup_name,
 			      struct tep_event **waking_event_ptr)
 {
-	*waking_event_ptr = tep_find_event_by_name(tep, "sched", wakeup_name);
+	struct tep_event *event;
+
+	event = tep_find_event_by_name(tep, "sched", wakeup_name);
+
+	if (event)
+		*waking_event_ptr = event;
 
-	return (*waking_event_ptr)? true : false;
+	return !!event;
 }
 
 /**
-- 
2.33.0

