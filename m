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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EFBC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB4520657
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406325AbgLKOqC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406331AbgLKOpx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 09:45:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167ABC0617B0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:29 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r7so9288178wrc.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=fAwam8/n7ZbkXwT0VUBxL0VQ1Vze/oj/ob1tA25xWurleSNUimIhye4cCvMYYxOOQV
         Rh4OH5s3rX1SG0IKZjLy6bS6coEhpUBNut5P3cwwZ/cJYJXtl5q+r0ONhwIwh/qhvZgL
         ioa8Y7UoqoFiBjBMMxEH8JQ8RR3c1OOIRX0MHj+UaOwF7vag60ASyF51VQRZXLhqbKux
         gXk5EEux2kJofyWFaqlPqSTSQvD85J9cxunMv8yIbL8cIHleFf+TgDe2c0yhXz0zTER6
         dIzCvEowyu3pSskk0/eHfKzt6deM1HsguRjmfogWLyD4/yM6PLGo6TlXlNaU6QPLzllX
         D8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=Es5oknj4kAyv8VotWZ233A8b6DLMfHUUGvXwIPCjePlF1LSYJav8HYxQMKReUjxMnr
         7d9V71NsHrkuBRvMQxHPMrvxOFB+nyOiBbCjOQgFnyd77yCodR4i/g3f85s8zJqWF78X
         ZVsPsCdWOGSO62tUA6B0vctnAPA2slwwLRpVPrL6BHOFykv4BgESXqXLKQbmhtfUXGBD
         vQcNSdDC1TOFC8JsLTaTLxoKV2tA39jB49TJ5YOGqcjbSYfsnClthZqr8jop2E7rFi8R
         XoT/RqKsBzjPwXMD76KrjkHV3p796ev1AaQGI9Y5I9ldH7ba4iUElUmlih3TMnooXyxz
         kLHg==
X-Gm-Message-State: AOAM532JffjB4LVs2uwbWVQ2KwD0VYDMD1scb/r3dxNwiBZjbKz2QT83
        G25lUHJsdEhXEtbbTplf4Dc=
X-Google-Smtp-Source: ABdhPJzy5EcjDctVxpwBfTjYvPBrlCGuPHaOS4QBzFFIAA6rRhgCfvf1HUuCYbyoVO2fRHKm0LNzuQ==
X-Received: by 2002:a5d:4c4d:: with SMTP id n13mr14480698wrt.356.1607697927832;
        Fri, 11 Dec 2020 06:45:27 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id y2sm14471471wma.6.2020.12.11.06.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:45:27 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 06/32] kernel-shark: Use only signed types in kshark_entry
Date:   Fri, 11 Dec 2020 16:44:45 +0200
Message-Id: <20201211144511.575346-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211144511.575346-1-y.karadz@gmail.com>
References: <20201211144511.575346-1-y.karadz@gmail.com>
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

