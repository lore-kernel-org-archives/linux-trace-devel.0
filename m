Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043C3C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D18C7214AE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfCMPHw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:07:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35518 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMPHw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:07:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id y15so2271225wma.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e2+ML2lpSIwhj2QPgw+Z9SlnkrCwUyUcM+MPXVLqLo8=;
        b=L2/6lW0tni2rOgl3PCjI+chrPuNYCriqfQCBKFJkZP0wiEKMjScpK/0YmbjxgJMSQC
         u4s+bVrW0cFw/nLGxAhOzKEt4ugUgHCclr7NVHwWRNz8wa0bC4mtgngck5RwNI7EG4pk
         hJS8kLyEDh4+lvNiuvXjJ2W0+EUkj8gW79En2ko5i0+gYWbfAfud0Hpfsh4+LHiSi2Vb
         ZyAmSP4jQCClavrrwOJja8MN3hNDmpkw3bBYaBU26VA81oRq8gq/rTqyJ4gtMYnGZR8Q
         2S5xyuzt+hu0gFTm1BcaKABYoy15mIIGtgWu6diSeBqsiN96t6nErKnrQaOokyHB5Ev4
         dkWg==
X-Gm-Message-State: APjAAAUJsDz7ADq1kh0maRd1zpFAN4ZwK7i7zXa4A0C0hMqbmD7okcJr
        zBjhKZvGe5P1qHTvNsCVwqc=
X-Google-Smtp-Source: APXvYqzHUxeJtAABbkiYEynSPwbWWePrNNNrIlrT8uAerRe+WrgSAgxBboqBAh3TiptJQjG2KdJ4Uw==
X-Received: by 2002:a7b:c413:: with SMTP id k19mr2713426wmi.75.1552489670342;
        Wed, 13 Mar 2019 08:07:50 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id f6sm22515103wrs.45.2019.03.13.08.07.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:07:49 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 3/4] kernel-shark: Rename the manu action for managing registered plugins
Date:   Wed, 13 Mar 2019 17:07:16 +0200
Message-Id: <20190313150717.21345-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313150717.21345-1-ykaradzhov@vmware.com>
References: <20190313150717.21345-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The menu action in Tools that is used to manage all registered
plugins is renamed in order to avoid confusion with the "Add plugins"
menu action, implemented in the previous patch.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 10 +++++-----
 kernel-shark/src/KsMainWindow.hpp |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 6428d4d..f165797 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -58,7 +58,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _clearAllFilters("Clear all filters", this),
   _cpuSelectAction("CPUs", this),
   _taskSelectAction("Tasks", this),
-  _pluginsAction("Plugins", this),
+  _managePluginsAction("Manage plugins", this),
   _addPluginsAction("Add plugins", this),
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
 
 	_addPluginsAction.setStatusTip("Add plugins");
@@ -341,7 +341,7 @@ void KsMainWindow::_createMenus()
 
 	/* Tools menu */
 	tools = menuBar()->addMenu("Tools");
-	tools->addAction(&_pluginsAction);
+	tools->addAction(&_managePluginsAction);
 	tools->addAction(&_addPluginsAction);
 	tools->addAction(&_captureAction);
 	tools->addSeparator();
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 1e6d619..a93382a 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -130,7 +130,7 @@ private:
 	QAction		_taskSelectAction;
 
 	// Tools menu.
-	QAction		_pluginsAction;
+	QAction		_managePluginsAction;
 
 	QAction		_addPluginsAction;
 
-- 
2.19.1

