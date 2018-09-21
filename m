Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0058.outbound.protection.outlook.com ([104.47.36.58]:21536
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728098AbeIUTfX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 15:35:23 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] kernel-shark-qt: Add kshark_convert_nano() function
Date: Fri, 21 Sep 2018 16:45:38 +0300
Message-Id: <20180921134540.13074-3-ykaradzhov@vmware.com>
In-Reply-To: <20180921134540.13074-1-ykaradzhov@vmware.com>
References: <20180921134540.13074-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

kshark_convert_nano() is used to convert the original value of the
timestamp of the trace records (having nanosecond precision) into two
values representing the time in seconds and milliseconds.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 14 ++++++++++++++
 kernel-shark-qt/src/libkshark.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 9ccb3cc..40625e5 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -1040,6 +1040,20 @@ const char *kshark_get_info_easy(struct kshark_entry *entry)
 	return info;
 }
 
+/**
+ * @brief Convert the timestamp of the trace record (nanosecond precision) into
+ *	  seconds and microseconds.
+ *
+ * @param time: Input location for the timestamp.
+ * @param sec: Output location for value of the seconds.
+ * @param usec: Output location for value of the microseconds.
+ */
+void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
+{
+	*sec = time / 1000000000ULL;
+	*usec = (time / 1000) % 1000000;
+}
+
 /**
  * @brief Dump into a string the content of one entry. The function allocates
  *	  a null terminated string and returns a pointer to this string. The
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index a1f294a..085b79c 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -158,6 +158,8 @@ const char *kshark_get_event_name_easy(struct kshark_entry *entry);
 
 const char *kshark_get_info_easy(struct kshark_entry *entry);
 
+void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
+
 char* kshark_dump_entry(const struct kshark_entry *entry);
 
 struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
-- 
2.17.1
