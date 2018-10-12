Return-Path: <SRS0=pqkA=MY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0061.outbound.protection.outlook.com ([104.47.36.61]:41568
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728857AbeJLXXd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 19:23:33 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark-qt: Fix a simple bug in KsDataStore::_freeData()
Date: Fri, 12 Oct 2018 18:49:53 +0300
Message-Id: <20181012154953.4682-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

After freeing the memory used to store the tracing data, this
function has to set the _dataSize field to zero.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsUtils.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.cpp
index 13b648e..5e4c9c8 100644
--- a/kernel-shark-qt/src/KsUtils.cpp
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -144,6 +144,8 @@ void KsDataStore::_freeData()
 		free(_rows);
 		_rows = nullptr;
 	}
+
+	_dataSize = 0;
 }
 
 /** Reload the trace data. */
-- 
2.17.1
