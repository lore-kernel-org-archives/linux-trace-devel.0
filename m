Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41772 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbfAJNob (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jan 2019 08:44:31 -0500
Received: by mail-wr1-f68.google.com with SMTP id x10so11399579wrs.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jan 2019 05:44:29 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] kernel-shark-qt: Remove _deselectAction from KsQuickContextMenu
Date: Thu, 10 Jan 2019 15:44:15 +0200
Message-Id: <20190110134419.20247-2-ykaradzhov@vmware.com>
In-Reply-To: <20190110134419.20247-1-ykaradzhov@vmware.com>
References: <20190110134419.20247-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The action used to deselect the active marker gets inherited from
KsQuickMarkerMenu. This makes the declaration of an identical data
member in class KsQuickContextMenu ambiguous.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 3 +--
 kernel-shark-qt/src/KsQuickContextMenu.hpp | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/src/KsQuickContextMenu.cpp
index 6c9c9ef..b41adb9 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -61,8 +61,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
   _addCPUPlotAction(this),
   _addTaskPlotAction(this),
   _removeCPUPlotAction(this),
-  _removeTaskPlotAction(this),
-  _deselectAction(this)
+  _removeTaskPlotAction(this)
 {
 	typedef void (KsQuickContextMenu::*mfp)();
 	QString taskName, parentName, descr;
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.hpp b/kernel-shark-qt/src/KsQuickContextMenu.hpp
index f5a2a78..670d010 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.hpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.hpp
@@ -104,8 +104,6 @@ private:
 	QAction _removeCPUPlotAction;
 
 	QAction _removeTaskPlotAction;
-
-	QAction _deselectAction;
 };
 
 /**
-- 
2.17.1
