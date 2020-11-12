Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1759C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4472C22248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YwV8gKPr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgKLOYP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLOYO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:14 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB53C0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:14 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 23so6173356wrc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=YwV8gKProY2LQo5n9yExbfu7QBSenBlFmsJadaii5jFBK730DA6joStEI+BlOOPsX2
         eQSoyTCs/meHXLcF5W6+F2ooNw4ixYkD5a31loUp5X4gMnFlHU18q+yIMDVLqQ1Q5bZz
         1TwbMmlJuUJLls8PhYiBDA2BNYE/WtBGz+EvlSXPUiM04uDJPqtTYWYJas8jlxawmHBy
         snGO7w8CKUsaYGDO0dc0PYmxWbo5lt0aeMgBx3bHPk+VAOzjeivsWgricxcSdJw6goYF
         +ExqaFuE1HZPi1W7T2CiDMi6NDG2PU8dWHA/+ZMFKkHaoE/C3FiIvQoWqIbZ9c5+aZTY
         hZ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=ivyj/Nzk1WJk98GrFLy9p/AgDWncZKttRVI9ZocX2EAbfGa3LHyprFKkOJL75DlfUq
         YoWi/DAIkPOlNG5nOzwJVflmZ7yawVwKVeGS5R24tZXq43peROYRqUBK9hYtuT+a/mWG
         dLe0fgpBkQwYDxaRaRorLjpa+RcmlUe8/5aNN3dn1aw1sp4jYPPfIbjjqn5INMVStGZz
         CJYlD2i0Mq/CbCtYxawIXBVNb81PxAGdndlppbNHZVAa56vPOl6iDjMJvPD6HWsIweu5
         eb7OsWoiZLWDrVeAK7pUsfmtvP8o6GVKCLzWw+mtgYTM/jgLLTnNLafamtmNoZlZH5dD
         RgOQ==
X-Gm-Message-State: AOAM533pPX4YmQ9ZTicNrLpmybsEqxX/THSso/MOxVCF1kDCHlANUWWo
        gu7umLsPVpCva3UD2hxNLI4=
X-Google-Smtp-Source: ABdhPJwmuCOtVBYR1DRF6/HQ/gNvgT7EayzSyGbalMKmX5y9swEKgbyCB+SoSNobWS+4OhrQSUp15w==
X-Received: by 2002:a05:6000:182:: with SMTP id p2mr26561315wrx.116.1605191053211;
        Thu, 12 Nov 2020 06:24:13 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:12 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 01/20] kernel-shark: Use only signed types in kshark_entry
Date:   Thu, 12 Nov 2020 16:23:39 +0200
Message-Id: <20201112142358.36821-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
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

