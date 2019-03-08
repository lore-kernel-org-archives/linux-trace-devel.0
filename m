Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E41C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845AD20851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbfCHROi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:14:38 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46476 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfCHROi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:14:38 -0500
Received: by mail-wr1-f42.google.com with SMTP id i16so22141036wrs.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:14:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEMG8i3cd/bPD/fZYAvwM7m/cMijjdt0l3+lKT1OcB4=;
        b=abKHe208lo74o8thj2vfu89odI9mBj04z9VDJCQc3GlXkuKXsvMTppoPW5jjfhKqz/
         wNilGep6BJ5Zp7CsHh4FXzZSO0/rVI4qVWOUQWsFafH6/sJ+zWmIlyC8E67NciNiLRJ9
         pCPdq6ATAQaz+bpgJFP+z8JtXMxmPabkW9QuoV5ZBGT99q+wpR20g0y2NgK4ce5EZbsr
         iKbz3afPFOcHk3G42DoGkgSN7JE75Rswz1oMEMBEkEmo/clZEDc6SbY2tC15ezxPn5e2
         3yg+v9RqLk8aQRH/LQHU47xU4Vqf0nRLUNl8V7v6gq5H3/Dbng9540ozfnKVKEac7+EA
         xC9g==
X-Gm-Message-State: APjAAAXIr4hdq3ZlxQsAm7WuymJxmnrKRWUYS/PWIYLJl727L5MTBHtK
        mBvvXRNO3MkwpkXcUEggMvw=
X-Google-Smtp-Source: APXvYqxpJzfOaWfhBIyvQ+caFRNmS+pGQJMuHZYgw6HiyrvnywRRbUrUY2iDJncC2zeF63sE7MmcUg==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr2866477wrs.249.1552065276449;
        Fri, 08 Mar 2019 09:14:36 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id o5sm6126796wmh.12.2019.03.08.09.14.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:14:36 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/4] kernel-shark: Rename the manu action for managing registered plugins
Date:   Fri,  8 Mar 2019 19:14:04 +0200
Message-Id: <20190308171405.15266-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190308171405.15266-1-ykaradzhov@vmware.com>
References: <20190308171405.15266-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The menu action in Tools that is used to manage all registered
plugins is renamed in order to avoid confusion with the "Add plugin"
menu action, implemented in the previous patch.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 10 +++++-----
 kernel-shark/src/KsMainWindow.hpp |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 004c9ac..f6889ca 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -58,7 +58,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _clearAllFilters("Clear all filters", this),
   _cpuSelectAction("CPUs", this),
   _taskSelectAction("Tasks", this),
-  _pluginsAction("Plugins", this),
+  _managePluginsAction("Manage plugins", this),
   _addPluginAction("Add plugin", this),
   _captureAction("Record", this),
   _colorAction(this),
@@ -228,10 +228,10 @@ void KsMainWindow::_createActions()
 		this,			&KsMainWindow::_taskSelect);
 
 	/* Tools menu */
-	_pluginsAction.setShortcut(tr("Ctrl+P"));
-	_pluginsAction.setStatusTip("Manage plugins");
+	_managePluginsAction.setShortcut(tr("Ctrl+P"));
+	_managePluginsAction.setStatusTip("Manage plugins");
 
-	connect(&_pluginsAction,	&QAction::triggered,
+	connect(&_managePluginsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_pluginSelect);
 
 	_addPluginAction.setStatusTip("Add plugin");
@@ -341,7 +341,7 @@ void KsMainWindow::_createMenus()
 
 	/* Tools menu */
 	tools = menuBar()->addMenu("Tools");
-	tools->addAction(&_pluginsAction);
+	tools->addAction(&_managePluginsAction);
 	tools->addAction(&_addPluginAction);
 	tools->addAction(&_captureAction);
 	tools->addSeparator();
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index a4eed19..0727631 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -130,7 +130,7 @@ private:
 	QAction		_taskSelectAction;
 
 	// Tools menu.
-	QAction		_pluginsAction;
+	QAction		_managePluginsAction;
 
 	QAction		_addPluginAction;
 
-- 
2.19.1

