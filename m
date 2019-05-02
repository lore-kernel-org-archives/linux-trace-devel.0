Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9350EC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707D32075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEBMsy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:48:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36494 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfEBMsy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:48:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id p16so2461569wma.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iTaQEMdDKyzVeiyiwZKYOkIlTY4c7OgcVgSgP0/QoTY=;
        b=OPV5daViIVZnPXWtol2Qew5u2EY2KU5TSem9A+nKln1DQUXFtAB0Gaajo6QdV9ZqpX
         HU8D2FDGTwa7nF6pJMjmGyFiYItj48F7VLjfEmjGXdy8iiTixpTEBIpY9nIASwK+yIz1
         0SaxnFLRNryOrLfXKO9ScoWXqxP/1+Z30FFsg1oJS1pBKlpsLuJeHrQseNAUO3uhu+ca
         p6HrKZsjcv3RAMewcZ1jHAWfLQAhnDMhbaTrshwpgyglY2j/Ua+6SeSHQZc3FY8eOyFZ
         EBMDKxl6HQy8qYCy2xzSKRRQE5lNEFcbHSlVfTYUQ7QiO4s10zctmAf8GYMgtRTinfan
         8hGA==
X-Gm-Message-State: APjAAAUntq5iXdoJ/UI2XtYMl19/S51yBB/3p6vmMgsh8fClyu80ioXw
        FJXhLdb1DMaRvNm/fLWZheSHdlWc
X-Google-Smtp-Source: APXvYqx6Y5f+qkY+M5gS9+HSFRRwkk+Q7GW+aYbXeioGlyYpzzFCLgLIg8a4TVp4JC+x+ILxo98z3w==
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr2238197wmj.0.1556800835096;
        Thu, 02 May 2019 05:40:35 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:34 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v2 3/8] kernel-shark: Add logic for the plugins search path
Date:   Thu,  2 May 2019 15:40:04 +0300
Message-Id: <20190502124009.32208-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the application has not been started from its installation location
and the the directory

 app_file_path + "../../kernel-shark/lib"

exists, all build-in plugins will be loaded from this directory. In any
other case all build-in plugins will be loaded from

_INSTALL_PREFIX/lib/kshark/plugins/

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsUtils.cpp            | 40 ++++++++++++++++++-------
 kernel-shark/src/KsUtils.hpp            |  2 ++
 kernel-shark/src/plugins/CMakeLists.txt |  2 +-
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 8c42206..f62e53a 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -544,13 +544,12 @@ void KsPluginManager::_parsePluginList()
  */
 void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
 {
-	auto lamRegBuiltIn = [&kshark_ctx](const QString &plugin)
+	auto lamRegBuiltIn = [&kshark_ctx, this](const QString &plugin)
 	{
 		char *lib;
 		int n;
 
-		n = asprintf(&lib, "%s/lib/plugin-%s.so",
-			     KS_DIR, plugin.toStdString().c_str());
+		lib = _pluginLibFromName(plugin, n);
 		if (n <= 0)
 			return;
 
@@ -579,13 +578,12 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
  */
 void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
 {
-	auto lamUregBuiltIn = [&kshark_ctx](const QString &plugin)
+	auto lamUregBuiltIn = [&kshark_ctx, this](const QString &plugin)
 	{
 		char *lib;
 		int n;
 
-		n = asprintf(&lib, "%s/lib/plugin-%s.so",
-			     KS_DIR, plugin.toStdString().c_str());
+		lib = _pluginLibFromName(plugin, n);
 		if (n <= 0)
 			return;
 
@@ -608,6 +606,28 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
 			lamUregUser);
 }
 
+char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
+{
+	QString execPath = QCoreApplication::applicationFilePath();
+	QString path = QFileInfo(execPath).path();
+	std::string pluginStr = plugin.toStdString();
+	char *lib;
+	QDir dir;
+
+	dir.setCurrent(path);
+	if (!KsUtils::isInstalled() && dir.cd("../../kernel-shark/lib")) {
+		std::string pathStr = dir.path().toStdString();
+
+		n = asprintf(&lib, "%s/plugin-%s.so",
+			     pathStr.c_str(), pluginStr.c_str());
+	} else {
+		n = asprintf(&lib, "%s/lib/kshark/plugins/plugin-%s.so",
+			     _INSTALL_PREFIX, pluginStr.c_str());
+	}
+
+	return lib;
+}
+
 /**
  * @brief Register a Plugin.
  *
@@ -629,8 +649,7 @@ void KsPluginManager::registerPlugin(const QString &plugin)
 			 * The argument is the name of the plugin. From the
 			 * name get the library .so file.
 			 */
-			n = asprintf(&lib, "%s/lib/plugin-%s.so",
-					KS_DIR, plugin.toStdString().c_str());
+			lib = _pluginLibFromName(plugin, n);
 			if (n > 0) {
 				kshark_register_plugin(kshark_ctx, lib);
 				_registeredKsPlugins[i] = true;
@@ -691,8 +710,7 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
 			 * The argument is the name of the plugin. From the
 			 * name get the library .so file.
 			 */
-			n = asprintf(&lib, "%s/lib/plugin-%s.so", KS_DIR,
-				     plugin.toStdString().c_str());
+			lib = _pluginLibFromName(plugin, n);
 			if (n > 0) {
 				kshark_unregister_plugin(kshark_ctx, lib);
 				_registeredKsPlugins[i] = false;
@@ -700,7 +718,7 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
 			}
 
 			return;
-		} else if  (plugin.contains("/lib/plugin-" +
+		} else if (plugin.contains("/lib/plugin-" +
 			                   _ksPluginList[i], Qt::CaseInsensitive)) {
 			/*
 			 * The argument is the name of the library .so file.
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index 7b80b21..1c87271 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -241,6 +241,8 @@ signals:
 private:
 	void _parsePluginList();
 
+	char *_pluginLibFromName(const QString &plugin, int &n);
+
 	template <class T>
 	void _forEachInList(const QStringList &pl,
 			    const QVector<bool> &reg,
diff --git a/kernel-shark/src/plugins/CMakeLists.txt b/kernel-shark/src/plugins/CMakeLists.txt
index 6098275..64cf98d 100644
--- a/kernel-shark/src/plugins/CMakeLists.txt
+++ b/kernel-shark/src/plugins/CMakeLists.txt
@@ -29,6 +29,6 @@ BUILD_PLUGIN(NAME missed_events
 list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
 
 install(TARGETS sched_events missed_events
-        LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/)
+        LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/plugins/)
 
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-- 
2.20.1

