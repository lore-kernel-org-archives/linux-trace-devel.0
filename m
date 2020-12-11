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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896BEC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D67623A7C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392649AbgLKPKH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392698AbgLKPJg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:09:36 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6988CC0617A7
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:19 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id t4so9336248wrr.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XbQnZ1JSgLUJnIWGmM1pYLsDVWl11jQpo0kl7PGJx0A=;
        b=SxxPw2dJYMblzK7dl422Y48n9jKClHcGKzCZ92lpXl3FP1sBwjU6YPlH3AK575i9FM
         GoTi6pDlFKKnuEU7UMoV3sKjJWFkqWMg+xHeOHLLKg/C/7F7BEFbW4+wuSRtM3n0gUK0
         /5gDeNQHOjHeKFlccGXZ+IgG6H1vmVNAmPu+pAd6kwu6D+DIPJrNmGBmRW4asNwjayXH
         5b/0tgW1TdhpBJGZVaftLnbMnP+VtlvpvenWDlZMjEnBQUssj7E/h1GWlrRWbTU88eFz
         tDSi4b+VmElPxFKXhqwWUVokLeyewc3G9WDMAJo1CnGg3sWKDOCiLH/zydIDc4gtoxKr
         Nb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XbQnZ1JSgLUJnIWGmM1pYLsDVWl11jQpo0kl7PGJx0A=;
        b=tf2equrs1i2WrXHjSRVQMuIC9wNrpYKT1hKhEhukl0lr1IrnznmSz4FjeOzXmrcwvf
         i/UGRlCfXmqgt1eZZyMKa6Y84TcsP4f7RoL/o+24ZpW0uCXePuBerIC2/vVfhmdGMsmH
         MWQv388Mv79KA8BLvniR3evOURX2hnF+qbdxiFNQLtjqupn31+AwA6jGVe48Em2nnV0V
         2YLg30BnuibtuPe/xl9/pnhapgLrw/lfsLYrsBETxd0O0VUYByQYGLXeshUfpGp7dArY
         dKrNJDCkCFP+8nTJJhuSNJ+cI58V/9hGSiDCxKjJozVcojlKCZnAPiz3heyzmErBIQrS
         XJIA==
X-Gm-Message-State: AOAM531GUIa14a5B0020LkMa25Bl2Cm8MqtdM5kLgnRUVDCNN31t717t
        MhEhow70aUkS5h+Kbhm99fQ=
X-Google-Smtp-Source: ABdhPJzWlnEIwRHIPXLkL7B/0AmiBzhAHenCFU35PwwbMYghG+OM/oP/EVNji2TIvHNFoPXpAJBnnA==
X-Received: by 2002:a5d:6845:: with SMTP id o5mr14271067wrw.421.1607699298183;
        Fri, 11 Dec 2020 07:08:18 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:17 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 07/32] kernel-shark: Add stream_id to kshark_entry
Date:   Fri, 11 Dec 2020 17:07:31 +0200
Message-Id: <20201211150756.577366-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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

