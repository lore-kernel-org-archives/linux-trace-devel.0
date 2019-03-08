Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE831C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DB9220851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfCHROh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:14:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36358 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfCHROh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:14:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id j125so13103516wmj.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:14:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d8qIf07kLv3HxeAuVR8KpZN9q8ZltOAblg+BDgthPg8=;
        b=sj/rolefxO2bR1JQScNTV0hKjT9SfT+J/6nFGrwSv/40rJ5uhNDKfdPUKq98ZNUle1
         Vu/MgrFdJKnxD7AUeKD7Pm5zT4aV4nrUOfm1F4Xb9JVZKJJFynTy6vSyl9WdswDBVdYN
         h8gVHOTruN1M7z2cJ/xxZqse2B8vDoCsvguIozLCDeanpSp485aTYSfOjj1cBda8gXdo
         1cM4KVGxPq2qETJ2If8wjfHdJSQkKNrUPbHiC3nUmJjZgaYkc6xK6T0JQZkhV3mmu9aU
         RZ/4SxkCjSXbWtJYGMobby/6st0qfics04VRJr22SSLKMkEWf5HphSRB08/sWHBa/Yvz
         H+ZA==
X-Gm-Message-State: APjAAAUgHDBt6yuUKJSnmwiGK/X9ZHSBLgwKQcuyLwUpYrt7nad0Xl0q
        mm2pusISbSvEsK/7cdsa+bM=
X-Google-Smtp-Source: APXvYqxAyuQ/F4QNO/pXtBfFp/W2c8l8E/c+V9E3uUQL4onbcMT3hmfQCKuQctovM+n+gqdDY+DdUA==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr9697814wml.4.1552065274992;
        Fri, 08 Mar 2019 09:14:34 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id o5sm6126796wmh.12.2019.03.08.09.14.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:14:34 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/4] kernel-shark: Add dialog for user-defined plugin to the Tools menu
Date:   Fri,  8 Mar 2019 19:14:03 +0200
Message-Id: <20190308171405.15266-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190308171405.15266-1-ykaradzhov@vmware.com>
References: <20190308171405.15266-1-ykaradzhov@vmware.com>
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
 kernel-shark/src/KsMainWindow.cpp | 20 ++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 362b955..004c9ac 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -59,6 +59,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _cpuSelectAction("CPUs", this),
   _taskSelectAction("Tasks", this),
   _pluginsAction("Plugins", this),
+  _addPluginAction("Add plugin", this),
   _captureAction("Record", this),
   _colorAction(this),
   _colSlider(this),
@@ -233,6 +234,11 @@ void KsMainWindow::_createActions()
 	connect(&_pluginsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_pluginSelect);
 
+	_addPluginAction.setStatusTip("Add plugin");
+
+	connect(&_addPluginAction,	&QAction::triggered,
+		this,			&KsMainWindow::_pluginAdd);
+
 	_captureAction.setIcon(QIcon::fromTheme("media-record"));
 	_captureAction.setShortcut(tr("Ctrl+R"));
 	_captureAction.setStatusTip("Capture trace data");
@@ -336,6 +342,7 @@ void KsMainWindow::_createMenus()
 	/* Tools menu */
 	tools = menuBar()->addMenu("Tools");
 	tools->addAction(&_pluginsAction);
+	tools->addAction(&_addPluginAction);
 	tools->addAction(&_captureAction);
 	tools->addSeparator();
 	tools->addAction(&_colorAction);
@@ -796,6 +803,19 @@ void KsMainWindow::_pluginSelect()
 	dialog->show();
 }
 
+void KsMainWindow::_pluginAdd()
+{
+	QString fileName;
+
+	fileName = QFileDialog::getOpenFileName(this, "Add KernelShark plugin", KS_DIR,
+						"KernelShark Plugins (*.so);;");
+
+	if (fileName.isEmpty())
+		return;
+
+	_plugins.addPlugin(fileName);
+}
+
 void KsMainWindow::_record()
 {
 #ifndef DO_AS_ROOT
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 969b603..a4eed19 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -132,6 +132,8 @@ private:
 	// Tools menu.
 	QAction		_pluginsAction;
 
+	QAction		_addPluginAction;
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

