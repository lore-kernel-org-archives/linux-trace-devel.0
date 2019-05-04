Return-Path: <SRS0=6G4v=TE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50DDC43219
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 13:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A7A20644
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 13:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfEDNHQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 4 May 2019 09:07:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32797 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEDNHQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 4 May 2019 09:07:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id e28so11275378wra.0
        for <linux-trace-devel@vger.kernel.org>; Sat, 04 May 2019 06:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=umEDmutCF5pi2/Wws4iRo0lTXpiFzOcDerbEKFuVe3M=;
        b=S7EpQpIs4jlgKLI8dvl/vTH1VYobI9Y3KGj+1O/YBfdIrhcpllmXt2wCtyOxuInktD
         ZapkfSCd5UcjVAJ8lTxQEoJ/KJgjXrCOW4CSMhTGG6SO5WZwaie05HDDvNikUXVANSME
         XVjsF2kPEmIoyiKTAWYbPPwuF/A86hMMtdYqXkcV6Isd5UGS3vyjbCPoEvx5V7Bn3ab+
         w6UGS0orTjDgTfUuD7BCuMQW9iaQ7o5iOPSqdBtxb/7ENDikA08vfFzR9aJlxq/nK7vM
         Ik/c5cAWhzvXn+hqfp8XFsEx8vixmHwAUmiCZWk+N+jZ5e8QfDcIi1UsknD7p3JcSBz4
         Ib9Q==
X-Gm-Message-State: APjAAAXogH3t00LYB8+UbgJ167d8zBIsolxZe96SJhOr9lq3TEX+4Vh8
        94Ngilz+KYVWz8bzVUS0gow=
X-Google-Smtp-Source: APXvYqwgkNN3ngwJkgd6aamPi9hAH3nNIeOdydnKIB4p5FDFj4l16e/Y1yoHTYrk+eADPMreLCDkHg==
X-Received: by 2002:a05:6000:ca:: with SMTP id q10mr3459795wrx.148.1556975233707;
        Sat, 04 May 2019 06:07:13 -0700 (PDT)
Received: from localhost.localdomain ([84.40.104.204])
        by smtp.gmail.com with ESMTPSA id z5sm8524891wre.70.2019.05.04.06.07.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:07:13 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v3 3/8] kernel-shark: Add logic for the plugins search path
Date:   Sat,  4 May 2019 16:07:02 +0300
Message-Id: <20190504130702.27755-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the application has not been started from its installation location
and the directory

 app_file_path + "../../kernel-shark/lib"

exists, all build-in plugins will be loaded from this directory. In any
other case all build-in plugins will be loaded from

_INSTALL_PREFIX/lib/kshark/plugins/

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsUtils.cpp            | 38 ++++++++++++++++++-------
 kernel-shark/src/KsUtils.hpp            |  2 ++
 kernel-shark/src/plugins/CMakeLists.txt |  2 +-
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 8c42206..3e88d96 100644
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
 
@@ -608,6 +606,26 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
 			lamUregUser);
 }
 
+char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
+{
+	QString appPath = QCoreApplication::applicationDirPath();
+	QString libPath = appPath + "/../../kernel-shark/lib";
+	std::string pluginStr = plugin.toStdString();
+	char *lib;
+
+	libPath = QDir::cleanPath(libPath);
+	if (!KsUtils::isInstalled() && QDir(libPath).exists()) {
+		std::string pathStr = libPath.toStdString();
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
@@ -629,8 +647,7 @@ void KsPluginManager::registerPlugin(const QString &plugin)
 			 * The argument is the name of the plugin. From the
 			 * name get the library .so file.
 			 */
-			n = asprintf(&lib, "%s/lib/plugin-%s.so",
-					KS_DIR, plugin.toStdString().c_str());
+			lib = _pluginLibFromName(plugin, n);
 			if (n > 0) {
 				kshark_register_plugin(kshark_ctx, lib);
 				_registeredKsPlugins[i] = true;
@@ -691,8 +708,7 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
 			 * The argument is the name of the plugin. From the
 			 * name get the library .so file.
 			 */
-			n = asprintf(&lib, "%s/lib/plugin-%s.so", KS_DIR,
-				     plugin.toStdString().c_str());
+			lib = _pluginLibFromName(plugin, n);
 			if (n > 0) {
 				kshark_unregister_plugin(kshark_ctx, lib);
 				_registeredKsPlugins[i] = false;
@@ -700,7 +716,7 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
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

