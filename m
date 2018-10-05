Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700068.outbound.protection.outlook.com ([40.107.70.68]:4464
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728044AbeJFBdW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 21:33:22 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 2/5] kernel-shark-qt: Add kshark_convert_nano() function
Date: Fri, 5 Oct 2018 18:33:24 +0000
Message-ID: <20181005183241.27026-3-ykaradzhov@vmware.com>
References: <20181005183241.27026-1-ykaradzhov@vmware.com>
In-Reply-To: <20181005183241.27026-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

kshark_convert_nano() is used to convert the original value of the
timestamp of the trace records (having nanosecond precision) into two
values representing the time in seconds and milliseconds.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 16 ++++++++++++++++
 kernel-shark-qt/src/libkshark.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index ef577e0..d9d1929 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -1084,6 +1084,22 @@ const char *kshark_get_info_easy(struct kshark_entry=
 *entry)
 	return info;
 }
=20
+/**
+ * @brief Convert the timestamp of the trace record (nanosecond precision)=
 into
+ *	  seconds and microseconds.
+ *
+ * @param time: Input location for the timestamp.
+ * @param sec: Output location for the value of the seconds.
+ * @param usec: Output location for the value of the microseconds.
+ */
+void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
+{
+	uint64_t s;
+
+	*sec =3D s =3D time / 1000000000ULL;
+	*usec =3D (time - s * 1000000000ULL) / 1000;
+}
+
 /**
  * @brief Dump into a string the content of one entry. The function alloca=
tes
  *	  a null terminated string and returns a pointer to this string. The
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index f00a584..d24ed8c 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -160,6 +160,8 @@ const char *kshark_get_event_name_easy(struct kshark_en=
try *entry);
=20
 const char *kshark_get_info_easy(struct kshark_entry *entry);
=20
+void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
+
 char* kshark_dump_entry(const struct kshark_entry *entry);
=20
 struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
--=20
2.17.1
