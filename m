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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA80C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 776E764E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhBKKjH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhBKKfv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:51 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB71C061222
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:42 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id f14so9257486ejc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GEWdWhfigjURshT9Ltb3Sznhioj3zu5UHyKnmx94g8E=;
        b=GhNL5Yn76/C3InCTSxcdkqRHxhx/KFfVmFViQjGTXqoddPjk2ct3pW2yuj6f7otUq7
         hhiGZJrBFj4oF97s7uijPTAItx1J6mU59SeY2oEcP4KjpshyYkJUYqrJVIYiDIp0CxXt
         W6IAFBoOVokvo5WjU6U0ijfL7YcZ29yYQJy3olNR9iDpDwFmgEuxloZ4OQed7TLW4A22
         U7X5h1pIxJ+tNBZfOfDiOtqSLHkAlOvuLn8j1rqI5AlkY/XLvuFljAR6nuhp2AkYF9q2
         i533e6eF0cU9qQa7MlCx+pwzeDzA+s2busLGUbWBv5fci1t5e96G56kbFPwgFcsEX3Mt
         Iqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GEWdWhfigjURshT9Ltb3Sznhioj3zu5UHyKnmx94g8E=;
        b=IIRpV2o+u6iQO83i09AS1yXZi1k5WzwuG2MuVOV6sYVjdBZ4Q3havE/nkr0NpZFl0j
         LyPThqKKy41/pg+oiNrAj8TNHoMIDWsoYvCAmdl/q2afRbX80Q9vS2wqOxAdPNZkbFU7
         Oj8252pEXsOqgsUnBz/cw02KFDH/hKe7qm7yW9qXknc05ta34Wr0j/vaXWLvNbRrhCb0
         iC1FRpfwuqcdaNc9fkdGhLK5SudPHSeQLACGGyx9haYNtGUoPuJsTTAN5JCH7bJ9YckZ
         ew4Do7dtY2WfPcMC0cTow7dUDw5Ffnq9LT7+NQcXPfLMWZD6asdLa8Qd1SB+cw0NQVVH
         M62A==
X-Gm-Message-State: AOAM5306SOJ4VdN1Vl+hT246iHyMLhYv7excaVktRlnLqvUmUKfW3CuJ
        cuabuEXKoRI14fylEI0WNrE=
X-Google-Smtp-Source: ABdhPJxTJKHJFY72gO0FC4+Xr/fA76q17w/iU8qsUr9HvlCep2v1xlGluR/IQdgxHKcuK7576TmQZA==
X-Received: by 2002:a17:906:6b1b:: with SMTP id q27mr7580880ejr.508.1613039560861;
        Thu, 11 Feb 2021 02:32:40 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:40 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 20/27] kernel-shark: Update KsCaptureDialog
Date:   Thu, 11 Feb 2021 12:31:58 +0200
Message-Id: <20210211103205.418588-21-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
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
index 6bb94d6..28f44fe 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -75,7 +75,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                         KsTraceGraph.hpp
                         KsTraceViewer.hpp
 #                         KsMainWindow.hpp
-#                         KsCaptureDialog.hpp
+                        KsCaptureDialog.hpp
                         KsQuickContextMenu.hpp
                         KsAdvFilteringDialog.hpp)
 
@@ -91,7 +91,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                                                             KsTraceGraph.cpp
                                                             KsTraceViewer.cpp
 #                                                             KsMainWindow.cpp
-#                                                             KsCaptureDialog.cpp
+                                                            KsCaptureDialog.cpp
                                                             KsQuickContextMenu.cpp
                                                             KsAdvFilteringDialog.cpp)
 
@@ -106,9 +106,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
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

