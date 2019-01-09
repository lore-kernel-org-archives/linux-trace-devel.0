Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50936 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730250AbfAINKF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 08:10:05 -0500
Received: by mail-wm1-f67.google.com with SMTP id n190so7579855wmd.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Jan 2019 05:10:04 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/6] kernel-shark-qt: Add the CPU filters to the filter clearing method
Date: Wed,  9 Jan 2019 15:09:44 +0200
Message-Id: <20190109130945.28519-6-ykaradzhov@vmware.com>
In-Reply-To: <20190109130945.28519-1-ykaradzhov@vmware.com>
References: <20190109130945.28519-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

When we introdused the CPU filters, we forgot to add these filters to
void KsDataStore::clearAllFilters().

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsUtils.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.cpp
index 0298010..34b2e2d 100644
--- a/kernel-shark-qt/src/KsUtils.cpp
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -375,6 +375,8 @@ void KsDataStore::clearAllFilters()
 	kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
 	kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
 	kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);
+	kshark_filter_clear(kshark_ctx, KS_SHOW_CPU_FILTER);
+	kshark_filter_clear(kshark_ctx, KS_HIDE_CPU_FILTER);
 
 	tep_filter_reset(kshark_ctx->advanced_event_filter);
 	kshark_clear_all_filters(kshark_ctx, _rows, _dataSize);
-- 
2.17.1
