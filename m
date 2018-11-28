Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710070.outbound.protection.outlook.com ([40.107.71.70]:36576
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeK2CSK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:10 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 02/17] kernel-shark-qt: Reprocess all CPU collections when the
 filtering changes
Date: Wed, 28 Nov 2018 15:16:07 +0000
Message-ID: <20181128151530.21965-3-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The CPU data collections are processed according to the visibility of
the entries. If the filtering condition changes, we need to reprocess
those data collections.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsUtils.cpp | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.=
cpp
index 8bb0970..25e7fdb 100644
--- a/kernel-shark-qt/src/KsUtils.cpp
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -186,10 +186,14 @@ void KsDataStore::update()
 	if (!kshark_instance(&kshark_ctx))
 		return;
=20
+	_unregisterCPUCollections();
+
 	if (kshark_filter_is_set(kshark_ctx)) {
 		kshark_filter_entries(kshark_ctx, _rows, _dataSize);
 		emit updateWidgets(this);
 	}
+
+	registerCPUCollections();
 }
=20
 /** Register a collection of visible entries for each CPU. */
--=20
2.17.1
