Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B276C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 08:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiBPI3o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 03:29:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBPI3n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 03:29:43 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F129C13C
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 00:29:32 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id d10so2813756eje.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 00:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A9FjkmvWrmWqF3Tm3XHSij0+m9tBC79x9xqT2+lWhy0=;
        b=R5CDyCNyudbRGX6lK7TX/0HtOm/mr0xV2GejoIPZF3kvbAJxBF3RqCyhosi2Jh31dY
         mDiIK4uOm4OJwAWi7lJ0VG6MP5BarnoMWina3BYQPYdapKz0qMcf+j9ghIVUfNKEDBfH
         NgE6dpXVQ5DFvNVast3mGs1GZiE1rYgE4GM0NJZclrCHwWjsdN7s7cLbqrgkOceh+lPH
         JK77PmqhD5C0v1tk09CZtp2LHCX1HK7Tqq2NFvQ+Uu08tpCVoxGJAkMhKoczqWGiiysk
         dkKwJyOID8h1KpDtB4ADlNHDEI4q3CBgsMCcRCXYtgteYZ87RfFeNbPkh59YHBFfWoU0
         ZDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A9FjkmvWrmWqF3Tm3XHSij0+m9tBC79x9xqT2+lWhy0=;
        b=vE5br8cqdv5MzW9uIvgZzpq1CA65zvzJdxk0Cq+9yrnGmzFlErS8JoDQN8ZNPOXvTO
         BCMi9w0uXEeiMgbJOpMalgpDfc/OGRJWv0y4Igk7Fv4MFAONqc1W9voquSh1npa3pJNf
         gnnMF65XaKiqVxkEHYViibH/MDPrzCF4LbaoqBhkUeTtjhI+QspJbvvZwYCnLmpYWu2f
         gdngIhhIN4EECSu0Mzb1yHLA6WFF5gchrWrPchyDnWeeAPN/vHGeZCDv7uP1wP03Wpx4
         04e9Tg+pLHqdr4Rs1kq0sGTL17uMWPHuOBQZgha/i/RryYYeWc+cxRLVYqN0CjazQUKy
         g1Hg==
X-Gm-Message-State: AOAM531sZ+8Lq7CxUeoMyguaVd8zX89XcN/EvSb2qD2tMpSThEgLtTvY
        0RYPoaBROow9dT2HEd7ujZjIdXD5TXo=
X-Google-Smtp-Source: ABdhPJy7zLWN3fIXa9kEClmQdOuYyJf3NNUJZkQLHwW+aiOGrQv0eQ6oHFrVYFkR90BIIdLw3PntZw==
X-Received: by 2002:a17:907:954f:b0:6ad:3614:73e6 with SMTP id ex15-20020a170907954f00b006ad361473e6mr1346601ejc.731.1645000170196;
        Wed, 16 Feb 2022 00:29:30 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id v18sm2592998ejk.125.2022.02.16.00.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:29:29 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     hongzhan.chen@intel.com, jan.kiszka@siemens.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Load 'ctrl' interface for user plugins
Date:   Wed, 16 Feb 2022 10:29:09 +0200
Message-Id: <20220216082909.614231-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220216082909.614231-1-y.karadz@gmail.com>
References: <20220216082909.614231-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, the 'ctrl' interface of all plugins gets called in the
constructor of the MainWindow widget. This works well for the built-in
plugins because the list of those plugins is known in advance. However,
the list of user plugins is populated dynamically, hence it is not known
by the time the constructor of the widget is called. The problem is
solved by making sure we call the 'ctrl' interface every time we load
a user plugin from the menus of the GUI or at start as a command line
option.

Reported-by: Hongzhan Chen <hongzhan.chen@intel.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsUtils.cpp | 35 +++++++++++++++++++++++++----------
 src/KsUtils.hpp |  2 ++
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index a22c445..e3e16ae 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -1190,6 +1190,20 @@ QVector<int> KsPluginManager::getPluginsByStatus(int sd, int status) const
 	return vec;
 }
 
+void KsPluginManager::_registerCtrlInterface(kshark_plugin_list *plugin)
+{
+	if (!plugin->handle || !plugin->ctrl_interface)
+		return;
+
+	void *dialogPtr = plugin->ctrl_interface(parent());
+	if (dialogPtr) {
+		QWidget *dialog = static_cast<QWidget *>(dialogPtr);
+
+		if (dialog && _pluginDialogs.indexOf(dialog) < 0)
+			_pluginDialogs.append(dialog);
+	}
+}
+
 /**
  * @brief Loop over the registered plugins and register all plugin-defined
  *	  menus (if any).
@@ -1203,14 +1217,7 @@ void KsPluginManager::registerPluginMenues()
 		return;
 
 	for (plugin = kshark_ctx->plugins; plugin; plugin = plugin->next)
-		if (plugin->handle && plugin->ctrl_interface) {
-			void *dialogPtr = plugin->ctrl_interface(parent());
-			if (dialogPtr) {
-				QWidget *dialog =
-					static_cast<QWidget *>(dialogPtr);
-				_pluginDialogs.append(dialog);
-			}
-		}
+		_registerCtrlInterface(plugin);
 }
 
 std::string KsPluginManager::_pluginLibFromName(const QString &plugin)
@@ -1247,11 +1254,17 @@ std::string KsPluginManager::_pluginNameFromLib(const QString &plugin)
  * @param pluginNames: Provide here the names of the plugin (as in the
  *		       CMake-generated header file) or the names of the
  *		       plugin's library files (.so including path).
- * 		       The names must be comma separated.
+ *		       The names must be comma separated.
  */
 void KsPluginManager::registerPlugins(const QString &pluginNames)
 {
-	_userPlugins.append(_loadPluginList(pluginNames.split(',')));
+	QVector<kshark_plugin_list *> plugins;
+
+	plugins = _loadPluginList(pluginNames.split(','));
+	for (auto const &p: plugins)
+		_registerCtrlInterface(p);
+
+	_userPlugins.append(plugins);
 }
 
 /**
@@ -1369,6 +1382,8 @@ void KsPluginManager::addPlugins(const QStringList &fileNames,
 		return;
 
 	plugins = _loadPluginList(fileNames);
+	for (auto const &p: plugins)
+		_registerCtrlInterface(p);
 	_userPlugins.append(plugins);
 
 	if (streamIds.isEmpty())
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index 1a97d9e..e42b6da 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -330,6 +330,8 @@ private:
 	QVector<kshark_plugin_list *>
 	_loadPluginList(const QStringList &plugins);
 
+	void _registerCtrlInterface(kshark_plugin_list *plugin);
+
 	std::string _pluginLibFromName(const QString &plugin);
 
 	std::string _pluginNameFromLib(const QString &plugin);
-- 
2.32.0

