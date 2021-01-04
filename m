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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D43C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB1020715
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbhADRtC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbhADRtC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:02 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5797C0617A0
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b73so28212332edf.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6J3nlTQiUnlAkEkX8AHZUBwDx72VEWyI0gNMQxrXqkc=;
        b=KhuWpg1DEYdWZYuwINh9oJbaWiQHpxOnmOCTnt71v4up/0lDMR9fNNgdtMtUiHvBd6
         fyAm4t9o9O3ltx2vgqgVUUZ36pUN+6Q73v0LFPVXofxTWk+uHfrKXbVtaXsw9qNsNSiN
         5dStIm3qDAP0LKXscIR8gzX9t65jk/1Hi6A4ccOHvO5nwkS2yaEaZkiAS4riMU9tJSH2
         shy6BZ7ECyMPcjxl8BhC6IGvNkAcGKIhD7YOW0ogn+a/LU2ysKHlueiFskbbgt/ybynL
         99kIzvD3DuRujy+2u6pIH5LqWhK7mWxUjrUNjPpkm1aA9kdfLAH7hU1e8FvA1vsL8EhP
         EcxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6J3nlTQiUnlAkEkX8AHZUBwDx72VEWyI0gNMQxrXqkc=;
        b=OnNpp7NZskjpqZLm6ChtIkGnsGvMnOpvvxR3awCmD4OJ216qvQl8a9fptke37b06Op
         Jn1D2bCXORAwPJtVmdfkrq2fYsOVksVgFqzWfnC+HPBGVo3hlH0QjjhIDLC4h2iDa1Bo
         HPGn5inEm4yTyJlsUGXkyqyszhXTqOgtgP83RXBSqBbg6YzCFbgAiz0atxg2c46bG6B+
         WLRoPIAl992mv1oPeq7ap/oGR6nk5V3B9ScXyIZGuYeTqPQ2NnCL53T6iUzwwXqbp7El
         7gQ6abIZp48uXIMwmNWonXnHBsl+bvflm5+ArOPHG4bcSyMEYue8Oog2OBKdZQCzSqys
         cLvw==
X-Gm-Message-State: AOAM531Rp6cOGvYM6qoIIfGakv0bLyVuDrr8eDGEtBef9eS4dECKrhTi
        pWJ+Xry2fAizDhnV6mkGZMM=
X-Google-Smtp-Source: ABdhPJwearDCOIdvZQ/ZbrA3bYEmXe/aATpd04EysddlRUmgaYL7QzkrGXqHpYqL6Uj03z3zmxij7Q==
X-Received: by 2002:a05:6402:1045:: with SMTP id e5mr72476449edu.40.1609782465477;
        Mon, 04 Jan 2021 09:47:45 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:45 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 09/44] kernel-shark: Use only signed types in kshark_entry
Date:   Mon,  4 Jan 2021 19:46:49 +0200
Message-Id: <20210104174724.70404-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index a44f46e..3b57e0b 100644
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

