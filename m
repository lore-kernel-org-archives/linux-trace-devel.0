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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DCAC5519F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7241C22248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2OWSv72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKLOYS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLOYR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:17 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390A2C0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:16 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id d142so5423872wmd.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=di/IFbD+AO4Z8oydLIU54ALnPl09tvFd6gvayVOcah4=;
        b=G2OWSv72xZyXUmhLCTjCU2BPAJCwn/rUJCkCBANk9W0Ap5seiYVnatECeRF5miA7ze
         niXjSe9KhVYHMFN8eIG1m4Ulmjc1owdAYOFjtQ3ooRl8yv/ZxdfHCwxkpuTdq0PiyBk2
         Bzcoj25MMOaRWGiDpVRUY1BlePQrEL801AXT8AnfGhUX2e9ujZ141iMmNYa6gnz+ilJW
         Llxxubfl4/vinvc0Rz7A+Bq8JLDDgq+0fuqqp8VIMwaSkgcfjJkT0a8pDG/CvsR4xU1L
         GwmiovtFLEwMBjEOVHXgJ55oEbIs7o7xuWL294thGGx86hmNyuT/22Rwqmet1IcYAs16
         A1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=di/IFbD+AO4Z8oydLIU54ALnPl09tvFd6gvayVOcah4=;
        b=FgYV5DduV1EgQUMrdZx6PIM4YHbteeBLdiOSYI/SYPM8FSPUDQVNgtfknXTn4OA+zy
         LGmLq4IGMvIHvDCosrWAjkV/p+oE2cZ36EC8eT/AAWIqMtySevUDdT65hFMQrnEFmuo9
         /UUkltJdxLIhyfp/hy2ev/qF23iCfSya7p7NCXEeTvYXguhbh5b2MKLzRkxxwDXieK6/
         oYM/Py786IBF9GIp0xARc2W7QtBWu54MsovNdee+/5j8UMQebSUYgnWIDHm4K4WCf6Qt
         ILo5/Bl3blbgv8YaAcEiAxpRKp1Pa77h5eeiVlcGHMl3zD/BKDxI2WhzG//o1BZri2YX
         BKIw==
X-Gm-Message-State: AOAM530HU6QZowwzZx0K1Bs42/NKDCvdNUKpL4z8+FC0fH29mOflwwsV
        GPC7mHHyzYEiRuxGDZ6gKeUmujsShQo=
X-Google-Smtp-Source: ABdhPJxgHxy2N7DapWAKSg/FjSF0FMGtf/aVIlrU0+CzAhXG5gYdFe0+7z1Jbz1pByb5bGmUXdIaaA==
X-Received: by 2002:a7b:c846:: with SMTP id c6mr9461963wml.143.1605191055003;
        Thu, 12 Nov 2020 06:24:15 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 02/20] kernel-shark: Add stream_id to kshark_entry
Date:   Thu, 12 Nov 2020 16:23:40 +0200
Message-Id: <20201112142358.36821-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
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

