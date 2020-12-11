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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DB8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCFED22CF8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406393AbgLKOrR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406383AbgLKOqY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 09:46:24 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004F5C06138C
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:29 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a3so8817598wmb.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XbQnZ1JSgLUJnIWGmM1pYLsDVWl11jQpo0kl7PGJx0A=;
        b=uglK/fNJgvE1pan0CKMl+O6k0suq2fP/U5Aw2yKQ8dnt3Ky67zYyfGvdFB+mClI/FC
         RVFJADvWDrhcyr0C5n8N1uxEvjZm1ROz4fWLJuLmf/5kjbO3ld5cBdmx/NRTAfBRRvZG
         oruF/4uZXHtwo+Ryv1YE3Q/ElADzdFTTuIeiA2af6lwSJVDP+7FKEYaWOA2U05WyYbrj
         eIIP1B84hdbOUfEsw6xFQUabvMvbTlXl90GXpj4ZodhZkw/fXPEwG7zdpu3XXtWzwdhc
         nVUpUC84/ucOv/RQ7vhLpkB/ihiCHvhA4K7roOHt5DzMjmDZX2k+TSHc4s1UC3MXK7GQ
         GI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XbQnZ1JSgLUJnIWGmM1pYLsDVWl11jQpo0kl7PGJx0A=;
        b=REZgfLBRGQdUaIVGuirePtDaWO53M1LQ+1IdPCjTE2LymuB079hEyK5fLVMdlq4NHH
         pLdwyRnczcmT1nD6/ZY+uDDTby3t+Bfs5evsn7DdnjfxPgi91oc/PuXkI68fMVyupJJR
         aGiKqVvBXA+MF/1zoqmf6CeK6x/heOMMecavhicmG/G6uahLDgnYSHj6aA+Azb9RWhBx
         0t8i2Vm6GcoHcTNWNvQFCgM0jt3ZAfW9lhw1X2HRzcSyei4JxoifidMGeKaQMCPiu1Un
         NUEUAUPVXYU6r+fW3xLZM+3HRN0C5V9Jt7vKxJfMhb424kAzxAOJx+w6f4Q8ICGANAW4
         bK1g==
X-Gm-Message-State: AOAM531fYnhaP58BNysGOw0DdY+vjHLqB2A0SnIgtvxOKU0hYprrBoyp
        eZqFg5PfaXPcZh3pJUSblEY=
X-Google-Smtp-Source: ABdhPJzTYUtX8hyocE8A8izT72FhucTulDAFIdRU7yViBE/Nq/rvgv6Imbtb7ffESXqxn+gGlDWGiA==
X-Received: by 2002:a1c:6008:: with SMTP id u8mr13516771wmb.173.1607697928812;
        Fri, 11 Dec 2020 06:45:28 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id y2sm14471471wma.6.2020.12.11.06.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:45:28 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 07/32] kernel-shark: Add stream_id to kshark_entry
Date:   Fri, 11 Dec 2020 16:44:46 +0200
Message-Id: <20201211144511.575346-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211144511.575346-1-y.karadz@gmail.com>
References: <20201211144511.575346-1-y.karadz@gmail.com>
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

