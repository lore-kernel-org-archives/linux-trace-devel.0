Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A57C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E60B220811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfCNPKc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:32 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:40889 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:32 -0400
Received: by mail-pf1-f179.google.com with SMTP id y124so4028822pfy.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PTU4K3LnWSxBmMJcYhJd6sNXwqo+Q5Fb+W5U3aL2RJQ=;
        b=f5V7IgpCVh8xnWwKXUUyB7sT7/mH88S7KaZzw0b5NQoInXhYD7wIgUgWyD/BSIM51H
         ZKDAOOqqD7nmLN6/71707GTCWFxKf0YJ4snUWuhNncZ7Izy4RZ35+3t4w9DLC7xmYX6N
         dP/xAoav9c/kOwoUKJPT5JsMmx3ahT0p7DXDg9u0ko6gO7cHL1cBIzaPZnZUgVoFDi4z
         3wwzGMvz7Hdf4m7v2IJOV2QFzuAEUjH98dIYea882iwb0X30mcEh8e+Iwafz1KXae1m0
         0t+VX0H95sdWITk5v96PFOQa3/pcBnF5ijHB+3MynBlat4PUg1jGjv/lWAo1fpZ+Xtvx
         kI3Q==
X-Gm-Message-State: APjAAAVhVMCgIheXEbq3cgdKHbIzSMYnFpaQggUvY/OYUtTcXUsfW5IO
        MFFat6JOsiFPc3AWNI6BOaWqWiS6
X-Google-Smtp-Source: APXvYqwsYhp8LacW3GVfd4ku5BfrXPoWWFl67VeL6/jQgv1Pwyi6DjYmn03bKLW8DRhzjuODQ+jlHg==
X-Received: by 2002:a62:ed06:: with SMTP id u6mr48700472pfh.132.1552576231924;
        Thu, 14 Mar 2019 08:10:31 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:31 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/12] kernel-shark: Fix a spelling typo in KsMainWindow class
Date:   Thu, 14 Mar 2019 17:10:01 +0200
Message-Id: <20190314151012.905-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

_restorSession*  -> _restoreSession*
                           ^

Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 12 ++++++------
 kernel-shark/src/KsMainWindow.hpp |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index a92944e..91e0c9f 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -43,7 +43,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _capture(this),
   _captureLocalServer(this),
   _openAction("Open", this),
-  _restorSessionAction("Restore Last Session", this),
+  _restoreSessionAction("Restore Last Session", this),
   _importSessionAction("Import Session", this),
   _exportSessionAction("Export Sassion", this),
   _quitAction("Quit", this),
@@ -167,9 +167,9 @@ void KsMainWindow::_createActions()
 	connect(&_openAction,	&QAction::triggered,
 		this,		&KsMainWindow::_open);
 
-	_restorSessionAction.setIcon(QIcon::fromTheme("document-open-recent"));
-	connect(&_restorSessionAction,	&QAction::triggered,
-		this,			&KsMainWindow::_restorSession);
+	_restoreSessionAction.setIcon(QIcon::fromTheme("document-open-recent"));
+	connect(&_restoreSessionAction,	&QAction::triggered,
+		this,			&KsMainWindow::_restoreSession);
 
 	_importSessionAction.setIcon(QIcon::fromTheme("document-send"));
 	_importSessionAction.setStatusTip("Load a session");
@@ -291,7 +291,7 @@ void KsMainWindow::_createMenus()
 
 	sessions = file->addMenu("Sessions");
 	sessions->setIcon(QIcon::fromTheme("document-properties"));
-	sessions->addAction(&_restorSessionAction);
+	sessions->addAction(&_restoreSessionAction);
 	sessions->addAction(&_importSessionAction);
 	sessions->addAction(&_exportSessionAction);
 	file->addAction(&_quitAction);
@@ -377,7 +377,7 @@ QString KsMainWindow::lastSessionFile()
 	return QString(file) +  "/lastsession.json";
 }
 
-void KsMainWindow::_restorSession()
+void KsMainWindow::_restoreSession()
 {
 	loadSession(lastSessionFile());
 	_graph.updateGeom();
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index c479520..1ecf2d8 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -99,7 +99,7 @@ private:
 	// File menu.
 	QAction		_openAction;
 
-	QAction		_restorSessionAction;
+	QAction		_restoreSessionAction;
 
 	QAction		_importSessionAction;
 
@@ -155,7 +155,7 @@ private:
 
 	void _open();
 
-	void _restorSession();
+	void _restoreSession();
 
 	void _importSession();
 
-- 
2.19.1

