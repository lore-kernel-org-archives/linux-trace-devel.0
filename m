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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EC9C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0B323329
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389670AbgLKPKC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392684AbgLKPJg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:09:36 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9943C0617B0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:19 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a11so1634071wrr.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=Ep96gI9/zB5EccbcXk5zAEfd+KbHZ5Bo5TjfxZrGc8WWNKZ/ULCwpkeKOw9u3PlwMB
         l0jqhYqhuiPWrtZFQla5XCXtG4j2+jDSeiAgBPX5aC4Tr3oggrmqesIFyc3pGPTLk8EJ
         TRo8EefE4s/39D5JZ7LB1zfdQXAq3Yc4WRiobHxUis38gwbd8lsu16mc9LzIdijzV6gR
         h9XGtK4poJ5g7g6FUdB/dsGTykeaAsIs4pYm912VJ76JEhoPe3lVHPgE1geopzFJloy4
         QPjgy/gAoxOcbeYato58hBXeGQRy51hCGaSETEwDnVtdcrvIn0yARN7wRHeAT1YdLypA
         51RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=KtmCNoeXSadRCb1BPbajWXcUf7oMkcrI1GtOGLLSw+e5rrNLCYbVazN4kZtdWte3nl
         Q4EuFU2VYzmeEuCS2NbsCllWqh8pdDnoCxXs0EJ3J/6sbg9tAl3DEZDyTHq5gAwDJ/rn
         SO2Km78nFQ3qq3iTQX8D8mAWtxjdrptXEQVwMSqsi5Thdv6EjxEiiVweyDp/jJJS0ecY
         js+P2TCbKjM6wZWNq4N/2Af0ZcBelcTDyoBgtZwyfgmF7U20/KYyA3CJDAG0uxe1PxdA
         HGzsQn1AWSJeUyM+Nm0ASZulFZQNZvbHQkSlg+e2NzrGMZKl2/cfQvcg3TJhyaeHPJe4
         WkMg==
X-Gm-Message-State: AOAM531/zfrwm3Y4g7UDecJ66JwpZ3zHx2v+5pJ+VQsx89OY5sXhKDEZ
        3BCuIo5iYdD4QMe6N6FeoVYH5/7DYbU=
X-Google-Smtp-Source: ABdhPJwQCGHt4ser66TvzE5T29IvYp/ozunwttdCV2tzzlRWmwB5fVvD8NxQUEHQcma8Rlxd5JFB9A==
X-Received: by 2002:a5d:4b4c:: with SMTP id w12mr14328763wrs.402.1607699297151;
        Fri, 11 Dec 2020 07:08:17 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:16 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 06/32] kernel-shark: Use only signed types in kshark_entry
Date:   Fri, 11 Dec 2020 17:07:30 +0200
Message-Id: <20201211150756.577366-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using uint64_t for the value of the offset was just wrong. According
to the POSIX standard off_t is a signed integer type with unspecified
size. Here we stick to a 64 bit integer, because this size guaranties
optimal packing of the kshark_entry structure.

Using unsigned values for the timestamps is also a source of problems
and has been a reason for the introduction of multiple bugs in the past.
In principal the value of the timestamps cannot be negative. However,
this value must have the same type as the values used to define the
state of the visualization model, like the range of the model or the
size of the bin. The model state definitions should not take negative
values as well, however their values are recalculated automatically when
the user browses the data and those calculations may result in negative
values in some corner cases. Because of this it is better to use a
signed integer type and treat the negative values as an indicator
of an error rather than have the negative result of the calculations
casted into unsigned type which results into unpredictable behavior of
the model.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libkshark.h b/src/libkshark.h
index 0d6c50d..9eecc2d 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -61,7 +61,7 @@ struct kshark_entry {
 	int32_t		event_id;
 
 	/** The offset into the trace file, used to find the record. */
-	uint64_t	offset;
+	int64_t		offset;
 
 	/**
 	 * The time of the record in nano seconds. The value is taken from
@@ -69,7 +69,7 @@ struct kshark_entry {
 	 * dependent. The time usually is the timestamp from when the system
 	 * started.
 	 */
-	uint64_t	ts;
+	int64_t		ts;
 };
 
 /** Size of the task's hash table. */
-- 
2.25.1

