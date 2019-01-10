Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41773 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbfAJNoc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jan 2019 08:44:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id x10so11399662wrs.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jan 2019 05:44:31 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] kernel-shark-qt: Rearrange the KsQuickContextMenu menu
Date: Thu, 10 Jan 2019 15:44:17 +0200
Message-Id: <20190110134419.20247-4-ykaradzhov@vmware.com>
In-Reply-To: <20190110134419.20247-1-ykaradzhov@vmware.com>
References: <20190110134419.20247-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Swaps the position of the Show / Hide actions in the menu. This is
done because we expect the "Show" actions to be used more often.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 26 ++++++++++++----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/src/KsQuickContextMenu.cpp
index 4f922a2..7ab5a5f 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -88,13 +88,6 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 
 	addSection("Pointer menu");
 
-	descr = "Hide task [";
-	descr += taskName;
-	descr += "-";
-	descr += QString("%1").arg(pid);
-	descr += "]";
-	lamAddAction(&_hideTaskAction, &KsQuickContextMenu::_hideTask);
-
 	descr = "Show task [";
 	descr += taskName;
 	descr += "-";
@@ -102,23 +95,32 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 	descr += "] only";
 	lamAddAction(&_showTaskAction, &KsQuickContextMenu::_showTask);
 
-	descr = "Hide event [";
-	descr += kshark_get_event_name_easy(_data->rows()[_row]);
+	descr = "Hide task [";
+	descr += taskName;
+	descr += "-";
+	descr += QString("%1").arg(pid);
 	descr += "]";
-	lamAddAction(&_hideEventAction, &KsQuickContextMenu::_hideEvent);
+	lamAddAction(&_hideTaskAction, &KsQuickContextMenu::_hideTask);
 
 	descr = "Show event [";
 	descr += kshark_get_event_name_easy(_data->rows()[_row]);
 	descr += "] only";
 	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
 
-	descr = QString("Hide CPU [%1]").arg(_data->rows()[_row]->cpu);
-	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
+	descr = "Hide event [";
+	descr += kshark_get_event_name_easy(_data->rows()[_row]);
+	descr += "]";
+	lamAddAction(&_hideEventAction, &KsQuickContextMenu::_hideEvent);
 
 	if (parentName == "KsTraceViewer") {
 		descr = QString("Show CPU [%1] only").arg(cpu);
 		lamAddAction(&_showCPUAction, &KsQuickContextMenu::_showCPU);
+	}
+
+	descr = QString("Hide CPU [%1]").arg(_data->rows()[_row]->cpu);
+	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
 
+	if (parentName == "KsTraceViewer") {
 		descr = "Add [";
 		descr += taskName;
 		descr += "-";
-- 
2.17.1
