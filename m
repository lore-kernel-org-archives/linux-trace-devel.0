Return-Path: <SRS0=4mzf=QT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44018C282CA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D0B220700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfBLREb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:04:31 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52744 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbfBLREb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Feb 2019 12:04:31 -0500
Received: by mail-wm1-f67.google.com with SMTP id m1so3817496wml.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Feb 2019 09:04:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QYicw5VDqn+MF+hSVCde3FK9OxX3udBbcb0GTkFM/F8=;
        b=saK4ByXXYGBLMqUBv7j2tC//vAGF+dG9hMPw6J5KvRr+DfpCbqQ+PIiLNO/KabwCFv
         opkOMbdZiW6YYs54Lx0pu4j3HrrnMl12rOvLRwUzeZllu/qO0APdeCtfFq6zPqNNX/ru
         oruN2wU8TiO9H8RxOn/zpms8PyYSQmuZ8RK3jfONgWGEnT6BWHayhX0QQ/8UHku728rF
         LPmt4aoBnsCX5rPjjMMWijscVPkGehN+9OAzWeIQo6DZOTo/QpfNhMSP1KhXG+rpAdKl
         TNgCR9S/8lJj5jqxvwYaafqTkOgr9aPlJDwN6xckqno/vZeLkMAcYYQxWtWxtZMqv9vJ
         nI3A==
X-Gm-Message-State: AHQUAuYegQln1n+iB6tSXKwGMfU2//AecY7gAZQKMMVX8Blga141YZfi
        je9pHncMtiz/haenjbwgbxc=
X-Google-Smtp-Source: AHgI3Ibju0dq8u5lwpHuLtfe9ZHo9Tr7woMDCh8qyijgUjAOktWZqzEKNwKoL/IB9Et4iAJXsSPH2A==
X-Received: by 2002:a1c:9c0a:: with SMTP id f10mr3749499wme.73.1549991069256;
        Tue, 12 Feb 2019 09:04:29 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c139sm5579732wmd.13.2019.02.12.09.04.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:04:28 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/5] kernel-shark: Define KS_NO_ROW_SELECTED as a negative row index (-1)
Date:   Tue, 12 Feb 2019 19:04:00 +0200
Message-Id: <20190212170402.10104-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190212170402.10104-1-ykaradzhov@vmware.com>
References: <20190212170402.10104-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently the model of the table treats any negative value of the Passive
Marker index as "No Row is Selected". In multiple places in the code the
value of "-1" is used in order to deselecting the marker. Defining a
dedicated constant (KS_NO_ROW_SELECTED), to be used for deselecting the
Passive Marker will make the code more readable and robust.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202327
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsModels.cpp      | 8 ++++----
 kernel-shark/src/KsModels.hpp      | 3 +++
 kernel-shark/src/KsTraceViewer.cpp | 6 +++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel-shark/src/KsModels.cpp b/kernel-shark/src/KsModels.cpp
index 1b68143..b89fee8 100644
--- a/kernel-shark/src/KsModels.cpp
+++ b/kernel-shark/src/KsModels.cpp
@@ -199,8 +199,8 @@ KsViewModel::KsViewModel(QObject *parent)
   _nRows(0),
   _header({"#", "CPU", "Time Stamp", "Task", "PID",
 	   "Latency", "Event", "Info"}),
-  _markA(-1),
-  _markB(-1)
+  _markA(KS_NO_ROW_SELECTED),
+  _markB(KS_NO_ROW_SELECTED)
 {}
 
 /**
@@ -311,10 +311,10 @@ void KsViewModel::selectRow(DualMarkerState state, int row)
 {
 	if (state == DualMarkerState::A) {
 		_markA = row;
-		_markB = -1;
+		_markB = KS_NO_ROW_SELECTED;
 	} else {
 		_markB = row;
-		_markA = -1;
+		_markA = KS_NO_ROW_SELECTED;
 	}
 }
 
diff --git a/kernel-shark/src/KsModels.hpp b/kernel-shark/src/KsModels.hpp
index 808c574..3faaf4a 100644
--- a/kernel-shark/src/KsModels.hpp
+++ b/kernel-shark/src/KsModels.hpp
@@ -28,6 +28,9 @@
 #include "libkshark-model.h"
 #include "KsSearchFSM.hpp"
 
+/** A negative row index, to be used for deselecting the Passive Marker. */
+#define KS_NO_ROW_SELECTED -1
+
 enum class DualMarkerState;
 
 class KsDataStore;
diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 61d7386..2881bd0 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -474,7 +474,7 @@ void KsTraceViewer::markSwitch()
 		 * The passive marker is not set.
 		 * Make sure that the model colors nothing.
 		 */
-		_model.selectRow(!state, -1);
+		_model.selectRow(!state, KS_NO_ROW_SELECTED);
 	}
 
 	/*
@@ -722,12 +722,12 @@ void KsTraceViewer::passiveMarkerSelectRow(int row)
 
 /**
  * Get the currently selected row. If no row is selected the function
- * returns -1.
+ * returns KS_NO_ROW_SELECTED (-1).
  */
 int KsTraceViewer::selectedRow()
 {
 	QItemSelectionModel *sm = _view.selectionModel();
-	int dataRow = -1;
+	int dataRow = KS_NO_ROW_SELECTED;
 
 	if (sm->hasSelection()) {
 		/* Only one row at the time can be selected. */
-- 
2.17.1

