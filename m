Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38004 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387878AbeGKNmM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 09:42:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69-v6so2580728wmf.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Jul 2018 06:37:48 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark-qt: Fix the default value of the Event Visible flag
Date: Wed, 11 Jul 2018 16:37:09 +0300
Message-Id: <20180711133709.26788-2-y.karadz@gmail.com>
In-Reply-To: <20180711133709.26788-1-y.karadz@gmail.com>
References: <20180711133709.26788-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes a simpel bug in the way the "Event Visible" flag of the
kshark_entries is set when the data is loadded.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 75b88c9..3299752 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -600,7 +600,7 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 				kshark_set_entry_values(kshark_ctx, rec, entry);
 				pid = entry->pid;
 				/* Apply event filtering. */
-				ret = FILTER_NONE;
+				ret = FILTER_MATCH;
 				if (adv_filter->filters)
 					ret = pevent_filter_match(adv_filter, rec);
 
-- 
2.17.1
