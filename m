Return-Path: <SRS0=L+0X=LS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50972 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbeIDUS3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Sep 2018 16:18:29 -0400
Received: by mail-wm0-f65.google.com with SMTP id s12-v6so5013910wmc.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Sep 2018 08:52:46 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/7] kernel-shark-qt: Make kshark_read_at() non-static.
Date: Tue,  4 Sep 2018 18:52:15 +0300
Message-Id: <20180904155218.32518-5-y.karadz@gmail.com>
In-Reply-To: <20180904155218.32518-1-y.karadz@gmail.com>
References: <20180904155218.32518-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

kshark_read_at() function provides a thread-safe read of a record from
a specific offset inside the trace.dat file. So far this function was
used only in libkshark.c and was defined static. This patch makes the
function non-static in order to make possible to use it from a plugin.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 12 ++++++++++--
 kernel-shark-qt/src/libkshark.h |  3 +++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index eef02368..91138527 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -830,8 +830,16 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	return -ENOMEM;
 }
 
-static struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
-					 uint64_t offset)
+/**
+ * @brief A thread-safe read of a record from a specific offset.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param offset: the offset into the file to find the record.
+ *
+ * @returns The returned pevent_record must be freed.
+ */
+struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
+				  uint64_t offset)
 {
 	/*
 	 * It turns that tracecmd_read_at() is not thread-safe.
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 203c8122..ba5ea6cb 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -150,6 +150,9 @@ void kshark_free(struct kshark_context *kshark_ctx);
 
 char* kshark_dump_entry(const struct kshark_entry *entry);
 
+struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
+				  uint64_t offset);
+
 /** Bit masks used to control the visibility of the entry after filtering. */
 enum kshark_filter_masks {
 	/**
-- 
2.17.1
