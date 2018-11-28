Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710043.outbound.protection.outlook.com ([40.107.71.43]:7840
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbeK2CST (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:19 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 08/17] kernel-shark-qt: Add a method for easy retrieve of all
 Ids of a filter
Date: Wed, 28 Nov 2018 15:16:16 +0000
Message-ID: <20181128151530.21965-9-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds to KsUtils a method which can be used to retrieve
a vector of sorted Id values associated with a given filter.
The method will be used by the Quick Context Menu widget.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsUtils.cpp | 21 +++++++++++++++++++++
 kernel-shark-qt/src/KsUtils.hpp |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.=
cpp
index 25e7fdb..c0e0f7d 100644
--- a/kernel-shark-qt/src/KsUtils.cpp
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -36,6 +36,27 @@ QVector<int> getPidList()
 	return pids;
 }
=20
+/** @brief Get a sorted vector of Id values of a filter. */
+QVector<int> getFilterIds(tracecmd_filter_id *filter)
+{
+	kshark_context *kshark_ctx(nullptr);
+	int *cpuFilter, n;
+	QVector<int> v;
+
+	if (!kshark_instance(&kshark_ctx))
+		return v;
+
+	cpuFilter =3D tracecmd_filter_ids(filter);
+	n =3D filter->count;
+	for (int i =3D 0; i < n; ++i)
+		v.append(cpuFilter[i]);
+
+	qSort(v);
+
+	free(cpuFilter);
+	return v;
+}
+
 /**
  * Set the bit of the filter mask of the kshark session context responsibl=
e
  * for the visibility of the events in the Table View.
diff --git a/kernel-shark-qt/src/KsUtils.hpp b/kernel-shark-qt/src/KsUtils.=
hpp
index b14cd6a..888ed56 100644
--- a/kernel-shark-qt/src/KsUtils.hpp
+++ b/kernel-shark-qt/src/KsUtils.hpp
@@ -84,6 +84,8 @@ namespace KsUtils {
=20
 QVector<int> getPidList();
=20
+QVector<int> getFilterIds(tracecmd_filter_id *filter);
+
 /** @brief Geat the list of plugins. */
 inline QStringList getPluginList() {return plugins.split(";");}
=20
--=20
2.17.1
