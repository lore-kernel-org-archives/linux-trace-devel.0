Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46477 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731997AbeHCPEw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 11:04:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id h14-v6so5340163wrw.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Aug 2018 06:08:35 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark-qt: Change the input argument of kshark_dump_entry() to const.
Date: Fri,  3 Aug 2018 16:07:58 +0300
Message-Id: <20180803130759.31858-2-y.karadz@gmail.com>
In-Reply-To: <20180803130759.31858-1-y.karadz@gmail.com>
References: <20180803130759.31858-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

kshark_dump_entry() should not be able to modify the content of its input
argument (kshark_entry) which is being dumped to a string. The type of the
argument is changed from "struct kshark_entry*" to "const struct kshark_entry*"

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 2 +-
 kernel-shark-qt/src/libkshark.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 3299752..847c10f 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -861,7 +861,7 @@ static const char *kshark_get_info(struct pevent *pe,
  * @returns The returned string contains a semicolon-separated list of data
  *	    fields.
  */
-char* kshark_dump_entry(struct kshark_entry *entry)
+char* kshark_dump_entry(const struct kshark_entry *entry)
 {
 	const char *event_name, *task, *lat, *info;
 	struct kshark_context *kshark_ctx;
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 0ad31c0..eda0a83 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -133,7 +133,7 @@ void kshark_close(struct kshark_context *kshark_ctx);
 
 void kshark_free(struct kshark_context *kshark_ctx);
 
-char* kshark_dump_entry(struct kshark_entry *entry);
+char* kshark_dump_entry(const struct kshark_entry *entry);
 
 /** Bit masks used to control the visibility of the entry after filtering. */
 enum kshark_filter_masks {
-- 
2.17.1
