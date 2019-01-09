Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44757 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbfAINKE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 08:10:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id z5so7569440wrt.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Jan 2019 05:10:03 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/6] kernel-shark-qt: Do not auto-scrolling  when the marker switches
Date: Wed,  9 Jan 2019 15:09:43 +0200
Message-Id: <20190109130945.28519-5-ykaradzhov@vmware.com>
In-Reply-To: <20190109130945.28519-1-ykaradzhov@vmware.com>
References: <20190109130945.28519-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In some cases, the auto-scrolling (inside the table) to the
position of the marker, when the user switches between MarkerA
and MarkerB can be very annoying. This patch disables this
vertical auto-scrolling. Jumping to the position of the Active
marker is still possible, but the user has to do a second
click on the MarkerA/MarkerB button.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/KsTraceViewer.cpp
index 2418de3..f02fbbb 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -578,13 +578,18 @@ void KsTraceViewer::markSwitch()
 		 */
 		size_t row =_mState->getMarker(state)._pos;
 
-		QModelIndex index = _proxyModel.mapFromSource(_model.index(row, 0));
+		QModelIndex index =
+			_proxyModel.mapFromSource(_model.index(row, 0));
 
 		/*
 		 * The row of the active marker will be colored according to
-		 * the assigned property of the current state of the Dual marker.
+		 * the assigned property of the current state of the Dual
+		 * marker. Auto-scrolling is temporarily disabled because we
+		 * do not want to scroll to the position of the marker yet.
 		 */
+		_view.setAutoScroll(false);
 		_view.selectRow(index.row());
+		_view.setAutoScroll(true);
 	} else {
 		_view.clearSelection();
 	}
-- 
2.17.1
