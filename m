Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710070.outbound.protection.outlook.com ([40.107.71.70]:36576
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728664AbeK2CSK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:10 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 01/17] kernel-shark-qt: Updata Event filter mask when applaing
 filters to Graph
Date: Wed, 28 Nov 2018 15:16:06 +0000
Message-ID: <20181128151530.21965-2-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

KS_GRAPH_VIEW_FILTER_MASK and KS_EVENT_VIEW_FILTER_MASK are two bit
flags used to control the visibility of an entry inside the Graphs.
Both flags have to be updated when the "Apply filters to Graph"
checkbox is clicked.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsUtils.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.=
cpp
index 5e4c9c8..8bb0970 100644
--- a/kernel-shark-qt/src/KsUtils.cpp
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -67,8 +67,10 @@ void graphFilterSync(bool state)
=20
 	if (state) {
 		kshark_ctx->filter_mask |=3D KS_GRAPH_VIEW_FILTER_MASK;
+		kshark_ctx->filter_mask |=3D KS_EVENT_VIEW_FILTER_MASK;
 	} else {
 		kshark_ctx->filter_mask &=3D ~KS_GRAPH_VIEW_FILTER_MASK;
+		kshark_ctx->filter_mask &=3D ~KS_EVENT_VIEW_FILTER_MASK;
 	}
 }
=20
--=20
2.17.1
