Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D1CC282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82D712171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfDSTiS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:38:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35150 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfDSTiS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 15:38:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id o12so4704696wrn.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 12:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NpbI2S9bGcE5lSFNoNpvOl10ZZyAD69vRiUg/1cQPf8=;
        b=uV3XiXpco25WJriMSCHJlxy7ElqcX2XWQcKdvspGMbsYhkRInhcv3abC10W4KXDeVb
         OF+OwodfbMWUtq21flb/xatNpz+9nLgO9KDMuwEQy0liHNoZXbV2M1iBN7QAIdWQ+Xgm
         7IfVh3Vaj5mHYDKjuDM2chkeotW/q/1GwwTcQfKRuFkrkDZLTqwztWWhAIyX+mkg+CMp
         iy5Bx18BwEfQA1ImHST72bo4AW6yqsw57tYBVEx6s5V0Gozr46b3g8k+JnPuQHziSpAc
         FDnkO4Wgx4lzOHfsvSkQL87Yg48OutRfOHF88roV9k6XOOczshzaEqbLhPqUW6J0KgFN
         xmIw==
X-Gm-Message-State: APjAAAVhwVqryo+Pne34qIq+W2ez/ueHpomVxRgzeZaXMB1QeBrOyTWU
        aQNEbAoEQI0CJns4jUclZa1kPD5F
X-Google-Smtp-Source: APXvYqwgoP/5Fs3y/3X1NO609vMfuHpkuDai6s0b/3yoYZZ7AwZ2dkN0sQveL9Gsr1b9xzrk7Q5Ksg==
X-Received: by 2002:a5d:52ce:: with SMTP id r14mr3262232wrv.224.1555681865688;
        Fri, 19 Apr 2019 06:51:05 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g132sm4120496wme.3.2019.04.19.06.51.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 06:51:05 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 8/8] kernel-shark: Handle the case when the marker points to a filtered entry
Date:   Fri, 19 Apr 2019 16:50:36 +0300
Message-Id: <20190419135036.19340-9-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190419135036.19340-1-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Markers can point to entries that are filtered out. When switching
the marker it may happen that new Active Marker points to an entry
that is filtered. In this case no actions must be taken and a warning
message for the user must be displayed.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsTraceViewer.cpp | 27 +++++++++++++++++----------
 kernel-shark/src/KsTraceViewer.hpp |  2 ++
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 04a38b8..85da64f 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -61,7 +61,8 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
   _graphFollowsCheckBox(this),
   _graphFollows(true),
   _mState(nullptr),
-  _data(nullptr)
+  _data(nullptr),
+  _em(this)
 {
 	this->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Maximum);
 
@@ -493,15 +494,21 @@ void KsTraceViewer::markSwitch()
 		QModelIndex index =
 			_proxyModel.mapFromSource(_model.index(row, 0));
 
-		/*
-		 * The row of the active marker will be colored according to
-		 * the assigned property of the current state of the Dual
-		 * marker. Auto-scrolling is temporarily disabled because we
-		 * do not want to scroll to the position of the marker yet.
-		 */
-		_view.setAutoScroll(false);
-		_view.selectRow(index.row());
-		_view.setAutoScroll(true);
+		if (index.isValid()) {
+			/*
+			 * The row of the active marker will be colored according to
+			 * the assigned property of the current state of the Dual
+			 * marker. Auto-scrolling is temporarily disabled because we
+			 * do not want to scroll to the position of the marker yet.
+			 */
+			_view.setAutoScroll(false);
+			_view.selectRow(index.row());
+			_view.setAutoScroll(true);
+		} else {
+			_view.clearSelection();
+			QString err("The marker's entry is filtered out.");
+			_em.showMessage(err);
+		}
 	} else {
 		_view.clearSelection();
 	}
diff --git a/kernel-shark/src/KsTraceViewer.hpp b/kernel-shark/src/KsTraceViewer.hpp
index cf529ba..15eee50 100644
--- a/kernel-shark/src/KsTraceViewer.hpp
+++ b/kernel-shark/src/KsTraceViewer.hpp
@@ -119,6 +119,8 @@ private:
 
 	KsDataStore		*_data;
 
+	QErrorMessage	_em;
+
 	enum Condition
 	{
 		Containes = 0,
-- 
2.20.1

