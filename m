Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4D9C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0893020811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfCNPKx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43180 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id q17so4024709pfh.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f8C7j7UUJo4vBP/4+DiQuGUXXXxVtCoxu7ygfOE2iGM=;
        b=tQfFmIMmBU0khL5plIagXHkv5BiK6TRGCMOaxhQh+Eaxbnz3QfwHArqrtX0MkZHRcJ
         xnwFSRiOMWuYwfkP0OLPgS2GKSdasjGYkCm30lsKRHrYFhtScko1p8j+gF9Axu3H2Qn9
         9wwdU2wiQnH7KMWTe7hC891hYLsyEPMJejUmdyksFz6CytiB+lq1S9nNzWtPbwm/UwDS
         me8o+8HAqyP2sIZEUfqH+U1Qoa+hkgbqF98TyioSz1hTFQvg7YxcmopHGXeyQwa743/U
         XH2QSJLuC7feQtMfMgf5XJz9ylD9+kTg7fA/jfMPO8tXoW5IQeMhxqWRywmvMErm5RQo
         DYAg==
X-Gm-Message-State: APjAAAVmMdwYibn1pvhe2JvjxQdP12Vd52mcLUcjtb/6OoqYV9shLdSk
        kwS3Cmg4vEa26+wMgoFwaCup9mbh
X-Google-Smtp-Source: APXvYqwPn3DTCVAYryKQShJ08WhD8jUAmmJJtgat0Wu1N9ogrFAo1FHlekyVNkh30hqTIy0OjgLKsw==
X-Received: by 2002:a63:a109:: with SMTP id b9mr45126224pgf.328.1552576252606;
        Thu, 14 Mar 2019 08:10:52 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:52 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/12] kernel-shark: In collections, handle the case when the data is small
Date:   Thu, 14 Mar 2019 17:10:12 +0200
Message-Id: <20190314151012.905-13-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In particular, handle the case when the size of the data is smaller
than the required margin.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-collection.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel-shark/src/libkshark-collection.c b/kernel-shark/src/libkshark-collection.c
index c70da1e..02a014e 100644
--- a/kernel-shark/src/libkshark-collection.c
+++ b/kernel-shark/src/libkshark-collection.c
@@ -71,7 +71,7 @@ static bool collection_add_entry(struct entry_list **list,
 static struct kshark_entry_collection *
 kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 			     struct kshark_entry **data,
-			     size_t first,
+			     ssize_t first,
 			     size_t n_rows,
 			     matching_condition_func cond,
 			     int val,
@@ -81,9 +81,19 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 	struct kshark_entry *last_vis_entry = NULL;
 	struct entry_list *col_list, *temp;
 	size_t resume_count = 0, break_count = 0;
-	size_t i, j, end, last_added = 0;
+	size_t i, j, last_added = 0;
+	ssize_t end;
 	bool good_data = false;
 
+	/* Create the collection. */
+	col_ptr = calloc(1, sizeof(*col_ptr));
+	if (!col_ptr)
+		goto fail;
+
+	end = first + n_rows - margin;
+	if (first >= end)
+		return col_ptr;
+
 	col_list = malloc(sizeof(*col_list));
 	if (!col_list)
 		goto fail;
@@ -106,7 +116,6 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 		temp->type = COLLECTION_IGNORE;
 	}
 
-	end = first + n_rows - margin;
 	for (i = first + margin; i < end; ++i) {
 		if (!cond(kshark_ctx, data[i], val)) {
 			/*
@@ -204,11 +213,6 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 	 */
 	assert(break_count == resume_count);
 
-	/* Create the collection. */
-	col_ptr = malloc(sizeof(*col_ptr));
-	if (!col_ptr)
-		goto fail;
-
 	col_ptr->next = NULL;
 
 	col_ptr->resume_points = calloc(resume_count,
-- 
2.19.1

