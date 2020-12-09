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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F2CC4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82BE123AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732477AbgLINm7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbgLINm7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:42:59 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F60C061793
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:18 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id w206so923084wma.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XbQnZ1JSgLUJnIWGmM1pYLsDVWl11jQpo0kl7PGJx0A=;
        b=sOzR4lenHGdTxsc56yp4fFvHEfCZVrXX/Io1jmtk8y/IQgASdEEgwOw8mBYQcHWOPW
         hEOKF3BS1FrSdofX8QWpEbp0YVBeXLJwsIDFfQxx1poqsv93ftGV9KXl2UPnTUN2L7vj
         fp1GFEfchR15N+TtSOFd9xQBLzcTskRhO9/eD2PQey6OcmkufYhgs1NKswXA7P5p3Obm
         mpQ3WdG7MWhWF+TyTiWDvFbrdss40LFldC8dgRtzUfgiwfbTTVBtdXy3LRY2HvNYr+7X
         XK4KMG09SuLPlzRzUMrB8rv/Ab/GScpkMLU3fyd61vF8nCgMXkB86HaHC851KivB7btu
         b9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XbQnZ1JSgLUJnIWGmM1pYLsDVWl11jQpo0kl7PGJx0A=;
        b=oCxe00UpRFa7VHlNFzEIxPoBsuGMtVbnbzDqsTJdw+Ckzb2Z4Ca8rxS7MWQgJLpOT7
         +7LBN8166OwfmnpxJC/UmZOsqoZm5+dPiHsS5WZ8Nbj7vEDz2FMq6tBt2VUVvAp3RBf5
         M4FsexEMY1Xmjs0ZQJGQ6HFGXE/9haq6iAxkTGHIQfhHywypmk5U23Zy09L01+wHh5HQ
         bVHFQEj2BbrEDrlp3XcYCXCNNba536ezlocPOoJOuZYUL0Eg4ohMwWy96WsZSbBc4I0g
         es+wI2f2YnxjTn/M+xTZZaDufw3YaARUCXyBNX+o6+41jXCyYF7k0WtdQtKqDFeLzmL/
         5uiA==
X-Gm-Message-State: AOAM531QCdhgeyDRMi/aMvQyglMnw3KClNGt82VQxPrBjp1OFjaXbGHR
        ZyrNEP8CK0y87Vq2rqcC31KLcjRj/ko=
X-Google-Smtp-Source: ABdhPJxqHeARmn19IounFoNkykByMSMvE0Zsx/jM7NhX3BdXyaDFH2F8lsqhYO+aqX6SlrTmfk2geg==
X-Received: by 2002:a1c:55c2:: with SMTP id j185mr2755117wmb.89.1607521337467;
        Wed, 09 Dec 2020 05:42:17 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:16 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 02/27] kernel-shark: Add stream_id to kshark_entry
Date:   Wed,  9 Dec 2020 15:41:38 +0200
Message-Id: <20201209134203.428068-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
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
index 9eecc2d..7d8b53b 100644
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

