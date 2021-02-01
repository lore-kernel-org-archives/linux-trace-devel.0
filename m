Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC5AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D5F64EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhBARZ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhBARZ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:57 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4112C061353
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:32 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z22so19778553edb.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=48CjVMJ+YprkTj1657C7k0JWmWC+8YkY09KyKQtxctU=;
        b=g79PmIbGUFYv4kEQDAX38OnzMu77BSzYC6ehhOR8SvUxAXzvBxekIp3bUoRFry2Iju
         U0+yN3okiEkImnoPePoBCu0k4QilTeF/Uc23l/kzijXTdL3xP9TJIR2eC/gTNV/RE7jB
         Oye7U+ZCunq2NzBNwPB/BLZAvPKvjgBsIPqFyMFu+HJ7ve7wb1oJ+b7e97lwxIU58Z/E
         34eEsM5NgRu/GhhmIprsW/tvxII/dzwf4loVW2KqplzGi0nNAB5Sw/Z1AhQ1AVJ+o7HB
         QVljxlpFDc7mOq1i1hSl53oUV/ZqY42Md0067H5m4xyjnyoNJzVrsexGlIBkCK8zs8TZ
         fgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=48CjVMJ+YprkTj1657C7k0JWmWC+8YkY09KyKQtxctU=;
        b=tGwlQT8A55Zxg5D+E1Z2qZnM/i6luH13im4vGY5PnUGB2V7w2LQPfFYvKaGyI/uafO
         FlF7vtQB9//5pdGxo98nUnzwdB4/9UXTPnph+hFpUR70CA/DcQAVgubszZJgbigMw1tF
         dDaOS+Wi0wQA+Ue3OJfofPwmSEMz9lf2aPqpZn3lLt8dXN2hbkOK2zjkbp/4yrOwNO6p
         +5dfibJqHTPq59k4nczHyRSUh7geJyNI6aAnc6Jn2AW3+Y6SW+8QMkuLefqxmp/AKpZx
         t0R8aPa2Sl3q3pFWv7bzxuL+tthmeh205YVkyIV9p7/f02rrbB8N1iJNGxZBRds0Eq21
         UHhw==
X-Gm-Message-State: AOAM532qR5AaZCIU+oGA7lXw61HXUUIIxOtsR36KzKzVKPszBn22WCMT
        IRngMl5fc2z/VPpyhFMZzRM=
X-Google-Smtp-Source: ABdhPJwFD+XUUdqydZT29VzuyMqDf2B+NsoMTGUsyVfZRwT/pewkCUChUm6lYwyrcF2e42bHCt+Zcg==
X-Received: by 2002:aa7:c418:: with SMTP id j24mr7168132edq.293.1612200271507;
        Mon, 01 Feb 2021 09:24:31 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:30 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 19/24] kernel-shark: Update KsCaptureDialog
Date:   Mon,  1 Feb 2021 19:23:53 +0200
Message-Id: <20210201172358.175407-20-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of KsCaptureDialog.cpp and kshark-record.cpp is
re-enabled and all functionalities are made compatible with the new
version of the C API of libkshark (KernelShark 2.0).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt      | 10 ++---
 src/KsCaptureDialog.cpp | 90 ++++++++++++++++++++++-------------------
 src/KsCaptureDialog.hpp |  4 +-
 3 files changed, 56 insertions(+), 48 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index c1d98d8..c188849 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -75,7 +75,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                         KsTraceGraph.hpp
                         KsTraceViewer.hpp
 #                         KsMainWindow.hpp
-#                         KsCaptureDialog.hpp
+                        KsCaptureDialog.hpp
                         KsQuickContextMenu.hpp
                         KsAdvFilteringDialog.hpp)
 
@@ -91,7 +91,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsTraceGraph.cpp
                                                             KsTraceViewer.cpp
 #                                                             KsMainWindow.cpp
-#                                                             KsCaptureDialog.cpp
+                                                            KsCaptureDialog.cpp
                                                             KsQuickContextMenu.cpp
                                                             KsAdvFilteringDialog.cpp)
 
@@ -106,9 +106,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 #     add_executable(${KS_APP_NAME}          kernelshark.cpp)
 #     target_link_libraries(${KS_APP_NAME}   kshark-gui)
 
