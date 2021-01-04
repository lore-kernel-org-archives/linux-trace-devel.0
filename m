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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3ADC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6ED20715
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbhADRtC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbhADRtC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:02 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754D0C0617A2
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:47 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id cm17so28242963edb.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QLycbyjL0opw4QhyZtP6Cd/e066iSR39csPtYlEnn3M=;
        b=mhlCcacpvEatVU9SNZgThKE1ZnZSXlL2ybozy5B020jrc0z+KTADcjmeQIrrZOIaGW
         r2j4Xru8RGuhmYtcVFPXkRhmPMGy0elj9Bn7bLRrVYfiBAjekgs1vsXgS9vcN63T4hTn
         DCI6zRvs+12cxgijT9qfIh4wFc0o8mnhMpJBU4ovIw3vbhY2a5W1xaJCQFfmeRhbu/lb
         hTwaiO2qvBHp5ERQvWovr8LPFyFNhlCuPufEtIGGjJvdwe5bkh2l3UlreGtzFSv8Fwwr
         6Vp8vUvPcAOltcES/+lQD/VYQO1C7IlfHP9iomx9JCFRghpTBkESwF+S3c+ykgUoMbzV
         SlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLycbyjL0opw4QhyZtP6Cd/e066iSR39csPtYlEnn3M=;
        b=MNaVERERIyJAALp1Of3MZ/c3YufcX52baBzqsLEXL1nnhk0ZEzc7tfad1oVMjRTrNt
         PL2q3owRQRj5SeNPWXfdDJsCk7TUBl5I4ibDR+RDGK911kPL5yClwZ0lcS3u6ZYjQew+
         YlnTWOfyH8yH4gDDh6TclDNegpo+FgyQhia2L5NhEFBh9AqDyozwj1KP3TTWXU+cGu1g
         Eki8tYOBuhTDEVbMtuve1XLMhncWgq62bWrSnuD8cg3y2LMq31QRbVgGMB2UmnKPC6Q6
         9TQtYpCZ9L5hkKoCnsyaRIX51q8POzHIEtQr/3wWoBW+pEKpyaLVQKOi+NGj8gBNVKMM
         fm8w==
X-Gm-Message-State: AOAM533MvkZa69yTdvwWjNFRbPvA+A2iRbzZfOhPs7UBGYFWsm3jKF/g
        b7avPkWiJApBEPH0FaLMCDA=
X-Google-Smtp-Source: ABdhPJzVY5Ini2CA/e+4XI0zCg7eL8fYJJWNicf3iJ7l1qQQK1TrOgD0l0bMnoZ0usHBZcsKCPZpnA==
X-Received: by 2002:a05:6402:d0a:: with SMTP id eb10mr19199055edb.305.1609782466297;
        Mon, 04 Jan 2021 09:47:46 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:45 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 10/44] kernel-shark: Add stream_id to kshark_entry
Date:   Mon,  4 Jan 2021 19:46:50 +0200
Message-Id: <20210104174724.70404-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index 3b57e0b..f279d16 100644
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

