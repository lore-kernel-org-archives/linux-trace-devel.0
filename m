Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC208C282DD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C374320685
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfDWN2G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:28:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39429 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfDWN2G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:28:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id n25so48691wmk.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Apr 2019 06:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQ5bu7Q2HlDV1Agt/54R/VPmV4hl5vSOySDWLM7upn8=;
        b=cNqGyH0TArqG5RET/AFBx+cJScFJS6b9mxovX/cYHX4MAT8uZkTSj/pqHWa5pz+5oB
         wotUeR1xwxIRyt7TpdOyk17mY/fdM95gBV9x8QLr38HW64ChPLk0GOCWCE2+WgZupFcY
         bEOeGGbv9pQ2zcZDVcZAET+XgstzqKo0AJqfpDe0ez/5WB7qXfcR339NuuiLXOkf5k9h
         8tmY1EPh/3FIxBupNdtiDM1BSXoSD3irk6aotVKxpkKBBtDUdmD9rOwG2ujUPEVkSwVJ
         UEts7BmVfAxjvteMwNFp3D85RKJ5X9PTt0BQv4COEvW6TQHlXgq3k8s4LiBcMGh6QWzH
         b4MQ==
X-Gm-Message-State: APjAAAWI26l3h1HhaQXMBOOdMSgafw6nVVLApYcY2YsOQ/MQlAcnvusL
        oGu97dqF041f+I+XnaruL6o=
X-Google-Smtp-Source: APXvYqw9YwJ08jGF5pxA9s86Bz8iw/5T4DcwE3+z9+jsxH8hl5blhk7t37kUtri+g6SaExhynwtTlQ==
X-Received: by 2002:a1c:6889:: with SMTP id d131mr2347449wmc.114.1556026084156;
        Tue, 23 Apr 2019 06:28:04 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w11sm31222231wre.15.2019.04.23.06.28.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 06:28:03 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/5] kernel-shark: Add logic for the plugins search path
Date:   Tue, 23 Apr 2019 16:27:39 +0300
Message-Id: <20190423132741.17864-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423132741.17864-1-ykaradzhov@vmware.com>
References: <20190423132741.17864-1-ykaradzhov@vmware.com>
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

