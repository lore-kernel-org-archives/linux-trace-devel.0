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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224A4C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD91423BDF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732125AbgLINm6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732503AbgLINm6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:42:58 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16D3C0613D6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:17 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t4so1776700wrr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=aVV/kN+dssCRTtf1aPo7KCUZsnozgSjOididm/1PjpryQQ+J6kT129w/aZfu6iqlHu
         Q1xIZAceLpJLceHbI7wBeZA1qY3/yIcAUATVfLATn1R25EsJLKPUFnpzvCPedolqQGlx
         ULadcsoGUfb+ykDkUuXgcsVPsbcqABdHswGkDbhOaz+Ien3wETQNv3RY9L5hwJ48/rUr
         GlQJ5uDmprguIdGjDGxPKLCkUoDyNrzcSoDTBeLdPAGtQaBUxR3gpy4eVJsKHSy3NCxg
         NWWasxx82OhgYBMCdoe9ORKH2Z4zQm/K9dnnlOpjD6mNrDDhwTZKimpRhzbklU42sjuU
         /YKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=PYQd2lCDUM79cwJZ/MW1SPNfICm8HdWFT7DqaCalYhUNoAHBFv7lROaozxgij+cmRp
         B/eEiohCfKbrTwIdxOtvtMkxuZ10L8E37zcWwXIemEsAydpFEX2YCxjKwSqsrN1L+ON1
         HNREeacpHS6dSfpMfAhHZfB1P5waATKnUAHo8pb3ETf4sEfWKk8zQDhA78eZUPu35lhp
         PXIsBGwspYUzDQ9jQqO2AldL1vpLhYmZmSu2RHodE9JhDu++D4QQxrwSerXqKXuzhAus
         SEwaB6zxQLPYJdX5cBK4/R5zGbRKwOhSu/sRvW+9qPM/5r9Mhnxv2ee+HdmBeewLDEIZ
         B1xg==
X-Gm-Message-State: AOAM531WCwiZrrZv0kymyvMFr7U3LEZ76hNfcwOeVKm9/huD127Nbc6J
        1ug63N4p26FzpPZ7wATPLKl9rHVc10c=
X-Google-Smtp-Source: ABdhPJypyC+BvWwIjbWO2N0PrpVuWG4/utPET28lLgkY9hBSqkfHtF7RDFmiLsVjZqK4Seb2FVkmQw==
X-Received: by 2002:adf:fa0c:: with SMTP id m12mr2872875wrr.222.1607521336469;
        Wed, 09 Dec 2020 05:42:16 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:16 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 01/27] kernel-shark: Use only signed types in kshark_entry
Date:   Wed,  9 Dec 2020 15:41:37 +0200
Message-Id: <20201209134203.428068-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
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

