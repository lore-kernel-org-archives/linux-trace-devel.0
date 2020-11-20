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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CA2C63777
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 642BF22227
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmUOg8PY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgKTJn1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgKTJn0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:26 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D2EC0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:26 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id q3so8809512edr.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=di/IFbD+AO4Z8oydLIU54ALnPl09tvFd6gvayVOcah4=;
        b=bmUOg8PYRw6Q+WC2uR1mZwCAExNDe9JT847Tb9Aa42s9VYEXA5HBwqNZUYA5j5pQe9
         pOWN4TjclxgUIKhsqT7u633iIkBGCF1K3Bpt/1ZNE/6GbgKOy1iYJZ/g26/0Ov2IizgJ
         EEe52nYGorf5lRs9UsFXASlsRdQXvHqJS8tu8vjLD6mKVquktAqxeX/XGhO3oMss8UhA
         U4bz1LWIcz/+SBdsF89lh/RKp8zFOmAtJTCyVFcuiYAOYUf05ux2T0JkXn3xYAtDZDuR
         JayRGjQmErlSgkDo/Gw4ndFAG7IQa+12SE9eZv5FyJxQndOmF8uaRp/ltRoC6bRAQ2eW
         /YoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=di/IFbD+AO4Z8oydLIU54ALnPl09tvFd6gvayVOcah4=;
        b=E3emVfTe5naxfz3HCtEW8fU4lGSR8yb+P+c5eC1uCsQ24qePCOcU/o8yvHhL+zsKM2
         lQ44psu+NHe9pR/zrUyLqfE7jGiwwtbxp64+BcAq3NkHojQxIMD5QyVsQV+mtOrv3tLl
         cFlkWkJO1PUpq7GybZ0T+knRa8HT0aJREFXhdGlb8xpybvvQ2lKqeIPLKUSykB4FetZD
         7gG3LALMVjxP/TNp9pTluSPhHM0ME8AlRS2hjA14kkNkbctLLjurcwxt9mmkjQ71ig/0
         AJv8Th++Y3pyE4lvJQCMfoi4WZxghv1ci37QVKeehaXwtItdxJyF8MWaX/KvSDXr3ZZZ
         bzRQ==
X-Gm-Message-State: AOAM532ccnWDktfew5mbK/iJeQIwCV/cBXL7XbQMF8x1RIlY3cGo8hna
        HV8oLmAismU1Pc+oyABsOYUyhp/edkQ=
X-Google-Smtp-Source: ABdhPJwTAWYLUrPiwRCAgrpOosnJPySWzFub5tq1KcAsU91W+KAOp94iL9NEbIboISIDcRVyR5F8fg==
X-Received: by 2002:a50:a45c:: with SMTP id v28mr17589185edb.329.1605865404873;
        Fri, 20 Nov 2020 01:43:24 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:24 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 02/20] kernel-shark: Add stream_id to kshark_entry
Date:   Fri, 20 Nov 2020 11:42:46 +0200
Message-Id: <20201120094304.271502-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

kshark_entry contains all information from one trace record, needed
in order to visualize the time-series of trace records. Here we
reorganize the data fields of kshark_entry in order to make room for
the unique identifier of the Data stream this entry belongs to.

The Id is coded in 16 bits that are taken from the "event_id" field.
So far "event_id" uses 32 bits but we found that it is coded with only
16 bits inside the kernel, so we still have 16 unused (spare) bits in
it.

Because the stream Id is coded with int8_t, we need to set an upper
limit (127) for the total number of Data streams loaded.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/libkshark.h b/src/libkshark.h
index 9eecc2d0..7d8b53b0 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: LGPL-2.1 */
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -51,15 +51,18 @@ struct kshark_entry {
 	 */
 	uint16_t	visible;
 
+	/** Data stream identifier. */
+	int16_t		stream_id;
+
+	/** Unique Id of the trace event type. */
+	int16_t		event_id;
+
 	/** The CPU core of the record. */
 	int16_t		cpu;
 
 	/** The PID of the task the record was generated. */
 	int32_t		pid;
 
-	/** Unique Id ot the trace event type. */
-	int32_t		event_id;
-
 	/** The offset into the trace file, used to find the record. */
 	int64_t		offset;
 
-- 
2.25.1

