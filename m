Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1D3C04E53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723CB20843
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfEOTK3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:10:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40978 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfEOTK3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:10:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id q17so446615pfq.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 12:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6WfPlN+10nuwKB/nKrdeUrA0kgkdFfN2WWZpTnbQank=;
        b=rp3vPhFx4+W5OjeqlWQ7w/EpnpT0vDVP8xY/9Fw6QAvpcEVUGGEsMGJLDFbozzxxqb
         cgUbHUTVJB/1YLMjqmNn+/Jf9OWDek/+YleP6Pbeb1gfLrYBVu5DSpJVC87x8GNAw24G
         UGF/9VbwL+7ZJUmvNNtOrcO1EQGK2iA+HLSgHrZlaGytAe2YE4EVyAN33tTwu3S6ehFq
         x2aqXVqSyKp7GkOCxp5sDALgnl7cRxBJlbn0Ib13hTqHDMB8cUxDZAxSFDYxgXoTqpWs
         VklVvNK/mbN2c/OtFDcjOFimWL6LINEyCuBjF7iYDMQ/3iGhakN4SFWDS9IzqwHWwKdB
         If2g==
X-Gm-Message-State: APjAAAXHYwmK2R+Um9QNMw9f9/cGIRpD5AX0XKME55cdVoC3FOghUJ4E
        A1j95M6xGAWWlIJRmCBO7K8=
X-Google-Smtp-Source: APXvYqyWqrt7eP1ofADfgDMabVTlM/Kmvwuu+sslvNyM54Pkzq9INK9DURFlmJYk82sZ/NOD3M9HTA==
X-Received: by 2002:a62:2cc2:: with SMTP id s185mr10288532pfs.106.1557947428658;
        Wed, 15 May 2019 12:10:28 -0700 (PDT)
Received: from localhost.localdomain (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l65sm5772595pfb.7.2019.05.15.12.10.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:10:28 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH 4/6] kernel-shark: Add "Report bug" button to "Help"
Date:   Wed, 15 May 2019 12:09:09 -0700
Message-Id: <20190515190911.20755-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515190911.20755-1-ykaradzhov@vmware.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When clicked, the Bugzilla will be opened in the appropriate Web browser
for the user's desktop environment.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 13 +++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 3cf10bc..c7c7f6b 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -67,6 +67,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _fullScreenModeAction("Full Screen Mode", this),
   _aboutAction("About", this),
   _contentsAction("Contents", this),
+  _bugReportAction("Report a bug", this),
   _deselectShortcut(this),
   _settings("kernelshark.org", "Kernel Shark") // organization , application
 {
@@ -288,6 +289,9 @@ void KsMainWindow::_createActions()
 	_contentsAction.setIcon(QIcon::fromTheme("help-contents"));
 	connect(&_contentsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_contents);
+
+	connect(&_bugReportAction,	&QAction::triggered,
+		this,			&KsMainWindow::_bugReport);
 }
 
 void KsMainWindow::_createMenus()
@@ -365,6 +369,7 @@ void KsMainWindow::_createMenus()
 	help = menuBar()->addMenu("Help");
 	help->addAction(&_aboutAction);
 	help->addAction(&_contentsAction);
+	help->addAction(&_bugReportAction);
 }
 
 void KsMainWindow::_open()
@@ -925,6 +930,14 @@ void KsMainWindow::_contents()
 				  QUrl::TolerantMode));
 }
 
+void KsMainWindow::_bugReport()
+{
+	QUrl bugs("https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---",
+		  QUrl::TolerantMode);
+
+	QDesktopServices::openUrl(bugs);
+}
+
 /** Load trace data for file. */
 void KsMainWindow::loadDataFile(const QString& fileName)
 {
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 962de2d..22700d9 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -151,6 +151,8 @@ private:
 
 	QAction		_contentsAction;
 
+	QAction		_bugReportAction;
+
 	QShortcut	_deselectShortcut;
 
 	QString		_lastDataFilePath, _lastConfFilePath, _lastPluginFilePath;
@@ -205,6 +207,8 @@ private:
 
 	void _contents();
 
+	void _bugReport();
+
 	void _captureStarted();
 
 	void _captureError(QProcess::ProcessError error);
-- 
2.20.1

