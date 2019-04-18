Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90258C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66D8520821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbfDRPXA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:23:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34995 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388806AbfDRPXA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:23:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id o12so135581wrn.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jMt/F/C22Sx4zYZaLZAVwDW0byrHT7ynGVqvNmmTXgA=;
        b=cHiyHdDlKNWn8MLqkhQnbrZIRY62uAkohI804/mFPp6RMRujEXkjsXtWyHvVtufi1d
         WYecwEtCIsH5NQeU6TE66pE0woNlm7YZSSY7oirvre2PCpJSo8HMTKqya0VGr1le+h0+
         SooWpv+Gb4IC3vEQb7fa5qHw/AFacaXHPvr+qFwOtx+++2D5MrKNdbhoIjQoVcHnACY5
         p7nY7OgbXLekqXO1UdQ9/vgf+lARrNTox3rrFpYG60dhJOAxq041MITEEQjGisB9qqq2
         ssq6vZ09SNFMBMM8MmEkxkRfZ5Fn7zZrGcySEPap4846Yd4bSfNh04e7OH0u0uJKRWHM
         BLDw==
X-Gm-Message-State: APjAAAUZ3hVeTCBS4a4A2lSM5/jZpf4piaIMSQhR6uY+zdoz362HmCEA
        vbHSeJO+r9yvrrmI6bAIKgI=
X-Google-Smtp-Source: APXvYqwtLwVJ4KAzB9vVXXhqOhjcEOxYBTqKqwc1Z+qByqxUpqjf3nLwyrv8X8RSjyV1luudQL6BYQ==
X-Received: by 2002:a5d:6050:: with SMTP id j16mr57027887wrt.253.1555600978514;
        Thu, 18 Apr 2019 08:22:58 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:58 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 8/8] kernel-shark: Handle the case when the marker points to a filtered entry
Date:   Thu, 18 Apr 2019 18:21:46 +0300
Message-Id: <20190418152146.27232-9-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
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
2.19.1

