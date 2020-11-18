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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F19C63777
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8508F246AA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oBfsgTFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgKROu2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgKROu2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:28 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BA9C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:27 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r17so2529081wrw.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=di/IFbD+AO4Z8oydLIU54ALnPl09tvFd6gvayVOcah4=;
        b=oBfsgTFomBFISCoTJX8CIIqMOvbTQLwwEvlVInQqmZqvBqMuamzvJ4WCVrqlYbnaXW
         A+WTt4AkiPl35dM3vVnI+bwbQVEONm9vUT6Q0ojsgem26I1GM2Pn6JrAbiSufx1ee6hO
         gyWSrwIou9YJzTFiI5prWs2LS4DTwRgTklSuOJMoizauheYCqHu2xrzeFoEovv3PFot4
         7fAGF09GHKmdEgQYk2Ex5/Xm0CbA1nzoX8S4BuvdcQGRJWAaVcfQ8GPYlf1EDyZth7O9
         GWvSeHe5sS/90kZKS+80p5SznwuFFvssNeszHuId54yKzW6LccQPv2N/ylJIp/G9P8cI
         mQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=di/IFbD+AO4Z8oydLIU54ALnPl09tvFd6gvayVOcah4=;
        b=hB93kdlYEjLKtn/eZVyaWKdG6IRWcqIhGqRLBU1fkMOeHCRkViHQoYaHmwh9X4vtyi
         YhEglbUIGEl58MU3qUFughJJEYu4jzo5VdRSkzoUdDWW5KYRGhbQ882c0cvx1IRfl+5G
         XyA4LBUTL7NvEMsje68PYSCtvpihArXAF0fqd4pj9L7berDII94t02kpBE8eYc+upLzP
         LMVIRnMndWqmInFEi62jtl9CWILfDphrOAhV6phPPVGRDmI/ql4gFciCNuFYl8mABFJ3
         PFG7VeUXNWa60AQ2X1eqvfeLwBkBnpqya+pwSH2C5lAxukq2g9zQAax1mtehzE7NBVIX
         yMMA==
X-Gm-Message-State: AOAM532lk142OguGRRZRBQpNJ6RT8FPyY9Zsa+KPgU0Ne187BevJMmd+
        EWrUUz/a0VC/Xw15fOufDlI=
X-Google-Smtp-Source: ABdhPJxoN0Co8kdOROQjyjIm0xD3jWmLFHzBACzKkeUdTQCq8CLNReD/DeWjNFkVrzkJgETVt2tbDg==
X-Received: by 2002:a05:6000:187:: with SMTP id p7mr5244573wrx.240.1605711026516;
        Wed, 18 Nov 2020 06:50:26 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:25 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 02/20] kernel-shark: Add stream_id to kshark_entry
Date:   Wed, 18 Nov 2020 16:49:45 +0200
Message-Id: <20201118145003.156542-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
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