-#     message(STATUS "kshark-record")
-#     add_executable(kshark-record        kshark-record.cpp)
-#     target_link_libraries(kshark-record kshark-gui)
+    message(STATUS "kshark-record")
+    add_executable(kshark-record        kshark-record.cpp)
+    target_link_libraries(kshark-record kshark-gui)
 
 #     install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
 #             RUNTIME DESTINATION       ${_INSTALL_PREFIX}/bin/
diff --git a/src/KsCaptureDialog.cpp b/src/KsCaptureDialog.cpp
index 7253ab6..ca4c2bc 100644
--- a/src/KsCaptureDialog.cpp
+++ b/src/KsCaptureDialog.cpp
@@ -14,6 +14,7 @@
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-tepdata.h"
 #include "KsUtils.hpp"
 #include "KsCmakeDef.hpp"
 #include "KsCaptureDialog.hpp"
@@ -24,11 +25,6 @@ extern "C" {
   #include <sys/types.h>
 }
 
-static inline tep_handle *local_events()
-{
-	return tracefs_local_events(tracefs_tracing_dir());
-}
-
 /**
  * @brief Create KsCommandLineEdit.
  *
@@ -48,11 +44,28 @@ QSize KsCommandLineEdit::sizeHint() const
 	return {FONT_WIDTH * 30, FONT_HEIGHT * 3};
 }
 
+static kshark_data_stream *_initLocalStream()
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	int sd;
+
+	if (!kshark_instance(&kshark_ctx))
+		return nullptr;
+
+	sd = kshark_add_stream(kshark_ctx);
+	stream = kshark_ctx->stream[sd];
+
+	kshark_tep_init_local(stream);
+
+	return stream;
+}
+
 /** @brief Create KsCaptureControl widget. */
 KsCaptureControl::KsCaptureControl(QWidget *parent)
 : QWidget(parent),
-  _localTEP(local_events()),
-  _eventsWidget(_localTEP, this),
+  _stream(_initLocalStream()),
+  _eventsWidget(_stream),
   _pluginsLabel("Plugin: ", this),
   _outputLabel("Output file: ", this),
   _commandLabel("Command: ", this),
@@ -80,7 +93,7 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
 		_topLayout.addWidget(line);
 	};
 
