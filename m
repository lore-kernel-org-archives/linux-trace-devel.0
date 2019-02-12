Return-Path: <SRS0=4mzf=QT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CB3C282CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD1C420700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfBLRE3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:04:29 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40510 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbfBLRE3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Feb 2019 12:04:29 -0500
Received: by mail-wm1-f66.google.com with SMTP id q21so3814021wmc.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Feb 2019 09:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ps63Xwwi5nXjvOYWpthjWVngj8bBpJNpSe9YgwRom0U=;
        b=LnW1wlwG90HaKLWd5kPESGLotWJh6jD2kvZOjyzqEP6gdevugggYCeTxYg8FEa3KDn
         bVJNmYBCW7g7m/Vxp3bqracwEO9BvmuYPR2Av/6QOFZ7Owi4SOI2DWbGykIe6rHGQfSE
         DeHz9ZeaS5aovcey7c2s829jnuDzTBoExk9V9g4Fdo7yjgFLhBqbAFayXfnflvF5/ziz
         tHd1koBbu6B61liZhs+Uup18/HuQtw0+HXgQmTcnbZFssMFY197ofxnZwpuiUbkPemnB
         YC+yCoVxPHIl9MWX9JPH87VVPX0ORdfI1Fu95PaUp1MkDJpENahX2QLp64CLAeizMBPt
         BKrA==
X-Gm-Message-State: AHQUAuaB6J/l3A7ZHPKNiT6fKhFekLSs+rLDoeSMAdZu0u+E834SU4ts
        t7tN7IBAs9LOO1w52gC4W8I=
X-Google-Smtp-Source: AHgI3IalFq/f5wudkbYjWM/KUA4/XgaZlCC+zDrOw8N71mpl/1DEZA4L8kYBbCQsZ5OqLCUVML4kiw==
X-Received: by 2002:a1c:9cce:: with SMTP id f197mr3655432wme.135.1549991067581;
        Tue, 12 Feb 2019 09:04:27 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c139sm5579732wmd.13.2019.02.12.09.04.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:04:27 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/5] kernel-shark: Define a method in View for selecting the Passive marker
Date:   Tue, 12 Feb 2019 19:03:59 +0200
Message-Id: <20190212170402.10104-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190212170402.10104-1-ykaradzhov@vmware.com>
References: <20190212170402.10104-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The same method can be used to deselect the Passive marker.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202327
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsTraceViewer.cpp | 16 ++++++++++++++++
 kernel-shark/src/KsTraceViewer.hpp |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 369c78e..61d7386 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -704,6 +704,22 @@ void KsTraceViewer::_searchItemsMapReduce(int column,
 		lamSearchReduce(_matchList, m.get());
 }
 
+/**
+ * @brief Color (select) the given row in the table, by using the color of the
+ * 	  Passive marker.
+ *
+ * @param row: The row index. If the Passive marker is selected and the input
+ *	        value is negative, the Passive marker will be deselected.
+ */
+void KsTraceViewer::passiveMarkerSelectRow(int row)
+{
+	DualMarkerState state = _mState->getState();
+
+	_view.setVisible(false);
+	_model.selectRow(!state, row);
+	_view.setVisible(true);
+}
+
 /**
  * Get the currently selected row. If no row is selected the function
  * returns -1.
diff --git a/kernel-shark/src/KsTraceViewer.hpp b/kernel-shark/src/KsTraceViewer.hpp
index f59f5df..cf529ba 100644
--- a/kernel-shark/src/KsTraceViewer.hpp
+++ b/kernel-shark/src/KsTraceViewer.hpp
@@ -68,6 +68,8 @@ public:
 
 	void clearSelection();
 
+	void passiveMarkerSelectRow(int row);
+
 	int selectedRow();
 
 	void update(KsDataStore *data);
-- 
2.17.1

