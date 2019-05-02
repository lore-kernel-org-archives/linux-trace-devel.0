Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159E7C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3CFF2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEBMqF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:46:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34482 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfEBMqF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:46:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id e9so3201952wrc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s7X8lzGxHFyxiXkBTtmd+4gn3gRD41VJ7VQmlcPc7Ws=;
        b=in0cqXxgjGnxt+nJlVSpRojiwap0J7oXmQN2JkU1ZbYgeyn6mVn+AjYl868IJQtLhQ
         9h2RBdj1rofpmEVtAsNWBrP3lEUgGl7Sl4JmeEhxgAhjTJ/3CBKRPxZt4IXSTqXro53y
         RgM/D/sKDi8/Rtnp9ku+R6vpQ1arm2J7ZL7Qe3WbfKegj4xAGfMO34dVYHI1/mX0MRQd
         2x+Jqu8I0oVBEq+hAFK3re5WQaq1v7Bs1hj77zeQAUoAy9NIG0F5/hicbNsoVl2Hjx3q
         ARMoLVk+KVL38uCmHXQ6VQHFXwhqNAV8GL4EXhlOb5uD+hSMumBcHCulXvj3d9bJBS+o
         W7ig==
X-Gm-Message-State: APjAAAWSzY4ea57gWgws5yjFrA0MZbh7mtxk/BQ7NGlgN1Bc4wxIf+J8
        ddvslQ8vEncCa3s2qrdLIOw=
X-Google-Smtp-Source: APXvYqw1yHhTU7c3y6lkTQ/9w2mkeB2odRhIZIwJS/9B7mK4kuCbt71X0vL5XHJ3ZNBeFhjKD1OjUQ==
X-Received: by 2002:a05:6000:1181:: with SMTP id g1mr2597063wrx.56.1556801163703;
        Thu, 02 May 2019 05:46:03 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c10sm10012949wrd.69.2019.05.02.05.46.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:46:03 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/2] kernel-shark: Add "Report bug" button to "Help"
Date:   Thu,  2 May 2019 15:45:36 +0300
Message-Id: <20190502124536.32463-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124536.32463-1-ykaradzhov@vmware.com>
References: <20190502124536.32463-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When clicked, the Bugzilla will be opened in the appropriate Web browser
for the user's desktop environment.

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