-	if (pluginList.count() == 0 || !_localTEP) {
+	if (pluginList.count() == 0 || !kshark_get_tep(_stream)) {
 		/*
 		 * No plugins or events have been found. Most likely this is
 		 * because the process has no Root privileges or because
@@ -88,7 +101,7 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
 		 */
 		QString message("Error: No events or plugins found.\n");
 
-		if (!_localTEP)
+		if (!kshark_get_tep(_stream))
 			message += "Cannot find or mount tracing directory.\n";
 
 		// geteuid() returns 0 if running as effective id of root
@@ -202,23 +215,19 @@ QStringList KsCaptureControl::getArgs()
 QStringList KsCaptureControl::_getPlugins()
 {
 	QStringList pluginList;
-	char **all_plugins;
+	char **all_tracers;
 
-	all_plugins = tracefs_tracers(tracefs_tracing_dir());
+	all_tracers = kshark_tracecmd_local_plugins();
 
-	if (!all_plugins)
+	if (!all_tracers)
 		return pluginList;
 
-	for (int i = 0; all_plugins[i]; ++i) {
-		/*
-		 * TODO plugin selection here.
-		 * printf("plugin %i %s\n", i, all_plugins[i]);
-		 */
-		pluginList << all_plugins[i];
-		free(all_plugins[i]);
+	for (int i = 0; all_tracers[i]; ++i) {
+		pluginList << all_tracers[i];
+		free(all_tracers[i]);
 	}
 
-	free (all_plugins);
+	free(all_tracers);
 	std::sort(pluginList.begin(), pluginList.end());
 
 	return pluginList;
@@ -226,20 +235,17 @@ QStringList KsCaptureControl::_getPlugins()
 
 void KsCaptureControl::_importSettings()
 {
-	int nEvts = tep_get_events_count(_localTEP), nIds;
+	QVector<int> event_ids = _eventsWidget.getIds();
+	QVector<int> status(_stream->n_events, 0);
 	kshark_config_doc *conf, *jevents, *temp;
-	QVector<bool> v(nEvts, false);
-	tracecmd_filter_id *eventHash;
-	QVector<int> eventIds;
+	kshark_hash_id *eventHash;
 	QString fileName;
+	int nIds;
 
 	auto lamImportError = [this] () {
 		emit print("ERROR: Unable to load the configuration file.\n");
 	};
 
-	/** Get all available events. */
-	eventIds = KsUtils::getEventIdList(TEP_EVENT_SORT_SYSTEM);
-
 	/* Get the configuration document. */
 	fileName = KsUtils::getFile(this, "Import from Filter",
 				    "Kernel Shark Config files (*.json);;",
@@ -267,8 +273,9 @@ void KsCaptureControl::_importSettings()
 		return;
 	}
 
-	eventHash = tracecmd_filter_id_hash_alloc();
-	nIds = kshark_import_event_filter(_localTEP, eventHash, "Events", jevents);
+	eventHash = kshark_get_filter(_stream, KS_SHOW_EVENT_FILTER);
+	nIds = kshark_import_event_filter(_stream, KS_SHOW_EVENT_FILTER,
+					  "Events", jevents);
 	if (nIds < 0) {
 		QString err("WARNING: ");
 		err += "Some of the imported events are not available on this system.\n";
@@ -276,13 +283,12 @@ void KsCaptureControl::_importSettings()
 		emit print(err);
 	}
 
-	for (int i = 0; i < nEvts; ++i) {
-		if (tracecmd_filter_id_find(eventHash, eventIds[i]))
-			v[i] = true;
+	for (int i = 0; i < _stream->n_events; ++i) {
+		if (kshark_hash_id_find(eventHash, event_ids[i]))
+			status[i] = true;
 	}
 
-	_eventsWidget.set(v);
-	tracecmd_filter_id_hash_free(eventHash);
+	_eventsWidget.set(status);
 
 	/** Get all available plugins. */
 	temp = kshark_string_config_alloc();
@@ -294,9 +300,9 @@ void KsCaptureControl::_importSettings()
 		if (pluginIndex >= 0) {
 			_pluginsComboBox.setCurrentText(KS_C_STR_CAST(temp->conf_doc));
 		} else {
-			QString err("WARNING: The traceer plugin \"");
+			QString err("WARNING: The tracer plugin \"");
 			err += plugin;
-			err += "\" is not available on this machine\n";
+			err += "\" is not available on this machine!\n";
 			emit print(err);
 		}
 	}
@@ -329,18 +335,20 @@ void KsCaptureControl::_exportSettings()
 	events = kshark_filter_config_new(KS_CONFIG_JSON);
 
 	/*
-	 * Use the tracecmd_filter_id to save all selected events in the
+	 * Use the kshark_hash_id to save all selected events in the
 	 * configuration file.
 	 */
 	ids = _eventsWidget.getCheckedIds();
-	tracecmd_filter_id *eventHash = tracecmd_filter_id_hash_alloc();
+	kshark_hash_id *eventHash = kshark_get_filter(_stream,
+						      KS_SHOW_EVENT_FILTER);
+
 	for (auto const &id: ids)
-		tracecmd_filter_id_add(eventHash, id);
+		kshark_hash_id_add(eventHash, id);
 
-	kshark_export_event_filter(_localTEP, eventHash, "Events", events);
+	kshark_export_event_filter(_stream, KS_SHOW_EVENT_FILTER, "Events", events);
 	kshark_config_doc_add(conf, "Events", events);
 
-	tracecmd_filter_id_hash_free(eventHash);
+	kshark_hash_id_free(eventHash);
 
 	/* Save the plugin. */
 	plugin = _pluginsComboBox.currentText();
diff --git a/src/KsCaptureDialog.hpp b/src/KsCaptureDialog.hpp
index 3fd3d8d..0c85101 100644
--- a/src/KsCaptureDialog.hpp
+++ b/src/KsCaptureDialog.hpp
@@ -61,9 +61,9 @@ signals:
 	void print(const QString &message);
 
 private:
-	tep_handle		*_localTEP;
+	kshark_data_stream	*_stream;
 
-	KsEventsCheckBoxWidget	_eventsWidget;
+	KsWidgetsLib::KsEventsCheckBoxWidget	_eventsWidget;
 
 	QVBoxLayout	_topLayout;
 
-- 
2.25.1

