Return-Path: <SRS0=cHGG=LM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52150 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbeH2U1Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Aug 2018 16:27:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id y2-v6so5908895wma.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Aug 2018 09:29:43 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] kernel-shark-qt: Change "pevent_" to "tep_" in Doxygen.
Date: Wed, 29 Aug 2018 19:29:24 +0300
Message-Id: <20180829162927.20200-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The naming convention has changed in the code already but we forgot to do
this in the Doxygen documentation.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index d07bdd8..1b7e544 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -759,7 +759,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 
 /**
  * @brief Load the content of the trace data file into an array of
- *	  pevent_records. Use this function only if you need fast access
+ *	  tep_records. Use this function only if you need fast access
  *	  to all fields of the record.
  *
  * @param kshark_ctx: Input location for the session context pointer.
@@ -962,14 +962,14 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
 }
 
 /**
- * @brief Binary search inside a time-sorted array of pevent_records.
+ * @brief Binary search inside a time-sorted array of tep_records.
  *
  * @param time: The value of time to search for.
  * @param data: Input location for the trace data.
  * @param l: Array index specifying the lower edge of the range to search in.
  * @param h: Array index specifying the upper edge of the range to search in.
  *
- * @returns On success, the first pevent_record inside the range, having a
+ * @returns On success, the first tep_record inside the range, having a
 	    timestamp equal or bigger than "time".
 	    If all entries inside the range have timestamps greater than "time"
 	    the function returns BSEARCH_ALL_GREATER (negative value).
-- 
2.17.1
