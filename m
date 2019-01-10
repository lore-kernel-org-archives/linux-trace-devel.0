Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45466 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbfAJNoc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jan 2019 08:44:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id t6so11379522wrr.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jan 2019 05:44:30 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] kernel-shark-qt: Remove the "Apply to" checkboxes from KsQuickContextMenu
Date: Thu, 10 Jan 2019 15:44:16 +0200
Message-Id: <20190110134419.20247-3-ykaradzhov@vmware.com>
In-Reply-To: <20190110134419.20247-1-ykaradzhov@vmware.com>
References: <20190110134419.20247-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

"Apply to list/graph" checkboxes are available in the "Filter" top menu.
Having the same checkboxes in the Context menu is a potential source of
confusion for the user.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 30 ----------------------
 1 file changed, 30 deletions(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/src/KsQuickContextMenu.cpp
index b41adb9..4f922a2 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -88,36 +88,6 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 
 	addSection("Pointer menu");
 
-	if (parentName == "KsTraceViewer") {
-		_graphSyncCBox =
-			KsUtils::addCheckBoxToMenu(this, "Apply filters to Graph");
-
-		connect(_graphSyncCBox,	&QCheckBox::stateChanged,
-					&KsUtils::graphFilterSync);
-
-		/*
-		 * By defauls the filters will be append to the List (Table)
-		 * only.
-		 */
-		KsUtils::listFilterSync(true);
-		KsUtils::graphFilterSync(false);
-		_graphSyncCBox->setChecked(false);
-	}
-
-	if (parentName == "KsTraceGraph" &&
-	    (graphs = dynamic_cast<KsTraceGraph *>(parent))) {
-		_listSyncCBox =
-			KsUtils::addCheckBoxToMenu(this, "Apply filters to List");
-
-		connect(_listSyncCBox,	&QCheckBox::stateChanged,
-					&KsUtils::listFilterSync);
-
-		/* By defauls the filters will be append to the Graph only. */
-		KsUtils::graphFilterSync(true);
-		KsUtils::listFilterSync(false);
-		_listSyncCBox->setChecked(false);
-	}
-
 	descr = "Hide task [";
 	descr += taskName;
 	descr += "-";
-- 
2.17.1
