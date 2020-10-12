Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045B2C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C22712080D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQoxNHv9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389326AbgJLOE5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730739AbgJLNgB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B16C0613D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:01 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id e23so10177423wme.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=kQoxNHv9H3smTFPwY0m34+bDhJqjJX4r9WAQjipW93hla9OWaLVcoFjNYlOW55U9Dk
         BF/t2BL41wDoIJ4ir//KcKVMUPY5IXAKvIEuWZchKCgL3zPkGPKwe8bmC1ckWVT2tJe+
         jcnWwS50LzqXcTvg4O3glWLsiIpKoyG32CruZ6yS2rGsdZF8CWJe5J7w5OxBMiThBaTX
         IYuTXIsDiOQHEUv8PlC1EpLOQBbVvYrMcf9i5SInZGkl+E9ayeXiUanaA3OknpEiRI/Y
         UCOccIYyN/b0KBYeB5kmn4BXtb5zT3gcYIcW+AQf3D16YvJPYb/OEt/7R014SdKht9EA
         3nMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=RqWMp3FOW3/jxFxb3fvaPZdFN6c43sb6coZVWmvlhPOpZC37ksKBQX13gdoKCGtpsq
         +Nb0qvHHKXzK9mTzAi0ZRAHouS+6qtVf1xYZTwFymVxxV6tMe8mMLqCv1f3PD05VrbMA
         KoQD3gNw0z7mCXMEQCHuUFkHTXHJ9/XeHFzqvICkIpdmN/Y7dIHUpTRsaNyJA06qcqhA
         jkIFEbKpWZvtujn+HFMHa7LwlXsf/VWmJ8i1R5z9TJfbMQRq0JuioiwqgLr91nMp2WYj
         9sZ4SFqP1lh4CESb5+WNslr2GIL90gcqLTbD3KyKZS1P+hAJGbfDSwDHI84dyUHMKTZz
         CAfQ==
X-Gm-Message-State: AOAM532lzCqJCi9vM+z+oWAD2Y7XHx8LoJ8OmPvcIa+59DP2ns4JxyfB
        iByKF98N535X3V/u2RduVQMe/OdGn30=
X-Google-Smtp-Source: ABdhPJwtLRTFMqgrXM/IvcCKGCBQVr+kV+YF7+qu94pe/8dIiHzvTAtGFNsV3dP3SZUPmdAskmv3iA==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr11322213wmh.39.1602509759798;
        Mon, 12 Oct 2020 06:35:59 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:35:59 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 02/20] kernel-shark: Use only signed types in kshark_entry
Date:   Mon, 12 Oct 2020 16:35:05 +0300
Message-Id: <20201012133523.469040-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
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
index 0d6c50d1..9eecc2d0 100644
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

