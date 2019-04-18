Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AEBC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B84720821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389056AbfDRPWr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36255 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731317AbfDRPWr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id y13so3464704wrd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/5rIGOhs7a/jPbr+IXa0qIZj5NDNRcRcUIxqrn/h1q8=;
        b=aU1Lauwhb4O/hOMxtGs2dNKcvDmD3zi/sNdKP54rbfmPIOE/Jl/mpPZRWF5wQWlhAs
         o5iNkC/SOTbenp+SBaWxGvDyRp7B4wafqkkjgWrnK2fsHSBk2/mVA1vhDy3P4Zg34M63
         jDnXP+F1nBUBEZGmJIdqvp6tFTLyBZlYAltXKoBZmRp9R4PqQuDT/+x2LdBfihNqX+IW
         dFybNBi4SG9UDuwOQIDDqfnFdyJoKgCvtkjKUfA3OCFLpn8GJLZ5OCWx60N+0Mjf0PMx
         7my18ekHTs2NuBDLWjiJYDlqBpwenPkU9q46MT93mDW5qQTuNxR+DXL80Hys9FVxc04M
         Pvpg==
X-Gm-Message-State: APjAAAU3IwREDIMJuW/M6ez2EKr4RlBz1MKQgl08bE9SWx1jOPrSoB1t
        dHVMeOudMnd3QkKrPGq0mPTOQS65
X-Google-Smtp-Source: APXvYqxXJK8bVqJFBHCcMIMiMqMH8SL1txG0Qd557JNmw0Y4BZEuah8MFYCteKHx6mDunETIYJUiag==
X-Received: by 2002:adf:ba49:: with SMTP id t9mr1934457wrg.146.1555600964871;
        Thu, 18 Apr 2019 08:22:44 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:44 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 4/8] kernel-shark: Add logic for the plugins search path
Date:   Thu, 18 Apr 2019 18:21:42 +0300
Message-Id: <20190418152146.27232-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
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
index 877c62a..85da9ae 100644
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
2.19.1

