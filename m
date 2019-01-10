Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36306 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbfAJNod (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jan 2019 08:44:33 -0500
Received: by mail-wm1-f67.google.com with SMTP id p6so12074522wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jan 2019 05:44:32 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] kernel-shark-qt: Add section separator in KsQuickContextMenu
Date: Thu, 10 Jan 2019 15:44:19 +0200
Message-Id: <20190110134419.20247-6-ykaradzhov@vmware.com>
In-Reply-To: <20190110134419.20247-1-ykaradzhov@vmware.com>
References: <20190110134419.20247-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Adding a separator between the filter-related and the plot-related
actions in the menu helps the user to get orientation.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/src/KsQuickContextMenu.cpp
index 231ca38..728ecbd 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -87,7 +87,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 
 	parentName = parent->metaObject()->className();
 
-	addSection("Pointer menu");
+	addSection("Pointer filter menu");
 
 	descr = "Show task [";
 	descr += taskName;
@@ -124,6 +124,8 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 	descr = "Clear all filters";
 	lamAddAction(&_clearAllFilters, &KsQuickContextMenu::_clearFilters);
 
+	addSection("Pointer plot menu");
+
 	if (parentName == "KsTraceViewer") {
 		descr = "Add [";
 		descr += taskName;
-- 
2.17.1
