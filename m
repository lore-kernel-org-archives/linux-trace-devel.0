Return-Path: <SRS0=Poap=7K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69CCC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 May 2020 11:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C6F208A7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 May 2020 11:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sBYBu3To"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbgE1LTc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 May 2020 07:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388243AbgE1LTa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 May 2020 07:19:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C99C08C5C5
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 May 2020 04:19:30 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u13so2713879wml.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 May 2020 04:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n3f9frLguxqDztUtJZ1d6mbZ13TDGZLr6XBYlQJRrAo=;
        b=sBYBu3ToaBYHRooe49UAssf+bXRNYskusw9Mw2RFf9x3kjq9UhBfJ2ol0X6dceIcGY
         KSRGt0E5mtsInS8727H13bf0iIYlqZ30Ah/YcfmCymt0g1eanElemyihOkvRitjqNbnq
         VTYHBKDpcenFC3FbYExKyM421W3JXl0tmV1UWNE7fGyshrqVqJiCTQ4Q2Ci2gYy8Uwop
         MHYBwPfMxYRNkRHAbazK6Lpd5MkbWdod7Xvj0wpBc3GmDwrb1YuWnK7LuyRzlQMfv9ER
         jU0uua27XsA6KVIE+GzlRpK6L6GDg81WfTLwMC69YY0OMn1Ff+8L7TgiLKRp2i1kOTWV
         FKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n3f9frLguxqDztUtJZ1d6mbZ13TDGZLr6XBYlQJRrAo=;
        b=TB3kNAXSI8EtSbqa7lRUxSdDp0/eDeN1QhYxTxOQvbZI8z+cyx8KMf/4iBy6eFbKVg
         QaJopcLxrXThfH5trHBSBSOp9WoxKKYd0NX7imv5VufuEu1heeFC1pmEDb4tk/nBLzOM
         Ti4VkAXlaa8slBhtS42xSf7vdECBpTSmxS/49RQbtHW2rokXqTYF1kCbuZCwhTAqKZ01
         a9iU3Le3KY+3m0Mp+B/ahyNa/H73/yTySKxsRMIGOn9z4B22pLR+v5UtDyhBVPjfhi6l
         xAjijTidjXr4QVnlkDZk8WzFELxNu0ZJIKTNrYyf+mgOOS9cuJlzE+taD45F0nTq+YoK
         D2kg==
X-Gm-Message-State: AOAM5307WjTL/9z+0hhOQSZLDeWtwYpew/z3LqAyaTI00KSO1JPf30QZ
        4zSiPN79RiJToJ7096rPDpI=
X-Google-Smtp-Source: ABdhPJzIQoSFrq5Xc0y4h7CnvSPqrWetv/+1svWzqRk+HNaMtPbNM1RCwpBflBf8mVjl1KikTAw5uQ==
X-Received: by 2002:a1c:6182:: with SMTP id v124mr2940675wmb.30.1590664769119;
        Thu, 28 May 2020 04:19:29 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.215])
        by smtp.gmail.com with ESMTPSA id y185sm6446676wmy.11.2020.05.28.04.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 04:19:28 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Do not change the PLUGIN_UNTOUCHED bit flag when filtering
Date:   Thu, 28 May 2020 14:19:17 +0300
Message-Id: <20200528111917.339007-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "visible" field of the entry has one special bit flag, that helps
the GUI to display the original tracing data (as recorded) regardless
of the possible modifications made by the plugins. This bit flag must
be preserved when applying or removing filters.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 0905359..52aacd3 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -489,6 +489,11 @@ static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
 	e->visible &= ~event_mask;
 }
 
+static void set_all_visible(uint16_t *v) {
+	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
+	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
+}
+
 /**
  * @brief This function loops over the array of entries specified by "data"
  *	  and "n_entries" and sets the "visible" fields of each entry
@@ -525,7 +530,7 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
 	/* Apply only the Id filters. */
 	for (i = 0; i < n_entries; ++i) {
 		/* Start with and entry which is visible everywhere. */
-		data[i]->visible = 0xFF;
+		set_all_visible(&data[i]->visible);
 
 		/* Apply event filtering. */
 		if (!kshark_show_event(kshark_ctx, data[i]->event_id))
@@ -555,9 +560,8 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 			      size_t n_entries)
 {
 	int i;
-
 	for (i = 0; i < n_entries; ++i)
-		data[i]->visible = 0xFF;
+		set_all_visible(&data[i]->visible);
 }
 
 static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
-- 
2.25.1

