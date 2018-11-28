Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:2944
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728413AbeK2CSf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:35 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 13/17] kernel-shark-qt: Add CPU-based filtering to KsDataStore
Date: Wed, 28 Nov 2018 15:16:23 +0000
Message-ID: <20181128151530.21965-14-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds to the KsDataStore class methods for CPU filtering.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsUtils.cpp | 21 +++++++++++++++++++--
 kernel-shark-qt/src/KsUtils.hpp |  4 ++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.=
cpp
index c0e0f7d..2ebbae3 100644
--- a/kernel-shark-qt/src/KsUtils.cpp
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -269,12 +269,17 @@ void KsDataStore::_applyIdFilter(int filterId, QVecto=
r<int> vec)
 			kshark_filter_clear(kshark_ctx, KS_SHOW_TASK_FILTER);
 			kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
 			break;
+		case KS_SHOW_CPU_FILTER:
+		case KS_HIDE_CPU_FILTER:
+			kshark_filter_clear(kshark_ctx, KS_SHOW_CPU_FILTER);
+			kshark_filter_clear(kshark_ctx, KS_HIDE_CPU_FILTER);
+			break;
 		default:
 			return;
 	}
=20
-	for (auto &&pid: vec)
-		kshark_filter_add_id(kshark_ctx, filterId, pid);
+	for (auto &&val: vec)
+		kshark_filter_add_id(kshark_ctx, filterId, val);
=20
 	if (!_tep)
 		return;
@@ -319,6 +324,18 @@ void KsDataStore::applyNegEventFilter(QVector<int> vec=
)
 	_applyIdFilter(KS_HIDE_EVENT_FILTER, vec);
 }
=20
+/** Apply Show CPU filter. */
+void KsDataStore::applyPosCPUFilter(QVector<int> vec)
+{
+	_applyIdFilter(KS_SHOW_CPU_FILTER, vec);
+}
+
+/** Apply Hide CPU filter. */
+void KsDataStore::applyNegCPUFilter(QVector<int> vec)
+{
+	_applyIdFilter(KS_HIDE_CPU_FILTER, vec);
+}
+
 /** Disable all filters. */
 void KsDataStore::clearAllFilters()
 {
diff --git a/kernel-shark-qt/src/KsUtils.hpp b/kernel-shark-qt/src/KsUtils.=
hpp
index 888ed56..052cc71 100644
--- a/kernel-shark-qt/src/KsUtils.hpp
+++ b/kernel-shark-qt/src/KsUtils.hpp
@@ -156,6 +156,10 @@ public:
=20
 	void applyNegEventFilter(QVector<int>);
=20
+	void applyPosCPUFilter(QVector<int>);
+
+	void applyNegCPUFilter(QVector<int>);
+
 	void clearAllFilters();
=20
 signals:
--=20
2.17.1
