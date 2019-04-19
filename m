Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB67C282DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CD6720821
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfDSTTs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:19:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55068 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfDSTTs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 15:19:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id c1so7142927wml.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 12:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O0UuVyUaj6gRC5oVMlVkfjA3JGzFPAwr7A83t9IIslI=;
        b=OYdrnUFsLMLTw29zsGtbl0XGNTayvTWEjoCqL3YwIwlhFQ5BUQAoG1JoYtx4JsEIkS
         3wkl/SttHThDOtLV8jPxoK5g5ng7nIH45oRrsHP1B6t4zNbQ8/FSB5xZN+zbxoRycV31
         Ryy0BA+h8dtq4fo1eNkyLhNoqtqk1Cv3gQpKVfE4YFkZRwv+LeAGAX/t4BpHNmx0YqTb
         baYOxD9q65A1LtYi0A9ZByZXIuTFaUi+4+48Gdj2Ls5Xl193/tTngiNiwRO3/SdWkL8s
         fR/neICfuKqjiygPdk4FCKnAQW8w4w2Dv4CW32R5ebzCkDaoZm5T1rlau9YwFA6NqI1h
         SSOQ==
X-Gm-Message-State: APjAAAU4dHHSGy8DpIk9QWYjv+4xsBYUFqEvvi+d0wR0mOQjxjCSD4lz
        6IECkfHHn6DM4MJ1THvJetEQI2jK
X-Google-Smtp-Source: APXvYqzsKmhQd4pOkE6TH3zt4PrEKH0XWWDiKNFh6I4AiEpITAwYt6Of9RvL62lSP3KtMvu+pXW1tw==
X-Received: by 2002:a7b:ce84:: with SMTP id q4mr2900033wmj.41.1555681860670;
        Fri, 19 Apr 2019 06:51:00 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g132sm4120496wme.3.2019.04.19.06.51.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 06:51:00 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 4/8] kernel-shark: Add logic for the plugins search path
Date:   Fri, 19 Apr 2019 16:50:32 +0300
Message-Id: <20190419135036.19340-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190419135036.19340-1-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the application has been started from the source code directory, all
build-in plugins will be loaded from kernel-shark/lib/
If the application has been started from its installation location, all
build-in plugins will be loaded from INSTALL_PREFIX/lib/kshark/plugins/

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/deff.h.cmake         |  3 +++
 kernel-shark/src/KsUtils.cpp            | 35 +++++++++++++++++--------
 kernel-shark/src/KsUtils.hpp            |  1 +
 kernel-shark/src/plugins/CMakeLists.txt |  2 +-
 4 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index 8041cfc..ba211f4 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -14,6 +14,9 @@
 /** KernelShark source code path. */
 #cmakedefine KS_DIR "@KS_DIR@"
 
+/** KernelShark installation prefix path. */
+#cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
+
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
 
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 6af0c66..b05c0dc 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -423,13 +423,12 @@ void KsPluginManager::_parsePluginList()
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
 
@@ -458,13 +457,12 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
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
 
@@ -487,6 +485,23 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
 			lamUregUser);
 }
 
+char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
+{
+	QString path = QCoreApplication::applicationFilePath();
+	std::string pluginStr = plugin.toStdString();
+	char *lib;
+
+	if (path.contains(KS_DIR)) {
+		n = asprintf(&lib, "%s/lib/plugin-%s.so",
+			     KS_DIR, pluginStr.c_str());
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
@@ -508,8 +523,7 @@ void KsPluginManager::registerPlugin(const QString &plugin)
 			 * The argument is the name of the plugin. From the
 			 * name get the library .so file.
 			 */
-			n = asprintf(&lib, "%s/lib/plugin-%s.so",
-					KS_DIR, plugin.toStdString().c_str());
+			lib = _pluginLibFromName(plugin, n);
 			if (n > 0) {
 				kshark_register_plugin(kshark_ctx, lib);
 				_registeredKsPlugins[i] = true;
@@ -570,8 +584,7 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
 			 * The argument is the name of the plugin. From the
 			 * name get the library .so file.
 			 */
-			n = asprintf(&lib, "%s/lib/plugin-%s.so", KS_DIR,
-				     plugin.toStdString().c_str());
+			lib = _pluginLibFromName(plugin, n);
 			if (n > 0) {
 				kshark_unregister_plugin(kshark_ctx, lib);
 				_registeredKsPlugins[i] = false;
@@ -579,7 +592,7 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
 			}
 
 			return;
-		} else if  (plugin.contains("/lib/plugin-" +
+		} else if (plugin.contains("/lib/plugin-" +
 			                   _ksPluginList[i], Qt::CaseInsensitive)) {
 			/*
 			 * The argument is the name of the library .so file.
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index 77048ab..019bde8 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -238,6 +238,7 @@ signals:
 
 private:
 	void _parsePluginList();
+	char *_pluginLibFromName(const QString &plugin, int &n);
 
 	template <class T>
 	void _forEachInList(const QStringList &pl,
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

