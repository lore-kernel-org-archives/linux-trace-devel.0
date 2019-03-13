Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FBDC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21A82214AE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfCMPHv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:07:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51787 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMPHu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:07:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id n19so2443006wmi.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0h2OYd+4fDOGzkfYdDN2PpY5KS+qCoACIVlWKMD3rI=;
        b=elSxK4CMGD/pHqJ/QaXnKZ80ktkXX/t9lwXJ1uZ69BhlLU8Oy1LgIk2gNhuUe7zzgd
         mw3P72elm9OAaMPyM4dLcmoO7HDuVpwjWHVgGP9eTCXlavGA2yo65UnVfC3TDepr+r9E
         5sTJs+6JbF4aS4GQOXz/sK/lnbJDmI9l+WS/jxP0iNvQmegQXgtmzn0eE7Ft00cqX0IY
         NJqMYIN8+jHbWCokBANrV+RGrmXg5in669qlXNIcEbRl75EyfMk2tVlWVFQElFl/iQsB
         u2qXYmcP5ZHmT2r8k0wcFbGuO7SN9GxFREUHxqcYIPGjDZ3NZsbTmatpexfGyX0kSox7
         9gww==
X-Gm-Message-State: APjAAAU9W86RC8DM8Y5RqJ+y22oRVETtZukjzz7mOueP4qBVlf7FT68z
        AkkstjifUBlMaqMN4X5GdEM=
X-Google-Smtp-Source: APXvYqyLhOxJ80B9g/0NMKYt6qHeEtXBJrJCesSAzF5fbrzgL7hVKwxD5xB4zZPuZwmsJ5WCM47XMA==
X-Received: by 2002:a1c:3c02:: with SMTP id j2mr2731286wma.72.1552489669077;
        Wed, 13 Mar 2019 08:07:49 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id f6sm22515103wrs.45.2019.03.13.08.07.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:07:48 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 2/4] kernel-shark: Add dialog for user-defined plugins to the Tools menu
Date:   Wed, 13 Mar 2019 17:07:15 +0200
Message-Id: <20190313150717.21345-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313150717.21345-1-ykaradzhov@vmware.com>
References: <20190313150717.21345-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The dialog allows the user to find and load the plugin's
lobrary (.so file).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 22 ++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 362b955..6428d4d 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -59,6 +59,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _cpuSelectAction("CPUs", this),
   _taskSelectAction("Tasks", this),
   _pluginsAction("Plugins", this),
+  _addPluginsAction("Add plugins", this),
   _captureAction("Record", this),
   _colorAction(this),
   _colSlider(this),
@@ -233,6 +234,11 @@ void KsMainWindow::_createActions()
 	connect(&_pluginsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_pluginSelect);
 
+	_addPluginsAction.setStatusTip("Add plugins");
+
+	connect(&_addPluginsAction,	&QAction::triggered,
+		this,			&KsMainWindow::_pluginAdd);
+
 	_captureAction.setIcon(QIcon::fromTheme("media-record"));
 	_captureAction.setShortcut(tr("Ctrl+R"));
 	_captureAction.setStatusTip("Capture trace data");
@@ -336,6 +342,7 @@ void KsMainWindow::_createMenus()
 	/* Tools menu */
 	tools = menuBar()->addMenu("Tools");
 	tools->addAction(&_pluginsAction);
+	tools->addAction(&_addPluginsAction);
 	tools->addAction(&_captureAction);
 	tools->addSeparator();
 	tools->addAction(&_colorAction);
@@ -796,6 +803,21 @@ void KsMainWindow::_pluginSelect()
 	dialog->show();
 }
 
+void KsMainWindow::_pluginAdd()
+{
+	QStringList fileNames;
+
+	fileNames =
+		QFileDialog::getOpenFileNames(this, "Add KernelShark plugins",
+					      KS_DIR,
+					      "KernelShark Plugins (*.so);;");
+
+	if (fileNames.isEmpty())
+		return;
+
+	_plugins.addPlugins(fileNames);
+}
+
 void KsMainWindow::_record()
 {
 #ifndef DO_AS_ROOT
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 969b603..1e6d619 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -132,6 +132,8 @@ private:
 	// Tools menu.
 	QAction		_pluginsAction;
 
+	QAction		_addPluginsAction;
+
 	QAction		_captureAction;
 
 	QWidgetAction	_colorAction;
@@ -185,6 +187,8 @@ private:
 
 	void _pluginSelect();
 
+	void _pluginAdd();
+
 	void _record();
 
 	void _setColorPhase(int);
-- 
2.19.1

